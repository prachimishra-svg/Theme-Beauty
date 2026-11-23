/* NUDGE interactive website: Blog listing and Article integration. Article cards, tags, Journal links and Previous/Next are resolved by the route resolver. This file binds the pages to routes:
   LISTING /blogs/journal/tagged/:tag hides the cards whose article does not carry the tag (tags are a prototype assignment, see data/blog-data.js) and marks the active tag; the PLP-style empty state
   is used when no card is left. ARTICLE /blogs/journal/:handle sets the title, breadcrumb, tag links and the Previous/Next titles. The article layout is one sample article body for every handle.
   NOT POSSIBLE without new design: "related products" on an article (the Article wireframe has no such section) and pagination (the listing shows one page). Both are reported, not invented.
   In Shopify: blog.articles | tag filter via /blogs/journal/tagged/:tag, paginate, article.tags, article.metafields for related products. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  function cardOf(a) { return a.closest('article') || a.closest('li'); }
  NS.integrations.blog = function () {
    var q = new URLSearchParams(g.location.search), t = q.get('t'), tag = t ? NS.blog.tagFromText(t) : null; if (t && !tag) { NS.go('/404'); return; }
    if (!tag) return; document.title = tag + ' | Journal | NUDGE';
    var shown = 0, seen = [];
    [].forEach.call(document.querySelectorAll('main a[href="#article"]'), function (a) {
      var c = cardOf(a); if (!c || seen.indexOf(c) > -1) return; seen.push(c);
      var h = c.querySelector('h2,h3,h4'), art = NS.blog.byTitle(h ? h.textContent : a.textContent), ok = !!art && art.tags.indexOf(tag) > -1; c.hidden = !ok; if (ok) shown++;
    });
    [].forEach.call(document.querySelectorAll('main a[href="#tag"],main a[href="#blog"]'), function (a) { var on = NS.blog.tagFromText(a.textContent) === tag; if (on) a.setAttribute('aria-current', 'true'); else if (a.getAttribute('aria-current') === 'true') a.removeAttribute('aria-current'); });
    var all = [].filter.call(document.querySelectorAll('main a[href="#blog"]'), function (a) { return a.textContent.trim() === 'All'; })[0]; if (all) all.removeAttribute('aria-current');
    if (!shown && g.NudgeBlog) g.NudgeBlog.state('empty');
  };
  NS.integrations.article = function () {
    var q = new URLSearchParams(g.location.search), h = q.get('a') || NS.blog.articles[0].handle, art = NS.blog.get(h); if (!art) { NS.go('/404'); return; }
    var title = document.querySelector('main h1'); if (title) title.textContent = art.title; document.title = art.title + ' | Journal | NUDGE';
    NS.breadcrumbs.update([{ label: 'Home', route: '/' }, { label: 'Journal', route: '/blogs/journal' }, { label: art.title, route: '/blogs/journal/' + h }]);
    var groups = []; [].forEach.call(document.querySelectorAll('main a[href="#tag"]'), function (a) { var p = a.parentElement, g2 = groups.filter(function (x) { return x.p === p; })[0]; if (!g2) groups.push(g2 = { p: p, list: [] }); g2.list.push(a); });
    groups.forEach(function (gr) { gr.list.forEach(function (a, i) { a.textContent = art.tags[i % art.tags.length]; }); });
    var nb = NS.blog.neighbours(h);
    [['prev', nb.prev], ['next', nb.next]].forEach(function (pair) {
      var a = document.querySelector('main a[href="#' + pair[0] + '"]'); if (!a) return;
      var s = [].slice.call(a.querySelectorAll('*')).filter(function (x) { return /Sample title/.test(x.textContent) && !x.children.length; })[0]; if (s) s.textContent = pair[1].title;
    });
  };
})(window);
