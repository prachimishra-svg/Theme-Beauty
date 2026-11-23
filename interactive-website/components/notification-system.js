/* NUDGE interactive website: notification system (toast). One polite live region, one message at a time per kind, auto-dismiss, optional action link.
   Built from the wireframe's own message styles (.message, .message-success ...) and design tokens, so it has no look of its own. Uses: unsupported features (account, checkout, wishlist),
   sold-out and quantity errors, unresolved links. In Shopify: a theme snippet with a live region, or the section's own inline messages. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite, host = null, timer = null;
  function ensure() {
    if (host && document.body.contains(host)) return host;
    host = document.createElement('div'); host.id = 'ix-toast'; host.setAttribute('role', 'status'); host.setAttribute('aria-live', 'polite');
    host.className = 'pointer-events-none fixed inset-x-0 bottom-4 flex justify-center px-gutter'; host.style.zIndex = '2147483000'; document.body.appendChild(host); return host;
  }
  /* notify(text, {kind: 'info'|'success'|'error', action: {label, route|fn}, ms}) */
  function notify(text, o) {
    o = o || {}; var kind = o.kind || 'info', h = ensure(); clearTimeout(timer); h.innerHTML = '';
    var box = document.createElement('div'); box.setAttribute('data-ix-kind', kind);
    box.className = 'message message-' + (kind === 'error' ? 'error' : kind === 'success' ? 'success' : 'info') + ' pointer-events-auto items-center bg-surface shadow-lg';
    box.style.maxWidth = '34rem';
    var span = document.createElement('span'); span.textContent = text; box.appendChild(span);
    if (o.action) {
      var b = document.createElement('button'); b.type = 'button'; b.className = 'link ml-2 min-h-touch whitespace-nowrap font-medium underline'; b.textContent = o.action.label;
      b.addEventListener('click', function () { clear(); if (o.action.fn) o.action.fn(); else if (o.action.route) NS.go(o.action.route); }); box.appendChild(b);
    }
    var x = document.createElement('button'); x.type = 'button'; x.className = 'ml-auto min-h-touch min-w-touch px-2'; x.setAttribute('aria-label', 'Dismiss message'); x.textContent = '×'; x.addEventListener('click', clear); box.appendChild(x);
    h.appendChild(box); NS.log.toasts.push({ kind: kind, text: text });
    timer = setTimeout(clear, o.ms || 6000); return box;
  }
  function clear() { clearTimeout(timer); if (host) host.innerHTML = ''; }
  NS.notify = notify; NS.notifyClear = clear;
  /* a reason shown for every feature the prototype cannot perform; the wording says what Shopify provides */
  NS.unsupported = function (feature) {
    var M = {
      account: 'Accounts and sign-in are not part of the wireframes. In Shopify this is the customer account (/account), a Shopify-hosted feature.',
      checkout: 'Checkout is not simulated. In Shopify, Checkout goes to the Shopify-hosted /checkout with real payment.',
      wishlist: 'There is no wishlist in the approved wireframes. In Shopify it needs a wishlist app.',
      social: 'The social profile address is not set in the wireframe. In Shopify it is a theme setting (Social media links).',
      contact: 'This contact detail is a placeholder in the wireframe.',
      pagination: 'The wireframe shows one page of sample articles, so there is no next page to open.',
      none: 'This item has no destination in the wireframe.'
    };
    notify(M[feature] || M.none, { kind: 'info', ms: 7000 }); NS.log.unsupported.push(feature);
  };
})(window);
