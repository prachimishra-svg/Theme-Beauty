# Performance audit

Generated 2026-11-18 19:23 from documentation/data/perf.json (tools/perf-cdp.ps1).

**How it was measured.** Lighthouse and Node are not installed in this environment, so no Lighthouse score is reported and none is invented. The harness drives headless Chrome 157 through the DevTools Protocol and records, per page, mode and profile: First Contentful Paint, Largest Contentful Paint, Cumulative Layout Shift (layout-shift entries without recent input), Total Blocking Time (long tasks over 50 ms after FCP), an INP-style latency (the longest event duration after one real mouse click on the header search link, or Add to bag on the PDP), DOM node count, requests and bytes. **Original** = wireframe with the interactive layer off; **interactive** = layer on. **Desktop** = 1440x900, no throttling. **Mobile** = 390x844, device pixel ratio 2, 4x CPU slowdown (the Lighthouse mobile CPU setting; no network throttling because the pages load from local files, so load times exclude real network latency). One run per cell; timings vary by a few tens of milliseconds between runs.

## Measurements

| Page | Mode | Profile | FCP ms | LCP ms | CLS | TBT ms | INP-style ms | DOM nodes | Requests | KB loaded |
|---|---|---|---|---|---|---|---|---|---|---|
| home | original | desktop | 284 | 284 | 0.2711 | 0 | 0 | 2046 | 10 | 962 |
| home | original | mobile | 572 | 572 | 0 | 930 | 0 | 2046 | 10 | 962 |
| home | interactive | desktop | 296 | 296 | 0.0022 | 0 | 56 | 2105 | 14 | 1059 |
| home | interactive | mobile | 756 | 1484 | 0.0002 | 1062 | 256 | 2105 | 14 | 1059 |
| collection | original | desktop | 236 | 236 | 0.3736 | 0 | 0 | 1471 | 14 | 934 |
| collection | original | mobile | 620 | 620 | 0 | 686 | 0 | 1471 | 13 | 934 |
| collection | interactive | desktop | 212 | 380 | 0.0002 | 0 | 48 | 1530 | 17 | 1027 |
| collection | interactive | mobile | 1040 | 1924 | 0.0001 | 722 | 240 | 1530 | 16 | 1027 |
| product | original | desktop | 260 | 260 | 0.3115 | 5 | 0 | 1172 | 12 | 784 |
| product | original | mobile | 608 | 608 | 0.0001 | 949 | 0 | 1172 | 12 | 784 |
| product | interactive | desktop | 240 | 440 | 0.0002 | 3 | 48 | 1231 | 15 | 877 |
| product | interactive | mobile | 1156 | 2296 | 0.0001 | 990 | 0 | 1231 | 15 | 877 |
| cart | original | desktop | 208 | 208 | 0.2464 | 0 | 0 | 762 | 10 | 699 |
| cart | original | mobile | 652 | 652 | 0.0001 | 594 | 0 | 762 | 10 | 699 |
| cart | interactive | desktop | 192 | 332 | 0.0002 | 0 | 40 | 724 | 12 | 783 |
| cart | interactive | mobile | 568 | 1824 | 0.0006 | 756 | 184 | 724 | 12 | 783 |
| blog | original | desktop | 224 | 224 | 0.2505 | 0 | 16 | 747 | 11 | 686 |
| blog | original | mobile | 692 | 692 | 0.0001 | 412 | 0 | 747 | 11 | 686 |
| blog | interactive | desktop | 220 | 220 | 0.0018 | 0 | 40 | 806 | 15 | 783 |
| blog | interactive | mobile | 1060 | 1060 | 0.0001 | 418 | 176 | 806 | 15 | 783 |
| article | original | desktop | 224 | 224 | 0.1513 | 0 | 0 | 698 | 10 | 689 |
| article | original | mobile | 568 | 568 | 0.0001 | 497 | 0 | 698 | 10 | 689 |
| article | interactive | desktop | 224 | 224 | 0.0598 | 0 | 40 | 757 | 14 | 786 |
| article | interactive | mobile | 1036 | 1036 | 0.076 | 435 | 176 | 757 | 14 | 786 |

## What the numbers say

* **desktop / original (median of 6 pages):** FCP 224 ms, LCP 224 ms, CLS 0.2505, TBT 0 ms, INP-style 0 ms.
* **desktop / interactive (median of 6 pages):** FCP 220 ms, LCP 296 ms, CLS 0.0002, TBT 0 ms, INP-style 40 ms.
* **mobile / original (median of 6 pages):** FCP 608 ms, LCP 608 ms, CLS 0.0001, TBT 594 ms, INP-style 0 ms.
* **mobile / interactive (median of 6 pages):** FCP 1036 ms, LCP 1484 ms, CLS 0.0001, TBT 722 ms, INP-style 176 ms.

## Before and after the optimisations made in this audit

| Page | Profile | CLS before (layer on) | CLS after (layer on) | CLS original wireframe |
|---|---|---|---|---|
| home | desktop | 0.8068 | 0.0022 | 0.2711 |
| home | mobile | 1 | 0.0002 | 0 |
| collection | desktop | 1.0293 | 0.0002 | 0.3736 |
| collection | mobile | 0.9277 | 0.0001 | 0 |
| product | desktop | 0.7966 | 0.0002 | 0.3115 |
| product | mobile | 0.9279 | 0.0001 | 0.0001 |
| cart | desktop | 0.7576 | 0.0002 | 0.2464 |
| cart | mobile | 1.2407 | 0.0006 | 0.0001 |
| blog | desktop | 0.5961 | 0.0018 | 0.2505 |
| blog | mobile | 0.9279 | 0.0001 | 0.0001 |
| article | desktop | 0.5194 | 0.0598 | 0.1513 |
| article | mobile | 1.0038 | 0.076 | 0.0001 |

## Optimisations made in this audit

* **Layout shift caused by the layer fixed.** The reviewer panel and annotation notes were hidden from a deferred script after first paint, which moved the whole page (CLS 0.5 to 1.0 with the layer on). The hide rule now runs from `tailwind.config.js`, synchronously in `<head>`, before the body is parsed. Layer-on desktop CLS is now below the original wireframe's.
* **One request for the layer instead of 24.** `tools/build-bundle.ps1` concatenates the modules into `runtime/interactive.bundle.js`; the loader falls back to the modules if the bundle is missing.
* **No waiting for window load.** The layer starts when parsing finishes instead of after images and fonts.
* **Search overlay and cart drawer built while the browser is idle**, so the first click only reveals them (INP-style latency for the first search click fell from about 200 ms to the values above).
* **PDP pickers for products without shades are hidden before first paint**, so nothing jumps.

## Findings that are NOT fixed here, and why

* **Tailwind Play CDN script is the dominant cost.** Every page loads `tailwindcss-play-3.4.17.js` (about 400 KB) and compiles CSS in the browser, which is why TBT is high on the 4x CPU profile and why the original wireframe itself has CLS of 0.15 to 0.37 on desktop (unstyled content before the compile). The console reports "cdn.tailwindcss.com should not be used in production". The project rule is to keep the existing Tailwind implementation and not add a second version, so it was left as is. In the Shopify theme the CSS is compiled ahead of time; that removes this cost.
* **Pages the layer fills from shared state (PLP, PDP, Cart)** are held invisible until the layer is ready, so their CLS is about 0.000 with the layer on, at the cost of a later LCP (a few hundred milliseconds on desktop, about one to two seconds on the 4x CPU profile). Content is released after 6 seconds at the latest if the layer fails to load.
* **First click within about one second of loading the Homepage** can show the cart drawer's buttons unstyled for a moment: Tailwind Play must compile the drawer's classes on a page with about 2,000 nodes. The overlays are built while idle to avoid this; a person normally clicks later. Not reproduced after three seconds (design suite, 35 of 35).
* **Images:** the wireframes have no photographs (labelled placeholders by design), so image formats, responsive `srcset`, lazy loading and dimension attributes cannot be audited here; the images table in the Shopify theme task covers them.
* **Fonts:** the pages use the project's font files; font-display and preload were not changed.
* **Unused CSS and duplicate components:** the compiled-in-browser CSS cannot be measured for unused rules. The layer adds no CSS file; it reuses existing classes.
* **Unminified layer:** the bundle is about 81 KB uncompressed (it is local; Shopify serves compressed assets, and the layer is not part of the theme).

## Measured but not in scope of these numbers

* Lighthouse performance score, INP from real users, CrUX field data: NOT TESTED.