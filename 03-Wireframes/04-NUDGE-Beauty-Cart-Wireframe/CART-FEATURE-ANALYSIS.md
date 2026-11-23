# NUDGE Beauty: Cart page and cart drawer, feature analysis and audit

Files in this folder: `Cart_Page_Wireframe_v1.html` (full cart page) and `Cart_Drawer_Wireframe_v1.html` (slide-in drawer, drawn over a generic page). Two separate wireframes; both single responsive files with review chrome (annotations, width preview, state buttons) and sample content only. Placeholders only: no photography.

## 1. Source and method

- **Authority:** `Homepage_CRO_5_Theme_Final_Comparison_Revised_Final.xlsx` (project root), sheet *Beauty - PLP, PDP & Cart*: **Cart 25 Yes, 2 No**. Cross-checked against *Cart Additional CRO Recs*, *Removed - PLP, PDP, Cart* (Cart rows 56 to 79), *Notes* and the Plan and Task Guide text. The brief names `Homepage_CRO_5_Theme_Final_Comparison.xlsx`; the project holds only the revised file, so that was used. The workbook was read only, never modified.
- Limits: the Plan and Guide PDFs were read as text only (figures not seen); no live Prestige or Motion research was done; no conversion data exists.

## 2. Feature checklist (Beauty)

### Included (25 Yes)
| # | Feature | Cart page | Drawer |
|---|---|---|---|
| 1 | Cart drawer (optional, merchant-controlled, separate) | n/a | Built |
| 2 | Full cart page (Essential) | Built | n/a |
| 3 | Title and item count | Title with count | Title with count |
| 4 | Free-shipping progress bar | Above the lines | Top of the body |
| 5 | Lines: image, title, variant, price, quantity | Built | Built |
| 6 | Quantity stepper, live update | Built | Built |
| 7 | Remove, one tap | Built | Built |
| 8 | Remove with undo, no dialog | Built | Built |
| 9 | Line price, compare-at, saving | Built | Built |
| 10 | Real stock warning on lines | Serum line, 3 left | Same |
| 11 | Delivery estimate date | Summary (computed from sample settings) | Page only |
| 12 | Native upsell, one or two low-priced items | Two rows | Two rows |
| 13 | Order note and gift message | Collapsed row | Page only |
| 14 | Subtotal, discount and saving | Summary | Foot |
| 15 | Taxes and shipping note | Summary | Foot |
| 16 | Checkout button with lock icon | Summary | Foot, fixed |
| 17 | Express payment buttons | Slot under the button | Page only |
| 18 | Trust line, secure checkout, payment icons | Once, in the summary | One short line |
| 19 | Returns and shipping policy links | Summary | Page only |
| 20 | Customer support contact link | Summary | Page only |
| 21 | Continue shopping, quiet link | Header link | Foot link |
| 22 | Sticky checkout bar (phones) | Built | Not needed: the foot is always fixed |
| 23 | Empty state with best-seller and collection links | Built | Built |
| 24 | Mobile-first layout, large tap targets | Built | Built |
| 25 | Gift card template | Not a cart section; a separate template page (out of scope here) | n/a |

### Excluded (No or Removed) and not drawn
Change size or option in the cart (No for Beauty); installment messaging (No); discount code box (Removed: Shopify accepts codes at checkout); gift wrap or free gift line (Removed: needs discount logic); frequently bought together, bundle and recommended blocks as separate features (Removed: merged into the native upsell); items-reserved timer (Removed: fake urgency); save for later, quantity discounts, shipping-protection add-ons, shipping rate calculator, live chat (Removed: app or not native).

### Improved
Continue shopping stays a quiet link so it never competes with checkout. The cart count lives in the title, not a second badge. Trust is stated once. The drawer keeps only what a quick review needs; note, express buttons, policy links and delivery estimate stay on the page.

### Optional, not added
Nothing beyond the workbook was added.

## 3. Conflicts with the brief (decisions to confirm)
- **Discount or promo code:** the brief lists it; the workbook marks it Removed. Not drawn.
- **Gift wrapping:** Removed (free gift line); the approved gift route is the order note and gift message, drawn on the page. Not in the drawer; say if you want it there.
- **Frequently bought together:** merged into the cart upsell; drawn as up to two low-priced add-on rows.
- **Empty-state illustration:** the brief asks for one; the standing wireframe rule is placeholders only, so the empty state is typographic with a message, a button and collection links.
- **Brief file name:** see section 1.
- Palette, typography and sentence-case headings follow the Homepage, PLP and PDP (warm greige placeholders from the PDP revision).

## 4. Design System reuse and additions
Reused: Button, Quantity, Message, Drawer (with `drawer.js`), Chip, Price, Link, Divider, Field and Input, Icon, container and tokens. No tokens added; the two warm greige tones are page-level mixes of existing tokens (as on the PDP). Page-level additions, proposed for the Design System: cart line, free-shipping bar, undo notice, upsell row, order summary panel, sticky checkout bar, two icons (lock, loader).

## 5. Structure
**Cart page:** header (title and count, Continue shopping link), free-shipping bar, lines list with column labels from 768 px, order note, upsell, order summary (sticky beside the lines from 1024 px) with subtotal, saving, note, delivery estimate, checkout, express slot, trust line and links; empty state; sticky checkout bar on phones.
**Cart drawer:** header (title with count, close), added confirmation, free-shipping bar, undo notice, lines, upsell, fixed foot (subtotal, saving, note, checkout, View cart and Continue shopping links, secure line); empty state.

## 6. Responsive
| Width | Page | Drawer |
|---|---|---|
| 1920, 1440 | Lines (7/12) beside a sticky summary (4/12) | Right-hand panel at the drawer width token |
| 1024 | Same | Same |
| 768 (tablet) | One column; each line in a single row; summary below | Right-hand panel |
| 390, 375, 320 | Stacked lines (image beside details, quantity underneath); summary below; sticky checkout bar | Full-width sheet; body scrolls on its own; foot and close stay on screen |

## 7. Interaction states built
Page: 3 items, 1 item, free shipping reached, long cart (6), remove with undo, empty, quantity changes (live), low-stock cap, add upsell. Drawer: empty, single product added (confirmation), multiple (3), long list (8, scrolls), quantity updated, remove with undo, upsell add, free-shipping progress and reached.

## 8. Shopify compatibility
Native: cart lines, quantities, compare-at prices, line and cart discounts, cart note, cart recommendations, additional checkout buttons, checkout, inventory. Theme editor settings: free-shipping threshold, drawer or page, upsell on or off, express buttons on or off, sticky bar. Custom theme JavaScript on the Cart Ajax API (to be built): live quantity update, remove with undo, drawer open after add, free-shipping bar, delivery estimate. Needs an app or excluded: discount-code box, save for later, quantity discounts, live chat, shipping calculator.

## 9. Audit
**Automated checks** (in-page `?selftest=1` in an exact-width frame at 1920, 1440, 1024, 768, 390, 375 and 320 px): **Cart page 11 of 11 and Cart drawer 9 of 9 pass at every width.** Page: no overflow, one visible H1, layout (two columns with sticky summary, or stacked; row or stacked lines), live update and header count, remove with undo, free-shipping progress and reached state, stock note and cap, empty state, excluded wording absent, sticky bar behaviour, 44 px targets and fonts. Drawer: panel width and no horizontal scroll, long list scrolls inside with checkout and close always on screen, live update, remove with undo and focus to Undo, free-shipping and upsell, added and empty states, focus return on close, excluded wording absent, 44 px targets and fonts.
**Reviewed visually:** page at 1440 and 390; drawer at 1440 and 390 (long list). Not reviewed: tablet screenshots, empty states and the sticky bar as images.
**Not run:** contrast measurement, touch-emulation runs.
**Untouched:** Homepage, PLP, PDP, Design System, tokens and the CRO workbooks were not modified by this build.
## 10. Audit corrections (2026-11-16, approved)

Made after the page-by-page audit, on the user's approval. A typed quantity above stock is capped with a message on the line, on the page and in the drawer ("Only 3 available. Quantity set to 3."; the message clears on the next edit); a line with more than one unit shows its price each; the drawer foot is tighter on phones (about 243 px, from about 279 px); the page's cart icon is a link and footer links are 44 px (the wireframes were rebuilt from the corrected Homepage header and footer). Kept as decided: the order note and gift message stay on the page only. The gift card template is still not wireframed (it is a template page, outside the four pages). Self-test: page 12 of 12 and drawer 10 of 10 at 1920, 1440, 1024, 768, 390, 375 and 320 px.
