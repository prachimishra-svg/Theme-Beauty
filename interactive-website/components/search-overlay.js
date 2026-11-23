/* NUDGE interactive website: search overlay.
   NOT IN THE APPROVED WIREFRAMES: the header only has a search link, there is no search panel or results page. This overlay is the smallest thing that makes the link work. It is built from
   existing tokens and classes only (input, price, type roles) and needs design sign-off before it is treated as part of the design. It searches PRODUCTS only (name, type, concern, skin type, ingredient, shade).
   States: empty (recent searches and suggestions), loading, results, no results, error-free. In Shopify: Predictive Search API for the panel and the /search template for the results page. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite, root = null, opener = null, tmr = null;
  var SUGGEST = ['Serum', 'Cleanser', 'Sunscreen', 'Dryness', 'Niacinamide'];
  function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); }
  function money(n) { return '$' + n.toFixed(2); }
  function build() {
    root = document.createElement('div'); root.id = 'ix-search'; root.hidden = true; root.style.zIndex = '2147482000';
    root.className = 'fixed inset-0 bg-scrim';
    root.innerHTML = '<div class="mx-auto mt-0 flex max-h-[100dvh] w-full max-w-[44rem] flex-col gap-4 overflow-hidden border border-line bg-page p-4 shadow-lg md:mt-12 md:max-h-[80vh] md:rounded-card md:p-6" role="dialog" aria-modal="true" aria-labelledby="ix-s-title">'
      + '<div class="flex items-center justify-between gap-4"><h2 class="type-h5 m-0" id="ix-s-title">Search</h2><button type="button" class="icon-btn" data-ix-close aria-label="Close search"><svg class="icon" aria-hidden="true" focusable="false"><use href="#icon-close"></use></svg></button></div>'
      + '<form role="search" class="flex gap-2" id="ix-s-form" novalidate><label class="sr-only" for="ix-s-q">Search products</label><input id="ix-s-q" name="q" type="search" autocomplete="off" placeholder="Search products" class="input min-h-touch flex-1 rounded-pill border border-line-strong bg-surface px-4 text-body"><button type="submit" class="btn btn-primary">Search</button></form>'
      + '<div id="ix-s-out" class="flex-1 overflow-y-auto" aria-live="polite"></div></div>';
    document.body.appendChild(root);
    root.addEventListener('click', function (e) {
      if (e.target === root || e.target.closest('[data-ix-close]')) { close(); return; }
      var s = e.target.closest('[data-ix-suggest]'); if (s) { setQuery(s.getAttribute('data-ix-suggest')); return; }
      if (e.target.closest('[data-ix-clear]')) { NS.searchState.clearRecent(); render(''); return; }
      var add = e.target.closest('[data-ix-add]');
      if (add) { var r = NS.cart.add(add.getAttribute('data-ix-add')); if (r.ok) { add.textContent = 'Added'; add.disabled = true; NS.notify('Added to your bag.', { kind: 'success', action: { label: 'View bag', fn: function () { close(); NS.cartDrawer.open(); } } }); } else NS.notify(r.reason === 'soldout' ? 'This product is sold out.' : 'This product cannot be added.', { kind: 'error' }); return; }
      var a = e.target.closest('a[data-ix-route]'); if (a) { e.preventDefault(); NS.searchState.remember(root.querySelector('#ix-s-q').value); NS.go(a.getAttribute('data-ix-route')); }
    });
    var q = root.querySelector('#ix-s-q'), f = root.querySelector('#ix-s-form');
    q.addEventListener('input', function () { run(q.value); });
    f.addEventListener('submit', function (e) { e.preventDefault(); var res = NS.products.search(q.value); NS.searchState.remember(q.value); if (res.length === 1) NS.go('/products/' + res[0].handle); else run(q.value, true); });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape' && !root.hidden) close(); if (e.key === 'Tab' && !root.hidden) trap(e); });
  }
  function trap(e) {
    var f = [].filter.call(root.querySelectorAll('button:not([disabled]),input,a[href]'), function (x) { return x.offsetParent !== null; }); if (!f.length) return;
    var first = f[0], last = f[f.length - 1];
    if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); } else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
  }
  function setQuery(v) { var q = root.querySelector('#ix-s-q'); q.value = v; q.focus(); run(v, true); }
  function run(v, now) {
    var out = root.querySelector('#ix-s-out'); clearTimeout(tmr);
    if (!String(v).trim()) { render(''); return; }
    out.innerHTML = '<p class="m-0 text-body-sm text-ink-secondary" data-ix-state="loading">Searching…</p>';
    tmr = setTimeout(function () { render(v); }, now ? 0 : 120); /* the short delay shows the loading state; Shopify's predictive search is a network call */
  }
  function row(p) {
    var price = '<span class="price"><span class="price-current">' + money(p.price) + '</span>' + (p.compare > p.price ? ' <s class="price-compare">' + money(p.compare) + '</s>' : '') + '</span>';
    return '<li class="grid grid-cols-[minmax(0,1fr)_auto] items-center gap-x-4 gap-y-1 border-t border-line py-3 first:border-t-0"><a class="min-w-0 text-inherit no-underline hover:underline" href="#pdp" data-ix-route="/products/' + p.handle + '"><span class="block font-heading text-body-lg leading-snug">' + esc(p.name) + '</span><span class="block text-body-sm text-ink-secondary">' + esc(p.type) + ' · ' + esc(p.size) + '</span></a><span class="flex items-center gap-3">' + price
      + (p.sold ? '<span class="text-body-sm text-ink-secondary">Sold out</span>' : '<button type="button" class="btn btn-secondary" data-ix-add="' + p.handle + '" aria-label="Add ' + esc(p.name) + ' to bag">Add</button>') + '</span></li>';
  }
  function render(v) {
    var out = root.querySelector('#ix-s-out'), q = String(v || '').trim();
    if (!q) {
      var rec = NS.searchState.recent(), h = '';
      if (rec.length) h += '<div class="mb-4" data-ix-state="empty"><p class="type-overline mb-2">Recent searches <button type="button" class="link ml-2" data-ix-clear>Clear</button></p><div class="chip-row">' + rec.map(function (r) { return '<button type="button" class="chip" data-ix-suggest="' + esc(r) + '">' + esc(r) + '</button>'; }).join('') + '</div></div>';
      h += '<div data-ix-state="empty"><p class="type-overline mb-2">Popular searches</p><div class="chip-row">' + SUGGEST.map(function (r) { return '<button type="button" class="chip" data-ix-suggest="' + r + '">' + r + '</button>'; }).join('') + '</div></div>';
      out.innerHTML = h; return;
    }
    var res = NS.products.search(q);
    if (!res.length) { out.innerHTML = '<div data-ix-state="none" class="flex flex-col gap-3 py-4"><p class="type-h5 m-0">No results for “' + esc(q) + '”</p><p class="m-0 text-ink-secondary">Check the spelling or try a product type, a concern or an ingredient.</p><div class="chip-row">' + SUGGEST.map(function (r) { return '<button type="button" class="chip" data-ix-suggest="' + r + '">' + r + '</button>'; }).join('') + '</div><a class="link" href="#shop" data-ix-route="/collections/all">Browse all products</a></div>'; return; }
    out.innerHTML = '<p class="m-0 mb-2 text-body-sm text-ink-secondary" data-ix-state="results">' + res.length + (res.length === 1 ? ' product' : ' products') + '</p><ul class="m-0 list-none p-0">' + res.slice(0, 8).map(row).join('') + '</ul>' + (res.length > 8 ? '<p class="mt-2 text-body-sm text-ink-secondary">Showing 8 of ' + res.length + '. Add more words to narrow the results.</p>' : '');
  }
  function open(q, from) {
    if (NS.cartDrawer && NS.cartDrawer.isOpen()) NS.cartDrawer.close(); /* one overlay at a time */ if (!root) build(); opener = from || document.activeElement; root.hidden = false; document.documentElement.classList.add('ix-lock'); document.body.style.overflow = 'hidden';
    var i = root.querySelector('#ix-s-q'); i.value = q || NS.searchState.query() || ''; i.focus(); run(i.value, true); NS.log.opened.push('search');
  }
  function close() { if (!root || root.hidden) return; root.hidden = true; document.body.style.overflow = ''; document.documentElement.classList.remove('ix-lock'); if (opener && opener.focus) try { opener.focus(); } catch (e) { /* gone */ } }
  NS.searchOverlay = { prepare: function () { if (!root) build(); }, open: open, close: close, isOpen: function () { return !!root && !root.hidden; } };
})(window);
