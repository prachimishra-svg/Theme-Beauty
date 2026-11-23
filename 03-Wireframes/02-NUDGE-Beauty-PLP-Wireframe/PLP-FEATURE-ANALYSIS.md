# NUDGE Beauty: PLP feature analysis, structure, design-system audit and final check

Wireframe: [PLP.html](PLP.html) (one responsive file, same folder; the file name is kept, the content is **revision 2**). Written 2026-11-12, revised the same day.

**Authority used.** The approved Yes/No list is the **Beauty column of the revised five-theme workbook** (`Homepage_CRO_5_Theme_Final_Comparison_Revised_Final.xlsx`: PLP: 23 kept, 7 not recommended). It is the later document, it is the one that records Yes and No, and the homepage was already built to it. The original CRO research and the CRO matrix supply the **negative-feedback evidence**. Where the documents disagree, or where a brief asks for something the workbook marks No, section 1.7 lists the choice made and how to reverse it.

## Revision 2: what changed and why

| Area | Revision 1 | Revision 2 |
|---|---|---|
| Filters, 768 px and up | Button opening a right-hand Drawer | **Sticky left sidebar** (240 px) with accordion groups; the grid sits on the right; choices apply at once with chips above the grid |
| Filters, below 768 px | Right Drawer | **Left slide-in drawer**, large close control, pinned **Clear all** and **Apply filters (N)** |
| Filter groups | Concern, skin type, product type, shade, size, price, availability | Same, plus **Key ingredients** and **Benefits** (brief). **Brand** not added (see 1.7) |
| Product card | Centred, rounded image, button under every card | **Editorial**: square image, category overline, serif name, supporting line, rating, price, shade dots; quiet outlined badges; **second image on hover** and a **Quick view bar over the image** on mouse screens; a labelled button under the card on touch |
| Pagination | Design System squares | Quiet pills, current page outlined in the brand colour, chevron Previous and Next, hairline and status line |
| Toolbar | Full-width bar with Filters button | Inside the results column: count (small caps) and sort; Filters button only on phones |
| Grid | 4 / 3 / 2 columns, full width | Beside the sidebar: 2 columns at 768, 3 at 1024, 4 at 1280; 2 / 3 on phones and small tablets |
| Unchanged | | The 23 approved features, numbered pagination only, no Load more, no wishlist, no Quick add, Quick view as the add route, Design System components and tokens, global header and footer |

## 0. What was read, and the limits

| Source | Read | Used for |
|---|---|---|
| `Homepage_CRO_5_Theme_Final_Comparison_Revised_Final.xlsx` | PLP Master Comparison (30 features), Beauty - PLP, PDP & Cart (PLP rows), PLP Additional CRO Recs, Removed - PLP/PDP/Cart, Notes, Revision Log, Source Map (PLP rows) | Yes/No, order, tier, configuration, removals, document conflicts |
| `04-CRO-Research/CRO-Comparison/NUDGE_Beauty_CRO_Feature_Decision_Matrix.xlsx` | PLP - Collection tab (PLP-01 to PLP-16, ADD-04 to ADD-06), Summary | Priority, initial release, source companies |
| `04-CRO-Research/Documentation/plp-cro-plan.md` | Whole file | Negative feedback per PLP item, suggested implementation |
| `Plan Sheet/Nudge-Theme-Plan.pdf` | Text extracted; collection component definitions (banner, filters, sort, product grid, product card, quick view, quick add, pagination, promo tile), card variants | Component variants and settings |
| `Plan Sheet/Nudge-Task-Guide-Team.pdf` | Text extracted; Collection and search batch, pp. 165-201 | Required components, edge cases |
| Homepage wireframe, Design System (CSS, JS, docs, showcase), tokens, icons | Read | Reuse |

Limits, stated plainly:
- The PDF reader here cannot render pages, so I decoded the PDF text layer myself. **Figures and images in the two PDFs were not seen**; only their text and captions.
- The 38-tab original workbook (`Copy of CRO Points for ABM.xlsx`, 6.9 MB) was **not re-read tab by tab**. I used the project's own derived plan and matrix, which cite every source row.
- No new market research was run. "Trending in premium beauty stores" rests on the project's own benchmark of 139 Beauty listings quoted in the workbook.

## 1. Step 1: PLP feature analysis

### 1.1 All 30 PLP features, Beauty column

| # | Feature | Beauty | Tier | In the wireframe |
|---|---|---|---|---|
| 1 | Breadcrumbs | Yes | Core | Yes |
| 2 | Collection Banner (title, image, short intro) | Yes | Core | Yes |
| 3 | Sub-collection Links (chips) | Yes | Core | Yes |
| 4 | Sort and Product Count Bar | Yes | Core | Yes |
| 5 | Filters (availability, price, product type; phone-friendly) | Yes | Core | Yes (sidebar; left drawer on phones) |
| 6 | Filter by Concern / Skin Type / Goal | Yes | Core | Yes |
| 7 | Filter by Colour / Shade Swatches | Yes | Core | Yes |
| 8 | Filter by Size | Yes | Core | Yes |
| 9 | Filter by Pet Type / Need | **No** | Core | No |
| 10 | Filter by Technical Specifications | **No** | Core | No |
| 11 | Active Filter Chips & Clear All | Yes | Core | Yes |
| 12 | Empty Filter Result State | Yes (Additional CRO, High) | Core | Yes |
| 13 | Promo Tile in Grid | Yes | Optional | Yes |
| 14 | Product Grid (2-4 columns, consistent card size) | Yes | Core | Yes |
| 15 | Grid / List View Toggle | **No** | Optional | No |
| 16 | Product Card: image, title, price, sale price and saving | Yes | Core | Yes |
| 17 | Product Rating on Card (display only) | Yes | Optional | Yes |
| 18 | Unit Price | Yes | Core | Yes |
| 19 | Key Attribute Line on Card | Yes | Core | Yes |
| 20 | Colour / Shade Swatches on Card | Yes | Core | Yes |
| 21 | Product Badges | Yes | Core | Yes |
| 22 | Low-Stock Message on Card (real inventory) | Yes | Optional | Yes |
| 23 | Second Image on Hover | **No** | Optional | **Yes, mouse screens only, at your request (1.7 C7)** |
| 24 | Quick Add | **No** | Optional | No |
| 25 | Quick View | Yes (after first listing) | Optional | Yes |
| 26 | Compare Bar | **No** | Optional | No |
| 27 | Numbered Pagination | Yes | Core | Yes |
| 28 | Scroll Position Kept on Back | Yes | Core | Behaviour, not drawn |
| 29 | Related Collections Strip | **No** (Additional CRO) | Optional | No |
| 30 | Collection SEO Description (below the grid) | Yes | Optional | Yes |

23 Yes built, 6 No absent, 1 No built on request. **Removed outright** (Removed sheet): wishlist and back-in-stock sign-up (need apps), infinite scroll, Load more button, filter by brand, sticky filters (deferred), recently viewed, best-seller strip, delivery strip, trust block, ratings from a review platform.

### 1.2 The 24 analysis areas

| # | Area | Decision | Why |
|---|---|---|---|
| 1 | Collection header / banner | **Include** | Essential; the page's one H1; compact so products start early |
| 2 | Title and description | **Include** (merged into the banner) | Separate title/image/description rows were merged in the workbook |
| 3 | Product count | **Include**, live and announced | Part of the Sort and Product Count Bar; small caps above the grid |
| 4 | Breadcrumb | **Include** | Core; phones show parent and current page |
| 5 | Sorting | **Include, improve** | Works, reversible, selected option visible, optional discount sort (PLP-05) |
| 6 | Filters | **Include** | Base set plus concern, skin type, ingredient, benefit, shade, size |
| 7 | Filter drawer / sidebar | **Sidebar from 768 px; left drawer below** | Brief; also settles the sidebar vs top bar question left open in the matrix |
| 8 | Active filter chips | **Include** | Essential; above the grid, one line on phones, Clear all |
| 9 | Grid layout | **Include** | Uniform; 2 / 3 / 4 columns by width and sidebar |
| 10 | Product cards | **Include, redesigned** | See 1.4 |
| 11 | Images and hover | **Second image on hover on mouse screens**; no image zoom | Brief; workbook says No (1.7 C7) |
| 12 | Badges | **Include** | One quiet badge: sold out, sale, new arrival, bestseller, limited edition |
| 13 | Ratings and reviews | **Include (optional)** | Metafield display only; hidden under a minimum review count (PLP-09) |
| 14 | Pricing and discount | **Include** | Price, compare-at, percent badge on the image, unit price where set |
| 15 | Swatches / variants | **Include, modify** | Dots on the card (up to 4 and +N); names and choice in Quick view (PLP-07) |
| 16 | Quick add to cart | **Exclude; Quick view is the add route** | No for Beauty: a shade must be chosen first |
| 17 | Quick view | **Include (optional, after first listing)** | Yes for Beauty; 130 of 139 Beauty listings |
| 18 | Wishlist | **Exclude** | Removed: needs an app |
| 19 | Load more / pagination / infinite scroll | **Numbered pagination only** | Load more and infinite scroll are Removed |
| 20 | Recently viewed | **Exclude** | Removed |
| 21 | Promo banners in the grid | **Include (optional)** | One tile; real offers only |
| 22 | Empty filter results | **Include** | Additional CRO, High priority |
| 23 | Mobile filter and sort | **Include** | Filters and Sort side by side; left drawer with a pinned Apply button |
| 24 | Responsive grid | **Include** | Design System grid tokens, re-pointed beside the sidebar (3.2) |

### 1.3 Filters

Included, in this order: **skin concern** and **skin type** (open by default), **product type**, **key ingredients**, **benefits**, **shade** (swatches, only when the collection has shades), **size** (volume), **price** (minimum and maximum), **availability**. Group titles show a count of chosen options; every option shows how many products it has. Concern labels reuse the homepage's six; skin types reuse the homepage finder's five.

Not included: **brand** (Removed in the workbook: each theme is one brand's store; adding it is one more metafield group), **pet type** and **technical specifications** (No). **Ingredients** and **Benefits** are not in the workbook's Beauty list (the matrix names ingredient as a possible metafield group, with the default attribute set left open); they are added at your request, and Benefits overlaps "Concern / Goal", so it is the first group to remove if the sidebar feels long.

### 1.4 Product card (decided content, top to bottom)

Square 4:5 image with one quiet badge, category overline, name (serif, up to three lines), key attribute line, optional rating, price with compare-at and unit price where set, shade dots, real low-stock line. Mouse screens: second image and a Quick view bar over the foot of the image. Touch screens: a labelled 44 px Quick view button under the card. Not on the card: wishlist, vendor name, quick add.

### 1.5 Negative feedback, and how the wireframe answers it

| ID | What went wrong on other stores | Answer in the wireframe |
|---|---|---|
| PLP-01 (13 sites) | Filters and sort scroll away | The desktop filter sidebar is sticky and scrolls inside itself; the sort toolbar can be made sticky (review toggle, off by default, see 1.7) |
| PLP-02 (5) | One filter per reload; selections reset | Sidebar: any number of choices, applied at once without a reload. Phones: batched, applied once |
| PLP-03 (7) | Only price and stock filters | Skin concern, skin type, ingredient, benefit, shade, size first |
| PLP-04 (3) | Applied filters push products down; look like unapplied | One-line chip row on phones; selected = tint, border and check mark; group titles show the count |
| PLP-05 (3) | Sort cannot be reversed or does nothing | Select shows the chosen option; any option, including Featured, can be re-selected |
| PLP-06 (5) | Add to cart tiny, over the image, or missing | Quick view is a full-width labelled 40 to 44 px bar (hover) or button (touch); on mouse screens it sits over the image only while the card is hovered or focused, and the touch version is always visible under the card |
| PLP-07 (4) | Partial variants; tiny colour images | Round colour dots, +N, all shades named in Quick view |
| PLP-08 (3) | Small price, truncated discount | Price at the token price size; percent badge on the image; long-title card tested (three lines, then clipped) |
| PLP-09 (2) | Ratings with zero reviews | Rating hidden under a minimum review count (5, a setting to confirm) |
| PLP-10 (1) | Cannot reach the bottom filter on mobile | Drawer body scrolls; **Clear all** and **Apply filters (N)** pinned |
| PLP-11 (1) | Missing sub-collection images look broken | Sub-collections are text chips |
| PLP-12, 16 | Quantity on cards; Buy now on cards | Not added |

### 1.6 Trending in premium beauty stores (project evidence only)

From the workbook's benchmark of 139 Beauty listings: colour swatches declared by **135**, swatch filters by **127**, quick view by **130**, stock counter by **123**. No other trend claims are made.

### 1.7 Conflicts and overrides, and the choice made

| # | Conflict | Choice | Reverse it by |
|---|---|---|---|
| C1 | **Quick Add.** Plan p56 and CRO matrix: P0. Workbook: No for Beauty (shade choice), Quick View Yes. The brief asks to refine "Quick Add" | Kept the workbook: Quick view with a shade chooser and Add to bag, refined (hover bar, touch button) | Setting "Show quick view" off, or add a variant chooser and relabel |
| C2 | **Sticky filters.** Matrix PLP-01: High. Workbook: Removed (deferred) | Desktop **sidebar sticky** (brief: "fixed or appropriately positioned"); the **sort toolbar** still scrolls away unless the review toggle "Sticky toolbar" is on | Turn the toggle on; or make the sidebar static |
| C3 | **Load more on phones.** Design System shows it below 600 px (provisional). Workbook: Removed | Numbered pagination at every width (brief: do not introduce conflicting systems) | n/a |
| C4 | **Instant vs applied filters.** PLP-02: instant on desktop | Sidebar applies at once; phone drawer batches with Apply | n/a |
| C5 | **Applied chips.** Design System: always wrap. CRO PLP-04: single line | One scrolling line below 600 px, wrapping from 600 px | Use `.cluster` |
| C6 | **Open workbook questions**: minimum review count, swatch source, default attribute set | Sample defaults: 5 reviews; shade from variant option plus colour metafield; groups as in 1.3 | Edit the settings |
| C7 | **Second image on hover.** Workbook: No for Beauty (touch has no hover) | Built on request for **mouse screens only** (hover and fine pointer); touch shows the first image; only products that have a second media item | Setting "Show second image" off |
| C8 | **Ingredients, Benefits** not in the workbook list; **Brand** Removed | Ingredients and Benefits added; Brand not | Remove or add the metafield groups |
| C9 | **Limited edition** badge not in the workbook list (sale, new, best seller, sold out) | Shown on one sample card; a merchant tag, one badge per card | Do not tag products |

## 2. Step 2: PLP structure and order

Order follows the revised workbook's Beauty PLP rows (journey order) and the Task Guide's wireframe rules (products visible early, one H1, one main action, no pop-up on load, empty and error states shown).

| Order | Section | Components (Task Guide ids) | Features |
|---|---|---|---|
| G1 | Announcement bar | global | homepage section, unchanged |
| G2 | Header | global | homepage section, unchanged; "Skin" is current |
| 1 | Collection banner | C1 | #1 Breadcrumbs, #2 Banner |
| 2 | Sub-collection links | C1 | #3 |
| 3a | **Filter sidebar** (left, from 768 px) | C3 | #5 to #8 |
| 3b | Toolbar: count, sort (Filters button on phones) | C3 | #4, #11 applied chips |
| 4 | Product grid with promo tile and cards (right of the sidebar) | C1, C2 | #12 to #22, #11 promo, second image |
| 5 | Numbered pagination | C1 | #27 |
| 6 | Collection SEO description | C1 | #30 |
| G3 | Footer | global | homepage section, unchanged |
| Overlay | Left filter drawer (below 768 px); Quick view Drawer (right) | C3 | #5 to #8; #25 |
| State | Empty filter result | C3 | #12 (replaces the grid) |

Search results (C4) and the collection list page (C5) belong to the same Task Guide batch but are outside this request.

## 3. Step 3: Design System audit

### 3.1 Reused, nothing rebuilt

| PLP element | Design System component / token |
|---|---|
| Breadcrumb | `.breadcrumb` (phone compact behaviour included) |
| Sub-collection chips; applied-filter chips | `.chip`, `.chip-row`, removable chip pattern; `chip-row.js` |
| Mobile filter panel and Quick view panel | `<dialog class="drawer">` (`drawer.js`: focus wrap, scroll lock, focus restore); `--layout-drawer-width` |
| Filter groups (sidebar and drawer) | `.accordion` (native `<details>`) |
| Options | `.choice` checkboxes; `.field` + `.input` for price; `.swatches` / `.swatch` for shade |
| Sort | `.select > .input` |
| Buttons | `.btn--primary`, `--secondary`, `--text`, `--sm`, `--block` |
| Product card | `.product-card`, `__media`, `__badges`, `__body`, `__title`, `__vendor` (used for the category), `__swatches`, `__action`, `--soldout` |
| Badges, price, rating | `.badge` variants, `.price` (`--sale`, `__compare`, `__unit`), `.rating` |
| Grid and layout | `.grid--products` (`--grid-columns-products`), `.container`, `.stack`, `.ratio--portrait` |
| Pagination | `.pagination`, `__link`, `__gap` |
| Type | `.h1`, `.h3`, `.h5`, `--type-h4-*` (card names), `.text-caption`, `.text-overline`, `.text-utility` |
| Promo tile surface | `.surface-inverse` scope |
| Icons | `05-Assets/Icons/sprite.svg`: filter, chevrons, close, search, eye, star, warning, check-circle |
| Colour, spacing, radius, shadow, motion, z-index | `variables.css` tokens only (`--shadow-md`, `--duration-*`, `--ease-standard`, `--radius-none`, `--z-raised`) |

**No new tokens, no new components, no Design System file changed.**

### 3.2 Additions (page level; each is a variant or state of an existing component, proposed for the Design System)

1. **Drawer, left variant** (`.drawer--left`: opens from the left with a slide-in). The Design System drawer opens from the right only. Three rules.
2. **Chip as a link** with a current state (`aria-current="page"`). Three rules.
3. **Sidebar layout and grid columns beside it**: a two-column listing layout; `--grid-columns-products` re-pointed on the grid (2 at 768, 3 at 1024, 4 at 1280). The sidebar width is `calc(var(--space-12) * 5)` (15 rem), a local custom property, not a token.
4. **Product card refinements**: left aligned, square image, category overline, quiet badges, second-image layer, hover Quick view bar (mouse screens) with the Design System action button kept for touch.
5. **Pagination skin**: pill links, outlined current page, chevron Previous and Next.
6. **Sticky positions**: the header section (see 3.3 F1), the sidebar and the optional toolbar.

The page-specific CSS is about 13 KB with **zero hex or rgb values, zero rem/em values and zero durations typed in**; the only `px` values are media-query breakpoints, a `0px` fallback inside a `calc()`, and the standard `1px` visually-hidden pattern. Header, announcement bar and footer CSS is copied unchanged from the homepage (it contains the homepage's own fixed sizes). The five shade colours in the script are merchant sample data, the one place the Design System allows a non-token colour.

### 3.3 Findings in existing files (reported, not changed)

| # | Finding | Where | Suggested fix |
|---|---|---|---|
| F1 | **The homepage header does not stick.** It is a sticky element inside a section exactly as tall as itself, so it cannot move. Its own note says "Sticky at every size" | Homepage wireframe | `#s02{position:sticky;top:0;z-index:30}` on the section (done in the PLP) |
| F2 | `.rating__stars` is coloured with `--color-brand-primary`, not `--color-rating-star` | `components.css` | Use `var(--color-rating-star)`; the PLP overrides it locally |
| F3 | Pagination switches to **Load more below 600 px** (provisional) against the approved numbered-only rule | `components.css`, `load-more.js`, `foundations.md` s.14 | Decide and align; the PLP uses numbered |
| F4 | Footer links are **32 px tall from 1024 px** (44 px between 768 and 1023), below the Design System's own 44 px rule; they meet WCAG 2.5.8 (24 px) | Homepage footer, copied unchanged | Raise to 44 px or document the exception |
| F5 | The product card has slots for wishlist, vendor and add-to-bag that the approved Beauty list excludes | `components.css`, showcase | Keep as theme settings, default off |
| F6 | No range slider or price-range component; price is two number fields | Design System | Acceptable for v1 |
| F7 | The Design System drawer has no left variant, and no slide-in motion | `components.css` | Adopt `.drawer--left` (3.2) |

## 4. Steps 4 and 5: the wireframe and its responsive layouts

`PLP_Wireframe_v1.html`, linked to `variables.css`, `foundation.css`, `base.css`, `components.css`, `drawer.js`, `chip-row.js` (no copies). Open it directly; **Width preview** shows 1920, 1440, 1024, 768, 390, 375 and 320 px. Annotations (yellow bars) give each section's purpose, CRO source and responsive behaviour. Review buttons: Open filters, Applied filters, Empty results, Quick view, Sticky toolbar, Reset.

Working in the wireframe: 24 sample products, filtering (OR within a group, AND across groups) across nine groups, six sorts, 10 per page with a promo tile after the 8th on page 1, numbered pagination with gaps, live count, chips that remove, Clear all (sidebar and chips row), empty state, hover second image and Quick view bar, Quick view with shade choice and Add to bag (header count updates), Escape and focus return for both drawers. At 768 px and up the sidebar applies each choice at once; below 768 px choices wait for **Apply filters**. Crossing 768 px moves the one filter form between the sidebar and the drawer.

| Viewport | Layout | Card (w x h) | Banner | First screen | Toolbar |
|---|---|---|---|---|---|
| 1920 x 1080 | Sidebar 240 px + 4 columns, content capped at the 80 rem container | 224 x 451 | 261 px, image placeholder right half | whole first card | count left, sort right |
| 1440 x 900 | same | 224 x 451 | 261 px | 307 px of the first card | same |
| 1024 x 768 | Sidebar + 3 columns | 198 x 418 | 261 px | 175 px | same |
| 768 x 1024 | Sidebar + 2 columns | 205 x 427 | 224 px, text only | whole first card | same; chips wrap |
| 390 x 844 | No sidebar; 2 columns; left drawer | 164 x 371 | 239 px, text only | 264 px | Filters and Sort side by side, count below; chips scroll |

At 1440 the sidebar is 240 px and the grid 992 px wide. The filter drawer is a full-width sheet below 600 px and 26 rem wide from 600 to 767 px, always from the left. The Quick view panel opens from the right.

## 5. Not part of this request

PDP, cart, search results and the collection list page; high-fidelity styling; real photography (placeholders only, as for the homepage); the other four theme presets.

## 6. Step 6: final audit

### 6.1 Checklist

| Check | Result | Evidence |
|---|---|---|
| All approved CRO features implemented | **23 of 23** | section 1.1; in-page table |
| Excluded features not added | **Yes**, except the two requested overrides | no wishlist, add-to-cart on cards, compare, list toggle, load more, infinite scroll, related strip, brand/pet/spec filters (the self-test asserts no wishlist and no add-to-cart on any card). Second image on hover and Ingredients/Benefits are built on request (C7, C8) |
| Negative feedback considered | **Yes** | section 1.5 |
| Design System components reused | **Yes** | section 3.1; no component duplicated; variants listed in 3.2 |
| Variables used consistently; no hard-coding | **Yes** | zero hex/rgb/rem/em/duration values in the PLP CSS; no new tokens |
| Typography and colours match the homepage | **Yes** | same tokens and fonts (Cormorant headings and card names, DM Sans UI); global sections copied unchanged |
| Product cards visually consistent | **Yes** | one card size per breakpoint; 4:5 images; one badge; actions aligned |
| Filtering and sorting work on desktop and phone | **Yes** | sidebar and left drawer driven by real clicks in the self-test at all widths, and under touch emulation |
| Four responsive layouts covered | **Yes** | 1920, 1440, tablet (1024, 768), 390 (plus 375, 320) |
| No Design System, variables, homepage or CRO file changed | **Yes** | only `PLP_Wireframe_v1.html` and this file were written; last-write times of the others are 2026-11-11 or earlier |

### 6.2 Measured

- **Self-test, 11 checks** (no horizontal overflow, one H1 and heading order, sidebar left of the grid with the Filters button hidden from 768 px and the reverse below, grid columns per width and uniform cards, card anatomy and one visible quick-view control per card, 44 px targets, filtering including ingredient and benefit, sidebar groups with 44 px headers and sticky position or the left drawer opening at left edge 0 with a pinned Apply button and focus return, Quick view with shade chooser, pagination logic and 44 px links, typography families, real-click filter flow): **11 of 11 at 1920, 1440, 1024, 768, 390, 375 and 320 px**; also **11 of 11 at 390 and 768 px with touch emulation** (no hover, coarse pointer), which exercises the touch layout.
- **Text contrast** (every visible text element against its rendered background): 207 elements at 1440, 200 at 768, 109 at 390, 184 at 1440 with filters applied, **none below AA**; lowest 5.54:1 (the real low-stock line).
- **Text over the banner gradient** (from pixels with the text hidden, darkest background behind the text block): desktop eyebrow 6.59:1, H1 11.26:1; phone eyebrow 5.16:1, H1 8.80:1. The intro is set in primary text (8.80:1 on phones) because secondary text measured only 4.60:1 there. Unchanged in revision 2.
- **Sticky behaviour**: at 1440 after scrolling 900 px the header is at top 0 and the sidebar docks at 101 px (header 85 px plus a 16 px gap), 783 px tall in a 900 px viewport; the sort toolbar scrolls away unless the toggle is on.

### 6.3 Known limits

- Footer links are 32 px on desktop (F4), inherited from the homepage and accepted in the check as a documented exception.
- The self-test drives controls with programmatic clicks; the Design System Drawer was tested earlier with real input. The new left drawer's slide-in motion and the hover bar were checked by screenshot (the hover state with a temporary forced-hover copy, now deleted), not by a real pointer. Not tested: Safari, Firefox, real devices, screen readers, browser zoom.
- Filter option counts are static; Shopify's filters update them live.
- Products, prices, tags, ingredients and copy are sample data. Shade colours are merchant sample data. Ingredient and benefit values are placeholders for metafields.
- The PDF figures were not seen (section 0).

### 6.4 Decisions to confirm

1. **Second image on hover** (C7): keep it, given the workbook's No?
2. **Ingredients and Benefits** (C8): keep both? Benefits overlaps Concern. Add Brand?
3. **Sticky**: the sidebar is sticky (C2). Should the sort toolbar be too?
4. **Quick view for Beauty** (C1): confirm it replaces Quick add, and whether it ships in the first release.
5. **Minimum review count** for showing ratings (sample: 5); **Limited edition** badge (C9).
6. Fix **F1** (homepage header) and **F2** (rating star colour) in their own change; adopt the left drawer and chip-link variants (3.2).

## Audit corrections (2026-11-16, approved)

Made after the page-by-page audit, on the user's approval. Changes: "Sort: Biggest discount" removed (not in the workbook, not a native Shopify sort); the filter sidebar is a normal column that scrolls with the page, and the "Sticky toolbar" review toggle was removed, because Sticky Filters while scrolling is Removed (deferred) in the revised workbook (this supersedes earlier statements here that the sidebar is sticky); the header cart icon is a link; footer links are 44 px; sub-collection and filter chips and the Quick view button are 44 px tall (page-level, Design System unchanged). Kept by the user's decision: second image on hover, Limited edition badge, and the Key ingredients and Benefits filter groups. Self-test: 11 of 11 at 1920, 1440, 1024, 768, 390, 375 and 320 px.
