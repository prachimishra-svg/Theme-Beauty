/* NUDGE Beauty: global behaviour (mobile menu drawer, scrolled header, announcement bar, footer accordion).
   Ported from the wireframe page scripts. Uses document-level event delegation, so it keeps working when the Theme Editor re-renders a section;
   only the announcement bar timer is (re)started on `shopify:section:load` and cleared on `shopify:section:unload`. */
(function () {
  'use strict';
  var b = document.body, annTimer = null, annIndex = 0;

  /* ---- mobile menu drawer (#menu-btn, #nav-close, #scrim, Escape) ---- */
  function navOpen(open) {
    b.classList.toggle('nav-open', open);
    var btn = document.getElementById('menu-btn'); if (btn) btn.setAttribute('aria-expanded', open ? 'true' : 'false');
    if (open) { var c = document.getElementById('nav-close'); if (c) c.focus({ preventScroll: true }); }
    else if (btn && document.activeElement && document.getElementById('nav') && document.getElementById('nav').contains(document.activeElement)) { btn.focus({ preventScroll: true }); }
  }
  document.addEventListener('click', function (e) {
    if (e.target.closest('#menu-btn')) { navOpen(true); return; }
    if (e.target.closest('#nav-close') || e.target.closest('#scrim')) { navOpen(false); return; }
    var h = e.target.closest('.fcol > button');
    if (h) { var f = h.parentNode, o = !f.classList.contains('is-open'); f.classList.toggle('is-open', o); h.setAttribute('aria-expanded', o ? 'true' : 'false'); return; }
    if (e.target.closest('#ann-prev')) { ann(-1, true); return; }
    if (e.target.closest('#ann-next')) { ann(1, true); return; }
  });
  document.addEventListener('keydown', function (e) { if ((e.key === 'Escape' || e.keyCode === 27) && b.classList.contains('nav-open')) navOpen(false); });

  /* ---- header turns solid after a few pixels of scroll (used by the transparent Homepage header) ---- */
  function scrolled() { b.classList.toggle('is-scrolled', (window.pageYOffset || document.documentElement.scrollTop || 0) > 8); }
  window.addEventListener('scroll', scrolled, { passive: true }); scrolled();

  /* ---- announcement bar: messages live in the hidden [data-ann-source] list ---- */
  function messages() { var bar = document.getElementById('annbar'); return bar ? [].slice.call(bar.querySelectorAll('[data-ann-source] [data-ann-item]')) : []; }
  function ann(delta, user) {
    var items = messages(); if (items.length < 2) return;
    annIndex = (annIndex + delta + items.length) % items.length;
    var msg = document.getElementById('ann-msg'); if (msg) msg.innerHTML = items[annIndex].innerHTML;
    [].forEach.call(document.querySelectorAll('.ann-dot'), function (x, i) { x.classList.toggle('bg-current', i === annIndex); x.classList.toggle('opacity-100', i === annIndex); x.classList.toggle('opacity-muted', i !== annIndex); });
    if (user) annStart(true);
  }
  function annStart(restart) {
    clearInterval(annTimer); annTimer = null;
    var bar = document.getElementById('annbar'); if (!bar || bar.getAttribute('data-autoplay') !== 'true') return;
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    var ms = parseInt(bar.getAttribute('data-interval'), 10) || 5000;
    annTimer = setInterval(function () { if (!bar.matches(':hover, :focus-within')) ann(1, false); }, ms);
  }
  /* ---- footer column headings are accordion buttons below 768 px and plain headings from 768 px: take them out of the tab order and drop aria-expanded there ---- */
  var footMq = window.matchMedia('(min-width:768px)');
  function syncFooter() {
    [].forEach.call(document.querySelectorAll('.fcol > button'), function (b) {
      if (footMq.matches) { b.setAttribute('tabindex', '-1'); b.setAttribute('aria-disabled', 'true'); b.removeAttribute('aria-expanded'); }
      else { b.removeAttribute('tabindex'); b.removeAttribute('aria-disabled'); b.setAttribute('aria-expanded', b.parentNode.classList.contains('is-open') ? 'true' : 'false'); }
    });
  }
  if (footMq.addEventListener) footMq.addEventListener('change', syncFooter); else footMq.addListener(syncFooter);
  function init() { annIndex = 0; annStart(); scrolled(); syncFooter(); }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();
  document.addEventListener('shopify:section:load', function () { init(); });
  document.addEventListener('shopify:section:unload', function () { clearInterval(annTimer); annTimer = null; });
})();