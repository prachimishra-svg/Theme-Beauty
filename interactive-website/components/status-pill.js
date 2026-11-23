/* NUDGE interactive website: prototype status pill (bottom-left). It is NOT part of the design: it tells the reviewer interactive mode is on and offers Load sample cart, Reset prototype and Exit.
   It is a small fixed element outside the page layout and never covers page content at 390 px (it collapses to an icon-sized control). Hidden in print and when the URL has ?ix_pill=0. */
(function (g) {
  'use strict';
  var NS = g.NudgeSite;
  function mount() {
    if (document.getElementById('ix-pill') || /[?&]ix_pill=0/.test(g.location.search)) return;
    var d = document.createElement('details'); d.id = 'ix-pill'; d.className = 'print:hidden'; d.style.cssText = 'position:fixed;left:8px;bottom:8px;z-index:2147483100;font:var(--font-size-caption)/1.3 var(--font-body,inherit);background:var(--color-bg-inverse);color:var(--color-text-inverse);border-radius:var(--radius-pill);box-shadow:var(--shadow-md);max-width:15rem';
    d.innerHTML = '<summary style="cursor:pointer;padding:6px 10px;list-style:none;min-height:24px">Interactive prototype</summary><div style="display:flex;flex-direction:column;gap:2px;padding:0 6px 8px">'
      + '<button type="button" data-a="sample" style="all:unset;cursor:pointer;padding:6px 8px;min-height:24px">Load sample cart</button>'
      + '<button type="button" data-a="reset" style="all:unset;cursor:pointer;padding:6px 8px;min-height:24px">Reset prototype data</button>'
      + '<button type="button" data-a="exit" style="all:unset;cursor:pointer;padding:6px 8px;min-height:24px">Exit interactive mode</button></div>';
    d.addEventListener('click', function (e) {
      var a = e.target.getAttribute && e.target.getAttribute('data-a'); if (!a) return;
      if (a === 'sample') { NS.cart.sample(); NS.notify('Sample cart loaded: Tinted Moisturiser, Face Serum, Face Cleanser.', { kind: 'success' }); if (NS.routes.pageKey() === 'cart') g.location.reload(); }
      if (a === 'reset') { NS.store.reset(); NS.notify('Prototype data cleared (cart, search history).', { kind: 'success' }); if (NS.routes.pageKey() === 'cart') g.location.reload(); }
      if (a === 'exit') { try { g.localStorage.removeItem('nudge.interactive'); } catch (x) { /* blocked */ } g.name = ''; var u = new URL(g.location.href); u.searchParams.delete('ix'); g.location.href = u.href; }
      d.open = false;
    });
    document.body.appendChild(d);
  }
  NS.statusPill = { mount: mount };
})(window);
