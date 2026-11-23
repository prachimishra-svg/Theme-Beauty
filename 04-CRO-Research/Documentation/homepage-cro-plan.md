# Homepage CRO plan

_Source: Copy of CRO Points for ABM.xlsx (38 tabs read). Facts from the workbook are marked as source statements; reasoning, implementation and priority are our assessment. The workbook has no conversion data, so none is claimed. Detail for every row is in cro-master-feature-matrix.xlsx._

## What the workbook actually says about the homepage

Only nine homepage-specific items exist. Three of them (HP-04, HP-05, HP-09) rest on the single Plum Goodness note, which is the only beauty-category source for the homepage. Most homepage-relevant material in the workbook is technical (layout shift, LCP, lazy loading) and is filed under Other / Global; see [other-features-cro-plan.md](other-features-cro-plan.md) items GLB-01 to GLB-03.

## Proposed homepage section order (our proposal, built only from the items below)

1. Announcement bar and header (see GLB-10, GLB-11)
2. Hero / promo banner, fully clickable with CTA (HP-01)
3. Category / concern tiles that show every option on mobile (HP-07)
4. Featured products that exclude sold-out items, using the shared product card (HP-02, HP-03, PLP-06)
5. Trust block with rating summary and review cards (HP-04), optional press logos (HP-06) and optional video (HP-05)

Sections beauty brands usually add (shop by skin concern, ingredients, routines and bundles, brand story, UGC, education) are **not supported by the workbook**. They are listed in the matrix only where a tab mentions them. Treat any beauty-specific homepage section beyond the five above as a hypothesis to validate, not a finding.

## Summary

| ID | Feature | Rec. | Priority | Companies |
|---|---|---|---|---|
| HP-01 | Fully clickable hero / promo banner with a visible CTA | KEEP | P0 | 2 |
| HP-04 | Trust block: average rating, total reviews and customer review cards | KEEP | P0 | 2 |
| HP-02 | Do not feature out-of-stock products in homepage product blocks | KEEP | P1 | 1 |
| HP-03 | Homepage product-card selectors must work or be removed | MODIFY | P1 | 2 |
| HP-05 | Influencer / UGC video content | NEEDS RESEARCH | P1 | 1 |
| HP-07 | Category / collection tiles show every option on mobile | MODIFY | P1 | 1 |
| HP-06 | Press / 'As featured in' logo strip | KEEP | P2 | 1 |
| HP-08 | Homepage image direction: HD, cohesive, non-distracting backgrounds | KEEP | P2 | 1 |
| HP-09 | Duplicate discount messaging and empty product blocks | NEEDS RESEARCH | P2 | 1 |

## P0 - core must-have

### HP-01 - Fully clickable hero / promo banner with a visible CTA

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Homepage | **Secondary:** PLP / Collection

- **Source says (2 companies):** Whole offer banner should be clickable; hero banner video is not clickable so it acts as passive media; CTA initially hidden behind another element.
- **Original description (first source, Flo Mattress (Flomattress!r19)):** The banner message which says 40% off but is clickable. Users have to locate the CTA which will take them to the page for which offer is being communicated. Also the CTA is hidden bu another element on the page initially and users have to scroll to access the CTA, increasing the overall firction'
- **Sources:** Flo Mattress; Awood Railing _[Flomattress!r19; 15 Companies!r17]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Users cannot reach the promoted offer or collection from the first visible section.
- **Our reasoning:** Two independent sources describe a hero with no obvious click target. Low effort and highest-visibility section.
- **Suggested implementation:** Hero/slideshow section: entire slide wrapped in a link plus a visible primary CTA button. Video hero supports poster image, muted autoplay and CTA overlay. CTA never covered by sticky bars or widgets.
- **Desktop:** CTA inside first viewport; hover/focus state on whole banner. | **Mobile:** Full-width tap target; CTA inside first viewport above any sticky bottom bar.
- **Unresolved questions:** Should the hero video have audio or captions? (see HP-05)

### HP-04 - Trust block: average rating, total reviews and customer review cards

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Homepage | **Secondary:** PDP

- **Source says (2 companies):** Safari: homepage shows only total review count, not clickable, no average. Plum Goodness note: no trust-building elements such as customer reviews and influencer videos; 'these are required in beauty category'.
- **Original description (first source, Safari Bags (safaribags.com!r6)):** Users should be shown not just the total reviews but also the average review ratings. Also, the users should be able to redirect to a reviews page on clicking this section to check all the reviews
- **Sources:** Safari Bags; Plum Goodness _[safaribags.com!r6; Plum Goodness!r2]_
- **Beauty-category sources:** Plum Goodness
- **Purpose / user problem:** First-time visitors need social proof before they trust the brand.
- **Our reasoning:** Beauty-category source explicitly calls it required; a second source shows the weak version (count only, not clickable).
- **Suggested implementation:** Reviews section: average rating, total count, 3-6 review cards with verified badge and product link; the section links to the reviews page or PDP anchor. Data from the review app via metafields.
- **Desktop:** 3-4 card row. | **Mobile:** Swipe carousel with a visible partial next card.
- **Unresolved questions:** Which review app will the theme integrate with? (app dependency)

## P1 - should have in first release

### HP-02 - Do not feature out-of-stock products in homepage product blocks

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** Homepage | **Secondary:** PLP / Collection

- **Source says (1 company):** Navneet: 5 of 6 featured products were out of stock, which makes the site look unable to meet needs at first glance.
- **Original description (first source, Navneet (Navneet!r6)):** Out of Stock products should not be shown in featured products section, as it will make users perceive the website to be unable to meet their reuquirements at the first glance and lead to users bouncing off the website
- **Sources:** Navneet _[Navneet!r6]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Sold-out items in prime homepage slots waste attention and signal poor availability.
- **Our reasoning:** Single source but unambiguous and cheap for a theme to handle.
- **Suggested implementation:** Featured-collection / product-list sections: setting to hide sold-out products, or show a clear Sold out / Notify-me state and sort available first.
- **Desktop:** Fill grid with available products only. | **Mobile:** Same; avoid half-empty carousels.
- **Unresolved questions:** Hide sold-out items or show them with back-in-stock capture (back-in-stock alerts need an app or Shopify Flow)?

### HP-03 - Homepage product-card selectors must work or be removed

**Recommendation:** MODIFY | **Priority:** P1 | **Primary page:** Homepage | **Secondary:** PLP / Collection

- **Source says (2 companies):** Ambrane: colour variant icons on homepage cards do nothing and the cart icon redirects to the cart page. Borosil: quantity and variant buttons in the bestsellers section are not clickable.
- **Original description (first source, Ambrane (httpswww.ambraneindia.com!r8)):** When users click on cart icon, the product should be added to the cart. If that is not intended, then the icon should be changed to view icon for better clarity. Also, since users are not able to select variants from the card block, we should remove the variant selector from the card block. It is better in case of mobile devices that users be redirect to the product page and make the purchase decision
- **Sources:** Ambrane; Borosil _[httpswww.ambraneindia.com!r8; Borosil!r25]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Controls that look interactive but fail erode trust and cause extra clicks.
- **Our reasoning:** The two sources imply different fixes (make functional vs remove). One decision is needed and it must match the PLP quick-add decision (PLP-06).
- **Suggested implementation:** Reuse the single product-card component used on PLP. Show shade/size swatches only when quick add handles them; otherwise omit selectors and link to the PDP.
- **Desktop:** Hover reveals quick add if enabled. | **Mobile:** Tap goes to PDP unless quick add is enabled; no non-functional controls.
- **Unresolved questions:** Quick add on homepage cards: yes or no?

### HP-05 - Influencer / UGC video content

**Recommendation:** NEEDS RESEARCH | **Priority:** P1 | **Primary page:** Homepage | **Secondary:** PDP

- **Source says (1 company):** Plum Goodness note: no influencer videos on the website; separate note 'Video need audio explanation' and 'Link to page to be given'.
- **Original description (first source, Plum Goodness (Plum Goodness!E2)):** Once the add to cart is done, why does the View Cart button come up on the homepage instead of the footer menu. It is hindering in overall navigation, which is the whole point of having a homepage The discounts are repeated and not required. As they are doing this there are product blocks with no information available and could be offputting for the users No trust building elements are present on the homepage / website such as customer reviews and influencer videos that can help with overall branding. These are required in beauty category No comparison feature enabled on the PDP (Pilgrim ne badhia kia hua hai) http://discoverpilgrim.com/products/korean-aloe-cooling-fluid-sunscreen-spf-50-pa?_pos=1&_sid=218c18566&_ss=r We can show head to head comparison against Pilgrim - same category - same tech stack.  Comp: Pilgrim Mcaffine Mama Earth  Video need audio explanation Link to page to be given
- **Sources:** Plum Goodness _[Plum Goodness!r2]_
- **Beauty-category sources:** Plum Goodness
- **Purpose / user problem:** Video from real users builds credibility for beauty products.
- **Our reasoning:** Single source and the note about audio is unclear. Video also carries a performance cost.
- **Suggested implementation:** Optional video-gallery section using native Shopify video: poster image, lazy loading, tap to play/unmute. A UGC feed from a platform would be an app.
- **Desktop:** 4-up row, click opens modal player. | **Mobile:** Horizontal scroller, tap to play.
- **Unresolved questions:** Does 'need audio explanation' mean voice-over, captions, or sound on by default?

### HP-07 - Category / collection tiles show every option on mobile

**Recommendation:** MODIFY | **Priority:** P1 | **Primary page:** Homepage | **Secondary:** PLP / Collection

- **Source says (1 company):** Safari: on mobile the category slider scrolls content out of view, users do not know how many options exist; a dropdown is suggested.
- **Original description (first source, Safari Bags (safaribags.com!r7)):** On mobile devices, users should be shown the entire list of option rather than scrolling content away from the view. Having a dropdown is helpful in identifying all the available options for the users
- **Sources:** Safari Bags _[safaribags.com!r7]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Hidden categories reduce discovery.
- **Our reasoning:** The visibility problem is valid, but a dropdown is a poor fit for image-led beauty tiles (shop by concern / type).
- **Suggested implementation:** Shop-by-category section as a wrapped 2-column grid, or a scroller that clearly peeks the next tile and shows a count.
- **Desktop:** 4-6 tiles in one row. | **Mobile:** 2-column grid or visibly peeking scroller.
- **Unresolved questions:** How many categories or concerns will a typical beauty store show?

## P2 - optional / later

### HP-06 - Press / 'As featured in' logo strip

**Recommendation:** KEEP | **Priority:** P2 | **Primary page:** Homepage | **Secondary:** Other / Global

- **Source says (1 company):** Glam Foods: featured-in section is plain text; logos would help users identify the publication and improve trust.
- **Original description (first source, Glam Foods LLC (httpsglamfoodsllc.com!r5)):** Instead of writing the places where the brand if featured, mentioning logos helps the users identify the brand better. This also improves the users trust and engages the users better.
- **Sources:** Glam Foods LLC _[httpsglamfoodsllc.com!r5]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Third-party credibility at a glance.
- **Our reasoning:** Single non-beauty source, but trivial to build and useful for premium beauty brands.
- **Suggested implementation:** Logo-strip section with image blocks (optionally linked, greyscale treatment from design tokens).
- **Desktop:** Single row of logos. | **Mobile:** 2-up grid or auto-scroll strip.
- **Unresolved questions:** Make this core or optional per merchant?

### HP-08 - Homepage image direction: HD, cohesive, non-distracting backgrounds

**Recommendation:** KEEP | **Priority:** P2 | **Primary page:** Homepage | **Secondary:** Other / Global

- **Source says (1 company):** StyleFox: images should be high-definition with good colour coordination; very vibrant backgrounds draw focus away from the product.
- **Original description (first source, StyleFox (15 Companies!r73)):** The images used on the homepage should be high definition images which have good color coordination to visually appeal to the users and attract them to checkout the product
- **Sources:** StyleFox _[15 Companies!r73]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Visual appeal and product focus.
- **Our reasoning:** This is art direction rather than a component, so capture it as a content guideline in docs and section settings.
- **Suggested implementation:** Image guideline in handoff docs; focal-point and overlay-opacity settings on image sections; use the design-system tokens for overlays.
- **Desktop:** High-resolution responsive srcset. | **Mobile:** Art-directed crops.
- **Unresolved questions:** None.

### HP-09 - Duplicate discount messaging and empty product blocks

**Recommendation:** NEEDS RESEARCH | **Priority:** P2 | **Primary page:** Homepage | **Secondary:** Other / Global

- **Source says (1 company):** Plum Goodness: discounts are repeated and not required; product blocks with no information could put users off.
- **Original description (first source, Plum Goodness (Plum Goodness!E2)):** Once the add to cart is done, why does the View Cart button come up on the homepage instead of the footer menu. It is hindering in overall navigation, which is the whole point of having a homepage The discounts are repeated and not required. As they are doing this there are product blocks with no information available and could be offputting for the users No trust building elements are present on the homepage / website such as customer reviews and influencer videos that can help with overall branding. These are required in beauty category No comparison feature enabled on the PDP (Pilgrim ne badhia kia hua hai) http://discoverpilgrim.com/products/korean-aloe-cooling-fluid-sunscreen-spf-50-pa?_pos=1&_sid=218c18566&_ss=r We can show head to head comparison against Pilgrim - same category - same tech stack.  Comp: Pilgrim Mcaffine Mama Earth  Video need audio explanation Link to page to be given
- **Sources:** Plum Goodness _[Plum Goodness!r2]_
- **Beauty-category sources:** Plum Goodness
- **Purpose / user problem:** Clutter and blank blocks reduce clarity.
- **Our reasoning:** Page-specific observation about one live site; cannot be generalised without seeing the page.
- **Suggested implementation:** Rule for the theme: one discount treatment per card (badge or price, not both); product card always renders image, title and price.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Which blocks and pages were meant? 'Pilgrim ne badhia kia hua hai' refers to a PDP comparison, see PDP-09.

