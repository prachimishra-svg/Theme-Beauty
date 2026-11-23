/* NUDGE interactive website: PDP integration. Binds the PDP wireframe to /products/:handle. The wireframe is ONE product page (Tinted Moisturiser: its gallery, description, FAQ and
   reviews slot). For any other product this file changes ONLY: title, price (and compare-at), breadcrumb, document title, and hides the shade and size pickers when the product has none
   (the picker would otherwise demand a shade before "Add to bag"). Everything else stays the sample content and is listed as a limitation.
   Add to bag: the page's own busy then "Added" sequence runs; when it reaches "Added" the line (product, quantity, shade, size) is written to the shared cart. "Add selected to bag" in
   Complete your routine adds the checked products. Related products and "View bag" are resolved by the route resolver.
   In Shopify: product.selected_or_first_available_variant, the product form posting to /cart/add.js, and complementary/related recommendations. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  function money(n) { return '$' + n.toFixed(2); }
  function $(id) { return document.getElementById(id); }
  function txt(id) { var e = $(id); return e ? e.textContent.trim() : ''; }
  /* The shared currency script (currency.js) rewrites "$32.00" into the chosen market's currency in the same nodes. Comparing against the raw "$" text would make the two
     observers undo each other forever, so a node counts as correct when it shows EITHER the base text or that text as currency.js would show it. */
  function shown(n) {
    var m = g.NudgeMarket ? g.NudgeMarket.markets.filter(function (x) { return x.cur === g.NudgeMarket.current(); })[0] : null;
    if (!m || m.rate === 1) return money(n);
    return new Intl.NumberFormat(m.loc, { style: 'currency', currency: m.cur, minimumFractionDigits: m.dec, maximumFractionDigits: m.dec }).format(n * m.rate);
  }
  function put(el, n, prefix) {
    if (!el) return; var t = el.textContent.trim(), base = (prefix || '') + money(n), conv = (prefix || '') + shown(n);
    if (t !== base && t !== conv) el.textContent = base;
  }
  function bindPrice(p) {
    function apply() {
      var cur = $('pr-cur'), cmp = $('pr-cmp'), sv = $('pr-save'), unit = $('pr-unit'), sa = $('sa-price'), has = p.compare > p.price;
      put(cur, p.price); put(sa, p.price);
      if (cmp) { if (has) put(cmp, p.compare); if (cmp.hidden === has) cmp.hidden = !has; }
      if (sv) { if (sv.hidden === has) sv.hidden = !has; if (has) put(sv, p.compare - p.price, 'Save '); }
      if (unit && !unit.hidden) unit.hidden = true;
    }
    apply();
    ['pr-cur', 'pr-cmp', 'pr-save', 'sa-price'].forEach(function (id) { var e = $(id); if (e) new MutationObserver(apply).observe(e, { childList: true, characterData: true, subtree: true, attributes: true, attributeFilter: ['hidden'] }); });
  }
  NS.integrations.product = function () {
    var q = new URLSearchParams(g.location.search), h = q.get('p') || 'tinted-moisturiser', p = NS.products.byHandle(h);
    if (!p) { NS.go('/404'); return; }
    NS.store.get().last.product = h; NS.store.save();
    var coll = NS.collections.get(p.group) || NS.collections.get('skin');
    NS.breadcrumbs.update([{ label: 'Home', route: '/' }, { label: coll.title, route: '/collections/' + coll.handle }, { label: p.name, route: '/products/' + h }]);
    document.title = p.name + ' | NUDGE';
    if (h !== 'tinted-moisturiser') {
      var t = $('p-title'); if (t) t.textContent = p.name; bindPrice(p);
      var early = document.getElementById('ix-early-pdp'); if (early) early.remove(); /* shown again below only where the product needs it */
      if (!p.shades.length) { if (g.NudgePDP && g.NudgePDP.pick) g.NudgePDP.pick(0); var sg = $('shade-tiles'); sg = sg && (sg.closest('fieldset') || sg.parentElement); if (sg) sg.hidden = true; }
      var sz = $('size-opts'); if (sz) { var zg = sz.closest('fieldset') || sz.parentElement; if (zg) zg.hidden = true; }
    }
    if (p.sold) { var a = $('atc'); if (a) { a.disabled = true; var l = $('atc-label'); if (l) l.textContent = 'Sold out'; } }
    /* add to bag: act when the page's own sequence reaches "Added" */
    var lab = $('atc-label'), was = lab ? lab.textContent : '';
    if (lab) new MutationObserver(function () {
      var now = lab.textContent; if (/^Added/.test(now) && !/^Added/.test(was)) {
        var qty = parseInt((($('q-input') || {}).value), 10) || 1, r = NS.cart.add(h, { qty: qty, shade: txt('shade-name'), size: txt('size-name') });
        if (r.capped) NS.notify('Quantity limited to what is in stock.', { kind: 'info' });
      } was = now;
    }).observe(lab, { childList: true, characterData: true, subtree: true });
    var ra = $('routine-add');
    if (ra) ra.addEventListener('click', function () {
      var n = 0; [].forEach.call(document.querySelectorAll('#routine-list input[type=checkbox]:checked'), function (c) {
        var pr = NS.nav.productIn(c.getAttribute('aria-label') || (c.closest('li') || c).textContent); if (pr && NS.cart.add(pr.handle, { qty: 1 }).ok) n++;
      });
    });
  };
})(window);
