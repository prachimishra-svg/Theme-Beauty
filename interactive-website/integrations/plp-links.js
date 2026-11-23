/* NUDGE interactive website: PLP integration. Binds the PLP wireframe to /collections/:handle: the collection's filter preset is applied through the page's own NudgePLP.apply(), the title,
   breadcrumb and document title follow the collection, and Quick view's Add to bag adds the real product to the shared cart. Product cards and "View full details" are resolved by the route resolver.
   Collections for makeup, hair and body have no products in the PLP sample data, so they show the PLP's own "no products" state (see missing-pages-and-interactions.md).
   In Shopify: collection.products, the collection's own filters (Storefront Filtering) and sort_by. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  function patchFrom(coll, f) {
    var p = {}; Object.keys(coll.preset || {}).forEach(function (k) { p[k] = coll.preset[k]; });
    String(f || '').split(';').forEach(function (kv) { var i = kv.indexOf(':'); if (i < 1) return; var k = kv.slice(0, i), v = kv.slice(i + 1); if (/^(concern|skin|type|ingredient|benefit|size|shade|avail)$/.test(k)) p[k] = (p[k] || []).concat([v]); });
    return p;
  }
  NS.integrations.collection = function () {
    var q = new URLSearchParams(g.location.search), h = q.get('c') || 'all', coll = NS.collections.get(h);
    if (!coll) { NS.go('/404'); return; }
    NS.store.get().last.collection = h; NS.store.save();
    var patch = patchFrom(coll, q.get('f')); if (g.NudgePLP) g.NudgePLP.apply(patch);
    var sort = document.getElementById('sort'); if (sort && patch.sort) sort.value = patch.sort;
    var t = document.getElementById('plp-title'); if (t) t.textContent = coll.title; document.title = coll.title + ' | NUDGE';
    var trail = [{ label: 'Home', route: '/' }]; if (!coll.top) trail.push({ label: NS.collections.groups[coll.group], route: '/collections/' + coll.group }); trail.push({ label: coll.title, route: '/collections/' + h });
    NS.breadcrumbs.update(trail);
    var add = document.getElementById('qv-add');
    if (add && !add.__ix) {
      add.__ix = 1;
      add.addEventListener('click', function () {
        var title = (document.getElementById('qv-title') || {}).textContent, p = NS.nav.productIn(title || ''); if (!p) return;
        var sh = document.querySelector('#qv-body input[name=qv-shade]:checked'), r = NS.cart.add(p.handle, { qty: 1, shade: sh ? sh.getAttribute('data-name') : '' });
        if (!r.ok) NS.notify(r.reason === 'soldout' ? 'This product is sold out.' : 'This product cannot be added.', { kind: 'error' });
        else if (r.capped) NS.notify('Quantity limited to what is in stock.', { kind: 'info' });
      });
    }
  };
})(window);
