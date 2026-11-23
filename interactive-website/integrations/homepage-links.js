/* NUDGE interactive website: Homepage integration. Almost everything on the Homepage is a link, so the route resolver does the work (category tiles, concern tiles, routine steps, product cards,
   reviews' product names, gift-set banner, header and footer). This file adds the two things a link cannot do: the newsletter form and the reviewer's "Shop the Look" note.
   Newsletter: the wireframe has no success state, so a notice is shown and NOTHING is stored or sent. In Shopify: {% form 'customer' %} with contact[tags]=newsletter. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  NS.integrations = NS.integrations || {};
  NS.integrations.home = function () {
    var email = document.getElementById('nl-email'); if (!email) return;
    var f = email.closest('form'); if (!f || f.__ix) return; f.__ix = 1;
    f.addEventListener('submit', function (e) {
      e.preventDefault();
      if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email.value.trim())) { email.setAttribute('aria-invalid', 'true'); email.focus(); NS.notify('Enter a valid email address.', { kind: 'error' }); return; }
      email.removeAttribute('aria-invalid'); NS.notify('Thanks. In the live store this address would be saved as a newsletter subscriber (not stored in the prototype).', { kind: 'success' }); email.value = '';
    });
  };
})(window);
