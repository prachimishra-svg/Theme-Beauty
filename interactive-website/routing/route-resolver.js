/* NUDGE interactive website: route resolver = the click interceptor that makes the wireframe's links real.
   It runs in the CAPTURE phase, so it decides before a page's own handler. It leaves alone: in-page anchors whose target exists (#s-collect, #main, skip links), links to other wireframe files
   (they already navigate), external and mailto links, modified clicks (new tab), and the mobile accordion toggles in the main menu. Everything else is resolved by navigation-config.js.
   Anything it cannot resolve is NOT left as a dead "#": it shows a notice and is recorded in NudgeSite.log.unresolved so the test report lists it. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  function section(a) {
    var s = a.closest('[data-section]'); if (s) return s.getAttribute('data-section');
    if (a.closest('#site-header')) return 'Header'; if (a.closest('footer')) return 'Footer'; var d = a.closest('dialog'); return d ? 'Dialog ' + d.id : 'Main';
  }
  function dispatch(r, a) {
    if (typeof r === 'string') {
      var m = /^\/collections\/([a-z0-9-]+)/.exec(r); if (m) NS.store.get().last.collection = m[1]; NS.store.save();
      NS.log.nav.push(r); if (!NS.go(r)) NS.notify('This page does not exist yet.', { kind: 'error' }); return;
    }
    switch (r && r.action) {
      case 'search': NS.searchOverlay.open('', a); break;
      case 'cart': NS.cartDrawer.open(a); break;
      case 'unsupported': NS.unsupported(r.feature); break;
      case 'inert': NS.log.inert.push(NS.nav.norm(a.textContent).slice(0, 40)); break;
      default: NS.log.unresolved.push({ page: NS.routes.pageKey(), text: NS.nav.norm(a.textContent).slice(0, 50), href: a.getAttribute('href') }); NS.unsupported('none');
    }
  }
  function onClick(e) {
    if (e.defaultPrevented || e.button !== 0 || e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;
    if (e.target.closest && e.target.closest('#ix-pill,#ix-search,#ix-toast')) { var inner = e.target.closest('a[data-ix-route]'); if (!inner) return; }
    var a = e.target.closest ? e.target.closest('a') : null; if (!a) return;
    var route = a.getAttribute('data-ix-route'); if (route) { if (a.closest('#ix-search')) NS.searchState.remember((document.getElementById('ix-s-q') || {}).value); e.preventDefault(); e.stopPropagation(); if (route === '/cart' && a.closest('#ix-cart-drawer,#cart-drawer')) NS.go(route); else dispatch(route, a); return; }
    var href = a.getAttribute('href'); if (href === null || a.hasAttribute('data-ix-skip') || a.target === '_blank') return;
    if (href.charAt(0) !== '#') return;
    if (a.hasAttribute('data-mega-link') && !g.matchMedia('(min-width:1024px)').matches) return;
    var id = href.slice(1), exists = !!(id && document.getElementById(id));
    /* a hash whose target exists on this page is a working in-page anchor (skip links, policy sections, #reviews, #s07): leave it. Three ids are placeholders that also exist as ids and are still resolved: */
    if (exists && id !== 'top' && id !== 's06' && id !== 's16') return;
    var text = a.getAttribute('aria-label') && !a.textContent.trim() ? a.getAttribute('aria-label') : (a.textContent || a.getAttribute('aria-label') || '');
    var r = NS.nav.resolve(a, href, text, section(a));
    if (r === null && exists) return; /* back to top, hero CTA that scrolls to its section */
    e.preventDefault(); e.stopPropagation(); dispatch(r, a);
  }
  NS.resolver = { install: function () { if (!NS.resolver.on) { document.addEventListener('click', onClick, true); NS.resolver.on = true; } }, dispatch: dispatch, section: section };
})(window);
