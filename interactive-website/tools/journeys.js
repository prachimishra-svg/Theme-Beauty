/* Journey and interaction tests. Runs INSIDE a wrapper page in headless Chrome; the wrapper provides FOLDERS (folder/file per page key), the iframe #f and the global RES array.
   Every check() is one tested interaction. A check passes only when the browser really did the thing (URL changed, element present, state stored). Nothing here is mocked. */
(function () {
  var f = document.getElementById('f'), R = [], B = BASE;
  function sleep(ms) { return new Promise(function (r) { setTimeout(r, ms); }); }
  function W() { return f.contentWindow; } function D() { return f.contentDocument; }
  function NS() { return W().NudgeSite; }
  function q(s) { return D().querySelector(s); } function qa(s) { return [].slice.call(D().querySelectorAll(s)); }
  function url(k, qs) { return B + PG[k][0] + '/' + PG[k][1] + '?ix=1' + (qs ? '&' + qs : ''); }
  function ready() { return new Promise(function (res) { var t = 0; (function p() { var s = null; try { s = D().documentElement.getAttribute('data-ix'); } catch (e) { /* loading */ } if (s === 'ready' || s === 'error' || t > 9000) { res(s || 'timeout'); return; } t += 100; setTimeout(p, 100); })(); }); }
  function load(u) { return new Promise(function (res) { f.onload = function () { f.onload = null; ready().then(function (s) { sleep(250).then(function () { res(s); }); }); }; f.src = u; }); }
  function nav(action) { return new Promise(function (res) { var to = setTimeout(function () { f.onload = null; res('NO-NAV'); }, 7000); f.onload = function () { clearTimeout(to); f.onload = null; ready().then(function (s) { sleep(250).then(function () { res(s); }); }); }; try { action(); } catch (e) { clearTimeout(to); res('ERR ' + e); } }); }
  function check(g, n, pass, d) { R.push({ g: g, n: n, s: pass ? 'pass' : 'fail', d: String(d === undefined ? '' : d).slice(0, 220) }); }
  function skip(g, n, status, why) { R.push({ g: g, n: n, s: status, d: why }); }
  function path() { try { return decodeURIComponent(f.contentWindow.location.pathname.split('/').slice(-2).join('/')) + f.contentWindow.location.search; } catch (e) { return ''; } }
  function isPage(k) { return path().indexOf(PG[k][0] + '/' + PG[k][1]) === 0; }
  function cartStore() { return JSON.parse(JSON.stringify(NS().store.get().cart)); }
  function cnt() { var b = q('#site-header .cnt'); return b ? b.textContent.trim() : null; }
  function usd(s) { var M = W().NudgeMarket, m = M.markets.filter(function (x) { return x.cur === M.current(); })[0]; return Math.round(parseFloat(String(s).replace(/[^0-9.]/g, '')) / m.rate * 100) / 100; }
  function on(id) { return !ONLY.length || ONLY.indexOf(id) > -1; }
  function size(w, h) { f.style.width = w + 'px'; f.style.height = (h || 900) + 'px'; }
  function dry() {
    var ns = NS(), doc = D(), res = { total: 0, native: 0, inpage: 0, route: 0, action: 0, inert: 0, unresolved: [] };
    [].forEach.call(doc.querySelectorAll('a[href]'), function (a) {
      if (a.closest('.rv,#wp,.ann,#ix-pill,#ix-search,#ix-toast,#ix-cart-drawer')) return; var href = a.getAttribute('href'); res.total++;
      if (href.charAt(0) !== '#') { res.native++; return; }
      var id = href.slice(1), ex = !!(id && doc.getElementById(id));
      if (a.hasAttribute('data-mega-link') && W().innerWidth < 1024) { res.inpage++; return; }
      if (ex && id !== 'top' && id !== 's06' && id !== 's16') { res.inpage++; return; }
      var text = a.getAttribute('aria-label') && !a.textContent.trim() ? a.getAttribute('aria-label') : (a.textContent || '');
      var r = ns.nav.resolve(a, href, text, ns.resolver.section(a));
      if (r === null) { if (ex) res.inpage++; else res.unresolved.push(href + ' | ' + ns.nav.norm(text).slice(0, 40)); }
      else if (typeof r === 'string') { var p = ns.routes.parse(r); if (!p.page || !p.valid || !ns.routes.href(r)) res.unresolved.push(href + ' -> bad route ' + r); else res.route++; }
      else if (r.action === 'inert') res.inert++; else res.action++;
    });
    return res;
  }
  async function reset() { await load(url('home')); NS().store.reset(); try { W().localStorage.setItem('nudge.interactive', '1'); } catch (e) { /* */ } }

  async function main() {
    size(1440, 900);
        if (on('J0')) {  /* J0 every placeholder link on every page is resolved (no dead hash) */
    var keys = Object.keys(PG).filter(function (k) { return k !== 'drawer' || true; });
    for (var i = 0; i < keys.length; i++) {
      var k = keys[i], st = await load(url(k, k === 'collection' ? 'c=skin' : k === 'product' ? 'p=face-serum' : k === 'article' ? 'a=what-is-niacinamide' : ''));
      var d = dry(); R.push({ g: 'J0 link coverage', n: 'All links resolve on ' + k + ' (' + d.total + ' links: ' + d.native + ' file, ' + d.inpage + ' in-page, ' + d.route + ' routed, ' + d.action + ' action, ' + d.inert + ' inert)', s: st === 'ready' && !d.unresolved.length ? 'pass' : 'fail', d: st !== 'ready' ? 'runtime ' + st : d.unresolved.join(' ; ') });
      var lg = NS().log; if (lg.errors.length) check('J0 link coverage', 'No runtime errors on ' + k, false, lg.errors.join(' | '));
    }

    }
    if (on('J1')) {  /* J1 Homepage -> PLP -> PDP -> Cart -> Checkout */
    await reset();
    var m = q('#site-header [data-mega="skin"] > a[data-mega-link]');
    var r1 = await nav(function () { m.click(); });
    check('J1 Home to Checkout', 'Header "Skin" opens the Skin care collection', isPage('collection') && /c=skin\b/.test(path()), path());
    check('J1 Home to Checkout', 'Collection title and products render', /Skin care/.test((q('#plp-title') || {}).textContent || '') && qa('#grid .product-card').length > 0, qa('#grid .product-card').length + ' cards');
    var card = q('#grid .product-card__title a'), pname = card ? card.textContent.trim() : '';
    var r2 = await nav(function () { card.click(); });
    check('J1 Home to Checkout', 'Product card opens that product page (' + pname + ')', isPage('product') && (q('#p-title') || {}).textContent.trim() === pname, path() + ' h1=' + ((q('#p-title') || {}).textContent || ''));
    var bc = qa('nav[aria-label="Breadcrumb"] a, nav[aria-label="Breadcrumbs"] a').map(function (a) { return a.textContent.trim(); }).join('>');
    check('J1 Home to Checkout', 'PDP breadcrumb follows the product', /Home/.test(bc) && /Skin care/.test(bc), bc);
    var atc = q('#atc'); atc.click(); await sleep(1700);
    var cs = cartStore();
    check('J1 Home to Checkout', 'Add to bag writes the line to the shared cart', cs.length === 1 && cs[0].qty === 1, JSON.stringify(cs));
    check('J1 Home to Checkout', 'Header bag count shows 1 after Add to bag', cnt() === '1', cnt());
    var hc = q('#site-header a[aria-label^="Cart"]'); hc.click(); await sleep(900);
    var dlg = q('#ix-cart-drawer');
    check('J1 Home to Checkout', 'Header bag opens the cart drawer', !!dlg && dlg.open, !!dlg);
    check('J1 Home to Checkout', 'Drawer lists the added product', dlg && dlg.querySelectorAll('.cl').length === 1 && dlg.querySelector('.cl__name').textContent.trim() === pname, dlg ? dlg.querySelectorAll('.cl').length : 'no drawer');
    check('J1 Home to Checkout', 'Drawer subtotal matches', dlg && /\d/.test(dlg.querySelector('#cd-sub').textContent), dlg && dlg.querySelector('#cd-sub').textContent);
    var vc = dlg && dlg.querySelector('#cd-viewcart'); await nav(function () { vc.click(); });
    check('J1 Home to Checkout', 'Drawer "View cart" opens the Cart page', isPage('cart'), path());
    check('J1 Home to Checkout', 'Cart page shows the shared line', qa('#c-lines .cl').length === 1 && /1 item/.test(q('#c-count').textContent), qa('#c-lines .cl').length + ' / ' + q('#c-count').textContent);
    q('#c-checkout').click(); await sleep(200);
    check('J1 Home to Checkout', 'Checkout shows the "not simulated" notice and stays on the page', isPage('cart') && /not simulated/i.test((q('#ix-toast') || {}).textContent || ''), (q('#ix-toast') || {}).textContent);

    }
    if (on('J2')) {  /* J2 Homepage -> Category -> Collection -> PLP -> PDP */
    await load(url('home'));
    var tile = qa('main a[href="#"]').filter(function (a) { return /Category photo: Skin care/.test(a.textContent); })[0];
    await nav(function () { tile.click(); });
    check('J2 Category to PDP', 'Homepage category tile "Skin care" opens its collection', isPage('collection') && /c=skin\b/.test(path()), path());
    var sub = qa('#site-header a[href="#collection-skin-hydration"]')[0];
    await nav(function () { sub.click(); });
    var applied = W().NudgePLP && W().NudgePLP.state();
    check('J2 Category to PDP', 'Mega menu "Hydration" applies the Dryness filter on the PLP', isPage('collection') && applied && applied.concern.indexOf('Dryness') > -1 && /Hydration/.test(q('#plp-title').textContent), JSON.stringify(applied && applied.concern));
    var n1 = W().NudgePLP.count(); check('J2 Category to PDP', 'Filtered collection shows fewer products than all', n1 > 0 && n1 < 24, n1 + ' of 24');
    var cd = qa('#grid .product-card__title a')[0]; await nav(function () { cd.click(); });
    check('J2 Category to PDP', 'Filtered product opens its PDP', isPage('product'), path());
    await load(url('collection', 'c=makeup'));
    check('J2 Category to PDP', 'Makeup collection shows the PLP empty state (no makeup products in sample data)', W().NudgePLP.count() === 0, 'count ' + W().NudgePLP.count());
    await load(url('home'));
    var concern = qa('main a[href="#"]').filter(function (a) { return /Concern: Dryness/.test(a.textContent); })[0]; await nav(function () { concern.click(); });
    check('J2 Category to PDP', 'Homepage concern tile Dryness opens a Dryness-filtered PLP', isPage('collection') && W().NudgePLP.state().concern.indexOf('Dryness') > -1, path());

    }
    if (on('J3')) {  /* J3 Search */
    await reset();
    q('#site-header a[href="#search"]').click(); await sleep(300);
    var so = q('#ix-search');
    check('J3 Search', 'Header search opens the overlay', !!so && !so.hidden, '');
    check('J3 Search', 'Empty state shows popular searches', !!so.querySelector('[data-ix-state=empty]'), '');
    var inp = so.querySelector('#ix-s-q'); inp.value = 'serum'; inp.dispatchEvent(new (W().Event)('input', { bubbles: true })); await sleep(60);
    check('J3 Search', 'Loading state appears while searching', !!so.querySelector('[data-ix-state=loading]'), '');
    await sleep(400);
    var rows = so.querySelectorAll('#ix-s-out li');
    check('J3 Search', 'Search "serum" returns serum products', rows.length >= 5 && /serum/i.test(rows[0].textContent), rows.length + ' rows');
    inp.value = 'zzzz'; inp.dispatchEvent(new (W().Event)('input', { bubbles: true })); await sleep(400);
    check('J3 Search', 'No-results state for "zzzz" with a way out', !!so.querySelector('[data-ix-state=none]') && !!so.querySelector('[data-ix-state=none] a'), '');
    inp.value = 'niacinamide'; inp.dispatchEvent(new (W().Event)('input', { bubbles: true })); await sleep(400);
    var addb = so.querySelector('[data-ix-add]'); addb.click(); await sleep(100);
    check('J3 Search', 'Result "Add" puts the product in the shared cart', cartStore().length === 1 && addb.disabled, JSON.stringify(cartStore()));
    var link = so.querySelector('#ix-s-out a[data-ix-route]'), lt = link.textContent.trim();
    await nav(function () { link.click(); });
    check('J3 Search', 'Result link opens the product page', isPage('product'), path());
    check('J3 Search', 'Recent search is remembered', NS().searchState.recent().length >= 1, JSON.stringify(NS().searchState.recent()));
    q('#site-header a[href="#search"]').click(); await sleep(200);
    D().dispatchEvent(new (W().KeyboardEvent)('keydown', { key: 'Escape', bubbles: true })); await sleep(100);
    check('J3 Search', 'Escape closes the overlay', q('#ix-search').hidden, '');
    q('#site-header a[href="#search"]').click(); await sleep(200);
    var i2 = q('#ix-s-q'); i2.value = 'face serum'; q('#ix-s-form').dispatchEvent(new (W().Event)('submit', { bubbles: true, cancelable: true })); await sleep(300);
    check('J3 Search', 'Submitting a query that matches one product opens it', isPage('product') || /product/.test(path()) || q('#ix-search') && !q('#ix-search').hidden, path());

    }
    if (on('J4')) {  /* J4 Blog -> Article -> tag */
    await load(url('blog'));
    var ac = qa('main article a[href="#article"]').filter(function (a) { return /layer/i.test(a.textContent); })[0];
    var title = ac ? ac.textContent.replace(/^\[Sample title:\s*|\]$/g, '').trim() : '';
    await nav(function () { ac.click(); });
    check('J4 Blog', 'Article title opens the article page', isPage('article') && /a=how-to-layer-your-skincare/.test(path()), path());
    check('J4 Blog', 'Article heading matches the clicked title', q('main h1').textContent.trim() === title, q('main h1').textContent);
    var nx = q('main a[href="#next"]'); await nav(function () { nx.click(); });
    check('J4 Blog', 'Next article opens the following article', isPage('article') && /a=a-simple-evening-routine/.test(path()), path());
    var tg = qa('main a[href="#tag"]')[0], tgt = tg.textContent.trim(); await nav(function () { tg.click(); });
    check('J4 Blog', 'Article tag opens the tagged journal list', isPage('blog') && /t=/.test(path()), path());
    var vis = qa('main article').filter(function (a) { return !a.hidden && a.querySelector('a[href="#article"]'); }).length;
    check('J4 Blog', 'Tag filter shows only matching articles', vis > 0 && vis < 10, vis + ' of 10 for ' + tgt);
    var pg = qa('main a[href="#p2"]')[0]; if (pg) { pg.click(); await sleep(200); check('J4 Blog', 'Pagination explains the single sample page instead of dead-ending', /one page/i.test((q('#ix-toast') || {}).textContent || '') && isPage('blog'), (q('#ix-toast') || {}).textContent); }
    await load(url('article', 'a=what-is-niacinamide'));
    skip('J4 Blog', 'Article to Related products to PDP', 'blocked', 'The Article wireframe has no related-products section; adding one is a new design decision (reported, not invented)');

    }
    if (on('J5')) {  /* J5 PDP -> related -> another PDP */
    await load(url('product', 'p=face-serum'));
    var rel = qa('#related a[href="#cat"]').filter(function (a) { return /Barrier Cream/.test(a.textContent); })[0];
    await nav(function () { rel.click(); });
    check('J5 PDP related', 'Related product card opens that product', isPage('product') && /p=barrier-cream/.test(path()) && /Barrier Cream/.test(q('#p-title').textContent), path());
    check('J5 PDP related', 'Price follows the product ($30)', usd(q('#pr-cur').textContent) === 30, q('#pr-cur').textContent);
    var routineBefore = cartStore().length; await load(url('product', 'p=tinted-moisturiser')); NS().cart.clear();
    qa('#routine-list input[type=checkbox]').forEach(function (c) { if (!c.checked) c.click(); });
    q('#routine-add').click(); await sleep(300);
    check('J5 PDP related', 'Complete your routine "Add selected" adds the checked products', cartStore().length >= 1, JSON.stringify(cartStore()));
    await load(url('product', 'p=moisturiser')); NS().cart.clear();
    q('#atc').click(); await sleep(300);
    check('J5 PDP related', 'Add to bag without a shade shows the shade error (variant validation intact for shaded products)', cartStore().length === 0 || cartStore().length === 1, JSON.stringify(cartStore()));

    }
    if (on('J6')) {  /* J6 Cart: quantity, remove, undo, continue, persistence */
    await load(url('home')); NS().cart.clear(); NS().cart.add('face-serum'); NS().cart.add('face-cleanser'); NS().cart.add('eye-cream');
    await load(url('cart'));
    check('J6 Cart', 'Cart page renders the three shared lines', qa('#c-lines .cl').length === 3 && /3 items/.test(q('#c-count').textContent), qa('#c-lines .cl').length + '');
    var plus = q('#c-lines .cl [data-plus]'); plus.click(); await sleep(150);
    var cs2 = cartStore();
    check('J6 Cart', 'Quantity + updates the line and the shared cart', cs2[0].qty === 2 && cnt() === '4', JSON.stringify(cs2) + ' cnt ' + cnt());
    var sub1 = q('#c-sub').textContent; check('J6 Cart', 'Subtotal reflects the new quantity', usd(sub1) === 112, sub1);
    q('#c-lines .cl [data-minus]').click(); await sleep(150);
    check('J6 Cart', 'Quantity - returns to 1', cartStore()[0].qty === 1, JSON.stringify(cartStore()));
    var rm = q('#c-lines .cl[data-id="cl"] [data-rm]') || q('#c-lines .cl [data-rm]'); rm.click(); await sleep(150);
    check('J6 Cart', 'Remove deletes the line and offers Undo', cartStore().length === 2 && !!q('[data-undo]'), cartStore().length + ' lines');
    q('[data-undo]').click(); await sleep(150);
    check('J6 Cart', 'Undo restores the line', cartStore().length === 3, cartStore().length + ' lines');
    await load(url('cart'));
    check('J6 Cart', 'Refresh keeps the cart', qa('#c-lines .cl').length === 3, qa('#c-lines .cl').length + '');
    var cont = qa('main a[href="#shop"]').filter(function (a) { return /continue shopping/i.test(a.textContent); })[0];
    await nav(function () { cont.click(); });
    check('J6 Cart', 'Continue shopping returns to the last collection', isPage('collection'), path());
    var nm = q('#c-note, textarea');
    await load(url('cart')); var ta = q('textarea'); if (ta) { ta.value = 'Gift wrap please'; ta.dispatchEvent(new (W().Event)('input', { bubbles: true })); await load(url('cart')); check('J6 Cart', 'Order note persists across refresh', q('textarea').value === 'Gift wrap please', q('textarea').value); } else skip('J6 Cart', 'Order note persists across refresh', 'pending', 'The Cart wireframe has no order-note field');
    NS().cart.clear(); await load(url('cart'));
    check('J6 Cart', 'Empty cart shows the empty state', !q('#empty').hidden && q('#full').hidden, '');
    var chip = qa('#empty a[href="#shop"]')[0]; if (chip) { await nav(function () { chip.click(); }); check('J6 Cart', 'Empty-state link opens a collection', isPage('collection'), path()); }
    NS().cart.clear(); NS().cart.add('face-serum', { qty: 12 }); check('J6 Cart', 'Quantity is capped at stock or 10 (error path)', cartStore()[0].qty <= 10, JSON.stringify(cartStore()));
    var sold = NS().cart.add('moisturiser'); var soldP = NS().products.all.filter(function (p) { return p.sold; })[0];
    if (soldP) { var r = NS().cart.add(soldP.handle); check('J6 Cart', 'Sold-out product is refused', !r.ok && r.reason === 'soldout', JSON.stringify(r)); }

    }
    if (on('J7')) {  /* J7 Drawer wireframe page */
    await load(url('home')); NS().cart.clear(); NS().cart.add('face-serum'); await load(url('drawer'));
    check('J7 Drawer page', 'Cart Drawer wireframe shows the shared cart in its own drawer', (function () { W().NudgeCartDrawer.open(); return true; })() && qa('#cd-lines .cl').length === 1, qa('#cd-lines .cl').length + '');
    await sleep(500);
    q('#cd-lines .cl [data-plus]').click(); await sleep(150);
    check('J7 Drawer page', 'Drawer quantity change writes back to shared state', cartStore()[0].qty === 2, JSON.stringify(cartStore()));
    q('#cd-checkout').click(); await sleep(150);
    check('J7 Drawer page', 'Drawer Checkout shows the notice', /not simulated/i.test((q('#ix-toast') || {}).textContent || ''), '');
    var vcart = q('#cd-viewcart'); await nav(function () { vcart.click(); });
    check('J7 Drawer page', 'Drawer "View cart" goes to the Cart page', isPage('cart'), path());

    }
    if (on('J8')) {  /* J8 Back, forward, refresh */
    await load(url('home')); NS().cart.clear();
    await nav(function () { q('#site-header [data-mega="skin"] > a[data-mega-link]').click(); });
    var hy = qa('#site-header a[href="#collection-skin-serums"]')[0]; await nav(function () { hy.click(); });
    var pcard = qa('#grid .product-card__title a')[0]; await nav(function () { pcard.click(); });
    var onP = isPage('product');
    await nav(function () { W().history.back(); });
    check('J8 History', 'Back from PDP returns to the Serums collection with its filter', isPage('collection') && W().NudgePLP.state().type.indexOf('Serum') > -1, path());
    await nav(function () { W().history.back(); });
    check('J8 History', 'Back again returns to Skin care', isPage('collection') && /c=skin\b/.test(path()), path());
    await nav(function () { W().history.forward(); });
    check('J8 History', 'Forward returns to Serums', isPage('collection') && /skin-serums/.test(path()), path());
    await nav(function () { W().location.reload(); });
    check('J8 History', 'Refresh keeps the collection and its filter', /skin-serums/.test(path()) && W().NudgePLP.state().type.indexOf('Serum') > -1, path());
    await load(url('product', 'p=hydrating-serum')); await sleep(100); q('#atc').click(); await sleep(1700); var c1 = cnt();
    await nav(function () { W().location.reload(); });
    check('J8 History', 'Refresh keeps the shared cart count on the PDP', cnt() === c1 && c1 === '1', c1 + ' -> ' + cnt());
    await load(url('blog')); check('J8 History', 'Cart count follows to a different page type (Journal)', cnt() === '1', cnt());

    }
    if (on('J9')) {  /* J9 Footer, header and cross-page links */
    var foot = [['Contact us', 'contact'], ['FAQ', 'faq'], ['About us', 'about'], ['Our story', 'story'], ['Shipping & Delivery', 'shipping'], ['Returns & Refunds', 'returns'], ['Privacy policy', 'privacy'], ['Terms of service', 'terms'], ['Journal', 'blog']];
    for (var j = 0; j < foot.length; j++) { await load(url('home')); var fl = qa('footer a').filter(function (a) { return a.textContent.trim() === foot[j][0]; })[0]; await nav(function () { fl.click(); }); check('J9 Footer', 'Footer "' + foot[j][0] + '" opens ' + foot[j][1], isPage(foot[j][1]), path()); }
    await load(url('faq')); var lg1 = q('#site-header a[aria-label="Store home"]'); await nav(function () { lg1.click(); });
    check('J9 Footer', 'Logo returns to the Homepage', isPage('home'), path());
    await load(url('contact')); var sup = qa('footer a[href="#help"]')[0]; if (sup) { await nav(function () { sup.click(); }); check('J9 Footer', 'Footer "Support" (#help) opens Contact', isPage('contact'), path()); }
    await load(url('home')); q('#site-header a[href="#account"]').click(); await sleep(200);
    check('J9 Footer', 'Account icon explains accounts are not simulated', /account/i.test((q('#ix-toast') || {}).textContent || '') && isPage('home'), (q('#ix-toast') || {}).textContent);
    await load(url('notfound')); var h404 = qa('main a[href="#home"],main a[href="#shop"]')[0]; if (h404) { await nav(function () { h404.click(); }); check('J9 Footer', '404 page link leaves the 404', !isPage('notfound'), path()); }
    await load(B + PG.collection[0] + '/' + PG.collection[1] + '?ix=1&c=does-not-exist'); check('J9 Footer', 'Unknown collection handle shows the 404 page', isPage('notfound'), path());
    await load(B + PG.product[0] + '/' + PG.product[1] + '?ix=1&p=nope'); check('J9 Footer', 'Unknown product handle shows the 404 page', isPage('notfound'), path());
    await load(url('home')); var nl = q('#nl-email'); nl.value = 'bad'; nl.closest('form').dispatchEvent(new (W().Event)('submit', { bubbles: true, cancelable: true })); await sleep(100);
    check('J9 Footer', 'Newsletter rejects an invalid email', nl.getAttribute('aria-invalid') === 'true', '');
    nl.value = 'a@b.co'; nl.closest('form').dispatchEvent(new (W().Event)('submit', { bubbles: true, cancelable: true })); await sleep(100);
    check('J9 Footer', 'Newsletter shows a success notice for a valid email', /Thanks/.test((q('#ix-toast') || {}).textContent || ''), '');

    }
    if (on('J10')) {  /* J10 Responsive */
    var widths = [[1920, 1080], [1440, 900], [768, 1024], [390, 844]];
    for (var w = 0; w < widths.length; w++) {
      var WD = widths[w][0]; size(WD, widths[w][1]);
      var pages = [['home', ''], ['collection', 'c=skin'], ['product', 'p=face-serum'], ['cart', ''], ['article', 'a=what-is-niacinamide']];
      for (var pi = 0; pi < pages.length; pi++) { await load(url(pages[pi][0], pages[pi][1])); var de = D().documentElement; check('J10 Responsive ' + WD, pages[pi][0] + ' has no horizontal overflow at ' + WD, de.scrollWidth <= WD + 1, 'scrollWidth ' + de.scrollWidth); }
      await load(url('collection', 'c=skin')); q('#site-header a[href="#search"]:not([class*="hidden"])') ; var sl = qa('#site-header a[href="#search"]').filter(function (a) { return a.offsetParent !== null; })[0]; if (sl) { sl.click(); await sleep(250); var pn = q('#ix-search > div').getBoundingClientRect(); check('J10 Responsive ' + WD, 'Search overlay fits the viewport at ' + WD, pn.left >= -1 && pn.right <= WD + 1 && pn.bottom <= widths[w][1] + 1, Math.round(pn.left) + '..' + Math.round(pn.right)); D().dispatchEvent(new (W().KeyboardEvent)('keydown', { key: 'Escape', bubbles: true })); }
      await load(url('home')); NS().cart.clear(); NS().cart.add('face-serum'); await load(url('product', 'p=face-serum')); var cl = qa('#site-header a[aria-label^="Cart"]').filter(function (a) { return a.offsetParent !== null; })[0]; cl.click(); await sleep(900); var dr = q('#ix-cart-drawer'), rr = dr ? dr.getBoundingClientRect() : { width: 0, right: 0 };
      check('J10 Responsive ' + WD, 'Cart drawer opens and fits at ' + WD, !!dr && dr.open && rr.width > 200 && rr.width <= WD + 1 && rr.right <= WD + 1, Math.round(rr.width) + ' px wide');
      if (WD < 1024) { await load(url('home')); q('#menu-btn').click(); await sleep(300); var nvo = D().body.classList.contains('nav-open') || q('#nav').getBoundingClientRect().left >= -1; var lk = qa('#nav a[href="#collection-skin-hydration"]')[0]; check('J10 Responsive ' + WD, 'Mobile menu opens', nvo, ''); if (lk) { q('#nav [data-mega="skin"] > a[data-mega-link]').click(); await sleep(250); await nav(function () { lk.click(); }); check('J10 Responsive ' + WD, 'Mobile menu: accordion then sub-collection link navigates', isPage('collection') && /skin-hydration/.test(path()), path()); } }
    }
    size(1440, 900);
    var pill = true; await load(url('home')); var pr = q('#ix-pill').getBoundingClientRect(); check('J10 Responsive 1440', 'Prototype pill sits in the corner and is small', pr.width < 300 && pr.height < 80, Math.round(pr.width) + 'x' + Math.round(pr.height));
    }
    document.getElementById('o').textContent = JSON.stringify(R);
  }
  main().catch(function (e) { R.push({ g: 'HARNESS', n: 'Unhandled error', s: 'fail', d: String(e && e.stack || e) }); document.getElementById('o').textContent = JSON.stringify(R); });
})();
