/* NUDGE design variables: review dashboard.
   Data: token JSON, inlined by Tokens/build-tokens.ps1 (works from file://).
   Values shown/validated: the real computed CSS from ../styles/variables.css. */
(function () {
  'use strict';
  var DATA = JSON.parse(document.getElementById('token-data').textContent);
  var T = DATA.tokens, BY = {};
  T.forEach(function (t) { BY[t.n] = t; });
  var root = document.documentElement, sim = document.getElementById('sim');
  var TIERS = ['Mobile', 'Tablet', 'Desktop'];
  var $ = function (id) { return document.getElementById(id); };
  var esc = function (s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); };
  var cs = function (el) { return getComputedStyle(el); };
  var cssVal = function (n, el) { return cs(el || sim).getPropertyValue(n).trim(); };

  /* ---------- value helpers ------------------------------------------------ */
  function lit(s, i) { return s.replace(/var\(--([a-z0-9-]+)\)/g, function (m, n) { return BY[n] ? lit(BY[n].v[i], i) : m; }); }
  function num(s) { var m = /^(-?[\d.]+)(rem|px)?$/.exec(s.trim()); return m ? parseFloat(m[1]) * (m[2] === 'rem' ? 16 : 1) : NaN; }
  var REF = [360, 768, 1280];   // reference widths of the three tiers (used to show and simulate fluid tokens)
  function tpx(name, i) { var t = BY[name]; return t.fl ? t.fp[i] : num(lit(t.v[i], i)); }
  function fmt(n) { return (Math.round(n * 100) / 100) + 'px'; }
  function disp(t, i) {
    if (t.fl) return '<code>' + esc(t.raw[0]) + '</code> <span class="pv-note">(≈' + t.fp.map(function (x) { return Math.round(x * 10) / 10; }).join(' / ') + 'px at ' + REF.join(' / ') + 'px)</span>';
    var raw = t.raw[i], l = lit(t.v[i], i), a = /^\{(.+)\}$/.exec(raw), p = num(l);
    if (a) return '<code>' + esc(a[1]) + '</code>' + (isNaN(p) ? ' <span class="pv-note">(' + esc(l) + ')</span>' : ' <span class="pv-note">(' + fmt(p) + ')</span>');
    if (/rem$/.test(raw) && !isNaN(p)) return esc(raw) + ' <span class="pv-note">(' + fmt(p) + ')</span>';
    return '<code>' + esc(raw) + '</code>';
  }
  function isColor(n) { return /^(palette-|color-)/.test(n); }

  /* ---------- tier state ---------------------------------------------------- */
  function liveTier() {
    var d = cssVal('--breakpoint-desktop', root), t = cssVal('--breakpoint-tablet', root);
    return matchMedia('(min-width:' + d + ')').matches ? 2 : matchMedia('(min-width:' + t + ')').matches ? 1 : 0;
  }
  var simSel = 'live';
  function activeTier() { return simSel === 'live' ? liveTier() : +simSel; }

  // Tokens that depend (transitively) on a responsive token must be re-declared inside a
  // simulated scope, because alias values are resolved where they are declared (:root).
  var DEP = {};
  T.forEach(function (t) { if (t.r || t.fl) DEP[t.n] = 1; });
  for (var ch = true; ch;) {
    ch = false;
    T.forEach(function (t) {
      if (DEP[t.n]) return;
      var refs = t.v[0].match(/var\(--[a-z0-9-]+\)/g) || [];
      if (refs.some(function (r) { return DEP[r.slice(6, -1)]; })) { DEP[t.n] = 1; ch = true; }
    });
  }
  function applyTier(el, i) { Object.keys(DEP).forEach(function (n) { el.style.setProperty('--' + n, BY[n].fl ? BY[n].fp[i] + 'px' : BY[n].v[i]); }); }
  function clearTier(el) { Object.keys(DEP).forEach(function (n) { el.style.removeProperty('--' + n); }); }

  /* ---------- measuring probe (inside #sim so simulated values apply) ------- */
  var probe = document.createElement('div');
  probe.setAttribute('aria-hidden', 'true');
  probe.style.cssText = 'position:absolute;visibility:hidden;pointer-events:none;height:0;overflow:hidden';
  sim.appendChild(probe);
  function cpx(token) { probe.style.width = 'var(' + token + ')'; return probe.getBoundingClientRect().width; }

  /* ---------- renderers ----------------------------------------------------- */
  function renderStats() {
    var resp = T.filter(function (t) { return t.r; }).length, flu = T.filter(function (t) { return t.fl; }).length;
    $('stats').innerHTML = [
      [T.length, 'tokens'], [resp, 'tier tokens'], [flu, 'fluid tokens'], [T.length - resp - flu, 'static tokens'], [DATA.files.length, 'JSON files'], ['<span id="stat-tier">—</span>', 'current tier']
    ].map(function (s) { return '<div class="pv-stat"><b>' + s[0] + '</b><span>' + s[1] + '</span></div>'; }).join('');
  }

  function colorTile(t, sub) {
    var l = lit(t.v[0], 0), a = /^\{(.+)\}$/.exec(t.raw[0]);
    return '<div class="pv-color"><div class="pv-color__chip" style="--c: var(--' + t.n + ')"></div><div class="pv-color__body"><strong>--' + esc(t.n) + '</strong>' +
      (a ? '<span class="pv-color__alias">→ ' + esc(a[1]) + '</span>' : '') + '<span class="pv-hex">' + esc(l.toUpperCase()) + '</span>' + (t.d ? '<span class="pv-color__alias">' + esc(t.d) + '</span>' : '') + '</div></div>';
  }
  function renderColors() {
    var pal = T.filter(function (t) { return t.f === 'primitives'; });
    var groups = [['Primitive: brand', /^palette-rose/], ['Primitive: neutrals', /^palette-(white|ivory|blush|charcoal|neutral)/], ['Primitive: status', /^palette-(red|green|amber)/]];
    var h = groups.map(function (g) {
      return '<h3 class="pv-label pv-group-title">' + g[0] + '</h3><div class="pv-grid-auto">' + pal.filter(function (t) { return g[1].test(t.n); }).map(colorTile).join('') + '</div>';
    }).join('');
    var sem = T.filter(function (t) { return t.f === 'semantic'; }), seen = {};
    sem.forEach(function (t) { var k = t.n.split('-')[1]; (seen[k] = seen[k] || []).push(t); });
    h += Object.keys(seen).map(function (k) {
      return '<h3 class="pv-label pv-group-title">Semantic: ' + k + '</h3><div class="pv-grid-auto">' + seen[k].map(colorTile).join('') + '</div>';
    }).join('');
    $('render-colors').innerHTML = h;
  }

  var SAMPLE = { display: 'Radiant skin, simply', h1: 'Heading one', h2: 'Heading two', h3: 'Heading three', h4: 'Heading four', h5: 'Heading five', h6: 'Heading six', 'body-lg': 'Body large: lead paragraphs and introductions.', body: 'Body: the default reading size for descriptions and policies.', 'body-sm': 'Body small: supporting copy.', caption: 'Caption: fine print and helper text.', overline: 'Overline / eyebrow', label: 'Form label', button: 'Button text', nav: 'Navigation link', utility: 'Free shipping over $60', input: 'Input text', validation: 'Enter a valid email address.', 'product-title': 'Rosewater Barrier Serum', price: '$48.00', 'price-lg': '$48.00' };
  function renderType() {
    var roles = T.filter(function (t) { return /^type-.+-font-size$/.test(t.n); }).map(function (t) { return t.n.slice(5, -10); });
    $('render-type').innerHTML = roles.map(function (r) {
      var p = '--type-' + r + '-', fam = BY['type-' + r + '-font-family'].raw[0].replace(/^\{font\.family\.(.+)\}$/, '$1');
      var szTok = BY['font-size-' + r];
      var sizes = [0, 1, 2].map(function (i) { return fmt(tpx('font-size-' + r, i)); });
      var same = sizes[0] === sizes[1] && sizes[1] === sizes[2];
      var style = 'font-family:var(' + p + 'font-family);font-size:var(' + p + 'font-size);font-weight:var(' + p + 'font-weight);line-height:var(' + p + 'line-height);letter-spacing:var(' + p + 'letter-spacing);' + (BY['type-' + r + '-text-transform'] ? 'text-transform:var(' + p + 'text-transform);' : '') + 'margin:0';
      var wt = lit(BY['type-' + r + '-font-weight'].v[0], 0), lh = lit(BY['type-' + r + '-line-height'].v[0], 0), ls = lit(BY['type-' + r + '-letter-spacing'].v[0], 0);
      return '<div class="pv-spec"><div class="pv-spec__sample"><p data-spec style="' + style + '">' + esc(SAMPLE[r] || r) + '</p></div><div class="pv-spec__meta"><span><b>--type-' + r + '-*</b> · ' + fam + ' · ' + wt + ' · LH ' + lh + ' · LS ' + ls + '</span>' +
        '<span>' + (szTok && szTok.fl ? 'fluid: ' + sizes.join(' / ') + ' at 360 / 768 / 1280px' : szTok && szTok.r ? 'mobile ' + sizes[0] + ' · tablet ' + sizes[1] + ' · desktop ' + sizes[2] : 'fixed ' + sizes[0]) + ' · now <span class="pv-live" data-now></span></span></div></div>';
    }).join('');
  }

  function bars(id, names, withTiers) {
    $(id).innerHTML = names.map(function (n) {
      var t = BY[n], tiers = (t.r || t.fl) ? ' <span class="pv-note">(' + [0, 1, 2].map(function (i) { return fmt(tpx(n, i)); }).join(' / ') + (t.fl ? ' at 360 / 768 / 1280px, fluid' : '') + ')</span>' : '';
      return '<div class="pv-bar"><span class="pv-code">' + esc(n) + '</span><span class="pv-live" data-px="--' + n + '"></span><span><i style="--w: var(--' + n + ')"></i>' + (withTiers ? tiers : '') + '</span></div>';
    }).join('');
  }
  function renderSpacing() {
    bars('render-space-scale', T.filter(function (t) { return /^space-\d+$/.test(t.n) && t.n !== 'space-0'; }).map(function (t) { return t.n; }));
    bars('render-space-resp', T.filter(function (t) { return (t.r || t.fl) && (/^space-/.test(t.n) || t.n === 'layout-gutter' || t.n === 'layout-grid-gap'); }).map(function (t) { return t.n; }), true);
  }
  function renderLayout() {
    $('render-containers').innerHTML = T.filter(function (t) { return /^container-/.test(t.n); }).map(function (t) {
      return '<div class="pv-container-bar" style="--w: var(--' + t.n + ')">--' + t.n + ' · ' + fmt(tpx(t.n, 0)) + '</div>';
    }).join('');
    var cols = T.filter(function (t) { return /^grid-columns-/.test(t.n); });
    $('render-grids').innerHTML = cols.map(function (t) {
      var max = Math.max.apply(null, t.v.map(Number)), count = max * 2;
      var cells = ''; for (var k = 1; k <= count; k++) cells += '<div class="pv-demo">' + k + '</div>';
      return '<div><p class="pv-label" style="margin-bottom:var(--space-2)">--' + t.n + ' = <span class="pv-live" data-col="--' + t.n + '"></span> <span class="pv-note">(' + t.v.join(' / ') + ')</span></p><div class="pv-cols" style="--cols: var(--' + t.n + ')">' + cells + '</div></div>';
    }).join('');
    $('render-aspects').innerHTML = T.filter(function (t) { return /^aspect-/.test(t.n); }).map(function (t) {
      return '<div style="display:grid;gap:var(--space-2)"><div class="pv-aspect" style="--ar: var(--' + t.n + ')">' + esc(cssVal('--' + t.n, root)) + '</div><span class="pv-note">--' + t.n + (t.r ? ' (responsive)' : '') + '</span></div>';
    }).join('');
  }
  function renderBreakpoints() {
    var bp = T.filter(function (t) { return t.f === 'breakpoints'; });
    $('render-bp').innerHTML = bp.map(function (t) { return '<tr><td class="pv-name">--' + t.n + '</td><td>' + disp(t, 0) + '</td><td>' + esc(t.d) + '</td></tr>'; }).join('');
    var tb = tpx('breakpoint-tablet', 0), dk = tpx('breakpoint-desktop', 0), MAX = 1600;
    $('render-ruler').innerHTML =
      '<div class="pv-ruler__zone" style="left:0;width:' + tb / MAX * 100 + '%">Mobile · 0–' + (tb - 1) + '</div>' +
      '<div class="pv-ruler__zone" style="left:' + tb / MAX * 100 + '%;width:' + (dk - tb) / MAX * 100 + '%">Tablet · ' + tb + '–' + (dk - 1) + '</div>' +
      '<div class="pv-ruler__zone" style="left:' + dk / MAX * 100 + '%;width:' + (MAX - dk) / MAX * 100 + '%">Desktop · ' + dk + '+</div>' +
      '<div class="pv-ruler__now" id="ruler-now"></div>';
  }
  function updateRuler() {
    var n = $('ruler-now'); if (!n) return;
    var w = window.innerWidth; n.style.left = Math.min(w, 1600) / 1600 * 100 + '%';
    n.setAttribute('data-label', w + 'px'); n.classList.toggle('pv-ruler__now--end', w > 1400);
  }
  function renderEffects() {
    var tile = function (t, box, extra) { return '<div class="pv-tile"><div class="pv-tile__box" style="' + box + '"></div><span><span class="pv-code">--' + t.n + '</span> ' + esc(extra || lit(t.v[0], 0)) + '</span></div>'; };
    $('render-radius').innerHTML = T.filter(function (t) { return /^radius-(none|sm|md|lg|pill)$/.test(t.n); }).map(function (t) { return tile(t, 'border-radius:var(--' + t.n + ');border-color:var(--color-border-strong)'); }).join('');
    $('render-borders').innerHTML = T.filter(function (t) { return /^border-width-/.test(t.n); }).map(function (t) { return tile(t, 'border:var(--' + t.n + ') solid var(--color-text-primary);border-radius:var(--radius-sm)'); }).join('');
    $('render-shadows').innerHTML = T.filter(function (t) { return /^shadow-(sm|md|lg)$/.test(t.n); }).map(function (t) { return tile(t, 'box-shadow:var(--' + t.n + ');border-radius:var(--radius-md)', t.n.slice(7)); }).join('');
    $('render-opacity').innerHTML = T.filter(function (t) { return /^opacity-/.test(t.n); }).map(function (t) { return tile(t, 'background:var(--color-brand-primary);opacity:var(--' + t.n + ');border-radius:var(--radius-sm)'); }).join('');
    var mo = [['duration-fast', 'ease-standard'], ['duration-base', 'ease-standard'], ['duration-slow', 'ease-standard'], ['duration-slow', 'ease-out']];
    $('render-motion').innerHTML = mo.map(function (m) {
      return '<div><div class="pv-motion" tabindex="0" style="--d:var(--' + m[0] + ');--e:var(--' + m[1] + ');--shift:6rem"><i></i></div><p class="pv-note" style="margin-top:var(--space-1)">--' + m[0] + ' (' + lit(BY[m[0]].v[0], 0) + ') + --' + m[1] + '</p></div>';
    }).join('');
    document.querySelectorAll('.pv-motion').forEach(function (m) { m.addEventListener('click', function () { m.classList.toggle('is-on'); }); });
    var z = T.filter(function (t) { return /^z-/.test(t.n); });
    $('render-z').innerHTML = z.slice().reverse().map(function (t, k) { return '<div style="--i:' + k + '"><span>--' + t.n + '</span><b>' + t.raw[0] + '</b></div>'; }).join('');
  }

  var STAR = '<svg class="on" aria-hidden="true" focusable="false"><use href="#i-star"/></svg>';
  function pcard(name, price, badge, extra, soldout) {
    return '<article class="pv-pcard"><div class="pv-pcard__media"><div class="pv-img" style="' + (soldout ? 'opacity:var(--opacity-muted)' : '') + '"><i></i></div>' + (badge ? '<div class="pv-pcard__badges">' + badge + '</div>' : '') + '</div>' +
      '<div class="pv-pcard__body"><p class="pv-label">NUDGE</p><h4 class="pv-pcard__title">' + name + '</h4><span class="pv-rating"><span class="pv-stars" role="img" aria-label="Rated 5 out of 5">' + STAR + STAR + STAR + STAR + STAR + '</span>5.0 (86)</span>' + price + '</div>' + (extra || '') + '</article>';
  }
  function renderProductCards() {
    $('render-pcards').innerHTML =
      pcard('Rosewater Barrier Serum', '<span class="pv-price"><span class="pv-price__now">$48.00</span></span>', '', '<button class="pv-btn pv-btn--secondary pv-btn--sm pv-btn--block" type="button">Add to bag</button>') +
      pcard('Overnight Peptide Cream', '<span class="pv-price pv-price--sale"><span class="pv-price__now">$38.00</span><s>$48.00</s></span>', '<span class="pv-badge pv-badge--brand">Sale −20%</span>', '<button class="pv-btn pv-btn--secondary pv-btn--sm pv-btn--block" type="button">Add to bag</button>') +
      pcard('Velvet Tint Lip Balm', '<span class="pv-price"><span class="pv-price__now">$24.00</span></span>', '<span class="pv-badge">New</span>', '<button class="pv-btn pv-btn--secondary pv-btn--sm pv-btn--block" type="button">Choose shade</button>') +
      pcard('Cloud Cleansing Balm', '<span class="pv-price"><span class="pv-price__now">$32.00</span></span>', '<span class="pv-badge pv-badge--dark">Sold out</span>', '<button class="pv-btn pv-btn--secondary pv-btn--sm pv-btn--block" type="button" disabled>Sold out</button>', true);
  }

  function renderCompare() {
    var h = '';
    [0, 1, 2].forEach(function (i) {
      var rng = ['0–' + (tpx('breakpoint-tablet', 0) - 1) + 'px', tpx('breakpoint-tablet', 0) + '–' + (tpx('breakpoint-desktop', 0) - 1) + 'px', tpx('breakpoint-desktop', 0) + 'px+'][i];
      var box = ''; var n = +BY['grid-columns-products'].v[i] * 2; for (var k = 1; k <= n; k++) box += '<div class="pv-demo">' + k + '</div>';
      h += '<div class="pv-frame" data-frame="' + i + '"><div class="pv-frame__bar"><span>' + TIERS[i] + '</span><span>' + rng + '</span></div><div class="pv-frame__body">' +
        '<p style="font-family:var(--type-display-font-family);font-size:var(--type-display-font-size);font-weight:var(--type-display-font-weight);line-height:var(--type-display-line-height);letter-spacing:var(--type-display-letter-spacing)">Radiant skin</p>' +
        '<h3 style="font-family:var(--type-h1-font-family);font-size:var(--type-h1-font-size);font-weight:var(--type-h1-font-weight);line-height:var(--type-h1-line-height);letter-spacing:var(--type-h1-letter-spacing);margin:0">Heading one</h3>' +
        '<h4 style="font-family:var(--type-h3-font-family);font-size:var(--type-h3-font-size);font-weight:var(--type-h3-font-weight);line-height:var(--type-h3-line-height);margin:0">Heading three</h4>' +
        '<p style="font-size:var(--type-body-lg-font-size);line-height:var(--type-body-lg-line-height);margin:0">Body large paragraph shows how reading size steps between tiers.</p>' +
        '<div class="pv-row"><button class="pv-btn pv-btn--primary pv-btn--lg" type="button">Large CTA</button><button class="pv-btn pv-btn--secondary" type="button">Medium</button></div>' +
        '<div class="pv-cols" style="--cols:var(--grid-columns-products)">' + box + '</div>' +
        '<div class="pv-frame__sec" style="padding-block:var(--space-section)">section padding ' + fmt(tpx('space-section', i)) + '</div>' +
        '<p class="pv-note">gutter ' + fmt(tpx('layout-gutter', i)) + ' · grid gap ' + fmt(tpx('layout-grid-gap', i)) + ' · ' + BY['grid-columns-products'].v[i] + ' product columns · header ' + fmt(tpx('layout-header-height', i)) + ' · large control ' + fmt(tpx('control-height-lg', i)) + '</p>' +
        '</div></div>';
    });
    $('render-compare').innerHTML = h;
    document.querySelectorAll('[data-frame]').forEach(function (f) { applyTier(f, +f.getAttribute('data-frame')); });
  }

  function renderMatrix() {
    var rows = T.filter(function (t) { return t.r; }).map(function (t) {
      return '<tr><td class="pv-name">--' + t.n + '</td>' + [0, 1, 2].map(function (i) { return '<td data-tier-col="' + i + '">' + disp(t, i) + '</td>'; }).join('') + '</tr>';
    });
    var fluid = T.filter(function (t) { return t.fl; });
    if (fluid.length) rows.push('<tr><th colspan="4" scope="colgroup" class="pv-src">Fluid tokens (clamp): size at 360 / 768 / 1280px, the reference width of each tier</th></tr>');
    fluid.forEach(function (t) { rows.push('<tr><td class="pv-name">--' + t.n + '</td>' + [0, 1, 2].map(function (i) { return '<td data-tier-col="' + i + '">' + fmt(t.fp[i]) + '</td>'; }).join('') + '</tr>'); });
    $('render-matrix').innerHTML = rows.join('');
  }

  function renderTokens() {
    var q = $('tok-q').value.trim().toLowerCase(), f = $('tok-f').value, ro = $('tok-r').checked, uo = $('tok-u').checked;
    var rows = T.filter(function (t) {
      if (f && t.f !== f) return false; if (ro && !t.r) return false; if (uo && (t.ar || t.ur || t.dr)) return false;
      return !q || t.n.indexOf(q) > -1 || t.p.indexOf(q) > -1 || t.d.toLowerCase().indexOf(q) > -1 || t.raw.join(' ').toLowerCase().indexOf(q) > -1;
    });
    $('tok-count').textContent = rows.length + ' of ' + T.length + ' tokens';
    $('render-tokens').innerHTML = rows.map(function (t) {
      var dot = isColor(t.n) ? '<span class="pv-dot" style="--c:var(--' + t.n + ')"></span>' : '';
      var cells = t.r ? [0, 1, 2].map(function (i) { return '<td data-tier-col="' + i + '">' + disp(t, i) + '</td>'; }).join('') : '<td colspan="3">' + dot + disp(t, 0) + '</td>';
      var refs = [t.ar ? t.ar + ' token' + (t.ar > 1 ? 's' : '') : '', t.ur ? t.ur + ' in dashboard' : '', t.dr ? t.dr + ' in design system' : ''].filter(Boolean).join(' · ') || '<span class="pv-known">none</span>';
      return '<tr><td class="pv-name">--' + t.n + '</td>' + cells + '<td class="pv-src">' + t.f + ' › <code>' + esc(t.p) + '</code></td><td class="pv-src">' + refs + '</td></tr>';
    }).join('');
    markCols();
  }

  /* ---------- live refresh ---------------------------------------------------- */
  function markCols() {
    var a = activeTier();
    document.querySelectorAll('[data-tier-col]').forEach(function (c) { c.classList.toggle('is-active', +c.getAttribute('data-tier-col') === a); });
  }
  function refresh() {
    var a = activeTier(), l = liveTier();
    document.querySelectorAll('[data-px]').forEach(function (e) { e.textContent = fmt(cpx(e.getAttribute('data-px'))); });
    document.querySelectorAll('[data-col]').forEach(function (e) { e.textContent = cssVal(e.getAttribute('data-col')); });
    document.querySelectorAll('[data-spec]').forEach(function (s) { var o = s.closest('.pv-spec').querySelector('[data-now]'); if (o) o.textContent = fmt(parseFloat(cs(s).fontSize)); });
    var hv = { 'hv-header': fmt(cpx('--layout-header-height')), 'hv-gutter': fmt(cpx('--layout-gutter')), 'hv-drawer': cssVal('--layout-drawer-width') };
    Object.keys(hv).forEach(function (k) { if ($(k)) $(k).textContent = hv[k]; });
    $('tier-readout').innerHTML = (simSel === 'live' ? 'Live: ' : 'Simulating: ') + '<b>' + TIERS[a] + '</b>' + (simSel === 'live' ? ' · ' + window.innerWidth + 'px' : ' (window is ' + TIERS[l] + ', ' + window.innerWidth + 'px)');
    var st = $('stat-tier'); if (st) st.textContent = TIERS[l];
    markCols(); updateRuler();
  }

  /* ---------- validation ------------------------------------------------------ */
  function hex(s) { var m = /^#([0-9a-f]{6})$/i.exec(s.trim()); return m ? [0, 2, 4].map(function (k) { return parseInt(m[1].substr(k, 2), 16) / 255; }) : null; }
  function lum(c) { var x = c.map(function (v) { return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); }); return 0.2126 * x[0] + 0.7152 * x[1] + 0.0722 * x[2]; }
  function ratio(a, b) { var x = lum(a), y = lum(b); return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05); }
  var PAIRS = [
    ['color-text-primary', 'color-bg-page', 4.5], ['color-text-primary', 'color-bg-surface', 4.5], ['color-text-primary', 'color-bg-subtle', 4.5],
    ['color-text-secondary', 'color-bg-page', 4.5], ['color-text-secondary', 'color-bg-subtle', 4.5],
    ['color-text-muted', 'color-bg-page', 4.5], ['color-text-muted', 'color-bg-surface', 4.5], ['color-text-muted', 'color-bg-subtle', 4.5],
    ['color-text-on-brand', 'color-brand-primary', 4.5], ['color-button-primary-text', 'color-button-primary-bg-hover', 4.5], ['color-button-primary-text', 'color-button-primary-bg-active', 4.5],
    ['color-link', 'color-bg-page', 4.5], ['color-link', 'color-bg-surface', 4.5], ['color-link-hover', 'color-bg-page', 4.5], ['color-price-sale', 'color-bg-surface', 4.5],
    ['color-status-error', 'color-status-error-bg', 4.5], ['color-status-success', 'color-status-success-bg', 4.5], ['color-status-warning', 'color-status-warning-bg', 4.5],
    ['color-text-inverse', 'color-bg-inverse', 4.5], ['color-button-disabled-text', 'color-button-disabled-bg', 4.5],
    ['color-focus-ring', 'color-bg-page', 3], ['color-focus-ring', 'color-bg-surface', 3], ['color-focus-ring', 'color-bg-subtle', 3],
    ['color-border-strong', 'color-bg-page', 3], ['color-border-strong', 'color-bg-surface', 3], ['color-border-strong', 'color-bg-subtle', 3, 1],
    ['color-rating-star', 'color-bg-surface', 3], ['color-control-selected', 'color-bg-surface', 3],
    ['color-text-on-brand', 'color-brand-secondary', 4.5], ['color-brand-secondary', 'color-bg-page', 4.5], ['color-text-primary', 'color-brand-accent', 4.5], ['color-text-on-brand', 'color-brand-accent', 4.5, 1],
    ['color-text-inverse-secondary', 'color-bg-inverse', 4.5], ['color-link-inverse', 'color-bg-inverse', 4.5], ['color-link-inverse-hover', 'color-bg-inverse', 4.5],
    ['color-focus-ring-inverse', 'color-bg-inverse', 3], ['color-border-inverse', 'color-bg-inverse', 3], ['color-focus-ring', 'color-bg-inverse', 3, 1]
  ];

  function runValidation() {
    var rootCs = cs(root), li = liveTier(), bad = [], missing = 0;
    var pr = document.createElement('div'); pr.style.display = 'none'; document.body.appendChild(pr);
    T.forEach(function (t) {
      var actual = rootCs.getPropertyValue('--' + t.n).trim();
      pr.style.setProperty('--probe', t.v[li]);
      var want = cs(pr).getPropertyValue('--probe').trim();
      if (actual === '') { missing++; bad.push('--' + t.n + ': not defined in the CSS'); }
      else if (actual !== want) bad.push('--' + t.n + ': CSS "' + actual + '" ≠ JSON "' + want + '"');
    });
    pr.remove();
    var groups = [];
    groups.push({ title: 'JSON ↔ CSS consistency (live tier: ' + TIERS[li] + ')', rows: [
      { s: bad.length ? 'fail' : 'pass', l: 'Every token resolves to the value defined in the JSON', d: (T.length - bad.length) + ' of ' + T.length + ' match' + (bad.length ? '. See the mismatch table below' : '') },
      { s: missing ? 'fail' : 'pass', l: 'No token is missing from the CSS', d: missing + ' missing' }
    ], note: 'This runs at the tier your window is in. Resize the window (or use device mode) to re-run at another tier. The build-time test covered all three tiers.' });

    if (bad.length) groups.push({ title: 'Mismatches (' + bad.length + (bad.length > 100 ? ', first 100 shown' : '') + ')', rows: bad.slice(0, 100).map(function (m) { return { s: 'fail', l: m, d: '' }; }) });
    var refs = 0; T.forEach(function (t) { t.v.forEach(function (v) { (v.match(/var\(--([a-z0-9-]+)\)/g) || []).forEach(function (r) { if (!BY[r.slice(6, -1)]) refs++; }); }); });
    var spaceBad = T.filter(function (t) { return /^space-\d+$/.test(t.n) && tpx(t.n, 0) % 4 !== 0; }).map(function (t) { return t.n; });
    var bpOk = tpx('breakpoint-tablet', 0) < tpx('breakpoint-desktop', 0) && tpx('breakpoint-desktop', 0) < tpx('breakpoint-wide', 0);
    var mono = [];
    T.forEach(function (t) { if (t.fl) { if (t.fp[1] < t.fp[0] || t.fp[2] < t.fp[1]) mono.push(t.n); return; } if (!t.r) return; var n = [0, 1, 2].map(function (i) { return num(lit(t.v[i], i)); }); if (n.some(isNaN)) return; if (n[1] < n[0] || n[2] < n[1]) mono.push(t.n); });
    var hier = [];
    [0, 1, 2].forEach(function (i) { var o = ['display', 'h1', 'h2', 'h3', 'h4', 'h5'].map(function (r) { return tpx('font-size-' + r, i); }); for (var k = 1; k < o.length; k++) if (o[k] > o[k - 1] || (k < 5 && o[k] === o[k - 1])) hier.push(TIERS[i] + ' ' + k); if (o[5] < tpx('font-size-body', i)) hier.push(TIERS[i] + ' h5<body'); });
    groups.push({ title: 'Structure', rows: [
      { s: refs ? 'fail' : 'pass', l: 'All alias references point to existing tokens', d: refs + ' broken' },
      { s: 'info', l: 'Tokens with no static reference (see All tokens › Not referenced)', d: T.filter(function (t) { return !t.ar && !t.ur && !t.dr; }).length + ' of ' + T.length + ': mostly scale/API tokens and runtime-built references; candidates to review, not proof of dead tokens' },
      { s: spaceBad.length ? 'fail' : 'pass', l: 'Spacing scale sits on the 4px grid', d: spaceBad.length ? spaceBad.join(', ') : 'all multiples of 4px' },
      { s: bpOk ? 'pass' : 'fail', l: 'Breakpoints ascend (tablet < desktop < wide)', d: fmt(tpx('breakpoint-tablet', 0)) + ' < ' + fmt(tpx('breakpoint-desktop', 0)) + ' < ' + fmt(tpx('breakpoint-wide', 0)) },
      { s: mono.length ? 'fail' : 'pass', l: 'Tier and fluid tokens never shrink as the viewport grows', d: mono.length ? mono.join(', ') : 'checked on ' + T.filter(function (t) { return t.r || t.fl; }).length + ' tier and fluid tokens where values are numeric' },
      { s: hier.length ? 'fail' : 'pass', l: 'Type hierarchy holds in every tier (display > h1 > … > h5 ≥ body)', d: hier.length ? hier.join(', ') : 'mobile, tablet, desktop' }
    ] });

    var us = [], rules = [];
    function min(label, name, lim, tiers) { var vals = [0, 1, 2].map(function (i) { return tpx(name, i); }); var ok = vals.every(function (v) { return v >= lim; }); rules.push({ s: ok ? 'pass' : 'fail', l: label, d: vals.map(fmt).join(' / ') + ' (needs ≥ ' + lim + 'px)' }); }
    min('Body text ≥ 16px in every tier', 'font-size-body', 16);
    min('Input text ≥ 16px (prevents iOS zoom)', 'font-size-input', 16);
    min('Touch target minimum ≥ 44px', 'touch-target-min', 44);
    min('Default control height (buttons, inputs, selects) ≥ 44px', 'control-height-md', 44);
    min('Large button height ≥ 44px', 'control-height-lg', 44);
    function hit(el) {
      var r = el.getBoundingClientRect(), w = r.width, h = r.height;
      ['::after', '::before'].forEach(function (ps) { var s = getComputedStyle(el, ps); if (s.position === 'absolute' && s.content !== 'none') { w = Math.max(w, parseFloat(s.width) || 0); h = Math.max(h, parseFloat(s.height) || 0); } });
      return [w, h];
    }
    var targets = [].slice.call(document.querySelectorAll('#components .pv-btn:not(:disabled), #components .pv-qty button, #components .pv-swatch:not(.pv-swatch--sm), #components .pv-choice, #components .pv-thumb, #components .pv-iconbtn, .pv-sim__seg button'));
    var tooSmall = targets.filter(function (e) { var s = hit(e); return s[0] < 43.5 || s[1] < 43.5; });
    rules.push({ s: tooSmall.length ? 'fail' : 'pass', l: 'Every interactive specimen has a 44 × 44px target (its box, or an invisible hit area)', d: targets.length + ' measured' + (tooSmall.length ? '; below 44px: ' + tooSmall.slice(0, 5).map(function (e) { return e.className; }).join(', ') : '; the 40px small button measures 44px through its hit area') });    var cardR = cssVal('--product-image-aspect-card').split('/').map(Number), thumbR = cssVal('--product-image-aspect-thumb').split('/').map(Number), keepFrac = Math.min(1, (cardR[0] / cardR[1]) / (thumbR[0] / thumbR[1]));
    rules.push({ s: keepFrac >= 0.8 ? 'pass' : 'fail', l: 'A square thumbnail keeps at least 80% of a card-ratio image (the imagery guideline says "central 80%")', d: Math.round(keepFrac * 100) + '% of the height survives (from --product-image-aspect-card and -aspect-thumb); if this changes, update the guideline' });
    var rail = document.querySelector('.pv-thumbs--rail'), thumbSize = tpx('product-image-thumb-size', 0);
    if (rail) rules.push({ s: document.documentElement.scrollWidth <= window.innerWidth + 1 ? 'pass' : 'fail', l: 'The thumbnail rail never widens the page', d: rail.children.length + ' thumbnails at ' + fmt(thumbSize) + ' need ' + fmt(rail.children.length * thumbSize + (rail.children.length - 1) * tpx('product-image-thumb-gap', 0)) + '; the rail is ' + fmt(rail.clientWidth) + ' wide and scrolls' + (rail.scrollWidth > rail.clientWidth + 1 ? ' (it overflows, as designed)' : '') });
    var fam = document.fonts ? ['DM Sans', 'Cormorant'].map(function (f) { return document.fonts.check('16px "' + f + '"') ? f + ' loaded' : f + ' using fallback'; }) : [];
    rules.push({ s: fam.every(function (x) { return /loaded/.test(x); }) ? 'pass' : 'known', l: 'Brand fonts available in this page', d: fam.join(' · ') || 'FontFaceSet not supported' });
    groups.push({ title: 'Usability rules', rows: rules });
    var dr = DRAWER_WIDTHS.map(measureDrawer), cap = 26 * 16, wide = dr.filter(function (x) { return tierForWidth(x.W) > 0; }), maxWide = Math.max.apply(null, wide.map(function (x) { return x.dw; }));
    groups.push({ title: 'Drawer width token (--layout-drawer-width): full-width sheet on phones, 26rem panel from 600px, measured at 8 viewport widths', rows: dr.map(function (x) {
      var sheet = tierForWidth(x.W) === 0, shape = sheet ? Math.abs(x.under) <= 0.5 : Math.abs(x.dw - cap) <= 0.5 && x.under >= 43.5;
      var ok = shape && x.closeIn && x.close >= 43.5 && !x.overflowX && x.scrolls && x.lastReach && x.footIn;
      return { s: ok ? 'pass' : 'fail', l: 'Viewport ' + x.W + 'px (' + (sheet ? 'phone sheet' : 'side panel') + ')', d: 'drawer ' + fmt(x.dw) + (sheet ? ' = the whole frame (' + fmt(x.inner) + ' inside its 1px border)' : ' · ' + fmt(x.under) + ' of the page left beside it') + ' · close button ' + fmt(x.close) + ' and inside · no horizontal overflow · body scrolls and the last row is reachable · footer action visible' };
    }).concat([{ s: maxWide <= cap + 0.5 ? 'pass' : 'fail', l: 'From 600px the drawer never exceeds 26rem', d: 'widest ' + fmt(maxWide) + ' of ' + fmt(cap) }]), note: 'A phone sheet has no page strip to tap, so the close button is the only on-screen way out: it is 44 × 44px and inside the sheet in every row. Keyboard behavior (focus trap, Escape to close, returning focus) is JavaScript and is not part of the token; it needs manual testing with the real drawer.' });
    if (focusResults.length) groups.push({ title: 'Focus ring on surfaces (real keyboard focus, measured from the rendered outline)', rows: focusResults, note: 'Each surface holds a button that was focused with focus(); the ring colour, width and offset are read from the browser and the ring is compared with the surface it sits on (needs 3:1, solid, ≥ 2px, offset ≥ 2px). Focus is a shape (an outline), never a colour change alone. Do not place bare focusable controls on photography: use a solid container.' });

    var crow = PAIRS.map(function (p) {
      var f = hex(cssVal('--' + p[0], root)), b = hex(cssVal('--' + p[1], root));
      if (!f || !b) return null;
      var r = ratio(f, b), ok = r >= p[2];
      return { s: ok ? (p[3] ? 'warn' : 'pass') : (p[3] ? 'known' : 'fail'), p: p, r: r };
    }).filter(Boolean);
    groups.push({ title: 'Contrast (WCAG 2.x)', contrast: crow });

    var all = [];
    groups.forEach(function (g) { (g.rows || g.contrast).forEach(function (x) { all.push(x.s); }); });
    var nChecks = all.filter(function (s) { return s !== 'info'; }).length, fails = all.filter(function (s) { return s === 'fail'; }).length, known = all.filter(function (s) { return s === 'known'; }).length, warn = all.filter(function (s) { return s === 'warn'; }).length;
    var label = { pass: ['pv-pass', 'Pass'], fail: ['pv-fail', 'Fail'], known: ['pv-known', 'Known'], warn: ['pv-known', 'Check'], info: ['pv-src', 'Info'] };
    $('render-validation').innerHTML = groups.map(function (g) {
      var body;
      if (g.contrast) {
        body = '<div class="pv-tablewrap" tabindex="0" role="region" aria-label="' + esc(g.title) + ' (scrollable)"><table class="pv-table" style="min-width:36rem"><thead><tr><th scope="col">Sample</th><th scope="col">Pair</th><th scope="col">Ratio</th><th scope="col">Needs</th><th scope="col">Result</th></tr></thead><tbody>' +
          g.contrast.map(function (x) {
            var res = x.s === 'known' ? 'Known fail (documented rule)' : x.s === 'warn' ? 'Passes, but this pair is documented as not allowed' : x.s === 'pass' ? 'Pass' : 'Fail';
            return '<tr><td><span class="pv-swatch-pair" style="--bg:var(--' + x.p[1] + ');--fg:var(--' + x.p[0] + ')">Aa</span></td><td class="pv-name">' + x.p[0].replace('color-', '') + ' on ' + x.p[1].replace('color-', '') + '</td><td>' + x.r.toFixed(2) + ':1</td><td>' + x.p[2] + ':1</td><td class="' + label[x.s][0] + '">' + res + '</td></tr>';
          }).join('') + '</tbody></table></div>';
      } else {
        body = '<div class="pv-tablewrap" tabindex="0" role="region" aria-label="' + esc(g.title) + ' (scrollable)"><table class="pv-table" style="min-width:30rem"><thead><tr><th scope="col">Check</th><th scope="col">Result</th><th scope="col">Detail</th></tr></thead><tbody>' +
          g.rows.map(function (x) { return '<tr><td>' + esc(x.l) + '</td><td class="' + label[x.s][0] + '">' + label[x.s][1] + '</td><td>' + esc(x.d) + '</td></tr>'; }).join('') + '</tbody></table></div>';
      }
      return '<div><h3 class="pv-label" style="margin-bottom:var(--space-2)">' + g.title + '</h3>' + body + (g.note ? '<p class="pv-note" style="margin-top:var(--space-2)">' + g.note + '</p>' : '') + '</div>';
    }).join('');
    var st = $('overall-status');
    st.className = 'pv-status ' + (fails ? 'pv-status--fail' : 'pv-status--pass');
    st.textContent = (fails ? fails + ' check(s) FAILED' : 'All checks passed') + ' · ' + nChecks + ' checks' + (known ? ' · ' + known + ' known/documented' : '') + (warn ? ' · ' + warn + ' to review' : '');
    window.__nudgeValidation = { total: nChecks, fails: fails, known: known, warn: warn, mismatches: bad.length, tier: li };
  }

  /* ---------- product-image and drawer specimens ------------------------------------- */
  function pic(w, h, bg, parts) { return 'data:image/svg+xml,' + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ' + w + ' ' + h + '" width="' + w + '" height="' + h + '"><rect width="' + w + '" height="' + h + '" fill="' + bg + '"/>' + parts + '</svg>'); }
  var BOTTLE = '<rect x="%X%" y="%Y%" width="%W%" height="%H%" rx="14" fill="#713448"/><rect x="%CX%" y="%CY%" width="%CW%" height="%CH%" rx="6" fill="#292126"/>';
  function bottle(w, h, bw, bh, bg) { var x = (w - bw) / 2, y = (h - bh) / 2, cw = bw * 0.5, ch = bh * 0.14; return pic(w, h, bg, '<rect x="' + x + '" y="' + (y + ch) + '" width="' + bw + '" height="' + (bh - ch) + '" rx="14" fill="#713448"/><rect x="' + (w - cw) / 2 + '" y="' + y + '" width="' + cw + '" height="' + ch + '" rx="6" fill="#292126"/>'); }
  var IMG = {
    serum: bottle(400, 500, 96, 320, '#F3ECE6'),     // tall slim bottle, standard 4:5 canvas
    jar: pic(400, 500, '#F3ECE6', '<rect x="90" y="215" width="220" height="130" rx="18" fill="#713448"/><rect x="100" y="185" width="200" height="40" rx="10" fill="#292126"/>'),   // wide short jar, same canvas
    raw: bottle(200, 600, 120, 560, '#F3ECE6')       // a raw 1:3 photo, no canvas
  };
  function renderPackaging() {
    var card = cssVal('--product-image-aspect-card').split('/').map(Number), th = cssVal('--product-image-aspect-thumb').split('/').map(Number);
    var cr = card[0] / card[1], tr = th[0] / th[1];
    var keep = Math.round(Math.min(1, cr / tr) * 100), rawKeep = Math.round(Math.min(1, (1 / 3) / cr) * 100);
    var fig = function (src, cls, alt, cap) { return '<figure><div class="pv-img ' + cls + '"><img src="' + src + '" alt="' + alt + '" width="400" height="500"></div><figcaption>' + cap + '</figcaption></figure>'; };
    var thumbs = function (items) { return '<div class="pv-thumbs pv-thumbs--rail" role="group" aria-label="Gallery thumbnails" style="max-width:100%">' + items.map(function (s, i) { return '<button class="pv-thumb" type="button" aria-label="Show image ' + (i + 1) + '"' + (i === 0 ? ' aria-current="true"' : '') + '><img src="' + s + '" alt=""></button>'; }).join('') + '</div>'; };
    $('render-packaging').innerHTML =
      '<div><p class="pv-label" style="margin-bottom:var(--space-2)">Card frame (4:5) with different packaging</p><div class="pv-pack">' +
        fig(IMG.serum, '', 'Tall slim serum bottle', 'Tall bottle on a 4:5 canvas (recommended)') + fig(IMG.jar, '', 'Wide short cream jar', 'Wide jar on the same canvas') +
        fig(IMG.raw, '', 'Tall bottle, uncropped 1:3 photo', 'Raw 1:3 photo, <b>cover</b>: only the middle ' + rawKeep + '% of its height shows') +
        fig(IMG.raw, 'pv-img--contain', 'Tall bottle, uncropped 1:3 photo', 'Same photo, <b>contain</b>: whole product, bars on the sides') + '</div></div>' +
      '<div><p class="pv-label" style="margin-bottom:var(--space-2)">Gallery thumbnails (<span class="pv-live" data-px="--product-image-thumb-size"></span> square; a rail that scrolls when they do not fit)</p>' +
        thumbs([IMG.serum, IMG.jar, IMG.serum, IMG.jar, IMG.serum, IMG.jar]) +
        '<p class="pv-note" style="margin-top:var(--space-2)">A square thumbnail of a 4:5 image keeps <b>' + keep + '%</b> of its height (computed from the aspect tokens): keep key content inside the central ' + keep + '%.</p></div>';
    renderPackaging.keep = keep;
  }
  var DRAWER_WIDTHS = [320, 360, 390, 430, 600, 768, 1024, 1440];
  /* A simulated frame takes the tier its own width belongs to (the window's media queries do not apply to it). */
  function tierForWidth(W) { return W >= num(cssVal('--breakpoint-desktop', root)) ? 2 : W >= num(cssVal('--breakpoint-tablet', root)) ? 1 : 0; }
  function drawerInner() {
    var rows = ''; for (var k = 1; k <= 14; k++) rows += '<label class="pv-choice"><input type="checkbox"><span>Filter option ' + k + '</span></label>';
    return '<div class="pv-under"><p>Page content stays visible beside the drawer.</p></div><div class="pv-scrimfill"></div><aside class="pv-drawer" aria-label="Filters"><div class="pv-drawer__head"><strong>Filters</strong><button class="pv-iconbtn" type="button" aria-label="Close filters">&times;</button></div><div class="pv-drawer__body">' + rows + '</div><div class="pv-drawer__foot"><button class="pv-btn pv-btn--primary pv-btn--block" type="button">Show 24 products</button></div></aside>';
  }
  function renderDrawer() {
    $('drawer-widths').innerHTML = [320, 390, 768, 1280].map(function (w, i) { return '<button class="pv-btn pv-btn--secondary pv-btn--sm" type="button" data-dw="' + w + '" aria-pressed="' + (i === 1) + '">' + w + 'px</button>'; }).join('');
    $('render-drawer').innerHTML = '<div class="pv-frameview" id="drawer-frame" style="--w:390px">' + drawerInner() + '</div>';
    applyTier($('drawer-frame'), tierForWidth(390));
    $('drawer-widths').addEventListener('click', function (e) { var b = e.target.closest('[data-dw]'); if (!b) return; [].forEach.call($('drawer-widths').children, function (x) { x.setAttribute('aria-pressed', String(x === b)); }); $('drawer-frame').style.setProperty('--w', b.getAttribute('data-dw') + 'px'); applyTier($('drawer-frame'), tierForWidth(+b.getAttribute('data-dw'))); });
  }
  function measureDrawer(W) {
    var f = document.createElement('div'); f.className = 'pv-frameview'; f.style.cssText = 'position:absolute;left:-99999px;top:0;max-width:none;width:' + W + 'px'; f.innerHTML = drawerInner(); sim.appendChild(f); applyTier(f, tierForWidth(W));
    var d = f.querySelector('.pv-drawer'), fr = f.getBoundingClientRect(), dr = d.getBoundingClientRect(), cb = f.querySelector('.pv-iconbtn').getBoundingClientRect(), body = f.querySelector('.pv-drawer__body'), foot = f.querySelector('.pv-drawer__foot .pv-btn').getBoundingClientRect();
    body.scrollTop = body.scrollHeight; var last = body.lastElementChild.getBoundingClientRect(), br = body.getBoundingClientRect();
    var r = { W: W, dw: dr.width, inner: f.clientWidth, under: f.clientWidth - dr.width, closeIn: cb.left >= fr.left - 0.5 && cb.right <= fr.right + 0.5 && cb.top >= fr.top - 0.5 && cb.bottom <= fr.bottom + 0.5, close: Math.min(cb.width, cb.height), overflowX: d.scrollWidth > d.clientWidth + 1 || f.scrollWidth > f.clientWidth + 1, scrolls: body.scrollHeight > body.clientHeight + 1 && getComputedStyle(body).overflowY === 'auto', lastReach: last.bottom <= br.bottom + 1 && last.top >= br.top - 1, footIn: foot.bottom <= fr.bottom + 0.5 && foot.top >= fr.top };
    f.remove(); return r;
  }

  /* ---------- focus ring on surfaces ------------------------------------------- */
  var SURFACES = [
    ['Page (Ivory)', 'color-bg-page', 'pass'], ['Surface (White)', 'color-bg-surface', 'pass'], ['Subtle (Blush)', 'color-bg-subtle', 'pass'],
    ['Brand tint', 'color-brand-tint', 'pass'], ['Brand tint strong', 'color-brand-tint-strong', 'pass'],
    ['Error tint', 'color-status-error-bg', 'pass'], ['Success tint', 'color-status-success-bg', 'pass'], ['Warning tint', 'color-status-warning-bg', 'pass'],
    ['Dark (.surface-inverse)', 'color-bg-inverse', 'pass', 'surface-inverse'],
    ['Brand fill, default ring', 'color-brand-primary', 'known', '', true],
    ['Brand fill, inverse ring', 'color-brand-primary', 'pass', '', true, true]
  ];
  function renderFocus() {
    $('render-focus').innerHTML = SURFACES.map(function (s, i) {
      var brand = s[4] ? ' color:var(--color-text-on-brand);border-color:var(--color-text-on-brand);' : '';
      var ring = s[5] ? '--focus-ring:var(--focus-ring-width) solid var(--color-focus-ring-inverse);' : '';
      var bg = (s[3] ? '' : 'background:var(--' + s[1] + ');') + (s[4] ? 'color:var(--color-text-on-brand);' : '');
      return '<div class="pv-surface ' + s[3] + '" data-surface="' + i + '" style="' + bg + ring + '"><button class="pv-btn pv-btn--secondary pv-btn--sm pv-show-focus" type="button" data-focus-sample style="' + brand + '">Focus</button><span class="pv-note" style="color:inherit">' + esc(s[0]) + '</span></div>';
    }).join('');
  }
  function rgb(str) { var m = /rgba?\(([\d.]+),\s*([\d.]+),\s*([\d.]+)/.exec(str); return m ? [m[1] / 255, m[2] / 255, m[3] / 255] : null; }
  var focusResults = [];
  function measureFocus() {
    var prev = document.activeElement, out = [];
    [].forEach.call(document.querySelectorAll('[data-focus-sample]'), function (btn) {
      var s = SURFACES[+btn.closest('[data-surface]').getAttribute('data-surface')], surf = btn.closest('[data-surface]');
      btn.classList.remove('pv-show-focus');   // the always-on demo ring must not mask the real :focus-visible rule
      btn.focus({ preventScroll: true });
      var real = btn.matches(':focus-visible'), forced = false;
      if (!real) { btn.classList.add('is-focus'); forced = true; }   // document not focused: fall back to the forced focus style and say so
      var c = getComputedStyle(btn), ring = rgb(c.outlineColor), bg = rgb(getComputedStyle(surf).backgroundColor);
      var w = parseFloat(c.outlineWidth), off = parseFloat(c.outlineOffset), focused = true, ost = c.outlineStyle;   // read before blur(): the computed style object is live
      btn.classList.remove('is-focus'); btn.blur(); btn.classList.add('pv-show-focus');
      var r = ring && bg ? ratio(ring, bg) : 0, ok = focused && r >= 3 && w >= 2 && off >= 2 && ost === 'solid';
      var st = ok ? (s[2] === 'known' ? 'warn' : 'pass') : (s[2] === 'known' ? 'known' : 'fail');
      out.push({ s: st, l: s[0], d: r.toFixed(2) + ':1 · ' + w + 'px ' + ost + ' · offset ' + off + 'px' + (forced ? ' · measured with the forced focus style (the document was not focused)' : '') + (s[2] === 'known' ? ' · documented as not permitted: use the inverse ring on brand fills' : '') });
    });
    if (prev && prev.focus && prev !== document.body) prev.focus({ preventScroll: true });
    return out;
  }

  /* ---------- wiring ----------------------------------------------------------- */
  renderStats(); renderColors(); renderType(); renderSpacing(); renderLayout(); renderBreakpoints(); renderEffects(); renderFocus(); renderProductCards(); renderPackaging(); renderDrawer(); renderCompare(); renderMatrix();
  var files = $('tok-f'); files.innerHTML = '<option value="">All files</option>' + DATA.files.map(function (f) { return '<option value="' + f.id + '">' + f.id + '.json</option>'; }).join('');
  ['tok-q', 'tok-f', 'tok-r', 'tok-u'].forEach(function (id) { $(id).addEventListener('input', renderTokens); $(id).addEventListener('change', renderTokens); });
  renderTokens();

  $('sim-controls').addEventListener('click', function (e) {
    var b = e.target.closest('button'); if (!b) return;
    simSel = b.getAttribute('data-tier');
    document.querySelectorAll('#sim-controls button').forEach(function (x) { x.setAttribute('aria-pressed', String(x === b)); });
    if (simSel === 'live') clearTier(sim); else applyTier(sim, +simSel);
    refresh();
  });
  var rt; window.addEventListener('resize', function () { clearTimeout(rt); rt = setTimeout(function () { refresh(); runValidation(); }, 100); });

  var links = document.querySelectorAll('.pv-nav a');
  if ('IntersectionObserver' in window) {
    var map = {}; links.forEach(function (a) { map[a.getAttribute('href').slice(1)] = a; });
    var io = new IntersectionObserver(function (es) { es.forEach(function (e) { if (e.isIntersecting) { links.forEach(function (a) { a.removeAttribute('aria-current'); }); if (map[e.target.id]) map[e.target.id].setAttribute('aria-current', 'true'); } }); }, { rootMargin: '-30% 0px -60% 0px' });
    Object.keys(map).forEach(function (id) { var s = $(id); if (s) io.observe(s); });
  }

  refresh();
  runValidation();
  setTimeout(function () { focusResults = measureFocus(); runValidation(); }, 400);   // after load, when the document has focus
  if (document.fonts && document.fonts.ready) document.fonts.ready.then(function () { refresh(); runValidation(); });
})();
