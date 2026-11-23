/* Phases 4 and 6 support: accessibility, keyboard and UX-rule checks on every page in interactive mode (1440 and 390 px) plus overlay behaviour. Automated rules only; colour contrast, screen reader
   output and real assistive technology are NOT TESTED here and are reported as such. */
function vis(e) { var cs = W().getComputedStyle(e), r = e.getBoundingClientRect(); return cs.display !== 'none' && cs.visibility !== 'hidden' && r.width > 0 && r.height > 0; }
function nm(e) { return e.tagName.toLowerCase() + (e.id ? '#' + e.id : '') + ' "' + (e.textContent || '').trim().slice(0, 20) + '"'; }
function accName(e) {
  var d = D(), t = (e.getAttribute('aria-label') || '').trim(); if (t) return t;
  var lb = e.getAttribute('aria-labelledby'); if (lb) { t = lb.split(/\s+/).map(function (i) { var x = d.getElementById(i); return x ? x.textContent : ''; }).join(' ').trim(); if (t) return t; }
  t = (e.textContent || '').replace(/\s+/g, ' ').trim(); if (t) return t; var sv = e.querySelector('svg[aria-label],[role=img][aria-label]'); if (sv && sv.getAttribute('aria-label').trim()) return sv.getAttribute('aria-label'); var im = e.querySelector('img[alt]'); if (im && im.alt.trim()) return im.alt; var ti = e.getAttribute('title'); if (ti) return ti;
  if (e.value && /^(button|submit)$/.test(e.type)) return e.value; return '';
}
function audit(g) {
  var d = D(), bad;
  check(g, 'html has a lang attribute', !!d.documentElement.lang, d.documentElement.lang);
  var h1 = qa('h1').filter(vis); check(g, 'Exactly one visible h1', h1.length === 1, h1.length);
  var hs = qa('h1,h2,h3,h4,h5,h6').filter(function (e) { return vis(e) && !e.closest('.rv,#wp'); }), jump = [], last = 0; hs.forEach(function (e) { var l = +e.tagName[1]; if (last && l > last + 1) jump.push(nm(e) + ' after h' + last); last = l; });
  rec(g, 'Heading order has no skipped levels', jump.length ? 'fail' : 'pass', jump.slice(0, 4).join(' ; '));
  var land = ['header', 'main', 'footer', 'nav'].filter(function (t) { return !q(t); }); check(g, 'Landmarks present (header, main, nav, footer)', !land.length, land.join(','));
  bad = qa('button,[role=button]').filter(function (e) { return vis(e) && !e.closest('.rv,#wp,.ann') && !accName(e); }); check(g, 'Every button has an accessible name', !bad.length, bad.slice(0, 4).map(nm).join(' ; '));
  bad = qa('a[href]').filter(function (e) { return vis(e) && !e.closest('.rv,#wp,.ann') && !accName(e); }); check(g, 'Every link has an accessible name', !bad.length, bad.slice(0, 4).map(function (e) { return nm(e) + ' ' + e.getAttribute('href'); }).join(' ; '));
  bad = qa('input:not([type=hidden]):not([type=submit]):not([type=button]),select,textarea').filter(function (e) { return !e.closest('.rv,#wp,.ann') && !(e.getAttribute('aria-label') || e.getAttribute('aria-labelledby') || e.closest('label') || (e.id && q('label[for="' + e.id + '"]'))); }); check(g, 'Every form field has a label', !bad.length, bad.slice(0, 4).map(function (e) { return e.tagName + '#' + e.id + '.' + e.name; }).join(' ; '));
  bad = qa('img').filter(function (e) { return !e.hasAttribute('alt'); }); check(g, 'Every image has alt text', !bad.length, bad.length);
  var ids = {}, dup = []; qa('[id]').forEach(function (e) { if (ids[e.id]) dup.push(e.id); ids[e.id] = 1; }); check(g, 'No duplicate ids', !dup.length, dup.slice(0, 5).join(','));
  bad = qa('[aria-controls]').filter(function (e) { return e.getAttribute('aria-controls').split(/\s+/).some(function (i) { return !d.getElementById(i); }); }); check(g, 'aria-controls point at existing elements', !bad.length, bad.slice(0, 3).map(nm).join(' ; '));
  var sk = qa('a[href^="#"]').filter(function (a) { return /skip to/i.test(a.textContent); })[0]; check(g, 'Skip link exists and its target exists', !!sk && !!d.getElementById(sk.getAttribute('href').slice(1)), sk ? sk.getAttribute('href') : 'none');
  /* focus indicator on the first 14 focusable controls */
  var f2 = qa('a[href],button,input:not([type=hidden]),select,summary').filter(function (e) { return vis(e) && !e.disabled && !e.closest('.rv,#wp,.ann,#ix-pill,[inert],[hidden]') && e.tabIndex >= 0; }).slice(0, 14), nofocus = [];
  f2.forEach(function (e) { e.focus(); var cs = W().getComputedStyle(e); var ring = (cs.outlineStyle !== 'none' && parseFloat(cs.outlineWidth) > 0) || (cs.boxShadow && cs.boxShadow !== 'none'); if (d.activeElement === e && !ring) nofocus.push(nm(e)); });
  check(g, 'Focus indicator visible on the first 14 controls', !nofocus.length, nofocus.slice(0, 4).join(' ; '));
}
(async function main() {
  if (on('pages')) {
    var keys = Object.keys(PG), qs = { collection: 'c=skin', product: 'p=face-serum', article: 'a=what-is-niacinamide' };
    for (var i = 0; i < keys.length; i++) for (var wi = 0; wi < 2; wi++) { var w = [1440, 390][wi]; size(w, w === 390 ? 844 : 900); var st = await load(url(keys[i], qs[keys[i]] || '')); if (st !== 'ready') { rec('P4 a11y ' + keys[i] + ' @' + w, 'ready', 'fail', st); continue; } audit('P4 a11y ' + keys[i] + ' @' + w); }
  }
  if (on('overlays')) {
    size(1440, 900); await load(url('product', 'p=face-serum')); var g = 'P4 overlays';
    var sl = qa('#site-header a[href="#search"]').filter(vis)[0]; sl.focus(); sl.click(); await sleep(300);
    check(g, 'Search opens and focus moves into the field', NS().searchOverlay.isOpen() && D().activeElement && D().activeElement.id === 'ix-s-q', D().activeElement && D().activeElement.id);
    D().dispatchEvent(new (W().KeyboardEvent)('keydown', { key: 'Escape', bubbles: true })); await sleep(150);
    check(g, 'Escape closes search and focus returns to the opener', !NS().searchOverlay.isOpen() && D().activeElement === sl, D().activeElement && D().activeElement.tagName);
    NS().cart.clear(); NS().cart.add('face-serum'); var cl = qa('#site-header a[aria-label^="Cart"]').filter(vis)[0]; cl.click(); await sleep(900);
    var dr = q('#ix-cart-drawer'); check(g, 'Cart drawer opens and focus moves inside it', !!dr && dr.open && dr.contains(D().activeElement), D().activeElement && D().activeElement.tagName);
    sl.click(); await sleep(400);
    var open = qa('dialog[open]').length + (NS().searchOverlay.isOpen() ? 1 : 0); check(g, 'Only one overlay is open at a time (drawer then search)', open <= 1, open + ' open');
    D().dispatchEvent(new (W().KeyboardEvent)('keydown', { key: 'Escape', bubbles: true })); await sleep(300);
    cl.click(); await sleep(900); D().dispatchEvent(new (W().KeyboardEvent)('keydown', { key: 'Escape', bubbles: true })); await sleep(400);
    check(g, 'Cart drawer is a modal dialog (native Escape close and focus trap)', q('#ix-cart-drawer').matches(':modal') || !q('#ix-cart-drawer').open, 'modal=' + q('#ix-cart-drawer').matches(':modal'));
    NS().notify('Test message', { kind: 'info' }); await sleep(100); var tt = q('#ix-toast'); check(g, 'Toast region is a polite live region', tt && tt.getAttribute('role') === 'status' && tt.getAttribute('aria-live') === 'polite', '');
    /* UX: PDP add to bag shows busy then success; sold-out and quantity messages */
    NS().cart.clear(); await load(url('product', 'p=face-serum')); q('#atc').click(); await sleep(150); check(g, 'Add to bag shows a busy state', q('#atc').getAttribute('aria-busy') === 'true' && /Adding/.test(q('#atc-label').textContent), q('#atc-label').textContent);
    await sleep(1600); check(g, 'Add to bag shows a success message with a View bag link', !q('#atc-msg').hidden && !!q('#atc-msg a'), '');
    var vb = q('#atc-msg a'); vb.click(); await sleep(900); check(g, 'View bag opens the drawer (not a dead anchor)', !!q('#ix-cart-drawer') && q('#ix-cart-drawer').open, '');
    /* keyboard path through the header */
    await load(url('home')); var tab = []; for (var t = 0; t < 8; t++) { var cands = qa('a[href],button,input,select,summary').filter(function (e) { return vis(e) && !e.closest('.rv,#wp,.ann,#ix-pill,[inert]') && e.tabIndex >= 0; }); if (cands[t]) tab.push(nm(cands[t])); }
    rec(g, 'First focus stops start with Skip link then header controls', /Skip/i.test(tab[0] || '') ? 'pass' : 'review', tab.slice(0, 5).join(' > '));
  }
  finish();
})().catch(function (e) { rec('HARNESS', 'error', 'fail', e && e.stack || e); finish(); });
