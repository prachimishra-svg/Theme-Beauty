/* NUDGE interactive website: cart drawer on every page.
   The markup is the Cart Drawer wireframe's own <dialog class="drawer"> (03-Wireframes/05-.../Cart_Drawer_Wireframe_v1.html) and the render and bind code is that page's own script, using
   window.NudgeCart (cart-render.js) and window.NudgeDrawer (drawer.js), which are loaded on demand when the page does not already have them. Nothing here is a new design.
   On the Cart page the header cart link stays on the page; on the Cart Drawer wireframe the page's own drawer is used. In Shopify: the cart-drawer section re-rendered with the Section Rendering API. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite, D = null, C = null, ready = null;
  var HTML = '<div class="drawer-head"><h2 class="type-h5 m-0" id="cd-title">Cart <span class="font-body text-body-sm font-regular normal-case tracking-normal text-ink-secondary" id="cd-count">0 items</span></h2><button class="icon-btn" type="button" data-drawer-close aria-label="Close cart"><svg class="icon" aria-hidden="true" focusable="false"><use href="#icon-close"></use></svg></button></div>'
    + '<div class="drawer-body flex flex-col gap-4" id="cd-body"><div id="cd-cart" class="flex flex-col gap-4"><div id="cd-fs"></div><div id="cd-undo"></div><div id="cd-lines"></div><div id="cd-up"></div></div>'
    + '<div id="cd-empty" class="flex flex-1 flex-col items-center justify-center gap-5 py-10 text-center" hidden><p class="type-h4 m-0">Your cart is empty</p><p class="m-0 text-ink-secondary">Nothing here yet. Browse the collections to find your next favourite.</p><button class="btn btn-primary" type="button" data-drawer-close id="cd-continue">Continue shopping</button>'
    + '<div class="chip-row max-w-full justify-center" aria-label="Shop by collection"><a class="chip" href="#shop" data-ix-route="/collections/all">Best sellers</a><a class="chip" href="#shop" data-ix-route="/collections/skin">Skin care</a><a class="chip" href="#shop" data-ix-route="/collections/makeup">Makeup</a><a class="chip" href="#shop" data-ix-route="/collections/hair">Hair</a><a class="chip" href="#shop" data-ix-route="/collections/body">Body</a></div></div></div>'
    + '<div class="drawer-foot flex flex-col gap-3" id="cd-foot"><div class="flex items-baseline justify-between gap-4"><span>Subtotal</span><span class="font-heading text-h4 font-regular leading-tight [font-variant-numeric:lining-nums]" id="cd-sub">$0.00</span></div>'
    + '<div class="flex items-baseline justify-between gap-4 text-brand" id="cd-savrow"><span>You save</span><span id="cd-sav">$0.00</span></div><p class="m-0 text-caption text-ink-secondary">Taxes and shipping calculated at checkout.</p>'
    + '<button class="btn btn-primary btn-lg btn-block" type="button" id="cd-checkout"><svg class="icon" aria-hidden="true" focusable="false"><use href="#icon-lock"></use></svg><span>Checkout</span></button><a class="link link-standalone justify-center" href="#cart" id="cd-viewcart" data-ix-route="/cart">View cart</a></div>';
  function load(src) { return new Promise(function (ok, no) { var s = document.createElement('script'); s.src = src; s.onload = ok; s.onerror = function () { no(new Error('load ' + src)); }; document.head.appendChild(s); }); }
  function need() {
    if (ready) return ready; var base = NS.base, p = Promise.resolve();
    if (!g.NudgeCart) p = p.then(function () { return load(new URL('../../03-Wireframes/00-Shared-Tailwind-Foundation/cart-render.js', base).href); });
    if (!g.NudgeDrawer) p = p.then(function () { return load(new URL('../../01-Design-System/Scripts/drawer.js', base).href); });
    ready = p; return p;
  }
  function $(id) { return document.getElementById(id); }
  function render(focus) {
    var n = C.count(), emp = C.S.items.length === 0 && !C.S.undo;
    $('cd-count').textContent = n + (n === 1 ? ' item' : ' items'); $('cd-empty').hidden = !emp; $('cd-cart').hidden = emp; $('cd-foot').hidden = emp;
    $('cd-fs').innerHTML = C.fsHtml(); $('cd-undo').innerHTML = C.undoHtml(); $('cd-lines').innerHTML = C.linesHtml();
    var up = document.createElement('div'); up.innerHTML = C.upHtml('Add to your order'); var li = up.querySelectorAll('li'); for (var i = 1; i < li.length; i++) li[i].remove(); $('cd-up').innerHTML = up.innerHTML;
    $('cd-sub').textContent = C.money(C.sub()); var sv = C.save(); $('cd-savrow').hidden = sv <= 0; $('cd-sav').textContent = C.money(sv);
    NS.cart.syncHeader();
    if (focus) { var el = null; if (focus === 'undo') el = D.querySelector('[data-undo]'); else if (focus.id) el = D.querySelector('.cl[data-id="' + focus.id + '"] ' + focus.sel); if (el && !el.disabled) el.focus(); }
  }
  function build() {
    D = document.createElement('dialog'); D.className = 'drawer'; D.id = 'ix-cart-drawer'; D.setAttribute('aria-labelledby', 'cd-title'); D.innerHTML = HTML; document.body.appendChild(D);
    C.ctx = 'drawer'; NS.cart.hookNudge(C);
    C.bind($('cd-body'), function (kind) {
      var a = document.activeElement, f = null;
      if (a && a.closest && a.closest('.cl')) f = { id: a.closest('.cl').getAttribute('data-id'), sel: a.hasAttribute('data-plus') ? '[data-plus]' : a.hasAttribute('data-minus') ? '[data-minus]' : a.hasAttribute('data-q') ? '[data-q]' : '[data-rm]' };
      if (C.S.undo && kind === 'edit' && !f) f = 'undo'; if (kind === 'remove') f = 'undo'; render(f);
    });
    NS.cart.bindRoot(C, $('cd-body'));
    D.addEventListener('click', function (e) {
      if (e.target.closest('#cd-checkout')) { NS.unsupported('checkout'); return; }
      var a = e.target.closest('a[data-ix-route]'); if (a) { e.preventDefault(); NS.go(a.getAttribute('data-ix-route')); }
    });
  }
  function close() { if (D && D.open && g.NudgeDrawer) g.NudgeDrawer.close(D); }
  function open(opener) {
    if (NS.searchOverlay && NS.searchOverlay.isOpen()) NS.searchOverlay.close(); /* one overlay at a time */
    var pg = NS.routes.pageKey();
    if (pg === 'drawer' && g.NudgeCartDrawer) { C = g.NudgeCart; NS.cart.registerCatalogue(C); C.pushShared(function () { g.NudgeCartDrawer.state('multi'); }); g.NudgeCartDrawer.open(opener); NS.log.opened.push('drawer'); return Promise.resolve(); }
    if (pg === 'cart') { var c = document.getElementById('cart'); if (c) c.scrollIntoView({ block: 'start' }); return Promise.resolve(); }
    return need().then(function () {
      C = g.NudgeCart; if (!D) build();
      C.set([]); C.pushShared(function () { C.set([]); }); render(); g.NudgeDrawer.open(D, opener || document.querySelector('#site-header a[aria-label^="Cart"]')); NS.log.opened.push('drawer');
    }).catch(function () { NS.go('/cart'); });
  }
  NS.cartDrawer = { prepare: function () { var pg = NS.routes.pageKey(); if (pg === 'cart' || pg === 'drawer' || D) return Promise.resolve(); return need().then(function () { C = g.NudgeCart; if (!D) build(); }).catch(function () { /* opened on demand instead */ }); }, open: open, close: close, isOpen: function () { return !!D && D.open; } };
})(window);
