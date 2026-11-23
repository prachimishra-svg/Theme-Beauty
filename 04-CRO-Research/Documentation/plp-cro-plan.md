# PLP / Collection CRO plan

_Source: Copy of CRO Points for ABM.xlsx (38 tabs read). Facts from the workbook are marked as source statements; reasoning, implementation and priority are our assessment. The workbook has no conversion data, so none is claimed. Detail for every row is in cro-master-feature-matrix.xlsx._

## What the workbook says

The listing page is the most repeated theme: sticky filters and sort (13 entries), multi-select filters (5), filter attributes (7), no-results recovery (6, under Other / Global), quick add (4) and price / discount prominence (4). Three beauty tabs (Lotus Botanicals, Aroma Magic, Khadi Natural) ask for richer filters; Khadi Natural names skin type and hair type.

## Summary

| ID | Feature | Rec. | Priority | Companies |
|---|---|---|---|---|
| PLP-01 | Sticky filter and sort bar | KEEP | P0 | 13 |
| PLP-02 | Multi-select filters without a page reload per click | KEEP | P0 | 5 |
| PLP-03 | Beauty-relevant filter attributes and a common 'all products' listing | KEEP | P0 | 7 |
| PLP-04 | Applied-filter chips and distinct active state | KEEP | P0 | 3 |
| PLP-06 | Prominent quick add / add to cart on product cards | KEEP | P0 | 5 |
| PLP-09 | Star ratings on cards; hide when there are no reviews | KEEP | P0 | 2 |
| PLP-10 | Mobile filter drawer: every control reachable | KEEP | P0 | 1 |
| PLP-05 | Working, reversible sort and sort by discount | KEEP | P1 | 3 |
| PLP-07 | Variant / swatch display on cards: all-or-none, clear colour chips | MODIFY | P1 | 4 |
| PLP-08 | Price and discount prominence on product cards | KEEP | P1 | 3 |
| PLP-11 | Sub-collection tiles with image fallback | KEEP | P2 | 1 |
| PLP-12 | Quantity, size or portion selectors on listing and home cards | NEEDS RESEARCH | P3 | 3 |

## P0 - core must-have

### PLP-01 - Sticky filter and sort bar

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PLP / Collection | **Secondary:** Other / Global

- **Source says (13 companies):** 13 entries: filters and sort scroll away; users must return to the top to change them. Expected: always accessible (fixed column on desktop, sticky bar or button on mobile).
- **Original description (first source, Helios Pickleball (15 Companies!r62)):** Filter and sorting options should remain as sticky on top of the page so that it is accesible to the users at all time
- **Sources:** Helios Pickleball; Nutricost; Timeline; bebe; Lotus Botanicals; Aroma Magic; Ambrane; Kazo; Meolaa; Wellversed; Life Long India; Biotique; Happilo _[15 Companies!r62; 15 Companies!r78; 15 Companies!r34; httpswww.bebe.com!r9; httpswww.lotusbotanicals.com!r5; httpswww.aromamagic.com!r6; httpswww.ambraneindia.com!r6; httpswww.kazo.com!r6; httpsmeolaa.com!r9; Wellversed!r4; LifelongIndia!r7; httpswww.biotique.com!r6; httpshappilo.com!r5]_
- **Beauty-category sources:** Lotus Botanicals; Aroma Magic; Biotique
- **Purpose / user problem:** Discovery drops when filters are out of reach on long listings.
- **Our reasoning:** Most repeated listing observation in the workbook (13 entries, 13 sites).
- **Suggested implementation:** Collection section with sticky filter/sort bar after scroll (desktop: sticky left sidebar or top bar; mobile: sticky Filter and Sort buttons). Respect header height.
- **Desktop:** Sticky left sidebar or top bar. | **Mobile:** Sticky Filter + Sort buttons under header.
- **Unresolved questions:** Sidebar vs top bar on desktop (design decision).

### PLP-02 - Multi-select filters without a page reload per click

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PLP / Collection | **Secondary:** Other / Global

- **Source says (5 companies):** Filters apply on each click and reload the page, so only one filter can be applied or a selection is reset; users should select several and apply once.
- **Original description (first source, XYXX (XYXX!r5)):** When the filter menu opens, users should be able to select all the parameters to be applied and then click on the apply button to apply them at once
- **Sources:** XYXX; Vicco Labs; Fablestreet; Joy Personal Care; Life Long India _[XYXX!r5; httpswww.viccolabs.com!r8; httpswww.fablestreet.com!r4; httpswww.joypersonalcare.com!r7; LifelongIndia!r7]_
- **Beauty-category sources:** Vicco Labs; Joy Personal Care
- **Purpose / user problem:** Combining attributes (for example skin type plus concern) must be quick.
- **Our reasoning:** Five sources describe the same pain; beauty shoppers combine several attributes.
- **Suggested implementation:** Shopify Storefront Filtering via section rendering API (no full reload). Desktop applies instantly with chips; mobile drawer batches selections with an Apply button.
- **Desktop:** Instant apply with AJAX. | **Mobile:** Drawer with sticky Apply and Clear footer.
- **Unresolved questions:** Instant apply vs Apply button on desktop?

### PLP-03 - Beauty-relevant filter attributes and a common 'all products' listing

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PLP / Collection | **Secondary:** Homepage

- **Source says (7 companies):** Listings offer only price and stock filters; users want type, category, colour, size; Khadi Natural: 'adding filters like Skin Type, Hair Type etc. is essential'; Timeline: one common collection with filters instead of separate collections.
- **Original description (first source, Lotus Botanicals (httpswww.lotusbotanicals.com!r4)):** Adding relevant filterable attibutes on the page like color and sizes, help cater to users need for quicker product discoverability
- **Sources:** Lotus Botanicals; Aroma Magic; Khadi Natural; Ambrane; Itsy Bitsy; Borosil; Timeline _[httpswww.lotusbotanicals.com!r4; httpswww.aromamagic.com!r2; httpswww.khadinatural.com!r4; httpswww.ambraneindia.com!r9; httpsitsybitsy.in!r7; Borosil!r24; 15 Companies!r34]_
- **Beauty-category sources:** Lotus Botanicals; Aroma Magic; Khadi Natural
- **Purpose / user problem:** Narrow a large catalogue to what suits the shopper.
- **Our reasoning:** Three beauty-category sources (Lotus, Aroma Magic, Khadi) plus others; skin type and hair type named explicitly.
- **Suggested implementation:** Filter groups driven by product metafields (skin type, concern, hair type, ingredient, shade, price). Theme supplies the filter UI; the merchant maps metafields to Search and Discovery filters.
- **Desktop:** Collapsible groups in sidebar. | **Mobile:** Accordion groups in drawer.
- **Unresolved questions:** Which attribute set is default (skin type, concern, ingredient, shade)? Metafield schema must be defined.

### PLP-04 - Applied-filter chips and distinct active state

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PLP / Collection | **Secondary:** Other / Global

- **Source says (3 companies):** Applied filters push products down the screen; applied and non-applied filters look alike; expected 'Showing results for <filter>'.
- **Original description (first source, IBA Cosmetics (IBA Cosmetics!r5)):** When the filters are applied, users should be able to identofy the filter applied without affecting the page view
- **Sources:** IBA Cosmetics; Melorra; Vicco Labs _[IBA Cosmetics!r5; Melorra!r6; httpswww.viccolabs.com!r8]_
- **Beauty-category sources:** IBA Cosmetics; Vicco Labs
- **Purpose / user problem:** Users must see what is applied without losing the product grid.
- **Our reasoning:** Three sources, one in a cosmetics store (IBA).
- **Suggested implementation:** Compact chip row (single line, horizontally scrollable) with Clear all, plus a clear selected style for filter options from the design system.
- **Desktop:** Chips above grid, one line. | **Mobile:** Chips under sticky bar; count on the Filter button.
- **Unresolved questions:** None.

### PLP-06 - Prominent quick add / add to cart on product cards

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PLP / Collection | **Secondary:** Homepage

- **Source says (5 companies):** Add to cart on cards is tiny and over the image; Melorra shows 'View similar' instead of add to cart; Zodiac has no add to cart on the grid; Blue Tokai 'Buy Now' sends users to the cart; Borosil CTA text sizes differ on the collection page.
- **Original description (first source, Zelouf Fabrics (15 Companies!r31)):** The add to cart button on the collection page should be more prominent to motivate users to add product to their cart directly
- **Sources:** Zelouf Fabrics; Melorra; Zodiac; Blue Tokai Coffee; Borosil _[15 Companies!r31; Melorra!r7; zodiaconline.com!r2; 15 Companies!r3; Borosil!r12]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Fewer clicks between listing and cart.
- **Our reasoning:** Multiple sources; supports visit-to-cart. For variants quick add should open a chooser.
- **Suggested implementation:** Card with a full-width or clearly sized quick-add button; single-variant adds directly; multi-variant opens a variant chooser; success opens mini cart.
- **Desktop:** Button visible on hover or always. | **Mobile:** Always-visible button, minimum 44px tap target.
- **Unresolved questions:** Always visible or on hover on desktop?

### PLP-09 - Star ratings on cards; hide when there are no reviews

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PLP / Collection | **Secondary:** PDP

- **Source says (2 companies):** Myborosil: PLP shows no average rating, which hurts trust. Zelouf: products with 0 reviews are shown with ratings, creating distrust; show reviews only when significant.
- **Original description (first source, Myborosil (httpsmyborosil.com!r7)):** The PLP should display the avg rating so as to get the visitor's trust
- **Sources:** Myborosil; Zelouf Fabrics _[httpsmyborosil.com!r7; 15 Companies!r30]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Social proof without exposing empty ratings.
- **Our reasoning:** The two entries combine into one rule: show rating when a minimum review count is met.
- **Suggested implementation:** Card shows stars and count when review count is at or above a theme setting (default to be decided); otherwise nothing.
- **Desktop:** Under title. | **Mobile:** Compact stars with count.
- **Unresolved questions:** Default minimum review count? Needs review-app data in metafields.

### PLP-10 - Mobile filter drawer: every control reachable

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PLP / Collection | **Secondary:** Other / Global

- **Source says (1 company):** Borosil: user cannot access the filter option at the bottom of the filters menu on mobile.
- **Original description (first source, Borosil (Borosil!r22)):** User is not able to access the filter option placed right at the bottom in the filters menu on mobile view
- **Sources:** Borosil _[Borosil!r22]_
- **Beauty-category sources:** none
- **Purpose / user problem:** A usable drawer on small screens.
- **Our reasoning:** Direct usability defect; pairs with PLP-02.
- **Suggested implementation:** Full-height drawer with scrollable body and fixed footer (Clear / Apply with result count); tested at 320px and with the browser bar.
- **Desktop:** n/a | **Mobile:** Fixed footer, safe-area padding.
- **Unresolved questions:** None.

## P1 - should have in first release

### PLP-05 - Working, reversible sort and sort by discount

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** PLP / Collection | **Secondary:** Other / Global

- **Source says (3 companies):** Fablestreet: after sorting by price low to high users cannot reverse it. Joy Personal Care: sort options do nothing. Borosil: sale page needs sort by highest discount.
- **Original description (first source, Fablestreet (httpswww.fablestreet.com!r5)):** Users should be allowed to sort the products in ascending and descending orders. Providing a button along with the sort option helps users to navigate the product listing page easily
- **Sources:** Fablestreet; Joy Personal Care; Borosil _[httpswww.fablestreet.com!r5; httpswww.joypersonalcare.com!r8; Borosil!r15]_
- **Beauty-category sources:** Joy Personal Care
- **Purpose / user problem:** Sorting must work and be undoable.
- **Our reasoning:** Three sources; core listing behaviour.
- **Suggested implementation:** Sort select with Featured, Best selling, Price low-high, Price high-low, Newest, and an optional Discount option. A selected state is visible and can be changed back.
- **Desktop:** Select in toolbar. | **Mobile:** Sort bottom sheet.
- **Unresolved questions:** Discount sort needs a metafield or compare-at calculation; confirm.

### PLP-07 - Variant / swatch display on cards: all-or-none, clear colour chips

**Recommendation:** MODIFY | **Priority:** P1 | **Primary page:** PLP / Collection | **Secondary:** PDP

- **Source says (4 companies):** Partial variants shown on cards suggest missing variants (IBA); colour variants shown as small product images are hard to tell apart, use colour shapes (Kazo); variant window too small and variant UI differs between collection and PDP sections (Borosil).
- **Original description (first source, IBA Cosmetics (IBA Cosmetics!r6)):** Users should not be shown partial variants on the products block as users might perceive that as unavailability of the variant they are looking for and avoid visiting the page
- **Sources:** IBA Cosmetics; Kazo; Borosil; Ambrane _[IBA Cosmetics!r6; httpswww.kazo.com!r7; Borosil!r13; Borosil!r18; Borosil!r27; httpswww.ambraneindia.com!r8]_
- **Beauty-category sources:** IBA Cosmetics
- **Purpose / user problem:** Variant choice must be legible and consistent.
- **Our reasoning:** Valid for shade selection in makeup; treatment must be consistent across cards, quick add and PDP.
- **Suggested implementation:** One swatch component: round colour chips with shade name on hover/selection; show up to N then '+X'; text chips for size/volume; identical styling in card, quick add and PDP.
- **Desktop:** Swatches under title. | **Mobile:** Swatches limited to one row with +X.
- **Unresolved questions:** Swatch source: variant option colour or metafield / image?

### PLP-08 - Price and discount prominence on product cards

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** PLP / Collection | **Secondary:** Homepage

- **Source says (3 companies):** Price font small and discount % small or cut off; discounts not highlighted while competitors use them as a motivator.
- **Original description (first source, Nutricost (15 Companies!r79)):** The font for the prices in the product cards should be prominently shown while highlighting the discount % on the products to increase user's perception of value associated with the product purchase
- **Sources:** Nutricost; XYXX; Borosil _[15 Companies!r79; XYXX!r7; Borosil!r14; Borosil!r26]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Show value at a glance.
- **Our reasoning:** Four entries; needs layout that never truncates the discount badge.
- **Suggested implementation:** Card shows price (strong weight), compare-at struck through and a percent-off badge on the image; layout tested with long titles.
- **Desktop:** Badge top-left of image. | **Mobile:** Same, smaller type but not truncated.
- **Unresolved questions:** Percent-off vs amount-off display (merchant setting)?

## P2 - optional / later

### PLP-11 - Sub-collection tiles with image fallback

**Recommendation:** KEEP | **Priority:** P2 | **Primary page:** PLP / Collection | **Secondary:** Homepage

- **Source says (1 company):** Borosil: sub-category featured images missing inside collection pages, so the page looks broken.
- **Original description (first source, Borosil (Borosil!r28)):** Sub category featured images inside collection pages are missing and gives a perception to the users that the page is broken
- **Sources:** Borosil _[Borosil!r28]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Sub-navigation that never looks broken.
- **Our reasoning:** Single source; easy to handle with a fallback.
- **Suggested implementation:** Collection-list section with image fallback (placeholder from tokens) and optional text-only layout.
- **Desktop:** 4-up tiles. | **Mobile:** 2-up tiles.
- **Unresolved questions:** None.

## P3 - later phase or low value

### PLP-12 - Quantity, size or portion selectors on listing and home cards

**Recommendation:** NEEDS RESEARCH | **Priority:** P3 | **Primary page:** PLP / Collection | **Secondary:** Homepage

- **Source says (3 companies):** Biotique and Happilo: users cannot choose quantity or size on home / listing cards; Myborosil: cannot choose 10+ quantity from the listing.
- **Original description (first source, Biotique (httpswww.biotique.com!r2)):** If the User has to buy more than 1 quantity then the user should have the option to select  from home page
- **Sources:** Biotique; Happilo; Myborosil _[httpswww.biotique.com!r2; httpswww.biotique.com!r3; httpswww.biotique.com!r4; httpshappilo.com!r2; httpsmyborosil.com!r6]_
- **Beauty-category sources:** Biotique
- **Purpose / user problem:** Fewer steps for repeat or bulk buyers.
- **Our reasoning:** Conflicts with PLP-06 / HP-03 (keep cards simple). The Biotique and Happilo rows reuse identical wording (Happilo is food: 'portion size'), so the beauty relevance is uncertain.
- **Suggested implementation:** Default: quick add with variant chooser only. A quantity stepper on cards would be optional.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Is quantity on cards needed for beauty (refills, multi-packs)? Check Biotique intent.

