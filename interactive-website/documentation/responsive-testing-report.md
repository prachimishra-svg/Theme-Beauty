# Responsive testing report

Generated 2026-11-18 19:23 from documentation/data/responsive-*.json (tools/suite-responsive.js).

Each viewport is an iframe of that exact width and height in headless Chrome 157 on Windows (the same technique the project's own self-tests use, because headless Chrome cannot open a window narrower than about 500 px or wider than the screen). Every page is loaded through the interactive site.

## Totals

| Measure | Count |
|---|---|
| Viewports tested (width x height) | 28 |
| Checks run | 1550 |
| PASS | 1550 |
| FAIL | 0 |

## Viewports tested

1024x768, 1280x800, 1366x768, 1440x900, 1600x900, 1920x1080, 2048x1152, 2560x1440, 3440x1440, 600x1024, 768x1024, 820x1180, 834x1194, 1024x1366, 1180x820, 1194x834, 1024x600, 320x568, 360x780, 375x667, 390x844, 393x852, 414x896, 430x932, 844x390, 667x375, 3840x2160, 5120x2880

## Result by group and page

| Group | Page | Viewports | Checks | PASS | FAIL |
|---|---|---|---|---|---|
| desktop | home | 6 | 42 | 42 | 0 |
| desktop | collection | 6 | 30 | 30 | 0 |
| desktop | product | 6 | 42 | 42 | 0 |
| desktop | cart | 6 | 30 | 30 | 0 |
| desktop | blog | 6 | 30 | 30 | 0 |
| desktop | article | 6 | 30 | 30 | 0 |
| ultra | home | 3 | 24 | 24 | 0 |
| ultra | collection | 3 | 18 | 18 | 0 |
| ultra | product | 3 | 24 | 24 | 0 |
| ultra | cart | 3 | 18 | 18 | 0 |
| ultra | blog | 3 | 18 | 18 | 0 |
| ultra | article | 3 | 18 | 18 | 0 |
| tablet | home | 9 | 67 | 67 | 0 |
| tablet | collection | 9 | 49 | 49 | 0 |
| tablet | product | 9 | 67 | 67 | 0 |
| tablet | cart | 9 | 49 | 49 | 0 |
| tablet | blog | 9 | 49 | 49 | 0 |
| tablet | article | 9 | 49 | 49 | 0 |
| mobile | home | 9 | 79 | 79 | 0 |
| mobile | collection | 9 | 61 | 61 | 0 |
| mobile | product | 9 | 79 | 79 | 0 |
| mobile | cart | 9 | 61 | 61 | 0 |
| mobile | blog | 9 | 61 | 61 | 0 |
| mobile | article | 9 | 61 | 61 | 0 |
| tv | home | 2 | 16 | 16 | 0 |
| tv | collection | 2 | 12 | 12 | 0 |
| tv | product | 2 | 16 | 16 | 0 |
| tv | cart | 2 | 12 | 12 | 0 |
| tv | blog | 2 | 12 | 12 | 0 |
| tv | article | 2 | 12 | 12 | 0 |
| others | drawer | 7 | 41 | 41 | 0 |
| others | contact | 7 | 41 | 41 | 0 |
| others | faq | 7 | 41 | 41 | 0 |
| others | about | 7 | 41 | 41 | 0 |
| others | story | 7 | 41 | 41 | 0 |
| others | shipping | 7 | 41 | 41 | 0 |
| others | returns | 7 | 41 | 41 | 0 |
| others | privacy | 7 | 41 | 41 | 0 |
| others | terms | 7 | 41 | 41 | 0 |
| others | notfound | 7 | 41 | 41 | 0 |

## Checks run on every page and viewport

* No horizontal overflow (with the offending element named on failure), no overlapping sections, no clipped text, no broken images.
* Touch targets 40 px or more below 1024 px (non-interactive footer headings and whole-card stretched links are excluded, see below).
* On 2048 px and wider: the header container stays at the design system maximum instead of stretching.
* Menu button shown below 1024 px and hidden from 1024 px; heading size scales on phones.
* Search overlay and cart drawer fit the viewport and Checkout stays on screen (Homepage and PDP at every viewport).
* PLP filter drawer opens and fits at 390, 600, 768 and 1024 px (sidebar from 768 px).

## Failures in the final run

None.

## Issues found and fixed during this audit

* **Cart page empty state overflowed horizontally at 390 px and below** (scrollWidth 420 at 390, 385 at 320). Cause: the empty-state chip row (`chip-row justify-center`) was as wide as its content. This was already present in the original wireframe. Fixed in `src/cart-page.src.html` and `src/cart-drawer.src.html` (added `max-w-full`) and in the interactive drawer component; both pages rebuilt.
* The first run reported touch-target, clipped-text and overlap failures that were **false positives of the probe** (non-interactive footer headings at tablet width, whole-card stretched links, screen-reader-only text, side-by-side columns). The probe was corrected and the matrix re-run; nothing in the pages was changed for these.
* PLP filter drawer appeared off screen in the test because headless virtual time does not advance CSS keyframes; the original wireframe behaves identically. The test now finishes the animation and the drawer fits at all four widths.

## Large and ultra-wide displays

From 2048 px the page content stays inside the design system container (header container width is reported per viewport in the data file) and full-bleed sections span the screen; text line length and card grids do not stretch. At 3840 and 5120 px the layout is the desktop layout centred with wider margins; no separate TV layout exists in the wireframes. Whether that is acceptable for TV use is a design decision (see missing-features report).

## NOT TESTED

* Real devices, real touch input, real device pixel ratios above 1 (only the performance run uses DPR 2 for the mobile profile), pinch zoom and browser zoom.
* Safari, Firefox and Edge (Chrome 157 only).
* True orientation change events: portrait and landscape are tested as separate width x height pairs (for example 1024x1366 and 1024x768, 390x844 and 844x390).
* Dynamic browser toolbars on phones (visual viewport changes).
* Layout shift while images load: the wireframes use placeholders instead of images, so there are no image loads to shift (CLS from the page itself is in performance-audit.md).