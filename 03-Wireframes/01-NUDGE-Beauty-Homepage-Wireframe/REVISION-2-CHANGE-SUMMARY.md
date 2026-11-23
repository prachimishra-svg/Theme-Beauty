# NUDGE Beauty Homepage Wireframe: Revision 2 change summary

**File revised in place:** `Homepage_Wireframe_Final.html` (previously `NUDGE-Beauty-Homepage-Wireframe.html`; the pre-revision backup has since been removed).
**Primary reference:** `Homepage_CRO_5_Theme_Final_Comparison_Revised_Final.xlsx` (Beauty column and the Beauty Homepage structure).
**Critical reference (not a template):** `Nudge-Theme-Plan.pdf`, section 4 (competitor studies with good and bad examples) and section 4.6 (the 13 "mistake seen, our rule" rows), plus the Plan's per-preset home order (p47).

## 1. What existed and what this covers

- The project contains **one** wireframe: the Beauty homepage (the README says storefront work started only with it). That is what was corrected.
- **Not covered because no wireframe exists yet:** Beauty PLP, PDP and Cart, and all pages of Clothing, Wellness, Pets and Electronics. Their structures are ready in the revised workbook; they can be wireframed next.
- Not touched: design tokens, design system, assets, research files, the original workbooks.

## 2. Alignment with the revised CRO workbook (Beauty homepage)

All 20 Yes sections are present in the workbook order; none of the 12 No sections is built.

| # | Section | Role in workbook | Status |
|---|---|---|---|
| 1 | Announcement Bar | Essential | kept |
| 2 | Header | Essential | **corrected** (mega menu removed) |
| 3 | Hero Banner | Essential | **corrected** (second button target) |
| 4 | Benefits / USP Row | Essential | kept |
| 5 | Shop by Category | Essential | kept |
| 6 | Featured Collection | Essential | **moved earlier, cards corrected** |
| 7 | Shop by Concern / Need / Routine | Industry-specific | **moved later, routine tiles simplified** |
| 8 | Guided Finder / Quiz | Industry-specific | kept (flagged: after first listing) |
| 9 | Shop the Look | Industry-specific | kept |
| 10 | Ingredient / Material Spotlight | Industry-specific | kept |
| 11 | How to Use / Routine Steps | Industry-specific | kept |
| 12 | Video Section | Industry-specific | kept |
| 13 | Before & After | Industry-specific | kept (flagged: after first listing, claim-safe images) |
| 14 | Testimonials / Customer Reviews | Essential | kept |
| 15 | Customer Photo Gallery | Industry-specific | kept |
| 16 | Logo List | Essential | kept |
| 17 | Promotional / Campaign Banner | Industry-specific | kept |
| 18 | **Custom Liquid Section** | Optional (merchant-controlled) | **added** |
| 19 | Newsletter | Essential | kept |
| 20 | Footer | Essential | kept |

Not built (No for Beauty): Shop by Pet Type, Shop by Occasion, Shop by Device / Use Case, Certifications & Lab Reports, Brand / Craft Story, Size & Fit Guidance, Spec Highlights, Comparison Table, Support & Warranty Info, Expert / Vet Credentials, Help Me Choose Guide, FAQ.

## 3. Sections corrected because of the revised CRO sheet

1. **Order:** Featured Collection is now before Shop by Concern / Routine (Plan p47: featured tabs, then shop by routine).
2. **Custom Liquid Section added** (new in the revised workbook; Theme Store requirement). Shown as an empty dashed slot before the newsletter; takes no space on the storefront while empty.
3. **Product cards:** removed **Add to bag** and the **second-image rollover**. In the revised PLP sheet Quick Add and Second Image on Hover are No for Beauty (shades and sizes are chosen on the product page). Added the **key-attribute line** (Yes for Beauty). Quick View (Yes for Beauty, after the first listing) is not built into the homepage cards.
4. **Header:** removed the **image mega menu**. The workbook gives Beauty the centred-logo header with four plain links; the mega menu is the Clothing variant. Sub-categories belong on the collection page as chips.
5. **Hero second button** ("Find your routine") pointed to the Guided Finder, which the workbook defers. It now points to the routine section that exists at launch.

## 4. Patterns avoided or removed after the PDF review

| Plan 4.6 mistake (seen in competitor themes) | How the wireframe handles it |
|---|---|
| Pop-ups and floating tabs over the page | None. Newsletter is a plain form, no pop-up. |
| Text over busy photos is hard to read | Hero text sits on a solid card beside the image; category captions sit on a solid panel. |
| Heavy pages | Image areas carry exact ratios and sizes for the build; weight is a build check. |
| Dense header (several bars, long menu) | One header row, four links, no mega menu. On phones the search is its own row (kept; see section 6). |
| No H1 or several H1 | One H1 (self-test). |
| Accessibility gaps | 44 px touch targets below 1024 px (self-test). Alt text and names are build tasks. |
| Fake or placeholder content | No countdowns, no invented stock or viewer counts; offers marked "real data only". |
| Demo does not match the industry | Beauty content only. |
| No product visible early | Hero shows a featured-product tag; categories follow the benefit row. |
| Broken or unnamed swatches | Shade dots appear only on products that have shades; named swatches are a product-page requirement. |
| No market selector in the mobile header | Country selector is in the drawer. |

Also deliberately not copied from the reference themes: scrolling slogan bands, a dark announcement bar with a countdown, a floating discount tab.

## 5. Redesigned or improved, and why

- **Routine steps (Shop by Concern / Routine):** four large image tiles repeated the same four steps shown again with images in How to Use. They are now four compact numbered links. Same purpose (jump to a routine step), less repetition and a shorter page.
- **Cards:** shade dots only where they mean something (before, a cleanser and a moisturiser showed colour dots); prices now align across cards whatever a card contains; the whole card is the tap target.
- **Review notes inside the page** (checklist, native-or-app table, validation tables) were brought up to date, including the implementation types from the revised workbook (guided finder is custom development; header country selector and newsletter form depend on Shopify store setup).

## 6. Reviewed and deliberately not changed

- Hero with one H1 and two buttons (CRO-HOM-007 allows one or two).
- Mobile header: announcement, then menu / logo / icons, then a full-width search row. Kept because the workbook asks for search always visible; hiding the search row on scroll is a build-stage option.
- Placeholder five-star rows in Testimonials (labelled as layout placeholders; stars should appear only if the merchant supplies ratings).
- Guided Finder and Before & After stay in the page as the workbook says Yes, flagged as after the first listing.

## 7. Validation (2026-11-04)

- Page self-test (10 checks per width): **10 of 10** at 1920, 1440, 1024, 768, 390, 375, 320 px in **Edge 156 and Chrome 156**; also at 1023, 767, 600 and 599 px, with the drawer open and with hover states on.
- Behaviour test (22 checks, Edge and Chrome): section count, order, numbering and anchor links; hero button targets; mega menu and Add to bag gone; card structure; tab switching with attribute lines and shade dots; routine links; Custom Liquid slot; drawer open and Escape close; toggles; finder to result; no script errors. All pass. (The test was run on the final candidate; the installed file differs from it only by one CSS comment.)
- Visual check of desktop (1440) and phone (390 px frame) renders.

**Limits:** headless Chromium only (Firefox, Safari, real phones, screen readers and browser text zoom not tested). The earlier validation table's grid-column counts did not match what the page measures; they were replaced with the measured values.
