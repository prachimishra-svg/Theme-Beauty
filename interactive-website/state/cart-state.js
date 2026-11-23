/* NUDGE interactive website: shared cart state.
   ONE cart for every page. Pages that already own a cart model (Cart page, Cart drawer, the drawer built here) use window.NudgeCart (03-Wireframes/00-Shared-Tailwind-Foundation/cart-render.js);
   this module registers every catalogue product in its CAT, pushes the shared lines into it and pulls the lines back after the shopper edits them. Pages without a cart model (Homepage, PLP, PDP)
   add through NudgeSite.cart.add(). In Shopify: POST /cart/add.js, /cart/change.js, /cart.js (the Cart AJAX API) replace this module; the line identity becomes the variant id. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite, st = NS.store, P = NS.products;
  function S() { return st.get(); }
  function prod(h) { return P.byHandle(h); }
  function maxQty(p) { return Math.max(1, Math.min(10, p.low || 24)); }
  function findLine(h) { var c = S().cart; for (var i = 0; i < c.length; i++) if (c[i].h === h) return c[i]; return null; }
  var cart = {
    lines: function () { return S().cart.filter(function (l) { return prod(l.h); }); },
    count: function () { return S().cart.reduce(function (a, l) { return a + l.qty; }, 0); },
    subtotal: function () { return S().cart.reduce(function (a, l) { var p = prod(l.h); return a + (p ? p.price * l.qty : 0); }, 0); },
    has: function (h) { return !!findLine(h); },
    /* add(handle, {qty, shade, size}) -> { ok, reason } ; sold-out products are refused, quantity is capped like the wireframe cart (10 or stock) */
    add: function (h, o) {
      o = o || {}; var p = prod(h); if (!p) return { ok: false, reason: 'unknown' }; if (p.sold) return { ok: false, reason: 'soldout' };
      var qty = Math.max(1, parseInt(o.qty, 10) || 1), l = findLine(h), cap = maxQty(p), res = { ok: true, capped: false };
      if (l) { l.qty += qty; } else { l = { h: h, qty: qty }; S().cart.push(l); }
      if (l.qty > cap) { l.qty = cap; res.capped = true; }
      if (o.shade || o.size) S().meta[h] = { shade: o.shade || (S().meta[h] || {}).shade || '', size: o.size || (S().meta[h] || {}).size || '' };
      st.save(); st.emit('cart', { action: 'add', handle: h }); cart.syncHeader(); return res;
    },
    setQty: function (h, q) { var l = findLine(h), p = prod(h); if (!l || !p) return; l.qty = Math.max(1, Math.min(maxQty(p), q)); st.save(); st.emit('cart', { action: 'qty', handle: h }); cart.syncHeader(); },
    remove: function (h) { S().cart = S().cart.filter(function (l) { return l.h !== h; }); st.save(); st.emit('cart', { action: 'remove', handle: h }); cart.syncHeader(); },
    clear: function () { S().cart = []; st.save(); st.emit('cart', { action: 'clear' }); cart.syncHeader(); },
    sample: function () { S().cart = [{ h: 'tinted-moisturiser', qty: 1 }, { h: 'face-serum', qty: 1 }, { h: 'face-cleanser', qty: 1 }]; st.save(); st.emit('cart', { action: 'sample' }); cart.syncHeader(); },
    note: function (v) { if (typeof v === 'string') { S().note = v; st.save(); } return S().note; },
    variantText: function (h) { var p = prod(h), m = S().meta[h] || {}; return [m.shade, m.size || (p && p.size)].filter(Boolean).join(' · '); },
    /* header count: written on every page, and rewritten if a page script writes its own number (PLP quick view and PDP keep page-local counters) */
    syncHeader: function () {
      var n = cart.count();
      [].forEach.call(document.querySelectorAll('#site-header .cnt'), function (b) {
        if (b.textContent !== String(n)) b.textContent = n;
        var a = b.closest('[aria-label^="Cart"]'); if (a && a.getAttribute('aria-label') !== 'Cart, ' + n + (n === 1 ? ' item' : ' items')) a.setAttribute('aria-label', 'Cart, ' + n + (n === 1 ? ' item' : ' items'));
      });
    },
    watchHeader: function () {
      var b = document.querySelector('#site-header .cnt'); if (!b || b.__ixw) return; b.__ixw = 1;
      new MutationObserver(function () { if (b.textContent !== String(cart.count())) cart.syncHeader(); }).observe(b, { childList: true, characterData: true, subtree: true });
      cart.syncHeader();
    },
    /* ---- bridge to window.NudgeCart (Cart page, Cart drawer, drawer component) ---- */
    nudgeId: function (h) { return P.cartId(h) || h; },
    registerCatalogue: function (C) {
      P.all.forEach(function (p, i) {
        var id = cart.nudgeId(p.handle), c = C.CAT[id];
        if (!c) C.CAT[id] = { name: p.name, variant: p.size, price: p.price, cmp: p.compare > p.price ? p.compare : 0, stock: p.low || 24, v: i % 3 };
        else { c.price = p.price; c.cmp = p.compare > p.price ? p.compare : c.cmp; }
      });
    },
    asNudgeList: function (C) {
      cart.registerCatalogue(C);
      return cart.lines().map(function (l) { var id = cart.nudgeId(l.h), v = cart.variantText(l.h); if (v && C.CAT[id]) C.CAT[id].variant = v; return [id, l.qty]; });
    },
    /* pull the lines back from the cart model after the shopper edited them there */
    pull: function (C) {
      var rev = {}; P.all.forEach(function (p) { rev[cart.nudgeId(p.handle)] = p.handle; });
      var prev = S().cart, next = [];
      C.S.items.forEach(function (i) { var h = rev[i.id]; if (h) next.push({ h: h, qty: i.qty }); });
      var same = prev.length === next.length && prev.every(function (l, k) { return l.h === next[k].h && l.qty === next[k].qty; });
      if (same) return; S().cart = next; st.save(); st.emit('cart', { action: 'pull' }); cart.syncHeader();
    },
    /* make the cart model show the shared cart; the model's own sample states are replaced while this runs */
    hookNudge: function (C) {
      if (!C || C.__ix) return; C.__ix = 1; var orig = C.set, forcing = false;
      C.set = function (list) { orig(forcing ? cart.asNudgeList(C) : list); };
      C.pushShared = function (rerender) { forcing = true; try { rerender(); } finally { forcing = false; } };
    },
    bindRoot: function (C, root) {
      if (!root || root.__ixb) return; root.__ixb = 1;
      ['click', 'change'].forEach(function (ev) { root.addEventListener(ev, function () { cart.pull(C); }); });
    }
  };
  NS.cart = cart;
  document.addEventListener('nudge:cart', function () { cart.syncHeader(); });
})(window);
