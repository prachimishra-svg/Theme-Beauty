/* NUDGE interactive website: wishlist state. The approved wireframes have NO wishlist control (the PDP list marks it "Removed: apps"), so this API exists and persists but nothing in the UI calls it.
   Listed as MISSING in documentation/missing-pages-and-interactions.md. In Shopify: a wishlist app or customer metafield; not available in the base theme. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite, st = NS.store;
  NS.wishlist = {
    items: function () { return st.get().wishlist.slice(); },
    has: function (h) { return st.get().wishlist.indexOf(h) > -1; },
    toggle: function (h) { var w = st.get().wishlist, i = w.indexOf(h); if (i > -1) w.splice(i, 1); else w.push(h); st.save(); st.emit('wishlist', { handle: h }); return i < 0; }
  };
})(window);
