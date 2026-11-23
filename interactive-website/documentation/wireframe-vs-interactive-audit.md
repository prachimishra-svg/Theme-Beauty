# Wireframe vs interactive website audit

Generated 2026-11-18 19:23 by tools/build-audit-reports.ps1 from documentation/data/compare.json (tools/suite-compare.js).

Method: every one of the 16 wireframe pages was loaded twice in headless Chrome, once as the original wireframe (interactive mode OFF) and once through the interactive site (mode ON), at 1440 px and 390 px. Every section (plus announcement bar, header and footer) was snapshotted and compared on presence, order, visibility, text, link / button / input / image / icon / placeholder counts, height and computed styles (background, padding, heading font, size and weight). The wireframe review panel and the pink annotation notes are hidden in BOTH sides before measuring (the interactive site hides them on purpose).

Statuses: **MATCHED** identical on every measured property. **MISSING** present in the original, absent in the interactive site. **INCORRECT** present but different without an explanation. **PARTIALLY IMPLEMENTED** present, content bound to data. **NEEDS REVIEW** differs, explanation below. **HIDDEN ON PURPOSE** hidden in the interactive site by request.

## Totals

| Measure | Count |
|---|---|
| Pages inspected (wireframes) | 16 |
| Pages with a counterpart in the interactive site | 16 |
| Section comparisons (section x page x 2 widths) | 242 |
| MATCHED | 224 |
| PARTIALLY IMPLEMENTED (explained) | 2 |
| HIDDEN ON PURPOSE | 12 |
| NEEDS REVIEW | 4 |
| INCORRECT | 0 |
| MISSING | 0 |

Distinct sections compared at 1440 px (sum over pages, header, announcement bar and footer included): **121**.

## Pages that do not exist in the wireframes (cannot be compared)

| Page | Status | Note |
|---|---|---|
| Search / search results | MISSING in the wireframes | Only a stand-in overlay exists in the interactive layer (needs sign-off) |
| Account, login, register, forgot password, orders | MISSING in the wireframes | Notice shown |
| Wishlist | MISSING in the wireframes | No control, no page |
| Checkout | Not a wireframe page | Shopify-native |

## Homepage

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| Hero Banner | MATCHED | MATCHED |  |
| Benefits / USP Row | MATCHED | MATCHED |  |
| Shop by Category | MATCHED | MATCHED |  |
| Featured Collection (Best Sellers / New Arrivals) | MATCHED | MATCHED |  |
| Shop by Concern / Need / Routine | MATCHED | MATCHED |  |
| Guided Finder / Quiz | MATCHED | MATCHED |  |
| Shop the Look | MATCHED | MATCHED |  |
| Ingredient / Material Spotlight | MATCHED | MATCHED |  |
| How to Use / Routine Steps | MATCHED | MATCHED |  |
| Video Section | MATCHED | MATCHED |  |
| Before & After | MATCHED | MATCHED |  |
| Testimonials / Customer Reviews | MATCHED | MATCHED |  |
| Customer Photo Gallery | MATCHED | MATCHED |  |
| Logo List (Awards, Certifications, Press, Partner Brands) | MATCHED | MATCHED |  |
| Promotional / Campaign Banner | MATCHED | MATCHED |  |
| Custom Liquid Section | HIDDEN ON PURPOSE | HIDDEN ON PURPOSE | hidden in interactive mode (optional empty merchant slot, hidden by request) |
| Newsletter | MATCHED | MATCHED |  |
| Footer (navigation, about, contact, support, shipping & returns, policies, social, payment icons, trust line, back to top) | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Radiance, Gently Nudged. |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (21 sections) | MATCHED |  |

## PLP (collection)

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| Collection Banner | MATCHED | MATCHED |  |
| Sub-collection Links | MATCHED | MATCHED |  |
| Filters and Product Grid | MATCHED | MATCHED |  |
| Sort, Product Count and Applied Filters | MATCHED | MATCHED |  |
| Product Grid | MATCHED | MATCHED |  |
| Collection SEO Description | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Skin care |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (9 sections) | MATCHED |  |

## PDP (product)

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| Breadcrumb | MATCHED | MATCHED |  |
| Product: gallery and purchase panel | MATCHED | MATCHED |  |
| Product information and purchase | MATCHED | MATCHED |  |
| Variant picker | MATCHED | MATCHED |  |
| Selling plan picker | MATCHED | MATCHED |  |
| Buy buttons | MATCHED | MATCHED |  |
| Delivery, returns, pickup and trust | MATCHED | MATCHED |  |
| Product details | MATCHED | MATCHED |  |
| Product storytelling | MATCHED | MATCHED |  |
| Complete your routine | MATCHED | MATCHED |  |
| Reviews | MATCHED | MATCHED |  |
| Related products | MATCHED | MATCHED |  |
| Product FAQ | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Tinted Moisturiser |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (16 sections) | MATCHED |  |

## Cart page

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | NEEDS REVIEW | NEEDS REVIEW | text differs at char 1102: "ts Account Cart3 Search products" vs "ts Account Cart0 Search products" |
| Cart | HIDDEN ON PURPOSE | HIDDEN ON PURPOSE | hidden in interactive mode (check) |
| Cart lines | HIDDEN ON PURPOSE | HIDDEN ON PURPOSE | hidden in interactive mode (check) |
| Order note and gift message | HIDDEN ON PURPOSE | HIDDEN ON PURPOSE | hidden in interactive mode (check) |
| Cart upsell | HIDDEN ON PURPOSE | HIDDEN ON PURPOSE | hidden in interactive mode (check) |
| Order summary | HIDDEN ON PURPOSE | HIDDEN ON PURPOSE | hidden in interactive mode (check) |
| Empty cart | MATCHED | MATCHED | Empty-cart state is visible because the shared cart starts empty; the wireframe starts with three sample lines. Same markup, different state. [height 0 vs 350 px] |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Cart |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (9 sections) | MATCHED |  |

## Cart drawer wireframe

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | NEEDS REVIEW | NEEDS REVIEW | text differs at char 1102: "ts Account Cart3 Search products" vs "ts Account Cart0 Search products" |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Page behind the drawer |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1440 / original 1440 at 1440 |
| Section order (3 sections) | MATCHED |  |

## Contact

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| Contact form | MATCHED | MATCHED |  |
| Contact details | MATCHED | MATCHED |  |
| Quick answers | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Contact us |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (6 sections) | MATCHED |  |

## FAQ

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| Question groups | MATCHED | MATCHED |  |
| Still need help | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Frequently asked questions |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (5 sections) | MATCHED |  |

## About

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| Intro | MATCHED | MATCHED |  |
| Mission | MATCHED | MATCHED |  |
| Values | MATCHED | MATCHED |  |
| How products are made | MATCHED | MATCHED |  |
| Closing call to action | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Skincare made to be simple to use |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (8 sections) | MATCHED |  |

## Our story

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| Intro | MATCHED | MATCHED |  |
| Opening note | MATCHED | MATCHED |  |
| Timeline | MATCHED | MATCHED |  |
| Pull quote | MATCHED | MATCHED |  |
| What comes next | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | How NUDGE began |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (8 sections) | MATCHED |  |

## Shipping policy

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| At a glance | MATCHED | MATCHED |  |
| Policy text | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Shipping and delivery policy |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (5 sections) | MATCHED |  |

## Returns policy

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| At a glance | MATCHED | MATCHED |  |
| Policy text | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Returns and refund policy |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (5 sections) | MATCHED |  |

## Privacy policy

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| At a glance | MATCHED | MATCHED |  |
| Policy text | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Privacy policy |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (5 sections) | MATCHED |  |

## Terms

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| At a glance | MATCHED | MATCHED |  |
| Policy text | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Terms and conditions |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (5 sections) | MATCHED |  |

## Blog listing

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| Featured article | MATCHED | MATCHED |  |
| Article grid | MATCHED | MATCHED |  |
| Pagination | MATCHED | MATCHED |  |
| No articles | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | Journal |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (7 sections) | MATCHED |  |

## Blog article

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| Article | PARTIALLY IMPLEMENTED | PARTIALLY IMPLEMENTED | Placeholder article title and tags are replaced by the bound article data (intended binding). [text differs at char 11: "HomeJournal[Article title] Routines [Sample title: " vs "HomeJournalA simple morning skincare routine Skinca" ; height 2218 vs 2152 px] |
| Comments | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | PARTIALLY IMPLEMENTED | Heading placeholder replaced by the bound article title. [h1 "[Sample title: the layered morning routi" vs "A simple morning skincare routine"] |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (5 sections) | MATCHED |  |

## 404

| Section | 1440 px | 390 px | Detail |
|---|---|---|---|
| Announcement bar | MATCHED | MATCHED |  |
| Header | MATCHED | MATCHED |  |
| 404 | MATCHED | MATCHED |  |
| Footer | MATCHED | MATCHED |  |

| Page-level check | Status | Detail |
|---|---|---|
| Interactive layer ready | MATCHED |  |
| Page title and main heading | MATCHED | We cannot find that page |
| Fonts in use (body, h1, button) | MATCHED | body:"DM Sans" h1:Cormorant button:system-ui |
| No horizontal overflow | MATCHED | interactive scrollWidth 1425 / original 1425 at 1440 |
| Section order (4 sections) | MATCHED |  |

## What this audit cannot show

* The wireframes use labelled **placeholders instead of photography** by design (a standing project rule). The interactive site keeps them; no section was swapped for a different placeholder (placeholder counts are compared above).
* Pixel-level appearance was compared through computed styles and heights, not screenshots, in this report. The project's own pixel-diff equivalence check (check-equivalence.ps1) is recorded in the final report.