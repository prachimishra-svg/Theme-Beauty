/* NUDGE chip row: keeps the focused chip fully visible in a horizontally scrolling .chip-row (phones).
   Why: browsers scroll a focused control into view only when it is completely hidden. A chip that is merely cut off at
   the edge keeps focus where it is, so a keyboard user would land on a half-visible chip with a clipped focus ring
   (measured in Chrome: a chip 57px past the edge did not scroll; a plain row of plain buttons behaves the same).
   Without this script everything still works; the focused chip just may stay partly hidden. */
(function () {
  'use strict';
  document.addEventListener('focusin', function (e) {
    var row = e.target.closest && e.target.closest('.chip-row');
    if (row && row.scrollWidth > row.clientWidth + 1) e.target.scrollIntoView({ block: 'nearest', inline: 'nearest' });
  });
})();
