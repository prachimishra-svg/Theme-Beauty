/* NUDGE market and currency selector (wireframe behaviour). Loaded by every page through the shared head partial.
   It extends the one existing control in the header (the "India (INR)" pill, #market-btn): the pill opens a small list of markets, the choice is
   remembered, and every price on the page is shown in the chosen currency through one shared formatter. No second selector is created.

   In the Shopify theme this is native: the list is the {% form 'localization' %} country form (Shopify Markets), prices are written with
   {{ price | money }} and Shopify converts and rounds them. Here the sample prices in the files are base amounts written as "$nn.nn" and are
   converted with the sample rates below, which exist only so the wireframe can show the behaviour. Nothing in a page is written with a currency
   symbol other than the base "$"; every other symbol comes from Intl.NumberFormat.

   Query overrides for review and tests: ?cur=INR|USD|GBP|EUR, and ?market=open to show the menu open. A page opened for the in-page self-test starts on USD so its checks read the base text. */
(function () {
  'use strict';
  var MARKETS = [
    { code: 'IN', name: 'India', cur: 'INR', loc: 'en-IN', rate: 83, dec: 0 },
    { code: 'US', name: 'US', cur: 'USD', loc: 'en-US', rate: 1, dec: 2 },
    { code: 'GB', name: 'UK', cur: 'GBP', loc: 'en-GB', rate: 0.79, dec: 2 },
    { code: 'EU', name: 'EU', cur: 'EUR', loc: 'en-IE', rate: 0.92, dec: 2 }
  ];
  var KEY = 'nudge-market';
  var ONE = /\$\s?(\d[\d,]*)(?:\.(\d{1,2}))?/;
  var ALL = /\$\s?(\d[\d,]*)(?:\.(\d{1,2}))?/g;
  var SKIPTAG = { SCRIPT: 1, STYLE: 1, NOSCRIPT: 1, TEXTAREA: 1, INPUT: 1, SELECT: 1, PRE: 1 };
  var q = new URLSearchParams(location.search);
  function find(c) { c = (c || '').toUpperCase(); return MARKETS.filter(function (m) { return m.cur === c || m.code === c; })[0]; }
  function stored() { try { return localStorage.getItem(KEY); } catch (e) { return null; } }
  function save(v) { try { localStorage.setItem(KEY, v); } catch (e) { /* storage can be blocked; the choice then lasts for the page only */ } }
  var cur = find(q.get('cur')) || (q.get('selftest') ? find('USD') : null) || find(stored()) || MARKETS[0];
  var seen = new Map();   // text node -> { base: original text with $ amounts, out: the text currently shown }

  function fmt(v, m, whole) {
    var d = whole ? 0 : m.dec;
    return new Intl.NumberFormat(m.loc, { style: 'currency', currency: m.cur, minimumFractionDigits: d, maximumFractionDigits: d }).format(v);
  }
  /* Amounts written without cents (thresholds such as "$50") are rounded to whole units so they stay tidy; amounts with cents keep the currency's own decimals. */
  function convert(s, m) {
    return s.replace(ALL, function (all, a, b) {
      if (m.rate === 1) return all;
      var v = parseFloat(a.replace(/,/g, '') + (b ? '.' + b : '')) * m.rate, whole = !b;
      if (whole) v = Math.round(v);
      return fmt(v, m, whole || m.dec === 0);
    });
  }
  function skipped(n) {
    for (var e = n.parentNode; e && e.nodeType === 1; e = e.parentNode) {
      if (SKIPTAG[e.nodeName] || (e.classList && (e.classList.contains('rv') || e.classList.contains('ann'))) || e.hasAttribute('data-no-currency')) return true;
    }
    return false;
  }
  function handle(n) {
    var info = seen.get(n), v = n.nodeValue, base;
    if (info && v === info.out) base = info.base;
    else if (ONE.test(v) && !skipped(n)) base = v;
    else { if (info) seen.delete(n); return; }
    var out = convert(base, cur);
    seen.set(n, { base: base, out: out });
    if (v !== out) n.nodeValue = out;
  }
  function walk(root) {
    if (root.nodeType === 3) { handle(root); return; }
    var w = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null), list = [], n;
    while ((n = w.nextNode())) list.push(n);
    list.forEach(handle);
  }

  var mo = new MutationObserver(function (ms) {
    ms.forEach(function (m) {
      if (m.type === 'characterData') handle(m.target);
      else m.addedNodes.forEach(function (n) { if (n.nodeType === 3 || n.nodeType === 1) walk(n); });
    });
  });

  function $(id) { return document.getElementById(id); }
  function symbol(m) {
    var parts = new Intl.NumberFormat(m.loc, { style: 'currency', currency: m.cur }).formatToParts(0);
    for (var i = 0; i < parts.length; i++) if (parts[i].type === 'currency') return parts[i].value;
    return m.cur;
  }
  function label(m) { return m.cur + ' ' + symbol(m); }   /* compact header label, for example INR ₹; the list rows keep the short country names */
  function nameFor(m) { return 'Country and currency: ' + m.cur + ' ' + symbol(m) + ' (' + m.name + ')'; }
  function build() {
    var menu = $('market-menu'); if (!menu) return;
    menu.innerHTML = MARKETS.map(function (m) {
      var on = m === cur;
      return '<button type="button" class="flex min-h-touch w-full items-center justify-between gap-5 rounded-control px-3 text-left text-body-sm text-ink hover:bg-subtle' + (on ? ' font-medium' : '') + '" style="cursor:pointer;touch-action:manipulation;-webkit-tap-highlight-color:transparent" data-market="' + m.code + '"' + (on ? ' aria-current="true"' : '') + '>' +
        '<span>' + m.name + ' <span class="font-regular text-ink-secondary">(' + m.cur + ' ' + symbol(m) + ')</span></span>' +
        (on ? '<svg class="icon size-5 text-brand" aria-hidden="true" focusable="false"><use href="#icon-check"></use></svg>' : '') + '</button>';
    }).join('') +
      '<span class="sr-only" role="status" id="market-status"></span>';
  }
  /* Open and close with a short fade and lift (170ms; none when the visitor prefers reduced motion). The menu stays in the page (hidden is
     removed before the fade-in and set again after the fade-out), so it never flickers, and a second click during the fade just reverses it. */
  var FADE = 170, fadeTimer = 0;
  function reduced() { return !!(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches); }
  function isOpen() { var b = $('market-btn'); return !!b && b.getAttribute('aria-expanded') === 'true'; }
  function items() { var m = $('market-menu'); return m ? [].slice.call(m.querySelectorAll('[data-market]')) : []; }
  function focusItem(el) { if (el) { try { el.focus({ preventScroll: true }); } catch (e) { el.focus(); } } }
  function open(o, focus) {
    var btn = $('market-btn'), menu = $('market-menu'); if (!btn || !menu || o === isOpen()) return;
    clearTimeout(fadeTimer);
    var d = reduced() ? 0 : FADE, s = menu.style;
    btn.setAttribute('aria-expanded', o ? 'true' : 'false');
    s.transition = d ? 'opacity ' + d + 'ms ease, transform ' + d + 'ms ease' : 'none';
    if (o) {
      menu.hidden = false;
      s.opacity = '0'; s.transform = 'translateY(-4px)'; s.pointerEvents = '';
      /* a long list scrolls inside the menu (smoothly, and it never scrolls the page behind it) */
      s.overflowY = 'auto'; s.overscrollBehavior = 'contain'; s.webkitOverflowScrolling = 'touch'; s.scrollBehavior = 'smooth';
      s.maxHeight = Math.max(144, Math.min(320, window.innerHeight - menu.getBoundingClientRect().top - 16)) + 'px';
      void menu.offsetWidth;
      s.opacity = '1'; s.transform = 'none';
      if (focus) focusItem(menu.querySelector('[aria-current]') || menu.querySelector('[data-market]'));
    } else {
      s.opacity = '0'; s.transform = 'translateY(-4px)'; s.pointerEvents = 'none';
      fadeTimer = setTimeout(function () { menu.hidden = true; s.pointerEvents = ''; }, d);
    }
  }
  function set(m, silent) {
    cur = m; save(m.code);
    document.documentElement.setAttribute('data-currency', m.cur);
    var l = $('market-label'); if (l) l.textContent = label(m); var bt = $('market-btn'); if (bt) bt.setAttribute('aria-label', nameFor(m));
    build(); walk(document.body);
    var s = $('market-status'); if (s && !silent) s.textContent = 'Showing prices in ' + m.cur + '.';
    document.dispatchEvent(new CustomEvent('nudge:currency', { detail: { currency: m.cur } }));
  }
  function init() {
    var btn = $('market-btn'), menu = $('market-menu'), box = $('market');
    document.documentElement.setAttribute('data-currency', cur.cur);
    var l = $('market-label'); if (l) l.textContent = label(cur); var bt0 = $('market-btn'); if (bt0) bt0.setAttribute('aria-label', nameFor(cur));
    build(); walk(document.body);
    mo.observe(document.body, { childList: true, subtree: true, characterData: true });
    if (!btn || !menu || !box) return;
    /* the control opens and closes only from its own button, a choice, Escape, Tab or a press outside it */
    btn.addEventListener('click', function (e) { open(!isOpen(), e.detail === 0); });
    if (q.get('market') === 'open') open(true);
    menu.addEventListener('click', function (e) {
      var b = e.target.closest ? e.target.closest('[data-market]') : null; if (!b) return;
      var m = find(b.getAttribute('data-market')); if (!m) return;
      if (m !== cur) set(m);
      open(false); focusItem(btn);
    });
    /* pointerdown covers mouse, pen and touch before any click, so an outside press closes the menu at once and a press inside never does */
    document.addEventListener('pointerdown', function (e) { if (isOpen() && !box.contains(e.target)) open(false); }, true);
    document.addEventListener('keydown', function (e) {
      if (e.target === btn && (e.key === 'ArrowDown' || e.key === 'ArrowUp') && !isOpen()) { e.preventDefault(); open(true, true); return; }
      if (!isOpen()) return;
      if (e.key === 'Escape') { e.preventDefault(); open(false); focusItem(btn); return; }
      if (e.key === 'Tab') { open(false); return; }
      var list = items(), i = list.indexOf(document.activeElement);
      if (e.key === 'ArrowDown' || e.key === 'ArrowUp') { e.preventDefault(); focusItem(list[(i + (e.key === 'ArrowDown' ? 1 : -1) + list.length) % list.length]); }
      else if (e.key === 'Home') { e.preventDefault(); focusItem(list[0]); }
      else if (e.key === 'End') { e.preventDefault(); focusItem(list[list.length - 1]); }
      else if (e.key.length === 1 && /\S/.test(e.key)) {
        var c = e.key.toLowerCase(), n = list.length, k;
        for (k = 1; k <= n; k++) { var it = list[(i + k + n) % n]; if (it.textContent.trim().toLowerCase().charAt(0) === c) { focusItem(it); break; } }
      }
    });
  }
  window.NudgeMarket = { set: function (c) { var m = find(c); if (m) set(m, true); }, current: function () { return cur.cur; }, markets: MARKETS };
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();
})();