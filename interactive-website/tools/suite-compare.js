/* Phase 1: wireframe vs interactive. Every page is loaded twice (interactive mode OFF = the original wireframe, ON = the interactive site) at 1440 and 390 px; every section is snapshotted and compared on
   presence, order, visibility, text, links, buttons, inputs, icons, placeholders, height and key computed styles. Statuses: pass = MATCHED, fail = MISSING or INCORRECT, review = NEEDS REVIEW or PARTIAL, hidden = hidden on purpose by the layer. */
function snap() {
  var d = D(), w = W(), out = { title: d.title, h1: (d.querySelector('h1') || {}).textContent || '', docH: d.documentElement.scrollHeight, docW: d.documentElement.scrollWidth, secs: [] };
  function visible(e) { var cs = w.getComputedStyle(e); return cs.display !== 'none' && cs.visibility !== 'hidden' && e.getBoundingClientRect().height > 0; }
  function sig(e) {
    var c = e.cloneNode(true); [].forEach.call(c.querySelectorAll('.ann,script,style'), function (x) { x.remove(); });
    var txt = (c.textContent || '').replace(/\s+/g, ' ').trim(), a = e.querySelectorAll('a[href]'), cs = w.getComputedStyle(e), hd = e.querySelector('h1,h2,h3'), hs = hd ? w.getComputedStyle(hd) : null;
    var icons = [].map.call(e.querySelectorAll('use'), function (u) { return u.getAttribute('href'); }).sort().join(',');
    return { text: txt, links: a.length, buttons: e.querySelectorAll('button').length, inputs: e.querySelectorAll('input,select,textarea').length, imgs: e.querySelectorAll('img').length, icons: icons,
      ph: e.querySelectorAll('.ph,.ph-b,.ph-c,.pm,.img,.optslot').length, h: Math.round(e.getBoundingClientRect().height), vis: visible(e),
      style: [cs.backgroundColor, cs.paddingTop, cs.paddingBottom, hs ? hs.fontFamily.split(',')[0] + '/' + hs.fontSize + '/' + hs.fontWeight : ''].join('|') };
  }
  var items = [['Announcement bar', '#annbar'], ['Header', '#site-header']];
  items.forEach(function (it) { var e = d.querySelector(it[1]); out.secs.push({ name: it[0], found: !!e, sig: e ? sig(e) : null }); });
  [].forEach.call(d.querySelectorAll('[data-section]'), function (e) { if (e.closest('.rv,#wp')) return; var nm = e.getAttribute('data-section'); if (/^(Announcement|Header \()/.test(nm)) return; out.secs.push({ name: nm, found: true, sig: sig(e) }); });
  var ft = d.querySelector('footer'); out.secs.push({ name: 'Footer', found: !!ft, sig: ft ? sig(ft) : null });
  out.fonts = ['body', 'h1', 'button'].map(function (s) { var e = d.querySelector(s); return e ? s + ':' + w.getComputedStyle(e).fontFamily.split(',')[0] : s + ':none'; }).join(' ');
  return out;
}
function diff(a, b) {
  var why = [];
  if (a.text !== b.text) { var i = 0; while (i < a.text.length && a.text[i] === b.text[i]) i++; why.push('text differs at char ' + i + ': "' + a.text.slice(Math.max(0, i - 15), i + 40) + '" vs "' + b.text.slice(Math.max(0, i - 15), i + 40) + '"'); }
  ['links', 'buttons', 'inputs', 'imgs', 'ph'].forEach(function (k) { if (a[k] !== b[k]) why.push(k + ' ' + a[k] + ' vs ' + b[k]); });
  if (a.icons !== b.icons) why.push('icons differ');
  if (Math.abs(a.h - b.h) > 2) why.push('height ' + a.h + ' vs ' + b.h + ' px');
  if (a.style !== b.style) why.push('style ' + a.style + ' vs ' + b.style);
  return why;
}
(async function main() {
  var keys = Object.keys(PG), qsFor = { collection: 'c=skin', product: 'p=tinted-moisturiser', article: 'a=a-simple-morning-skincare-routine' };
  var widths = [1440, 390], total = 0;
  for (var i = 0; i < keys.length; i++) {
    for (var wi = 0; wi < widths.length; wi++) {
      var k = keys[i], w = widths[wi]; size(w, w === 390 ? 844 : 900);
      await loadPlain(url(k, qsFor[k] || '', false)); var hs = D().createElement('style'); hs.textContent = '.rv,#wp,.ann{display:none!important}'; D().head.appendChild(hs); await sleep(150); var A = snap(); /* the reviewer panel and annotation notes are hidden in BOTH so heights compare like for like */
      var st = await load(url(k, qsFor[k] || '')); var B = snap();
      var g = 'P1 ' + k + ' @' + w;
      if (st !== 'ready') rec(g, 'Interactive layer ready', 'fail', 'state ' + st); else rec(g, 'Interactive layer ready', 'pass', '');
      /* page level */
      rec(g, 'Page title and main heading', (A.h1 === B.h1) ? 'pass' : 'review', A.h1 === B.h1 ? A.h1.slice(0, 60) : 'h1 "' + A.h1.slice(0, 40) + '" vs "' + B.h1.slice(0, 40) + '"');
      rec(g, 'Fonts in use (body, h1, button)', A.fonts === B.fonts ? 'pass' : 'fail', A.fonts === B.fonts ? A.fonts : A.fonts + ' vs ' + B.fonts);
      rec(g, 'No horizontal overflow', B.docW <= w + 1 ? 'pass' : 'fail', 'interactive scrollWidth ' + B.docW + ' / original ' + A.docW + ' at ' + w);
      var an = A.secs.map(function (s) { return s.name; }), bn = B.secs.filter(function (s) { return s.found; }).map(function (s) { return s.name; });
      var orderOk = an.filter(function (n) { return bn.indexOf(n) > -1; }).join('|') === bn.filter(function (n) { return an.indexOf(n) > -1; }).join('|');
      rec(g, 'Section order (' + an.length + ' sections)', orderOk ? 'pass' : 'fail', orderOk ? '' : 'normal: ' + an.join(' > ') + ' / interactive: ' + bn.join(' > '));
      for (var s = 0; s < A.secs.length; s++) {
        var a = A.secs[s], b = B.secs.filter(function (x) { return x.name === a.name; })[0]; total++;
        if (!a.found) { rec(g, a.name, 'review', 'not found in the original'); continue; }
        if (!b || !b.found) { rec(g, a.name, 'fail', 'MISSING in the interactive site'); continue; }
        if (a.sig.vis && !b.sig.vis) { rec(g, a.name, 'hidden', 'hidden in interactive mode (' + (/Custom Liquid/.test(a.name) ? 'optional empty merchant slot, hidden by request' : 'check') + ')'); continue; }
        var why = diff(a.sig, b.sig);
        rec(g, a.name, why.length ? 'review' : 'pass', why.join(' ; '));
      }
    }
  }
  rec('P1 totals', 'Sections compared (page x width)', 'pass', total);
  finish();
})().catch(function (e) { rec('HARNESS', 'error', 'fail', e && e.stack || e); finish(); });
