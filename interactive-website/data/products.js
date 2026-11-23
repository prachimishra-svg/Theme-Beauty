/* NUDGE interactive website: product catalogue.
   Built from sample data that ALREADY exists in the wireframes: the 24 PLP products (data/plp-raw.js, copied from the PLP's own data), the cart wireframe's catalogue
   (Body Lotion, Hand Cream, Setting Mist, Lip Balm, Travel Cleanser), the Homepage (Lip Colour) and the Shop the Look rows (Foundation, Blush). Prices come from those pages.
   The collection group of each extra product (makeup, body ...) is a prototype assumption, listed in documentation/missing-pages-and-interactions.md. In Shopify this is the product object. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite, D = NS.data;
  function slug(s) { return String(s).toLowerCase().replace(/&/g, 'and').replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, ''); }
  var F = D.shadeFamilies, list = [];
  D.plpRaw.forEach(function (r, i) {
    list.push({ handle: slug(r[0]), name: r[0], type: r[1], ml: r[2], size: r[2] + ' ml', price: r[3], compare: r[4], concerns: r[5], skin: r[6], attr: r[7], badge: r[8], rating: r[9], reviews: r[10], shades: r[11].map(function (k) { return F[k][0]; }), low: r[12], sold: !!r[13], ingredients: r[15], group: 'skin', source: 'PLP', order: i });
  });
  [
    { name: 'Lip Colour', type: 'Lip colour', size: '3.5 g', price: 16, group: 'makeup', source: 'Homepage featured collection', badge: 'New' },
    { name: 'Foundation', type: 'Foundation', size: '30 ml', price: 30, group: 'makeup', source: 'Homepage Shop the Look' },
    { name: 'Blush', type: 'Blush', size: '5 g', price: 20, group: 'makeup', source: 'Homepage Shop the Look' },
    { name: 'Setting Mist', type: 'Setting mist', size: '100 ml', price: 22, group: 'makeup', source: 'Cart wireframe catalogue' },
    { name: 'Lip Balm', type: 'Lip care', size: 'Rose', price: 12, group: 'makeup', source: 'Cart wireframe catalogue' },
    { name: 'Body Lotion', type: 'Body lotion', size: '200 ml', price: 24, group: 'body', source: 'Cart wireframe catalogue' },
    { name: 'Hand Cream', type: 'Hand and foot care', size: '50 ml', price: 14, group: 'body', source: 'Cart wireframe catalogue' },
    { name: 'Travel Cleanser', type: 'Cleanser', size: '50 ml', price: 9, group: 'skin', source: 'Cart wireframe catalogue' }
  ].forEach(function (p) { p.handle = slug(p.name); p.compare = 0; p.concerns = []; p.skin = []; p.attr = p.attr || ''; p.rating = 0; p.reviews = 0; p.shades = []; p.low = 0; p.sold = false; p.ingredients = []; p.ml = parseInt(p.size, 10) || 0; list.push(p); });
  var by = {}; list.forEach(function (p) { by[p.handle] = p; });
  /* the cart wireframe uses short ids; these are the same products */
  var CART_ID = { 'tinted-moisturiser': 'tm', 'face-serum': 'sr', 'face-cleanser': 'cl', 'daily-sunscreen': 'sp', 'eye-cream': 'ey', 'body-lotion': 'bl', 'hand-cream': 'hc', 'setting-mist': 'mk', 'lip-balm': 'lb', 'travel-cleanser': 'tc' };
  var ALIAS = { 'sunscreen': 'daily-sunscreen', 'moisturizer': 'moisturiser' };
  function find(name) { var h = slug(String(name).replace(/\s*\(.*$/, '')); return by[h] || by[ALIAS[h]] || null; }
  function search(q) {
    var t = String(q || '').toLowerCase().split(/\s+/).filter(Boolean); if (!t.length) return [];
    var res = [];
    list.forEach(function (p) {
      var name = p.name.toLowerCase(), meta = [p.type, p.attr, p.concerns.join(' '), p.skin.join(' '), p.ingredients.join(' '), p.shades.join(' '), p.group].join(' ').toLowerCase(), score = 0, ok = true;
      t.forEach(function (w) { var s = 0; if (name.indexOf(w) === 0) s = 5; else if (name.indexOf(' ' + w) > -1) s = 4; else if (name.indexOf(w) > -1) s = 3; else if (meta.indexOf(w) > -1) s = 1; if (!s) ok = false; score += s; });
      if (ok) res.push({ p: p, score: score });
    });
    res.sort(function (a, b) { return b.score - a.score || a.p.order - b.p.order; });
    return res.map(function (r) { return r.p; });
  }
  NS.products = { all: list, byHandle: function (h) { return by[h] || null; }, find: find, search: search, slug: slug, cartId: function (h) { return CART_ID[h] || ''; }, CART_ID: CART_ID };
})(window);
