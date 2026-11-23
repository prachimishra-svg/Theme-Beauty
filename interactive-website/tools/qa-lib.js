/* Shared helpers for the QA suites (suite-*.js). Prepended by tools/run-suite.ps1. Runs in a wrapper page in headless Chrome.
   Globals from the wrapper: BASE (file URL of 03-Wireframes/), PG (page key -> [folder, file]), ONLY (selected groups), iframe #f, textarea #o. */
var f = document.getElementById('f'), R = [];
function sleep(ms) { return new Promise(function (r) { setTimeout(r, ms); }); }
function W() { return f.contentWindow; } function D() { return f.contentDocument; }
function NS() { return W().NudgeSite; }
function q(s, root) { return (root || D()).querySelector(s); } function qa(s, root) { return [].slice.call((root || D()).querySelectorAll(s)); }
function url(k, qs, ix) { return BASE + PG[k][0] + '/' + PG[k][1] + '?' + (ix === false ? 'ix=0' : 'ix=1') + (qs ? '&' + qs : ''); }
function on(id) { return !ONLY.length || ONLY.indexOf(id) > -1; }
function ready(mode) { return new Promise(function (res) { var t = 0; (function p() { var s = null; try { s = D().documentElement.getAttribute('data-ix'); } catch (e) { /* loading */ } if (mode === 'plain') { try { if (D().readyState === 'complete' && t > 1500) { res('plain'); return; } } catch (e2) { /* */ } } else if (s === 'ready' || s === 'error') { res(s); return; } if (t > 9000) { res(s || 'timeout'); return; } t += 100; setTimeout(p, 100); })(); }); }
/* load(url) in interactive mode; loadPlain(url) with interactive mode OFF (flag and window.name cleared first) */
function load(u) { return new Promise(function (res) { f.onload = function () { f.onload = null; ready().then(function (s) { sleep(300).then(function () { res(s); }); }); }; f.src = u; }); }
function loadPlain(u) {
  return new Promise(function (res) {
    try { f.contentWindow.localStorage.removeItem('nudge.interactive'); f.contentWindow.name = ''; } catch (e) { /* first load */ }
    f.onload = function () { f.onload = null; ready('plain').then(function (s) { sleep(300).then(function () { res(s); }); }); }; f.src = u;
  });
}
function nav(action) { return new Promise(function (res) { var to = setTimeout(function () { f.onload = null; res('NO-NAV'); }, 7000); f.onload = function () { clearTimeout(to); f.onload = null; ready().then(function (s) { sleep(300).then(function () { res(s); }); }); }; try { action(); } catch (e) { clearTimeout(to); res('ERR ' + e); } }); }
function size(w, h) { f.style.width = w + 'px'; f.style.height = (h || 900) + 'px'; }
function rec(g, n, status, d) { R.push({ g: g, n: n, s: status, d: String(d === undefined ? '' : d).slice(0, 400) }); }
function check(g, n, pass, d) { rec(g, n, pass ? 'pass' : 'fail', d); }
function finish() { document.getElementById('o').textContent = JSON.stringify(R); }
function path() { try { return decodeURIComponent(f.contentWindow.location.pathname.split('/').slice(-2).join('/')) + f.contentWindow.location.search; } catch (e) { return ''; } }
function isPage(k) { return path().indexOf(PG[k][0] + '/' + PG[k][1]) === 0; }
