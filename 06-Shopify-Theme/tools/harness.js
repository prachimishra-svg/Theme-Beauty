/* Local Shopify-style Liquid renderer for verification (runs in headless Chrome, driven by tools/render-theme.ps1).
   It is NOT Shopify: it uses LiquidJS plus stand-ins for the Shopify tags, filters and objects the theme uses. Differences from Shopify are possible,
   so this proves the theme's Liquid parses, renders and produces the approved DOM; it does not replace Shopify's Theme Check or a store.
   Inputs (set by the driver before this file runs): window.BUNDLE = { files: { "sections/x.liquid": "..." }, assets: ["theme.css", ...], data: {...sample objects...},
   options: { template: "index", play: false, designMode: false, settingsOverride: {} } }.  Output: textarea#out. */
(function () {
  'use strict';
  var B = window.BUNDLE, F = B.files, O = B.options || {}, D = B.data || {};
  var Liquid = window.liquidjs.Liquid, Hash = window.liquidjs.Hash, Value = window.liquidjs.Value;
  var errors = [];
  function note(m) { errors.push(m); }

  /* ---------- virtual file system for LiquidJS (snippets resolved from "snippets/") ---------- */
  var fs = {
    sep: '/',
    resolve: function (root, file, ext) { return root.replace(/\/$/, '') + '/' + file + (/\.[a-z]+$/.test(file) ? '' : ext); },
    exists: function (p) { return Promise.resolve(p in F); }, existsSync: function (p) { return p in F; },
    readFile: function (p) { return p in F ? Promise.resolve(F[p]) : Promise.reject(new Error('ENOENT: ' + p)); },
    readFileSync: function (p) { if (p in F) return F[p]; throw new Error('ENOENT: ' + p); },
    contains: function () { return true; }, dirname: function (p) { return p.replace(/\/[^\/]*$/, ''); },
    fallback: function () { return undefined; }
  };

  /* ---------- locale + settings ---------- */
  var locale = JSON.parse(F['locales/en.default.json'] || '{}');
  function lookup(obj, key) { return key.split('.').reduce(function (o, k) { return o && o[k] !== undefined ? o[k] : undefined; }, obj); }
  function schemaOf(src) {
    var m = /\{%-?\s*schema\s*-?%\}([\s\S]*?)\{%-?\s*endschema\s*-?%\}/.exec(src); if (!m) return null;
    try { return JSON.parse(m[1]); } catch (e) { note('schema JSON error: ' + e.message); return null; }
  }
  function defaultsOf(settings) {
    var o = {}; (settings || []).forEach(function (s) {
      if (!s.id) return;
      if (s.default !== undefined) o[s.id] = s.default;
      else if (s.type === 'checkbox') o[s.id] = false;
      else if (/^(image_picker|collection|product|blog|page|link_list|article|video|url)$/.test(s.type)) o[s.id] = null;
      else if (/^(text|textarea|richtext|html|liquid|inline_richtext|color|font_picker|number|range)$/.test(s.type)) o[s.id] = (s.type === 'number' || s.type === 'range') ? 0 : '';
      else o[s.id] = '';
    }); return o;
  }
  var themeSchema = JSON.parse(F['config/settings_schema.json'] || '[]'), themeData = JSON.parse(F['config/settings_data.json'] || '{"current":{}}');
  var settings = {};
  themeSchema.forEach(function (g) { Object.assign(settings, defaultsOf(g.settings)); });
  Object.assign(settings, (themeData.current && typeof themeData.current === 'object') ? themeData.current : {}, O.settingsOverride || {});

  /* ---------- Shopify-like objects ---------- */
  function resource(kind, v) { return v; }
  var linklists = D.linklists || {};
  var ctxBase = {
    settings: settings, shop: D.shop || { name: 'NUDGE Beauty', url: 'https://example.myshopify.com', enabled_payment_types: ['visa', 'master', 'american_express'], currency: 'USD' },
    request: { path: '/', locale: { iso_code: 'en', root_url: '' }, design_mode: !!O.designMode, page_type: O.template || 'index', host: 'example.myshopify.com' },
    routes: { root_url: '/', cart_url: '/cart', cart_add_url: '/cart/add', cart_change_url: '/cart/change', cart_update_url: '/cart/update', cart_clear_url: '/cart/clear', account_url: '/account', account_login_url: '/account/login', account_register_url: '/account/register', search_url: '/search', all_products_collection_url: '/collections/all', predictive_search_url: '/search/suggest', localization_url: '/localization', collections_url: '/collections' },
    linklists: linklists, cart: D.cart || { item_count: 0, items: [], total_price: 0, currency: { iso_code: 'USD' } },
    localization: D.localization || { available_countries: [{ iso_code: 'US', name: 'United States', currency: { iso_code: 'USD', symbol: '$' }, market: { handle: 'us' } }], country: { iso_code: 'US', name: 'United States', currency: { iso_code: 'USD', symbol: '$' } }, language: { iso_code: 'en' } },
    customer: null, page_title: 'NUDGE Beauty Theme', canonical_url: 'https://example.myshopify.com/', template: O.template || 'index', collections: D.collections || {}, all_products: D.products || {}, products: D.products || {},
    content_for_header: '<!-- content_for_header -->', page_description: '', current_page: 1, powered_by_link: ''
  };

  /* ---------- engine ---------- */
  var globalsForSnippets = {}; Object.keys(ctxBase).forEach(function (k) { if (k !== 'content_for_layout' && k !== 'content_for_header') globalsForSnippets[k] = ctxBase[k]; });
  var engine = new Liquid({ fs: fs, root: [''], partials: ['snippets'], extname: '.liquid', strictFilters: false, strictVariables: false, jsTruthy: false, ownPropertyOnly: false, greedy: true, globals: globalsForSnippets });

  /* LiquidJS passes keyword filter arguments (image_url: width: 480) as [key, value] pairs; Shopify passes one hash. Normalise. */
  function kwargs(args) { var o = {}; [].slice.call(args).forEach(function (a) { if (Array.isArray(a) && a.length === 2 && typeof a[0] === 'string') o[a[0]] = a[1]; else if (a && typeof a === 'object' && !Array.isArray(a)) Object.assign(o, a); }); return o; }  function esc(s) { return String(s).replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }
  /* Shopify integer division: divided_by on two integers floors, LiquidJS returns a float */
  engine.registerFilter('divided_by', function (a, b, intOnly) { a = Number(a); b = Number(b); if (!b) throw new Error('divided by 0'); return (Number.isInteger(a) && Number.isInteger(b)) ? Math.floor(a / b) : a / b; });
  engine.registerFilter('asset_url', function (n) { if (B.assets.indexOf(n) < 0) note('asset_url: missing asset ' + n); return '/assets/' + n; });
  engine.registerFilter('stylesheet_tag', function (u) { return '<link href="' + u + '" rel="stylesheet" type="text/css" media="all">'; });
  engine.registerFilter('script_tag', function (u) { return '<script src="' + u + '"><\/script>'; });
  engine.registerFilter('t', function (key) {
    var vars = kwargs([].slice.call(arguments, 1));
    var v = lookup(locale, String(key)); if (v === undefined) { note('translation missing: ' + key); return 'translation missing: ' + key; }
    if (v && typeof v === 'object') { if (vars.count === undefined) { note('translation needs count: ' + key); return 'translation missing: ' + key; } v = vars.count === 1 ? v.one : v.other; }
    return String(v).replace(/\{\{\s*(\w+)\s*\}\}/g, function (m, k) { return vars[k] !== undefined ? vars[k] : m; });
  });
  engine.registerFilter('money', function (c) { return '$' + (Number(c) / 100).toFixed(2); });
  engine.registerFilter('money_without_currency', function (c) { return (Number(c) / 100).toFixed(2); });
  engine.registerFilter('money_with_currency', function (c) { return '$' + (Number(c) / 100).toFixed(2) + ' USD'; });
  engine.registerFilter('handleize', function (s) { return String(s).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, ''); });
  engine.registerFilter('handle', function (s) { return String(s).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, ''); });
  engine.registerFilter('image_url', function (img) { var opts = kwargs([].slice.call(arguments, 1)); if (!img) return ''; var w = opts && opts.width ? opts.width : 'auto'; return (img.src || ('https://cdn.example/' + (img.id || 'image') + '.jpg')) + '?width=' + w; });
  engine.registerFilter('image_tag', function (url) {
    var opts = kwargs([].slice.call(arguments, 1)); if (!url) return ''; var a = ''; if (opts) Object.keys(opts).forEach(function (k) { if (k === 'width' || k === 'height' || k === 'widths' || k === 'sizes') { if (k === 'width' || k === 'height' || k === 'sizes') a += ' ' + k + '="' + esc(opts[k]) + '"'; } else a += ' ' + k.replace(/_/g, '-') + '="' + esc(opts[k]) + '"'; });
    return '<img src="' + url + '"' + (a.indexOf(' alt=') < 0 ? ' alt=""' : '') + a + '>';
  });
  engine.registerFilter('placeholder_svg_tag', function (n, c) { return '<svg class="' + (c || '') + '" data-placeholder="' + esc(n) + '"></svg>'; });
  engine.registerFilter('link_to', function (txt, url) { return '<a href="' + url + '">' + txt + '</a>'; });
  engine.registerFilter('escape_once', function (s) { return String(s).replace(/&(?!(?:amp|lt|gt|quot|#\d+);)/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); });
  engine.registerFilter('structured_data', function (o) { return JSON.stringify(o || {}); });
  engine.registerFilter('within', function (p) { return p; });
  engine.registerFilter('payment_type_svg_tag', function (t, c) { return '<svg class="' + (c ? (c.class || '') : '') + '" data-payment="' + esc(t) + '"></svg>'; });
  engine.registerFilter('file_url', function (n) { return '/files/' + n; });
  engine.registerFilter('plus_a', function (a) { return a; });

  /* schema / stylesheet / javascript: swallowed (blocks) */
  function swallow(name) {
    engine.registerTag(name, { parse: function (tagToken, tokens) { var end = 'end' + name; var stream = this.liquid.parser.parseStream(tokens); stream.on('template', function () { }).on('tag:' + end, function () { stream.stop(); }).on('end', function () { throw new Error(name + ' not closed'); }); stream.start(); }, render: function () { return ''; } });
  }
  swallow('schema'); swallow('javascript'); swallow('stylesheet');
  /* style: render body inside <style data-shopify> */
  engine.registerTag('style', { parse: function (tagToken, tokens) { var self = this; this.tpls = []; var stream = this.liquid.parser.parseStream(tokens); stream.on('template', function (t) { self.tpls.push(t); }).on('tag:endstyle', function () { stream.stop(); }).on('end', function () { throw new Error('style not closed'); }); stream.start(); },
    render: function* (ctx, emitter) { emitter.write('<style data-shopify>'); yield this.liquid.renderer.renderTemplates(this.tpls, ctx, emitter); emitter.write('</style>'); } });
  /* form: <form ...> + body + </form>, with a `form` object in scope */
  engine.registerTag('form', { parse: function (tagToken, tokens) { var self = this; this.tpls = []; var fm = /^\s*['"]?([\w.-]+)['"]?\s*(?:,\s*([\s\S]*))?$/.exec(tagToken.args) || []; this.type = fm[1] || 'form'; this.hash = new Hash(fm[2] || '');
      var stream = this.liquid.parser.parseStream(tokens); stream.on('template', function (t) { self.tpls.push(t); }).on('tag:endform', function () { stream.stop(); }).on('end', function () { throw new Error('form not closed'); }); stream.start(); },
    render: function* (ctx, emitter) { var type = this.type; var h = yield this.hash.render(ctx);
      var action = { localization: '/localization', customer: '/contact#newsletter', cart: '/cart', product: '/cart/add', contact: '/contact#contact_form', localization_form: '/localization' }[type] || '/'; var attrs = ' method="post" action="' + action + '" accept-charset="UTF-8"'; if (h && h.id) attrs += ' id="' + esc(h.id) + '"'; if (h && h.class) attrs += ' class="' + esc(h.class) + '"'; if (h && h.novalidate) attrs += ' novalidate="novalidate"';
      emitter.write('<form' + attrs + '><input type="hidden" name="form_type" value="' + esc(type) + '"><input type="hidden" name="utf8" value="✓">');
      ctx.push({ form: { errors: null, 'posted_successfully?': false } }); yield this.liquid.renderer.renderTemplates(this.tpls, ctx, emitter); ctx.pop(); emitter.write('</form>'); } });

  function resolveSettings(defs, vals) {
    (defs || []).forEach(function (s) {
      if (!s.id) return; var v = vals[s.id];
      if (s.type === 'link_list') vals[s.id] = (typeof v === 'string' && linklists[v]) ? linklists[v] : ((v && typeof v === 'object') ? v : null);
      else if (s.type === 'collection') vals[s.id] = (typeof v === 'string' && D.collections && D.collections[v]) ? D.collections[v] : ((v && typeof v === 'object') ? v : null);
      else if (s.type === 'product') vals[s.id] = (typeof v === 'string' && D.products && D.products[v]) ? D.products[v] : ((v && typeof v === 'object') ? v : null);
      else if (s.type === 'video_url') { var ym = typeof v === 'string' && /(?:youtube\.com\/watch\?v=|youtu\.be\/)([\w-]{6,})/.exec(v), vm = typeof v === 'string' && /vimeo\.com\/(\d+)/.exec(v); vals[s.id] = ym ? { type: 'youtube', id: ym[1] } : (vm ? { type: 'vimeo', id: vm[1] } : null); }
      else if (s.type === 'image_picker') vals[s.id] = (typeof v === 'string' && v) ? { src: v, alt: '', id: v } : ((v && typeof v === 'object') ? v : null);
    }); return vals;
  }  /* section / sections */
  function mkSection(type, id, inst) {
    var src = F['sections/' + type + '.liquid']; if (src === undefined) { note('missing section file: sections/' + type + '.liquid'); return null; }
    var sc = schemaOf(src) || {}; inst = inst || {};
    var sset = resolveSettings(sc.settings, Object.assign(defaultsOf(sc.settings), inst.settings || {}));
    var blocks = [], order = inst.block_order || Object.keys(inst.blocks || {});
    if (inst.blocks) order.forEach(function (bid) { var b = inst.blocks[bid]; if (!b) return; var bs = ((sc.blocks || []).filter(function (x) { return x.type === b.type; })[0]) || {}; blocks.push({ id: bid, type: b.type, settings: resolveSettings(bs.settings, Object.assign(defaultsOf(bs.settings), b.settings || {})), shopify_attributes: '' }); });
    return { id: id, type: type, settings: sset, blocks: blocks, block_order: blocks.map(function (b) { return b.id; }), index: 1, location: 'template', shopify_attributes: '' };
  }
  function* renderSectionObj(self, ctx, emitter, sec, group) {
    if (!sec) return;
    var cls = 'shopify-section' + (group ? ' shopify-section-group-' + group : '');
    emitter.write('<div id="shopify-section-' + sec.id + '" class="' + cls + '">');
    ctx.push({ section: sec }); var tpls = self.liquid.parse(F['sections/' + sec.type + '.liquid']); yield self.liquid.renderer.renderTemplates(tpls, ctx, emitter); ctx.pop();
    emitter.write('</div>');
  }
  engine.registerTag('section', { parse: function (tagToken) { this.name = new Value(tagToken.args, this.liquid); },
    render: function* (ctx, emitter) { var n = yield this.name.value(ctx); var st = (O.staticSections && O.staticSections[n]) ? { settings: O.staticSections[n] } : null; yield* renderSectionObj(this, ctx, emitter, mkSection(n, n, st), null); } });
  engine.registerTag('sections', { parse: function (tagToken) { this.name = new Value(tagToken.args, this.liquid); },
    render: function* (ctx, emitter) { var n = yield this.name.value(ctx); var raw = F['sections/' + n + '.json']; if (raw === undefined) { note('missing section group: sections/' + n + '.json'); return; }
      var g = JSON.parse(raw);
      for (var i = 0; i < (g.order || []).length; i++) { var id = g.order[i], inst = g.sections[id]; yield* renderSectionObj(this, ctx, emitter, mkSection(inst.type, id, inst), n); } } });

  /* template: JSON (sections in order) or liquid */
  var out = '', t0 = Date.now();
  var tplJson = F['templates/' + (O.template || 'index') + '.json'];
  var layout = F['layout/theme.liquid'];
  var content = '';
  var pre = (async function () {
    var ctx = Object.assign({}, ctxBase);
    if (tplJson !== undefined) {
      var j = JSON.parse(tplJson), html = '';
      var order = j.order || [];
      for (var i = 0; i < order.length; i++) { var id = order[i], inst = j.sections[id], sec = mkSection(inst.type, id, inst); if (!sec) continue;
        var tpl = engine.parse(F['sections/' + sec.type + '.liquid']);
        var body = await engine.render(tpl, Object.assign({}, ctx, { section: sec }));
        html += '<div id="shopify-section-' + id + '" class="shopify-section">' + body + '</div>'; }
      ctx.content_for_layout = html;
    } else { var tplL = F['templates/' + (O.template || 'index') + '.liquid']; ctx.content_for_layout = tplL ? await engine.parseAndRender(tplL, ctx) : ''; }
    return engine.parseAndRender(layout, ctx);
  })();
  pre.then(function (h) { finish(h); }).catch(function (e) { note('RENDER ERROR: ' + (e && e.message ? e.message : e)); finish(''); });
  function finish(html) { var ta = document.getElementById('out'); ta.textContent = JSON.stringify({ html: html, errors: errors, ms: Date.now() - t0 }); document.title = 'done'; }
})();
