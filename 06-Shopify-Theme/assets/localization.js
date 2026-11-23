/* NUDGE Beauty: country and currency selector (Shopify Markets, native localization form).
   The pill #market-btn opens the list #market-menu; choosing a country sets the form's country_code and submits it to /localization.
   Port of the wireframe's open/close and keyboard behaviour (the wireframe's sample exchange rates are NOT used: Shopify converts and rounds prices). Delegated, Theme Editor safe. */
(function () {
  'use strict';
  function parts() { return { btn: document.getElementById('market-btn'), menu: document.getElementById('market-menu') }; }
  function open(o) {
    var p = parts(); if (!p.btn || !p.menu) return;
    p.btn.setAttribute('aria-expanded', o ? 'true' : 'false'); p.menu.hidden = !o;
    if (o) { var f = p.menu.querySelector('[aria-current]') || p.menu.querySelector('button'); if (f) f.focus(); }
  }
  document.addEventListener('click', function (e) {
    var p = parts(); if (!p.btn || !p.menu) return;
    if (e.target.closest('#market-btn')) { open(p.menu.hidden); return; }
    var c = e.target.closest('[data-market]');
    if (c && p.menu.contains(c)) {
      var form = p.menu.querySelector('form'), input = form && form.querySelector('[data-country-input]');
      if (input && c.getAttribute('data-market') !== input.value) { input.value = c.getAttribute('data-market'); form.submit(); } else { open(false); p.btn.focus(); }
      return;
    }
    if (!p.menu.hidden && !e.target.closest('#market')) open(false);
  });
  document.addEventListener('keydown', function (e) {
    var p = parts(); if (!p.menu || p.menu.hidden) return;
    if (e.key === 'Escape') { open(false); p.btn.focus(); return; }
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      var items = [].slice.call(p.menu.querySelectorAll('[data-market]')), i = items.indexOf(document.activeElement);
      e.preventDefault(); items[(i + (e.key === 'ArrowDown' ? 1 : -1) + items.length) % items.length].focus();
    }
  });
})();