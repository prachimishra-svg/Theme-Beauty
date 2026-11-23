/* NUDGE Beauty: cart drawer behaviour (Shopify AJAX Cart API + Section Rendering API, no app).
   The drawer (sections/cart-drawer.liquid) is rendered by Shopify from the real cart. Every change posts to /cart/change.js or /cart/add.js, then the
   drawer section is fetched again (/?sections=cart-drawer) and its contents are swapped into the open <dialog>, so prices, free-shipping progress, savings,
   stock limits and the empty state always come from Shopify. Focus is put back on the control the shopper was using.
   Opening/closing, focus trap, scroll lock and focus return are the Design System's drawer.js (data-drawer-open / data-drawer-close).
   Undo after Remove re-adds the variant and quantity (line item properties are not restored). Delegated events: Theme Editor safe.
   Other code can ask for a refresh with: document.dispatchEvent(new CustomEvent('cart:refresh', { detail: { open: true } })). */
(function () {
  'use strict';
  var undo = null, undoTimer = null, busy = false;

  function root() { return (window.Shopify && window.Shopify.routes && window.Shopify.routes.root) || '/'; }
  function dlg() { return document.getElementById('cart-drawer'); }
  function post(path, body) {
    return fetch(root() + path, { method: 'POST', headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }, body: JSON.stringify(body) })
      .then(function (r) { return r.json().then(function (j) { return { ok: r.ok, json: j }; }, function () { return { ok: r.ok, json: {} }; }); });
  }
  function focusSpec() {
    var a = document.activeElement, li = a && a.closest && a.closest('#cart-drawer .cl');
    if (li) return { key: li.getAttribute('data-id'), sel: a.hasAttribute('data-plus') ? '[data-plus]' : a.hasAttribute('data-minus') ? '[data-minus]' : a.hasAttribute('data-q') ? '[data-q]' : '[data-rm]' };
    return null;
  }
  function updateHeader(d) {
    var n = d.getAttribute('data-cart-count'), label = d.getAttribute('data-cart-aria');
    [].forEach.call(document.querySelectorAll('[data-cart-count]'), function (b) { if (b !== d) b.textContent = n; });
    [].forEach.call(document.querySelectorAll('#site-header [data-drawer-open="cart-drawer"], #site-header a[aria-label^="Cart"]'), function (b) { if (label) b.setAttribute('aria-label', label); });
  }
  /* fetch the drawer section again and swap it in */
  function refresh(opts) {
    opts = opts || {};
    return fetch(root() + '?sections=cart-drawer', { headers: { 'Accept': 'application/json' } })
      .then(function (r) { return r.json(); })
      .then(function (j) {
        var doc = new DOMParser().parseFromString(j['cart-drawer'] || '', 'text/html'), fresh = doc.getElementById('cart-drawer'), d = dlg();
        if (!fresh || !d) return;
        ['data-cart-count', 'data-cart-aria', 'data-msg-stock', 'data-msg-limit', 'data-msg-removed', 'data-checkout-url'].forEach(function (a) { d.setAttribute(a, fresh.getAttribute(a)); });
        d.innerHTML = fresh.innerHTML;
        updateHeader(d);
        if (opts.error) showError(opts.error.key, opts.error.text);
        if (undo && !d.querySelector('#cd-cart[hidden]')) showUndo();
        var f = opts.focus, el = null;
        if (f === 'undo') el = d.querySelector('[data-undo]');
        else if (f && f.key) el = d.querySelector('.cl[data-id="' + f.key + '"] ' + f.sel);
        if (el && !el.disabled) el.focus();
        if (opts.open && !d.open && window.NudgeDrawer) window.NudgeDrawer.open(d, document.querySelector('#site-header [data-drawer-open]'));
      });
  }
  function showError(key, text) {
    var d = dlg(), li = d && d.querySelector('.cl[data-id="' + key + '"]'), t = d && d.querySelector('#cd-error-template'); if (!li || !t) return;
    var p = t.content.firstElementChild.cloneNode(true); p.textContent = text; li.querySelector('.flex.flex-col.gap-1').appendChild(p);
  }
  function showUndo() {
    var d = dlg(), t = d && d.querySelector('#cd-undo-template'), host = d && d.querySelector('#cd-undo'); if (!t || !host || !undo) return;
    var p = t.content.firstElementChild.cloneNode(true);
    p.querySelector('[data-undo-text]').textContent = (d.getAttribute('data-msg-removed') || '').replace('__TITLE__', undo.title);
    host.innerHTML = ''; host.appendChild(p);
  }
  function clearUndo() { undo = null; clearTimeout(undoTimer); var h = dlg() && dlg().querySelector('#cd-undo'); if (h) h.innerHTML = ''; }

  function change(key, qty, focus, errorKeyOnFail) {
    if (busy) return; busy = true;
    return post('cart/change.js', { id: key, quantity: qty }).then(function (res) {
      var err = null;
      if (!res.ok) err = { key: key, text: (res.json && (res.json.description || res.json.message)) || '' };
      return refresh({ focus: focus, error: err });
    }).then(function () { busy = false; }, function () { busy = false; });
  }

  document.addEventListener('click', function (e) {
    var d = dlg(); if (!d || !d.contains(e.target)) { return; }
    var li = e.target.closest('.cl'), key = li && li.getAttribute('data-id');
    if (e.target.closest('[data-minus]')) { clearUndo(); change(key, Math.max(1, parseInt(li.querySelector('[data-q]').value, 10) - 1), { key: key, sel: '[data-minus]' }); return; }
    if (e.target.closest('[data-plus]')) { clearUndo(); change(key, parseInt(li.querySelector('[data-q]').value, 10) + 1, { key: key, sel: '[data-plus]' }); return; }
    if (e.target.closest('[data-rm]')) {
      var name = (li.querySelector('.cl__name') || {}).textContent || '';
      undo = { variant: li.getAttribute('data-variant'), qty: parseInt(li.getAttribute('data-qty'), 10) || 1, title: name.trim() };
      clearTimeout(undoTimer); undoTimer = setTimeout(clearUndo, 8000);
      change(key, 0, 'undo'); return;
    }
    if (e.target.closest('[data-undo]')) {
      if (!undo) return; var u = undo; clearUndo();
      post('cart/add.js', { id: u.variant, quantity: u.qty }).then(function () { return refresh({ focus: null }); }); return;
    }
    var add = e.target.closest('[data-add]');
    if (add) { clearUndo(); post('cart/add.js', { id: add.getAttribute('data-add'), quantity: 1 }).then(function () { return refresh({}); }); return; }
    if (e.target.closest('[data-checkout]')) { window.location.href = d.getAttribute('data-checkout-url') || (root() + 'checkout'); }
  });

  document.addEventListener('change', function (e) {
    var q = e.target.closest && e.target.closest('#cart-drawer [data-q]'); if (!q) return;
    var li = q.closest('.cl'), key = li.getAttribute('data-id'), d = dlg(), v = parseInt(q.value, 10), max = parseInt(q.getAttribute('data-max'), 10) || 10, stock = parseInt(q.getAttribute('data-stock'), 10);
    var msg = null; if (isNaN(v) || v < 1) v = 1;
    if (v > max) { msg = (max < 10 && stock >= 0) ? (d.getAttribute('data-msg-stock') || '').replace('__N__', max) : (d.getAttribute('data-msg-limit') || ''); v = max; }
    clearUndo();
    if (busy) return; busy = true;
    post('cart/change.js', { id: key, quantity: v }).then(function (res) {
      var err = msg ? { key: key, text: msg } : (!res.ok ? { key: key, text: (res.json && res.json.description) || '' } : null);
      return refresh({ focus: { key: key, sel: '[data-q]' }, error: err });
    }).then(function () { busy = false; }, function () { busy = false; });
  });

  document.addEventListener('cart:refresh', function (e) { refresh({ open: !!(e.detail && e.detail.open) }); });
  document.addEventListener('shopify:section:load', function (e) { if (e.target && e.target.id === 'shopify-section-cart-drawer') { var d = dlg(); if (d) updateHeader(d); } });
})();
