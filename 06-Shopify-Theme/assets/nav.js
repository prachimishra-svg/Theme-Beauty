/* NUDGE Beauty: mega menu (ported from the wireframe nav.js, Theme Editor safe).
   Desktop (1024 and up): hover or tap opens a full-width panel under the header; with the keyboard ArrowDown or Space on the link opens it and moves into it; Escape, an outside click or leaving closes it.
   Below 1024: the same markup is an accordion inside the slide-in drawer (one section open at a time); the drawer itself is opened by theme.js.
   Markup contract (sections/header.liquid): [data-mega=key] > [data-mega-link] + [data-mega-panel]. Items are bound once (flag) and re-bound on shopify:section:load.
   Review helper: ?mega=skin|makeup|hair|body opens that section on load. */
(function () {
  'use strict';
  var mq = window.matchMedia('(min-width:1024px)'), lastPointer = 'mouse';
  function hdr() { return document.getElementById('site-header'); }
  function itemsOf(h) { return h ? [].slice.call(h.querySelectorAll('[data-mega]')) : []; }
  function linkOf(it) { return it.querySelector('[data-mega-link]'); }
  function panelOf(it) { return it.querySelector('[data-mega-panel]'); }

  function setOpen(it, open) {
    var h = it.closest('#site-header'), items = itemsOf(h);
    if (open) { items.forEach(function (o) { if (o !== it && o.hasAttribute('data-open')) setOpen(o, false); }); }
    if (open) { it.setAttribute('data-open', ''); panelOf(it).setAttribute('data-open', ''); }
    else { it.removeAttribute('data-open'); panelOf(it).removeAttribute('data-open'); }
    linkOf(it).setAttribute('aria-expanded', open ? 'true' : 'false');
    var any = items.some(function (o) { return o.hasAttribute('data-open'); }), on = any && mq.matches;
    h.classList.toggle('mega-open', on); document.body.classList.toggle('mega-open', on);
  }
  function closeAll() { itemsOf(hdr()).forEach(function (o) { if (o.hasAttribute('data-open')) setOpen(o, false); }); }
  function roles() { itemsOf(hdr()).forEach(function (it) { var a = linkOf(it); if (mq.matches) a.removeAttribute('role'); else a.setAttribute('role', 'button'); }); }

  function bind(it) {
    if (it.__megaBound) return; it.__megaBound = true;
    var a = linkOf(it), openTimer = null, closeTimer = null;
    it.addEventListener('pointerenter', function (e) { if (!mq.matches || e.pointerType === 'touch') return; clearTimeout(closeTimer); openTimer = setTimeout(function () { setOpen(it, true); }, 80); });
    it.addEventListener('pointerleave', function (e) { if (!mq.matches || e.pointerType === 'touch') return; clearTimeout(openTimer); closeTimer = setTimeout(function () { setOpen(it, false); }, 200); });
    a.addEventListener('click', function (e) {
      var open = it.hasAttribute('data-open');
      if (!mq.matches) { e.preventDefault(); setOpen(it, !open); return; }
      if (lastPointer === 'touch' && !open) { e.preventDefault(); setOpen(it, true); }   /* touch laptops/tablets: first tap opens, second follows the link */
    });
    a.addEventListener('keydown', function (e) {
      if (!mq.matches && (e.key === ' ' || e.key === 'Spacebar')) { e.preventDefault(); a.click(); }
      if (mq.matches && (e.key === 'ArrowDown' || e.key === ' ' || e.key === 'Spacebar')) { e.preventDefault(); setOpen(it, true); var first = panelOf(it).querySelector('a'); if (first) first.focus(); }
    });
    /* Keyboard: Tab moves straight along Skin, Makeup, Hair, Body (a panel is not opened by focus alone, so users are not forced through its 12 links). ArrowDown or Space opens it and moves into it. */
    it.addEventListener('focusout', function (e) { if (!mq.matches) return; var to = e.relatedTarget; if (!to || it.contains(to)) return; setOpen(it, false); });
  }
  function init() {
    var h = hdr(); if (!h) return; itemsOf(h).forEach(bind); roles();
    var want = new URLSearchParams(location.search).get('mega');
    if (want) itemsOf(h).forEach(function (it) { if (it.getAttribute('data-mega') === want) setOpen(it, true); });
  }
  document.addEventListener('pointerdown', function (e) { lastPointer = e.pointerType || 'mouse'; }, true);
  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape' && e.keyCode !== 27) return;
    var open = itemsOf(hdr()).filter(function (o) { return o.hasAttribute('data-open'); })[0]; if (!open) return;
    var had = open.contains(document.activeElement); closeAll(); if (had && mq.matches) linkOf(open).focus();
  });
  document.addEventListener('click', function (e) { var h = hdr(); if (!h || !mq.matches) return; if (!h.contains(e.target) || e.target.id === 'mega-scrim') closeAll(); });
  var onMq = function () { closeAll(); roles(); };
  if (mq.addEventListener) mq.addEventListener('change', onMq); else mq.addListener(onMq);
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();
  document.addEventListener('shopify:section:load', init);
})();