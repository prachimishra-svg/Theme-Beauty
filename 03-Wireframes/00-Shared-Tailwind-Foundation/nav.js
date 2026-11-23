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
  var lastPointer = 'mouse';

  function linkOf(it) { return it.querySelector('[data-mega-link]'); }
  function panelOf(it) { return it.querySelector('[data-mega-panel]'); }

  function setOpen(it, open) {
    if (open) { items.forEach(function (o) { if (o !== it && o.hasAttribute('data-open')) setOpen(o, false); }); }
    if (open) { it.setAttribute('data-open', ''); panelOf(it).setAttribute('data-open', ''); }
    else { it.removeAttribute('data-open'); panelOf(it).removeAttribute('data-open'); }
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
    if (had && mq.matches) linkOf(openItem).focus();
  });
  document.addEventListener('click', function (e) {
    if (!mq.matches) return;
    if (!hdr.contains(e.target) || e.target.id === 'mega-scrim') closeAll();
  });

  var want = new URLSearchParams(location.search).get('mega');
  if (want) { items.forEach(function (it) { if (it.getAttribute('data-mega') === want) setOpen(it, true); }); }
})();


/* INTERACTIVE PROTOTYPE HOOK (the only change the interactive-website/ layer makes to the wireframes; see interactive-website/documentation/architecture.md).
   Dormant unless interactive mode is on: ?ix=1 in the URL, localStorage nudge.interactive=1 (set by interactive-website/index.html) or a window.name that starts with "nudge".
   Opened directly, every wireframe behaves exactly as before. In the Shopify theme this block is not copied. */
(function () {
  try {
    var on = /[?&]ix=1(&|$)/.test(location.search);
    if (on) { try { localStorage.setItem('nudge.interactive', '1'); } catch (e) { /* storage blocked */ } if (!window.name) window.name = 'nudge-ix'; }
    else { try { on = localStorage.getItem('nudge.interactive') === '1'; } catch (e2) { on = false; } if (!on && String(window.name).indexOf('nudge') === 0) on = true; }
    if (!on) return;
    var hs = document.getElementById('ix-hide-review') || document.createElement('style'); hs.id = 'ix-hide-review'; hs.textContent = '.rv,#wp,.ann,section[data-section="Custom Liquid Section"]{display:none!important}'; document.head.appendChild(hs); /* before first paint, so hiding the reviewer panel causes no layout shift */
    var me = document.currentScript || document.querySelector('script[src$="nav.js"]'); if (!me || !me.src) return;
    var s = document.createElement('script'); s.src = new URL('../../interactive-website/runtime/boot.js', me.src).href; document.head.appendChild(s);
  } catch (e3) { /* never break the page */ }
})();