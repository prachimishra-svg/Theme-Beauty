# PDP CRO plan

_Source: Copy of CRO Points for ABM.xlsx (38 tabs read). Facts from the workbook are marked as source statements; reasoning, implementation and priority are our assessment. The workbook has no conversion data, so none is claimed. Detail for every row is in cro-master-feature-matrix.xlsx._

## What the workbook says

The strongest PDP signals are sticky add to cart (19 entries), buy box in the first fold (6), price and discount prominence (4), clear variant selection (4) and returns / delivery reassurance. Beauty-specific PDP content (ingredients, how to use, results, suitability) is only touched by one note (Meolaa: not enough description and enhanced brand content, no how-to-use). The rest is **not source-supported** and should be added as hypotheses from outside the workbook.

## Summary

| ID | Feature | Rec. | Priority | Companies |
|---|---|---|---|---|
| PDP-01 | Buy box in the first fold: price, variants, quantity and add to cart | KEEP | P0 | 6 |
| PDP-02 | Sticky add-to-cart bar | KEEP | P0 | 19 |
| PDP-04 | Clear variant selection | KEEP | P0 | 4 |
| PDP-05 | Prominent price and discount treatment | KEEP | P0 | 3 |
| PDP-06 | Reviews and average rating on the PDP | KEEP | P0 | 1 |
| PDP-08 | Complete product information: description, how to use, enhanced content | KEEP | P0 | 1 |
| PDP-03 | Sticky bar and toasts never overlapped by floating widgets | KEEP | P1 | 3 |
| PDP-07 | Review display policy (hide low or zero reviews) | MODIFY | P1 | 4 |
| PDP-09 | Product comparison table | MODIFY | P1 | 2 |
| PDP-10 | Delivery estimate and pincode check without pushing add to cart down | KEEP | P1 | 4 |
| PDP-11 | Returns and shipping reassurance on PDP and near checkout | KEEP | P1 | 3 |
| PDP-19 | Breadcrumb free of filter query parameters | KEEP | P1 | 1 |
| PDP-13 | Buy now / direct checkout behaviour | MODIFY | P2 | 3 |
| PDP-15 | Conversion-friendly CTA label | MODIFY | P2 | 1 |
| PDP-18 | Product video with explanation | NEEDS RESEARCH | P2 | 1 |
| PDP-12 | Visual size chart / dimension guide | SKIP | P3 | 1 |
| PDP-14 | Offer countdown and offer-price explanation | NEEDS RESEARCH | P3 | 1 |
| PDP-16 | PDP UI polish: accordion toggles, USP spacing, star colours, field truncation | KEEP | P3 | 1 |
| PDP-17 | Rewards: post-login confirmation on the same page | NEEDS RESEARCH | P3 | 1 |
| PDP-20 | Items not applicable to beauty or unclear in the source | SKIP | P3 | 2 |

## P0 - core must-have

### PDP-01 - Buy box in the first fold: price, variants, quantity and add to cart

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PDP | **Secondary:** Cart

- **Source says (6 companies):** Add to cart is not visible in the first fold; only the title shows; product information shifts down on load and a product list distracts (bebe).
- **Original description (first source, Havells (httpshavells.com!r2)):** When users land on the PDP users should readily see the Buy button on the page which acts as a stimulus for the users to make a purchase decision
- **Sources:** Havells; Fire-Boltt; Max Protein; GoDPS Music; Sugar Lash Pro; bebe _[httpshavells.com!r2; httpswww.fireboltt.com!r2; httpsmaxprotein.in!r6; 15 Companies!r9; 15 Companies!r42; httpswww.bebe.com!r5]_
- **Beauty-category sources:** Sugar Lash Pro
- **Purpose / user problem:** Users can decide to buy without scrolling.
- **Our reasoning:** Six entries across six sites.
- **Suggested implementation:** Product section: media and buy box side by side on desktop; on mobile gallery height capped so title, price, variant and add to cart peek into the first viewport. Reserve space to avoid layout shift.
- **Desktop:** Two-column, buy box sticky beside gallery. | **Mobile:** Compact gallery then buy box; ATC in first viewport or sticky bar.
- **Unresolved questions:** Gallery height on mobile (design decision).

### PDP-02 - Sticky add-to-cart bar

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PDP | **Secondary:** Cart

- **Source says (19 companies):** 19 entries: sticky add to cart missing or only appears late. Details: show price (Safari), clicking should ask for variant (IBA, XYXX), bottom placement is thumb-friendly (Eureka Forbes, Biotique).
- **Original description (first source, Oxyfresh (15 Companies!r24)):** The add to cart sticky should be visible on the page when the actual add to cart button is not present in the view, this enable users to make a purchase decision at any point in time
- **Sources:** Oxyfresh; Zelouf Fabrics; Timeline; Ozlo Sleep; Sugar Lash Pro; Apo Shop; Helios Pickleball; Wdrobe Apparel; Nutricost; bebe; IBA Cosmetics; XYXX; Aroma Magic; Vicco Labs; Khadi Natural; Safari Bags; Eureka Forbes; Biotique; Life Long India _[15 Companies!r24; 15 Companies!r29; 15 Companies!r33; 15 Companies!r37; 15 Companies!r40; 15 Companies!r47; 15 Companies!r63; 15 Companies!r67; 15 Companies!r77; httpswww.bebe.com!r7; IBA Cosmetics!r4; XYXX!r6; httpswww.aromamagic.com!r4; httpswww.viccolabs.com!r4; httpswww.khadinatural.com!r7; safaribags.com!r4; httpeurekaforbes.com!r3; httpswww.biotique.com!r8; LifelongIndia!r3]_
- **Beauty-category sources:** Sugar Lash Pro; IBA Cosmetics; Aroma Magic; Vicco Labs; Khadi Natural; Biotique
- **Purpose / user problem:** Keep the purchase action reachable on long pages.
- **Our reasoning:** Most repeated item in the workbook (19 entries).
- **Suggested implementation:** Sticky bar shown when the main button leaves the viewport: thumbnail, title, selected variant, price and Add to cart; if no variant is selected the button opens the variant chooser.
- **Desktop:** Top or bottom bar after scroll. | **Mobile:** Bottom bar, safe-area aware.
- **Unresolved questions:** Top vs bottom on desktop.

### PDP-04 - Clear variant selection

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PDP | **Secondary:** PLP / Collection

- **Source says (4 companies):** Selected variant not prominent; dropdown and swatches both select the same variant; single-volume products still show a dropdown; button greyed out until a variant is picked so product looks non-purchasable.
- **Original description (first source, Blue Tokai Coffee (15 Companies!r4)):** Currently selected variant should be prominent so that users are able to determine that variants need to be selected on the page.
- **Sources:** Blue Tokai Coffee; Zelouf Fabrics; Myborosil; XYXX _[15 Companies!r4; 15 Companies!r28; httpsmyborosil.com!r8; XYXX!r6]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Users should know what to choose and what is chosen.
- **Our reasoning:** Four entries; essential for shade and size options in beauty.
- **Suggested implementation:** One variant picker per option (swatches for shade, buttons for size, dropdown only for long lists); strong selected state; no picker for single-option products; add to cart stays enabled and prompts for a missing choice.
- **Desktop:** Inline pickers with labels. | **Mobile:** Same, large tap targets.
- **Unresolved questions:** None.

### PDP-05 - Prominent price and discount treatment

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PDP | **Secondary:** Cart

- **Source says (3 companies):** Price shown small or in grey with no discount; offer price text and price should differ in size and colour; explanation of how to get the offer price should be closer to the price but less prominent.
- **Original description (first source, Max Protein (httpsmaxprotein.in!r7)):** The price on the PDP should be shown in a prominent font color, size and weight while highlighting the discount which users will be getting, this will enable users to associate value with their purchase decision and convert
- **Sources:** Max Protein; bebe; Flo Mattress _[httpsmaxprotein.in!r7; httpswww.bebe.com!r6; Flomattress!r4; Flomattress!r5]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Communicate value.
- **Our reasoning:** Four entries; supports price perception.
- **Suggested implementation:** Price block: sale price in accent weight, compare-at struck through, percent saved, small secondary offer text.
- **Desktop:** Beside title. | **Mobile:** Under title, above variants.
- **Unresolved questions:** None.

### PDP-06 - Reviews and average rating on the PDP

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PDP | **Secondary:** Homepage

- **Source says (1 company):** Meolaa: no product rating or reviews on the PDP; should show verified users' reviews and average rating.
- **Original description (first source, Meolaa (httpsmeolaa.com!r6)):** The PDP should display the verified user's reviews and avg rating so as to get the visitor's trust
- **Sources:** Meolaa _[httpsmeolaa.com!r6]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Trust at decision time.
- **Our reasoning:** Standard requirement; one source reports its absence.
- **Suggested implementation:** Rating summary near the title with anchor to a reviews section (summary, photos, filters). Data via review app.
- **Desktop:** Under title; reviews section below the fold. | **Mobile:** Stars under title; reviews in an accordion or section.
- **Unresolved questions:** Review app choice.

### PDP-08 - Complete product information: description, how to use, enhanced content

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** PDP | **Secondary:** Other / Global

- **Source says (1 company):** Meolaa: not enough product description and enhanced brand content; users cannot understand how to use the product.
- **Original description (first source, Meolaa (httpsmeolaa.com!r7)):** The product page should be able to show all the required information.
- **Sources:** Meolaa _[httpsmeolaa.com!r7]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Informed purchase decisions.
- **Our reasoning:** One source, but central for beauty where ingredients and usage drive trust.
- **Suggested implementation:** Structured sections or accordions: benefits, ingredients, how to use, skin type, FAQs; driven by metafields.
- **Desktop:** Accordions beside or under the buy box. | **Mobile:** Accordions below the buy box.
- **Unresolved questions:** Metafield schema for ingredients and usage.

## P1 - should have in first release

### PDP-03 - Sticky bar and toasts never overlapped by floating widgets

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** PDP | **Secondary:** Other / Global

- **Source says (3 companies):** WhatsApp sticky button covers the add-to-cart sticky (Havells, Fire-Boltt); sticky add to cart overlaps the wishlist notification (Itsy Bitsy).
- **Original description (first source, Havells (httpshavells.com!r3)):** The add to cart sticky should be easily clickable and add products to the cart instantly. Also, no other element should overlap with the add to cart button to ensure that users are able to perform this action with ease, thereby increasing visit to cart ratio
- **Sources:** Havells; Fire-Boltt; Itsy Bitsy _[httpshavells.com!r3; httpswww.fireboltt.com!r3; httpsitsybitsy.in!r8]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Overlaps look broken and block the purchase button.
- **Our reasoning:** Three entries; an easy layering rule for the theme.
- **Suggested implementation:** Defined z-index scale in the design tokens; floating widgets offset above the sticky bar; toasts on the top layer.
- **Desktop:** n/a | **Mobile:** Widgets move up when sticky bar is visible.
- **Unresolved questions:** Which third-party widgets must be supported (chat, WhatsApp)?

### PDP-07 - Review display policy (hide low or zero reviews)

**Recommendation:** MODIFY | **Priority:** P1 | **Primary page:** PDP | **Secondary:** PLP / Collection

- **Source says (4 companies):** Do not show products with 0 reviews; publish only reviews rated 3 or higher; do not show low-rated products unless higher ratings significantly outweigh them.
- **Original description (first source, Max Protein (httpsmaxprotein.in!r9)):** The reviews for the which have ratings 3 or higher should only be published on the website to increase user trust in the products and motivate users to make a purchase
- **Sources:** Max Protein; Navneet; Sugar Lash Pro; Nutricost _[httpsmaxprotein.in!r9; Navneet!r5; 15 Companies!r41; 15 Companies!r80]_
- **Beauty-category sources:** Sugar Lash Pro
- **Purpose / user problem:** Avoid a weak first impression.
- **Our reasoning:** Hiding rating widgets until a minimum count is sensible. Deleting or hiding negative reviews is a different matter and can breach consumer-protection rules in some markets (verify with the client's legal advice). This caution is our own, not from the workbook.
- **Suggested implementation:** Theme setting: show stars only above a minimum review count; show review list unfiltered; never filter by star rating in the theme.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Does the merchant want to suppress reviews? Legal check needed.

### PDP-09 - Product comparison table

**Recommendation:** MODIFY | **Priority:** P1 | **Primary page:** PDP | **Secondary:** Other / Global

- **Source says (2 companies):** Flo Mattress: a comparison table at the bottom of the PDP helps decisions. Plum Goodness: no comparison feature on the PDP; suggests head-to-head comparison against Pilgrim (Mamaearth, mCaffeine also listed as competitors).
- **Original description (first source, Flo Mattress (Flomattress!r2)):** Product comparison table at the bottom of the PDP will help the users take a decision
- **Sources:** Flo Mattress; Plum Goodness _[Flomattress!r2; Plum Goodness!r2]_
- **Beauty-category sources:** Plum Goodness
- **Purpose / user problem:** Help users choose between options.
- **Our reasoning:** Comparing the merchant's own products or variants is a safe theme feature. Head-to-head against a named competitor is merchant content with legal risk and should not be built in.
- **Suggested implementation:** Comparison section with rows driven by metafields for the merchant's own products (for example routine steps or formulas).
- **Desktop:** Table with 2-4 columns. | **Mobile:** Horizontal scroll with sticky first column or cards.
- **Unresolved questions:** Own-product comparison only? Confirm with the pitch team.

### PDP-10 - Delivery estimate and pincode check without pushing add to cart down

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** PDP | **Secondary:** Cart

- **Source says (4 companies):** Serviceability checker pushes variant, quantity and add to cart below the fold; show it below the button; expected delivery date missing after pincode entry; ETA differs between PDP and checkout; cart shows no delivery date.
- **Original description (first source, Max Protein (httpsmaxprotein.in!r8)):** The serviceability checker widget should be placed below the add to cart button, so that users first response is to purchase the product rather than check its servicability and increase user fatigue
- **Sources:** Max Protein; Flo Mattress; IBA Cosmetics; Mivi _[httpsmaxprotein.in!r8; Flomattress!r12; IBA Cosmetics!r8; httpswww.mivi.in!r9]_
- **Beauty-category sources:** IBA Cosmetics
- **Purpose / user problem:** Remove delivery uncertainty without hurting the buy box.
- **Our reasoning:** Four entries; India-specific, so a setting-driven component.
- **Suggested implementation:** Compact pincode field under the add-to-cart button; result shows date range. The pincode lookup needs an integration or app, and the same ETA logic must be used in cart.
- **Desktop:** Under ATC. | **Mobile:** Collapsed link that expands.
- **Unresolved questions:** Which serviceability API or app is used? ETA consistency with checkout is not controllable by the theme.

### PDP-11 - Returns and shipping reassurance on PDP and near checkout

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** PDP | **Secondary:** Cart

- **Source says (3 companies):** A 10-day easy-returns message should appear on the PDP and next to the checkout button or in the cart summary.
- **Original description (first source, Eureka Forbes (httpeurekaforbes.com!r4)):** When users are on the cart page, if they are preovided assurance that even if the product turns out to be not what they wanted, they will be able to easiliy return the product withing 10 days, it motivates the users to go ahead with the chekout journey It should be placed close to the “Proceed to Checkout” button or within the checkout summary to ensure users can see it just before committing to the purchase.
- **Sources:** Eureka Forbes; Biotique; Happilo _[httpeurekaforbes.com!r4; httpswww.biotique.com!r9; httpshappilo.com!r6]_
- **Beauty-category sources:** Biotique
- **Purpose / user problem:** Reduce purchase anxiety.
- **Our reasoning:** Three entries. The '10 day' wording is brand-specific and must be a setting.
- **Suggested implementation:** Reassurance block with icon and short text under ATC, and in the cart summary; text from settings.
- **Desktop:** Below ATC. | **Mobile:** Below ATC, one line each.
- **Unresolved questions:** Return policy copy per merchant.

### PDP-19 - Breadcrumb free of filter query parameters

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** PDP | **Secondary:** Other / Global

- **Source says (1 company):** IBA Cosmetics: breadcrumb shows filter parameters after filtering and the page breaks with a horizontal scroll.
- **Original description (first source, IBA Cosmetics (IBA Cosmetics!r7)):** The breadcrumb should not show the filters as part of the current page as it would make the users perceive the website to be broken when they see filter query parameters
- **Sources:** IBA Cosmetics _[IBA Cosmetics!r7]_
- **Beauty-category sources:** IBA Cosmetics
- **Purpose / user problem:** Clean navigation trail.
- **Our reasoning:** Single beauty source; breadcrumb should use the collection URL only.
- **Suggested implementation:** Breadcrumb built from collection and product, never from query strings; wrap text to avoid overflow.
- **Desktop:** Above title. | **Mobile:** Single line with ellipsis.
- **Unresolved questions:** None.

## P2 - optional / later

### PDP-13 - Buy now / direct checkout behaviour

**Recommendation:** MODIFY | **Priority:** P2 | **Primary page:** PDP | **Secondary:** Cart

- **Source says (3 companies):** Buy Now should go directly to checkout with the product; Ozlo's Buy sends users to another product page; Vicco offers checkout-only for some products with no add to cart.
- **Original description (first source, Blue Tokai Coffee (15 Companies!r3)):** Users should be able to move the products directly to their cart and move to checkout whith single click on the collections pag
- **Sources:** Blue Tokai Coffee; Ozlo Sleep; Vicco Labs _[15 Companies!r3; 15 Companies!r36; httpswww.viccolabs.com!r7]_
- **Beauty-category sources:** Vicco Labs
- **Purpose / user problem:** Shorter path for decided buyers without losing add to cart.
- **Our reasoning:** Keep add to cart always available; Buy now goes directly to checkout.
- **Suggested implementation:** Shopify dynamic checkout buttons as a setting; no product forced into checkout only.
- **Desktop:** Secondary button. | **Mobile:** Secondary button under ATC.
- **Unresolved questions:** Enable dynamic checkout (Shop Pay, GPay)? Depends on payment setup.

### PDP-15 - Conversion-friendly CTA label

**Recommendation:** MODIFY | **Priority:** P2 | **Primary page:** PDP | **Secondary:** Other / Global

- **Source says (1 company):** Awood Railing: label should be Book Now / Buy Now / Get Yours Now rather than 'Get Started Now'.
- **Original description (first source, Awood Railing (15 Companies!r18)):** The text for motivating users to avail a product should be Book Now, Buy Now, Get Yours Now etc. which acts a stimulus for users to make a purchase decision
- **Sources:** Awood Railing _[15 Companies!r18]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Clear action wording.
- **Our reasoning:** Label is B2B-specific; a theme setting for button copy covers it.
- **Suggested implementation:** Editable ATC and Buy labels with sensible defaults.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### PDP-18 - Product video with explanation

**Recommendation:** NEEDS RESEARCH | **Priority:** P2 | **Primary page:** PDP | **Secondary:** Homepage

- **Source says (1 company):** Plum Goodness note: 'Video need audio explanation'.
- **Original description (first source, Plum Goodness (Plum Goodness!E2)):** Once the add to cart is done, why does the View Cart button come up on the homepage instead of the footer menu. It is hindering in overall navigation, which is the whole point of having a homepage The discounts are repeated and not required. As they are doing this there are product blocks with no information available and could be offputting for the users No trust building elements are present on the homepage / website such as customer reviews and influencer videos that can help with overall branding. These are required in beauty category No comparison feature enabled on the PDP (Pilgrim ne badhia kia hua hai) http://discoverpilgrim.com/products/korean-aloe-cooling-fluid-sunscreen-spf-50-pa?_pos=1&_sid=218c18566&_ss=r We can show head to head comparison against Pilgrim - same category - same tech stack.  Comp: Pilgrim Mcaffine Mama Earth  Video need audio explanation Link to page to be given
- **Sources:** Plum Goodness _[Plum Goodness!r2]_
- **Beauty-category sources:** Plum Goodness
- **Purpose / user problem:** Show how a product is used.
- **Our reasoning:** Note is a fragment without context.
- **Suggested implementation:** Native product video in the gallery with poster, captions option.
- **Desktop:** In gallery. | **Mobile:** In gallery.
- **Unresolved questions:** Clarify what was meant by audio explanation.

## P3 - later phase or low value

### PDP-12 - Visual size chart / dimension guide

**Recommendation:** SKIP | **Priority:** P3 | **Primary page:** PDP | **Secondary:** Other / Global

- **Source says (1 company):** Safari Bags: sizes shown as plain text; show the product against a person or mark dimensions on the image.
- **Original description (first source, Safari Bags (safaribags.com!r5)):** User should be able to visually understand the dimesions of the product. Having a size chart which will be helpful for the users to undestand the product dimensions.For e.g. showing the product against a 6 ft. person or showing the image and marking the dimesions against the exact edges of the product
- **Sources:** Safari Bags _[safaribags.com!r5]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Understand physical size.
- **Our reasoning:** Luggage-specific. Beauty analogues (shade guide, volume comparison) are covered by PDP-04 and later shade-finder work.
- **Suggested implementation:** None in core.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### PDP-14 - Offer countdown and offer-price explanation

**Recommendation:** NEEDS RESEARCH | **Priority:** P3 | **Primary page:** PDP | **Secondary:** Other / Global

- **Source says (1 company):** Countdown shows days, hours, minutes and seconds; only one unit should be shown.
- **Original description (first source, Flo Mattress (Flomattress!r5)):** Mention of how to get the offer price can be closer to the Offer price and less prominent
- **Sources:** Flo Mattress _[Flomattress!r5; Flomattress!r6]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Urgency without noise.
- **Our reasoning:** Countdown timers risk looking manipulative; only worth including as an optional block.
- **Suggested implementation:** Optional announcement or price-block countdown with a single unit; end time from settings.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Include at all?

### PDP-16 - PDP UI polish: accordion toggles, USP spacing, star colours, field truncation

**Recommendation:** KEEP | **Priority:** P3 | **Primary page:** PDP | **Secondary:** Other / Global

- **Source says (1 company):** Extra space between USPs; quantity field value cut off for two-digit numbers in You may also like; review star colours inconsistent between summary and grid; View all / View less shown for a single FAQ.
- **Original description (first source, Borosil (Borosil!r16)):** Extra space between the USPs on product page
- **Sources:** Borosil _[Borosil!r16; Borosil!r17; Borosil!r19; Borosil!r20]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Consistent, bug-free UI.
- **Our reasoning:** QA-level items that the component library should handle by default.
- **Suggested implementation:** Accordion hides toggle when under N items; consistent star token; quantity input width for 2+ digits; tokenised spacing.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### PDP-17 - Rewards: post-login confirmation on the same page

**Recommendation:** NEEDS RESEARCH | **Priority:** P3 | **Primary page:** PDP | **Secondary:** Other / Global

- **Source says (1 company):** After logging in to get rewards, users land on the account page with no confirmation; should return to the PDP with a success message.
- **Original description (first source, bebe (httpswww.bebe.com!r8)):** When users click on the login link to get awards, post login users should be redirect to the page on which they had clicked on the login link, while a message is shown to the user that they have successfully received the rewards and they can use it on the checkout page
- **Sources:** bebe _[httpswww.bebe.com!r8]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Close the loop on loyalty actions.
- **Our reasoning:** Depends on the loyalty app and customer accounts.
- **Suggested implementation:** Only a rewards entry point and return-URL support; logic belongs to the loyalty app.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Will the theme include loyalty at all?

### PDP-20 - Items not applicable to beauty or unclear in the source

**Recommendation:** SKIP | **Priority:** P3 | **Primary page:** PDP | **Secondary:** Cart

- **Source says (2 companies):** Flo Mattress: Ortho recommended too early on the Ergo page; unclear item 'Only can be added after Price per night'; custom-size message unclear. Ozlo: buy and rent flows differ.
- **Original description (first source, Flo Mattress (Flomattress!r3)):** On Ergo page, we are recommending the Ortho product too early (at the top itself). Let us user see the Ergo page first.
- **Sources:** Flo Mattress; Ozlo Sleep _[Flomattress!r3; Flomattress!r7; Flomattress!r8; 15 Companies!r38]_
- **Beauty-category sources:** none
- **Purpose / user problem:** n/a
- **Our reasoning:** Mattress-specific or unclear. The buy-versus-rent idea maps loosely to subscription or replenishment later.
- **Suggested implementation:** None.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** FL row 7 wording needs the author's clarification.

