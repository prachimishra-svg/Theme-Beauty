/* NUDGE "Load more" (phones). Numbered pagination stays the desktop pattern; this replaces it below 600px.
   Markup and CSS: components.css, "Load more". Without JavaScript the button is an ordinary link to the next page.

   Contract:
     <div data-load-more data-load-more-target="results-id" data-total="96" data-noun="products">
       <p data-load-more-status role="status">Showing 24 of 96 products</p>
       <a class="btn btn--secondary" href="?page=2" data-load-more-button>Load more products</a>
       <div class="message message--error" role="alert" data-load-more-error hidden>...</div>
     </div>
   Behavior: loading state (aria-busy on the list, aria-disabled on the button, which keeps keyboard focus, label
   "Loading..."); on success the new items are appended, the status is announced, focus moves to the first new item
   and the address bar is updated with replaceState; on failure an alert shows, the list is untouched and the button
   becomes "Try again". Modified clicks (ctrl, meta, shift, middle button) open the link normally.
   Loader: NudgeLoadMore.loader(url, root) returns a promise of { items: [Element], nextUrl: string|null }. The
   default fetches the URL and reads the same list and button from the returned page; it has NOT been exercised
   against a real Shopify theme (none exists yet). The showcase replaces it with a stub. */
(function () {
  'use strict';
  var LM = window.NudgeLoadMore = window.NudgeLoadMore || {};
  LM.loader = LM.loader || function (url, root) {
    return fetch(url, { credentials: 'same-origin' }).then(function (r) {
      if (!r.ok) throw new Error('HTTP ' + r.status);
      return r.text();
    }).then(function (html) {
      var doc = new DOMParser().parseFromString(html, 'text/html');
      var list = doc.getElementById(root.getAttribute('data-load-more-target'));
      if (!list) throw new Error('Results list not found in the response');
      var next = doc.querySelector('[data-load-more-button]');
      return { items: [].slice.call(list.children), nextUrl: next && !next.hidden ? next.getAttribute('href') : null };
    });
  };

  function init(root) {
    var btn = root.querySelector('[data-load-more-button]'), status = root.querySelector('[data-load-more-status]'), err = root.querySelector('[data-load-more-error]');
    var list = document.getElementById(root.getAttribute('data-load-more-target'));
    if (!btn || !status || !list) return;
    var total = +root.getAttribute('data-total') || 0, noun = root.getAttribute('data-noun') || 'items', label = btn.textContent.trim(), busy = false;
    function announce() { status.textContent = list.children.length >= total ? 'All ' + total + ' ' + noun + ' shown' : 'Showing ' + list.children.length + ' of ' + total + ' ' + noun; }

    btn.addEventListener('click', function (e) {
      if (e.defaultPrevented || e.button || e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;
      e.preventDefault();
      if (busy) return;
      busy = true;
      if (err) err.hidden = true;
      btn.setAttribute('aria-disabled', 'true'); list.setAttribute('aria-busy', 'true');
      btn.textContent = 'Loading…'; status.textContent = 'Loading more ' + noun;
      var url = btn.getAttribute('href');
      Promise.resolve().then(function () { return LM.loader(url, root); }).then(function (res) {
        var first = res.items[0];
        res.items.forEach(function (i) { list.appendChild(i); });
        try { history.replaceState(history.state, '', url); } catch (x) { /* some embedded contexts forbid it */ }
        if (res.nextUrl && list.children.length < total) btn.setAttribute('href', res.nextUrl); else btn.hidden = true;
        if (first) {
          var f = first.querySelector('a[href], button') || first;
          if (f === first) first.setAttribute('tabindex', '-1');
          f.focus();
        }
        announce();
      }).catch(function () {
        if (err) err.hidden = false;
        btn.textContent = 'Try again'; status.textContent = '';
      }).then(function () {
        busy = false; list.removeAttribute('aria-busy'); btn.removeAttribute('aria-disabled');
        if (btn.textContent === 'Loading…') btn.textContent = label;
      });
    });
  }
  document.querySelectorAll('[data-load-more]').forEach(init);
})();
