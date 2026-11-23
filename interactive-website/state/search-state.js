/* NUDGE interactive website: search state (last query and recent searches). In Shopify: the Predictive Search API (/search/suggest.json) and the /search results template. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite, st = NS.store;
  NS.searchState = {
    query: function () { return st.get().search.q || ''; },
    recent: function () { return st.get().search.recent || []; },
    remember: function (q) {
      q = String(q || '').trim(); if (!q) return; var s = st.get().search; s.q = q;
      s.recent = [q].concat((s.recent || []).filter(function (x) { return x.toLowerCase() !== q.toLowerCase(); })).slice(0, 5); st.save(); st.emit('search', { q: q });
    },
    clearRecent: function () { st.get().search.recent = []; st.save(); st.emit('search'); }
  };
})(window);
