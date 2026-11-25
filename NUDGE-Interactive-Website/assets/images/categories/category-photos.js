/* NUDGE "Shop by category" photographs for the interactive website. Plain script, no library; every path is relative to this file, so the folder works when it is shared, opened offline, or published.
   The cards are matched by position: 1 Skin care, 2 Makeup, 3 Hair, 4 Body.
   Each card gets a <picture>: the wide-tile picture from 768 px, the small-tile picture below 768 px, so the browser downloads only one of them.
   If a file is missing the card keeps its placeholder, nothing breaks. The high-fidelity site has its own photo layer, so this script steps aside there. */
(function () {
  'use strict';
  var cs = document.currentScript, BASE = cs && cs.getAttribute('src') ? cs.getAttribute('src').replace(/[^\/]*$/, '') : 'assets/images/categories/';   /* the folder of this script exactly as the page wrote it (relative), so the pictures follow the folder wherever it is opened */
  var MAP = [
    { name: 'skin-care', wide: 'skin-care.jpg', small: 'skin-care-mobile.jpg' },
    { name: 'makeup', wide: 'makeup.jpg', small: 'makeup-mobile.jpg' },
    { name: 'hair', wide: 'hair.jpg', small: 'hair.jpg' },
    { name: 'body', wide: 'body.jpg', small: 'body-mobile.jpg' }
  ];
  var CSS = '.cat-pic{display:contents}.cat-photo{position:absolute;inset:0;z-index:1;width:100%;height:100%;object-fit:cover;object-position:50% 40%}'
    + '.img.has-cat-photo .in{display:none}'
    + '.cat-photo[data-cat="hair"]{object-position:72% 50%}.cat-photo[data-cat="body"]{object-position:88% 50%}'
    + '@media (min-width:768px){.cat-photo[data-cat="makeup"]{object-position:100% 50%}.cat-photo[data-cat="hair"]{object-position:28% 50%}.cat-photo[data-cat="body"]{object-position:50% 50%}}'
    + '@media (min-width:1024px){.cat-photo[data-cat="hair"]{object-position:0% 50%}}';
  function place() {
    if (document.querySelector('script[src*="hifi/hifi.js"]')) return;
    if (!document.getElementById('cat-photo-css')) { var st = document.createElement('style'); st.id = 'cat-photo-css'; st.textContent = CSS; document.head.appendChild(st); }
    var tiles = document.querySelectorAll('[data-section="Shop by Category"] .g--cat > a');
    MAP.forEach(function (m, i) {
      var a = tiles[i], box = a && a.querySelector('.img'); if (!box || box.querySelector('.cat-pic')) return;
      var pic = document.createElement('picture'), so = document.createElement('source'), im = document.createElement('img');
      pic.className = 'cat-pic'; so.media = '(max-width:767px)'; so.srcset = BASE + m.small; im.className = 'cat-photo'; im.setAttribute('data-cat', m.name); im.alt = ''; im.decoding = 'async'; im.loading = 'lazy'; im.src = BASE + m.wide;
      im.onload = function () { box.classList.add('has-cat-photo'); };
      im.onerror = function () { pic.remove(); box.classList.remove('has-cat-photo'); };
      pic.appendChild(so); pic.appendChild(im); box.insertBefore(pic, box.firstChild);
    });
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', place); else place();
})();
