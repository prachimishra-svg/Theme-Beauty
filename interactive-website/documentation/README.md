# NUDGE interactive website layer

A separate layer that makes the 16 wireframe pages behave like one e-commerce site. The wireframes are not merged, redrawn or duplicated.

**Open it:** `index.html` (sets interactive mode and opens the Homepage). Exit from the pill at the bottom left of any page. Opened directly, the wireframes behave as before.

## How it attaches
Two small dormant blocks in the shared foundation, both active only when interactive mode is on (`?ix=1`, the launcher flag, or a `window.name` starting `nudge`):

* the end of `03-Wireframes/00-Shared-Tailwind-Foundation/nav.js` loads `runtime/boot.js` (original: `tools/nav.js.original`);
* the end of `03-Wireframes/00-Shared-Tailwind-Foundation/tailwind.config.js` hides the reviewer panel, annotation notes and the empty Custom Liquid slot before first paint (original: `tools/tailwind.config.js.original`).

The layer loads as one file, `runtime/interactive.bundle.js` (built by `tools/build-bundle.ps1`; the test runners rebuild it). Add `&ix_dev=1` to load the individual modules instead.

## Structure
| Folder | Contents |
|--------|----------|
| `routing/` | `routes.js` (Shopify route table), `navigation-config.js` (the linking map in code), `route-resolver.js` (click interceptor) |
| `components/` | notification-system, search-overlay (new stand-in, needs sign-off), cart-drawer (wireframe 05's own markup), breadcrumbs, status-pill. Mobile menu: the existing `nav.js` and `drawer.js` are used as they are |
| `integrations/` | homepage, plp, pdp, cart (and drawer page), blog (listing and article), content pages |
| `state/` | store (localStorage with window.name fallback), cart, search, wishlist (API only), user (signed out) |
| `data/` | products, collections, blog; `plp-raw.js` and `collection-links.js` are generated from the wireframes by `tools/generate-data.ps1` |
| `documentation/` | missing-pages-and-interactions, page-linking-map, shopify-integration, interaction-testing-report, and the audit set: wireframe-vs-interactive-audit, responsive-testing-report, navigation-link-verification, interaction-qa-report, performance-audit, missing-features-and-dependencies, final-quality-assurance-report |
| `tools/` | audit-links, generate-data, build-bundle, journeys + run-journeys, run-suite with suite-compare / links / responsive / a11y / design, perf-cdp (DevTools Protocol), build-report, build-audit-reports |

## Re-run the checks
`.\tools\run-journeys.ps1` then `.\tools\build-report.ps1` for the journeys; `.\tools\run-suite.ps1 -Suite compare|links|responsive|a11y|design [-Only group]` and `.\tools\perf-cdp.ps1` for the audit; `.\tools\build-audit-reports.ps1` writes the audit documents from the measured data. Do not run two browser suites at once (timings and the shared profile).