/* NUDGE interactive website: navigation configuration = the central page-linking map in code.
   The wireframes use placeholder hrefs (#, #collection, #pdp, #shop, #cat, #article, #tag ...). resolve() turns each into a Shopify route using the link's href, its visible text and the
   section it sits in (the vocabulary found by tools/audit-links.ps1, 352 KB of evidence in documentation/data/link-inventory.json). It returns:
     '/route'                 navigate to it
     { action: 'search' }     open the search overlay        { action: 'cart' }   open the cart drawer (or stay on the cart page)
     { action: 'unsupported', feature }  explain why it cannot work in a prototype
     { action: 'inert' }      deliberately does nothing (placeholder logos)         null   no rule matched (logged as an unresolved link)
   In Shopify none of this exists: the real hrefs are written by Liquid (routes.product_url, collection.url, routes.cart_url ...). */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  function norm(t) { return String(t || '').replace(/IMAGE PLACEHOLDER\s*\d+:\d+/gi, ' ').replace(/\s+/g, ' ').trim(); }
  function low(t) { return norm(t).toLowerCase(); }
  /* the longest product name contained in a text ("ProductPackshot ... Face Serum 30 ml" -> face-serum) */
  function productIn(text) {
    var t = ' ' + low(text).replace(/[^a-z0-9 ]/g, ' ').replace(/\s+/g, ' ') + ' ', best = null;
    NS.products.all.forEach(function (p) { var n = ' ' + p.name.toLowerCase().replace(/[^a-z0-9 ]/g, ' ').replace(/\s+/g, ' ').trim() + ' '; if (t.indexOf(n) > -1 && (!best || p.name.length > best.name.length)) best = p; });
    if (!best && /\bsunscreen\b/.test(t)) best = NS.products.byHandle('daily-sunscreen');
    return best;
  }
  /* the product a card, row or link belongs to: its own text first, then the card title it sits in */
  function productFor(a, text) {
    var p = productIn(text); if (p) return p;
    var card = a.closest('.product-card,.card,article,li,[data-quick]'); if (card) { var h = card.querySelector('h2,h3,h4,.ptitle,.product-card__title,.cl__name,.up__name'); if (h) { p = productIn(h.textContent); if (p) return p; } }
    var qv = document.getElementById('qv-title'); if (qv && a.closest('#quick-view')) { p = productIn(qv.textContent); if (p) return p; }
    return null;
  }
  var CONCERN = { dryness: 'concern:Dryness', dullness: 'concern:Dullness', breakouts: 'concern:Breakouts', sensitivity: 'concern:Sensitivity', 'uneven tone': 'concern:Uneven tone', texture: 'concern:Texture' };
  var STEP = { cleanse: 'type:Cleanser', treat: 'type:Serum', moisturise: 'type:Moisturiser', protect: 'type:Sun care' };
  function coll(handle, f) { return '/collections/' + handle + (f ? '?f=' + encodeURIComponent(f) : ''); }
  function lastColl() { var h = NS.store.get().last.collection; return NS.collections.get(h) ? h : 'all'; }
  function resolve(a, href, text, section) {
    var id = href === '#' ? '' : href.slice(1), t = low(text), P, c, tag, art;
    if (id.indexOf('collection-') === 0) return coll(id.slice(11)); /* mega menu, footer and tile links: #collection-<handle> */
    switch (id) {
      case 'search': return { action: 'search' };
      case 'account': return { action: 'unsupported', feature: 'account' };
      case 'cart': case 'bag': return a.closest('#cart-drawer,#ix-cart-drawer') ? '/cart' : { action: 'cart' };
      case 'top': return (t === 'store home' || t === 'home' || /store home/.test(low(a.getAttribute('aria-label'))) || t === 'nudge') ? '/' : null;
      case 'home': return '/';
      case 'main': case 'results': case 'product': return null;
      case 'collection':
        c = NS.collections.fromText(t); return coll(c ? c.handle : 'all');
      case 'shop':
        if (/^continue shopping/.test(t)) return coll(lastColl());
        c = NS.collections.fromText(t); if (c) return coll(c.handle);
        return coll(/^shop gift/.test(t) ? 'body-gift-sets' : 'all');
      case 'pdp':
        P = productFor(a, text); return P ? '/products/' + P.handle : '/collections/all';
      case 'cat':
        if (/related products/i.test(section)) { P = productFor(a, text); if (P) return '/products/' + P.handle; }
        c = NS.collections.fromText(t); if (c) return coll(c.handle);
        P = productFor(a, text); if (P) return '/products/' + P.handle;
        return coll('skin');
      case 'article':
        art = NS.blog.byTitle(text) || NS.blog.byTitle((a.closest('article,li,section') || a).querySelector('h2,h3,h4') ? (a.closest('article,li,section').querySelector('h2,h3,h4').textContent) : '');
        return art ? '/blogs/journal/' + art.handle : '/blogs/journal';
      case 'tag': tag = NS.blog.tagFromText(t); return tag ? '/blogs/journal/tagged/' + NS.blog.slug(tag) : '/blogs/journal';
      case 'blog': return '/blogs/journal';
      case 'prev': case 'next': { var cur = NS.routes.current(), nb = NS.blog.neighbours((cur.query.get('a') || '')); return '/blogs/journal/' + (id === 'prev' ? nb.prev : nb.next).handle; }
      case 'p0': case 'p1': case 'p2': case 'p3': return { action: 'unsupported', feature: 'pagination' };
      case 'help': case 'contact': case 's-contact': return '/pages/contact';
      case 'faq': return '/pages/faq';
      case 'about': return '/pages/about';
      case 'story': return '/pages/our-story';
      case 'shipping': return '/policies/shipping-policy';
      case 'returns': return '/policies/refund-policy';
      case 'privacy': return '/policies/privacy-policy';
      case 'terms': return '/policies/terms-of-service';
      case 'policy': return /shipping/.test(t) ? '/policies/shipping-policy' : /privacy/.test(t) ? '/policies/privacy-policy' : /terms/.test(t) ? '/policies/terms-of-service' : '/policies/refund-policy';
      case 'policies': return '/policies/shipping-policy';
      case 'ingredients': return '/blogs/journal/tagged/ingredients';
      case 'mail': case 'tel': return { action: 'unsupported', feature: 'contact' };
      case 's16': return { action: 'inert' };
      case 's07': return null; /* "Find your routine" scrolls to the finder section, which exists */
      case 's06': {
        if (/see matching products/.test(t)) { var on = a.closest('section') && a.closest('section').querySelector('button[aria-pressed="true"],[aria-checked="true"]'); var sk = on ? norm(on.textContent) : ''; return coll('skin', /^(Dry|Normal|Oily|Combination|Sensitive)$/.test(sk) ? 'skin:' + sk : ''); }
        if (/shop the products/.test(t)) return coll('skin');
        if (/hero banner/i.test(section)) return /^shop the edit$/.test(t) ? null : ((P = productFor(a, text)) ? '/products/' + P.handle : null);
        P = productFor(a, text); return P ? '/products/' + P.handle : null;
      }
      case '': break;
      default: return null;
    }
    /* bare "#": decide by section and text */
    P = productFor(a, text); c = NS.collections.fromText(t.replace(/^category photo:\s*/, '').replace(/(tall|wide) editorial.*$/, '').replace(/\d:\d.*$/, ''));
    if (/^category photo:/.test(t)) { var m = /^category photo:\s*(skin care|makeup|hair|body)/.exec(t); return coll(m ? NS.collections.fromText(m[1]).handle : 'all'); }
    if (/^concern:/.test(t)) { var k = t.replace(/^concern:\s*/, '').replace(/\d:\d.*$/, '').trim(); k = Object.keys(CONCERN).filter(function (x) { return k.indexOf(x) === 0; })[0]; return coll('skin', CONCERN[k] || ''); }
    var step = /^\d?\s*(cleanse|treat|moisturise|protect)/.exec(t.replace(/^\d/, '').trim()); if (step && /routine|need/i.test(section)) return coll('skin', STEP[step[1]]);
    if (/^(instagram|facebook|youtube)$/.test(t)) return { action: 'unsupported', feature: 'social' };
    if (/^view all/.test(t)) return coll('all');
    if (/^shop gift/.test(t)) return coll('body-gift-sets');
    if (P) return '/products/' + P.handle;
    return null;
  }
  NS.nav = { resolve: resolve, productIn: productIn, productFor: productFor, norm: norm };
})(window);
