# NUDGE Beauty: PDP feature analysis, structure, design-system audit and final check

Wireframe: [PDP.html](PDP.html) (one responsive file, same folder). Written 2026-11-12.

**Authority used.** The approved Yes/No list is the **Beauty column of the revised five-theme workbook** (`Homepage_CRO_5_Theme_Final_Comparison_Revised_Final.xlsx`, sheet *Beauty - PLP, PDP & Cart*: PDP **33 kept, 14 not recommended**). It is the later document, it records Yes and No, and the Homepage and PLP were built to it. The original CRO research and the CRO matrix supply the **customer-feedback evidence**. Where your brief asks for something the workbook marks No or Removed, section 1.5 lists the choice made and how to reverse it.

## 0. What was read, and the limits

| Source | Read | Used for |
|---|---|---|
| `Homepage_CRO_5_Theme_Final_Comparison_Revised_Final.xlsx` | Beauty PDP rows (47), PDP Additional CRO Recs, Removed sheet (PDP rows), Notes, Revision Log | Yes/No, role, configuration, limits, removals, document conflicts |
| `04-CRO-Research/CRO-Comparison/NUDGE_Beauty_CRO_Feature_Decision_Matrix.xlsx` | PDP tab (PDP-01 to PDP-27, ADD-07 to ADD-14) | Priority, initial release, customer-feedback IDs |
| `04-CRO-Research/Documentation/pdp-cro-plan.md` | P0 and P1 items, source companies, feedback | Negative feedback per PDP item |
| `Plan Sheet/Nudge-Theme-Plan.pdf` | Text extracted: product page components and variants per preset (gallery, product info, variant picker, buy buttons, sticky add to cart, pickup, delivery estimate), section 4.1 Beauty, section 4.6 mistake and rule table, captions of the theme captures | Component variants, Beauty configuration, rules |
| `Plan Sheet/Nudge-Task-Guide-Team.pdf` | Text extracted: Product batch, components P1 to P8 and P11 to P13, settings and edge cases | Required components and edge cases |
| Homepage and PLP wireframes, Design System (CSS, JS, docs, showcase), tokens, icons | Read | Reuse |

Limits, stated plainly:
- The PDF reader cannot render pages, so I decoded the PDF text layer myself. **Figures and images in the PDFs were not seen**, only text and captions.
- **No live research of Prestige, Impulse or Motion was run.** The Plan mentions Prestige (captions of five preset product pages, 45 mentions) and Motion (4 mentions) and has no Impulse content. The theme-pattern study here rests on those captions and on the Plan's own section 4.1 (Be Yours, Blockshop: "thumbnails with a texture shot, pickup with address and ready time, accordions for Ingredients, Customer results, Shipping information"; preset Nudge adds shade swatches with a visible name and a photo, ingredients with highlighted actives and free-from chips, routine steps, a claim-safe wording slot). Nothing was copied from any theme.
- The 38-tab original workbook was not re-read tab by tab; the project's derived plan and matrix cite every source row.
- Customer-feedback evidence is from the workbook and the plan, not from new interviews or data. There is no conversion data in any source.

## 1. Step 1: PDP feature analysis

### 1.1 INCLUDE: the 33 approved features

| # | Feature | Role | Where in the wireframe |
|---|---|---|---|
| 1 | Product Image Gallery (thumbnails, swipe, variant images) | Essential | Gallery: vertical thumbnails from 1024 px, swipe with dots on phones; slide 1 follows the chosen shade |
| 2 | Image Zoom | Essential | Hover magnifier on mouse screens; Zoom button and click open a full-screen viewer |
| 3 | Product Video in Gallery | Optional | Video slide with poster and play control |
| 4 | Before & After Images | Optional, after first listing | **Optional slide, off by default** (review toggle); needs claim-safe images and legal review |
| 5 | Title, Subtitle (key benefit) and Breadcrumbs | Essential | Breadcrumb above; the page's one H1; subtitle under it |
| 6 | Rating Summary near Title (display only) | Optional | Stars and count under the subtitle, linking to Reviews; hidden under 5 reviews |
| 7 | Price Block (price, compare-at, saving, unit price) | Essential | Large price, struck compare-at, "Save" line, unit price |
| 8 | Key Benefits / Highlights near Title | Essential | Three short benefits with icons |
| 9 | Description and Details Accordion | Essential | Accordion: description, full ingredients, suitability, safety, certifications |
| 10 | Variant Picker (buttons, live price and image) | Essential | Size and pack buttons; live price, unit price and image |
| 11 | Colour / Shade Swatches with Visible Names | Industry-specific | **Image swatches** with the name under each; selected name in the label |
| 12 | Quantity Selector (stepper) | Essential | Design System `.qty`, limited by stock |
| 13 | Subscribe & Save Selling-Plan Picker | Optional | Two-row picker; shows only if plans exist |
| 14 | Pack-Size Savings Display | Additional CRO | Duo pack: compare-at, saving and a lower unit price |
| 15 | Stock and Low-Stock Message (real inventory) | Essential | Icon and words under the button |
| 16 | Add to Cart Button (clear label and feedback) | Essential | Primary button with loading and success states |
| 17 | Express Checkout Buttons | Optional | Placeholder for Shopify's dynamic buttons |
| 18 | Sticky Add to Cart | Optional | Compact floating bar on desktop, slim bottom bar on phones |
| 19 | Delivery Estimate and Cut-off Message | Optional | Date range from processing days and cut-off (sample settings) |
| 20 | Free-Shipping Threshold Message | Optional | Remaining amount from the cart total |
| 21 | Returns, Refund and Guarantee Information | Essential | Row under the button, with a policy link |
| 22 | Trust and Payment Row | Essential | Secure checkout and payment chips |
| 23 | Pickup Availability | Optional | Row, only when the store has pickup locations |
| 24 | Ingredients (list, actives, free-from) | Industry-specific | Key ingredients section plus full list in the accordion |
| 25 | Allergen and Safety Information | Additional CRO | Accordion item |
| 26 | How to Use / Routine Steps | Industry-specific | Step section with morning and evening |
| 27 | Suitability (best for / not for) | Industry-specific | Accordion item |
| 28 | Certifications and Claims Disclaimer | Industry-specific | Accordion item with a disclaimer line |
| 29 | Expert Note | Optional | **Not drawn** (see 1.4) |
| 30 | Product FAQ | Optional | FAQ accordion |
| 31 | Complementary Products (incl. frequently-bought-together layout) | Essential | "Complete your routine": selectable list with a total |
| 32 | Related Products | Essential | Four product cards |
| 33 | Routine / Set Bundle Contents | Optional | Covered by "Complete your routine" |

### 1.2 EXCLUDE: marked No or Removed

**Marked No for Beauty (14):** 3D model / AR view, installment message, size guide, fit information and model info, true-to-size scale, materials and fabric care, specifications / facts table, compatibility checker, what's in the box, warranty and support information, SKU / model number, feeding guide / portion calculator, comparison table, complete the look / set.

**Removed (PDP rows of the Removed sheet):** wishlist (app), ask a question (app), back-in-stock sign-up (app), full review cards, review filters and customer photos (app), quantity discounts (app), embedded social reviews (app), "visitors viewed / bought in 24 hours" (invented numbers), follower counts, **recently viewed**, sample add-on (needs discount logic), made-to-measure form, results block (claims risk), finish explainer, swatch wall, separate Buy Now (the express buttons are the one fast-checkout), express delivery countdown (fake urgency).

**Asked for in the brief but not approved:**

| Brief item | Status | What the wireframe does |
|---|---|---|
| Cash on Delivery | Not in the approved list | Not drawn. Payment chips are merchant content; the merchant adds it if the store supports it |
| Authenticity assurance | Not in the approved list; a merchant claim | Not drawn. Trust row contents are merchant content |
| Product specifications | "Specifications / facts table" is No | Size and volume sit in the variant picker and the description |
| Installment message, size guide | No | Not drawn |
| Customer review photos, review filtering and sorting, rating distribution, review cards | Removed (app-dependent); ADD-10 is "needs research" | A labelled **reviews app slot** (the Theme Store requires an app-block area, Plan p101) next to a display-only rating summary. No reviews, names or photos are invented |
| Recently Viewed | Removed | Not drawn |
| Buy Now | Separate Buy Now removed; Express checkout buttons are Yes (optional) | Express checkout placeholder only |
| Pincode checker | PDP-10 is KEEP but "initial release: No"; needs an integration | Not drawn; the delivery estimate uses processing days and cut-off |

### 1.3 IMPROVE: where the workbook asks for a better treatment

| Item | Customer feedback (source) | UI/UX answer |
|---|---|---|
| Buy box visible early (PDP-01, 6 sites) | Add to cart not in the first fold | Two-column layout; on phones the gallery is capped to a square so title, rating and price peek into the first screen, with the sticky bar for the action |
| Sticky add to cart (PDP-02, 19 sites; PDP-23, PDP-24) | Missing or late; should show price; ask for a variant on click; reachable by thumb | Appears when the main button leaves the screen; shows price and variant; with no shade chosen it scrolls to the shade picker; bottom placement on phones |
| Clear variant selection (PDP-04, 4 sites) | Selected variant not prominent; greyed button makes the product look unbuyable | Thick ring and the name in the label; **the button is never disabled for a missing choice**: it prompts and focuses the picker |
| Price and discount (PDP-05, 3 sites) | Price small or grey; offer text same weight as price | Large price, compare-at struck through, "Save" line and the unit price smaller beneath |
| Rating (PDP-06, PDP-07) | No rating; zero-review ratings erode trust | Rating near the title, hidden under a minimum review count (5, a setting); the list is never filtered by stars in the theme |
| Delivery and returns (PDP-10, PDP-11) | A serviceability widget pushed the button down; returns message missing | Delivery, free shipping, returns and pickup sit **below** the button, one line each |
| Layering (PDP-03, 3 sites) | A chat button covered the sticky bar | Sticky bar uses the `--z-sticky` token; no other floating widget on the page |
| Breadcrumb (PDP-19) | Filter parameters shown in the trail | Built from collection and product only; one line with ellipsis on phones |
| Accordions (PDP-16) | Toggles, spacing, star colour | Design System accordion, 44 px headers; stars in the rating token colour |
| Add to bag feedback | Duplicate submissions, silent success | Loading state, one submission, success state with a message |

### 1.4 OPTIONAL: approved but merchant-controlled, or additional CRO needing justification

Approved optional features built, each with a setting: product video, before and after slide (off by default, after first listing, legal review), subscribe and save (display only), express checkout, sticky add to cart, delivery estimate, free-shipping message, pickup availability, FAQ, set contents.

**Approved optional, not built:** *Expert note* ("statements must be real and checked by the merchant"). There is no real practitioner to quote, so no placeholder was drawn; it is one more text block when the merchant has one.

**Additional CRO opportunities considered, not built (each needs a decision):**

| Idea | Source | Why not now |
|---|---|---|
| Review photos, filter by skin type or concern | ADD-10 | Needs research and a review app |
| Results block with substantiation | ADD-11; Removed as claims risk | Needs substantiation and legal review |
| Back-in-stock notification | ADD-13; Removed | Needs an app |
| Shade finder or try-on | ADD-14 | Needs research; the homepage finder is itself deferred |
| Pincode check | PDP-10, PDP-21 | Needs a serviceability integration |
| Own-product comparison table | PDP-09 | "Comparison table" is No for Beauty |

### 1.5 Conflicts between your brief, the approved list and the existing system

| # | Conflict | Choice | Reverse it by |
|---|---|---|---|
| C1 | **Palette.** Brief: "prefer warm ivory, champagne, beige". The current tokens are Pearl Pink, Rose Quartz, Blush Rose, Luxury Rose, Rich Burgundy and Midnight Plum; champagne and beige were retired at your request on 2026-11-11 | Existing tokens only: page Pearl Pink, gallery and ingredient surfaces white, quiet sections Rose Quartz | Change the tokens, not this page |
| C2 | **Uppercase headings.** Brief: "maintain the existing uppercase heading convention". The existing convention (homepage and PLP) is **sentence-case Cormorant headings**; uppercase is for labels, eyebrows and buttons only | Followed the existing convention | Add `.heading-caps` to headings |
| C3 | **Reviews.** Brief asks for distribution, cards, photos, verified labels, filters and sorting. Workbook: Removed (app-dependent) | Rating summary plus a reviews-app slot; nothing fabricated | Install a review app; the slot is its app block |
| C4 | **Sticky add to cart.** Workbook and Plan: compact floating button; matrix and brief: bottom bar on phones | Compact floating bar on desktop and tablet; slim bottom bar on phones. One component | Setting "sticky position" |
| C5 | **Sticky buy box.** Plan Beauty variant: sticky panel. The panel (title to trust rows, plus the accordions) is taller than a 900 px screen | The **gallery** is the sticky column from 1024 px (Plan variant "two-column-sticky-media"); the sticky add to cart covers reachability | Make the info column sticky if you shorten it |
| C6 | **Frequently bought together.** Brief lists it separately. Workbook merged it into Complementary Products | One block, "Complete your routine", in the frequently-bought-together layout | n/a |
| C7 | **Cash on Delivery, authenticity, specifications, installments** | Not drawn (1.2) | Merchant content |
| C8 | **Open workbook questions**: minimum review count; swatch source; sticky position | Sample defaults: 5 reviews; shade image from the variant image or a metafield; as C4 | Edit the settings |

## 2. Step 2: PDP structure and section order

Order follows the revised workbook's Beauty PDP rows (journey order: orient, look, decide, confirm, learn, trust) and the Task Guide's Product batch (components P1 to P8 and P11 to P13). One H1; the product and its action first; no pop-up on load.

| Order | Section | Task Guide components | Features |
|---|---|---|---|
| G1 | Announcement bar | global | homepage section, unchanged |
| G2 | Header | global | homepage section, unchanged; "Skin" is current |
| 1 | Breadcrumb | P2 | #5 |
| 2 | **Gallery** (left, sticky from 1024 px) | P1 | #1 to #4 |
| 3 | **Product info** (right): category, title, subtitle, rating, price, benefits | P2 | #5 to #8, #14 |
| 3a | Variant picker: shade (image swatches), size and pack | P3 | #10, #11, #14 |
| 3b | Selling-plan picker | P5 | #13 |
| 3c | Quantity, **Add to bag**, express checkout, stock | P4, P13 | #12, #15, #16, #17 |
| 3d | Delivery, free shipping, returns, pickup, trust row | P6, P11, P12 | #19 to #23 |
| 3e | Details accordion | P2 | #9, #25, #27, #28 |
| 4 | Key ingredients | P2 | #24 |
| 5 | How to use | P2 | #26 |
| 6 | Complete your routine | P7 | #31, #33 |
| 7 | Reviews (rating summary and app slot) | P8 | #6 |
| 8 | FAQ | P2 | #30 |
| 9 | Related products | P7 | #32 |
| G3 | Footer | global | homepage section, unchanged |
| Overlay | Sticky add to cart; image viewer | P9 (sticky add to cart) | #2, #18 |

Recently viewed, review cards and photos, specifications and the pincode check are deliberately absent (1.2).

## 3. Step 3: Design System audit

### 3.1 Reused, nothing rebuilt

| PDP element | Design System component / token |
|---|---|
| Breadcrumb | `.breadcrumb` |
| Buttons | `.btn--primary`, `--secondary`, `--text`, `--lg`, `--block` |
| Quantity | `.qty`, `.qty__btn`, `.qty__input` |
| Details and FAQ accordions | `.accordion` (native `<details>`) |
| Selling-plan options; routine checkboxes | `.choice` |
| Messages (success, error) | `.message--success`, `--error` |
| Price, rating, badge | `.price` (`--lg`, `--sale`, `__compare`, `__unit`), `.rating`, `.badge` |
| Image viewer | `<dialog class="drawer">` and `drawer.js` (focus wrap, scroll lock, Escape, focus restore) |
| Related products | `.product-card` and the PLP card treatment |
| Grid, layout, type | `.grid--products`, `.container`, `.stack`, `.ratio`, `.h2`, `.h3`, `.text-overline`, `.text-caption`, `.text-utility` |
| Surfaces and borders | `--color-bg-page`, `--color-bg-surface`, `--color-bg-subtle`, `--color-border-subtle`, `--color-control-border` |
| Icons | `05-Assets/Icons/sprite.svg` set (see 3.2 for the six added) |
| Colour, spacing, radius, shadow, motion, z-index | `variables.css` tokens only (`--space-*`, `--shadow-lg`, `--z-sticky`, `--duration-*`) |

**No new tokens and no Design System file changed.**

### 3.2 Additions (page level; each is a new component or a variant of an existing one, proposed for the Design System)

| Addition | Why | Nearest existing |
|---|---|---|
| **Gallery** (P1): scroll-snap stage, vertical thumbnails, dots, arrows, counter | The Design System has no media gallery | none |
| **Image swatch tile** (`.tile`): a larger image swatch with the name beneath | Plan variant "image-swatches"; the Design System swatch is a 32 px colour chip | `.swatch` |
| **Option button** (`.opt`): size and pack choice with price and unit price | Plan variant "buttons" | `.chip`, `.choice` |
| **Sticky add to cart** (P9) | Plan component, Task Guide P9 | none |
| **Button busy state** (`aria-busy`) and spinner | The Design System buttons have no loading state | `.btn` |
| **Image viewer** (`.drawer--zoom`) | Plan gallery uses a modal; the Design System has the side Drawer only | `.drawer` |
| **Six icons** in the page sprite: zoom-in, play, truck, rotate-ccw, shield-check, store, plus loader | The icon set has none; drawn in the same 24 px, rounded-stroke style | `sprite.svg` |
| Ingredient, step and routine blocks | Page content patterns | `.card`, ritual steps on the homepage |

Page-specific CSS uses tokens only. A scan for hex, rgb, rem and em values is reported in 6.2. The shade and ingredient colours in the script are merchant sample data (the one place the Design System allows a non-token colour). Header, announcement bar and footer CSS is copied unchanged from the homepage.

### 3.3 Findings in existing files (reported, not changed)

The PLP findings F1 to F7 still apply (homepage header does not stick; rating star colour; Load more on phones; footer links 32 px; drawer has no left variant). New ones from the PDP:

| # | Finding | Suggested fix |
|---|---|---|
| P1 | The Design System has no media gallery, sticky bar, loading button or image viewer, although the Plan lists them as P0 or P1 components | Adopt the additions in 3.2 |
| P2 | The Plan's variant-picker variant for Beauty is image swatches, but `.swatch` only supports a flat colour via `--swatch` | Add `.swatch--image` (tile) |
| P3 | Icon set lacks zoom, play, truck, return, shield, store and a spinner | Add them to `sprite.svg` |

## 4. Steps 4 to 7: the wireframe, responsive layouts and states

The wireframe is `PDP_Wireframe_v1.html` in this folder: one responsive file, with review chrome (annotations, width preview, state buttons). Open it and use **Width preview** for 1920, 1440, 1024, 768, 390, 375 and 320 px.

### 4.1 Layouts by width

| Width | Layout |
|---|---|
| 1920 and 1440 | Two columns (7 / 5). Vertical thumbnails left of the stage. Gallery stays in view while the buy column scrolls. Hover magnifier on mouse screens. Sticky bar appears once the buy box scrolls out of view. |
| 1024 | Same as desktop; gallery sticky begins here. |
| 768 (tablet) | Two columns at 50 / 50. Thumbnails sit under the stage. Arrow buttons shown. Sticky bar is a compact floating bar at the bottom. |
| 390, 375, 320 (phone) | One column, gallery first, square stage with swipe and dots so title, rating and price peek into the first screen. Compact one-row header. Slim full-width sticky bar (price, shade and size, Add to bag). Ingredients become compact rows. |

### 4.2 Interaction states built (the buttons in the review bar trigger each)

Thumbnail and dot selection; arrow and swipe navigation; hover magnifier and full-screen image viewer (focus returns to the Zoom button); video slide; optional before and after slide (off by default); shade selection with the gallery following the shade; sold-out shade and size (struck through, not selectable); size change updating price, compare-at, saving and unit price; quantity capped by stock with a low-stock message; Add to bag with no shade (message, focus moves to the shade picker, button stays enabled); Add to bag loading, success and reset (one submission only, however many clicks); sticky bar show, hide and its own add button; single-variant product (picker hidden); complementary products total updating as items are ticked; accordions (native).

## 5. Shopify compatibility

Listed in the page's review notes: native platform data (media, variants, price, stock, selling plans, pickup, recommendations, dynamic checkout), theme-editor settings and blocks (layout, zoom, sticky bar, accordions, section order), merchant metafields (ingredients, how to use, suitability, safety, certifications, benefits, FAQ, rating display), and custom theme JavaScript on the Cart Ajax API (add to bag states, viewer, sticky bar, delivery estimate). Reviews list, photos, filters, subscriptions, back-in-stock and pincode lookup need an app or integration and are excluded.

## 6. Final audit

**Automated checks** (the in-page `?selftest=1`, run in an exact-width frame at 1920, 1440, 1024, 768, 390, 375 and 320 px): **11 of 11 pass at every width.** The checks cover no horizontal overflow, heading structure and one H1, two-column or stacked layout and gallery stickiness, gallery structure and navigation and viewer focus return, variant and price behaviour, shade prompt with an enabled button, loading and single-submission add to bag, quantity limits, sticky bar behaviour, content and exclusions (no invented reviews, no excluded wording), 44 px touch targets and fonts (Cormorant headings, DM Sans UI).

**Other checks:** the PDP CSS has no hex colours and no odd font sizes; raw px values are limited to breakpoints and the one-pixel visually-hidden clip. Homepage, Design System, tokens, CRO workbooks and the PLP were not modified by this build. Screenshots reviewed at 1440 (top and full page) and 390 (top).

**Not run:** a separate contrast measurement for the PDP, touch-emulation runs at 390 and 768, and screenshots of the open viewer, the success state and the sticky bar. These are open and should be done before sign-off.

| Audit point | Result |
|---|---|
| Matches approved CRO list | 32 of 33 drawn; Expert note not drawn (no real statement) |
| Exclusions respected | Yes: no reviews content, recently viewed, wishlist, Buy Now, specs, size guide, installments, COD, authenticity, pincode |
| Rating next to the title | Yes |
| Gallery | Vertical thumbnails, zoom, texture, application, ingredient and video slides |
| Variants | Image swatches with names; selected, hover, focus, sold-out states |
| Add to bag always reachable | Yes: sticky bar on every width; never disabled for a missing shade |
| Delivery and availability clear | Yes; estimate labelled as computed from sample settings |
| Design System reuse | Components reused; additions listed in 3.2 |
| Brand identity | Current tokens (Luxury Rose, Rich Burgundy, Pearl, Plum); sentence-case headings |

**Decisions to confirm:** palette (your brief says ivory, champagne and beige, which were retired on 2026-11-11); sentence-case headings rather than uppercase; gallery sticky from 1024 px; no pre-selected shade; reviews as an app slot plus a display rating only.

## 7. Revision 2: luxury visual direction

Requested by the user after review (brief: premium luxury transformation; sections 1 to 3 of the brief were received, the text ended at the gallery section). Decisions taken with the user: media stays as **art-directed placeholders** (no photography exists in the project; the earlier no-imagery rule stands), and the **current palette** is kept (Luxury Rose, Rich Burgundy, Pearl, Plum), layered for depth rather than reverting to ivory, champagne and beige.

Changes, all in page CSS with tokens only: a soft light wash behind the product section; a distinct surface for every band (pearl, rose glow, a deep burgundy How to use band, blush reviews); a framed gallery stage with an inner hairline and lift; composed placeholders per slide (pack shot with spotlight, floor shadow and a dashed product zone, texture, application split, ingredient circles, a plum video poster) in both stage and thumbnails; the pack shot tints to the chosen shade; editorial eyebrows with a rule; a larger Cormorant title and price with lining numerals; framed ingredient and card media. The 11 self-test checks still pass at 1920 to 320 px.

## 8. Revision 3: clean, minimal, premium (supersedes the surface and decoration choices in section 7)

Requested by the user because revision 2 felt crowded. Approved CRO features are unchanged; the page was simplified, not extended.

**Removed or merged:** the benefit list with icons (moved to a three-line benefits row below the fold); the in-panel details accordion (merged with Ingredients and How to use into one Product details accordion); three ingredient image cards (now one editorial image beside the three actives); the separate How to use band (steps now sit in the accordion); icons on delivery and trust lines; boxes around delivery, plans and the routine summary; the image counter badge (kept for screen readers only); gradients on every band, drop shadows, inner frame lines and the rule beside each eyebrow label; the repeated free-from chips and the full ingredient list that appeared twice.

**Structure now:** announcement, header, breadcrumb; gallery and purchase panel (category, title, rating, short description, price, shade, size, plan, quantity and Add to bag, stock, express checkout, four delivery lines, one secure-checkout line); benefits; product details accordion; one tinted editorial band (key ingredients); complete your routine; reviews; related products; FAQ; footer. Page ivory throughout, one tinted band, hairlines between sections. Section padding uses the space tokens (48 px phones, 80 px from 1024 px).

**Brief points not followed, because the approved CRO list says otherwise (decisions to confirm):** rating distribution, review images and review cards stay in the reviews app slot (Removed: need an app); Quick Add on related cards (not approved on the PLP either); a specifications table (No for Beauty). Headings stay sentence case, as on the Homepage and PLP, although the brief says to follow uppercase headings. The brief's warm ivory is the existing Pearl page token.

**Checks:** the 11 in-page checks pass at 1920, 1440, 1024, 768, 390, 375 and 320 px after the change (detail accordion count is now 6). Screenshots reviewed at 1440 (top and full page) and 390. Contrast and touch-emulation runs are still open.

## 9. Revision 4: restructure (supersedes the layout in sections 7 and 8)

Requested after the user rejected revision 3 as not different enough. The CRO source of truth is unchanged (revised workbook, Beauty PDP: 33 Yes, 14 No); the checklist in section 1 was re-checked against the page, and every drawn feature below is a Yes item.

**What changed structurally**
- The details accordion (description, how to use, full ingredients, suitability and safety, certifications) now closes the purchase column, as on Prestige-style themes, instead of being a separate section below. The page lost two sections and is shorter.
- Benefits are the headline and lead of the single editorial band; there is no benefits strip.
- Purchase panel: shade swatches are round image tiles with the name in the legend (no captions); size is one row of three options with label and price; purchase options are one inline row; one quantity and Add to bag row; stock line; express checkout; four plain delivery lines; one payment line; then the accordion.
- Surfaces: page ivory, one tinted editorial band, hairlines between sections. Placeholder media now uses a warm greige derived from the existing border and page tokens (14 and 28 percent mixes), so the page no longer reads as pink on pink. No new tokens were added; the two mixes are page-local aliases.
- Gallery arrows appear on hover or focus only. Related cards are the PLP card.

**Section order:** gallery and purchase panel (with details accordion); editorial band (benefits and key ingredients); complete your routine; reviews (rating and app slot); related products; FAQ; footer.

**Checks:** 11 of 11 in-page checks pass at 1920, 1440, 1024, 768, 390, 375 and 320 px (the accordion now holds 5 items). Screenshots reviewed at 1440 (top and full page) and 390 (top). Not run: contrast measurement, touch emulation, tablet screenshot, and viewer, success and sticky-bar screenshots.

**Still not drawn because the approved list excludes them:** rating distribution and review images (reviews app slot only), Quick Add, specifications, Buy Now, recently viewed, wishlist.

## 10. Audit corrections (2026-11-16, approved)

Made after the page-by-page audit, on the user's approval. Restored to follow the revised workbook: shade names are visible under each swatch (row 11); one line of key benefits sits under the rating (row 8, "near title"); the Duo pack option shows its saving (row 14); the delivery line has a sample dispatch cut-off message (row 19, a sample setting). The purchase panel was tightened so the Add to bag button sits higher (bottom edge about 873 px at 1440, from about 905 px; it is still below the fold of a 800 px-tall browser window, and the sticky bar covers it once the page scrolls). The header cart icon is a link, footer links are 44 px, and the in-page review notes were updated. Expert note remains not drawn. Self-test: 11 of 11 at 1920, 1440, 1024, 768, 390, 375 and 320 px.
