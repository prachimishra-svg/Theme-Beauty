/* Review dashboard for a PROPOSED Figma specification (not a Figma file, not a Figma Variables panel).
   Data: window.FIGMA_SPEC (preview-data.js, generated from the specification files) and window.FIGMA_VALIDATION (validation-data.js, written by the validator).
   This script holds no colour, size or token value of its own; it renders what the data says and reports what is missing. */
(function () {
  'use strict';
  var S = window.FIGMA_SPEC, V = window.FIGMA_VALIDATION || null;
  var app = document.getElementById('app');
  if (!S) { app.textContent = 'preview-data.js did not load. Run 01-Design-System/Figma-Specification/build-figma-docs.ps1 and reload.'; return; }
  var BY = {}, COLL = {}, STYLE = {}, COMP = {};
  S.variables.forEach(function (v) { BY[v.name] = v; }); S.collections.forEach(function (c) { COLL[c.name] = c; }); S.textStyles.forEach(function (t) { STYLE[t.name] = t; }); S.components.forEach(function (c) { COMP[c.id] = c; });
  var st = { sem: COLL.Semantic.defaultMode, layout: COLL.Layout.defaultMode, type: COLL.Typography.defaultMode, f: { color: { q: '', group: 'all' }, sem: { q: '', group: 'all', diff: false }, vb: { q: '', coll: 'all', type: 'all', layer: 'all', rel: 'all' }, map: { q: '', cat: 'all' } }, pg: { props: null, vcomp: S.components[0].id } };
  var $ = function (id) { return document.getElementById(id); };
  function h(tag, attrs, kids) {
    var e = document.createElement(tag);
    Object.keys(attrs || {}).forEach(function (k) { if (k === 'style') e.style.cssText = attrs[k]; else if (k === 'text') e.textContent = attrs[k]; else if (k === 'onclick') e.addEventListener('click', attrs[k]); else if (attrs[k] !== null && attrs[k] !== undefined) e.setAttribute(k, attrs[k]); });
    (kids || []).forEach(function (c) { if (c !== null && c !== undefined && c !== false) e.appendChild(typeof c === 'string' || typeof c === 'number' ? document.createTextNode(String(c)) : c); });
    return e;
  }
  function modeFor(coll) { return coll === 'Semantic' ? st.sem : coll === 'Layout' ? st.layout : coll === 'Typography' ? st.type : 'Value'; }
  function entry(name, mode) { var v = BY[name]; if (!v) return null; var m = mode || modeFor(v.collection); return v.values[m] || v.values[Object.keys(v.values)[0]]; }
  function val(name, mode) { var e = entry(name, mode); return e ? e.resolved : undefined; }
  function hexA(hex, alpha) { var x = String(hex).replace('#', ''); var a = alpha === undefined ? (x.length === 8 ? parseInt(x.slice(6, 8), 16) / 255 : 1) : alpha; return 'rgb(' + parseInt(x.slice(0, 2), 16) + ' ' + parseInt(x.slice(2, 4), 16) + ' ' + parseInt(x.slice(4, 6), 16) + ' / ' + Math.round(a * 1000) / 1000 + ')'; }
  function chain(name, mode) {
    var out = [], cur = name, m = mode, guard = 0;
    while (cur && guard++ < 8) { var v = BY[cur]; if (!v) { out.push({ name: cur, missing: true }); break; } var mm = v.values[m] ? m : Object.keys(v.values)[0]; var e = v.values[mm]; out.push({ name: cur, mode: mm, resolved: e.resolved, alias: e.alias }); cur = e.alias; m = mm; }
    return out;
  }
  function valueNode(v, mode) {
    var e = v.values[mode]; var t = v.type === 'COLOR' ? [h('span', { style: 'display:inline-block;width:14px;height:14px;border:1px solid var(--c-border-subtle);border-radius:3px;vertical-align:-2px;margin-right:8px;background:' + e.resolved })] : [];
    var n = h('span', { 'data-var': v.name, 'data-mode': mode, 'data-value': String(e.resolved) }, t.concat([String(e.resolved)]));
    return h('span', {}, [n, e.alias ? h('span', { style: 'display:block;font-size:12px;color:var(--c-muted)', text: '= ' + e.alias }) : null]);
  }
  function table(head, rows, opts) {
    opts = opts || {};
    var tb = h('tbody', {}, rows.map(function (r) {
      var tr = h('tr', opts.click ? { class: 'row-btn', tabindex: '0', role: 'button', 'data-row': r.key } : {}, r.cells.map(function (c) { return h('td', c && c.nodeType ? {} : { text: c === null || c === undefined ? '' : String(c) }, c && c.nodeType ? [c] : []); }));
      if (opts.click) { tr.addEventListener('click', function () { opts.click(r.key); }); tr.addEventListener('keydown', function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); opts.click(r.key); } }); }
      return tr;
    }));
    return h('div', { class: 'scroll' }, [h('table', {}, [h('thead', {}, [h('tr', {}, head.map(function (x) { return h('th', { scope: 'col', text: x }); }))]), tb])]);
  }
  function pill(text, kind) { return h('span', { class: 'status ' + (kind || ''), text: text }); }
  function sec(id, n, title, lede, kids) { return h('section', { class: 'sec', id: 's-' + id, 'aria-labelledby': 'h-' + id }, [h('p', { class: 'eyebrow', text: String(n).padStart(2, '0') + ' / 12' }), h('h2', { id: 'h-' + id, text: title }), lede ? h('p', { class: 'lede', text: lede }) : null].concat(kids)); }
  function empty(msg) { return h('div', { class: 'empty', text: msg }); }
  function select(label, opts, value, on) { var s = h('select', {}, opts.map(function (o) { var v = typeof o === 'string' ? o : o[0], t = typeof o === 'string' ? o : o[1]; return h('option', { value: v, text: t }); })); s.value = value; s.addEventListener('change', function () { on(s.value); }); return h('label', {}, [label, s]); }
  function searchBox(label, value, on) { var i = h('input', { type: 'search', placeholder: 'type to filter' }); i.value = value; i.addEventListener('input', function () { on(i.value); }); return h('label', {}, [label, i]); }
  function sizeOf(arr, fn) { return arr.reduce(function (a, c) { return a + fn(c); }, 0); }
  function variantCount(c) { var n = 1; c.properties.forEach(function (p) { if (p.type === 'VARIANT') n *= p.values.length; }); return n; }

  /* ---- theme: the dashboard chrome is built from the specification's own Semantic Default values ---- */
  function applyTheme() {
    var r = document.documentElement.style, set = function (k, n, m) { var x = val(n, m); if (x !== undefined) r.setProperty(k, typeof x === 'number' ? x + 'px' : x); };
    [['--c-bg', 'color/bg/page'], ['--c-surface', 'color/bg/surface'], ['--c-subtle', 'color/bg/subtle'], ['--c-text', 'color/text/primary'], ['--c-text2', 'color/text/secondary'], ['--c-muted', 'color/text/muted'], ['--c-border', 'color/border/strong'], ['--c-border-subtle', 'color/border/subtle'], ['--c-accent', 'color/brand/primary'], ['--c-accent-hover', 'color/brand/primary-hover'], ['--c-on-accent', 'color/text/on-brand'], ['--c-tint', 'color/brand/tint'], ['--c-focus', 'color/focus/ring'], ['--c-error', 'color/status/error'], ['--c-success', 'color/status/success'], ['--c-warning', 'color/status/warning']].forEach(function (p) { set(p[0], p[1], 'Default'); });
    [['--r-sm', 'radius/sm'], ['--r-md', 'radius/md'], ['--r-lg', 'radius/lg'], ['--touch', 'touch-target/min'], ['--ring', 'focus/ring-width'], ['--ring-offset', 'focus/ring-offset']].forEach(function (p) { set(p[0], p[1], 'Value'); });
    [1, 2, 3, 4, 5, 6, 8, 10, 12, 16].forEach(function (n) { set('--s-' + n, 'space/' + n, 'Value'); });
    var hf = val('font/family/heading', 'Value'), bf = val('font/family/body', 'Value');
    if (hf) r.setProperty('--f-head', '"' + hf + '", Georgia, serif'); if (bf) r.setProperty('--f-body', '"' + bf + '", system-ui, sans-serif');
  }

  /* ---- context for the component renderers ---- */
  function textCss(styleName) {
    var s = STYLE[styleName]; if (!s) return '';
    var fam = s.fontFamily === val('font/family/heading', 'Value') ? '"' + s.fontFamily + '", Georgia, serif' : '"' + s.fontFamily + '", system-ui, sans-serif';
    return 'font-family:' + fam + ';font-size:' + s.fontSizePx[st.type] + 'px;font-weight:' + s.fontWeight + ';line-height:' + (s.lineHeightPercent / 100) + ';letter-spacing:' + (s.letterSpacingPercent / 100) + 'em;' + (s.textCase === 'UPPER' ? 'text-transform:uppercase;' : '');
  }
  VRender.init({ components: S.components, has: function (n) { return !!BY[n]; }, col: function (n) { return String(val(n)); }, num: function (n) { var x = val(n); return typeof x === 'number' ? x : NaN; }, numMode: function (n, m) { var x = val(n, m); return typeof x === 'number' ? x : 0; }, css: textCss });
  function showRender(c, props, label) {
    var r = VRender.render(c, props);
    var wrap = h('div', { class: 'cell' }, [h('div', { style: 'background:' + String(val('color/bg/page')) + ';color:' + String(val('color/text/primary')) + ';padding:12px;border-radius:6px' }, [r.node || h('span', { class: 'miss', text: 'No preview drawing for this component' })]), label ? h('span', { class: 'lbl', text: label }) : null]);
    if (r.missing.length) wrap.appendChild(h('span', { class: 'miss', text: 'Missing variable(s): ' + r.missing.join(', ') }));
    return wrap;
  }

  /* ---- fonts ---- */
  var fontInfo = {};
  function fontsRendering(family) { try { var cx = document.createElement('canvas').getContext('2d'), t = 'mmmmmmmmmmlliWW', w = function (f) { cx.font = '64px ' + f; return cx.measureText(t).width; }; return w('"' + family + '", monospace') !== w('monospace') || w('"' + family + '", serif') !== w('serif'); } catch (e) { return false; } }
  function checkFonts() {
    var fams = [val('font/family/heading', 'Value'), val('font/family/body', 'Value')].filter(Boolean);
    var jobs = fams.map(function (f) { return (document.fonts && document.fonts.load ? document.fonts.load('500 20px "' + f + '"') : Promise.resolve([])).then(function (faces) { fontInfo[f] = { faces: faces.length, rendering: fontsRendering(f) }; }, function () { fontInfo[f] = { faces: 0, rendering: fontsRendering(f), error: true }; }); });
    return Promise.all(jobs).then(updateFontBadges);
  }
  function fontLabel(f) { var i = fontInfo[f]; if (!i) return ['Checking...', 'info']; if (i.rendering) return ['Rendering with ' + f, 'ok']; return ['FALLBACK in use: ' + f + ' did not load, so specimens use a system font', 'bad']; }
  function updateFontBadges() { document.querySelectorAll('[data-font]').forEach(function (n) { var l = fontLabel(n.getAttribute('data-font')); n.textContent = l[0]; n.className = 'status ' + l[1]; }); }

  /* ================= sections ================= */
  function secOverview() {
    var types = {}; S.variables.forEach(function (v) { types[v.type] = (types[v.type] || 0) + 1; });
    var modes = {}; S.collections.forEach(function (c) { if (c.modes.length > 1) c.modes.forEach(function (m) { modes[m] = 1; }); });
    var variants = sizeOf(S.components, variantCount), prov = S.components.filter(function (c) { return c.status === 'provisional'; }), vs = validationState();
    var stat = function (n, label, sub) { return h('div', { class: 'stat' }, [h('b', { text: String(n) }), h('span', { text: label }), sub ? h('small', { text: sub }) : null]); };
    return sec('overview', 1, 'NUDGE: Figma-native system (proposal)', 'A Figma-specific specification of the NUDGE design variables and components for a premium beauty and skincare brand, kept separate from the web system so the two can be compared. Every figure on this page is computed from the specification data loaded by this page.', [
      h('div', { class: 'banner warn' }, [pill('Not a Figma file', 'warn'), h('p', { text: 'Nothing in this system has been created in Figma. This dashboard is a browser preview of a proposed specification. The controls on this page are browser-preview interactions, not Figma features.' })]),
      h('div', { class: 'banner ' + vs.kind }, [pill(vs.label, vs.kind), h('p', { text: vs.detail })]),
      h('div', { class: 'grid stats' }, [stat(S.collections.length, 'collections', S.collections.map(function (c) { return c.name; }).join(', ')), stat(S.variables.length, 'variables', Object.keys(types).map(function (t) { return t + ' ' + types[t]; }).join(', ')), stat(S.textStyles.length, 'text styles'), stat(S.gridStyles.length + S.effectStyles.length, 'grid and effect styles', S.gridStyles.length + ' grid, ' + S.effectStyles.length + ' effect'), stat(S.components.length, 'components', S.patterns.length + ' patterns'), stat(variants, 'component variants', 'sum of each component\'s variant axes'), stat(Object.keys(modes).length, 'switchable modes', Object.keys(modes).join(', ') + '; Primitives and Components have a single mode'), stat(S.webMapping.length, 'web tokens classified', Object.keys(S.mappingSummary.categories).map(function (k) { return k + ' ' + S.mappingSummary.categories[k]; }).join(', '))]),
      h('h3', { text: 'Collections' }),
      table(['Collection', 'Modes', 'Variables', 'Purpose'], S.collections.map(function (c) { return { key: c.name, cells: [c.name, c.modes.join(', '), S.variables.filter(function (v) { return v.collection === c.name; }).length, c.purpose] }; })),
      h('h3', { text: 'Provisional, unverified and missing decisions' }),
      h('p', { class: 'note', text: S.provisionalDecisions.length + ' decisions are provisional, approximate, unverified or not done; ' + prov.length + ' components are marked provisional (' + prov.map(function (c) { return c.name; }).join(', ') + '); ' + S.pendingItems.length + ' items are not defined. Details are in section 12.' }),
      table(['Decision', 'Status', 'Why'], S.provisionalDecisions.map(function (d) { return { key: d.id, cells: [d.title, pill(d.status, d.status === 'Provisional' || d.status === 'Approximation' ? 'warn' : 'info'), d.reason] }; })),
      h('p', { class: 'note', text: 'Display fonts for this page are borrowed read-only from the web system\'s 05-Assets/Fonts folder so the specimens look right; Figma itself uses its own font library.' })
    ]);
  }
  function groupOf(name, idx) { return name.split('/')[idx] || ''; }
  function swatch(v, mode) {
    var e = v.values[mode], b = h('button', { type: 'button', class: 'sw', 'aria-label': v.name + ' ' + e.resolved + ', open details', 'data-var': v.name, 'data-mode': mode, 'data-value': String(e.resolved) }, [h('div', { class: 'chip checker' }, [h('div', { style: 'height:100%;background:' + e.resolved })]), h('div', { class: 'meta' }, [h('b', { text: v.name }), h('span', { text: e.resolved }), h('span', { text: v.collection + ' | ' + v.type + (e.alias ? ' | alias ' + e.alias : ' | literal') }), v.description ? h('span', { text: v.description }) : null])]);
    b.addEventListener('click', function () { openPanel(v.name); }); return b;
  }
  function secColors() {
    var list = h('div', { class: 'grid swgrid', id: 'color-list' }), count = h('span', { class: 'count' });
    var prims = S.variables.filter(function (v) { return v.collection === 'Primitives' && v.type === 'COLOR'; }), groups = ['all'].concat(Object.keys(prims.reduce(function (a, v) { a[groupOf(v.name, 1) || groupOf(v.name, 0)] = 1; return a; }, {})));
    function draw() { var f = st.f.color, q = f.q.toLowerCase(); var items = prims.filter(function (v) { var g = groupOf(v.name, 1) || groupOf(v.name, 0); return (f.group === 'all' || g === f.group) && (!q || (v.name + ' ' + v.description + ' ' + v.values.Value.resolved).toLowerCase().indexOf(q) >= 0); }); list.textContent = ''; items.forEach(function (v) { list.appendChild(swatch(v, 'Value')); }); if (!items.length) list.appendChild(empty('No colour variable matches the filter.')); count.textContent = items.length + ' of ' + prims.length + ' colours'; }
    var flt = h('div', { class: 'filters' }, [searchBox('Search name, usage or value', st.f.color.q, function (x) { st.f.color.q = x; draw(); }), select('Palette group', groups.map(function (g) { return [g, g === 'all' ? 'All groups' : g]; }), st.f.color.group, function (x) { st.f.color.group = x; draw(); }), count]);
    var s = sec('colors', 2, 'Color Variables', 'The ' + prims.length + ' colour primitives (collection Primitives, mode Value). They are hidden from publishing so designers bind the semantic roles instead. Select a swatch for its details.', [flt, list]); draw(); return s;
  }
  function secSemantic() {
    var vars = S.variables.filter(function (v) { return v.collection === 'Semantic'; }), groups = ['all'].concat(Object.keys(vars.reduce(function (a, v) { a[groupOf(v.name, 1)] = 1; return a; }, {}))), body = h('div', { id: 'sem-body' }), count = h('span', { class: 'count' }), M = COLL.Semantic.modes;
    function differs(v) { return v.values[M[0]].resolved !== v.values[M[1]].resolved || v.values[M[0]].alias !== v.values[M[1]].alias; }
    function draw() {
      var f = st.f.sem, q = f.q.toLowerCase(); var items = vars.filter(function (v) { return (f.group === 'all' || groupOf(v.name, 1) === f.group) && (!f.diff || differs(v)) && (!q || (v.name + ' ' + v.description).toLowerCase().indexOf(q) >= 0); });
      body.textContent = ''; var by = {}; items.forEach(function (v) { (by[groupOf(v.name, 1)] = by[groupOf(v.name, 1)] || []).push(v); });
      Object.keys(by).forEach(function (g) { body.appendChild(h('h3', { text: 'color/' + g + '  (' + by[g].length + ')' })); body.appendChild(h('div', { class: 'grid swgrid' }, by[g].map(function (v) { return swatch(v, st.sem); }))); });
      if (!items.length) body.appendChild(empty('No semantic role matches the filter.')); count.textContent = items.length + ' of ' + vars.length + ' roles in mode ' + st.sem;
    }
    var changed = vars.filter(differs);
    var sample = h('div', { class: 'card', style: 'background:' + val('color/bg/page') + ';color:' + val('color/text/primary') + ';border-color:' + val('color/border/strong') }, [h('h3', { style: 'color:' + val('color/text/primary'), text: 'Mode sample: ' + st.sem }), h('p', { style: 'color:' + val('color/text/secondary'), text: 'Secondary text on the page background.' }), h('p', { style: 'color:' + val('color/text/muted'), text: 'Muted text (AA on Ivory, White and Blush).' }), h('p', {}, [h('span', { style: 'color:' + val('color/link/default') + ';text-decoration:underline', text: 'A link in this mode' })]), h('div', { style: 'display:flex;gap:12px;flex-wrap:wrap;align-items:center' }, [VRender.render(COMP.button, { Variant: 'Primary', Size: 'Md', State: 'Default', Label: 'Primary' }).node, VRender.render(COMP.button, { Variant: 'Secondary', Size: 'Md', State: 'Default', Label: 'Secondary' }).node, VRender.render(COMP.button, { Variant: 'Secondary', Size: 'Md', State: 'Focus', Label: 'Focus ring' }).node])]);
    var cmp = table(['Role that differs between modes', M[0], M[1]], changed.map(function (v) { return { key: v.name, cells: [v.name, valueNode(v, M[0]), valueNode(v, M[1])] }; }), { click: openPanel });
    var chk = h('label', { class: 'check' }), ci = h('input', { type: 'checkbox' }); ci.checked = st.f.sem.diff; ci.addEventListener('change', function () { st.f.sem.diff = ci.checked; draw(); }); chk.appendChild(ci); chk.appendChild(document.createTextNode('Only roles that differ between modes'));
    var flt = h('div', { class: 'filters' }, [searchBox('Search role or usage', st.f.sem.q, function (x) { st.f.sem.q = x; draw(); }), select('Group', groups.map(function (g) { return [g, g === 'all' ? 'All groups' : g]; }), st.f.sem.group, function (x) { st.f.sem.group = x; draw(); }), chk, count]);
    var s = sec('semantic', 3, 'Semantic Colors', 'The ' + vars.length + ' colour roles (collection Semantic). The Semantic mode switch at the top changes the values shown (current: ' + st.sem + '). In ' + M[1] + ', ' + changed.length + ' roles re-resolve; the rest keep their value. Each role shows whether it is an alias or a literal, and where it points.', [sample, flt, body, h('h3', { text: 'Roles that differ between ' + M.join(' and ') + ' (' + changed.length + ')' }), cmp, h('p', { class: 'note', text: 'Two roles are literal colours with alpha because a Figma alias cannot change alpha: color/border/inverse-subtle and color/overlay/scrim.' })]);
    draw(); return s;
  }
  function secType() {
    var heads = [val('font/family/heading', 'Value'), val('font/family/body', 'Value')];
    var fstatus = h('div', { class: 'card' }, [h('h3', { text: 'Font rendering status' }), h('p', { class: 'note', text: 'The preview checks whether each intended family really rendered. If it did not, the specimens below use a system fallback and the status says so.' })].concat(heads.map(function (f) { return h('p', {}, [h('b', { text: f + '   ' }), h('span', { 'data-font': f, class: 'status info', text: 'Checking...' })]); })));
    var groups = {}; S.textStyles.forEach(function (t) { var g = t.name.split('/')[0]; (groups[g] = groups[g] || []).push(t); });
    var kids = [fstatus];
    Object.keys(groups).forEach(function (g) {
      kids.push(h('h3', { text: g }));
      groups[g].forEach(function (t) {
        var sv = BY[t.fontSizeVariable], px = t.fontSizePx[st.type], lh = Math.round(px * t.lineHeightPercent) / 100, fluid = sv && sv.webRelation === 'mapped' && typeof sv.webRaw === 'string' && sv.webRaw.indexOf('clamp(') === 0;
        kids.push(h('div', { class: 'stage' }, [
          h('div', { class: 'sample', style: textCss(t.name) + 'color:var(--c-text)', text: g === 'Display' ? 'A calm, editorial foundation' : /Overline|Button|Utility/.test(t.name) ? 'Add to bag' : 'Rosewater Barrier Serum' }),
          h('div', { class: 'cap' }, [h('b', { text: t.name }), h('span', { text: t.fontFamily + ' ' + t.fontWeight }), h('span', { 'data-var': t.fontSizeVariable, 'data-mode': st.type, 'data-value': String(px), text: px + ' px' }), h('span', { text: 'line height ' + t.lineHeightPercent + '% (' + lh + ' px)' }), h('span', { text: 'letter spacing ' + t.letterSpacingPercent + '%' }), h('span', { text: 'case ' + t.textCase })]),
          h('div', { class: 'cap', style: 'margin-top:8px' }, [h('span', { text: 'Use: ' + t.usage }), h('span', { text: 'binds ' + t.fontFamilyVariable + ', ' + t.fontWeightVariable + ', ' + t.fontSizeVariable })]),
          h('div', { class: 'cap', style: 'margin-top:8px' }, [fluid ? pill('Fluid on the web, sampled in Figma', 'warn') : (COLL.Typography.modes.some(function (m) { return t.fontSizePx[m] !== t.fontSizePx[COLL.Typography.modes[0]]; }) ? pill('Stepped px: the web tier values, one per mode', 'ok') : pill('Static px: the same in every mode', 'ok')), h('span', { text: 'Figma ' + COLL.Typography.modes.map(function (m) { return t.fontSizePx[m] + ' px'; }).join(' / ') + ' (' + COLL.Typography.modes.join(' / ') + ')' }), sv && sv.webRaw ? h('span', { text: 'web ' + sv.webRaw + (fluid ? ' = ' + COLL.Typography.modes.map(function (m) { return Math.round(sv.webResolved[m] * 100) / 100 + ' px'; }).join(' / ') + ' at 360 / 768 / 1280' : '') }) : null])
        ]));
      });
    });
    kids.push(h('h3', { text: 'Size ladder (px, mode ' + st.type + ')' }));
    var max = Math.max.apply(null, S.textStyles.map(function (t) { return t.fontSizePx.Desktop; }));
    S.textStyles.forEach(function (t) { kids.push(h('div', { class: 'bar-row' }, [h('span', { text: t.name }), h('i', { style: 'width:' + (t.fontSizePx[st.type] / max * 100) + '%' }), h('span', { text: t.fontSizePx[st.type] + ' px' })])); });
    kids.push(h('p', { class: 'note', text: 'Font sizes are canonical in px, whole and even. Since the 2026-11-11 audit the web has no fluid sizes: the scaled sizes step at 600 and 1024px, and each Figma mode holds the web tier value exactly. A fluid clamp() would be shown here as sampled values if one were reintroduced.' }));
    return sec('type', 4, 'Typography', S.textStyles.length + ' Text Styles rendered with their specified family, weight, size, line height, letter spacing and case, at the selected Typography mode (' + st.type + '). Line height and letter spacing are stored in the style as percentages.', kids);
  }
  function barRows(names, unit, max, mode) { return names.map(function (n) { var x = val(n, mode); return h('div', { class: 'bar-row' }, [h('button', { class: 'pill', type: 'button', text: n, onclick: function () { openPanel(n); } }), h('i', { style: 'width:' + Math.max(0.5, (x / max) * 100) + '%' }), h('span', { 'data-var': n, 'data-mode': mode || modeFor(BY[n].collection), 'data-value': String(x), text: x + ' ' + unit })]); }); }
  function secSpacing() {
    var space = S.variables.filter(function (v) { return v.name.indexOf('space/') === 0; }).map(function (v) { return v.name; });
    var comp = S.variables.filter(function (v) { return v.collection === 'Components' && v.type === 'FLOAT'; });
    var sizing = comp.filter(function (v) { return /(height|size|touch-target|thumb-size)/.test(v.name) && v.name.indexOf('min-height') < 0 && typeof v.values.Value.resolved === 'number' && v.values.Value.resolved <= 120; }), padgap = comp.filter(function (v) { return /(padding|gap|offset)/.test(v.name); });
    var boxes = h('div', { class: 'specimens' }, sizing.map(function (v) { var x = v.values.Value.resolved; return h('div', { class: 'spec' }, [h('div', { class: 'box', style: 'width:' + x + 'px;height:' + x + 'px' }), h('button', { class: 'pill', type: 'button', onclick: function () { openPanel(v.name); }, text: v.name }), h('span', { 'data-var': v.name, 'data-mode': 'Value', 'data-value': String(x), text: x + ' px' })]); }));
    return sec('spacing', 5, 'Spacing & Sizing', 'The spacing scale (Primitives) and the component sizing and spacing variables (Components). Bars and squares are drawn at the real pixel size, so differences between values are visible. Padding and gap variables alias the spacing scale.', [
      h('h3', { text: 'Spacing scale (' + space.length + ')' }), h('div', {}, barRows(space, 'px', 96, 'Value')),
      h('h3', { text: 'Component sizing (drawn at 1:1)' }), boxes,
      h('h3', { text: 'Padding, gap and offset variables (' + padgap.length + ')' }),
      table(['Variable', 'Value', 'Alias', 'Intended use'], padgap.map(function (v) { var e = v.values.Value; return { key: v.name, cells: [v.name, h('span', { 'data-var': v.name, 'data-mode': 'Value', 'data-value': String(e.resolved), text: e.resolved + ' px' }), e.alias || '(literal)', v.description] }; }), { click: openPanel }),
      h('p', { class: 'note', text: 'Sizes that are not square (input/textarea-min-height, qty/input-width) are in the variable browser (section 8).' })
    ]);
  }
  function secLayout() {
    var lv = S.variables.filter(function (v) { return v.collection === 'Layout'; }), modes = COLL.Layout.modes;
    var tbl = table(['Variable'].concat(modes).concat(['Web token', 'Relation']), lv.map(function (v) { return { key: v.name, cells: [v.name].concat(modes.map(function (m) { return h('span', { style: m === st.layout ? 'font-weight:700;color:var(--c-accent)' : '' }, [valueNode(v, m)]); })).concat([v.webToken || '(Figma only)', v.webRelation]) }; }), { click: openPanel });
    var cont = lv.filter(function (v) { return v.name.indexOf('layout/container/') === 0; }).map(function (v) { return v.name; });
    var frames = h('div', { class: 'frames' }, modes.map(function (m) {
      var w = val('layout/frame-width', m), g = val('layout/gutter', m), gap = val('layout/grid-gap', m), gs = S.gridStyles.filter(function (x) { return x.mode === m; })[0], sc = 0.32, cols = gs ? gs.columns : 0;
      var page = h('div', { class: 'page', style: 'width:' + w * sc + 'px;padding:' + g * sc + 'px;gap:' + gap * sc + 'px;grid-template-columns:repeat(' + (cols || 1) + ',1fr)' }); for (var i = 0; i < Math.max(cols, 1) * 2; i++) page.appendChild(h('div', { class: 'col', style: 'height:' + 40 * sc * 2 + 'px' }));
      return h('div', { class: 'frame', style: m === st.layout ? 'outline:2px solid var(--c-accent)' : '' }, [h('b', { text: m + ' frame, ' + w + ' px' }), h('div', { text: 'gutter ' + g + ' px, gap ' + gap + ' px, ' + (cols ? cols + ' product columns' : 'no grid style') }), page]);
    }));
    var bps = S.webMapping.filter(function (r) { return r.css.indexOf('--breakpoint-') === 0; }), rules = S.components.filter(function (c) { return c.responsive; });
    return sec('layout', 6, 'Layout & Grid', 'Page gutters, grid gaps, section spacing, containers and reference frame widths, per tier mode (current: ' + st.layout + '). The three modes stand for the web system\'s three tiers; Figma has no media queries.', [
      h('h3', { text: 'Layout variables (' + lv.length + ')' }), tbl,
      h('h3', { text: 'Content widths (proportional, mode ' + st.layout + ')' }), h('div', {}, barRows(cont, 'px', Math.max.apply(null, cont.map(function (n) { return val(n, st.layout); })), st.layout)),
      h('h3', { text: 'Frames per tier (scaled to 32%)' }), frames,
      h('h3', { text: 'Grid Styles (' + S.gridStyles.length + ')' }), table(['Style', 'Mode', 'Columns', 'Gap', 'Margin', 'Note'], S.gridStyles.map(function (g) { return { key: g.name, cells: [g.name, g.mode, g.columns, g.gutterVariable, g.marginVariable, g.note] }; })),
      h('p', { class: 'note', text: 'No 12-column page grid is defined: the web system did not adopt one, so none is shown. Only the product grid has Grid Styles.' }),
      h('h3', { text: 'Breakpoints' }), bps.length ? table(['Web token', 'Category', 'Figma representation'], bps.map(function (r) { return { key: r.css, cells: [r.css, r.category, r.figma] }; })) : empty('No breakpoint mapping in the data.'),
      h('h3', { text: 'Responsive rules documented per component' }), table(['Component', 'Responsive design intent'], rules.map(function (c) { return { key: c.id, cells: [c.name, c.responsive] }; }))
    ]);
  }
  function secEffects() {
    var rad = S.variables.filter(function (v) { return v.name.indexOf('radius/') === 0 && v.collection === 'Primitives'; }), bw = S.variables.filter(function (v) { return v.name.indexOf('border-width/') === 0; }), op = S.variables.filter(function (v) { return v.name.indexOf('opacity/') === 0; });
    var specs = function (arr, fn, suffix) { return h('div', { class: 'specimens' }, arr.map(function (v) { var x = v.values.Value.resolved; return h('div', { class: 'spec' }, [fn(x), h('button', { class: 'pill', type: 'button', onclick: function () { openPanel(v.name); }, text: v.name }), h('span', { 'data-var': v.name, 'data-mode': 'Value', 'data-value': String(x), text: String(x) + suffix })]); })); };
    var fx = S.effectStyles.map(function (e) { var css = e.layers.map(function (l) { var base = val(String(l.color).replace(/[{}]/g, ''), 'Value'); return l.x + 'px ' + l.y + 'px ' + l.blur + 'px ' + l.spread + 'px ' + hexA(base, l.alpha); }).join(', '); return h('div', { class: 'spec' }, [h('div', { style: 'width:120px;height:80px;border-radius:' + val('radius/md', 'Value') + 'px;background:' + val('color/bg/surface') + ';box-shadow:' + css }), h('b', { style: 'color:var(--c-text)', text: e.name }), h('span', { text: e.layers.length + ' layer(s); web ' + e.webToken })]); });
    var other = S.webMapping.filter(function (r) { return /^--(duration|ease|transition|z|shadow)-/.test(r.css); });
    return sec('effects', 7, 'Radius, Borders & Effects', 'Radius, stroke and opacity are Variables. Shadows are Effect Styles, because a Variable cannot hold a bundle of offsets, blur and colour. Motion and layer order are not Variables in Figma.', [
      h('h3', { text: 'Radius' }), specs(rad, function (x) { return h('div', { style: 'width:96px;height:64px;border:2px solid var(--c-border);background:var(--c-surface);border-radius:' + Math.min(x, 32) + 'px' }); }, ' px'),
      h('h3', { text: 'Border widths' }), specs(bw, function (x) { return h('div', { style: 'width:96px;height:64px;background:var(--c-surface);border:' + x + 'px solid var(--c-text)' }); }, ' px'),
      h('h3', { text: 'Opacity' }), specs(op, function (x) { return h('div', { style: 'width:96px;height:64px;background:var(--c-accent);opacity:' + x }); }, ' (fraction)'),
      h('h3', { text: 'Effect Styles (' + S.effectStyles.length + ')' }), h('div', { class: 'specimens', style: 'padding:24px;background:var(--c-subtle);border-radius:8px' }, fx),
      h('h3', { text: 'Focus ring' }), h('div', { class: 'specimens' }, [h('div', { class: 'spec' }, [h('div', { style: 'width:120px;height:44px;background:var(--c-surface);border:1px solid var(--c-border);border-radius:' + val('radius/control') + 'px;outline:' + val('focus/ring-width', 'Value') + 'px solid ' + val('color/focus/ring') + ';outline-offset:' + val('focus/ring-offset', 'Value') + 'px' }), h('span', { text: 'focus/ring-width ' + val('focus/ring-width', 'Value') + ' px, focus/ring-offset ' + val('focus/ring-offset', 'Value') + ' px, color/focus/ring (' + st.sem + ')' })])]),
      h('h3', { text: 'Not Variables (documented alternatives)' }), table(['Web token', 'Category', 'Figma representation'], other.map(function (r) { return { key: r.css, cells: [r.css, r.category, r.figma] }; }))
    ]);
  }
  function secCollections() {
    var cards = S.collections.map(function (c) { var n = S.variables.filter(function (v) { return v.collection === c.name; }).length; return h('div', { class: 'card' }, [h('h3', { text: c.name + '  ' }, [pill(n + ' variables')]), h('p', {}, c.modes.map(function (m) { return h('span', { class: 'tag', text: 'mode: ' + m + (m === c.defaultMode ? ' (default)' : '') }); })), h('p', { text: c.purpose }), h('p', { class: 'note', text: c.modeRationale })]); });
    var inbound = {}; S.variables.forEach(function (v) { Object.keys(v.values).forEach(function (m) { var a = v.values[m].alias; if (a) { (inbound[a] = inbound[a] || {})[v.name] = 1; } }); });
    var top = Object.keys(inbound).map(function (k) { return [k, Object.keys(inbound[k]).length]; }).sort(function (a, b) { return b[1] - a[1]; }).slice(0, 10);
    var list = h('div', { id: 'vb' }), count = h('span', { class: 'count' });
    function drawVB() {
      var f = st.f.vb, q = f.q.toLowerCase(); var items = S.variables.filter(function (v) { return (f.coll === 'all' || v.collection === f.coll) && (f.type === 'all' || v.type === f.type) && (f.layer === 'all' || v.layer === f.layer) && (f.rel === 'all' || v.webRelation === f.rel) && (!q || (v.name + ' ' + v.description + ' ' + v.webToken).toLowerCase().indexOf(q) >= 0); });
      var collsShown = f.coll === 'all' ? S.collections : [COLL[f.coll]], modeCols = []; collsShown.forEach(function (c) { c.modes.forEach(function (m) { if (modeCols.indexOf(m) < 0) modeCols.push(m); }); });
      list.textContent = '';
      list.appendChild(table(['Variable', 'Collection', 'Type'].concat(modeCols.map(function (m) { return m + (m === st.sem || m === st.layout || m === st.type ? ' *' : ''); })).concat(['Web token']), items.map(function (v) { return { key: v.name, cells: [v.name, v.collection, v.type].concat(modeCols.map(function (m) { return v.values[m] ? valueNode(v, m) : h('span', { style: 'color:var(--c-muted)', text: '-' }); })).concat([v.webToken || '(Figma only)']) }; }), { click: openPanel }));
      if (!items.length) list.appendChild(empty('No variable matches the filters.')); count.textContent = items.length + ' of ' + S.variables.length + ' variables';
    }
    var uniq = function (k) { return ['all'].concat(Object.keys(S.variables.reduce(function (a, v) { a[v[k]] = 1; return a; }, {}))); }, lab = function (arr, all) { return arr.map(function (t) { return [t, t === 'all' ? all : t]; }); };
    var flt = h('div', { class: 'filters' }, [searchBox('Search name, usage or web token', st.f.vb.q, function (x) { st.f.vb.q = x; drawVB(); }), select('Collection', [['all', 'All collections']].concat(S.collections.map(function (c) { return [c.name, c.name]; })), st.f.vb.coll, function (x) { st.f.vb.coll = x; drawVB(); }), select('Type', lab(uniq('type'), 'All types'), st.f.vb.type, function (x) { st.f.vb.type = x; drawVB(); }), select('Layer', lab(uniq('layer'), 'All layers'), st.f.vb.layer, function (x) { st.f.vb.layer = x; drawVB(); }), select('Web relation', lab(uniq('webRelation'), 'All'), st.f.vb.rel, function (x) { st.f.vb.rel = x; drawVB(); }), count]);
    var s = sec('collections', 8, 'Figma Collections & Modes', 'The collections, their modes and every variable with its value in each mode. A star marks the mode currently selected in the top bar. This is a browser rendering of the specification, not a native Figma Variables panel.', [h('div', { class: 'grid two' }, cards), h('h3', { text: 'Most-used alias targets (semantic relationships)' }), table(['Variable', 'Variables aliasing it'], top.map(function (t) { return { key: t[0], cells: [t[0], t[1]] }; }), { click: openPanel }), h('h3', { text: 'Variable browser' }), flt, list]);
    drawVB(); return s;
  }
  function secComponents() {
    var cards = S.components.map(function (c) {
      var r = VRender.render(c, VRender.defaults(c));
      var render = h('div', { class: 'render', style: 'background:' + val('color/bg/page') + ';color:' + val('color/text/primary') }, [r.node || h('span', { class: 'miss', text: 'No preview drawing' })]);
      return h('div', { class: 'card', id: 'c-' + c.id }, [h('h3', { text: c.name }), h('p', {}, [pill(c.status === 'provisional' ? 'Provisional' : 'Specified', c.status === 'provisional' ? 'warn' : 'ok'), h('span', { class: 'tag', text: 'web ' + c.webComponent }), h('span', { class: 'tag', text: variantCount(c) + ' variants' }), h('span', { class: 'tag', text: c.priority })]), c.statusNote ? h('p', { class: 'note', text: c.statusNote }) : null, render, r.missing.length ? h('p', { class: 'miss', text: 'Missing variable(s): ' + r.missing.join(', ') }) : null, h('p', { text: c.summary }),
        h('p', { style: 'font-size:14px' }, [h('b', { text: 'Properties: ' }), c.properties.map(function (p) { return p.name + ' (' + p.type + ')'; }).join(', ')]), h('p', { style: 'font-size:14px' }, [h('b', { text: 'Auto Layout: ' }), c.layout.direction + '; width ' + c.layout.widthSizing + '; height ' + c.layout.heightSizing + '; gap ' + c.layout.gap]), h('p', { style: 'font-size:14px' }, [h('b', { text: 'Responsive: ' }), c.responsive]), h('p', { style: 'font-size:14px' }, [h('b', { text: 'Bindings: ' }), c.bindings.length + ' variable bindings (see Component Variants)']), h('button', { class: 'btn', type: 'button', text: 'Open in Component Variants', onclick: function () { st.pg.vcomp = c.id; st.pg.props = null; rebuild(); location.hash = '#s-variants'; } })]);
    });
    var pend = S.pendingItems.map(function (p) { return { key: p.name, cells: [p.name, pill(p.status, 'info'), p.note] }; });
    S.notComponents.forEach(function (n) { pend.push({ key: n, cells: [n, pill('Not defined', 'info'), 'Listed as deliberately not a component in the specification.'] }); });
    return sec('components', 9, 'Components', S.components.length + ' components are specified. Each drawing is built from the component\'s own variable bindings and state styles in the selected Semantic mode (' + st.sem + '), and is a browser illustration, not a Figma component. Icon glyphs are generic placeholders.', [h('div', { class: 'grid cgrid' }, cards), h('h3', { text: 'Not defined or pending' }), table(['Item', 'Status', 'Note'], pend)]);
  }
  function secVariants() {
    var c = COMP[st.pg.vcomp]; if (!st.pg.props) st.pg.props = VRender.defaults(c);
    var live = h('div', { id: 'pg-live' }), ctr = h('div', { class: 'controls' });
    function drawLive() { live.textContent = ''; live.appendChild(h('div', { class: 'render-wrap' }, [showRender(c, st.pg.props, 'Live: ' + Object.keys(st.pg.props).map(function (k) { return k + '=' + st.pg.props[k]; }).join(', '))])); }
    ctr.appendChild(select('Component', S.components.map(function (x) { return [x.id, x.name]; }), c.id, function (x) { st.pg.vcomp = x; st.pg.props = null; rebuild(); }));
    c.properties.forEach(function (p) {
      var cur = st.pg.props[p.name];
      if (p.type === 'VARIANT') ctr.appendChild(select(p.name + ' (variant)', p.values.map(function (v) { return [v, v]; }), cur, function (x) { st.pg.props[p.name] = x; drawLive(); }));
      else if (p.type === 'BOOLEAN') { var l = h('label', { class: 'check' }), i = h('input', { type: 'checkbox' }); i.checked = cur === true || cur === 'true'; i.addEventListener('change', function () { st.pg.props[p.name] = i.checked ? 'true' : 'false'; drawLive(); }); l.appendChild(i); l.appendChild(document.createTextNode(p.name + ' (boolean)')); ctr.appendChild(l); }
      else if (p.type === 'TEXT') { var t = h('input', { type: 'text' }); t.value = cur || ''; t.addEventListener('input', function () { st.pg.props[p.name] = t.value; drawLive(); }); ctr.appendChild(h('label', {}, [p.name + ' (text)', t])); }
      else ctr.appendChild(select(p.name + ' (instance swap)', (p.name === 'Icon' ? S.icons.map(function (i) { return ['Icon/' + i, 'Icon/' + i]; }) : [[cur, cur]]), cur, function (x) { st.pg.props[p.name] = x; drawLive(); }));
    });
    var all = VRender.combos(c, 60), grid = h('div', { class: 'render-wrap' }, all.list.map(function (combo) { return showRender(c, combo, Object.keys(combo).map(function (k) { return k + '=' + combo[k]; }).join(', ')); }));
    var bind = table(['Element', 'Property', 'Variable', 'Value now'], c.bindings.map(function (b) { var x = val(b.variable); return { key: b.variable, cells: [b.element, b.property, b.variable, BY[b.variable] ? h('span', { 'data-var': b.variable, 'data-mode': modeFor(BY[b.variable].collection), 'data-value': String(x), text: String(x) }) : h('span', { class: 'miss', text: 'MISSING VARIABLE' })] }; }), { click: function (k) { if (BY[k]) openPanel(k); } });
    var s = sec('variants', 10, 'Component Variants', 'Pick a component and change its properties to see the drawing update. These are browser-preview interactions, not real Figma components or variant sets. Below, every combination of the variant properties is drawn (up to 60).', [
      h('div', { class: 'banner' }, [pill('Browser preview', 'info'), h('p', { text: 'Variants: ' + variantCount(c) + (all.total > all.list.length ? ' (showing the first ' + all.list.length + ')' : '') + '. Status: ' + (c.status === 'provisional' ? 'provisional. ' + c.statusNote : 'specified.') })]), ctr, live,
      h('h3', { text: 'All variant combinations (' + all.list.length + ' of ' + all.total + ')' }), grid,
      h('h3', { text: 'Properties' }), table(['Property', 'Type', 'Values', 'Default', 'Note'], c.properties.map(function (p) { return { key: p.name, cells: [p.name, p.type, (p.values || []).join(', '), p.default, p.note] }; })),
      h('h3', { text: 'Auto Layout intent' }), table(['Aspect', 'Specification'], [['Direction', c.layout.direction], ['Width', c.layout.widthSizing], ['Height', c.layout.heightSizing], ['Padding', c.layout.padding], ['Gap', c.layout.gap], ['Alignment', c.layout.align]].map(function (r) { return { key: r[0], cells: r }; })),
      h('h3', { text: 'Variable bindings (' + c.bindings.length + ')' }), bind,
      h('h3', { text: 'Responsive, accessibility and handoff' }), table(['Topic', 'Notes'], [['Responsive', c.responsive], ['Accessibility', c.accessibility], ['Developer handoff', c.handoff], ['Not representable in Figma', (c.notRepresentedInFigma || []).join('; ') || 'nothing noted']].map(function (r) { return { key: r[0], cells: r }; }))
    ]);
    drawLive(); return s;
  }
  function secNaming() {
    var trees = S.collections.map(function (c) {
      var root = {}; S.variables.filter(function (v) { return v.collection === c.name; }).forEach(function (v) { var n = root; v.name.split('/').forEach(function (seg) { n = n[seg] = n[seg] || {}; }); });
      function ul(node) { var u = h('ul'); Object.keys(node).forEach(function (k) { var kids = Object.keys(node[k]); u.appendChild(h('li', { text: k }, kids.length ? [ul(node[k])] : [])); }); return u; }
      return h('details', { class: 'tree' }, [h('summary', { text: c.name + ' (' + S.variables.filter(function (v) { return v.collection === c.name; }).length + ')' }), ul(root)]);
    });
    var mt = h('div', { id: 'map-body' }), count = h('span', { class: 'count' });
    function draw() { var f = st.f.map, q = f.q.toLowerCase(); var rows = S.webMapping.filter(function (r) { return (f.cat === 'all' || r.category === f.cat) && (!q || (r.css + ' ' + r.figma + ' ' + r.why).toLowerCase().indexOf(q) >= 0); }); mt.textContent = ''; mt.appendChild(table(['Web token', 'Category', 'Figma representation', 'Why'], rows.slice(0, 400).map(function (r) { var fv = S.variables.filter(function (v) { return v.webToken === r.css; })[0]; return { key: fv ? fv.name : '', cells: [r.css, r.category, r.figma, r.why] }; }), { click: function (k) { if (k) openPanel(k); } })); count.textContent = rows.length + ' of ' + S.webMapping.length + ' web tokens'; }
    var cats = ['all'].concat(Object.keys(S.mappingSummary.categories));
    var flt = h('div', { class: 'filters' }, [searchBox('Search web token or Figma name', st.f.map.q, function (x) { st.f.map.q = x; draw(); }), select('Category', cats.map(function (x) { return [x, x === 'all' ? 'All categories' : x + ' (' + S.mappingSummary.categories[x] + ')']; }), st.f.map.cat, function (x) { st.f.map.cat = x; draw(); }), count]);
    var s = sec('naming', 11, 'Naming & Token Mapping', 'Names mirror the web token path with "/" (--color-bg-page is color/bg/page). Every web token is classified; selecting a row opens the Figma variable when one exists.', [h('div', { class: 'grid two' }, [h('div', {}, [h('h3', { text: 'Hierarchy' })].concat(trees)), h('div', {}, [h('h3', { text: 'Summary' }), table(['Category', 'Web tokens'], Object.keys(S.mappingSummary.categories).map(function (k) { return { key: k, cells: [k, S.mappingSummary.categories[k]] }; }).concat([{ key: 'fo', cells: ['Figma-only variables', (S.mappingSummary.figmaOnlyVariables || []).join(', ')] }])), h('p', { class: 'note', text: 'Text Styles use "Group/Name"; components use Title Case; State, Variant and Size are variant axes.' })])]), h('h3', { text: 'Web token to Figma mapping' }), flt, mt]);
    draw(); return s;
  }

  /* ---- validation: live checks in this page, and the validator's results ---- */
  function liveChecks() {
    var out = [], add = function (id, name, problems, detail) { out.push({ id: id, name: name, problems: problems, detail: detail || '' }); };
    var counts = S.meta.counts, p = [];
    if (counts.variables !== S.variables.length) p.push('meta says ' + counts.variables + ' variables, the data holds ' + S.variables.length);
    if (counts.textStyles !== S.textStyles.length) p.push('meta says ' + counts.textStyles + ' text styles, the data holds ' + S.textStyles.length);
    if (S.webMapping.length !== S.mappingSummary.total) p.push('mapping rows ' + S.webMapping.length + ' differ from the summary total ' + S.mappingSummary.total);
    add('L1', 'Data loaded and counts agree with the generator\'s own counts', p, S.variables.length + ' variables, ' + S.textStyles.length + ' text styles, ' + S.components.length + ' components');
    var seen = {}, d = []; S.variables.forEach(function (v) { var k = v.name.toLowerCase(); if (seen[k]) d.push('duplicate name ' + v.name); seen[k] = 1; }); add('L2', 'No duplicate variable names', d);
    var a = []; S.variables.forEach(function (v) { Object.keys(v.values).forEach(function (m) { var e = v.values[m]; if (e.alias) { var t = BY[e.alias]; if (!t) a.push(v.name + ' (' + m + ') aliases missing ' + e.alias); else if (t.type !== v.type) a.push(v.name + ' aliases ' + e.alias + ' of another type'); } var g = 0, cur = v, mm = m; while (cur && cur.values[mm] && cur.values[mm].alias && g++ < 12) { cur = BY[cur.values[mm].alias]; if (cur && !cur.values[mm]) mm = Object.keys(cur.values)[0]; } if (g >= 12) a.push(v.name + ' alias chain too deep (cycle?)'); }); }); add('L3', 'Every alias resolves, matches its type and has no cycle', a);
    var mo = []; S.variables.forEach(function (v) { COLL[v.collection].modes.forEach(function (m) { if (!v.values[m]) mo.push(v.name + ' has no value for mode ' + m); }); }); add('L4', 'Every variable has a value for each mode of its collection', mo);
    var pt = [], re = new RegExp('\\d\\s?' + 'p' + 't\\b'); S.variables.filter(function (v) { return v.name.indexOf('font-size/') === 0; }).forEach(function (v) { Object.keys(v.values).forEach(function (m) { var x = v.values[m].resolved; if (typeof x !== 'number') pt.push(v.name + ' (' + m + ') is not a px number: ' + x); }); if (v.type !== 'FLOAT') pt.push(v.name + ' is not FLOAT'); }); if (re.test(JSON.stringify(S))) pt.push('a point unit appears in the data'); add('L5', 'Font sizes are px numbers; no point unit anywhere in the data', pt);
    var cp = [], ts = []; S.components.forEach(function (c) { ['id', 'name', 'properties', 'layout', 'bindings', 'responsive', 'accessibility', 'handoff'].forEach(function (f) { if (c[f] === undefined) cp.push(c.name + ' is missing ' + f); }); c.bindings.forEach(function (b) { if (!BY[b.variable]) cp.push(c.name + ' binds missing variable ' + b.variable); }); (c.stateStyles || []).forEach(function (s) { if (s) ['fill', 'stroke', 'strokeWidth', 'text'].forEach(function (k) { if (s[k] && !BY[s[k]]) cp.push(c.name + ' state style uses missing variable ' + s[k]); }); }); }); add('L6', 'Every component is complete and every variable it names exists', cp);
    S.textStyles.forEach(function (t) { ['fontFamilyVariable', 'fontWeightVariable', 'fontSizeVariable'].forEach(function (k) { if (!BY[t[k]]) ts.push(t.name + ' binds missing ' + t[k]); }); }); add('L7', 'Every text style binds existing variables', ts);
    var miss = []; S.components.forEach(function (c) { if (VRender.supported(c.id)) { var r = VRender.render(c, VRender.defaults(c)); r.missing.forEach(function (n) { miss.push(c.name + ' drawing needs missing variable ' + n); }); } else miss.push(c.name + ' has no preview drawing'); }); add('L8', 'Every component renders from existing variables (no missing bindings)', miss);
    var un = S.webMapping.filter(function (r) { return /^--(palette|color)-/.test(r.css) && r.category.indexOf('UNMAPPED') === 0; }).map(function (r) { return r.css + ' is an unmapped colour token'; }); add('L9', 'No web colour token is unmapped', un, S.webMapping.length + ' web tokens classified');
    return out;
  }
  function compareWithValidator() {
    if (!V) return { rows: [], diffs: ['Validator results are not loaded'] };
    var vc = V.meta.counts, rows = [], diffs = [];
    var mine = { collections: S.collections.length, variables: S.variables.length, textStyles: S.textStyles.length, gridStyles: S.gridStyles.length, effectStyles: S.effectStyles.length, components: S.components.length, variants: sizeOf(S.components, variantCount), webTokens: S.webMapping.length };
    Object.keys(mine).forEach(function (k) { var ok = mine[k] === vc[k]; rows.push([k, mine[k], vc[k], ok ? 'same' : 'DIFFERENT']); if (!ok) diffs.push(k + ': preview ' + mine[k] + ', source ' + vc[k]); });
    S.collections.forEach(function (c) { var m = S.variables.filter(function (v) { return v.collection === c.name; }).length, s = vc.variablesByCollection[c.name], ok = m === s; rows.push(['variables in ' + c.name, m, s, ok ? 'same' : 'DIFFERENT']); if (!ok) diffs.push('variables in ' + c.name + ': preview ' + m + ', source ' + s); });
    var srcSame = true; Object.keys(V.meta.sourceHashes).forEach(function (k) { if (!S.meta.sourceHashes || S.meta.sourceHashes[k] !== V.meta.sourceHashes[k]) { srcSame = false; diffs.push('source file changed since the preview data was built: ' + k); } });
    rows.push(['source file hashes (' + Object.keys(V.meta.sourceHashes).length + ' files)', 'preview data', 'validator', srcSame ? 'same' : 'DIFFERENT']);
    if (V.meta.variableMapSha256 !== S.meta.variableMapSha256) diffs.push('variable-map.json differs between the validator run and the preview data');
    return { rows: rows, diffs: diffs };
  }
  function validationState() {
    var live = liveChecks(), liveFail = live.filter(function (x) { return x.problems.length; }).length;
    if (!V) return { kind: 'warn', label: 'Validator results not loaded', detail: 'validation-data.js is missing. Run 02-Design-Variables/Figma-Variables/validate-figma-variables.ps1 to create it. In-page checks: ' + (liveFail ? liveFail + ' of ' + live.length + ' failed.' : 'all ' + live.length + ' passed.') + ' Nothing has been validated in Figma.' };
    var cmp = compareWithValidator(), failed = V.meta.groupsFailed;
    if (failed || liveFail) return { kind: 'bad', label: 'Issues found', detail: failed + ' of ' + V.meta.groupsTotal + ' validator groups failed; ' + liveFail + ' of ' + live.length + ' in-page checks failed.' };
    if (cmp.diffs.length) return { kind: 'warn', label: 'Validation results are out of date', detail: 'The validator passed, but the preview data differs from the sources it validated: ' + cmp.diffs.slice(0, 2).join('; ') + '. Rebuild and rerun the validator.' };
    return { kind: 'ok', label: 'Specification checks passed', detail: 'All ' + V.meta.groupsTotal + ' validator groups passed and all ' + live.length + ' in-page checks passed, against the current sources. This validates the specification files only: nothing was validated in Figma, and ' + S.provisionalDecisions.length + ' items remain provisional, approximate, unverified or not done.' };
  }
  function secValidation() {
    var live = liveChecks(), cmp = compareWithValidator(), vs = validationState();
    var kids = [h('div', { class: 'banner ' + vs.kind }, [pill(vs.label, vs.kind), h('p', { text: vs.detail })])];
    kids.push(h('h3', { text: 'Validator results (02-Design-Variables/Figma-Variables/validate-figma-variables.ps1)' }));
    kids.push(V ? table(['#', 'Check', 'Result', 'Problems'], V.groups.map(function (g) { return { key: g.id, cells: [g.id, g.name, pill(g.status, g.status === 'PASS' ? 'ok' : 'bad'), g.problems.length ? g.problems.join(' | ') : ''] }; })) : empty('No validator results loaded. Run the validator.'));
    kids.push(h('h3', { text: 'In-page checks (computed by this page from the loaded data)' }));
    kids.push(table(['#', 'Check', 'Result', 'Problems or detail'], live.map(function (g) { return { key: g.id, cells: [g.id, g.name, pill(g.problems.length ? 'FAIL' : 'PASS', g.problems.length ? 'bad' : 'ok'), g.problems.length ? g.problems.slice(0, 8).join(' | ') : g.detail] }; })));
    kids.push(h('h3', { text: 'Preview versus source data' })); kids.push(V ? table(['Measure', 'In this preview', 'In the source files (validator)', 'Result'], cmp.rows.map(function (r) { return { key: r[0], cells: [r[0], r[1], r[2], pill(r[3], r[3] === 'same' ? 'ok' : 'bad')] }; })) : empty('Comparison unavailable without validator results.'));
    kids.push(h('h3', { text: 'Fonts' })); kids.push(h('div', { class: 'card' }, [val('font/family/heading', 'Value'), val('font/family/body', 'Value')].map(function (f) { return h('p', {}, [h('b', { text: f + '   ' }), h('span', { 'data-font': f, class: 'status info', text: 'Checking...' })]); })));
    kids.push(h('h3', { text: 'Provisional, approximate, unverified or not done (' + S.provisionalDecisions.length + ')' }));
    kids.push(table(['Decision', 'Status', 'Why', 'Evidence needed to close it'], S.provisionalDecisions.map(function (d) { return { key: d.id, cells: [d.title, pill(d.status, d.status === 'Provisional' || d.status === 'Approximation' ? 'warn' : 'info'), d.reason, d.evidenceNeeded] }; })));
    kids.push(h('h3', { text: 'Not defined or pending (' + S.pendingItems.length + ')' })); kids.push(table(['Item', 'Status', 'Note'], S.pendingItems.map(function (p) { return { key: p.name, cells: [p.name, pill(p.status, 'info'), p.note] }; })));
    kids.push(h('h3', { text: 'Web mapping coverage' })); kids.push(h('p', { text: S.webMapping.length + ' web tokens are classified (' + Object.keys(S.mappingSummary.categories).map(function (k) { return k + ' ' + S.mappingSummary.categories[k]; }).join(', ') + '). No web colour token is unmapped.' }));
    return sec('validation', 12, 'Validation & Issues', 'What was checked, what failed and what is still open. The page never reports the system as fully validated: the checks run on the specification files, and nothing exists in Figma to validate.', kids);
  }

  /* ---- detail panel ---- */
  function openPanel(name) {
    var v = BY[name]; if (!v) return; var panel = $('panel'); $('panel-title').textContent = v.name;
    var body = $('panel-body'); body.textContent = '';
    body.appendChild(h('dl', {}, [['Collection', v.collection], ['Type', v.type], ['Layer', v.layer], ['Scopes', (v.scopes || []).join(', ')], ['Hidden from publishing', String(v.hidden)], ['Source file', v.sourceFile], ['Web token', v.webToken || '(Figma only)'], ['Web relation', v.webRelation], ['Usage', v.description]].reduce(function (a, r) { a.push(h('dt', { text: r[0] })); a.push(h('dd', { text: String(r[1]) })); return a; }, [])));
    body.appendChild(h('h4', { text: 'Values by mode' }));
    body.appendChild(h('div', { class: 'vals' }, COLL[v.collection].modes.map(function (m) {
      var e = v.values[m], ch = chain(v.name, m), links = [];
      ch.forEach(function (c, i) { if (i) links.push(h('span', { class: 'arrow', text: '→' })); links.push(c.missing ? h('span', { class: 'miss', text: c.name + ' (missing)' }) : h('button', { class: 'pill', type: 'button', text: c.name + (c.alias ? '' : ' = ' + c.resolved), onclick: function () { openPanel(c.name); } })); });
      return h('div', {}, [h('div', { class: 'v' }, [v.type === 'COLOR' ? h('span', { class: 'dot', style: 'background:' + e.resolved }) : null, h('b', { text: m }), h('span', { 'data-var': v.name, 'data-mode': m, 'data-value': String(e.resolved), text: String(e.resolved) }), h('span', { style: 'color:var(--c-muted)', text: e.alias ? 'alias' : 'literal' })]), h('div', { class: 'chain' }, links)]);
    })));
    if (v.webToken) {
      body.appendChild(h('h4', { text: 'Web value (read from Design Variables at build time)' }));
      body.appendChild(h('p', { class: 'mono', text: 'raw: ' + (typeof v.webRaw === 'string' ? v.webRaw : JSON.stringify(v.webRaw)) }));
      body.appendChild(h('div', { class: 'vals' }, Object.keys(v.webResolved || {}).map(function (m) { var w = v.webResolved[m], f = v.values[m].resolved, same = typeof w === 'number' && typeof f === 'number' ? Math.abs(w - f) < 0.0001 : String(w) === String(f), dl = typeof w === 'number' && typeof f === 'number' ? Math.round((f - w) * 1000) / 1000 : null; return h('div', { class: 'v' }, [h('b', { text: m }), h('span', { text: 'web ' + w }), h('span', { text: 'figma ' + f }), h('span', { class: same ? 'same' : 'diff', text: same ? 'same' : dl !== null ? 'differs by ' + dl : 'differs' })]); })));
    }
    var used = S.variables.filter(function (o) { return Object.keys(o.values).some(function (m) { return o.values[m].alias === v.name; }); });
    body.appendChild(h('h4', { text: 'Aliased by (' + used.length + ')' })); body.appendChild(h('div', { class: 'chain' }, used.slice(0, 40).map(function (o) { return h('button', { class: 'pill', type: 'button', text: o.name, onclick: function () { openPanel(o.name); } }); })));
    var comps = S.components.filter(function (c) { return JSON.stringify([c.bindings, c.stateStyles, c.toneStyles]).indexOf('"' + v.name + '"') >= 0; });
    body.appendChild(h('h4', { text: 'Used by components (' + comps.length + ')' })); body.appendChild(h('div', { class: 'chain' }, comps.map(function (c) { return h('button', { class: 'pill', type: 'button', text: c.name, onclick: function () { st.pg.vcomp = c.id; st.pg.props = null; closePanel(); rebuild(); location.hash = '#s-variants'; } }); })));
    panel.hidden = false; $('panel-close').focus();
  }
  function closePanel() { $('panel').hidden = true; }

  /* ---- shell: navigation, modes, search ---- */
  var SECTIONS = [['overview', 'Overview', secOverview, function () { return S.variables.length + ' vars'; }], ['colors', 'Color Variables', secColors, function () { return S.variables.filter(function (v) { return v.collection === 'Primitives' && v.type === 'COLOR'; }).length + ''; }], ['semantic', 'Semantic Colors', secSemantic, function () { return S.variables.filter(function (v) { return v.collection === 'Semantic'; }).length + ''; }], ['type', 'Typography', secType, function () { return S.textStyles.length + ''; }], ['spacing', 'Spacing & Sizing', secSpacing, function () { return ''; }], ['layout', 'Layout & Grid', secLayout, function () { return ''; }], ['effects', 'Radius, Borders & Effects', secEffects, function () { return ''; }], ['collections', 'Figma Collections & Modes', secCollections, function () { return S.collections.length + ''; }], ['components', 'Components', secComponents, function () { return S.components.length + ''; }], ['variants', 'Component Variants', secVariants, function () { return sizeOf(S.components, variantCount) + ''; }], ['naming', 'Naming & Token Mapping', secNaming, function () { return S.webMapping.length + ''; }], ['validation', 'Validation & Issues', secValidation, function () { var s = validationState(); return s.kind === 'ok' ? 'pass' : s.kind === 'bad' ? 'issues' : 'check'; }]];
  function buildNav() { var nav = $('nav'); nav.textContent = ''; SECTIONS.forEach(function (s, i) { var a = h('a', { href: '#s-' + s[0], 'data-sec': s[0] }, [h('span', { class: 'n', text: String(i + 1) }), h('span', { text: s[1] }), s[3]() ? h('span', { class: 'st', text: s[3]() }) : null]); a.addEventListener('click', function () { $('side').classList.remove('open'); $('menu-btn').setAttribute('aria-expanded', 'false'); }); nav.appendChild(a); }); }
  var io = null;
  function observe() {
    if (io) io.disconnect(); if (!('IntersectionObserver' in window)) return;
    io = new IntersectionObserver(function (es) { es.forEach(function (e) { if (e.isIntersecting) { document.querySelectorAll('#nav a').forEach(function (a) { a.removeAttribute('aria-current'); }); var a = document.querySelector('#nav a[data-sec="' + e.target.id.replace('s-', '') + '"]'); if (a) a.setAttribute('aria-current', 'true'); } }); }, { rootMargin: '-30% 0px -60% 0px' });
    document.querySelectorAll('section.sec').forEach(function (s) { io.observe(s); });
  }
  function rebuild() {
    var y = window.scrollY; app.textContent = '';
    SECTIONS.forEach(function (s) { try { app.appendChild(s[2]()); } catch (e) { app.appendChild(h('section', { class: 'sec', id: 's-' + s[0] }, [h('h2', { text: s[1] }), h('div', { class: 'banner bad' }, [pill('Render error', 'bad'), h('p', { text: String(e && e.message) })])])); if (window.console && console.error) console.error('Section ' + s[0] + ': ' + (e && e.stack || e)); } });
    buildNav(); updateFontBadges(); window.scrollTo(0, y); observe();
  }
  function buildModes() {
    var bar = $('modes'); bar.textContent = '';
    [['sem', 'Semantic', 'Semantic'], ['layout', 'Layout', 'Layout'], ['type', 'Type', 'Typography']].forEach(function (g) {
      bar.appendChild(h('div', { class: 'seg' }, [h('span', { text: g[1] }), h('div', { role: 'group', 'aria-label': g[1] + ' mode' }, COLL[g[2]].modes.map(function (m) { var b = h('button', { type: 'button', 'aria-pressed': String(st[g[0]] === m), 'data-grp': g[0], 'data-mode': m, text: m }); b.addEventListener('click', function () { st[g[0]] = m; bar.querySelectorAll('button[data-grp="' + g[0] + '"]').forEach(function (x) { x.setAttribute('aria-pressed', String(x.getAttribute('data-mode') === m)); }); rebuild(); }); return b; }))]));
    });
  }
  function buildSearch() {
    var inp = $('gsearch'), res = $('gresults');
    function run() {
      var q = inp.value.trim().toLowerCase(); res.textContent = ''; if (!q) { res.hidden = true; return; }
      var m = S.variables.filter(function (v) { return v.name.toLowerCase().indexOf(q) >= 0 || (v.description || '').toLowerCase().indexOf(q) >= 0; }); res.hidden = false;
      if (!m.length) { res.appendChild(h('div', { class: 'none', text: 'No variable matches "' + inp.value + '"' })); return; }
      m.slice(0, 14).forEach(function (v) { res.appendChild(h('button', { type: 'button', role: 'option', 'data-result': v.name, onclick: function () { res.hidden = true; openPanel(v.name); } }, [v.type === 'COLOR' ? h('span', { style: 'width:16px;height:16px;border-radius:3px;border:1px solid var(--c-border-subtle);flex:none;background:' + entry(v.name).resolved }) : null, h('span', { text: v.name }), h('span', { style: 'margin-left:auto;font-size:12px;color:var(--c-muted)', text: v.collection })])); });
      res.setAttribute('data-total', String(m.length)); if (m.length > 14) res.appendChild(h('div', { class: 'none', text: (m.length - 14) + ' more: refine the search or use the variable browser (section 8)' }));
    }
    inp.addEventListener('input', run); inp.addEventListener('keydown', function (e) { if (e.key === 'Escape') res.hidden = true; });
    document.addEventListener('click', function (e) { if (!res.contains(e.target) && e.target !== inp) res.hidden = true; });
  }
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape' && !$('panel').hidden) closePanel(); });
  $('panel-close').addEventListener('click', closePanel);
  $('menu-btn').addEventListener('click', function () { var o = $('side').classList.toggle('open'); $('menu-btn').setAttribute('aria-expanded', String(o)); });
  applyTheme(); buildModes(); buildSearch(); rebuild(); checkFonts();
})();
