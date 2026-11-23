/* NUDGE interactive website: breadcrumbs. The pages already have a breadcrumb <nav>; this component only gives its items the right label and route for the current product, collection or article.
   Trail items map onto the existing links in order; the last item is the current page. Extra trail items are ignored (the wireframe decides how many crumbs there are). In Shopify: the breadcrumb snippet built from collection and product. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  function nav() { return document.querySelector('nav[aria-label="Breadcrumb"],nav[aria-label="Breadcrumbs"],nav.breadcrumb,.breadcrumb'); }
  /* update([{label, route}, ...]) */
  function update(trail) {
    var n = nav(); if (!n) return false;
    var items = [].slice.call(n.querySelectorAll('a, [aria-current]')).filter(function (x, i, all) { return all.indexOf(x) === i; });
    for (var i = 0; i < items.length && i < trail.length; i++) {
      var el = items[i], t = trail[i], txt = el.querySelector('span') && !el.querySelector('svg') ? el.querySelector('span') : el;
      if (i === trail.length - 1 || items.length - 1 === i) { if (el.tagName === 'A') el.removeAttribute('data-ix-route'); }
      else el.setAttribute('data-ix-route', t.route);
      if (!el.querySelector('*')) el.textContent = t.label; else { var lf = [].slice.call(el.childNodes).filter(function (c) { return c.nodeType === 3 && c.textContent.trim(); })[0]; if (lf) lf.textContent = t.label; else txt.textContent = t.label; }
    }
    return true;
  }
  NS.breadcrumbs = { update: update };
})(window);
