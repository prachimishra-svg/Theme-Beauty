/* NUDGE interactive website: route table.
   Every route uses the SHOPIFY URL shape (/collections/:handle, /products/:handle, /cart, /pages/:handle, /policies/:handle, /blogs/journal[/:article], /search ...).
   In the prototype each route resolves to one existing wireframe file plus a query (c, p, a, t, f, q) the integrations read. In Shopify the same routes are served by the theme templates,
   so only this file's page map and href() builder go away. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  var PAGES = {
    home: ['01-NUDGE-Beauty-Homepage-Wireframe', 'Homepage.html'], collection: ['02-NUDGE-Beauty-PLP-Wireframe', 'PLP.html'], product: ['03-NUDGE-Beauty-PDP-Wireframe', 'PDP.html'],
    cart: ['04-NUDGE-Beauty-Cart-Wireframe', 'Cart_Page.html'], drawer: ['05-NUDGE-Beauty-Cart-Drawer-Wireframe', 'Cart_Drawer_Wireframe_v1.html'], contact: ['06-NUDGE-Beauty-Contact-Wireframe', 'Contact_Page_Wireframe_v1.html'],
    faq: ['07-NUDGE-Beauty-FAQ-Wireframe', 'FAQ_Page_Wireframe_v1.html'], about: ['08-NUDGE-Beauty-About-Wireframe', 'About_Page_Wireframe_v1.html'], story: ['09-NUDGE-Beauty-Story-Wireframe', 'Story_Page_Wireframe_v1.html'],
    shipping: ['10-NUDGE-Beauty-Shipping-Policy-Wireframe', 'Shipping_Policy_Wireframe_v1.html'], returns: ['11-NUDGE-Beauty-Returns-Policy-Wireframe', 'Returns_Policy_Wireframe_v1.html'],
    privacy: ['12-NUDGE-Beauty-Privacy-Policy-Wireframe', 'Privacy_Policy_Wireframe_v1.html'], terms: ['13-NUDGE-Beauty-Terms-Wireframe', 'Terms_Conditions_Wireframe_v1.html'],
    blog: ['14-NUDGE-Beauty-Blog-Listing-Wireframe', 'Blog_Listing_Wireframe_v1.html'], article: ['15-NUDGE-Beauty-Blog-Article-Wireframe', 'Blog_Article_Wireframe_v1.html'], notfound: ['16-NUDGE-Beauty-404-Wireframe', '404_Page_Wireframe_v1.html']
  };
  var STATIC = { '/': 'home', '/cart': 'cart', '/pages/contact': 'contact', '/pages/faq': 'faq', '/pages/about': 'about', '/pages/our-story': 'story', '/policies/shipping-policy': 'shipping',
    '/policies/refund-policy': 'returns', '/policies/privacy-policy': 'privacy', '/policies/terms-of-service': 'terms', '/blogs/journal': 'blog', '/404': 'notfound' };
  var UNSUPPORTED = { '/account': 'account', '/account/login': 'account', '/checkout': 'checkout', '/search': 'search', '/wishlist': 'wishlist' };
  function split(route) { var i = route.indexOf('?'); var p = i > -1 ? route.slice(0, i) : route; var q = {}; if (i > -1) route.slice(i + 1).split('&').forEach(function (kv) { var a = kv.split('='); if (a[0]) q[decodeURIComponent(a[0])] = decodeURIComponent(a[1] || ''); }); return { path: p.replace(/\/+$/, '') || '/', q: q }; }
  /* parse('/products/face-serum') -> { page, params, valid } ; valid=false means Shopify would answer 404 */
  function parse(route) {
    var s = split(route), p = s.path, m;
    if (STATIC[p]) return { page: STATIC[p], params: s.q, valid: true, path: p };
    if (UNSUPPORTED[p]) return { page: null, unsupported: UNSUPPORTED[p], params: s.q, valid: true, path: p };
    if ((m = /^\/collections\/([a-z0-9-]+)$/.exec(p))) { s.q.c = m[1]; return { page: 'collection', params: s.q, valid: !!NS.collections.get(m[1]), path: p }; }
    if ((m = /^\/products\/([a-z0-9-]+)$/.exec(p))) { s.q.p = m[1]; return { page: 'product', params: s.q, valid: !!NS.products.byHandle(m[1]), path: p }; }
    if ((m = /^\/blogs\/journal\/tagged\/([a-z0-9-]+)$/.exec(p))) { s.q.t = m[1]; return { page: 'blog', params: s.q, valid: !!NS.blog.tagFromText(m[1]), path: p }; }
    if ((m = /^\/blogs\/journal\/([a-z0-9-]+)$/.exec(p))) { s.q.a = m[1]; return { page: 'article', params: s.q, valid: !!NS.blog.get(m[1]), path: p }; }
    return { page: 'notfound', params: {}, valid: false, path: p };
  }
  function href(route) {
    var r = parse(route); if (!r.page) return null;
    if (!r.valid) r = parse('/404');
    var q = ['ix=1'], keys = ['c', 'p', 'a', 't', 'f', 'q', 'pg']; keys.forEach(function (k) { if (r.params[k]) q.push(k + '=' + encodeURIComponent(r.params[k])); });
    return new URL('../' + PAGES[r.page][0] + '/' + PAGES[r.page][1] + '?' + q.join('&'), g.location.href).href;
  }
  function currentPage() {
    var f = decodeURIComponent(g.location.pathname).split('/').slice(-2), key = null;
    Object.keys(PAGES).forEach(function (k) { if (PAGES[k][0] === f[0]) key = k; });
    return key;
  }
  /* the route the current page represents, derived from its page and query (used by breadcrumbs, the status pill and tests) */
  function current() {
    var pg = currentPage(), q = new URLSearchParams(g.location.search), r = '/';
    if (pg === 'collection') r = '/collections/' + (q.get('c') || 'all');
    else if (pg === 'product') r = '/products/' + (q.get('p') || 'tinted-moisturiser');
    else if (pg === 'article') r = '/blogs/journal/' + (q.get('a') || 'a-simple-morning-skincare-routine');
    else if (pg === 'blog') r = q.get('t') ? '/blogs/journal/tagged/' + q.get('t') : '/blogs/journal';
    else Object.keys(STATIC).forEach(function (k) { if (STATIC[k] === pg) r = k; });
    return { page: pg, route: r, query: q };
  }
  NS.routes = { PAGES: PAGES, STATIC: STATIC, parse: parse, href: href, current: current, pageKey: currentPage };
  NS.go = function (route) { var h = href(route); if (h) g.location.href = h; return !!h; };
})(window);
