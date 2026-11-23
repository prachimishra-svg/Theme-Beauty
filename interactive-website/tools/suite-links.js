/* Phase 2: link verification by REAL clicks. For every page (1440 px, interactive mode) every visible link is resolved with the same resolver the click uses; the links are grouped by destination and the first link of
   each group is clicked for real. A route must land on the right wireframe with the right query; a search link must open the overlay; a cart link must open the drawer; an unsupported link must show its notice and stay;
   an in-page anchor must move to its target without leaving. Every other link in a group shares the same resolution, so the count of links "covered" per page is reported next to the number of real clicks. */
function visible(e) { var cs = W().getComputedStyle(e), r = e.getBoundingClientRect(); return cs.display !== 'none' && cs.visibility !== 'hidden' && r.width > 0 && r.height > 0; }
function keyOf(a, ns) {
  var href = a.getAttribute('href'); if (href.charAt(0) !== '#') return 'file:' + href;
  var id = href.slice(1), doc = D(), ex = !!(id && doc.getElementById(id));
  if (ex && id !== 'top' && id !== 's06' && id !== 's16') return 'inpage:' + href;
  var text = a.getAttribute('aria-label') && !a.textContent.trim() ? a.getAttribute('aria-label') : (a.textContent || '');
  var r = ns.nav.resolve(a, href, text, ns.resolver.section(a));
  if (r === null) return ex ? 'inpage:' + href : 'UNRESOLVED:' + href;
  return typeof r === 'string' ? 'route:' + r : 'action:' + r.action + (r.feature ? ':' + r.feature : '');
}
function collect() {
  var ns = NS(), out = []; qa('a[href]').forEach(function (a) {
    if (a.closest('.rv,#wp,.ann,#ix-pill,#ix-search,#ix-toast,#ix-cart-drawer')) return;
    var panel = a.closest('[data-mega-panel]'), vis = visible(a) || !!panel; if (!vis) return;
    out.push({ el: a, key: keyOf(a, ns), text: (a.getAttribute('aria-label') || a.textContent || '').replace(/IMAGE PLACEHOLDER\s*\d:\d/gi, '').replace(/\s+/g, ' ').trim().slice(0, 40), href: a.getAttribute('href') });
  });
  return out;
}
function openMega(a) { var m = a.closest('[data-mega]'); if (m) { m.setAttribute('data-open', ''); var pn = m.querySelector('[data-mega-panel]'); if (pn) pn.setAttribute('data-open', ''); } }
async function verify(g, page, qs, item) {
  var key = item.key, a = item.el, ns = NS(), label = item.text + '  [' + item.href + ' -> ' + key + ']';
  if (/^UNRESOLVED/.test(key)) { rec(g, label, 'fail', 'no destination'); return false; }
  openMega(a); if (!visible(a)) { var cs0 = W().getComputedStyle(a), r0 = a.getBoundingClientRect(); rec(g, label, 'fail', 'link not visible even with its menu open: display=' + cs0.display + ' visibility=' + cs0.visibility + ' rect=' + Math.round(r0.width) + 'x' + Math.round(r0.height) + ' connected=' + a.isConnected + ' frameW=' + W().innerWidth); return false; }
  var before = path();
  if (key.indexOf('route:') === 0) {
    var route = key.slice(6), exp = ns.routes.parse(route), st = await nav(function () { a.click(); });
    var ok = st !== 'NO-NAV' && st !== 'error';
    if (ok) { var pgKey = exp.valid ? exp.page : 'notfound'; ok = isPage(pgKey); if (ok && exp.valid) ['c', 'p', 'a', 't'].forEach(function (k) { if (exp.params[k] && new URLSearchParams(W().location.search).get(k) !== exp.params[k]) ok = false; }); }
    rec(g, label, ok ? 'pass' : 'fail', ok ? path().replace(/\?ix=1&?/, '?') : 'landed on ' + path() + ' state ' + st); return true;
  }
  if (key.indexOf('file:') === 0) { var st2 = await nav(function () { a.click(); }); var rel = a.getAttribute('href'); var expect = decodeURIComponent(rel).split('/').slice(-2).join('/'); rec(g, label, (st2 !== 'NO-NAV' && path().indexOf(expect.split('?')[0]) === 0) ? 'pass' : 'fail', path()); return true; }
  if (key.indexOf('action:search') === 0) { a.click(); await sleep(300); var o = ns.searchOverlay.isOpen(); rec(g, label, o ? 'pass' : 'fail', 'overlay open=' + o); if (o) ns.searchOverlay.close(); return false; }
  if (key.indexOf('action:cart') === 0) { var pgk = ns.routes.pageKey(); a.click(); await sleep(900); var okc = pgk === 'cart' ? true : (pgk === 'drawer' ? !!q('#cart-drawer') && q('#cart-drawer').open : !!q('#ix-cart-drawer') && q('#ix-cart-drawer').open); rec(g, label, okc ? 'pass' : 'fail', pgk + ' drawer open=' + okc); return pgk !== 'cart'; }
  if (key.indexOf('action:unsupported') === 0) { a.click(); await sleep(250); var t = (q('#ix-toast') || {}).textContent || ''; rec(g, label, t && path() === before ? 'pass' : 'fail', t.slice(0, 80)); return false; }
  if (key.indexOf('action:inert') === 0) { a.click(); await sleep(150); rec(g, label, path() === before ? 'pass' : 'fail', 'stays on the page (placeholder logo, no destination)'); return false; }
  if (key.indexOf('inpage:') === 0) { var id = item.href.slice(1); a.click(); await sleep(250); rec(g, label, (id ? D().getElementById(id) : true) && path().split('#')[0] === before.split('#')[0] ? 'pass' : 'fail', 'target ' + (id || 'top') + ' exists, no navigation'); return false; }
  rec(g, label, 'fail', 'unknown key ' + key); return false;
}
(async function main() {
  var qs = { collection: 'c=skin', product: 'p=face-serum', article: 'a=what-is-niacinamide' }, keys = Object.keys(PG);
  for (var i = 0; i < keys.length; i++) {
    var page = keys[i]; if (!on(page)) continue; size(1440, 900);
    await load(url(page, qs[page] || '')); NS().cart.clear();
    var items = collect(), groups = {}, order = []; items.forEach(function (it, ix) { it.ix = ix; if (!groups[it.key]) { groups[it.key] = ix; order.push(it.key); } });
    rec('P2 ' + page + ' summary', items.length + ' visible links, ' + order.length + ' distinct destinations', 'pass', 'links covered by a real click of their destination group: ' + items.length);
    for (var k = 0; k < order.length; k++) {
      var cur = items[groups[order[k]]];
      if (!cur || !cur.el.isConnected || path().indexOf(PG[page][0]) !== 0) { await load(url(page, qs[page] || '')); items = collect(); cur = items[groups[order[k]]]; }
      if (!cur) { rec('P2 ' + page, 'group ' + order[k], 'fail', 'link disappeared after reload'); continue; }
      await verify('P2 ' + page, page, qs[page], cur);
      /* anything that navigated, opened a drawer or left the page needs a fresh page for the next link */
      var stale = path().indexOf(PG[page][0]) !== 0 || qa('#ix-cart-drawer[open],#cart-drawer[open]').length || NS().searchOverlay.isOpen();
      if (stale || /^route:|^file:/.test(order[k])) { await load(url(page, qs[page] || '')); items = collect(); }
    }
  }
  finish();
})().catch(function (e) { rec('HARNESS', 'error', 'fail', e && e.stack || e); finish(); });
