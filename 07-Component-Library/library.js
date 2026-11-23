/* NUDGE Component Library v1 - the viewer. Reads window.NUDGE_LIB (generated), renders with NudgeEngine, shows the result in one preview frame. */
(function () {
  'use strict';
  var LIB = window.NUDGE_LIB, C = LIB.components;
  var ORIG = JSON.parse(JSON.stringify(Object.keys(C).reduce(function (o, k) { o[k] = { html: C[k].html, manifest: C[k].manifest }; return o; }, {})));
  var engine = new NudgeEngine(C, { builtins: LIB.builtins, pages: LIB.pages });
  var $ = function (s, r) { return (r || document).querySelector(s); };
  function el(tag, attrs, kids) {
    var e = document.createElement(tag), k;
    for (k in (attrs || {})) { if (k === 'text') e.textContent = attrs[k]; else if (k === 'html') e.innerHTML = attrs[k]; else if (k.slice(0, 2) === 'on') e.addEventListener(k.slice(2), attrs[k]); else if (attrs[k] !== false && attrs[k] !== null) e.setAttribute(k, attrs[k] === true ? '' : attrs[k]); }
    (kids || []).forEach(function (c) { if (c) e.appendChild(typeof c === 'string' ? document.createTextNode(c) : c); });
    return e;
  }
  function esc(s) { return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }
  var truthy = function (v) { return !(v === undefined || v === null || v === '' || v === '0' || v === 'false' || v === false || (Array.isArray(v) && !v.length)); };

  /* ---------- component model ---------- */
  function levelOf(n) { var m = C[n].manifest; if (m && m.level) return m.level; return C[n].group === 'base' ? 'base' : (C[n].includes.length ? 'main' : 'sub'); }
  function labelOf(n) { var m = C[n].manifest; return m && m.name ? m.name : n.split('/').pop(); }
  function props(n) {
    var m = C[n].manifest; if (m && m.properties) return m.properties;
    if (C[n].inferred) return C[n].inferred;
    var h = C[n].html, seen = {}, out = [], skip = /\{\{each /.test(h) ? { item: 1, href: 1, index: 1, index0: 1, first: 1, last: 1 } : {}, hasTok = {};
    var m1; var rt = /\{\{(?:slug:|lower:|arg:)?([\w]+)(?:\.\w+)?\}\}/g; while ((m1 = rt.exec(h))) hasTok[m1[1]] = 1;
    var re = /\{\{(if|each) !?([\w]+)(?:=[^}]*)?\}\}|\{\{(?:slug:|lower:|arg:)?(\w+)(?:\.\w+)?\}\}/g, x;
    while ((x = re.exec(h))) {
      var nm = x[2] || x[3]; if (!nm || skip[nm] || seen[nm]) continue;
      var tp = x[1] === 'each' ? 'LIST' : (x[1] === 'if' && !hasTok[nm] && !/\{\{if \w+=/.test(h.substr(x.index, 40)) ? 'BOOLEAN' : 'TEXT');
      seen[nm] = 1; out.push({ name: nm, type: tp, default: tp === 'BOOLEAN' ? false : '', note: 'Inferred from the template (no manifest yet)' });
    }
    C[n].inferred = out; return out;
  }
  function parseCall(call) { var m = /@@PARTIAL ([a-z0-9\/-]+)([^@]*)@@/.exec(call); var a = NudgeEngine.parseArgs(m ? m[2] : ''); Object.keys(a).forEach(function (k) { a[k] = NudgeEngine.unesc(a[k]); }); return a; }
  function defaultsFor(n) {
    var o = {}; props(n).forEach(function (p) { var d = p.default; if (typeof d === 'boolean') d = d ? '1' : '0'; if (d === undefined || d === null) d = ''; o[p.name] = d; });
    var u = LIB.usage[n]; if (u && u.examples.length && !(C[n].manifest)) { var ex = parseCall(u.examples[0].call); Object.keys(ex).forEach(function (k) { if (k in o) o[k] = ex[k]; }); }
    return o;
  }

  /* ---------- state ---------- */
  var S = { sel: null, args: {}, tab: 'preview', width: 1440, bg: 'bg-page', ctx: 'shared', ctxManual: false, vars: {}, vprop: null, inst: null, master: null };
  var WIDTHS = [1440, 1024, 768, 390];

  /* ---------- preview frame ---------- */
  var frame = $('#frame'), frameReady = false, pending = null, resolveCbs = {}, rid = 0;
  function frameDoc() {
    return '<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">' +
      '<link rel="stylesheet" href="../02-Design-Variables/Styles/variables.css"><link rel="stylesheet" href="../01-Design-System/Styles/foundation.css">' +
      '<script src="../03-Wireframes/00-Shared-Tailwind-Foundation/tailwindcss-play-3.4.17.js"><\/script><script src="../03-Wireframes/00-Shared-Tailwind-Foundation/tailwind.config.js"><\/script>' +
      '<style type="text/tailwindcss">' + LIB.css.base + '\n' + LIB.css.components + (S.ctx === 'homepage' ? '\n' + LIB.css.pages.homepage : '') + '</style>' +
      '<style>body{margin:0}#root{padding:20px}figure{margin:0 0 24px}figcaption{font:600 11px/1.4 system-ui,sans-serif;letter-spacing:.06em;text-transform:uppercase;color:#6d6672;margin-bottom:8px}.cells{display:flex;flex-wrap:wrap;gap:24px}.cell{min-width:0}.err{font:13px/1.4 ui-monospace,Consolas,monospace;color:#b3261e;white-space:pre-wrap}</style></head>' +
      '<body class="bg-page"><div style="display:none">' + LIB.sprite + '</div><div id="root"></div><script>' +
      'var root=document.getElementById("root"),prev=[];' +
      'function setVars(v){prev.forEach(function(n){document.documentElement.style.removeProperty(n)});prev=Object.keys(v||{});prev.forEach(function(n){document.documentElement.style.setProperty(n,v[n])})}' +
      'function report(){setTimeout(function(){parent.postMessage({type:"size",h:Math.ceil(root.getBoundingClientRect().height)+40},"*")},80)}' +
      'addEventListener("message",function(e){var d=e.data||{};' +
      'if(d.type==="render"){root.innerHTML=d.html;document.body.className=d.bodyClass||"";setVars(d.vars);report();parent.postMessage({type:"rendered",id:d.id},"*")}' +
      'if(d.type==="vars"){setVars(d.vars);report()}' +
      'if(d.type==="resolve"){var cs=getComputedStyle(document.documentElement),o={};d.names.forEach(function(n){o[n]=cs.getPropertyValue(n).trim()});parent.postMessage({type:"resolved",id:d.id,values:o},"*")}});' +
      'if(window.ResizeObserver)new ResizeObserver(report).observe(root);' +
      'addEventListener("load",function(){parent.postMessage({type:"ready"},"*")});<\/script></body></html>';
  }
  window.addEventListener('message', function (e) {
    if (e.source !== frame.contentWindow) return; var d = e.data || {};
    if (d.type === 'ready') { frameReady = true; if (pending) { post(pending); pending = null; } }
    if (d.type === 'size') { frame.style.height = Math.max(160, d.h) + 'px'; }
    if (d.type === 'resolved' && resolveCbs[d.id]) { resolveCbs[d.id](d.values); delete resolveCbs[d.id]; }
    if (d.type === 'rendered') { window.__lastRendered = d.id; }
  });
  function post(msg) { if (!frameReady) { pending = msg; return; } frame.contentWindow.postMessage(msg, '*'); }
  function resolveVars(names, cb) { var id = ++rid; resolveCbs[id] = cb; post({ type: 'resolve', names: names, id: id }); }
  frame.srcdoc = frameDoc();

  function safeRender(n, args) { try { return { html: engine.render(n, args) }; } catch (e) { return { error: e.message }; } }
  function status(msg, bad) { var s = $('#status'); s.textContent = msg || ''; s.className = 'status' + (msg ? (bad ? ' err' : ' ok') : ''); }
  var renderSeq = 0;
  function send(html) { renderSeq++; S.lastMsg = { type: 'render', html: html, bodyClass: S.bg, vars: S.vars, id: renderSeq }; post(S.lastMsg); return renderSeq; }
  function applyCtx(c) { if (S.ctx === c) { $('#ctx').value = c; return; } S.ctx = c; $('#ctx').value = c; frameReady = false; pending = S.lastMsg || null; frame.srcdoc = frameDoc(); }
  function wantCtx(n, args, tab) { if (S.ctxManual) return S.ctx; var m = C[n] && C[n].manifest, hasEd = !!(m && m.properties.some(function (p) { return p.type === 'VARIANT' && (p.values || []).some(function (v) { return /^editorial/.test(v); }); })); if (C[n] && C[n].group === 'homepage') return 'homepage'; if (hasEd && (tab === 'variants' || /^editorial/.test((args && args.variant) || ''))) return 'homepage'; return 'shared'; }
  function errBlock(m) { return '<div class="err">' + esc(m) + '</div>'; }

  /* ---------- tree ---------- */
  var LEVELS = [['base', 'Base components'], ['sub', 'Sub-components'], ['main', 'Main components']];
  function buildTree() {
    var q = $('#search').value.toLowerCase().trim(), t = $('#tree'); t.innerHTML = '';
    var names = Object.keys(C).sort();
    LEVELS.forEach(function (lv) {
      var list = names.filter(function (n) { return levelOf(n) === lv[0] && (!q || (n + ' ' + labelOf(n) + ' ' + (C[n].manifest ? C[n].manifest.page || '' : '')).toLowerCase().indexOf(q) >= 0); });
      if (!list.length) return;
      t.appendChild(el('h3', { text: lv[1] + ' (' + list.length + ')' }));
      var groups = {}; list.forEach(function (n) { (groups[C[n].group] = groups[C[n].group] || []).push(n); });
      Object.keys(groups).forEach(function (g) {
        t.appendChild(el('h4', { text: g }));
        groups[g].forEach(function (n) {
          var u = LIB.usage[n], c = u ? Object.keys(u.pages).length + Object.keys(u.parents).length : 0;
          t.appendChild(el('button', { 'data-n': n, 'aria-current': n === S.sel ? 'true' : 'false', title: n, onclick: function () { select(n); } }, [el('span', { class: 'dot' + (C[n].manifest ? ' doc' : '') }), labelOf(n), el('span', { class: 'cnt', text: c ? 'used ' + c : '' })]));
        });
      });
    });
    if (!t.children.length) t.appendChild(el('p', { class: 'empty', text: 'No match.' }));
  }

  /* ---------- selection ---------- */
  function select(n, keepTab) {
    if (!C[n]) return; Object.keys(DIRTY).forEach(function (k) { resetMain(k); delete DIRTY[k]; }); S.sel = n; S.args = defaultsFor(n); S.inst = null; S.master = null; S.vprop = null; S.ctxManual = false;
    if (!keepTab) { /* stay on the current tab */ }
    location.hash = n; header(); buildTree(); fillExamples(); propsPanel(); show();
  }
  function header() {
    var n = S.sel, m = C[n].manifest || {}, lv = levelOf(n);
    $('#cName').textContent = labelOf(n); $('#cSummary').textContent = m.summary || 'No manifest yet: properties are inferred from the template. Documented in a later phase.';
    var meta = $('#cMeta'); meta.innerHTML = '';
    meta.appendChild(el('span', { class: 'chip lv-' + lv, text: lv })); meta.appendChild(el('span', { class: 'chip', text: m.page || C[n].group }));
    meta.appendChild(el('span', { class: 'chip', text: m.status || (C[n].manifest ? 'ready' : 'undocumented') })); var sy = (window.NUDGE_SYNC || {})[n]; if (sy) { meta.appendChild(el('span', { class: 'chip sy-' + sy.status.toLowerCase().replace(/[^a-z]+/g, '-'), title: sy.note || '', text: 'Shopify: ' + sy.status + (sy.pending ? ' (pending data)' : '') })); } meta.appendChild(el('code', { class: 'mono', text: n + '   (' + C[n].path + ')' }));
  }
  function fillExamples() {
    var s = $('#examples'); s.innerHTML = ''; var u = LIB.usage[S.sel]; var ex = u ? u.examples : [];
    s.appendChild(el('option', { value: '', text: ex.length ? 'Defaults' : 'No real call sites' }));
    ex.forEach(function (e, i) { s.appendChild(el('option', { value: i, text: e.where + ' #' + (i + 1) })); });
    s.onchange = function () { if (s.value === '') S.args = defaultsFor(S.sel); else { var a = parseCall(ex[+s.value].call); S.args = Object.assign(defaultsFor(S.sel), a); } propsPanel(); show(); };
  }

  /* ---------- property controls ---------- */
  function control(p, value, onchange, id) {
    var t = p.type, e;
    if (t === 'VARIANT' || t === 'INSTANCE_SWAP') {
      var opts = (t === 'VARIANT' ? p.values : p.options) || []; e = el('select', { id: id });
      opts.forEach(function (o) { e.appendChild(el('option', { value: o, text: o === '' ? '(none)' : o })); });
      if (opts.indexOf(value) < 0 && value !== undefined) e.appendChild(el('option', { value: value, text: String(value) }));
      e.value = value; e.addEventListener('change', function () { onchange(e.value); });
    } else if (t === 'BOOLEAN') {
      e = el('input', { type: 'checkbox', id: id }); e.checked = truthy(value); e.addEventListener('change', function () { onchange(e.checked ? '1' : '0'); });
    } else if (t === 'LIST') {
      var isObj = Array.isArray(value); e = el('textarea', { id: id, spellcheck: 'false' });
      e.value = isObj ? JSON.stringify(value, null, 1) : String(value).split('|').join('\n');
      e.addEventListener('input', function () {
        if (isObj) { try { onchange(JSON.parse(e.value)); e.style.borderColor = ''; } catch (x) { e.style.borderColor = '#b3261e'; } } else onchange(e.value.split('\n').filter(function (l) { return l !== ''; }).join('|'));
      });
    } else { e = el('input', { type: 'text', id: id, value: value === undefined ? '' : value }); e.addEventListener('input', function () { onchange(e.value); }); }
    return e;
  }
  function propsPanel() {
    var box = $('#props'); box.innerHTML = ''; box.appendChild(el('h2', { text: 'Properties' }));
    var ps = props(S.sel); if (!ps.length) box.appendChild(el('p', { class: 'note', text: 'This component takes no properties.' }));
    ps.forEach(function (p, i) {
      var id = 'p-' + p.name, row = el('div', { class: 'prop' });
      row.appendChild(el('label', { for: id }, [p.name, el('span', { class: 'ty', text: p.type })]));
      row.appendChild(control(p, S.args[p.name], function (v) { S.args[p.name] = v; show(); }, id));
      if (p.note) row.appendChild(el('p', { class: 'note', text: p.note }));
      box.appendChild(row);
    });
    var r = el('div', { class: 'row' }, [el('button', { class: 'btn-ui', text: 'Reset to defaults', onclick: function () { S.args = defaultsFor(S.sel); propsPanel(); show(); } })]); box.appendChild(r);
  }

  /* ---------- tabs ---------- */
  function show() {
    var tab = S.tab, panel = $('#panel'), fw = $('#frameWrap');
    var withFrame = ['preview', 'variants', 'instances', 'tokens'].indexOf(tab) >= 0;
    fw.hidden = !withFrame; panel.hidden = tab === 'preview';
    $('#bar').style.display = withFrame ? '' : 'none'; $('#exWrap').style.display = tab === 'preview' ? '' : 'none';
    document.querySelectorAll('#tabs button').forEach(function (b) { b.setAttribute('aria-selected', b.dataset.tab === tab ? 'true' : 'false'); });
    if (S.mode === 'components') applyCtx(wantCtx(S.sel, S.args, tab));
    ({ preview: tPreview, variants: tVariants, hierarchy: tHierarchy, reuse: tReuse, tokens: tTokens, instances: tInstances, docs: tDocs })[tab]();
    applyWidth();
  }
  function applyWidth() {
    var fw = $('#frameWrap'), cv = $('#canvas'); fw.style.width = S.width + 'px'; var avail = cv.clientWidth - 40; var k = Math.min(1, avail / S.width);
    fw.style.transform = k < 1 ? 'scale(' + k + ')' : ''; fw.style.marginBottom = k < 1 ? ((k - 1) * (frame.offsetHeight || 0)) + 'px' : '';
    document.querySelectorAll('#widths button').forEach(function (b) { b.setAttribute('aria-pressed', String(+b.dataset.w === S.width)); });
  }
  function tPreview() {
    var r = safeRender(S.sel, S.args);
    if (r.error) { status(r.error, true); send(errBlock(r.error)); } else { status('Rendered', false); send('<div data-instance="main">' + r.html + '</div>'); }
  }
  function tVariants() {
    var ps = props(S.sel).filter(function (p) { return (p.type === 'VARIANT' && (p.values || []).length > 1) || (p.type === 'BOOLEAN'); });
    var panel = $('#panel'); panel.hidden = false; panel.innerHTML = '';
    if (!ps.length) { panel.appendChild(el('p', { class: 'empty', text: 'This component has no variant or boolean properties.' })); send(''); return; }
    if (!S.vprop || !ps.some(function (p) { return p.name === S.vprop; })) S.vprop = (ps.filter(function (p) { return p.name === 'variant'; })[0] || ps[0]).name;
    var sel = el('select', { onchange: function () { S.vprop = sel.value; tVariants(); } }); ps.forEach(function (p) { sel.appendChild(el('option', { value: p.name, text: p.name + ' (' + p.type + ')' })); }); sel.value = S.vprop;
    panel.appendChild(el('div', { class: 'row' }, ['Vary the property:', sel, el('span', { class: 'note', text: 'Every value of the chosen property is rendered side by side; all other properties follow the Properties panel.' })]));
    var p = ps.filter(function (q) { return q.name === S.vprop; })[0], vals = p.type === 'BOOLEAN' ? ['0', '1'] : p.values, html = '<div class="cells">';
    vals.forEach(function (v) { var a = Object.assign({}, S.args); a[p.name] = v; var r = safeRender(S.sel, a); html += '<figure class="cell"><figcaption>' + esc(p.name + ' = ' + (v === '' ? '(none)' : v) + (v === (p.default === true ? '1' : p.default === false ? '0' : p.default) ? '  - default' : '')) + '</figcaption>' + (r.error ? errBlock(r.error) : r.html) + '</figure>'; });
    status(vals.length + ' values', false); send(html + '</div>');
  }
  function tree(n, depth, seen) {
    var li = el('li'); var kids = C[n].includes || [];
    li.appendChild(el('button', { text: labelOf(n), onclick: function () { select(n); } })); li.appendChild(el('span', { class: 'chip lv-' + levelOf(n), text: levelOf(n), style: 'margin-left:6px' }));
    if (depth > 6 || seen.indexOf(n) >= 0) return li;
    if (kids.length) { var ul = el('ul'); kids.forEach(function (k) { if (k.indexOf('{{') >= 0) ul.appendChild(el('li', { text: k + '  (dynamic)', class: 'note' })); else if (C[k]) ul.appendChild(tree(k, depth + 1, seen.concat(n))); else ul.appendChild(el('li', { text: k + '  (shared partial)', class: 'note' })); }); li.appendChild(ul); }
    return li;
  }
  function tHierarchy() {
    var p = $('#panel'); p.hidden = false; p.innerHTML = '';
    p.appendChild(el('h2', { text: 'Contains (nested components)' })); var ul = el('ul', { class: 'h-tree' }); ul.appendChild(tree(S.sel, 0, [])); p.appendChild(ul);
    if (!(C[S.sel].includes || []).length) p.appendChild(el('p', { class: 'note', text: 'This component does not contain other components.' }));
    var u = LIB.usage[S.sel]; p.appendChild(el('h2', { text: 'Used inside (parents)' }));
    var pk = u ? Object.keys(u.parents).filter(function (k) { return C[k]; }) : [];
    if (pk.length) { var u2 = el('ul', { class: 'h-tree' }); pk.forEach(function (k) { u2.appendChild(el('li', {}, [el('button', { text: labelOf(k) + '  (' + k + ')', onclick: function () { select(k); } }), ' x' + u.parents[k]])); }); p.appendChild(u2); } else p.appendChild(el('p', { class: 'note', text: 'Not nested inside another component.' }));
    send('');
  }
  function tReuse() {
    var p = $('#panel'); p.hidden = false; p.innerHTML = ''; var u = LIB.usage[S.sel];
    p.appendChild(el('h2', { text: 'Where it is used' }));
    if (!u) { p.appendChild(el('p', { class: 'note', text: 'No page or component calls this component yet.' })); send(''); return; }
    var tb = el('table'); tb.appendChild(el('tr', {}, [el('th', { text: 'Place' }), el('th', { text: 'Kind' }), el('th', { text: 'Calls' })]));
    Object.keys(u.pages).forEach(function (k) { tb.appendChild(el('tr', {}, [el('td', { text: k }), el('td', { text: 'page source' }), el('td', { text: u.pages[k] })])); });
    Object.keys(u.parents).forEach(function (k) { tb.appendChild(el('tr', {}, [el('td', { text: k }), el('td', { text: 'parent component' }), el('td', { text: u.parents[k] })])); });
    p.appendChild(tb); p.appendChild(el('h2', { text: 'Real call sites (click to load into the preview)' }));
    u.examples.forEach(function (e, i) { p.appendChild(el('div', {}, [el('pre', { text: e.call }), el('button', { class: 'btn-ui', text: 'Load these arguments (' + e.where + ')', onclick: function () { S.args = Object.assign(defaultsFor(S.sel), parseCall(e.call)); S.tab = 'preview'; propsPanel(); show(); } })])); });
    if (!u.examples.length) p.appendChild(el('p', { class: 'note', text: 'Only calls with computed arguments exist; no fixed example to show.' }));
    send('');
  }

  /* ---------- tokens ---------- */
  var T = (window.tailwind && window.tailwind.config && window.tailwind.config.theme) || {};
  var SPACING = ['p', 'px', 'py', 'pt', 'pb', 'pl', 'pr', 'm', 'mx', 'my', 'mt', 'mb', 'ml', 'mr', 'gap', 'gap-x', 'gap-y', 'space-x', 'space-y', 'w', 'h', 'size', 'min-w', 'min-h', 'max-h', 'top', 'left', 'right', 'bottom', 'inset', 'inset-x', 'inset-y'];
  var COLORP = ['text', 'bg', 'border', 'border-t', 'border-b', 'border-l', 'border-r', 'fill', 'stroke', 'ring', 'outline', 'decoration', 'divide', 'placeholder', 'accent', 'caret', 'from', 'to', 'via'];
  function flat(o, pre, out) { out = out || {}; Object.keys(o || {}).forEach(function (k) { var v = o[k]; if (v && typeof v === 'object' && !Array.isArray(v)) flat(v, pre ? pre + '-' + k : k, out); else out[k === 'DEFAULT' ? pre : (pre ? pre + '-' + k : k)] = Array.isArray(v) ? v.join(',') : String(v); }); return out; }
  var COLORS = flat(T.colors || {}, '');
  function lookup(cls) {
    var base = cls.replace(/^.*:(?![^\[]*\])/, '').replace(/^!/, '').replace(/^-/, '');
    var arb = /^([\w-]+)-\[(.+)\]$/.exec(base);
    if (arb) { var vm = /var\((--[\w-]+)/.exec(arb[2]); return vm ? { cls: cls, kind: 'token', via: 'arbitrary', vars: [vm[1]], what: arb[2] } : { cls: cls, kind: 'fixed', what: arb[2] }; }
    var m = /^([a-z-]+?)-([\w.\/-]+)$/.exec(base), pre = m ? m[1] : base, key = m ? m[2] : 'DEFAULT';
    function tok(group, k) { var v = (group || {})[k]; if (v === undefined) return null; v = Array.isArray(v) ? v.join(',') : String(v); var vm2 = /var\((--[\w-]+)/.exec(v); return { cls: cls, kind: 'token', via: group === T.colors ? 'colors' : '', vars: vm2 ? [vm2[1]] : [], what: v }; }
    var r = null;
    if (SPACING.indexOf(pre) >= 0 && m) r = tok(T.spacing, key); if (r) { r.via = 'spacing.' + key; return r; }
    if (pre === 'max-w' && m) { r = tok(T.maxWidth, key); if (r) { r.via = 'maxWidth.' + key; return r; } }
    if (pre === 'text' && m && T.fontSize && T.fontSize[key]) { r = tok(T.fontSize, key); r.via = 'fontSize.' + key; return r; }
    if (COLORP.indexOf(pre) >= 0 && m && COLORS[key]) { var cv = COLORS[key], vm3 = /var\((--[\w-]+)/.exec(cv); return { cls: cls, kind: 'token', via: 'colors.' + key, vars: vm3 ? [vm3[1]] : [], what: cv }; }
    var maps = { rounded: 'borderRadius', shadow: 'boxShadow', leading: 'lineHeight', tracking: 'letterSpacing', z: 'zIndex', duration: 'transitionDuration', ease: 'transitionTimingFunction', aspect: 'aspectRatio', opacity: 'opacity' };
    if (maps[pre] && m) { r = tok(T[maps[pre]], key); if (r) { r.via = maps[pre] + '.' + key; return r; } }
    if (pre === 'font' && m) { r = tok(T.fontFamily, key) || tok(T.fontWeight, key); if (r) { r.via = 'font.' + key; return r; } }
    if (pre === 'rounded' && !m) return null;
    return null;
  }
  function classesOf(html) { var out = {}, re = /class="([^"]*)"/g, m; while ((m = re.exec(html))) m[1].split(/\s+/).forEach(function (c) { if (c) out[c] = 1; }); return Object.keys(out); }
  function tTokens() {
    var p = $('#panel'); p.hidden = false; p.innerHTML = ''; var r = safeRender(S.sel, S.args); send(r.error ? errBlock(r.error) : '<div>' + r.html + '</div>'); $('#frameWrap').hidden = false; $('#bar').style.display = '';
    if (r.error) { p.appendChild(el('p', { class: 'err', text: r.error })); return; }
    var cls = classesOf(r.html), rows = [], dsRows = [], vars = {};
    cls.forEach(function (c) {
      var x = lookup(c); if (x) { rows.push(x); (x.vars || []).forEach(function (v) { vars[v] = 1; }); }
      if (LIB.dsClasses[c]) { var inner = []; LIB.dsClasses[c].split(/\s+/).forEach(function (u) { var y = lookup(u); if (y) { inner.push(y); (y.vars || []).forEach(function (v) { vars[v] = 1; }); y.via = '.' + c + ': ' + (y.via || ''); if (!rows.some(function (z) { return z.cls === y.cls && z.kind === y.kind; })) rows.push(y); } }); dsRows.push({ cls: c, apply: LIB.dsClasses[c], inner: inner }); }
    });
    var fixed = rows.filter(function (x) { return x.kind === 'fixed'; }), toks = rows.filter(function (x) { return x.kind === 'token'; });
    p.appendChild(el('h2', { text: 'Design System classes used (' + dsRows.length + ')' }));
    if (dsRows.length) { var t1 = el('table'); t1.appendChild(el('tr', {}, [el('th', { text: 'Class' }), el('th', { text: '@apply' })])); dsRows.forEach(function (d) { t1.appendChild(el('tr', {}, [el('td', {}, [el('code', { text: '.' + d.cls })]), el('td', {}, [el('code', { text: d.apply })])])); }); p.appendChild(t1); } else p.appendChild(el('p', { class: 'note', text: 'None: this component is plain utilities.' }));
    p.appendChild(el('h2', { text: 'Utilities bound to Design Variables (' + toks.length + ')' }));
    var t2 = el('table'); t2.appendChild(el('tr', {}, [el('th', { text: 'Class' }), el('th', { text: 'Theme key' }), el('th', { text: 'CSS variable' }), el('th', { text: 'Resolved value' })]));
    toks.forEach(function (x) { var tr = el('tr'); tr.appendChild(el('td', {}, [el('code', { text: x.cls })])); tr.appendChild(el('td', { text: x.via || '' })); tr.appendChild(el('td', {}, [el('code', { text: (x.vars || []).join(', ') || '(none)' })])); var cell = el('td', { 'data-var': (x.vars || [])[0] || '', text: '...' }); tr.appendChild(cell); t2.appendChild(tr); });
    p.appendChild(t2);
    p.appendChild(el('h2', { text: 'Fixed values, not tokens (' + fixed.length + ')' }));
    p.appendChild(el('p', { class: 'note', text: 'Arbitrary values written directly in the component. Listed for the token review; none has been changed.' }));
    p.appendChild(el('div', {}, fixed.map(function (x) { return el('span', { class: 'chip', text: x.cls }); })));
    var names = Object.keys(vars).sort();
    p.appendChild(el('h2', { text: 'Try a variable (live in the preview above)' }));
    p.appendChild(el('p', { class: 'note', text: 'Change a value and the preview updates. This is a local override only; the Design Variables file is not touched.' }));
    var vt = el('table'); vt.appendChild(el('tr', {}, [el('th', { text: 'Variable' }), el('th', { text: 'Value' }), el('th', { text: '' })]));
    var inputs = {}; names.forEach(function (n) {
      var inp = el('input', { type: 'text', 'data-v': n }); inputs[n] = inp; inp.addEventListener('input', function () { if (inp.value.trim()) S.vars[n] = inp.value.trim(); else delete S.vars[n]; post({ type: 'vars', vars: S.vars }); });
      vt.appendChild(el('tr', {}, [el('td', {}, [el('code', { text: n })]), el('td', {}, [inp]), el('td', {}, [el('button', { class: 'btn-ui', text: 'reset', onclick: function () { delete S.vars[n]; post({ type: 'vars', vars: S.vars }); fillVals(); } })])]));
    });
    p.appendChild(vt); p.appendChild(el('div', { class: 'row' }, [el('button', { class: 'btn-ui', text: 'Reset all variables', onclick: function () { S.vars = {}; post({ type: 'vars', vars: S.vars }); fillVals(); } })]));
    function fillVals() {
      resolveVars(names, function (vals) {
        names.forEach(function (n) { if (document.activeElement !== inputs[n]) inputs[n].value = S.vars[n] || vals[n] || ''; });
        p.querySelectorAll('td[data-var]').forEach(function (td) { var v = td.getAttribute('data-var'); td.innerHTML = ''; if (v) { var val = vals[v] || ''; if (/^(#|rgb|hsl)/i.test(val)) td.appendChild(el('span', { class: 'swatch', style: 'background:' + val })); td.appendChild(document.createTextNode(val)); } else td.textContent = 'n/a'; });
      });
    }
    setTimeout(fillVals, 400);
  }

  /* ---------- instances: shared edit and overrides ---------- */
  var DIRTY = {};
  function resetMain(n) { C[n].html = ORIG[n].html; C[n].manifest = ORIG[n].manifest ? JSON.parse(JSON.stringify(ORIG[n].manifest)) : null; C[n].inferred = null; }
  function tInstances() {
    var n = S.sel, p = $('#panel'); p.hidden = false; p.innerHTML = '';
    if (!S.master || S.master.n !== n || !S.inst) { S.master = { n: n }; S.inst = [{}, {}, {}]; }
    var pp = props(n), base = defaultsFor(n);
    p.appendChild(el('h2', { text: 'Main component and three instances' }));
    p.appendChild(el('p', { class: 'note', html: '<b>Edit the main component</b> (its template or a default) and every instance that has not overridden that property follows. <b>Override a property on one instance</b> and only that instance changes: the main component and the other instances stay as they are. Edits here live in memory only and never touch the files; Reset restores them.' }));
    var used = LIB.usage[n]; if (used) p.appendChild(el('p', { class: 'note', text: 'In the real pages this component is called ' + (Object.keys(used.pages).length + Object.keys(used.parents).length) + ' place(s); an edit to the main component reaches all of them.' }));
    p.appendChild(el('h2', { text: 'Main: change a default' }));
    var md = el('div', { class: 'row' }); pp.filter(function (q) { return q.type === 'VARIANT' || q.type === 'TEXT' || q.type === 'BOOLEAN'; }).slice(0, 4).forEach(function (q) {
      var cur = base[q.name], c = control(q, cur, function (v) { var mp = C[n].manifest && C[n].manifest.properties.filter(function (x) { return x.name === q.name; })[0]; if (mp) { mp.default = q.type === 'BOOLEAN' ? v === '1' : v; DIRTY[n] = 1; } tInstances(); }, 'md-' + q.name); md.appendChild(el('label', { class: 'lbl' }, [q.name, c]));
    }); p.appendChild(md);
    p.appendChild(el('h2', { text: 'Main: edit the template (HTML with the same {{tokens}})' }));
    var ta = el('textarea', { id: 'masterTpl', style: 'width:100%;min-height:90px;font:12px/1.4 ui-monospace,Consolas,monospace', spellcheck: 'false' }); ta.value = C[n].html; p.appendChild(ta);
    p.appendChild(el('div', { class: 'row' }, [el('button', { class: 'btn-ui pri', id: 'applyMain', text: 'Apply to main (all instances update)', onclick: function () { C[n].html = ta.value; C[n].inferred = null; DIRTY[n] = 1; tInstances(); } }), el('button', { class: 'btn-ui', text: 'Reset main to the file', onclick: function () { resetMain(n); S.inst = [{}, {}, {}]; tInstances(); } })]));
    p.appendChild(el('h2', { text: 'Instances' }));
    var grid = el('div', { class: 'inst-grid' }), cells = '<div class="cells">';
    S.inst.forEach(function (ov, i) {
      var card = el('div', { class: 'inst', 'data-inst': i }); card.appendChild(el('h3', { text: 'Instance ' + (i + 1) + '  (' + Object.keys(ov).length + ' override' + (Object.keys(ov).length === 1 ? '' : 's') + ')' }));
      pp.filter(function (q) { return q.type !== 'LIST'; }).slice(0, 6).forEach(function (q) {
        var row = el('div', { class: 'prop' }), over = q.name in ov, val = over ? ov[q.name] : base[q.name];
        var reset = el('button', { class: 'ovr', hidden: !over, text: 'overridden - reset', onclick: function () { delete ov[q.name]; tInstances(); } });
        row.appendChild(el('label', {}, [q.name, reset])); row.appendChild(control(q, val, function (v) { ov[q.name] = v; tInstances(); }, 'i' + i + '-' + q.name)); card.appendChild(row);
      });
      grid.appendChild(card);
      var a = Object.assign({}, base, ov), r = safeRender(n, a); cells += '<figure class="cell" data-instance="' + i + '"><figcaption>Instance ' + (i + 1) + '</figcaption>' + (r.error ? errBlock(r.error) : r.html) + '</figure>';
    });
    p.appendChild(grid);
    var rm = safeRender(n, base); var mainCell = '<figure class="cell" data-instance="main"><figcaption>Main component (defaults)</figcaption>' + (rm.error ? errBlock(rm.error) : rm.html) + '</figure>';
    status(rm.error ? rm.error : 'Main + 3 instances', !!rm.error); send(mainCell + cells + '</div>');
  }

  /* ---------- docs ---------- */
  function tDocs() {
    var n = S.sel, m = C[n].manifest, p = $('#panel'); p.hidden = false; p.innerHTML = ''; send('');
    if (!m) { p.appendChild(el('p', { class: 'note', text: 'No manifest for this component yet. Its properties above are inferred from the template. Manifests are written when its page is converted.' })); return; }
    [['Summary', m.summary], ['Accessibility', m.accessibility], ['Responsive behaviour', m.responsive]].forEach(function (x) { if (x[1]) { p.appendChild(el('h2', { text: x[0] })); p.appendChild(el('p', { text: x[1] })); } });
    if (m.tokens && m.tokens.length) { p.appendChild(el('h2', { text: 'Design Variable groups it depends on' })); p.appendChild(el('p', { text: m.tokens.join(', ') })); }
    p.appendChild(el('h2', { text: 'Properties' }));
    var t = el('table'); t.appendChild(el('tr', {}, ['Name', 'Type', 'Default', 'Values', 'Note'].map(function (h) { return el('th', { text: h }); })));
    m.properties.forEach(function (q) { t.appendChild(el('tr', {}, [el('td', {}, [el('code', { text: q.name })]), el('td', { text: q.type }), el('td', { text: typeof q.default === 'object' ? JSON.stringify(q.default) : String(q.default) }), el('td', { text: (q.values || q.options || []).join(', ') }), el('td', { text: q.note || '' })])); });
    p.appendChild(t);
    if (m.children && m.children.length) { p.appendChild(el('h2', { text: 'Children' })); p.appendChild(el('p', { text: m.children.join(', ') })); }
  }

  /* ---------- master library and page-wise views (from the audit) ---------- */
  var AUD = window.NUDGE_AUDIT || { entries: [], pages: [] };
  var STAT = { component: 'Component', ready: 'Ready (not adopted)', css: 'Design System class', page: 'Page-specific', 'page-local': 'Page-local icon', none: 'Not in wireframes' };
  var STATNOTE = { component: 'Implemented as a partial component and used by pages.', ready: 'A base component exists and validates; pages still use hand-written markup.', css: 'A Design System CSS class; the markup is written by hand on each page.', page: 'Page-specific markup or script; no shared component yet.', 'page-local': 'An icon defined inside one page only; not in the shared sprite or the icon assets.', none: 'Requested in the brief but not present in any wireframe. Not created.' };
  var PAGESHORT = AUD.pages.reduce(function (o, p) { o[p.number] = p.short; return o; }, {});
  function entryById(id) { return AUD.entries.filter(function (e) { return e.id === id; })[0]; }
  function pageNo(e) { return e.hits.map(function (h) { return h.page; }).filter(function (v, i, a) { return a.indexOf(v) === i; }); }
  function chrome(mode) {
    S.mode = mode; var comp = mode === 'components';
    document.querySelectorAll('#modes button').forEach(function (b) { b.setAttribute('aria-pressed', String(b.dataset.m === mode)); });
    $('#tabs').style.display = comp ? '' : 'none'; $('#search').placeholder = comp ? 'Search components (name, group, page)' : (mode === 'master' ? 'Search the master library' : 'Search pages and sections');
  }
  function setMode(m) {
    chrome(m);
    if (m === 'components') { select(S.sel || 'components/base/button'); }
    else if (m === 'master') { buildMasterTree(); showEntry(S.entry || AUD.entries[0].id); }
    else { buildPageTree(); showPage(S.pg || 1); }
  }
  function legendPanel() {
    var b = $('#props'); b.innerHTML = ''; b.appendChild(el('h2', { text: 'Status legend' })); var lg = el('div', { class: 'legend' });
    Object.keys(STAT).forEach(function (k) { var n = AUD.entries.filter(function (e) { return e.status === k; }).length; lg.appendChild(el('p', {}, [el('span', { class: 'chip st-' + k, text: STAT[k] }), ' ' + n + ' entries. ' + STATNOTE[k]])); });
    b.appendChild(lg); b.appendChild(el('p', { class: 'note', text: 'Entries are drawn from the audit of all 16 wireframes (docs/MASTER-COMPONENT-INVENTORY.md). Detections are read from the rendered pages at 1440 px.' }));
  }
  function buildMasterTree() {
    var q = $('#search').value.toLowerCase().trim(), t = $('#tree'); t.innerHTML = ''; var cur = null, shown = 0;
    AUD.entries.forEach(function (e) {
      if (q && (e.name + ' ' + e.impl + ' ' + e.group + ' ' + e.status).toLowerCase().indexOf(q) < 0) return;
      if (e.group !== cur) { cur = e.group; t.appendChild(el('h3', { text: cur.replace(/^\d+ /, '') })); }
      var np = pageNo(e).length; shown++;
      t.appendChild(el('button', { 'aria-current': e.id === S.entry ? 'true' : 'false', title: STAT[e.status], onclick: function () { showEntry(e.id); } }, [el('span', { class: 'dot st-' + e.status }), e.name, el('span', { class: 'cnt', text: np ? np + 'p' : '' })]));
    });
    if (!shown) t.appendChild(el('p', { class: 'empty', text: 'No match.' }));
  }
  function mapped(e) {
    var m = /(base|homepage|header|layout|common)\/[a-z0-9-]+/.exec(e.impl); if (!m) return null; var n = 'components/' + m[0]; if (!C[n]) return null;
    var a = defaultsFor(n), v = /variant=([a-z-]+)/.exec(e.impl), nm = /\bname=([a-z]+(?:-[a-z]+)*)(?![\w*-])/.exec(e.impl), el2 = /element=([a-z]+)/.exec(e.impl);
    if (v && 'variant' in a) a.variant = v[1]; if (nm && 'name' in a) a.name = nm[1]; if (el2 && 'element' in a) a.element = el2[1];
    return { name: n, args: a };
  }
  function goComponent(n, args) { setMode('components'); select(n); if (args) { S.args = Object.assign(S.args, args); propsPanel(); } S.tab = 'preview'; show(); }
  function goEntry(id) { if (S.mode !== 'master') { chrome('master'); } S.entry = id; buildMasterTree(); showEntry(id); }
  function goPage(n) { if (S.mode !== 'pages') { chrome('pages'); } S.pg = n; buildPageTree(); showPage(n); }
  function showEntry(id) {
    var e = entryById(id); if (!e) return; S.entry = id; buildMasterTree(); legendPanel();
    $('#cName').textContent = e.name; $('#cSummary').textContent = e.impl + (e.note ? '  -  ' + e.note : '');
    var meta = $('#cMeta'); meta.innerHTML = ''; meta.appendChild(el('span', { class: 'chip st-' + e.status, text: STAT[e.status] })); meta.appendChild(el('span', { class: 'chip', text: e.group.replace(/^\d+ /, '') })); meta.appendChild(el('code', { class: 'mono', text: e.id }));
    var p = $('#panel'); p.hidden = false; p.innerHTML = ''; $('#bar').style.display = 'none';
    p.appendChild(el('h2', { text: 'Status' })); p.appendChild(el('p', { text: STAT[e.status] + ': ' + STATNOTE[e.status] }));
    p.appendChild(el('h2', { text: 'Where it is used (16 pages)' }));
    var on = {}; e.hits.forEach(function (h) { on[h.page] = (on[h.page] || 0) + h.count; });
    var rg = el('div', { class: 'reuse' }); AUD.pages.forEach(function (pg) { rg.appendChild(el('button', { class: on[pg.number] ? 'on' : '', title: pg.name, onclick: function () { goPage(pg.number); } }, [el('b', { text: on[pg.number] || '-' }), pg.short])); }); p.appendChild(rg);
    if (!e.hits.length) p.appendChild(el('p', { class: 'note', text: e.status === 'none' ? 'Not present on any page.' : 'No direct detector (structural, type style or unused variant).' }));
    else { var tb = el('table'); tb.appendChild(el('tr', {}, [el('th', { text: 'Page' }), el('th', { text: 'Section' }), el('th', { text: 'Detections' })])); e.hits.slice(0, 40).forEach(function (h) { tb.appendChild(el('tr', {}, [el('td', {}, [el('button', { class: 'lnk', text: PAGESHORT[h.page], onclick: function () { goPage(h.page); } })]), el('td', { text: h.block }), el('td', { text: h.count })])); }); p.appendChild(tb); if (e.hits.length > 40) p.appendChild(el('p', { class: 'note', text: '+' + (e.hits.length - 40) + ' more in docs/COMPONENT-REUSE-MAP.md' })); }
    var mp = mapped(e); var fw = $('#frameWrap');
    if (mp) { var r = safeRender(mp.name, mp.args); 
      p.appendChild(el('h2', { text: 'Component' })); p.appendChild(el('p', {}, [el('code', { text: mp.name }), '  ', el('button', { class: 'btn-ui pri', text: 'Open in the Components view (variants, properties, tokens, instances)', onclick: function () { goComponent(mp.name, mp.args); } })]));
      applyCtx(wantCtx(mp.name, mp.args, 'preview')); fw.hidden = false; $('#bar').style.display = ''; $('#exWrap').style.display = 'none'; S.bg = $('#bg').value; send(r.error ? errBlock(r.error) : '<div data-instance="entry">' + r.html + '</div>'); status(r.error || 'Preview of ' + mp.name, !!r.error); }
    else { fw.hidden = true; send(''); status(''); }
    applyWidth();
  }
  function buildPageTree() {
    var q = $('#search').value.toLowerCase().trim(), t = $('#tree'); t.innerHTML = '';
    var sets = [['Core pages', [1, 2, 3, 4, 5]], ['Content pages', [6, 7, 8, 9]], ['Policy pages', [10, 11, 12, 13]], ['Blog and utility', [14, 15, 16]]];
    sets.forEach(function (s) { t.appendChild(el('h3', { text: s[0] })); s[1].forEach(function (n) { var pg = AUD.pages.filter(function (x) { return x.number === n; })[0]; if (!pg) return;
      if (q && (pg.name + ' ' + pg.blocks.map(function (b) { return b.name; }).join(' ')).toLowerCase().indexOf(q) < 0) return;
      t.appendChild(el('button', { 'aria-current': n === S.pg ? 'true' : 'false', onclick: function () { showPage(n); } }, [el('span', { class: 'dot doc' }), (n < 10 ? '0' : '') + n + '  ' + pg.name, el('span', { class: 'cnt', text: pg.blocks.length + ' sec' })])); }); });
  }
  function entryLink(id) { var e = entryById(id); return e ? el('button', { class: 'lnk', text: e.name, title: id, onclick: function () { goEntry(id); } }) : null; }
  function showPage(n) {
    var pg = AUD.pages.filter(function (x) { return x.number === n; })[0]; if (!pg) return; S.pg = n; buildPageTree(); legendPanel();
    $('#cName').textContent = 'Page ' + (n < 10 ? '0' : '') + n + ' - ' + pg.name; $('#cSummary').textContent = pg.file + (n === 5 ? '  (a dialog opened from the header, audited as the page that hosts it)' : '');
    var meta = $('#cMeta'); meta.innerHTML = ''; var kinds = {}; pg.blocks.forEach(function (b) { kinds[b.kind] = (kinds[b.kind] || 0) + 1; });
    meta.appendChild(el('span', { class: 'chip', text: pg.blocks.length + ' sections' })); Object.keys(kinds).forEach(function (k) { meta.appendChild(el('span', { class: 'chip', text: kinds[k] + ' ' + k })); });
    $('#frameWrap').hidden = true; send(''); status(''); $('#bar').style.display = 'none';
    var p = $('#panel'); p.hidden = false; p.innerHTML = ''; p.appendChild(el('p', { class: 'note', text: 'Every section in document order, read from the rendered wireframe. Open a section to see its main component, nested parts, buttons, icons and the master components it uses. Names in blue open the master library or the live component.' }));
    pg.blocks.forEach(function (b, i) {
      var d = el('details', { class: 'blk' }); d.appendChild(el('summary', {}, [(i + 1 < 10 ? '0' : '') + (i + 1) + '  ' + (b.name || '(unnamed)') + '  ', el('span', { class: 'chip', text: b.kind })]));
      var body = el('div', { class: 'body' });
      var row = function (label, kids) { var r = el('p', {}, [el('span', { class: 'lbl2', text: label })]); kids.forEach(function (k, j) { if (j) r.appendChild(document.createTextNode(', ')); r.appendChild(typeof k === 'string' ? document.createTextNode(k) : k); }); if (!kids.length) r.appendChild(document.createTextNode('none')); body.appendChild(r); };
      var mc = b.main ? (C[b.main] ? [el('button', { class: 'lnk', text: b.main.replace('components/', ''), onclick: function () { goComponent(b.main); } })] : [b.main + ' (shared partial)']) : ['page markup (not a component yet)']; row('Main component', mc);
      row('Nested sub-components', (b.nested || []).map(function (c) { return C[c] ? el('button', { class: 'lnk', text: c.replace('components/', ''), onclick: function () { goComponent(c); } }) : c; }));
      row('Subsections', (b.heads || []).slice(0, 14)); row('Buttons and controls', (b.buttons || []).slice(0, 14)); row('Icons', b.icons || []);
      row('Master components used', (b.refs || []).map(entryLink).filter(Boolean)); d.appendChild(body); p.appendChild(d);
    });
  }

  /* ---------- wiring ---------- */
  var wb = $('#widths'); WIDTHS.forEach(function (w) { wb.appendChild(el('button', { 'data-w': w, text: String(w), onclick: function () { S.width = w; applyWidth(); } })); });
  $('#ctx').addEventListener('change', function (e) { S.ctxManual = true; applyCtx(e.target.value); if (S.mode === 'components') show(); else if (S.entry && S.mode === 'master') showEntry(S.entry); });
  $('#bg').addEventListener('change', function (e) { S.bg = e.target.value; show(); });
  $('#search').addEventListener('input', function () { if (S.mode === 'master') buildMasterTree(); else if (S.mode === 'pages') buildPageTree(); else buildTree(); });
  document.querySelectorAll('#modes button').forEach(function (b) { b.addEventListener('click', function () { setMode(b.dataset.m); }); });
  document.querySelectorAll('#tabs button').forEach(function (b) { b.addEventListener('click', function () { S.tab = b.dataset.tab; show(); }); });
  window.addEventListener('resize', applyWidth);
  $('#meta').textContent = Object.keys(C).length + ' components, generated ' + LIB.generated;
  var start = decodeURIComponent((location.hash || '').slice(1)); if (!C[start]) start = 'components/base/button';
  S.mode = 'components'; buildTree(); select(start);
  window.__lib = { setMode: setMode, goEntry: goEntry, goPage: goPage, AUD: AUD, S: S, select: select, engine: engine, show: show, post: post, safeRender: safeRender, props: props, defaultsFor: defaultsFor, lookup: lookup, frame: frame, tabs: function (t) { S.tab = t; show(); } };
})();
