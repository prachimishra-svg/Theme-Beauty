/* Phase 6: design-system consistency. For each page the set of fonts, text colours, background colours, border colours, radii and shadows used by the ORIGINAL wireframe elements is collected; then the interactive
   layer's own elements (search overlay, cart drawer, toast, prototype pill) are opened and every value they use is checked against that set. A value outside the set is a design-system deviation. Also checks that every
   icon reference points at a symbol in the shared sprite, and that the interactive pages use the same font stack as the originals. */
function vis(e, w) { var cs = w.getComputedStyle(e), r = e.getBoundingClientRect(); return cs.display !== 'none' && cs.visibility !== 'hidden' && r.width > 0 && r.height > 0; }
function lab(e) { return e.tagName.toLowerCase() + (e.id ? '#' + e.id : '') + '.' + String(e.className).split(/\s+/).slice(0, 2).join('.'); }
function norm(c) { return String(c).replace(/\s+/g, ''); }
function collect(root, w, text) {
  var S = { font: {}, color: {}, bg: {}, border: {}, radius: {}, shadow: {} };
  [].forEach.call(root.querySelectorAll('*'), function (e) {
    if (!vis(e, w) || /^(SCRIPT|STYLE|SVG|PATH|USE|G|DEFS)$/i.test(e.tagName) || e.closest('svg')) return; var cs = w.getComputedStyle(e);
    if (text || (e.childNodes.length && [].some.call(e.childNodes, function (n) { return n.nodeType === 3 && n.textContent.trim(); }))) { S.font[cs.fontFamily.split(',')[0].replace(/["']/g, '').trim()] = 1; S.color[norm(cs.color)] = lab(e); }
    if (cs.backgroundColor !== 'rgba(0, 0, 0, 0)') S.bg[norm(cs.backgroundColor)] = lab(e);
    if (parseFloat(cs.borderTopWidth) > 0 && cs.borderTopStyle !== 'none') S.border[norm(cs.borderTopColor)] = lab(e);
    if (cs.borderTopLeftRadius !== '0px') S.radius[cs.borderTopLeftRadius] = 1; if (cs.boxShadow !== 'none') S.shadow[cs.boxShadow] = 1;
  });
  return S;
}
/* the design system's own values: every --color-*, --radius-* and --shadow-* custom property, resolved to its computed value through a probe element */
function tokenSet(d, w) {
  var names = {}; [].forEach.call(d.styleSheets, function (sh) { var rules; try { rules = sh.cssRules; } catch (e) { return; } [].forEach.call(rules, function (r) { if (r.style) for (var i = 0; i < r.style.length; i++) { var n = r.style[i]; if (/^--(color|radius|shadow|palette)/.test(n)) names[n] = 1; } }); });
  var probe = d.createElement('div'); probe.style.cssText = 'position:absolute;left:-9999px;top:0;width:10px;height:10px'; d.body.appendChild(probe);
  var T = { color: {}, radius: {}, shadow: {} }, n = 0;
  Object.keys(names).forEach(function (k) { n++; if (/^--(color|palette)/.test(k)) { probe.style.color = ''; probe.style.color = 'var(' + k + ')'; var c = norm(w.getComputedStyle(probe).color); if (c) T.color[c] = 1; probe.style.backgroundColor = ''; probe.style.backgroundColor = 'var(' + k + ')'; var b = norm(w.getComputedStyle(probe).backgroundColor); if (b) T.color[b] = 1; }
    else if (/^--radius/.test(k)) { probe.style.borderRadius = ''; probe.style.borderRadius = 'var(' + k + ')'; T.radius[w.getComputedStyle(probe).borderTopLeftRadius] = 1; }
    else if (/^--shadow/.test(k)) { probe.style.boxShadow = ''; probe.style.boxShadow = 'var(' + k + ')'; T.shadow[w.getComputedStyle(probe).boxShadow] = 1; } });
  probe.remove(); T.count = n; return T;
}
function outside(newS, base, T) {
  var bad = [], ok = function (kind, v) { return T && (T[kind] || {})[v]; };
  Object.keys(newS).forEach(function (k) { Object.keys(newS[k]).forEach(function (v) {
    if (base[k][v]) return; var kind = (k === 'color' || k === 'bg' || k === 'border') ? 'color' : k; if (kind === 'font') { bad.push(k + ' ' + v); return; }
    if (v === 'rgba(0,0,0,0)' || /^(0px|rgba\(0, 0, 0, 0\) 0px 0px 0px 0px(, rgba\(0, 0, 0, 0\) 0px 0px 0px 0px)*)$/.test(v)) return;
    if (ok(kind, v)) return; /* a shadow stack may contain the zero-offset rings of utilities: accept when every layer is a token layer or a zero ring */
    if (kind === 'shadow') { var layers = v.split(/,(?![^(]*\))/).map(function (s) { return s.trim(); }).filter(function (s) { return !/^rgba\(0, 0, 0, 0\) 0px 0px 0px 0px$/.test(s); }); var tokenLayers = Object.keys(T.shadow).join(' | '); if (layers.every(function (s) { return tokenLayers.indexOf(s) > -1; })) return; }
    bad.push(k + ' ' + v + ' (' + (typeof newS[k][v] === 'string' ? newS[k][v] : '') + ')'); }); });
  return bad;
}
(async function main() {
  var pages = [['home', ''], ['collection', 'c=skin'], ['product', 'p=face-serum'], ['cart', ''], ['blog', ''], ['article', 'a=what-is-niacinamide']];
  size(1440, 900);
  for (var i = 0; i < pages.length; i++) {
    var pg = pages[i][0], g = 'P6 design ' + pg;
    await loadPlain(url(pg, pages[i][1], false)); var base = collect(D().body, W(), false), TK = tokenSet(D(), W()), fontsOrig = Object.keys(base.font).sort().join(' | ');
    var sprite = qa('use').map(function (u) { return (u.getAttribute('href') || '').replace('#', ''); }), miss = sprite.filter(function (id) { return id && !D().getElementById(id); });
    check(g, 'Every icon reference exists in the shared sprite (' + sprite.length + ' icons)', !miss.length, miss.slice(0, 5).join(','));
    await load(url(pg, pages[i][1])); TK = tokenSet(D(), W()); await sleep(3000); /* a person needs a few seconds before the first click; Tailwind Play compiles the drawer's classes in the meantime (a click within ~1 s on the 2,000-node Homepage can show unstyled buttons for a moment, noted in performance-audit.md) */ var fontsIx = Object.keys(collect(D().body, W(), false).font).sort().join(' | ');
    /* open every layer element */
    NS().cart.clear(); NS().cart.add('face-serum'); NS().cart.add('face-cleanser');
    if (pg !== 'cart') { NS().cartDrawer.open(); await sleep(1000); var dr = q('#ix-cart-drawer'); if (dr) { var s1 = collect(dr, W(), true); var b1 = outside(s1, base, TK); check(g, 'Cart drawer uses only design-system values', !b1.length, b1.slice(0, 5).join(' ; ')); try { W().NudgeDrawer.close(dr); } catch (e) { /* */ } await sleep(200); } }
    NS().searchOverlay.open('serum'); await sleep(500); var so = q('#ix-search'); var s2 = collect(so, W(), true), b2 = outside(s2, base, TK); check(g, 'Search overlay uses only design-system values', !b2.length, b2.slice(0, 5).join(' ; ')); NS().searchOverlay.close();
    NS().notify('Design check', { kind: 'success' }); await sleep(200); var s3 = collect(q('#ix-toast'), W(), true), b3 = outside(s3, base, TK); check(g, 'Toast uses only design-system values', !b3.length, b3.slice(0, 5).join(' ; '));
    var s4 = collect(q('#ix-pill'), W(), true), b4 = outside(s4, base, TK); rec(g, 'Prototype pill (reviewer control, not part of the site) uses design-system values', b4.length ? 'review' : 'pass', b4.slice(0, 5).join(' ; '));
    check(g, 'Font stack unchanged by the layer (' + fontsOrig + ')', fontsOrig === fontsIx || fontsIx.split(' | ').every(function (f) { return fontsOrig.indexOf(f) > -1; }), fontsOrig + ' vs ' + fontsIx);
  }
  finish();
})().catch(function (e) { rec('HARNESS', 'error', 'fail', e && e.stack || e); finish(); });
