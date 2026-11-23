/* NUDGE interactive website: Cart page and Cart drawer page integration. Both wireframes already render lines, quantity, remove, undo, free-shipping progress and totals through window.NudgeCart.
   This file makes them show the SHARED cart instead of their sample states (NudgeCart.set is wrapped so the page's own render shows the shared lines), writes edits back, and turns Checkout
   into a clear "not simulated" notice. Continue shopping, empty-state chips and product names are resolved by the route resolver. The order note is kept in the shared state.
   The wireframes' review-state buttons (Multi, One, Free, Long, Empty) still work as before but are sample data and do not write to the shared cart.
   In Shopify: /cart.js for the lines, /cart/change.js for quantity and remove, cart attributes for the note, and Shopify Checkout for payment (never simulated here). */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  function $(id) { return document.getElementById(id); }
  function boot(root, stateFn, checkoutIds) {
    var C = g.NudgeCart; if (!C || !stateFn) return;
    NS.cart.hookNudge(C); NS.cart.registerCatalogue(C); NS.cart.bindRoot(C, root);
    C.pushShared(function () { stateFn('multi'); });
    checkoutIds.forEach(function (id) { var b = $(id); if (b && !b.__ix) { b.__ix = 1; b.addEventListener('click', function () { NS.unsupported('checkout'); }); } });
    document.addEventListener('nudge:cart', function (e) { if (e.detail && e.detail.action === 'pull') return; C.pushShared(function () { stateFn('multi'); }); });
  }
  NS.integrations.cart = function () {
    boot($('cart'), g.NudgeCartPage && g.NudgeCartPage.state, ['c-checkout']);
    var note = document.querySelector('textarea'); if (note && !note.__ix) { note.__ix = 1; note.value = NS.cart.note(); note.addEventListener('input', function () { NS.cart.note(note.value); }); }
  };
  NS.integrations.drawer = function () {
    boot($('cd-body'), g.NudgeCartDrawer && g.NudgeCartDrawer.state, ['cd-checkout']);
  };
})(window);
