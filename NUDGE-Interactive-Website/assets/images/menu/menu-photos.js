/* NUDGE menus: real photographs in the two cards of every desktop mega menu (Skin, Makeup, Hair, Body), in the four collection tiles of the mobile menu drawer, and the drawer's search field (it opens the site search). Plain script; every path is relative to this file, so the folder works shared, offline or published.
   The cards are matched by menu and position (first card, second card). The pictures are crops of the approved campaign and category photographs, 3:2, with the card title and "Shop now" link underneath as before.
   If a file is missing the card keeps its placeholder. In Shopify these are the image pickers of the two promo blocks in the mega menu. */
(function () {
  'use strict';
  var cs = document.currentScript, BASE = cs && cs.getAttribute('src') ? cs.getAttribute('src').replace(/[^\/]*$/, '') : 'assets/images/menu/';
  var MAP = { skin: ['skin-1.jpg', 'skin-2.jpg'], makeup: ['makeup-1.jpg', 'makeup-2.jpg'], hair: ['hair-1.jpg', 'hair-2.jpg'], body: ['body-1.jpg', 'body-2.jpg'] };
  var POS = { 'skin-2.jpg': '80% 50%', 'makeup-1.jpg': '100% 50%', 'hair-2.jpg': '60% 50%' };
  var CSS = '.mega-photo{position:absolute;inset:0;z-index:1;width:100%;height:100%;object-fit:cover;object-position:var(--mp,50% 50%);transition:transform var(--duration-slow,400ms) var(--ease-standard,ease)}'
    + '.mega-has-photo>span{display:none}a:hover>.mega-has-photo .mega-photo,a:focus-visible>.mega-has-photo .mega-photo{transform:scale(1.03)}'
    + '@media (prefers-reduced-motion:reduce){.mega-photo{transition:none}}';
  function place() {
    if (!document.getElementById('mega-photo-css')) { var st = document.createElement('style'); st.id = 'mega-photo-css'; st.textContent = CSS; document.head.appendChild(st); }
    [].forEach.call(document.querySelectorAll('[data-mega-panel]'), function (panel) {
      var key = (panel.id || '').replace(/^mega-/, ''), files = MAP[key]; if (!files) return;
      [].forEach.call(panel.querySelectorAll('[class*="grid-cols-2"] > a'), function (a, i) {
        var box = a.firstElementChild, f = files[i]; if (!box || !f || box.querySelector('.mega-photo')) return;
        var im = document.createElement('img'); im.className = 'mega-photo'; im.alt = ''; im.decoding = 'async'; im.loading = 'lazy'; im.src = BASE + f; if (POS[f]) im.style.setProperty('--mp', POS[f]);
        im.onload = function () { box.classList.add('mega-has-photo'); }; im.onerror = function () { im.remove(); box.classList.remove('mega-has-photo'); };
        box.insertBefore(im, box.firstChild);
      });
    });
    /* mobile drawer: the four collection tiles */
    var TILE = { skin: ['skin-1.jpg', '50% 50%'], makeup: ['makeup-1.jpg', '100% 50%'], hair: ['hair-1.jpg', '70% 50%'], body: ['body-1.jpg', '70% 50%'] };
    [].forEach.call(document.querySelectorAll('[data-nav-tile]'), function (a) {
      var spec = TILE[a.getAttribute('data-nav-tile')], box = a.firstElementChild; if (!spec || !box || box.querySelector('.mega-photo')) return;
      var im = document.createElement('img'); im.className = 'mega-photo'; im.alt = ''; im.decoding = 'async'; im.loading = 'lazy'; im.src = BASE + spec[0]; im.style.setProperty('--mp', spec[1]);
      im.onerror = function () { im.remove(); }; box.insertBefore(im, box.firstChild);
    });
    /* mobile drawer: the search field closes the drawer and opens the site search with what was typed */
    [].forEach.call(document.querySelectorAll('[data-nav-search]'), function (form) {
      if (form.__ixs) return; form.__ixs = 1;
      form.addEventListener('submit', function (e) {
        e.preventDefault(); var q = (form.querySelector('input') || {}).value || '', NS = window.NudgeSite, close = document.getElementById('nav-close');
        if (close) close.click();
        window.setTimeout(function () {
          if (NS && NS.searchOverlay && NS.searchOverlay.open) NS.searchOverlay.open(q.trim());
          else { var ic = document.querySelector('#site-header a[role="search"]'); if (ic) ic.click(); }
        }, 260);
      });
    });
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', place); else place();
})();
