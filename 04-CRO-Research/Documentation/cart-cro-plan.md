# Cart CRO plan

_Source: Copy of CRO Points for ABM.xlsx (38 tabs read). Facts from the workbook are marked as source statements; reasoning, implementation and priority are our assessment. The workbook has no conversion data, so none is claimed. Detail for every row is in cro-master-feature-matrix.xlsx._

## What the workbook says

The cart is the second most documented area: sticky checkout (5), checkout from mini cart (4), add-to-cart feedback (4), upsell visibility (12), price transparency (10), remove confirmation (15) and save for later (12). The checkout itself is Shopify-controlled; those items are in [other-features-cro-plan.md](other-features-cro-plan.md) (CHK-01 to CHK-07).

## Summary

| ID | Feature | Rec. | Priority | Companies |
|---|---|---|---|---|
| CRT-01 | Add-to-cart feedback via mini cart or toast, no redirect | KEEP | P0 | 4 |
| CRT-02 | Checkout directly from the mini cart | KEEP | P0 | 4 |
| CRT-03 | Sticky checkout button | KEEP | P0 | 5 |
| CRT-04 | Mini cart lists every item with correct totals | KEEP | P0 | 1 |
| CRT-06 | Transparent price summary | KEEP | P0 | 10 |
| CRT-05 | Cart upsell / recommendations visible without scrolling and addable in place | KEEP | P1 | 11 |
| CRT-09 | Discount code and available offers display | MODIFY | P1 | 6 |
| CRT-10 | Quantity selector rules and stock messages | MODIFY | P1 | 5 |
| CRT-11 | Cart layout efficiency | KEEP | P1 | 3 |
| CRT-12 | Estimated delivery date in cart | KEEP | P1 | 2 |
| CRT-13 | Continue shopping secondary CTA | KEEP | P1 | 1 |
| CRT-14 | Terms checkbox before checkout | MODIFY | P1 | 3 |
| CRT-16 | Benefit messages beside cart items (free shipping and similar) | KEEP | P1 | 1 |
| CRT-07 | Remove-from-cart confirmation | MODIFY | P2 | 15 |
| CRT-08 | Save for later / move to wishlist | MODIFY | P2 | 12 |
| CRT-15 | One checkout button per customer region | MODIFY | P2 | 2 |
| CRT-17 | Later-phase cart ideas: edit variant in cart and post-purchase upsell | NEEDS RESEARCH | P3 | 3 |

## P0 - core must-have

### CRT-01 - Add-to-cart feedback via mini cart or toast, no redirect

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Cart | **Secondary:** PDP

- **Source says (4 companies):** Users are taken to the cart page after add to cart, which makes adding more items harder; expected a notification with a link to the cart; Vicco: show only the mini cart; Plum Goodness: View Cart button appears on the homepage after adding.
- **Original description (first source, GoDPS Music (15 Companies!r10)):** Users should be notified that a product has been added to their cart and there should be an option for users to check their cart along with the notification. This enables users to either move to cart page for next steps or remain on the page explore other items as well
- **Sources:** GoDPS Music; Bearded Crew; Vicco Labs; Plum Goodness _[15 Companies!r10; 15 Companies!r53; httpswww.viccolabs.com!r5; Plum Goodness!r2]_
- **Beauty-category sources:** Vicco Labs; Plum Goodness
- **Purpose / user problem:** Keep shoppers browsing and raise basket size.
- **Our reasoning:** Four entries; matches the listing and PDP flows.
- **Suggested implementation:** Cart type setting: drawer (default) or notification; add to cart opens the drawer or shows a toast with View cart and Checkout.
- **Desktop:** Right-hand drawer. | **Mobile:** Bottom sheet or full-height drawer.
- **Unresolved questions:** Drawer vs notification as default.

### CRT-02 - Checkout directly from the mini cart

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (4 companies):** Redundant View Cart step between add to cart and checkout; users should be shown only the checkout button; extra disclaimer click before checkout.
- **Original description (first source, Max Protein (httpsmaxprotein.in!r2)):** When users are already on the mini cart redirecting them to the cart page increase the number of clicks required to make the purchase and thus increasing the user fatigue
- **Sources:** Max Protein; Kazo; Itsy Bitsy; GoDPS Music _[httpsmaxprotein.in!r2; httpswww.kazo.com!r5; httpsitsybitsy.in!r6; 15 Companies!r12]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Fewer clicks to purchase.
- **Our reasoning:** Four entries.
- **Suggested implementation:** Mini cart has Checkout as primary; a View cart link is a text link only.
- **Desktop:** Drawer footer. | **Mobile:** Sticky footer.
- **Unresolved questions:** Keep a full cart page at all?

### CRT-03 - Sticky checkout button

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (5 companies):** Checkout button moves off screen when several products are added.
- **Original description (first source, Blue Tokai Coffee (15 Companies!r5)):** The checkout button in the cart page should be a sticky and visible to the users at all time, to enable users to move to checkout as soon as they finalize purchase
- **Sources:** Blue Tokai Coffee; Wdrobe Apparel; bebe; Life Long India; Wellversed _[15 Companies!r5; 15 Companies!r68; httpswww.bebe.com!r2; LifelongIndia!r2; Wellversed!r2]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Checkout always reachable.
- **Our reasoning:** Five entries.
- **Suggested implementation:** Footer with subtotal and Checkout fixed in drawer and on cart page (mobile).
- **Desktop:** Sticky summary column. | **Mobile:** Sticky bottom bar.
- **Unresolved questions:** None.

### CRT-04 - Mini cart lists every item with correct totals

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (1 company):** Helios Pickleball: mini cart shows only one product.
- **Original description (first source, Helios Pickleball (15 Companies!r64)):** The minicart should show all product list added to the cart, along with the correct price summary to enable users to checkout with minimal clicks
- **Sources:** Helios Pickleball _[15 Companies!r64]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Accurate summary.
- **Our reasoning:** Basic correctness.
- **Suggested implementation:** Scrollable item list with fixed header and footer.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### CRT-06 - Transparent price summary

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (10 companies):** Show original price, discount, taxes and shipping; VAT mentioned but not shown; savings hidden in a small dropdown; Lotus: original and discounted price identical in the cart.
- **Original description (first source, Timeline (15 Companies!r35)):** The price summary should be clearly showing the breakup of the prices include the dicounts, taxes, or any other hidden cost, to help the users make a purchase decision without having to worry about additional or incorrect charges
- **Sources:** Timeline; Max Protein; bebe; IBA Cosmetics; XYXX; Navneet; Ambrane; Lotus Botanicals; Eureka Forbes; Happilo _[15 Companies!r35; httpsmaxprotein.in!r4; httpswww.bebe.com!r4; IBA Cosmetics!r3; XYXX!r3; Navneet!r4; httpswww.ambraneindia.com!r5; httpswww.lotusbotanicals.com!r7; httpeurekaforbes.com!r5; httpshappilo.com!r8]_
- **Beauty-category sources:** IBA Cosmetics; Lotus Botanicals
- **Purpose / user problem:** Trust and no surprises at checkout.
- **Our reasoning:** Ten entries.
- **Suggested implementation:** Always-expanded summary: subtotal, discounts, savings, shipping or threshold message, tax note; per-line compare-at price.
- **Desktop:** Summary column. | **Mobile:** Compact summary above footer.
- **Unresolved questions:** Tax display depends on store tax settings. Happilo row repeats Eureka Forbes wording (installation), so only the principle is used.

## P1 - should have in first release

### CRT-05 - Cart upsell / recommendations visible without scrolling and addable in place

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** Cart | **Secondary:** PDP

- **Source says (11 companies):** Recommendations are hidden after scroll or absent; adding a recommendation sends users to another cart view; Borosil needs two scrolls to reach add to cart for recommendations.
- **Original description (first source, Mivi (httpswww.mivi.in!r10)):** The cart doesn't offer upsell/cross-sell products with benefits or urgency ("Now or never") or a special discount.
- **Sources:** Mivi; Oxyfresh; Sugar Lash Pro; Max Protein; XYXX; Safari Bags; Kazo; Itsy Bitsy; Joy Personal Care; Zodiac; Borosil _[httpswww.mivi.in!r10; 15 Companies!r23; 15 Companies!r43; httpsmaxprotein.in!r3; XYXX!r2; safaribags.com!r2; httpswww.kazo.com!r4; httpsitsybitsy.in!r5; httpswww.joypersonalcare.com!r6; zodiaconline.com!r3; Borosil!r11; Borosil!r30]_
- **Beauty-category sources:** Sugar Lash Pro; Joy Personal Care
- **Purpose / user problem:** Raise basket value.
- **Our reasoning:** Twelve entries. Keep it compact so it does not block checkout.
- **Suggested implementation:** One compact recommendations row in the cart drawer (complete-the-routine); adds in place and updates totals; source from Shopify recommendations or manual list.
- **Desktop:** Under items, above footer. | **Mobile:** One-row carousel above the sticky footer.
- **Unresolved questions:** Recommendation source (native, metafield or app).

### CRT-09 - Discount code and available offers display

**Recommendation:** MODIFY | **Priority:** P1 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (6 companies):** Icon opens the coupon box without a clear label; users do not know which coupons exist; coupon validity is only visible after applying; coupon dialog does not close after applying; cart says no coupons while a 10% payment discount shows.
- **Original description (first source, Ambrane (httpswww.ambraneindia.com!r2)):** The icon should have a clear message saying "Click here to avail discounts". Coupon code which can be applied to the users shoudl be shown adjacent to the coupon code addition filed. This helps the users know what discount they can get by adding the coupon then and there anc checing how much discount they will get
- **Sources:** Ambrane; Itsy Bitsy; Joy Personal Care; XYXX; Melorra; Eureka Forbes _[httpswww.ambraneindia.com!r2; httpsitsybitsy.in!r2; httpswww.joypersonalcare.com!r2; XYXX!r4; Melorra!r5; httpeurekaforbes.com!r6]_
- **Beauty-category sources:** Joy Personal Care
- **Purpose / user problem:** Help users find and use a valid offer.
- **Our reasoning:** Shopify cannot list valid codes natively. The theme can show a merchant-curated offers list.
- **Suggested implementation:** Labelled code field; offers list from theme settings; the dialog closes and the summary updates after apply.
- **Desktop:** Collapsible field in the summary. | **Mobile:** Bottom sheet.
- **Unresolved questions:** Are payment-gateway offers shown (consistency with checkout)?

### CRT-10 - Quantity selector rules and stock messages

**Recommendation:** MODIFY | **Priority:** P1 | **Primary page:** Cart | **Secondary:** PDP

- **Source says (5 companies):** Clear 'Only X left' messages and set quantity to the maximum available; Lifelong: field editable with no validation; Myborosil: users want custom quantity entry.
- **Original description (first source, Borosil (Borosil!r9)):** When 10 product qty is in cart adding another qty shows a message that "Only 4 items were added to your cart due to availability."
- **Sources:** Borosil; Navneet; Joy Personal Care; Life Long India; Myborosil _[Borosil!r9; Navneet!r3; httpswww.joypersonalcare.com!r3; LifelongIndia!r6; httpsmyborosil.com!r4]_
- **Beauty-category sources:** Joy Personal Care
- **Purpose / user problem:** Prevent invalid quantities and confusion.
- **Our reasoning:** Sources conflict (non-editable vs custom entry). Plus/minus with a validated numeric input satisfies both.
- **Suggested implementation:** Stepper with a validated input; inline message with the maximum available.
- **Desktop:** n/a | **Mobile:** Large +/- targets.
- **Unresolved questions:** None.

### CRT-11 - Cart layout efficiency

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (3 companies):** Cart needs horizontal scroll on mobile; scrolling enabled even when there is room; wasted space.
- **Original description (first source, GoDPS Music (15 Companies!r11)):** The pages should not break on mobile screens so that users can easily navigate the website
- **Sources:** GoDPS Music; Svibe; Life Long India _[15 Companies!r11; 15 Companies!r59; LifelongIndia!r5]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Everything fits in view.
- **Our reasoning:** Basic layout quality.
- **Suggested implementation:** Responsive cart without horizontal overflow; scroll only when needed.
- **Desktop:** Two-column. | **Mobile:** Single column.
- **Unresolved questions:** None.

### CRT-12 - Estimated delivery date in cart

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** Cart | **Secondary:** PDP

- **Source says (2 companies):** Cart does not show the expected delivery day.
- **Original description (first source, Mivi (httpswww.mivi.in!r9)):** The cart does not show the day of expected delivery
- **Sources:** Mivi; Flo Mattress _[httpswww.mivi.in!r9; Flomattress!r12]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Remove delivery uncertainty.
- **Our reasoning:** Shares logic with PDP-10.
- **Suggested implementation:** Estimated delivery line in cart summary from the same component as PDP.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Integration needed.

### CRT-13 - Continue shopping secondary CTA

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (1 company):** Mivi: no continue shopping button on the cart page.
- **Original description (first source, Mivi (httpswww.mivi.in!r11)):** A secondary CTA "Continue shopping" button is not available on the cart page
- **Sources:** Mivi _[httpswww.mivi.in!r11]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Easy return to browsing.
- **Our reasoning:** Single source; trivial.
- **Suggested implementation:** Text link in cart page and empty-cart state.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### CRT-14 - Terms checkbox before checkout

**Recommendation:** MODIFY | **Priority:** P1 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (3 companies):** Users must tick a terms box or read a disclaimer before checkout; expected pre-ticked or removed.
- **Original description (first source, Apo Shop (15 Companies!r48)):** Users should not have to click on accepting T&C before checkout, instead the checkbox should be auto checked and if users wish to explicitly not accept it they should be allowed to uncheck the box. This will reduce a click for users in the purchase journey
- **Sources:** Apo Shop; Wdrobe Apparel; GoDPS Music _[15 Companies!r48; 15 Companies!r69; 15 Companies!r12]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Remove a click.
- **Our reasoning:** Legal requirements vary by market. Default off, merchant can enable.
- **Suggested implementation:** Optional checkbox, with link-only agreement text as the default.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Legal review per market.

### CRT-16 - Benefit messages beside cart items (free shipping and similar)

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (1 company):** Eureka Forbes: free shipping and installation message is only visible after scrolling.
- **Original description (first source, Eureka Forbes (httpeurekaforbes.com!r2)):** When mobile users adds product to the cart, messages related to products Free installation should be displayed with the product so that users can relate to the benefit of checking out with the product.  Such information should be readily visible to the users, without the user having to scrol down the page and view this information
- **Sources:** Eureka Forbes _[httpeurekaforbes.com!r2]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Remind users of benefits before checkout.
- **Our reasoning:** The installation benefit is product-specific; free shipping is a common pattern.
- **Suggested implementation:** Message block near the items or a threshold bar from settings.
- **Desktop:** n/a | **Mobile:** Above sticky footer.
- **Unresolved questions:** Free-shipping threshold bar included? (source only supports the message)

## P2 - optional / later

### CRT-07 - Remove-from-cart confirmation

**Recommendation:** MODIFY | **Priority:** P2 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (15 companies):** 15 entries ask for a confirm or decline prompt before removal.
- **Original description (first source, Lotus Botanicals (httpswww.lotusbotanicals.com!r2)):** When user clicks on the remove from cart button, user should be shown a message with CTA to confirm or decline his request
- **Sources:** Lotus Botanicals; Aroma Magic; Vicco Labs; Khadi Natural; Fablestreet; Ambrane; Kazo; Itsy Bitsy; Joy Personal Care; Myborosil; Meolaa; Safari Bags; Eureka Forbes; Biotique; Happilo _[httpswww.lotusbotanicals.com!r2; httpswww.aromamagic.com!r3; httpswww.viccolabs.com!r2; httpswww.khadinatural.com!r2; httpswww.fablestreet.com!r2; httpswww.ambraneindia.com!r3; httpswww.kazo.com!r2; httpsitsybitsy.in!r3; httpswww.joypersonalcare.com!r4; httpsmyborosil.com!r3; httpsmeolaa.com!r5; safaribags.com!r3; httpeurekaforbes.com!r7; httpswww.biotique.com!r5; httpshappilo.com!r4]_
- **Beauty-category sources:** Lotus Botanicals; Aroma Magic; Vicco Labs; Khadi Natural; Joy Personal Care; Biotique
- **Purpose / user problem:** Prevent accidental removal.
- **Our reasoning:** The goal is valid; a blocking confirmation dialog adds a click in the purchase path. An undo message achieves the same protection without friction (our recommendation, to be tested).
- **Suggested implementation:** Remove shows an Undo toast for a few seconds, with optional move to wishlist. Dialog available as a setting.
- **Desktop:** Toast inside drawer. | **Mobile:** Toast above sticky footer.
- **Unresolved questions:** Dialog or undo? Test.

### CRT-08 - Save for later / move to wishlist

**Recommendation:** MODIFY | **Priority:** P2 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (12 companies):** 12 entries: no way to save an item instead of removing it; Borosil: guest can add to wishlist but cannot view it.
- **Original description (first source, Lotus Botanicals (httpswww.lotusbotanicals.com!r3)):** When user clicks on the remove from cart button, user should be provided with an option to move the product from cart to a wishlisht, which can be accessed later to easily find the product
- **Sources:** Lotus Botanicals; Aroma Magic; Vicco Labs; Khadi Natural; Fablestreet; Ambrane; Kazo; Itsy Bitsy; Joy Personal Care; Myborosil; Happilo; Borosil _[httpswww.lotusbotanicals.com!r3; httpswww.aromamagic.com!r5; httpswww.viccolabs.com!r3; httpswww.khadinatural.com!r3; httpswww.fablestreet.com!r3; httpswww.ambraneindia.com!r4; httpswww.kazo.com!r3; httpsitsybitsy.in!r4; httpswww.joypersonalcare.com!r5; httpsmyborosil.com!r2; httpshappilo.com!r7; Borosil!r21]_
- **Beauty-category sources:** Lotus Botanicals; Aroma Magic; Vicco Labs; Khadi Natural; Joy Personal Care
- **Purpose / user problem:** Return visits and fewer lost items.
- **Our reasoning:** A wishlist needs an app or customer accounts. The theme should provide UI hooks only.
- **Suggested implementation:** Heart icon on cards and PDP and a Save for later action in the cart that call a wishlist app or local storage with a visible Wishlist page link.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** App vs custom local storage; guest behaviour.

### CRT-15 - One checkout button per customer region

**Recommendation:** MODIFY | **Priority:** P2 | **Primary page:** Cart | **Secondary:** Other / Global

- **Source says (2 companies):** Two checkout buttons (India and rest of world) look discriminatory; detect location instead.
- **Original description (first source, Khadi Natural (httpswww.khadinatural.com!r5)):** Instead, the website should identify the user's location and show the respective checkout button. This will help control users from opeing the incorrect checkout option and also esnure users appear to be treated equally on the website
- **Sources:** Khadi Natural; Fablestreet _[httpswww.khadinatural.com!r5; httpswww.fablestreet.com!r7]_
- **Beauty-category sources:** Khadi Natural
- **Purpose / user problem:** Avoid trust issues.
- **Our reasoning:** Only relevant to multi-market stores; use Shopify Markets.
- **Suggested implementation:** Single checkout button; market logic handled by Shopify Markets, not the theme.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Multi-market scope.

## P3 - later phase or low value

### CRT-17 - Later-phase cart ideas: edit variant in cart and post-purchase upsell

**Recommendation:** NEEDS RESEARCH | **Priority:** P3 | **Primary page:** Cart | **Secondary:** PDP

- **Source says (3 companies):** Change size/portion in the cart without going to the PDP; add an upsell step between checkout and thank-you.
- **Original description (first source, Biotique (httpswww.biotique.com!r7)):** If the portion size of the product is availble then user should be able to select without doing on PDP Page
- **Sources:** Biotique; Happilo; Mivi _[httpswww.biotique.com!r7; httpshappilo.com!r3; httpswww.mivi.in!r12]_
- **Beauty-category sources:** Biotique
- **Purpose / user problem:** Fewer steps and higher AOV.
- **Our reasoning:** Variant editing is custom work; post-purchase upsell needs Shopify Plus or an app.
- **Suggested implementation:** None in MVP.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Priority vs MVP.

