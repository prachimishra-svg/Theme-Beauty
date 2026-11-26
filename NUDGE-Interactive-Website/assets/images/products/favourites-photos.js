/* NUDGE "Shop our favourites": product photographs per tab. Best sellers: Gentle Cleanser, Radiance Serum, Lip Colour. New launches: Sunscreen, Eye Cream, Mascara, Hair Oil. Sets: Starter Set, Gift Set, Travel Set (the Makeup Set has no photograph yet and keeps its placeholder).
   800 x 1000 (4:5), the same file on every screen, relative paths (the folder works shared, offline or published). The cards are matched by their title. The tabs reuse the same four cards with other products, so each tab has its own list and a picture is shown only on its own tab.
   A missing file leaves the placeholder. In Shopify these are the product featured images of the Best sellers collection. */
(function () {
  'use strict';
  var cs = document.currentScript, BASE = cs && cs.getAttribute('src') ? cs.getAttribute('src').replace(/[^\/]*$/, '') : 'assets/images/products/';
  var MAP = [ { 'gentle cleanser': 'gentle-cleanser.jpg', 'radiance serum': 'radiance-serum.jpg', 'lip colour': 'lip-colour.jpg', 'repair cream': 'repair-cream.jpg' }, { 'sunscreen': 'sunscreen.jpg', 'eye cream': 'eye-cream.jpg', 'mascara': 'mascara.jpg', 'hair oil': 'hair-oil.jpg' }, { 'starter set': 'starter-set.jpg', 'gift set': 'gift-set.jpg', 'travel set': 'travel-set.jpg' } ];   /* per tab: 0 Best sellers, 1 New launches, 2 Sets */
  var CSS = '.fav-photo{position:absolute;inset:0;z-index:1;width:100%;height:100%;object-fit:cover}.img.has-fav-photo .in{display:none}';
  function tabOf(sec) { var on = sec.querySelector('.tab.on,.tab[aria-selected="true"]'); return on ? (parseInt(on.getAttribute('data-set'), 10) || 0) : 0; }
  function sync() {
    var sec = document.querySelector('[data-section^="Featured Collection"]'); if (!sec) return;
    if (!document.getElementById('fav-photo-css')) { var st = document.createElement('style'); st.id = 'fav-photo-css'; st.textContent = CSS; document.head.appendChild(st); }
    var map = MAP[tabOf(sec)] || {};
    [].forEach.call(sec.querySelectorAll('#prod-grid .card'), function (card) {
      var box = card.querySelector('.card__img .img'), t = card.querySelector('.ptitle'); if (!box || !t) return;
      var file = map[t.textContent.replace(/\s+/g, ' ').trim().toLowerCase()], im = box.querySelector('.fav-photo');
      if (!file) { if (im) im.remove(); box.classList.remove('has-fav-photo'); return; }
      if (im && im.getAttribute('data-f') === file) return; if (im) im.remove();
      im = document.createElement('img'); im.className = 'fav-photo'; im.setAttribute('data-f', file); im.alt = ''; im.decoding = 'async'; im.loading = 'lazy'; im.src = BASE + file;
      im.onload = function () { box.classList.add('has-fav-photo'); }; im.onerror = function () { im.remove(); box.classList.remove('has-fav-photo'); };
      box.insertBefore(im, box.firstChild);
    });
  }
  function init() { sync(); [].forEach.call(document.querySelectorAll('.tab'), function (t) { t.addEventListener('click', function () { setTimeout(sync, 0); setTimeout(sync, 120); }); }); }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();
})();