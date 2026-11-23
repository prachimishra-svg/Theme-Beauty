/* NUDGE Beauty: Homepage section behaviour (ported from the wireframe page script, Theme Editor safe).
   Click behaviour is delegated; per-section state is set up by init(), which runs on load and on shopify:section:load (items carry a bound flag).
   - Featured collection tabs: inactive tabs' product grids are <template data-tab-grid="n">; choosing a tab swaps one into #prod-grid.
   - Guided finder: questions come from the hidden [data-finder-source] list (one <li data-question> per block, answers one per line).
   - Shop the look: pins are exclusive (.is-on).
   - Ritual steps: previous/next scroll the track, the counter and button states follow the scroll position. */
(function () {
  'use strict';
  var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---- delegated clicks: tabs, pins, finder chips ---- */
  document.addEventListener('click', function (e) {
    var tab = e.target.closest('.tabs [role="tab"]');
    if (tab) {
      var grid = document.getElementById('prod-grid'); if (!grid) return;
      var set = tab.getAttribute('data-set');
      [].forEach.call(tab.parentNode.querySelectorAll('[role="tab"]'), function (t) { var on = t === tab; t.classList.toggle('on', on); t.setAttribute('aria-selected', on ? 'true' : 'false'); });
      if (!grid.hasAttribute('data-tab-0')) { var t0 = document.createElement('template'); t0.setAttribute('data-tab-grid', '0'); t0.innerHTML = grid.innerHTML; grid.setAttribute('data-tab-0', ''); grid.parentNode.insertBefore(t0, grid.nextSibling); }
      var tpl = grid.parentNode.querySelector('template[data-tab-grid="' + set + '"]'); if (tpl) grid.innerHTML = tpl.innerHTML;
      return;
    }
    var pin = e.target.closest('.pin');
    if (pin) { [].forEach.call(document.querySelectorAll('.pin'), function (x) { x.classList.remove('is-on'); }); pin.classList.add('is-on'); return; }
    var chip = e.target.closest('#f-chips .hp-chip');
    if (chip) { [].forEach.call(chip.parentNode.children, function (x) { x.classList.remove('on'); }); chip.classList.add('on'); }
  });

  /* ---- guided finder ---- */
  function initFinder(card) {
    if (card.__fin) return; card.__fin = true;
    var src = card.querySelector('[data-finder-source]'); if (!src) return;
    var steps = [].map.call(src.querySelectorAll('[data-question]'), function (li) {
      return { q: li.getAttribute('data-question'), o: li.textContent.split(/\r?\n/).map(function (x) { return x.trim(); }).filter(Boolean) };
    });
    var stepEl = card.querySelector('#f-step'), qEl = card.querySelector('#f-q'), chips = card.querySelector('#f-chips'), res = card.querySelector('#f-res'), next = card.querySelector('#f-next'), back = card.querySelector('#f-back');
    var tmpl = stepEl.textContent, si = 0, N = steps.length;
    function esc(s) { return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;'); }
    function show() {
      var last = si >= N;
      chips.style.display = last ? 'none' : 'flex'; res.hidden = !last; next.style.display = last ? 'none' : '';
      if (!last) {
        var n = 0; stepEl.textContent = tmpl.replace(/\d+/g, function () { n++; return n === 1 ? (si + 1) : N; });
        qEl.textContent = steps[si].q;
        chips.innerHTML = steps[si].o.map(function (o, i) { return '<button class="hp-chip' + (i === 0 ? ' on' : '') + '" type="button">' + esc(o) + '</button>'; }).join('');
      } else { stepEl.textContent = src.getAttribute('data-result-step') || ''; qEl.textContent = src.getAttribute('data-result-title') || ''; }
    }
    next.addEventListener('click', function () { if (si < N) { si++; show(); } });
    back.addEventListener('click', function () { if (si > 0) { si--; show(); } });
  }

  /* ---- ritual steps scroller ---- */
  function initRitual(r) {
    if (r.__rit) return; r.__rit = true;
    var tr = r.querySelector('.rit__track'), items = tr.children, cnt = r.querySelector('.rit__count'), pv = r.querySelector('.rit__prev'), nx = r.querySelector('.rit__next'), N = items.length;
    if (!N) return;
    function pad(n) { return (n < 10 ? '0' : '') + n; }
    function pos(k) { return items[k].offsetLeft - items[0].offsetLeft; }
    function idx() { var max = tr.scrollWidth - tr.clientWidth; if (tr.scrollLeft >= max - 2) return N - 1; var best = 0, d = 1e9; for (var k = 0; k < N; k++) { var dd = Math.abs(pos(k) - tr.scrollLeft); if (dd < d) { d = dd; best = k; } } return best; }
    function upd() { var i = idx(); cnt.textContent = pad(i + 1) + ' / ' + pad(N); pv.disabled = tr.scrollLeft <= 2; nx.disabled = tr.scrollLeft >= tr.scrollWidth - tr.clientWidth - 2; }
    function go(d) { var i = Math.max(0, Math.min(N - 1, idx() + d)); tr.scrollTo({ left: pos(i), behavior: reduce ? 'auto' : 'smooth' }); }
    pv.addEventListener('click', function () { go(-1); }); nx.addEventListener('click', function () { go(1); });
    tr.addEventListener('scroll', upd, { passive: true }); window.addEventListener('resize', upd); upd();
  }

  /* ---- video: the iframe is created only when the shopper taps play ---- */
  document.addEventListener('click', function (e) {
    var play = e.target.closest('.vid__box .play[data-embed]'); if (!play) return;
    var box = play.closest('.vid__box'), poster = box.querySelector('.img');
    var frame = document.createElement('iframe');
    frame.src = play.getAttribute('data-embed'); frame.title = play.getAttribute('data-title') || ''; frame.allow = 'autoplay; encrypted-media; picture-in-picture; fullscreen'; frame.setAttribute('allowfullscreen', ''); 
    poster.appendChild(frame); play.hidden = true; var dur = box.querySelector('.dur'); if (dur) dur.hidden = true;
  });

  /* ---- before / after slider ---- */
  function initCompare(root) {
    if (root.__cmp) return; root.__cmp = true;
    var f = root.querySelector('.cmp__frame'), r = root.querySelector('.cmp__range'), tb = root.querySelector('.cmp__tag--b'), ta = root.querySelector('.cmp__tag--a'), drag = false;
    function tags(v) { var w = f.clientWidth, x = v / 100 * w; if (tb) root.classList.toggle('hide-b', x < tb.offsetLeft + tb.offsetWidth + 8); if (ta) root.classList.toggle('hide-a', x > ta.offsetLeft - 8); }
    function set(v) { v = Math.max(0, Math.min(100, v)); root.style.setProperty('--pos', v + '%'); root.style.setProperty('--p', v); tags(v); r.value = Math.round(v); r.setAttribute('aria-valuetext', Math.round(v) + '% before, ' + Math.round(100 - v) + '% after'); }
    function at(e) { var b = f.getBoundingClientRect(); if (b.width) set((e.clientX - b.left) / b.width * 100); }
    set(parseFloat(root.getAttribute('data-start')) || 50);
    window.addEventListener('resize', function () { tags(+r.value); });
    r.addEventListener('input', function () { set(+r.value); });
    f.addEventListener('pointerdown', function (e) { if (e.button > 0) return; drag = true; f.classList.add('is-drag'); if (f.setPointerCapture) f.setPointerCapture(e.pointerId); at(e); });
    f.addEventListener('pointermove', function (e) { if (drag) at(e); });
    ['pointerup', 'pointercancel', 'lostpointercapture'].forEach(function (n) { f.addEventListener(n, function () { drag = false; f.classList.remove('is-drag'); }); });
  }

  /* ---- generic scroller (Testimonials, Logo list) ---- */
  function initScroller(s) {
    if (s.__scr) return; s.__scr = true;
    var tr = s.querySelector('.rec__track'), p = s.querySelector('.rec__prev'), n = s.querySelector('.rec__next');
    function upd() { var max = tr.scrollWidth - tr.clientWidth; s.classList.toggle('is-static', max <= 2); p.disabled = tr.scrollLeft <= 2; n.disabled = tr.scrollLeft >= max - 2; }
    function go(d) { tr.scrollBy({ left: d * tr.clientWidth * 0.9, behavior: reduce ? 'auto' : 'smooth' }); }
    p.addEventListener('click', function () { go(-1); }); n.addEventListener('click', function () { go(1); });
    tr.addEventListener('scroll', upd, { passive: true }); window.addEventListener('resize', upd); upd();
  }

  /* ---- newsletter: check the email first; a valid form is submitted to Shopify as normal ---- */
  function initNewsletter(f) {
    if (f.__nl) return; f.__nl = true;
    var i = f.querySelector('#nl-email'), m = document.getElementById('nl-msg'); if (!i || !m) return;
    function say(ok, t) { m.classList.remove('is-ok', 'is-err'); m.classList.add(ok ? 'is-ok' : 'is-err'); m.textContent = t; }
    f.addEventListener('submit', function (e) {
      var ok = i.value.trim() !== '' && i.checkValidity();
      i.setAttribute('aria-invalid', ok ? 'false' : 'true');
      if (!ok) { e.preventDefault(); say(false, m.getAttribute('data-error') || ''); i.focus(); }
    });
    i.addEventListener('input', function () { if (i.getAttribute('aria-invalid') === 'true' && i.checkValidity()) { i.setAttribute('aria-invalid', 'false'); m.textContent = ''; m.classList.remove('is-ok', 'is-err'); } });
  }
  function init() {
    [].forEach.call(document.querySelectorAll('#finder'), initFinder);
    [].forEach.call(document.querySelectorAll('[data-ritual]'), initRitual);
    [].forEach.call(document.querySelectorAll('.cmp'), initCompare);
    [].forEach.call(document.querySelectorAll('[data-scroller]'), initScroller);
    [].forEach.call(document.querySelectorAll('#nl-form'), initNewsletter);
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();
  document.addEventListener('shopify:section:load', init);
})();