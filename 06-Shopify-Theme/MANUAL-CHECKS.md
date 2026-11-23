# NUDGE Beauty theme: checks completed and checks still pending

Last updated 2026-11-17. "Automated" means a script in `tools/` ran it in headless Chrome (real browser, real rendering, LiquidJS standing in for Shopify). Nothing has been pushed to any Shopify store.

## A. Completed (automated, repeatable)
| # | Check | Tool | Result |
|---|---|---|---|
| A1 | Liquid, schema and Theme Editor rules (own linter) | `lint-theme.ps1` | 0 errors, 0 warnings |
| A2 | Rendered markup equals the approved wireframe (19 Homepage elements, cart drawer in 5 states) | `compare-theme.ps1` | all equal |
| A3 | Pixels, whole Homepage at 1920, 1440, 1280, 1024, 768, 390, 320 px | `theme-pixel-diff.ps1` | 0.01% to 0.02% differ |
| A4 | Cart drawer pixels against the approved drawer at 1440 and 390 px (real click opens it) | `test-drawer-visual.ps1` | 0.00% differ |
| A5 | Every section renders when freshly added from its preset and when emptied | `test-presets.ps1` | 17 of 17, both modes |
| A6 | Homepage behaviour (tabs, finder, pins, ritual, slider, scrollers, newsletter, video, footer accordion, announcement) | `test-homepage.ps1` | clean at 5 widths |
| A7 | Cart drawer logic against a mock of Shopify's AJAX cart and Section Rendering APIs | `test-cart.ps1` | 23 of 23 at 2 widths |
| A8 | Mega menu and mobile drawer (synthetic events) | `test-mega.ps1 -File` | clean at 6 widths |
| A9 | Real mouse, touch and keyboard input; focus trap and focus return; accessibility tree (landmarks, one H1, names, lists, ids, targets) | `test-input.ps1` | 46 of 46 |
| A10 | axe-core in default, mega-menu-open, mobile-drawer-open and cart-drawer-open states | `test-axe.ps1` | 0 violations |
| A11 | Colour contrast of the 20 solid text/background token pairs the theme uses | `test-contrast.ps1` | all meet WCAG 2.2 AA |
| A12 | The 16 wireframe pages are unchanged | `check-equivalence.ps1`, `test-engine.ps1` | 16 of 16, engine tests pass |
| A13 | Checkout lock icon: one `icon-lock` symbol per page, drawn in the theme and the wireframe | probe + A4 | done (see "Changes" below) |

### Keyboard fixes in `nav.js` and `theme.js` (verified by A8, A9 and A6)
Mega panels no longer open on keyboard focus (Tab moves Skin, Makeup, Hair, Body; ArrowDown or Space opens a panel and moves into it; Escape closes it and does not re-open it); footer column headings are not focusable on desktop. Checked with real key events (Tab, Shift+Tab, Enter, Space, Escape, ArrowDown) plus the existing navigation and drawer suites: no regression.

### Dialog `close` event: test-only workaround
Headless Chrome does not reliably fire the `<dialog>` `close` event that `drawer.js` uses to return focus. `test-cart.ps1` (mock API) therefore dispatches that event by hand when the browser did not, and prints that it did. This lives only in the test. The real-input test (A9) has no workaround and passes: a real Escape closes the drawer, the real `close` event fires and focus returns to the cart button. `drawer.js` is unchanged (generated from the Design System).

## B. Pending: needs a Shopify store (not allowed yet)
| # | Check | Why it cannot be done here |
|---|---|---|
| S1 | Shopify Theme Check | Needs Shopify CLI (not installed) or a store |
| S2 | Theme Editor: add, reorder, remove, edit sections and blocks; live preview reloads (`shopify:section:load`) | Needs a store |
| S3 | Real cart: `/cart/change.js`, `/cart/add.js`, `/?sections=cart-drawer`, stock errors, discounts, selling plans | Only tested against a mock |
| S4 | Markets and the country selector (real `localization` object, form post and redirect) | Only tested with fixtures |
| S5 | Customer form for the newsletter (customer created, tagged `newsletter`, consent) | Needs a store |
| S6 | Performance on a real theme (Lighthouse, Core Web Vitals) | Needs a deployed theme |

## C. Pending: assistive technology (needs a person)
For each, test at desktop width and phone width. Record pass/fail and notes in the last column.
| # | Tool | Tasks | Status |
|---|---|---|---|
| T1 | NVDA + Firefox and Chrome (Windows) | Skip link; landmarks list; headings list (one H1); open Skin mega menu and reach a link; country selector; open cart drawer, hear its title and item count, change a quantity, hear the update, remove and undo; Escape returns focus; newsletter error message is announced | **Pending** |
| T2 | JAWS + Chrome (Windows) | Same tasks as T1 | **Pending** |
| T3 | VoiceOver + Safari (macOS) | Same tasks; rotor lists for landmarks, headings, links | **Pending** |
| T4 | VoiceOver + Safari (iOS) | Mobile menu drawer, accordion rows, cart drawer, finder quiz, before/after slider (arrow keys / swipe), ritual scroller buttons | **Pending** |
| T5 | TalkBack + Chrome (Android) | Same as T4 | **Pending** |
Known things to listen for: the announcement bar message change (live region), the mega menu link count, the before/after slider's spoken value ("% before, % after"), the cart count in the header button name.

## D. Pending: physical devices (needs a person)
| # | Device | Tasks | Status |
|---|---|---|---|
| D1 | iPhone (Safari) | Tap targets, drawer menu, accordion, scrollers by swipe, before/after slider drag, cart drawer, keyboard type for the email field, safe areas | **Pending** |
| D2 | Android phone (Chrome) | Same as D1 | **Pending** |
| D3 | iPad / Android tablet, portrait and landscape | 768 and 1024 breakpoints: first tap opens a mega panel, second tap follows the link | **Pending** |
| D4 | Laptop with a touchscreen | Hover and touch together; mega menu behaviour | **Pending** |

## E. Colour contrast: what is left for a person
| # | Item | Status |
|---|---|---|
| E1 | Solid token pairs (text, links, buttons, status colours, borders, focus ring) | **Done** (A11, 20 of 20 pass) |
| E2 | Text over gradients: hero label and text on the campaign image, placeholder labels, category and product placeholder captions | **Pending** (axe cannot compute; check with real photography, because contrast depends on the photo) |
| E3 | Text over the translucent scrims and overlapped areas (mega menu scrim, drawer backdrop) | **Pending** |
| E4 | Footer text on the dark background with images/hover states | Token pairs pass (A11); hover/pressed states **Pending** |
Tool suggestion: the Colour Contrast Analyser, or browser DevTools contrast picker, on the live page with the merchant's real images.

## F. Pending decisions and confirmations
| # | Item | Status |
|---|---|---|
| P1 | **Product metafield names** (`custom.size`, `custom.highlight`, `reviews.rating`, `reviews.rating_count`, tag `badge:<text>`) are placeholders and are marked as such in `snippets/product-card-home.liquid`. Do not rename until the merchant confirms their real definitions. | **Pending merchant confirmation** |
| P2 | CSS is the interim extracted Tailwind output (`assets/theme.css`). Not switching to the Tailwind CLI without approval. | **Pending approval** |
| P3 | Development store push | **Not authorised** |
| P4 | PLP, PDP, Cart page and the 12 other wireframe pages are not converted to Liquid yet | **Not started** |

## Changes made in this round
- `05-Assets/Icons`: added `lock.svg` (Lucide `lock`, 24 x 24, 1.5 stroke, same as the set) through `build-icons.ps1`; `sprite.svg` and the Design System page sprite regenerated (29 icons); `foundations.md` count updated.
- Wireframes: the shared sprite partial gets the symbol; the Cart page and Cart drawer wireframes carried their own local copy of the same symbol (comment: "proposed for 05-Assets/Icons/sprite.svg"), which would now duplicate the id, so the local copies were removed. Correction to an earlier statement: the Checkout icon was **not** blank in those two wireframes (it was only blank in the theme, whose sprite is built from the shared set). All 16 wireframe pages now have exactly one `icon-lock`, the stored baselines were refreshed for that reason only (each page equals its old baseline apart from the symbol), and the pages still pass their equality check.
- Theme: Checkout icon verified (symbol defined once; drawn 18 x 20 in the 24 px box). Found by the new drawer pixel test and fixed: the drawer's icons are explicitly 20 px (`size-5`) like the approved drawer (the theme's default icon size is the Homepage's 24 px), and the drawer carries `leading-normal` while the page body's relaxed line height (`leading-relaxed`) now applies on the Homepage only, as in the wireframes.