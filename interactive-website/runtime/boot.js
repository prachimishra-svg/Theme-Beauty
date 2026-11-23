/* NUDGE interactive website: ordered loader and initialiser. Loaded ONLY when interactive mode is on (see the hook at the end of 03-Wireframes/00-Shared-Tailwind-Foundation/nav.js).
   It loads every module in a fixed order, waits for the page's own scripts to finish (window load), then installs the route resolver and runs the integration for the current page.
   Any failure to load a module is recorded in NudgeSite.log.errors and shown in the status pill instead of leaving the page half-wired. */
(function (g) {
  'use strict';
  var me = document.currentScript, NS = g.NudgeSite = g.NudgeSite || {};
  if (NS.booted) return; NS.booted = true;
  NS.base = me && me.src ? me.src : g.location.href;
  NS.log = { nav: [], toasts: [], unresolved: [], unsupported: [], inert: [], opened: [], errors: [] };
  /* the wireframes' reviewer panel (title, Width preview, hover and edit toggles, review notes) and its width-preview dialog are not part of the site: hidden in interactive mode only, nothing is removed from the files */
  var st = document.getElementById('ix-hide-review') || document.createElement('style'); st.id = 'ix-hide-review'; st.textContent = '.rv,#wp,.ann,section[data-section="Custom Liquid Section"]{display:none!important}'; document.head.appendChild(st);
  var ROOT = new URL('../', NS.base).href;
  var FILES = ['data/collection-links.js', 'data/plp-raw.js', 'data/products.js', 'data/collections.js', 'data/blog-data.js', 'state/store.js', 'state/cart-state.js', 'state/search-state.js', 'state/wishlist-state.js', 'state/user-state.js',
    'components/notification-system.js', 'components/search-overlay.js', 'components/cart-drawer.js', 'components/breadcrumbs.js', 'components/status-pill.js',
    'routing/routes.js', 'routing/navigation-config.js', 'routing/route-resolver.js',
    'integrations/homepage-links.js', 'integrations/plp-links.js', 'integrations/pdp-links.js', 'integrations/cart-links.js', 'integrations/blog-links.js', 'integrations/content-links.js'];
  var left = FILES.length;
  function init() {
    try {
      NS.resolver.install(); NS.cart.watchHeader(); NS.cart.syncHeader(); NS.statusPill.mount();
      var pg = NS.routes.pageKey(), map = { home: 'home', collection: 'collection', product: 'product', cart: 'cart', drawer: 'drawer', blog: 'blog', article: 'article' };
      (NS.integrations[map[pg] || 'content'] || function () {})();
      var q = new URLSearchParams(g.location.search).get('q'); if (q && pg !== 'collection') NS.searchOverlay.open(q);
      /* build the overlays while the browser is idle so the first click only reveals them (keeps interaction latency low) */
      (g.requestIdleCallback || function (f) { setTimeout(f, 600); })(function () { try { NS.searchOverlay.prepare(); NS.cartDrawer.prepare(); } catch (e) { NS.log.errors.push(String(e)); } }, { timeout: 2000 });
      NS.ready = true; document.documentElement.setAttribute('data-ix', 'ready'); document.dispatchEvent(new CustomEvent('nudge:ready'));
    } catch (e) { NS.log.errors.push(String(e && e.stack || e)); document.documentElement.setAttribute('data-ix', 'error'); }
  }
  function done() { if (--left > 0) return; /* the page's own scripts have run once parsing is finished, so there is no need to wait for window load (images, fonts); waiting caused late layout shifts */ if (document.readyState !== 'loading') setTimeout(init, 0); else document.addEventListener('DOMContentLoaded', function () { setTimeout(init, 0); }); }
  function loadEach() {
    FILES.forEach(function (f) {
      var s = document.createElement('script'); s.src = ROOT + f; s.async = false; s.onload = done;
      s.onerror = function () { NS.log.errors.push('load failed: ' + f); done(); }; document.head.appendChild(s);
    });
  }
  /* one request for the whole layer (built by tools/build-bundle.ps1); the 24 modules are the fallback when the bundle is missing or ?ix_dev=1 */
  if (/[?&]ix_dev=1/.test(g.location.search)) loadEach();
  else {
    var b = document.createElement('script'); b.src = ROOT + 'runtime/interactive.bundle.js'; b.async = false;
    b.onload = function () { left = 1; done(); };
    b.onerror = function () { loadEach(); }; document.head.appendChild(b);
  }
})(window);