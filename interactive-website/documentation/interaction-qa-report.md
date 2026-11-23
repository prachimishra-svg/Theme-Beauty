# Interaction QA report

Generated 2026-11-18 19:23 from documentation/data/test-results.json (journeys), a11y-overlays.json and a11y-pages.json.

## Totals

| Measure | Count |
|---|---|
| Interactions and checks run | 522 |
| PASS | 521 |
| FAIL | 0 |
| PENDING | 0 |
| BLOCKED | 1 |

## User journeys (real clicks and typing in headless Chrome)

| Journey group | Checks | PASS | FAIL | BLOCKED |
|---|---|---|---|---|
| J0 link coverage | 16 | 16 | 0 | 0 |
| J1 Home to Checkout | 12 | 12 | 0 | 0 |
| J2 Category to PDP | 6 | 6 | 0 | 0 |
| J3 Search | 10 | 10 | 0 | 0 |
| J4 Blog | 7 | 6 | 0 | 1 |
| J5 PDP related | 4 | 4 | 0 | 0 |
| J6 Cart | 13 | 13 | 0 | 0 |
| J7 Drawer page | 4 | 4 | 0 | 0 |
| J8 History | 6 | 6 | 0 | 0 |
| J9 Footer | 17 | 17 | 0 | 0 |
| J10 Responsive | 33 | 33 | 0 | 0 |

The requested journeys map to groups: Shopping = J1, Search = J3, Navigation = J2 and J8, Blog = J4, Cart = J6 and J7, history and refresh = J8, responsive = J10. Open the full list in interaction-testing-report.md.

## Overlays, keyboard and feedback

| Result | Check | Evidence |
|---|---|---|
| PASS | Search opens and focus moves into the field | ix-s-q |
| PASS | Escape closes search and focus returns to the opener | A |
| PASS | Cart drawer opens and focus moves inside it | BUTTON |
| PASS | Only one overlay is open at a time (drawer then search) | 1 open |
| PASS | Cart drawer is a modal dialog (native Escape close and focus trap) | modal=true |
| PASS | Toast region is a polite live region |  |
| PASS | Add to bag shows a busy state | Adding… |
| PASS | Add to bag shows a success message with a View bag link |  |
| PASS | View bag opens the drawer (not a dead anchor) |  |
| PASS | First focus stops start with Skip link then header controls | a "Skip to content" > button#ann-prev "" > button#ann-next "" > a "" > a "Skin" |

## Accessibility rules on all 16 pages (1440 and 390 px)

| Rule | Pages passing | Pages failing |
|---|---|---|
| html has a lang attribute | 32 | 0 |
| Exactly one visible h1 | 32 | 0 |
| Heading order has no skipped levels | 32 | 0 |
| Landmarks present (header, main, nav, footer) | 32 | 0 |
| Every button has an accessible name | 32 | 0 |
| Every link has an accessible name | 32 | 0 |
| Every form field has a label | 32 | 0 |
| Every image has alt text | 32 | 0 |
| No duplicate ids | 32 | 0 |
| aria-controls point at existing elements | 32 | 0 |
| Skip link exists and its target exists | 32 | 0 |
| Focus indicator visible on the first 14 controls | 32 | 0 |

### Accessibility failures in the final run

None.

## UX rules

* One overlay at a time: opening search closes the cart drawer and the reverse (fixed; checked above).
* Add to bag: busy state, success message with "View bag", sold-out and quantity limit messages (journeys J5, J6, overlays).
* Notices for features that do not exist are short, polite live-region toasts that auto-dismiss.
* Not tested: colour contrast ratios, screen reader output, real assistive technology, prefers-reduced-motion, high-contrast mode (NOT TESTED).