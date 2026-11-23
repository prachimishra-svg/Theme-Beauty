/* NUDGE interactive website: user state. There is NO account, login or order page in the wireframes, so nothing here signs anyone in: signedIn stays false and the Account link shows a
   "not available in the prototype" notice. In Shopify: customer accounts (/account/login, /account, /account/orders), which are Shopify-hosted and need a real store. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite, st = NS.store;
  NS.user = { signedIn: function () { return false; }, name: function () { return ''; }, snapshot: function () { return { signedIn: false }; } };
})(window);
