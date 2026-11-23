/* Phase 3: responsive matrix. Each viewport is an iframe of that exact width and height (headless Chrome cannot open windows narrower than ~500 px or wider than the screen, so frames are the way, as the project's
   own self-tests do). Checks per page and viewport: horizontal overflow (with the offending element), section overlap, clipped text, broken images, touch targets (below 1024 px), container width on large
   displays, header/menu state, and drawers/overlays fitting. Real device pixel ratio, real touch and OS zoom are NOT emulated and are reported as NOT TESTED in the report. */
var VP = {
  desktop: [[1024, 768], [1280, 800], [1366, 768], [1440, 900], [1600, 900], [1920, 1080]],
  ultra: [[2048, 1152], [2560, 1440], [3440, 1440]],
  tablet: [[600, 1024], [768, 1024], [820, 1180], [834, 1194], [1024, 1366], [1024, 768], [1180, 820], [1194, 834], [1024, 600]],
  mobile: [[320, 568], [360, 780], [375, 667], [390, 844], [393, 852], [414, 896], [430, 932], [844, 390], [667, 375]],
  tv: [[3840, 2160], [5120, 2880]]
};
var KEY = [['home', ''], ['collection', 'c=skin'], ['product', 'p=face-serum'], ['cart', ''], ['blog', ''], ['article', 'a=what-is-niacinamide']];
var OTHER = [['drawer', ''], ['contact', ''], ['faq', ''], ['about', ''], ['story', ''], ['shipping', ''], ['returns', ''], ['privacy', ''], ['terms', ''], ['notfound', '']];
var OTHER_W = [[320, 568], [390, 844], [768, 1024], [1024, 768], [1440, 900], [1920, 1080], [3840, 2160]];
function vis(e, w) { var cs = w.getComputedStyle(e), r = e.getBoundingClientRect(); return cs.display !== 'none' && cs.visibility !== 'hidden' && r.width > 0 && r.height > 0; }
function nm(e) { return e.tagName.toLowerCase() + (e.id ? '#' + e.id : '') + (e.className && typeof e.className === 'string' ? '.' + e.className.split(/\s+/).slice(0, 2).join('.') : '') + ' "' + (e.textContent || '').trim().slice(0, 24) + '"'; }
function probe(wd, ht, page) {
  var d = D(), w = W(), res = {}, de = d.documentElement;
  res.docW = de.scrollWidth; res.overflow = [];
  if (de.scrollWidth > wd + 1) {
    [].forEach.call(d.body.querySelectorAll('*'), function (e) { if (res.overflow.length > 4 || !vis(e, w)) return; var r = e.getBoundingClientRect(); if (r.right > wd + 1 && !e.closest('[hidden],[aria-hidden=true],.sr-only')) { var p = e.parentElement, clipped = false; while (p && p !== d.body) { var o = w.getComputedStyle(p).overflowX; if (o === 'hidden' || o === 'auto' || o === 'scroll' || o === 'clip') { clipped = true; break; } p = p.parentElement; } if (!clipped) res.overflow.push(nm(e) + ' right=' + Math.round(r.right)); } });
  }
  /* section overlap */
  res.overlap = []; var secs = [].slice.call(d.querySelectorAll('main > section, [data-section]')).filter(function (e) { return vis(e, w) && !e.closest('.rv,#wp') && w.getComputedStyle(e).position !== 'fixed'; });
  for (var i = 1; i < secs.length; i++) { var a = secs[i - 1].getBoundingClientRect(), b = secs[i].getBoundingClientRect(); if (secs[i - 1].contains(secs[i]) || secs[i].contains(secs[i - 1])) continue; var pos = w.getComputedStyle(secs[i]).position; var hov = Math.min(a.right, b.right) - Math.max(a.left, b.left); if (hov > Math.min(a.width, b.width) * 0.5 && b.top < a.bottom - 3 && b.height > 20 && a.height > 20 && pos !== 'sticky' && pos !== 'absolute' && w.getComputedStyle(secs[i - 1]).position !== 'sticky') res.overlap.push((secs[i - 1].getAttribute('data-section') || secs[i - 1].id) + ' / ' + (secs[i].getAttribute('data-section') || secs[i].id)); }
  /* clipped text */
  res.clipped = []; [].forEach.call(d.body.querySelectorAll('h1,h2,h3,h4,p,a,button,span,li,label,td,th,b'), function (e) {
    if (res.clipped.length > 4 || !vis(e, w) || e.closest('.sr-only,[hidden],#ix-toast,.ph,.img,.in')) return; var cs = w.getComputedStyle(e); if (e.clientWidth <= 2 || e.getBoundingClientRect().width <= 2) return; /* visually hidden */
    if ((cs.overflowX === 'hidden' || cs.overflowX === 'clip') && e.scrollWidth > e.clientWidth + 2 && cs.textOverflow !== 'ellipsis' && e.children.length < 3 && (e.textContent || '').trim().length > 3) res.clipped.push(nm(e) + ' ' + e.scrollWidth + '>' + e.clientWidth);
  });
  res.broken = [].filter.call(d.querySelectorAll('img'), function (i) { return i.complete && i.naturalWidth === 0 && vis(i, w); }).length;
  /* touch targets */
  res.small = [];
  if (wd < 1024) [].forEach.call(d.body.querySelectorAll('a[href],button,summary,input:not([type=hidden]),select,[role=button]'), function (e) {
    if (res.small.length > 6 || !vis(e, w) || e.closest('.sr-only,.rv,#wp,.ann,#ix-pill')) return; var cs = w.getComputedStyle(e), r = e.getBoundingClientRect(); if (cs.pointerEvents === 'none') return; var af = w.getComputedStyle(e, '::after'); if (af.position === 'absolute' && af.content !== 'none' && af.content !== 'normal') return; /* stretched card link: the whole card is the target */
    if (e.tagName === 'A' && cs.display === 'inline' && e.closest('p,li,dd,td')) return; if (e.type === 'radio' || e.type === 'checkbox') { var l = e.closest('label'); if (l) { r = l.getBoundingClientRect(); } }
    if (Math.min(r.width, r.height) < 40) res.small.push(nm(e) + ' ' + Math.round(r.width) + 'x' + Math.round(r.height));
  });
  /* containers on large displays */
  var hdr = d.querySelector('#site-header > div'), wr = d.querySelector('main .wrap, main .sec__in, main [class*="max-w"]');
  res.container = hdr ? Math.round(hdr.getBoundingClientRect().width) : 0; res.h1 = (function () { var h = d.querySelector('h1'); return h ? parseFloat(w.getComputedStyle(h).fontSize) : 0; })();
  var menu = d.getElementById('menu-btn'); res.menuVisible = menu ? vis(menu, w) : null;
  var hh = d.getElementById('site-header'); res.headerH = hh ? Math.round(hh.getBoundingClientRect().height) : 0;
  return res;
}
async function drawersFit(wd, ht, g) {
  var h = W().NudgeSite; if (!h) return;
  var sl = qa('#site-header a[href="#search"]').filter(function (a) { return a.offsetParent !== null; })[0];
  if (sl) { sl.click(); await sleep(250); var pn = q('#ix-search > div'); if (pn) { var r = pn.getBoundingClientRect(); check(g, 'Search overlay fits (' + Math.round(r.width) + 'x' + Math.round(r.height) + ')', r.left >= -1 && r.right <= wd + 1 && r.bottom <= ht + 1 && r.width > 0, 'l' + Math.round(r.left) + ' r' + Math.round(r.right) + ' b' + Math.round(r.bottom) + ' vs ' + wd + 'x' + ht); }
    D().dispatchEvent(new (W().KeyboardEvent)('keydown', { key: 'Escape', bubbles: true })); await sleep(100); }
  h.cart.clear(); h.cart.add('face-serum'); h.cart.add('face-cleanser');
  var cl = qa('#site-header a[aria-label^="Cart"]').filter(function (a) { return a.offsetParent !== null; })[0];
  if (cl) { cl.click(); await sleep(900); var dr = q('#ix-cart-drawer'); if (dr) { var rr = dr.getBoundingClientRect(), foot = q('#cd-checkout', dr); var fb = foot ? foot.getBoundingClientRect() : null; check(g, 'Cart drawer fits and Checkout stays on screen (' + Math.round(rr.width) + ' px wide)', dr.open && rr.width > 200 && rr.right <= wd + 1 && rr.left >= -1 && fb && fb.bottom <= ht + 1, 'l' + Math.round(rr.left) + ' r' + Math.round(rr.right) + ' checkoutBottom ' + (fb ? Math.round(fb.bottom) : '-') + ' vs ' + ht); try { W().NudgeDrawer.close(dr); } catch (e) { /* */ } } else rec(g, 'Cart drawer opens', 'fail', 'no drawer'); }
  h.cart.clear();
}
async function runPage(group, pg, vp, withDrawers) {
  var wd = vp[0], ht = vp[1]; size(wd, ht); var g = 'P3 ' + group + ' ' + pg[0] + ' @' + wd + 'x' + ht;
  var st = await load(url(pg[0], pg[1]));
  if (st !== 'ready') { rec(g, 'Page loads in interactive mode', 'fail', st); return; }
  var r = probe(wd, ht, pg[0]);
  check(g, 'No horizontal overflow', r.docW <= wd + 1, 'scrollWidth ' + r.docW + ' ' + r.overflow.join(' ; '));
  check(g, 'No overlapping sections', !r.overlap.length, r.overlap.join(' ; '));
  check(g, 'No clipped text', !r.clipped.length, r.clipped.join(' ; '));
  check(g, 'No broken images', r.broken === 0, r.broken);
  if (wd < 1024) rec(g, 'Touch targets 40 px or more', r.small.length ? 'fail' : 'pass', r.small.join(' ; '));
  if (wd >= 2048) rec(g, 'Container does not stretch on large displays (header container ' + r.container + ' px of ' + wd + ')', r.container && r.container <= 1800 ? 'pass' : 'fail', 'container ' + r.container + ' h1 ' + r.h1 + 'px');
  var mv = r.menuVisible; if (mv !== null) check(g, 'Menu button ' + (wd < 1024 ? 'shown below 1024' : 'hidden from 1024'), wd < 1024 ? mv === true : mv === false, 'visible=' + mv);
  if (wd < 600) check(g, 'Heading scales (h1 ' + r.h1 + 'px)', r.h1 > 0 && r.h1 <= Math.max(44, wd * 0.14), r.h1);
  if (withDrawers) await drawersFit(wd, ht, g);
}
(async function main() {
  for (var grp in VP) {
    if (!on(grp)) continue;
    for (var v = 0; v < VP[grp].length; v++) for (var p = 0; p < KEY.length; p++) await runPage(grp, KEY[p], VP[grp][v], KEY[p][0] === 'home' || KEY[p][0] === 'product');
  }
  if (on('others')) for (var o = 0; o < OTHER.length; o++) for (var ow = 0; ow < OTHER_W.length; ow++) await runPage('others', OTHER[o], OTHER_W[ow], false);
  if (on('diag')) { await runPage('diag', ['cart', ''], [390, 844], false); await runPage('diag', ['cart', ''], [320, 568], false); }
  if (on('filter')) {
    for (var fw = 0; fw < 4; fw++) { var vp = [[390, 844], [600, 1024], [768, 1024], [1024, 768]][fw]; size(vp[0], vp[1]); await load(url('collection', 'c=skin')); var g2 = 'P3 filter @' + vp[0]; var fo = q('#f-open');
      if (fo && fo.offsetParent !== null) { fo.click(); await sleep(400); var dg = q('#faceted-drawer'); if (dg && dg.getAnimations) dg.getAnimations().forEach(function (a) { try { a.finish(); } catch (e) { /* */ } }); /* headless virtual time does not advance CSS keyframes; finishing them shows the end position, identical in the original wireframe */ await sleep(100); var rr = dg ? dg.getBoundingClientRect() : null; check(g2, 'PLP filter drawer opens and fits', !!dg && dg.open && rr.right <= vp[0] + 1 && rr.left >= -1 && rr.height > 200, rr ? 'open=' + dg.open + ' l' + Math.round(rr.left) + ' r' + Math.round(rr.right) + ' ' + Math.round(rr.width) + 'x' + Math.round(rr.height) : 'none'); try { W().NudgeDrawer.close(dg); } catch (e) { /* */ } }
      else check(g2, 'PLP filters shown as a sidebar (drawer button hidden)', !!q('#faceted-sidebar') && q('#faceted-sidebar').getBoundingClientRect().width > 150, ''); }
  }
  finish();
})().catch(function (e) { rec('HARNESS', 'error', 'fail', e && e.stack || e); finish(); });
