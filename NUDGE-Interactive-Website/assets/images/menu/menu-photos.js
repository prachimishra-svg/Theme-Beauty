/* NUDGE desktop mega menu: real photographs in the two cards of every menu (Skin, Makeup, Hair, Body). Plain script; every path is relative to this file, so the folder works shared, offline or published.
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
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', place); else place();
})();
