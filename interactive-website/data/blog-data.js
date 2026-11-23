/* NUDGE interactive website: journal articles.
   Titles are the sample titles in the Blog listing wireframe. The TAG assignment and the RELATED PRODUCTS of each article are prototype assumptions (the wireframes show tag links but no
   mapping); they are listed in documentation/missing-pages-and-interactions.md. In Shopify: blog "journal", article.handle, article.tags, and a product metafield list for related products. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  var TAGS = ['Skincare', 'Routines', 'Ingredients', 'Makeup', 'Hair and body'];
  var A = [
    ['A simple morning skincare routine', ['Skincare', 'Routines'], ['face-cleanser', 'face-serum', 'daily-sunscreen']],
    ['How to layer your skincare', ['Skincare', 'Routines'], ['face-serum', 'moisturiser', 'daily-sunscreen']],
    ['A simple evening routine', ['Routines', 'Skincare'], ['cream-cleanser', 'hydrating-serum', 'barrier-cream']],
    ['What is niacinamide?', ['Ingredients', 'Skincare'], ['face-serum', 'brightening-serum']],
    ['Skin prep before makeup', ['Makeup', 'Skincare'], ['tinted-moisturiser', 'foundation', 'blush']],
    ['Caring for dry skin on the body', ['Hair and body', 'Skincare'], ['body-lotion', 'hand-cream']],
    ['Sunscreen basics, explained', ['Skincare', 'Ingredients'], ['daily-sunscreen', 'mineral-sunscreen', 'tinted-sunscreen']],
    ['Building a routine for sensitive skin', ['Routines', 'Skincare'], ['calming-serum', 'barrier-cream', 'gel-cleanser']],
    ['A guide to common cleansing ingredients', ['Ingredients'], ['face-cleanser', 'foaming-cleanser', 'balm-cleanser']],
    ['Seasonal skin changes', ['Skincare', 'Routines'], ['hydrating-serum', 'eye-cream', 'lip-balm']]
  ];
  function slug(s) { return String(s).toLowerCase().replace(/&/g, 'and').replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, ''); }
  var list = A.map(function (a, i) { return { handle: slug(a[0]), title: a[0], tags: a[1], related: a[2], order: i }; });
  var by = {}; list.forEach(function (a) { by[a.handle] = a; });
  var byTitle = {}; list.forEach(function (a) { byTitle[a.title.toLowerCase()] = a; });
  NS.blog = {
    articles: list, tags: TAGS, slug: slug,
    get: function (h) { return by[h] || null; },
    byTitle: function (t) { return byTitle[String(t || '').replace(/^\[?Sample title:\s*/i, '').replace(/\]$/, '').trim().toLowerCase()] || null; },
    tagFromText: function (t) { var s = slug(t); for (var i = 0; i < TAGS.length; i++) if (slug(TAGS[i]) === s) return TAGS[i]; return null; },
    withTag: function (tag) { return list.filter(function (a) { return a.tags.indexOf(tag) > -1; }); },
    neighbours: function (h) { var i = (by[h] || list[0]).order; return { prev: list[(i + list.length - 1) % list.length], next: list[(i + 1) % list.length] }; },
    relatedProducts: function (h) { return ((by[h] || {}).related || []).map(function (x) { return NS.products.byHandle(x); }).filter(Boolean); }
  };
})(window);
