# Interaction testing report

Generated 2026-11-18 19:18 by tools/build-report.ps1 from documentation/data/test-results.json. Tests run in headless Chrome against the real wireframe files with interactive mode on (tools/journeys.js). A check passes only when the browser really did the thing.

## Totals

| Measure | Count |
|---------|-------|
| Total interactions tested | 128 |
| Passed | 127 |
| Failed | 0 |
| Pending | 0 |
| Blocked | 1 |

## By group

| Group | Tested | Passed | Failed | Pending | Blocked |
|-------|--------|--------|--------|---------|---------|
| J0 link coverage | 16 | 16 | 0 | 0 | 0 |
| J1 Home to Checkout | 12 | 12 | 0 | 0 | 0 |
| J2 Category to PDP | 6 | 6 | 0 | 0 | 0 |
| J3 Search | 10 | 10 | 0 | 0 | 0 |
| J4 Blog | 7 | 6 | 0 | 0 | 1 |
| J5 PDP related | 4 | 4 | 0 | 0 | 0 |
| J6 Cart | 13 | 13 | 0 | 0 | 0 |
| J7 Drawer page | 4 | 4 | 0 | 0 | 0 |
| J8 History | 6 | 6 | 0 | 0 | 0 |
| J9 Footer | 17 | 17 | 0 | 0 | 0 |
| J10 Responsive | 33 | 33 | 0 | 0 | 0 |

## Every check

| Result | Group | Check | Evidence |
|--------|-------|-------|----------|
| PASS | J0 link coverage | All links resolve on home (128 links: 9 file, 6 in-page, 97 routed, 8 action, 8 inert) |  |
| PASS | J0 link coverage | All links resolve on collection (114 links: 9 file, 9 in-page, 88 routed, 8 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on product (95 links: 9 file, 5 in-page, 72 routed, 9 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on cart (95 links: 9 file, 4 in-page, 75 routed, 7 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on drawer (90 links: 9 file, 3 in-page, 71 routed, 7 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on contact (95 links: 9 file, 3 in-page, 73 routed, 10 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on faq (94 links: 9 file, 8 in-page, 69 routed, 8 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on about (91 links: 9 file, 3 in-page, 71 routed, 8 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on story (90 links: 9 file, 3 in-page, 70 routed, 8 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on shipping (106 links: 9 file, 19 in-page, 70 routed, 8 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on returns (108 links: 9 file, 21 in-page, 70 routed, 8 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on privacy (108 links: 9 file, 21 in-page, 70 routed, 8 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on terms (113 links: 9 file, 23 in-page, 73 routed, 8 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on blog (120 links: 9 file, 3 in-page, 95 routed, 13 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on article (94 links: 9 file, 4 in-page, 73 routed, 8 action, 0 inert) |  |
| PASS | J0 link coverage | All links resolve on notfound (92 links: 9 file, 3 in-page, 72 routed, 8 action, 0 inert) |  |
| PASS | J1 Home to Checkout | Header "Skin" opens the Skin care collection | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin |
| PASS | J1 Home to Checkout | Collection title and products render | 10 cards |
| PASS | J1 Home to Checkout | Product card opens that product page (Face Cleanser) | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?ix=1&p=face-cleanser h1=Face Cleanser |
| PASS | J1 Home to Checkout | PDP breadcrumb follows the product | Home>Skin care>Face Cleanser |
| PASS | J1 Home to Checkout | Add to bag writes the line to the shared cart | [{"h":"face-cleanser","qty":1}] |
| PASS | J1 Home to Checkout | Header bag count shows 1 after Add to bag | 1 |
| PASS | J1 Home to Checkout | Header bag opens the cart drawer | true |
| PASS | J1 Home to Checkout | Drawer lists the added product | 1 |
| PASS | J1 Home to Checkout | Drawer subtotal matches | ₹1,494 |
| PASS | J1 Home to Checkout | Drawer "View cart" opens the Cart page | 04-NUDGE-Beauty-Cart-Wireframe/Cart_Page.html?ix=1 |
| PASS | J1 Home to Checkout | Cart page shows the shared line | 1 / 1 item |
| PASS | J1 Home to Checkout | Checkout shows the "not simulated" notice and stays on the page | Checkout is not simulated. In Shopify, Checkout goes to the Shopify-hosted /checkout with real payment.× |
| PASS | J2 Category to PDP | Homepage category tile "Skin care" opens its collection | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin |
| PASS | J2 Category to PDP | Mega menu "Hydration" applies the Dryness filter on the PLP | ["Dryness"] |
| PASS | J2 Category to PDP | Filtered collection shows fewer products than all | 9 of 24 |
| PASS | J2 Category to PDP | Filtered product opens its PDP | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?ix=1&p=cream-cleanser |
| PASS | J2 Category to PDP | Makeup collection shows the PLP empty state (no makeup products in sample data) | count 0 |
| PASS | J2 Category to PDP | Homepage concern tile Dryness opens a Dryness-filtered PLP | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin&f=concern%3ADryness |
| PASS | J3 Search | Header search opens the overlay |  |
| PASS | J3 Search | Empty state shows popular searches |  |
| PASS | J3 Search | Loading state appears while searching |  |
| PASS | J3 Search | Search "serum" returns serum products | 7 rows |
| PASS | J3 Search | No-results state for "zzzz" with a way out |  |
| PASS | J3 Search | Result "Add" puts the product in the shared cart | [{"h":"gel-cleanser","qty":1}] |
| PASS | J3 Search | Result link opens the product page | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?ix=1&p=gel-cleanser |
| PASS | J3 Search | Recent search is remembered | ["niacinamide"] |
| PASS | J3 Search | Escape closes the overlay |  |
| PASS | J3 Search | Submitting a query that matches one product opens it | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?ix=1&p=gel-cleanser |
| PASS | J4 Blog | Article title opens the article page | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?ix=1&a=how-to-layer-your-skincare |
| PASS | J4 Blog | Article heading matches the clicked title | How to layer your skincare |
| PASS | J4 Blog | Next article opens the following article | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?ix=1&a=a-simple-evening-routine |
| PASS | J4 Blog | Article tag opens the tagged journal list | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html?ix=1&t=routines |
| PASS | J4 Blog | Tag filter shows only matching articles | 5 of 10 for Routines |
| PASS | J4 Blog | Pagination explains the single sample page instead of dead-ending | The wireframe shows one page of sample articles, so there is no next page to open.× |
| BLOCKED | J4 Blog | Article to Related products to PDP | The Article wireframe has no related-products section; adding one is a new design decision (reported, not invented) |
| PASS | J5 PDP related | Related product card opens that product | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?ix=1&p=barrier-cream |
| PASS | J5 PDP related | Price follows the product ($30) | ₹2,490 |
| PASS | J5 PDP related | Complete your routine "Add selected" adds the checked products | [{"h":"face-cleanser","qty":1},{"h":"face-serum","qty":1},{"h":"daily-sunscreen","qty":1}] |
| PASS | J5 PDP related | Add to bag without a shade shows the shade error (variant validation intact for shaded products) | [] |
| PASS | J6 Cart | Cart page renders the three shared lines | 3 |
| PASS | J6 Cart | Quantity + updates the line and the shared cart | [{"h":"face-serum","qty":2},{"h":"face-cleanser","qty":1},{"h":"eye-cream","qty":1}] cnt 4 |
| PASS | J6 Cart | Subtotal reflects the new quantity | ₹9,296 |
| PASS | J6 Cart | Quantity - returns to 1 | [{"h":"face-serum","qty":1},{"h":"face-cleanser","qty":1},{"h":"eye-cream","qty":1}] |
| PASS | J6 Cart | Remove deletes the line and offers Undo | 2 lines |
| PASS | J6 Cart | Undo restores the line | 3 lines |
| PASS | J6 Cart | Refresh keeps the cart | 3 |
| PASS | J6 Cart | Continue shopping returns to the last collection | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin |
| PASS | J6 Cart | Order note persists across refresh | Gift wrap please |
| PASS | J6 Cart | Empty cart shows the empty state |  |
| PASS | J6 Cart | Empty-state link opens a collection | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin |
| PASS | J6 Cart | Quantity is capped at stock or 10 (error path) | [{"h":"face-serum","qty":3}] |
| PASS | J6 Cart | Sold-out product is refused | {"ok":false,"reason":"soldout"} |
| PASS | J7 Drawer page | Cart Drawer wireframe shows the shared cart in its own drawer | 1 |
| PASS | J7 Drawer page | Drawer quantity change writes back to shared state | [{"h":"face-serum","qty":2}] |
| PASS | J7 Drawer page | Drawer Checkout shows the notice |  |
| PASS | J7 Drawer page | Drawer "View cart" goes to the Cart page | 04-NUDGE-Beauty-Cart-Wireframe/Cart_Page.html?ix=1 |
| PASS | J8 History | Back from PDP returns to the Serums collection with its filter | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin-serums |
| PASS | J8 History | Back again returns to Skin care | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin |
| PASS | J8 History | Forward returns to Serums | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin-serums |
| PASS | J8 History | Refresh keeps the collection and its filter | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin-serums |
| PASS | J8 History | Refresh keeps the shared cart count on the PDP | 1 -> 1 |
| PASS | J8 History | Cart count follows to a different page type (Journal) | 1 |
| PASS | J9 Footer | Footer "Contact us" opens contact | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | J9 Footer | Footer "FAQ" opens faq | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | J9 Footer | Footer "About us" opens about | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | J9 Footer | Footer "Our story" opens story | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | J9 Footer | Footer "Shipping & Delivery" opens shipping | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | J9 Footer | Footer "Returns & Refunds" opens returns | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | J9 Footer | Footer "Privacy policy" opens privacy | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | J9 Footer | Footer "Terms of service" opens terms | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | J9 Footer | Footer "Journal" opens blog | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | J9 Footer | Logo returns to the Homepage | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html?ix=1 |
| PASS | J9 Footer | Footer "Support" (#help) opens Contact | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html?ix=1 |
| PASS | J9 Footer | Account icon explains accounts are not simulated | Accounts and sign-in are not part of the wireframes. In Shopify this is the customer account (/account), a Shopify-hosted feature.× |
| PASS | J9 Footer | 404 page link leaves the 404 | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin-serums |
| PASS | J9 Footer | Unknown collection handle shows the 404 page | 16-NUDGE-Beauty-404-Wireframe/404_Page_Wireframe_v1.html?ix=1 |
| PASS | J9 Footer | Unknown product handle shows the 404 page | 16-NUDGE-Beauty-404-Wireframe/404_Page_Wireframe_v1.html?ix=1 |
| PASS | J9 Footer | Newsletter rejects an invalid email |  |
| PASS | J9 Footer | Newsletter shows a success notice for a valid email |  |
| PASS | J10 Responsive 1920 | home has no horizontal overflow at 1920 | scrollWidth 1905 |
| PASS | J10 Responsive 1920 | collection has no horizontal overflow at 1920 | scrollWidth 1905 |
| PASS | J10 Responsive 1920 | product has no horizontal overflow at 1920 | scrollWidth 1905 |
| PASS | J10 Responsive 1920 | cart has no horizontal overflow at 1920 | scrollWidth 1905 |
| PASS | J10 Responsive 1920 | article has no horizontal overflow at 1920 | scrollWidth 1905 |
| PASS | J10 Responsive 1920 | Search overlay fits the viewport at 1920 | 608..1312 |
| PASS | J10 Responsive 1920 | Cart drawer opens and fits at 1920 | 416 px wide |
| PASS | J10 Responsive 1440 | home has no horizontal overflow at 1440 | scrollWidth 1425 |
| PASS | J10 Responsive 1440 | collection has no horizontal overflow at 1440 | scrollWidth 1425 |
| PASS | J10 Responsive 1440 | product has no horizontal overflow at 1440 | scrollWidth 1425 |
| PASS | J10 Responsive 1440 | cart has no horizontal overflow at 1440 | scrollWidth 1425 |
| PASS | J10 Responsive 1440 | article has no horizontal overflow at 1440 | scrollWidth 1425 |
| PASS | J10 Responsive 1440 | Search overlay fits the viewport at 1440 | 368..1072 |
| PASS | J10 Responsive 1440 | Cart drawer opens and fits at 1440 | 416 px wide |
| PASS | J10 Responsive 768 | home has no horizontal overflow at 768 | scrollWidth 753 |
| PASS | J10 Responsive 768 | collection has no horizontal overflow at 768 | scrollWidth 753 |
| PASS | J10 Responsive 768 | product has no horizontal overflow at 768 | scrollWidth 753 |
| PASS | J10 Responsive 768 | cart has no horizontal overflow at 768 | scrollWidth 753 |
| PASS | J10 Responsive 768 | article has no horizontal overflow at 768 | scrollWidth 753 |
| PASS | J10 Responsive 768 | Search overlay fits the viewport at 768 | 32..736 |
| PASS | J10 Responsive 768 | Cart drawer opens and fits at 768 | 416 px wide |
| PASS | J10 Responsive 768 | Mobile menu opens |  |
| PASS | J10 Responsive 768 | Mobile menu: accordion then sub-collection link navigates | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin-hydration |
| PASS | J10 Responsive 390 | home has no horizontal overflow at 390 | scrollWidth 375 |
| PASS | J10 Responsive 390 | collection has no horizontal overflow at 390 | scrollWidth 375 |
| PASS | J10 Responsive 390 | product has no horizontal overflow at 390 | scrollWidth 375 |
| PASS | J10 Responsive 390 | cart has no horizontal overflow at 390 | scrollWidth 375 |
| PASS | J10 Responsive 390 | article has no horizontal overflow at 390 | scrollWidth 375 |
| PASS | J10 Responsive 390 | Search overlay fits the viewport at 390 | 0..390 |
| PASS | J10 Responsive 390 | Cart drawer opens and fits at 390 | 390 px wide |
| PASS | J10 Responsive 390 | Mobile menu opens |  |
| PASS | J10 Responsive 390 | Mobile menu: accordion then sub-collection link navigates | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?ix=1&c=skin-hydration |
| PASS | J10 Responsive 1440 | Prototype pill sits in the corner and is small | 177x38 |

## Failed

None in this run.

## Pending, blocked and unsupported

* **BLOCKED** Article to Related products to PDP: The Article wireframe has no related-products section; adding one is a new design decision (reported, not invented)
* **UNSUPPORTED (by design, needs Shopify)** checkout and payment, accounts and orders, discount codes, real inventory, newsletter delivery, contact form delivery, wishlist, reviews. See shopify-integration.md.
* **MISSING in the wireframes** search results page, wishlist control, article related products, makeup, hair and body product data. See missing-pages-and-interactions.md.

## Safety checks

* 06-Shopify-Theme fingerprint: 0 of 103 files differ from 07-Component-Library/shopify/06-baseline.json.
* The wireframes were opened, not edited. The one change is the dormant hook appended to 03-Wireframes/00-Shared-Tailwind-Foundation/nav.js (original saved at tools/nav.js.original).
* No Shopify store tool was called; nothing was pushed or published.