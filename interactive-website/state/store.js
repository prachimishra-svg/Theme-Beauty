/* NUDGE interactive website: shared state store.
   ONE store for every page (cart, wishlist, search, user, last visited collection). It persists in localStorage and, as a same-tab fallback for browsers that give every file:// page its own
   storage, in window.name. In Shopify the cart is the Cart AJAX API and the wishlist and account are app or customer-account features; this store only stands in for them in the prototype. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite = g.NudgeSite || {};
  var KEY = 'nudge.site.v1';
  function blank() { return { cart: [], extra: {}, meta: {}, note: '', wishlist: [], search: { q: '', recent: [] }, user: { signedIn: false, name: '' }, last: { collection: 'skin', product: '' }, seq: 0 }; }
  function read() {
    var raw = null; try { raw = g.localStorage.getItem(KEY); } catch (e) { raw = null; }
    if (!raw && typeof g.name === 'string' && g.name.indexOf('nudge:') === 0) raw = g.name.slice(6);
    var s = blank(); try { var p = JSON.parse(raw || '{}'); for (var k in p) if (Object.prototype.hasOwnProperty.call(p, k)) s[k] = p[k]; } catch (e) { /* start clean */ }
    return s;
  }
  var S = read();
  function save() { var j = JSON.stringify(S); try { g.localStorage.setItem(KEY, j); } catch (e) { /* storage blocked */ } try { g.name = 'nudge:' + j; } catch (e2) { /* ignore */ } }
  function emit(name, detail) { try { document.dispatchEvent(new CustomEvent('nudge:' + name, { detail: detail || {} })); } catch (e) { /* old browser */ } }
  NS.store = {
    get: function () { return S; },
    save: save,
    emit: emit,
    reload: function () { S = read(); return S; },
    reset: function () { S = blank(); save(); emit('cart'); emit('wishlist'); emit('search'); emit('user'); },
    key: KEY
  };
})(window);
