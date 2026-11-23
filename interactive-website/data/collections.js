/* NUDGE interactive website: collections and categories.
   Handles and titles come from the header mega menus and footer (data/collection-links.js, generated from the wireframes). The FILTER PRESET of each collection is a prototype assumption
   (the wireframes only show the menu, not what a collection contains): it maps a collection to the PLP's own filters (concern, type, ingredient, sort).
   Makeup, hair and body collections have NO products in the PLP sample data, so they open the PLP's existing "no products" state. In Shopify a collection holds products by rule or by hand. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite, links = NS.data.collectionLinks;
  var GROUPS = { skin: 'Skin care', makeup: 'Makeup', hair: 'Hair', body: 'Body' };
  var PRESET = {
    'skin-hydration': { concern: ['Dryness'] }, 'skin-brightening': { concern: ['Dullness', 'Uneven tone'] }, 'skin-anti-ageing': { ingredient: ['Peptides'] },
    'skin-blemish-care': { concern: ['Breakouts'] }, 'skin-sensitive-skin': { concern: ['Sensitivity'] }, 'skin-cleansers': { type: ['Cleanser'] }, 'skin-serums': { type: ['Serum'] },
    'skin-moisturisers': { type: ['Moisturiser'] }, 'skin-sun-care': { type: ['Sun care'] }, 'skin-masks': { type: ['Mask'] }, 'skin-eye-care': { type: ['Eye care'] },
    'skin-new-in-skin': { sort: 'new' }, 'skin-skin-routines': {}, 'skin': {}
  };
  var list = [{ handle: 'all', title: 'All products', group: 'all', preset: {}, top: true }];
  links.forEach(function (l) {
    var h = l[0], grp = h.split('-')[0], top = !!GROUPS[h];
    list.push({ handle: h, title: top ? GROUPS[h] : l[1], group: grp, top: top, preset: grp === 'skin' ? (PRESET[h] || {}) : { type: ['(no products in sample data)'] } });
  });
  var by = {}; list.forEach(function (c) { by[c.handle] = c; });
  function norm(t) { return String(t || '').toLowerCase().replace(/\s+/g, ' ').trim(); }
  function fromText(text) {
    var t = norm(text).replace(/^(shop all|all|view all)\s+/, '');
    if (t === 'skin care' || t === 'skin') return by.skin; if (/^(makeup|hair|body)$/.test(t)) return by[t];
    for (var i = 0; i < list.length; i++) if (!list[i].top && norm(list[i].title) === t) return list[i];
    return null;
  }
  NS.collections = { all: list, groups: GROUPS, get: function (h) { return by[h] || null; }, fromText: fromText, groupOf: function (p) { return by[p && p.group] || by.skin; } };
})(window);
