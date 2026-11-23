/* NUDGE interactive website: content pages (Contact, FAQ, About, Story, Shipping, Returns, Privacy, Terms, 404). These pages need no binding: their in-page anchors already work and their
   cross links (Contact, FAQ, policies, Shop, Home, Journal) are resolved by the route resolver. Only the Story and About calls to action and the 404's "back to the store" links are listed here
   so the page-linking map and the tests know they were considered. Contact form and FAQ accordions keep the page's own behaviour (the contact form shows the page's own success state and sends nothing).
   In Shopify: {% form 'contact' %} posts to /contact; policy pages are shop.policies or page templates. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  NS.integrations.content = function () { /* intentionally empty: resolver rules cover every link on these pages */ };
})(window);
