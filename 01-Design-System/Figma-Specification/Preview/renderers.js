/* Component illustrations for the review dashboard. Browser-preview drawings of PROPOSED Figma components, not Figma components.
   Every colour, size, radius, gap and text style is read from the specification through the context passed to VRender.init(): the
   component's own stateStyles / toneStyles / variable names. A variable that does not exist is drawn as a marker and reported (VRender.lastMissing).
   Icon glyphs are generic placeholder strokes, not the web system's icons. No colour or size literal lives in this file. */
(function () {
  'use strict';
  var X = null, missing = [];
  function el(tag, attrs, kids) {
    var e = document.createElement(tag);
    Object.keys(attrs || {}).forEach(function (k) { if (k === 'style') e.style.cssText = attrs[k]; else if (k === 'text') e.textContent = attrs[k]; else e.setAttribute(k, attrs[k]); });
    (kids || []).forEach(function (c) { if (c != null) e.appendChild(typeof c === 'string' ? document.createTextNode(c) : c); });
    return e;
  }
  var GLYPH = {
    search: 'M11 4a7 7 0 1 0 0 14a7 7 0 0 0 0-14zM20 20l-4.2-4.2', close: 'M6 6l12 12M18 6L6 18', heart: 'M12 20s-7-4.6-7-10a4 4 0 0 1 7-2.6A4 4 0 0 1 19 10c0 5.4-7 10-7 10z',
    bag: 'M6 8h12l1 12H5L6 8zM9 8V6a3 3 0 0 1 6 0v2', 'chevron-down': 'M6 9l6 6 6-6', 'chevron-right': 'M9 6l6 6-6 6', 'chevron-left': 'M15 6l-6 6 6 6', 'chevron-up': 'M6 15l6-6 6 6',
    'arrow-right': 'M5 12h14M13 6l6 6-6 6', 'arrow-left': 'M19 12H5M11 6l-6 6 6 6', check: 'M5 12.5l4.5 4.5L19 7.5', plus: 'M12 5v14M5 12h14', minus: 'M5 12h14',
    star: 'M12 3l2.7 5.6 6.1.9-4.4 4.3 1 6.1L12 17l-5.4 2.9 1-6.1L3.2 9.5l6.1-.9z', warning: 'M12 3l10 18H2L12 3zM12 10v5M12 17.5v.5', info: 'M12 3a9 9 0 1 0 0 18a9 9 0 0 0 0-18zM12 11v6M12 7.5v.5',
    'check-circle': 'M12 3a9 9 0 1 0 0 18a9 9 0 0 0 0-18zM8 12.5l3 3 5-6', filter: 'M4 6h16M7 12h10M10 18h4', menu: 'M4 7h16M4 12h16M4 17h16', account: 'M12 12a4 4 0 1 0 0-8a4 4 0 0 0 0 8zM4 20a8 8 0 0 1 16 0'
  };
  function glyph(name, size, color, filled) {
    var ns = 'http://www.w3.org/2000/svg', s = document.createElementNS(ns, 'svg'); s.setAttribute('viewBox', '0 0 24 24'); s.setAttribute('width', size); s.setAttribute('height', size); s.setAttribute('aria-hidden', 'true'); s.style.flex = 'none';
    var p = document.createElementNS(ns, 'path'); p.setAttribute('d', GLYPH[name] || 'M5 5h14v14H5z'); p.setAttribute('fill', filled ? 'currentColor' : 'none'); p.setAttribute('stroke', 'currentColor'); p.setAttribute('stroke-width', '1.6'); p.setAttribute('stroke-linecap', 'round'); p.setAttribute('stroke-linejoin', 'round');
    s.appendChild(p); s.style.color = color || 'currentColor'; return s;
  }
  function C(n) { if (!X.has(n)) { if (missing.indexOf(n) < 0) missing.push(n); return 'transparent'; } return X.col(n); }
  function N(n) { if (!X.has(n)) { if (missing.indexOf(n) < 0) missing.push(n); return 0; } var v = X.num(n); return isNaN(v) ? 0 : v; }
  function T(style) { return X.css(style); }
  function bool(v) { return v === true || v === 'true'; }
  function find(c, p, keys) { return (c.stateStyles || []).filter(function (s) { return s && s.state === p.State && Object.keys(s.variant).every(function (k) { return String(p[k]) === String(s.variant[k]); }); })[0]; }
  function ring() { return 'outline:' + N('focus/ring-width') + 'px solid ' + C('color/focus/ring') + ';outline-offset:' + N('focus/ring-offset') + 'px;'; }
  function note(t) { return el('span', { class: 'miss', text: t }); }
  var COMP = {};
  function getComp(id) { return COMP[id]; }
  var R = {};

  R.button = function (c, p) {
    var k = String(p.Size || 'Md').toLowerCase(), s = find(c, p); if (!s) return note('no state style');
    var b = s.stroke ? N(s.strokeWidth) + 'px solid ' + C(s.stroke) : '0 solid transparent';
    var css = 'display:inline-flex;align-items:center;justify-content:center;gap:' + N('button/gap') + 'px;height:' + N('control/height/' + k) + 'px;min-width:' + N('touch-target/min') + 'px;padding:0 ' + N('control/padding-x/' + k) + 'px;border-radius:' + N('radius/control') + 'px;background:' + (s.fill ? C(s.fill) : 'transparent') + ';border:' + b + ';color:' + C(s.text) + ';' + T('Label/Button') + (p.Variant === 'Text' ? 'text-decoration:underline;' : '') + (s.focusRing ? ring() : '');
    var kids = []; if (bool(p['Show leading icon'])) kids.push(glyph(String(p.Icon || '').replace('Icon/', ''), N('icon/size/sm'))); kids.push(el('span', { text: p.Label || 'Label' })); if (bool(p['Show trailing icon'])) kids.push(glyph(String(p.Icon || '').replace('Icon/', ''), N('icon/size/sm')));
    return el('span', { style: css }, kids);
  };
  R['icon-button'] = function (c, p) {
    var focus = p.State === 'Focus', dis = p.State === 'Disabled', sel = bool(p.Selected) || p.Selected === 'true';
    var wrap = el('span', { style: 'position:relative;display:inline-flex;align-items:center;justify-content:center;width:' + N('touch-target/min') + 'px;height:' + N('touch-target/min') + 'px;border-radius:' + N('radius/pill') + 'px;color:' + (dis ? C('color/text/disabled') : sel ? C('color/brand/primary') : C('color/text/primary')) + ';' + (focus ? ring() : '') }, [glyph(String(p.Icon || 'Icon/search').replace('Icon/', ''), N('icon/size/lg'), null, sel)]);
    if (bool(p['Show count'])) wrap.appendChild(el('span', { style: 'position:absolute;top:2px;right:2px;min-width:' + N('icon-button/count-size') + 'px;height:' + N('icon-button/count-size') + 'px;border-radius:' + N('radius/pill') + 'px;background:' + C('color/brand/primary') + ';color:' + C('color/text/on-brand') + ';display:flex;align-items:center;justify-content:center;font-size:10px', text: p.Count || '2' }));
    var out = el('span', { style: 'display:inline-grid;gap:4px;justify-items:start' }, [wrap]);
    if (p.State === 'Hover' || p.State === 'Pressed') out.appendChild(el('span', { class: 'miss', style: 'color:inherit;opacity:.8', text: p.State + ' fill not specified' }));
    return out;
  };
  R['input-field'] = function (c, p) {
    var s = find(c, p); if (!s) return note('no state style'); var type = p.Type || 'Text';
    var b = N(s.strokeWidth) + 'px ' + (s.strokeStyle === 'dashed' ? 'dashed' : 'solid') + ' ' + C(s.stroke);
    var h = type === 'Textarea' ? 'min-height:' + N('input/textarea-min-height') + 'px;align-items:flex-start;padding-top:' + N('input/padding-y') + 'px;' : 'height:' + N('control/height/md') + 'px;';
    var ctl = el('div', { style: 'display:flex;align-items:center;justify-content:space-between;width:220px;' + h + 'padding:0 ' + N('input/padding-x') + 'px;border-radius:' + N('radius/control') + 'px;background:' + C(s.fill) + ';border:' + b + ';color:' + (p.Value ? C(s.text) : C('color/text/muted')) + ';' + T('Form/Input') + (s.focusRing ? ring() : '') }, [el('span', { text: p.Value || (type === 'Select' ? 'Choose' : 'name@example.com') }), type === 'Select' ? glyph('chevron-down', N('icon/size/md')) : null]);
    var kids = [el('span', { style: T('Label/Default') + 'color:' + C('color/text/primary'), text: (p.Label || 'Label') + (bool(p.Required) ? ' *' : '') }), ctl];
    if (bool(p['Show hint'])) kids.push(el('span', { style: T('Body/Small') + 'color:' + C('color/text/secondary'), text: p.Hint || 'Hint text' }));
    if (p.State === 'Error') kids.push(el('span', { style: 'display:inline-flex;gap:4px;align-items:center;' + T('Form/Validation') + 'color:' + C('color/status/error') }, [glyph('warning', N('icon/size/sm')), el('span', { text: p['Error message'] || 'Error' })]));
    return el('div', { style: 'display:grid;gap:' + N('form/label-gap') + 'px;justify-items:start' }, kids);
  };
  R.choice = function (c, p) {
    var s = find(c, p); if (!s) return note('no state style'); var radio = p.Type === 'Radio', on = String(p.Checked) === 'true', bs = N('choice/size');
    var box = el('span', { style: 'display:inline-flex;align-items:center;justify-content:center;width:' + bs + 'px;height:' + bs + 'px;border-radius:' + (radio ? N('radius/pill') : N('radius/sm')) + 'px;background:' + C(s.fill) + ';border:' + N(s.strokeWidth) + 'px ' + (s.strokeStyle === 'dashed' ? 'dashed' : 'solid') + ' ' + C(s.stroke) + ';color:' + C('color/text/on-brand') + ';' + (s.focusRing ? ring() : '') }, [on ? (radio ? el('span', { style: 'width:' + N('choice/dot-size') + 'px;height:' + N('choice/dot-size') + 'px;border-radius:' + N('radius/pill') + 'px;background:currentColor' }) : glyph('check', N('choice/check-size'))) : null]);
    return el('span', { style: 'display:inline-flex;align-items:center;gap:' + N('choice/gap') + 'px;min-height:' + N('touch-target/min') + 'px;color:' + C(s.text) + ';' + T('Body/Default') }, [box, el('span', { text: p.Label || 'Label' })]);
  };
  R.chip = function (c, p) {
    var s = find(c, p); if (!s) return note('no state style'); var sel = String(p.Selected) === 'true', rem = bool(p.Removable);
    var css = 'display:inline-flex;align-items:center;gap:' + N('space/2') + 'px;height:' + N('control/height/sm') + 'px;min-width:' + N('touch-target/min') + 'px;justify-content:center;padding:0 ' + N('space/4') + 'px;border-radius:' + N('radius/pill') + 'px;background:' + C(s.fill) + ';border:' + N(s.strokeWidth) + 'px ' + (s.strokeStyle === 'dashed' ? 'dashed' : 'solid') + ' ' + C(s.stroke) + ';color:' + C(s.text) + ';' + T('Label/Default') + (s.focusRing ? ring() : '');
    return el('span', { style: css }, [sel && !rem ? glyph('check', N('icon/size/sm')) : null, el('span', { text: p.Label || 'Label' }), rem ? glyph('close', N('icon/size/sm')) : null]);
  };
  R.swatch = function (c, p) {
    var sm = p.Size === 'Sm', size = N(sm ? 'swatch/size-sm' : 'swatch/size'), sel = String(p.Selected) === 'true', dis = p.State === 'Disabled', foc = p.State === 'Focus';
    var css = 'display:inline-block;width:' + size + 'px;height:' + size + 'px;border-radius:' + N('radius/pill') + 'px;background:' + C('color/brand/tint-strong') + ';' + (dis ? 'opacity:' + N('opacity/disabled') + ';background-image:linear-gradient(to top right,transparent calc(50% - 1px),' + C('color/text/primary') + ' 50%,transparent calc(50% + 1px));' : '') + (sel ? 'outline:' + N('swatch/ring-width') + 'px solid ' + C('color/text/primary') + ';outline-offset:' + N('swatch/ring-offset') + 'px;' : '') + (foc ? 'box-shadow:0 0 0 ' + (N('swatch/ring-offset') + N('focus/ring-width')) + 'px ' + C('color/focus/ring') + ';' : '');
    return el('span', { style: 'display:inline-grid;gap:6px;justify-items:center;padding:' + (N('swatch/ring-offset') + N('swatch/ring-width') + 2) + 'px' }, [el('span', { style: css, title: 'placeholder colour: the real colour is product data, not a variable' })]);
  };
  R.badge = function (c, p) {
    var t = (c.toneStyles || []).filter(function (x) { return x.tone === p.Tone; })[0]; if (!t) return note('no tone style');
    return el('span', { style: 'display:inline-flex;align-items:center;gap:' + N('space/1') + 'px;padding:' + N('badge/padding-y') + 'px ' + N('badge/padding-x') + 'px;border-radius:' + N('radius/badge') + 'px;background:' + (t.fill ? C(t.fill) : 'transparent') + ';border:' + (t.stroke ? N(t.strokeWidth) + 'px solid ' + C(t.stroke) : '0 solid transparent') + ';color:' + C(t.text) + ';' + T('Label/Utility') }, [bool(p['Show icon']) ? glyph('info', N('icon/size/sm')) : null, el('span', { text: p.Label || 'Label' })]);
  };
  R.message = function (c, p) {
    var t = (c.toneStyles || []).filter(function (x) { return x.tone === p.Tone; })[0]; if (!t) return note('no tone style');
    var kids = [glyph(String(p.Icon || 'Icon/warning').replace('Icon/', ''), N('icon/size/md'), C(t.icon)), el('span', { style: 'flex:1;' + T('Body/Small') + 'color:' + C(t.text), text: p.Text || 'Message' })];
    if (bool(p['Show action'])) kids.push(R.button(COMP.button, { Variant: 'Text', Size: 'Sm', State: 'Default', Label: 'Try again' }));
    return el('div', { style: 'display:flex;gap:' + N('space/3') + 'px;align-items:flex-start;width:320px;padding:' + N('space/3') + 'px ' + N('space/4') + 'px;border-radius:' + N('radius/control') + 'px;background:' + C(t.fill) }, kids);
  };
  R.quantity = function (c, p) {
    var dis = p.State === 'Disabled', foc = p.State === 'Focus', bt = function (g, off) { return el('span', { style: 'display:inline-flex;align-items:center;justify-content:center;width:' + N('touch-target/min') + 'px;height:100%;opacity:' + (off || dis ? N('opacity/disabled') : 1) }, [glyph(g, N('icon/size/md'))]); };
    return el('span', { style: 'display:inline-flex;align-items:center;height:' + N('control/height/md') + 'px;border:' + N('border-width/thin') + 'px solid ' + C('color/control/border') + ';border-radius:' + N('radius/control') + 'px;background:' + C('color/control/bg') + ';color:' + C('color/text/primary') + ';' + T('Form/Input') + (foc ? ring() : '') }, [bt('minus', bool(p['Minus disabled'])), el('span', { style: 'width:' + N('qty/input-width') + 'px;text-align:center', text: p.Value || '1' }), bt('plus', bool(p['Plus disabled']))]);
  };
  R.rating = function (c, p) {
    var v = Number(p.Value), kids = []; for (var i = 1; i <= 5; i++) kids.push(glyph('star', N('icon/size/sm'), i <= v ? C('color/rating/star') : C('color/rating/star-empty'), i <= v));
    if (bool(p['Show count'])) kids.push(el('span', { style: T('Body/Caption') + 'color:' + C('color/text/secondary'), text: p.Count || '' }));
    return el('span', { style: 'display:inline-flex;align-items:center;gap:' + N('rating/gap') + 'px' }, kids);
  };
  R['accordion-item'] = function (c, p) {
    var open = String(p.Open) === 'true', foc = p.State === 'Focus';
    var sum = el('div', { style: 'display:flex;align-items:center;justify-content:space-between;min-height:' + N('touch-target/min') + 'px;color:' + C('color/text/primary') + ';' + T('Heading/H5') + (foc ? ring() : '') }, [el('span', { text: p.Title || 'Title' }), el('span', { style: 'display:inline-flex;transform:rotate(' + (open ? 180 : 0) + 'deg)' }, [glyph('chevron-down', N('icon/size/md'))])]);
    var kids = [sum]; if (open) kids.push(el('div', { style: 'padding-bottom:' + N('space/5') + 'px;max-width:' + N('layout/container/text') + 'px' }, [1, 2, 3].map(function (i) { return el('div', { style: 'height:8px;margin:8px 0;border-radius:4px;width:' + (i === 3 ? '60%' : '100%') + ';background:' + C('color/bg/subtle') }); }).concat([el('span', { class: 'miss', style: 'color:inherit;opacity:.7', text: 'content slot (instance swap)' })])));
    if (p.State === 'Hover') kids.push(el('span', { class: 'miss', style: 'color:inherit;opacity:.8', text: 'hover style not specified' }));
    return el('div', { style: 'width:300px;border-bottom:' + N('border-width/thin') + 'px solid ' + C('color/border/subtle') }, kids);
  };
  R.breadcrumb = function (c, p) {
    var items = String(p.Items || 'Home / Skincare / Serums / Rosewater Barrier Serum').split(/\s*\/\s*/), compact = p.Layout === 'Compact', shown = compact ? items.slice(-2) : items, row = [];
    shown.forEach(function (it, i) {
      var last = i === shown.length - 1;
      if (i > 0) row.push(glyph('chevron-right', N('icon/size/sm'), C('color/text/muted')));
      row.push(el('span', { style: 'display:inline-flex;align-items:center;min-height:' + N('touch-target/min') + 'px;min-width:' + (last ? 0 : N('touch-target/min')) + 'px;' + T('Body/Small') + 'color:' + (last ? C('color/text/primary') : C('color/text/secondary')) + (last ? '' : ';text-decoration:underline') + (compact && last && bool(p['Truncate current']) ? ';overflow:hidden;text-overflow:ellipsis;white-space:nowrap;flex:1 1 0' : ''), text: it }));
    });
    return el('div', { style: 'display:flex;align-items:center;gap:' + N('space/2') + 'px;width:' + (compact ? 240 : 420) + 'px;flex-wrap:' + (compact ? 'nowrap' : 'wrap') }, row);
  };
  R.pagination = function (c, p) {
    if (p.Pattern === 'Load more') {
      var st = p['Load more state'] || 'Default', kids = [];
      if (st !== 'Error') kids.push(el('span', { style: T('Body/Caption') + 'color:' + C('color/text/secondary'), text: st === 'Done' ? 'All products shown' : st === 'Loading' ? 'Loading more products' : (p['Status text'] || 'Showing 24 of 96 products') }));
      if (st === 'Error') kids.push(R.message(COMP.message, { Tone: 'Error', Text: 'Could not load more products. Check your connection and try again.', Icon: 'Icon/warning', 'Show action': 'false' }));
      if (st === 'Default') kids.push(R.button(COMP.button, { Variant: 'Secondary', Size: 'Md', State: 'Default', Label: 'Load more products' }));
      if (st === 'Loading') kids.push(R.button(COMP.button, { Variant: 'Secondary', Size: 'Md', State: 'Disabled', Label: 'Loading...' }));
      if (st === 'Error') kids.push(R.button(COMP.button, { Variant: 'Secondary', Size: 'Md', State: 'Default', Label: 'Try again' }));
      return el('div', { style: 'display:grid;gap:' + N('space/3') + 'px;justify-items:center;width:320px' }, kids);
    }
    var labels = ['Previous', '1', '2', '3', '...', '12', 'Next'], cur = String(p['Current page'] || '1');
    return el('div', { style: 'display:flex;gap:' + N('space/1') + 'px;align-items:center;flex-wrap:wrap' }, labels.map(function (l) {
      var isCur = l === cur, dis = l === 'Previous', gap = l === '...';
      return el('span', { style: 'display:inline-flex;align-items:center;justify-content:center;min-width:' + N('touch-target/min') + 'px;min-height:' + N('touch-target/min') + 'px;padding:0 ' + N('space/3') + 'px;border-radius:' + N('radius/control') + 'px;' + T('Label/Default') + 'background:' + (isCur ? C('color/button/primary-bg') : 'transparent') + ';color:' + (isCur ? C('color/button/primary-text') : dis || gap ? C('color/text/muted') : C('color/text/primary')) + (dis ? ';text-decoration:line-through' : ''), text: l });
    }));
  };
  R.drawer = function (c, p) {
    var sheet = p.Presentation === 'Sheet', fw = X.numMode('layout/frame-width', sheet ? 'Mobile' : 'Tablet'), dw = sheet ? fw : X.numMode('layout/drawer-width', 'Tablet'), H = 560, scale = sheet ? 0.62 : 0.4;
    var head = el('div', { style: 'display:flex;align-items:center;justify-content:space-between;padding:' + N('space/1') + 'px ' + N('space/1') + 'px ' + N('space/1') + 'px ' + N('space/4') + 'px;border-bottom:' + N('border-width/thin') + 'px solid ' + C('color/border/subtle') }, [el('span', { style: T('Heading/H5') + 'color:' + C('color/text/primary'), text: p.Title || 'Filters' }), R['icon-button'](COMP['icon-button'], { State: 'Default', Selected: 'false', Icon: 'Icon/close', 'Show count': 'false' })]);
    var rows = [0, 1, 2, 3, 4, 5].map(function (i) { return R.choice(COMP.choice, { Type: 'Checkbox', Checked: String(i === 1), State: 'Default', Label: 'Option ' + (i + 1) }); });
    var body = el('div', { style: 'flex:1;overflow:hidden;padding:' + N('space/3') + 'px ' + N('space/4') + 'px;display:grid;align-content:start' }, rows);
    var kids = [head, body]; if (bool(p['Show footer'])) kids.push(el('div', { style: 'padding:' + N('space/4') + 'px;border-top:' + N('border-width/thin') + 'px solid ' + C('color/border/subtle') + ';display:grid' }, [el('span', { style: 'display:grid' }, [R.button(COMP.button, { Variant: 'Primary', Size: 'Md', State: 'Default', Label: p['Primary action'] || 'Show products' })])]));
    var panel = el('div', { style: 'position:absolute;top:0;right:0;bottom:0;width:' + dw + 'px;display:flex;flex-direction:column;background:' + C('color/bg/surface') }, kids);
    var frame = el('div', { style: 'position:relative;width:' + fw + 'px;height:' + H + 'px;background:' + C('color/bg/page') + ';transform:scale(' + scale + ');transform-origin:top left;overflow:hidden' }, [!sheet && bool(p['Show scrim']) ? el('div', { style: 'position:absolute;inset:0;background:' + C('color/overlay/scrim') }) : null, panel]);
    return el('div', { style: 'display:grid;gap:6px' }, [el('div', { style: 'width:' + fw * scale + 'px;height:' + H * scale + 'px;border:1px solid ' + C('color/border/subtle') + ';overflow:hidden' }, [frame]), el('span', { style: 'font-size:12px;opacity:.7', text: (sheet ? 'Sheet: fills the ' : 'Panel: ') + dw + 'px ' + (sheet ? 'Mobile frame' : 'wide in a ' + fw + 'px Tablet frame') + ' (drawn at ' + Math.round(scale * 100) + '%)' })]);
  };
  R['product-card'] = function (c, p) {
    var sold = bool(p['Sold out']), foc = p.State === 'Focus', kids = [];
    var media = el('div', { style: 'position:relative;aspect-ratio:4/5;border-radius:' + N('radius/card') + 'px;background:' + C('color/bg/subtle') + ';opacity:' + (sold ? N('opacity/muted') : 1) + ';display:flex;align-items:flex-end;justify-content:center;overflow:hidden' }, [el('span', { style: 'font-size:12px;opacity:.7;padding:8px;text-align:center', text: 'image placeholder 4:5 (provisional canvas; no photography supplied)' })]);
    var over = el('div', { style: 'position:absolute;inset:' + N('product-card/badge-offset') + 'px;display:flex;justify-content:space-between;align-items:flex-start;pointer-events:none' }, [(bool(p['Show badge']) || sold) ? R.badge(COMP.badge, { Tone: sold ? 'Dark' : 'Brand', Label: sold ? 'Sold out' : 'Sale', 'Show icon': 'false' }) : el('span'), el('span', { style: 'display:inline-flex;width:' + N('touch-target/min') + 'px;height:' + N('touch-target/min') + 'px;margin:-' + N('space/2') + 'px;align-items:center;justify-content:center;border-radius:' + N('radius/pill') + 'px;background:' + C('color/bg/surface') + ';color:' + C('color/text/primary') }, [glyph('heart', N('icon/size/md'))])]);
    media.appendChild(over); kids.push(media);
    var body = [el('span', { style: T('Label/Overline') + 'color:' + C('color/text/secondary'), text: p.Brand || 'BRAND' }), el('span', { style: T('Product/Title') + 'color:' + C('color/text/primary'), text: p.Title || 'Product title' })];
    if (bool(p['Show rating'])) body.push(R.rating(COMP.rating, { Value: '5', 'Show count': 'true', Count: '(86)' }));
    body.push(el('span', { style: T('Product/Price') + 'color:' + C('color/text/primary') }, [el('span', { style: bool(p['Show badge']) ? 'color:' + C('color/price/sale') : '', text: p.Price || '$0.00' }), p['Compare price'] ? el('span', { style: 'margin-left:8px;text-decoration:line-through;color:' + C('color/text/muted'), text: p['Compare price'] }) : null]));
    if (bool(p['Show swatches'])) body.push(el('span', { style: 'display:inline-flex;gap:' + N('space/1') + 'px' }, [1, 2, 3].map(function () { return R.swatch(COMP.swatch, { Size: 'Sm', Selected: 'false', State: 'Default' }); })));
    body.push(R.button(COMP.button, { Variant: 'Secondary', Size: 'Md', State: sold ? 'Disabled' : 'Default', Label: sold ? 'Sold out' : 'Add to bag' }));
    kids.push(el('div', { style: 'display:grid;gap:' + N('product-card/gap') + 'px;justify-items:start;margin-top:' + N('product-card/gap') + 'px' }, body));
    return el('div', { style: 'width:220px;border-radius:' + N('radius/card') + 'px;' + (foc ? ring() : '') }, kids);
  };

  function defaults(c) { var d = {}; (c.properties || []).forEach(function (q) { d[q.name] = q.default; }); return d; }
  window.VRender = {
    init: function (ctx) { X = ctx; COMP = {}; ctx.components.forEach(function (c) { COMP[c.id] = c; }); },
    supported: function (id) { return !!R[id]; },
    defaults: defaults,
    render: function (c, props) { missing = []; var p = {}; var d = defaults(c); Object.keys(d).forEach(function (k) { p[k] = d[k]; }); Object.keys(props || {}).forEach(function (k) { p[k] = props[k]; }); var out = R[c.id] ? R[c.id](c, p) : null; var m = missing.slice(); return { node: out, missing: m }; },
    glyph: glyph,
    combos: function (c, cap) {
      var axes = (c.properties || []).filter(function (q) { return q.type === 'VARIANT'; }), res = [{}];
      axes.forEach(function (a) { var next = []; res.forEach(function (r) { a.values.forEach(function (v) { var o = {}; Object.keys(r).forEach(function (k) { o[k] = r[k]; }); o[a.name] = v; next.push(o); }); }); res = next; });
      return { list: res.slice(0, cap || 60), total: res.length };
    }
  };
})();
