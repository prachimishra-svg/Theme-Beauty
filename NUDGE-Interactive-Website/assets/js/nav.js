/* N-U-D-G-E Beauty: mega menu behaviour (shared by every page through the head partial).
   Desktop (1024 and up): hover, keyboard focus or tap opens a full-width panel under the header; Escape, outside click or leaving closes it.
   Below 1024: the same markup is an accordion inside the slide-in drawer (one section open at a time).
   The drawer itself (menu button, Close, scrim, Escape) is opened by each page's own script; this file only handles the sections.
   Markup contract (partials/header.html): [data-mega=key] item > [data-mega-link] link + [data-mega-panel] panel.
   Review helper: ?mega=skin|makeup|hair|body opens that section on load. */
(function () {
  var hdr = document.getElementById('site-header');
  if (!hdr) return;
  var items = [].slice.call(hdr.querySelectorAll('[data-mega]'));
  if (!items.length) return;
  var mq = window.matchMedia('(min-width:1024px)');
  var lastPointer = 'mouse', quiet = false;

  function linkOf(it) { return it.querySelector('[data-mega-link]'); }
  function panelOf(it) { return it.querySelector('[data-mega-panel]'); }

  function setOpen(it, open) {
    if (open) { items.forEach(function (o) { if (o !== it && o.hasAttribute('data-open')) setOpen(o, false); }); }
    var pn = panelOf(it);
    if (open) { clearTimeout(pn.__ct); pn.removeAttribute('data-closing'); it.setAttribute('data-open', ''); pn.setAttribute('data-open', ''); }
    else {
      var was = it.hasAttribute('data-open'); it.removeAttribute('data-open'); pn.removeAttribute('data-open');
      /* desktop: the panel fades out (about 160 ms) instead of vanishing; skipped for reduced motion */
      if (was && mq.matches && !(window.matchMedia && window.matchMedia('(prefers-reduced-motion:reduce)').matches)) { pn.setAttribute('data-closing', ''); clearTimeout(pn.__ct); pn.__ct = setTimeout(function () { pn.removeAttribute('data-closing'); }, 170); }
    }
    linkOf(it).setAttribute('aria-expanded', open ? 'true' : 'false');
    var any = items.some(function (o) { return o.hasAttribute('data-open'); });
    var on = any && mq.matches;
    hdr.classList.toggle('mega-open', on);
    document.body.classList.toggle('mega-open', on);
  }
  function closeAll() { items.forEach(function (o) { if (o.hasAttribute('data-open')) setOpen(o, false); }); }

  /* below 1024 the link row is a disclosure button (the "Shop all" link inside the panel does the navigating) */
  function roles() {
    items.forEach(function (it) {
      var a = linkOf(it);
      if (mq.matches) { a.removeAttribute('role'); } else { a.setAttribute('role', 'button'); }
    });
  }
  roles();
  var onMq = function () { closeAll(); roles(); };
  if (mq.addEventListener) { mq.addEventListener('change', onMq); } else { mq.addListener(onMq); }

  document.addEventListener('pointerdown', function (e) { lastPointer = e.pointerType || 'mouse'; }, true);

  items.forEach(function (it) {
    var a = linkOf(it), openTimer = null, closeTimer = null; /* per item, so a quick leave/enter between items cannot cancel the wrong timer */

    it.addEventListener('pointerenter', function (e) {
      if (!mq.matches || e.pointerType === 'touch') return;
      clearTimeout(closeTimer);
      openTimer = setTimeout(function () { setOpen(it, true); }, 80);
    });
    it.addEventListener('pointerleave', function (e) {
      if (!mq.matches || e.pointerType === 'touch') return;
      clearTimeout(openTimer);
      closeTimer = setTimeout(function () { setOpen(it, false); }, 200);
    });

    a.addEventListener('click', function (e) {
      var open = it.hasAttribute('data-open');
      if (!mq.matches) { e.preventDefault(); setOpen(it, !open); return; }
      /* touch laptops/tablets: the first tap opens the panel, the second follows the link */
      if (lastPointer === 'touch' && !open) { e.preventDefault(); setOpen(it, true); }
    });
    a.addEventListener('keydown', function (e) {
      if (!mq.matches && (e.key === ' ' || e.key === 'Spacebar')) { e.preventDefault(); a.click(); }
      if (mq.matches && e.key === 'ArrowDown') {
        e.preventDefault(); setOpen(it, true);
        var first = panelOf(it).querySelector('a'); if (first) first.focus();
      }
    });

    it.addEventListener('focusin', function () {
      if (quiet) return; /* focus handed back to the link by Escape must not reopen the panel */
      if (mq.matches && lastPointer !== 'touch') { clearTimeout(closeTimer); setOpen(it, true); }
    });
    it.addEventListener('focusout', function (e) {
      if (!mq.matches) return;
      var to = e.relatedTarget;
      if (to && it.contains(to)) return;
      if (!to) return; /* window blur or click on non-focusable area: the outside-click handler decides */
      setOpen(it, false);
    });
  });

  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape' && e.keyCode !== 27) return;
    var openItem = items.filter(function (o) { return o.hasAttribute('data-open'); })[0];
    if (!openItem) return;
    var had = openItem.contains(document.activeElement);
    closeAll();
    if (had && mq.matches) { quiet = true; linkOf(openItem).focus(); quiet = false; }
  });
  document.addEventListener('click', function (e) {
    if (!mq.matches) return;
    if (!hdr.contains(e.target) || e.target.id === 'mega-scrim') closeAll();
  });

  var want = new URLSearchParams(location.search).get('mega');
  if (want) { items.forEach(function (it) { if (it.getAttribute('data-mega') === want) setOpen(it, true); }); }
})();


/* INTERACTIVE WEBSITE: the interactive layer is ON by default. Add ?ix=0 to a page address to see it as the plain wireframe. Loads interactive/boot.js. */
(function () {
  try {
    if (/[?&]ix=0(&|$)/.test(location.search)) return;
    var me = document.currentScript || document.querySelector('script[src$="nav.js"]'); if (!me || !me.src) return;
    var s = document.createElement('script'); s.src = new URL('interactive/boot.js', me.src).href; document.head.appendChild(s);
  } catch (e) { /* never break the page */ }
})();