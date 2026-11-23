/* NUDGE Design System preview — tiny progressive enhancements only.
   Everything here is demo behaviour; the design system itself is pure CSS. */
(function () {
  'use strict';
  var root = document.documentElement;
  var css = getComputedStyle(root);

  /* 1. Print the resolved value of each token next to its tile (no hand-copied hex). */
  document.querySelectorAll('[data-token-value]').forEach(function (el) {
    el.textContent = css.getPropertyValue(el.getAttribute('data-token-value')).trim().toUpperCase();
  });

  /* 1b. Spacing-scale labels are read from the tokens (no hand-copied pixel values). */
  document.querySelectorAll('.ds-space__row').forEach(function (row) {
    var name = row.children[0].textContent.trim(), out = row.children[1];
    var probe = document.createElement('div'); probe.style.cssText = 'position:absolute;visibility:hidden;width:var(--' + name + ')';
    document.body.appendChild(probe); out.textContent = Math.round(probe.getBoundingClientRect().width) + 'px'; probe.remove();
  });

  /* 2. Live computed font-size for each type specimen + viewport readout. */
  function updateLive() {
    document.querySelectorAll('[data-spec]').forEach(function (sample) {
      var out = sample.closest('.ds-spec').querySelector('.ds-live');
      if (out) out.textContent = parseFloat(getComputedStyle(sample).fontSize).toFixed(1).replace('.0', '') + 'px';
    });
    var vw = document.querySelector('[data-vw]');
    if (vw) vw.textContent = window.innerWidth + 'px';
    var cols = document.querySelector('[data-cols]');
    if (cols) cols.textContent = css.getPropertyValue('--grid-columns-products').trim();
    var gut = document.querySelector('[data-gutter]');
    var probe = document.querySelector('.container');
    if (gut && probe) gut.textContent = parseFloat(getComputedStyle(probe).paddingLeft).toFixed(0) + 'px';
  }
  updateLive();
  var t; window.addEventListener('resize', function () { clearTimeout(t); t = setTimeout(updateLive, 80); });

  /* 3. Section nav: mark the section in view. */
  var links = document.querySelectorAll('.ds-nav a');
  if ('IntersectionObserver' in window && links.length) {
    var map = {};
    links.forEach(function (a) { map[a.getAttribute('href').slice(1)] = a; });
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) {
          links.forEach(function (a) { a.removeAttribute('aria-current'); });
          var a = map[e.target.id]; if (a) a.setAttribute('aria-current', 'true');
        }
      });
    }, { rootMargin: '-30% 0px -60% 0px' });
    Object.keys(map).forEach(function (id) { var s = document.getElementById(id); if (s) io.observe(s); });
  }

  /* 4. Quantity selectors. */
  document.querySelectorAll('.qty').forEach(function (q) {
    var input = q.querySelector('.qty__input'), minus = q.querySelector('[data-qty="-1"]'), plus = q.querySelector('[data-qty="1"]');
    var min = +input.min || 1, max = +input.max || 99;
    function sync() { minus.disabled = +input.value <= min; plus.disabled = +input.value >= max; }
    q.addEventListener('click', function (e) {
      var b = e.target.closest('[data-qty]'); if (!b || b.disabled) return;
      input.value = Math.min(max, Math.max(min, (+input.value || min) + (+b.dataset.qty))); sync();
    });
    input.addEventListener('change', function () { input.value = Math.min(max, Math.max(min, +input.value || min)); sync(); });
    sync();
  });

  /* 5. Password visibility toggle. */
  document.querySelectorAll('[data-toggle-password]').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var input = document.getElementById(btn.getAttribute('data-toggle-password'));
      var show = input.type === 'password';
      input.type = show ? 'text' : 'password';
      btn.setAttribute('aria-pressed', String(show));
      btn.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
      btn.querySelector('use').setAttribute('href', show ? '#icon-eye-off' : '#icon-eye');
    });
  });

  /* 6. Swatch label + wishlist toggle. */
  document.querySelectorAll('[data-swatch-group]').forEach(function (g) {
    var out = document.getElementById(g.getAttribute('data-swatch-group'));
    g.addEventListener('change', function (e) { if (out && e.target.matches('input')) out.textContent = e.target.getAttribute('data-name'); });
  });
  document.querySelectorAll('[data-wishlist]').forEach(function (b) {
    b.addEventListener('click', function () {
      var on = b.getAttribute('aria-pressed') !== 'true';
      b.setAttribute('aria-pressed', String(on));
      b.setAttribute('aria-label', on ? 'Remove from wishlist' : 'Add to wishlist');
    });
  });

  /* 6b. Filter chips (demo toggle). */
  document.querySelectorAll('[data-chip]').forEach(function (c) {
    c.addEventListener('click', function () { c.setAttribute('aria-pressed', String(c.getAttribute('aria-pressed') !== 'true')); });
  });

  /* 7. Validation demo: error = border + icon + text, focus moves to first error. */
  var form = document.getElementById('demo-form');
  if (form) {
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var first = null;
      form.querySelectorAll('[data-required]').forEach(function (input) {
        var field = input.closest('.field');
        var bad = !input.value.trim() || (input.type === 'email' && !/^\S+@\S+\.\S+$/.test(input.value));
        field.classList.toggle('field--error', bad);
        field.classList.toggle('field--success', !bad);
        if (bad) { input.setAttribute('aria-invalid', 'true'); first = first || input; }
        else input.removeAttribute('aria-invalid');
      });
      var summary = document.getElementById('demo-form-summary');
      summary.hidden = !first;
      if (first) first.focus();
    });
  }
  /* 8. Load more: demo loader (there is no server here). A theme uses the default fetch loader in load-more.js. */
  if (window.NudgeLoadMore) {
    var failNext = false, failBtn = document.querySelector('[data-demo-fail]'), failLabel = failBtn ? failBtn.textContent : '';
    if (failBtn) failBtn.addEventListener('click', function () { failNext = true; failBtn.textContent = 'The next load will fail'; });
    window.NudgeLoadMore.loader = function (url) {
      return new Promise(function (resolve, reject) {
        setTimeout(function () {
          if (failNext) { failNext = false; if (failBtn) failBtn.textContent = failLabel; reject(new Error('demo failure')); return; }
          var page = +(/page=(\d+)/.exec(url) || [0, 2])[1], items = [];
          for (var n = 1; n <= 4; n++) {
            var i = (page - 1) * 4 + n, li = document.createElement('li');
            li.className = 'card'; li.innerHTML = '<a class="link link--standalone" href="#navigation">Demo product ' + i + '</a><p class="text-caption">$' + (30 + i) + '</p>';
            items.push(li);
          }
          resolve({ items: items, nextUrl: page < 4 ? '?page=' + (page + 1) : null });
        }, 500);
      });
    };
  }})();
