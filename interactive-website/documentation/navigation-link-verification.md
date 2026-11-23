# Navigation and link verification

Generated 2026-11-18 19:23 from documentation/data/links-*.json (tools/suite-links.js).

Method: on each of the 16 pages at 1440 px (interactive mode ON) every visible link, including links inside the mega menu panels (opened first), was collected. Each link was resolved with the same resolver a click uses and the links were grouped by destination; the first link of every group was then **clicked for real** in headless Chrome and the result checked: a route must land on the right wireframe with the right query, a search link must open the overlay, a cart link must open the drawer, an unsupported link must show its notice and stay, an in-page anchor must reach its target without leaving. A link that resolves to nothing is a failure.

## Totals

| Measure | Count |
|---|---|
| Pages tested | 16 of 16 |
| Visible links found (all pages) | 1550 |
| Distinct (page, destination) groups | 1269 |
| Real clicks performed | 1269 |
| Working (PASS) | 1269 |
| Broken (FAIL) | 0 |
| Links with no destination left (placeholder, empty or dead) | 0 |

Every link in a group shares the same resolution, so one real click verifies the group; links covered by that group are counted in the totals above. The earlier dry-run (journeys group J0) also resolved all links on all 16 pages with 0 unresolved.

## By page

| Page | Visible links | Destination groups | Real clicks | PASS | FAIL |
|---|---|---|---|---|---|
| Homepage | 125 | 92 | 92 | 92 | 0 |
| PLP (collection) | 108 | 83 | 83 | 83 | 0 |
| PDP (product) | 92 | 78 | 78 | 78 | 0 |
| Cart page | 89 | 72 | 72 | 72 | 0 |
| Cart drawer wireframe | 87 | 71 | 71 | 71 | 0 |
| Contact | 91 | 76 | 76 | 76 | 0 |
| FAQ | 92 | 78 | 78 | 78 | 0 |
| About | 89 | 75 | 75 | 75 | 0 |
| Our story | 88 | 74 | 74 | 74 | 0 |
| Shipping policy | 96 | 81 | 81 | 81 | 0 |
| Returns policy | 97 | 83 | 83 | 83 | 0 |
| Privacy policy | 97 | 83 | 83 | 83 | 0 |
| Terms | 101 | 86 | 86 | 86 | 0 |
| Blog listing | 116 | 88 | 88 | 88 | 0 |
| Blog article | 92 | 77 | 77 | 77 | 0 |
| 404 | 90 | 72 | 72 | 72 | 0 |

## Required elements (from the request) and their status

| Element | Status | Evidence |
|---|---|---|
| Logo returns to the Homepage | PASS | journey J9 and the per-page clicks of the "Store home" link |
| Header search opens a search interface | PARTIALLY PASSED | opens the stand-in overlay; there is no search RESULTS page in the wireframes |
| Header cart opens the cart drawer (cart page: stays) | PASS | per-page clicks, journeys J1, J7 |
| Header account opens the account page | FAIL (page does not exist) | no account page in the wireframes; a notice explains it. Listed in missing-features-and-dependencies.md |
| Header wishlist opens the wishlist | FAIL (control does not exist) | no wishlist control or page in the wireframes |
| Main navigation and mega menu links open the right collections | PASS | all 54 collection links are clicked (skin collections show their products; makeup, hair, body show the PLP empty state because no products exist for them) |
| Mobile menu opens and closes | PASS | journey J10 at 320 to 844 px; keyboard and Escape closing is in interaction-qa-report.md |
| Announcement bar links | NOT APPLICABLE | the announcement bar has messages and arrows only, no links |
| Homepage hero CTAs, category cards, product cards, concerns, blog cards, footer | PASS | per-page clicks on the Homepage (hero "Shop the edit" and "Find your routine" keep scrolling to their section, as designed) |
| PLP product cards, filters, sort, pagination, quick add, breadcrumbs | PASS | journeys J1, J2, J8; PLP wishlist does not exist |
| PDP gallery, zoom, variants, Add to bag, quantity, accordions, related products, breadcrumbs | PASS | journeys J1, J5 and the page's own self-test; Buy Now does not exist (the wireframe uses express checkout) |
| Cart quantity, remove, subtotal, drawer and page in sync, continue shopping, empty state | PASS | journeys J6, J7 |
| Checkout destination | NOT SIMULATED | shows a notice; Shopify-native checkout is the real destination |
| Blog cards, article tags, back to blog, previous and next article | PASS | journey J4 |
| Article related articles and related product links | BLOCKED | the Article wireframe has neither section |

## Every real click

| Result | Page | Link [href -> destination] | Evidence |
|---|---|---|---|
| PASS | home | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | home | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | home | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | home | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | home | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | home | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | home | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | home | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | home | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | home | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | home | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | home | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | home | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | home | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | home | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | home | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | home | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | home | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | home | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | home | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | home | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | home | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | home | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | home | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | home | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | home | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | home | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | home | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | home | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | home | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | home | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | home | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | home | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | home | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | home | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | home | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | home | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | home | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | home | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | home | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | home | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | home | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | home | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | home | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | home | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | home | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | home | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | home | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | home | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | home | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | home | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | home | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | home | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | home | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | home | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | home | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | home | Search products  [#search -> action:search] | overlay open=true |
| PASS | home | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | home | Cart, 0 items  [#cart -> action:cart] | home drawer open=true |
| PASS | home | Shop the edit  [#s06 -> inpage:#s06] | target s06 exists, no navigation |
| PASS | home | Find your routine  [#s07 -> inpage:#s07] | target s07 exists, no navigation |
| PASS | home | Face Cleanser  [# -> route:/products/face-cleanser] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=face-cleanser |
| PASS | home | Face Serum  [# -> route:/products/face-serum] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=face-serum |
| PASS | home | Moisturiser  [# -> route:/products/moisturiser] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=moisturiser |
| PASS | home | Lip Colour  [# -> route:/products/lip-colour] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=lip-colour |
| PASS | home | View all best sellers  [# -> route:/collections/all] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=all |
| PASS | home | Concern: Dryness1:1, 400 x 400Dryness  [# -> route:/collections/skin?f=concern%3ADryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin&f=concern%3ADryness |
| PASS | home | Concern: Dullness1:1, 400 x 400Dullness  [# -> route:/collections/skin?f=concern%3ADullness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin&f=concern%3ADullness |
| PASS | home | Concern: Breakouts1:1, 400 x 400Breakout  [# -> route:/collections/skin?f=concern%3ABreakouts] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin&f=concern%3ABreakouts |
| PASS | home | Concern: Sensitivity1:1, 400 x 400Sensit  [# -> route:/collections/skin?f=concern%3ASensitivity] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin&f=concern%3ASensitivity |
| PASS | home | Concern: Uneven tone1:1, 400 x 400Uneven  [# -> route:/collections/skin?f=concern%3AUneven%20tone] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin&f=concern%3AUneven%20tone |
| PASS | home | Concern: Texture1:1, 400 x 400Texture  [# -> route:/collections/skin?f=concern%3ATexture] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin&f=concern%3ATexture |
| PASS | home | 1Cleanse  [# -> route:/collections/skin?f=type%3ACleanser] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin&f=type%3ACleanser |
| PASS | home | 2Treat  [# -> route:/collections/skin?f=type%3ASerum] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin&f=type%3ASerum |
| PASS | home | 3Moisturise  [# -> route:/collections/skin?f=type%3AMoisturiser] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin&f=type%3AMoisturiser |
| PASS | home | 4Protect  [# -> route:/collections/skin?f=type%3ASun%20care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin&f=type%3ASun%20care |
| PASS | home | Sunscreen  [#s06 -> route:/products/daily-sunscreen] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=daily-sunscreen |
| PASS | home | Eye Cream  [# -> route:/products/eye-cream] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=eye-cream |
| PASS | home | Lip Balm  [# -> route:/products/lip-balm] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=lip-balm |
| PASS | home | Certification 1 (placeholder): verify th  [#s16 -> action:inert] | stays on the page (placeholder logo, no destination) |
| PASS | home |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | home | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | home | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | home | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | home | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | home | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | home | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | home | Support  [#help -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | home | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | home | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | home | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | home | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | collection | Previous  [#results -> inpage:#results] | target results exists, no navigation |
| PASS | collection | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | collection | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | collection | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | collection | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | collection | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | collection | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | collection | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | collection | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | collection | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | collection | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | collection | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | collection | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | collection | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | collection | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | collection | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | collection | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | collection | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | collection | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | collection | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | collection | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | collection | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | collection | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | collection | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | collection | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | collection | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | collection | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | collection | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | collection | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | collection | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | collection | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | collection | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | collection | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | collection | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | collection | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | collection | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | collection | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | collection | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | collection | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | collection | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | collection | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | collection | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | collection | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | collection | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | collection | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | collection | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | collection | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | collection | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | collection | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | collection | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | collection | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | collection | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | collection | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | collection | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | collection | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | collection | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | collection | Search products  [#search -> action:search] | overlay open=true |
| PASS | collection | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | collection | Cart, 0 items  [#cart -> action:cart] | collection drawer open=true |
| PASS | collection | Skin care  [#banner -> inpage:#banner] | target banner exists, no navigation |
| PASS | collection | Face Cleanser  [#pdp -> route:/products/face-cleanser] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=face-cleanser |
| PASS | collection | Gel Cleanser  [#pdp -> route:/products/gel-cleanser] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=gel-cleanser |
| PASS | collection | Cream Cleanser  [#pdp -> route:/products/cream-cleanser] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=cream-cleanser |
| PASS | collection | Balm Cleanser  [#pdp -> route:/products/balm-cleanser] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=balm-cleanser |
| PASS | collection | Face Serum  [#pdp -> route:/products/face-serum] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=face-serum |
| PASS | collection | Hydrating Serum  [#pdp -> route:/products/hydrating-serum] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=hydrating-serum |
| PASS | collection | Brightening Serum  [#pdp -> route:/products/brightening-serum] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=brightening-serum |
| PASS | collection | Calming Serum  [#pdp -> route:/products/calming-serum] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=calming-serum |
| PASS | collection | Smoothing Serum  [#pdp -> route:/products/smoothing-serum] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=smoothing-serum |
| PASS | collection | Moisturiser  [#pdp -> route:/products/moisturiser] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=moisturiser |
| PASS | collection | Previous  [#results -> inpage:#results] | target results exists, no navigation |
| PASS | collection |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | collection | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | collection | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | collection | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | collection | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | collection | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | collection | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | collection | Support  [#help -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | collection | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | collection | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | collection | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | collection | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | product | Face Serum  [#product -> inpage:#product] | target product exists, no navigation |
| PASS | product | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | product | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | product | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | product | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | product | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | product | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | product | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | product | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | product | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | product | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | product | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | product | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | product | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | product | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | product | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | product | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | product | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | product | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | product | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | product | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | product | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | product | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | product | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | product | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | product | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | product | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | product | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | product | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | product | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | product | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | product | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | product | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | product | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | product | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | product | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | product | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | product | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | product | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | product | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | product | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | product | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | product | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | product | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | product | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | product | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | product | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | product | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | product | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | product | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | product | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | product | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | product | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | product | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | product | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | product | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | product | Search products  [#search -> action:search] | overlay open=true |
| PASS | product | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | product | Cart, 0 items  [#cart -> action:cart] | product drawer open=true |
| PASS | product | Face Serum  [#product -> inpage:#product] | target product exists, no navigation |
| PASS | product | 31 reviews  [#reviews -> inpage:#reviews] | target reviews exists, no navigation |
| PASS | product | Returns policy  [#policy -> route:/policies/refund-policy] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html? |
| PASS | product | Hydrating Serum  [#cat -> route:/products/hydrating-serum] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=hydrating-serum |
| PASS | product | Gel Moisturiser  [#cat -> route:/products/gel-moisturiser] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=gel-moisturiser |
| PASS | product | Barrier Cream  [#cat -> route:/products/barrier-cream] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=barrier-cream |
| PASS | product | Eye Cream  [#cat -> route:/products/eye-cream] | 03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=eye-cream |
| PASS | product |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | product | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | product | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | product | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | product | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | product | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | product | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | product | Support  [#help -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | product | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | product | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | product | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | product | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | cart | Cart, 0 items  [#cart -> inpage:#cart] | target cart exists, no navigation |
| PASS | cart | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | cart | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | cart | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | cart | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | cart | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | cart | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | cart | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | cart | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | cart | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | cart | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | cart | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | cart | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | cart | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | cart | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | cart | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | cart | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | cart | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | cart | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | cart | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | cart | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | cart | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | cart | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | cart | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | cart | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | cart | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | cart | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | cart | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | cart | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | cart | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | cart | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | cart | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | cart | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | cart | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | cart | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | cart | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | cart | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | cart | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | cart | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | cart | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | cart | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | cart | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | cart | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | cart | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | cart | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | cart | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | cart | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | cart | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | cart | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | cart | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | cart | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | cart | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | cart | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | cart | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | cart | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | cart | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | cart | Search products  [#search -> action:search] | overlay open=true |
| PASS | cart | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | cart | Cart, 0 items  [#cart -> inpage:#cart] | target cart exists, no navigation |
| PASS | cart | Best sellers  [#shop -> route:/collections/all] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=all |
| PASS | cart |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | cart | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | cart | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | cart | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | cart | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | cart | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | cart | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | cart | Support  [#help -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | cart | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | cart | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | cart | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | cart | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | drawer | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | drawer | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | drawer | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | drawer | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | drawer | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | drawer | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | drawer | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | drawer | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | drawer | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | drawer | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | drawer | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | drawer | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | drawer | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | drawer | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | drawer | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | drawer | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | drawer | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | drawer | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | drawer | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | drawer | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | drawer | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | drawer | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | drawer | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | drawer | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | drawer | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | drawer | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | drawer | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | drawer | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | drawer | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | drawer | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | drawer | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | drawer | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | drawer | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | drawer | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | drawer | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | drawer | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | drawer | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | drawer | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | drawer | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | drawer | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | drawer | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | drawer | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | drawer | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | drawer | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | drawer | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | drawer | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | drawer | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | drawer | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | drawer | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | drawer | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | drawer | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | drawer | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | drawer | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | drawer | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | drawer | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | drawer | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | drawer | Search products  [#search -> action:search] | overlay open=true |
| PASS | drawer | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | drawer |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | drawer | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | drawer | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | drawer | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | drawer | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | drawer | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | drawer | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | drawer | Support  [#help -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | drawer | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | drawer | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | drawer | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | drawer | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | drawer | Best sellers  [#shop -> route:/collections/all] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=all |
| PASS | contact | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | contact | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | contact | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | contact | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | contact | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | contact | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | contact | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | contact | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | contact | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | contact | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | contact | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | contact | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | contact | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | contact | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | contact | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | contact | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | contact | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | contact | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | contact | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | contact | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | contact | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | contact | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | contact | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | contact | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | contact | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | contact | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | contact | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | contact | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | contact | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | contact | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | contact | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | contact | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | contact | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | contact | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | contact | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | contact | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | contact | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | contact | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | contact | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | contact | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | contact | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | contact | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | contact | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | contact | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | contact | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | contact | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | contact | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | contact | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | contact | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | contact | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | contact | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | contact | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | contact | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | contact | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | contact | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | contact | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | contact | Search products  [#search -> action:search] | overlay open=true |
| PASS | contact | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | contact | Cart, 0 items  [#cart -> action:cart] | contact drawer open=true |
| PASS | contact | Contact us  [#contact -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | contact | privacy policy  [#privacy -> route:/policies/privacy-policy] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html? |
| PASS | contact | [support email address]  [#mail -> action:unsupported:contact] | This contact detail is a placeholder in the wireframe.× |
| PASS | contact | Frequently asked questions  [#faq -> route:/pages/faq] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html? |
| PASS | contact | Shipping and delivery  [#shipping -> route:/policies/shipping-policy] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html? |
| PASS | contact | Returns and refunds  [#returns -> route:/policies/refund-policy] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html? |
| PASS | contact |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | contact | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | contact | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | contact | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | contact | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | contact | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | contact | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | contact | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | contact | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | contact | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | contact | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | faq | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | faq | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | faq | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | faq | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | faq | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | faq | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | faq | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | faq | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | faq | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | faq | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | faq | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | faq | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | faq | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | faq | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | faq | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | faq | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | faq | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | faq | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | faq | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | faq | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | faq | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | faq | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | faq | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | faq | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | faq | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | faq | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | faq | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | faq | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | faq | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | faq | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | faq | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | faq | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | faq | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | faq | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | faq | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | faq | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | faq | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | faq | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | faq | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | faq | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | faq | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | faq | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | faq | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | faq | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | faq | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | faq | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | faq | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | faq | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | faq | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | faq | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | faq | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | faq | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | faq | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | faq | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | faq | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | faq | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | faq | Search products  [#search -> action:search] | overlay open=true |
| PASS | faq | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | faq | Cart, 0 items  [#cart -> action:cart] | faq drawer open=true |
| PASS | faq | FAQ  [#faq -> route:/pages/faq] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html? |
| PASS | faq | Orders and delivery  [#g-orders -> inpage:#g-orders] | target g-orders exists, no navigation |
| PASS | faq | Returns  [#g-returns -> inpage:#g-returns] | target g-returns exists, no navigation |
| PASS | faq | Products and skin  [#g-products -> inpage:#g-products] | target g-products exists, no navigation |
| PASS | faq | Account and payment  [#g-account -> inpage:#g-account] | target g-account exists, no navigation |
| PASS | faq | returns and refunds page  [#returns -> route:/policies/refund-policy] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html? |
| PASS | faq | contact page  [#contact -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | faq |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | faq | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | faq | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | faq | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | faq | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | faq | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | faq | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | faq | Support  [#help -> inpage:#help] | target help exists, no navigation |
| PASS | faq | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | faq | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | faq | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | faq | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | about | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | about | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | about | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | about | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | about | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | about | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | about | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | about | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | about | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | about | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | about | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | about | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | about | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | about | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | about | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | about | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | about | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | about | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | about | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | about | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | about | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | about | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | about | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | about | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | about | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | about | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | about | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | about | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | about | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | about | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | about | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | about | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | about | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | about | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | about | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | about | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | about | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | about | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | about | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | about | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | about | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | about | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | about | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | about | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | about | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | about | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | about | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | about | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | about | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | about | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | about | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | about | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | about | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | about | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | about | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | about | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | about | Search products  [#search -> action:search] | overlay open=true |
| PASS | about | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | about | Cart, 0 items  [#cart -> action:cart] | about drawer open=true |
| PASS | about | About us  [#about -> route:/pages/about] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html? |
| PASS | about | Shop the collection  [#shop -> route:/collections/all] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=all |
| PASS | about | Browse our ingredients  [#ingredients -> route:/blogs/journal/tagged/ingredients] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html?t=ingredients |
| PASS | about | Read our story  [#story -> route:/pages/our-story] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html? |
| PASS | about |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | about | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | about | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | about | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | about | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | about | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | about | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | about | Support  [#help -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | about | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | about | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | about | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | about | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | story | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | story | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | story | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | story | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | story | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | story | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | story | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | story | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | story | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | story | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | story | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | story | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | story | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | story | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | story | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | story | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | story | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | story | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | story | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | story | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | story | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | story | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | story | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | story | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | story | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | story | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | story | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | story | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | story | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | story | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | story | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | story | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | story | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | story | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | story | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | story | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | story | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | story | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | story | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | story | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | story | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | story | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | story | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | story | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | story | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | story | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | story | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | story | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | story | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | story | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | story | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | story | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | story | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | story | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | story | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | story | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | story | Search products  [#search -> action:search] | overlay open=true |
| PASS | story | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | story | Cart, 0 items  [#cart -> action:cart] | story drawer open=true |
| PASS | story | About us  [#about -> route:/pages/about] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html? |
| PASS | story | Our story  [#story -> route:/pages/our-story] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html? |
| PASS | story | Shop now  [#shop -> route:/collections/all] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=all |
| PASS | story |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | story | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | story | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | story | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | story | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | story | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | story | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | story | Support  [#help -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | story | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | story | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | story | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | story | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | shipping | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | shipping | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | shipping | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | shipping | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | shipping | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | shipping | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | shipping | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | shipping | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | shipping | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | shipping | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | shipping | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | shipping | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | shipping | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | shipping | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | shipping | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | shipping | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | shipping | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | shipping | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | shipping | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | shipping | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | shipping | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | shipping | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | shipping | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | shipping | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | shipping | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | shipping | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | shipping | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | shipping | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | shipping | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | shipping | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | shipping | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | shipping | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | shipping | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | shipping | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | shipping | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | shipping | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | shipping | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | shipping | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | shipping | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | shipping | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | shipping | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | shipping | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | shipping | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | shipping | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | shipping | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | shipping | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | shipping | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | shipping | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | shipping | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | shipping | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | shipping | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | shipping | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | shipping | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | shipping | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | shipping | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | shipping | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | shipping | Search products  [#search -> action:search] | overlay open=true |
| PASS | shipping | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | shipping | Cart, 0 items  [#cart -> action:cart] | shipping drawer open=true |
| PASS | shipping | Policies  [#policies -> route:/policies/shipping-policy] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html? |
| PASS | shipping | Processing time  [#s-processing -> inpage:#s-processing] | target s-processing exists, no navigation |
| PASS | shipping | Shipping rates and regions  [#s-rates -> inpage:#s-rates] | target s-rates exists, no navigation |
| PASS | shipping | Delivery times  [#s-times -> inpage:#s-times] | target s-times exists, no navigation |
| PASS | shipping | Order tracking  [#s-tracking -> inpage:#s-tracking] | target s-tracking exists, no navigation |
| PASS | shipping | Delays and lost parcels  [#s-delays -> inpage:#s-delays] | target s-delays exists, no navigation |
| PASS | shipping | Address changes  [#s-address -> inpage:#s-address] | target s-address exists, no navigation |
| PASS | shipping | Duties and taxes  [#s-duties -> inpage:#s-duties] | target s-duties exists, no navigation |
| PASS | shipping | Contact  [#s-contact -> inpage:#s-contact] | target s-contact exists, no navigation |
| PASS | shipping | Contact us  [#contact -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | shipping | Read the FAQ  [#faq -> route:/pages/faq] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html? |
| PASS | shipping |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | shipping | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | shipping | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | shipping | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | shipping | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | shipping | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | shipping | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | shipping | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | shipping | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | shipping | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | shipping | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | returns | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | returns | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | returns | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | returns | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | returns | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | returns | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | returns | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | returns | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | returns | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | returns | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | returns | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | returns | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | returns | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | returns | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | returns | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | returns | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | returns | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | returns | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | returns | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | returns | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | returns | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | returns | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | returns | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | returns | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | returns | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | returns | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | returns | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | returns | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | returns | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | returns | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | returns | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | returns | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | returns | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | returns | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | returns | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | returns | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | returns | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | returns | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | returns | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | returns | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | returns | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | returns | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | returns | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | returns | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | returns | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | returns | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | returns | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | returns | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | returns | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | returns | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | returns | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | returns | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | returns | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | returns | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | returns | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | returns | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | returns | Search products  [#search -> action:search] | overlay open=true |
| PASS | returns | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | returns | Cart, 0 items  [#cart -> action:cart] | returns drawer open=true |
| PASS | returns | Policies  [#policies -> route:/policies/shipping-policy] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html? |
| PASS | returns | Returns and refunds  [#returns -> route:/policies/refund-policy] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html? |
| PASS | returns | Return window  [#s-window -> inpage:#s-window] | target s-window exists, no navigation |
| PASS | returns | What can be returned  [#s-eligible -> inpage:#s-eligible] | target s-eligible exists, no navigation |
| PASS | returns | What cannot be returned  [#s-notreturn -> inpage:#s-notreturn] | target s-notreturn exists, no navigation |
| PASS | returns | How to start a return  [#s-start -> inpage:#s-start] | target s-start exists, no navigation |
| PASS | returns | Return shipping  [#s-shipping -> inpage:#s-shipping] | target s-shipping exists, no navigation |
| PASS | returns | Refunds  [#s-refunds -> inpage:#s-refunds] | target s-refunds exists, no navigation |
| PASS | returns | Exchanges  [#s-exchanges -> inpage:#s-exchanges] | target s-exchanges exists, no navigation |
| PASS | returns | Damaged or wrong items  [#s-damaged -> inpage:#s-damaged] | target s-damaged exists, no navigation |
| PASS | returns | Contact  [#s-contact -> inpage:#s-contact] | target s-contact exists, no navigation |
| PASS | returns | Contact us  [#contact -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | returns | Read the FAQ  [#faq -> route:/pages/faq] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html? |
| PASS | returns |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | returns | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | returns | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | returns | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | returns | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | returns | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | returns | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | returns | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | returns | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | returns | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | returns | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | privacy | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | privacy | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | privacy | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | privacy | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | privacy | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | privacy | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | privacy | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | privacy | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | privacy | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | privacy | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | privacy | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | privacy | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | privacy | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | privacy | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | privacy | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | privacy | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | privacy | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | privacy | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | privacy | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | privacy | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | privacy | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | privacy | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | privacy | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | privacy | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | privacy | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | privacy | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | privacy | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | privacy | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | privacy | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | privacy | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | privacy | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | privacy | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | privacy | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | privacy | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | privacy | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | privacy | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | privacy | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | privacy | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | privacy | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | privacy | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | privacy | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | privacy | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | privacy | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | privacy | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | privacy | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | privacy | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | privacy | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | privacy | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | privacy | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | privacy | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | privacy | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | privacy | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | privacy | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | privacy | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | privacy | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | privacy | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | privacy | Search products  [#search -> action:search] | overlay open=true |
| PASS | privacy | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | privacy | Cart, 0 items  [#cart -> action:cart] | privacy drawer open=true |
| PASS | privacy | Policies  [#policies -> route:/policies/shipping-policy] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html? |
| PASS | privacy | Privacy policy  [#privacy -> route:/policies/privacy-policy] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html? |
| PASS | privacy | Information we collect  [#s-collect -> inpage:#s-collect] | target s-collect exists, no navigation |
| PASS | privacy | How we use information  [#s-use -> inpage:#s-use] | target s-use exists, no navigation |
| PASS | privacy | Cookies and similar technologies  [#s-cookies -> inpage:#s-cookies] | target s-cookies exists, no navigation |
| PASS | privacy | Who we share information with  [#s-sharing -> inpage:#s-sharing] | target s-sharing exists, no navigation |
| PASS | privacy | Your choices and rights  [#s-choices -> inpage:#s-choices] | target s-choices exists, no navigation |
| PASS | privacy | How long we keep information  [#s-retention -> inpage:#s-retention] | target s-retention exists, no navigation |
| PASS | privacy | How we protect information  [#s-security -> inpage:#s-security] | target s-security exists, no navigation |
| PASS | privacy | Changes to this policy  [#s-changes -> inpage:#s-changes] | target s-changes exists, no navigation |
| PASS | privacy | Contact  [#s-contact -> inpage:#s-contact] | target s-contact exists, no navigation |
| PASS | privacy | Contact us  [#contact -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | privacy | Read the FAQ  [#faq -> route:/pages/faq] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html? |
| PASS | privacy |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | privacy | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | privacy | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | privacy | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | privacy | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | privacy | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | privacy | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | privacy | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | privacy | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | privacy | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | privacy | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | terms | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | terms | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | terms | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | terms | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | terms | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | terms | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | terms | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | terms | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | terms | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | terms | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | terms | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | terms | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | terms | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | terms | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | terms | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | terms | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | terms | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | terms | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | terms | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | terms | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | terms | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | terms | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | terms | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | terms | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | terms | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | terms | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | terms | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | terms | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | terms | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | terms | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | terms | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | terms | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | terms | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | terms | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | terms | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | terms | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | terms | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | terms | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | terms | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | terms | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | terms | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | terms | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | terms | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | terms | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | terms | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | terms | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | terms | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | terms | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | terms | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | terms | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | terms | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | terms | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | terms | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | terms | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | terms | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | terms | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | terms | Search products  [#search -> action:search] | overlay open=true |
| PASS | terms | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | terms | Cart, 0 items  [#cart -> action:cart] | terms drawer open=true |
| PASS | terms | Policies  [#policies -> route:/policies/shipping-policy] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html? |
| PASS | terms | Terms and conditions  [#terms -> route:/policies/terms-of-service] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html? |
| PASS | terms | Returns and refunds  [#returns -> route:/policies/refund-policy] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html? |
| PASS | terms | Privacy policy  [#privacy -> route:/policies/privacy-policy] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html? |
| PASS | terms | Using our store  [#s-using -> inpage:#s-using] | target s-using exists, no navigation |
| PASS | terms | Products and pricing  [#s-products -> inpage:#s-products] | target s-products exists, no navigation |
| PASS | terms | Orders and payment  [#s-orders -> inpage:#s-orders] | target s-orders exists, no navigation |
| PASS | terms | Shipping, returns and refunds  [#s-delivery -> inpage:#s-delivery] | target s-delivery exists, no navigation |
| PASS | terms | Accounts  [#s-account -> inpage:#s-account] | target s-account exists, no navigation |
| PASS | terms | Intellectual property  [#s-ip -> inpage:#s-ip] | target s-ip exists, no navigation |
| PASS | terms | Limits of liability  [#s-liability -> inpage:#s-liability] | target s-liability exists, no navigation |
| PASS | terms | Governing law  [#s-law -> inpage:#s-law] | target s-law exists, no navigation |
| PASS | terms | Changes to these terms  [#s-changes -> inpage:#s-changes] | target s-changes exists, no navigation |
| PASS | terms | Contact  [#s-contact -> inpage:#s-contact] | target s-contact exists, no navigation |
| PASS | terms | Contact us  [#contact -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | terms | Read the FAQ  [#faq -> route:/pages/faq] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html? |
| PASS | terms |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | terms | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | terms | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | terms | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | terms | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | terms | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | terms | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | terms | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | terms | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | terms | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | terms | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | blog | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | blog | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | blog | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | blog | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | blog | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | blog | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | blog | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | blog | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | blog | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | blog | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | blog | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | blog | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | blog | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | blog | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | blog | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | blog | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | blog | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | blog | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | blog | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | blog | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | blog | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | blog | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | blog | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | blog | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | blog | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | blog | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | blog | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | blog | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | blog | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | blog | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | blog | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | blog | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | blog | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | blog | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | blog | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | blog | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | blog | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | blog | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | blog | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | blog | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | blog | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | blog | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | blog | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | blog | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | blog | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | blog | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | blog | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | blog | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | blog | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | blog | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | blog | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | blog | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | blog | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | blog | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | blog | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | blog | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | blog | Search products  [#search -> action:search] | overlay open=true |
| PASS | blog | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | blog | Cart, 0 items  [#cart -> action:cart] | blog drawer open=true |
| PASS | blog | Journal  [#blog -> route:/blogs/journal] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html? |
| PASS | blog | Skincare  [#tag -> route:/blogs/journal/tagged/skincare] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html?t=skincare |
| PASS | blog | Routines  [#tag -> route:/blogs/journal/tagged/routines] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html?t=routines |
| PASS | blog | Ingredients  [#tag -> route:/blogs/journal/tagged/ingredients] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html?t=ingredients |
| PASS | blog | Makeup  [#tag -> route:/blogs/journal/tagged/makeup] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html?t=makeup |
| PASS | blog | Hair and body  [#tag -> route:/blogs/journal/tagged/hair-and-body] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html?t=hair-and-body |
| PASS | blog | Image placeholder: featured article  [#article -> route:/blogs/journal/a-simple-morning-skincare-routine] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=a-simple-morning-skincare-routine |
| PASS | blog | Image placeholder: article  [#article -> route:/blogs/journal/how-to-layer-your-skincare] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=how-to-layer-your-skincare |
| PASS | blog | Image placeholder: article  [#article -> route:/blogs/journal/a-simple-evening-routine] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=a-simple-evening-routine |
| PASS | blog | Image placeholder: article  [#article -> route:/blogs/journal/what-is-niacinamide] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=what-is-niacinamide |
| PASS | blog | Image placeholder: article  [#article -> route:/blogs/journal/skin-prep-before-makeup] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=skin-prep-before-makeup |
| PASS | blog | Image placeholder: article  [#article -> route:/blogs/journal/caring-for-dry-skin-on-the-body] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=caring-for-dry-skin-on-the-body |
| PASS | blog | Image placeholder: article  [#article -> route:/blogs/journal/sunscreen-basics-explained] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=sunscreen-basics-explained |
| PASS | blog | Image placeholder: article  [#article -> route:/blogs/journal/building-a-routine-for-sensitive-skin] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=building-a-routine-for-sensitive-skin |
| PASS | blog | Image placeholder: article  [#article -> route:/blogs/journal/a-guide-to-common-cleansing-ingredients] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=a-guide-to-common-cleansing-ingredients |
| PASS | blog | Image placeholder: article  [#article -> route:/blogs/journal/seasonal-skin-changes] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=seasonal-skin-changes |
| PASS | blog | Previous page  [#p0 -> action:unsupported:pagination] | The wireframe shows one page of sample articles, so there is no next page to ope |
| PASS | blog |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | blog | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | blog | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | blog | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | blog | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | blog | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | blog | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | blog | Support  [#help -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | blog | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | blog | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | blog | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | blog | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | article | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | article | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | article | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | article | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | article | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | article | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | article | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | article | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | article | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | article | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | article | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | article | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | article | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | article | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | article | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | article | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | article | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | article | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | article | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | article | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | article | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | article | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | article | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | article | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | article | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | article | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | article | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | article | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | article | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | article | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | article | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | article | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | article | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | article | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | article | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | article | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | article | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | article | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | article | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | article | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | article | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | article | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | article | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | article | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | article | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | article | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | article | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | article | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | article | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | article | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | article | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | article | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | article | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | article | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | article | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | article | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | article | Search products  [#search -> action:search] | overlay open=true |
| PASS | article | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | article | Cart, 0 items  [#cart -> action:cart] | article drawer open=true |
| PASS | article | Journal  [#blog -> route:/blogs/journal] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html? |
| PASS | article | What is niacinamide?  [#article -> inpage:#article] | target article exists, no navigation |
| PASS | article | Ingredients  [#tag -> route:/blogs/journal/tagged/ingredients] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html?t=ingredients |
| PASS | article | Skincare  [#tag -> route:/blogs/journal/tagged/skincare] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html?t=skincare |
| PASS | article | Previous articleA simple evening routine  [#prev -> route:/blogs/journal/a-simple-evening-routine] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=a-simple-evening-routine |
| PASS | article | Next articleSkin prep before makeup  [#next -> route:/blogs/journal/skin-prep-before-makeup] | 15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=skin-prep-before-makeup |
| PASS | article |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | article | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | article | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | article | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | article | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | article | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | article | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | article | Support  [#help -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | article | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | article | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | article | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | article | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |
| PASS | notfound | Skip to content  [#main -> inpage:#main] | target main exists, no navigation |
| PASS | notfound | Store home  [#top -> route:/] | 01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html? |
| PASS | notfound | Skin  [#collection -> route:/collections/skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin |
| PASS | notfound | Hydration  [#collection-skin-hydration -> route:/collections/skin-hydration] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-hydration |
| PASS | notfound | Brightening  [#collection-skin-brightening -> route:/collections/skin-brightening] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-brightening |
| PASS | notfound | Anti-ageing  [#collection-skin-anti-ageing -> route:/collections/skin-anti-ageing] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-anti-ageing |
| PASS | notfound | Blemish care  [#collection-skin-blemish-care -> route:/collections/skin-blemish-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-blemish-care |
| PASS | notfound | Sensitive skin  [#collection-skin-sensitive-skin -> route:/collections/skin-sensitive-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sensitive-skin |
| PASS | notfound | Cleansers  [#collection-skin-cleansers -> route:/collections/skin-cleansers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-cleansers |
| PASS | notfound | Serums  [#collection-skin-serums -> route:/collections/skin-serums] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-serums |
| PASS | notfound | Moisturisers  [#collection-skin-moisturisers -> route:/collections/skin-moisturisers] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-moisturisers |
| PASS | notfound | Sun care  [#collection-skin-sun-care -> route:/collections/skin-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-sun-care |
| PASS | notfound | Masks  [#collection-skin-masks -> route:/collections/skin-masks] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-masks |
| PASS | notfound | Eye care  [#collection-skin-eye-care -> route:/collections/skin-eye-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-eye-care |
| PASS | notfound | New in skinShop now  [#collection-skin-new-in-skin -> route:/collections/skin-new-in-skin] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-new-in-skin |
| PASS | notfound | Skin routinesShop now  [#collection-skin-skin-routines -> route:/collections/skin-skin-routines] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin-skin-routines |
| PASS | notfound | Makeup  [#collection -> route:/collections/makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup |
| PASS | notfound | Foundation  [#collection-makeup-foundation -> route:/collections/makeup-foundation] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-foundation |
| PASS | notfound | Concealer  [#collection-makeup-concealer -> route:/collections/makeup-concealer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-concealer |
| PASS | notfound | Blush  [#collection-makeup-blush -> route:/collections/makeup-blush] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-blush |
| PASS | notfound | Highlighter  [#collection-makeup-highlighter -> route:/collections/makeup-highlighter] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-highlighter |
| PASS | notfound | Primer  [#collection-makeup-primer -> route:/collections/makeup-primer] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-primer |
| PASS | notfound | Mascara  [#collection-makeup-mascara -> route:/collections/makeup-mascara] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-mascara |
| PASS | notfound | Eyeliner  [#collection-makeup-eyeliner -> route:/collections/makeup-eyeliner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-eyeliner |
| PASS | notfound | Brows  [#collection-makeup-brows -> route:/collections/makeup-brows] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brows |
| PASS | notfound | Lipstick  [#collection-makeup-lipstick -> route:/collections/makeup-lipstick] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lipstick |
| PASS | notfound | Lip care  [#collection-makeup-lip-care -> route:/collections/makeup-lip-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-lip-care |
| PASS | notfound | Brushes and tools  [#collection-makeup-brushes-and-tools -> route:/collections/makeup-brushes-and-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-brushes-and-tools |
| PASS | notfound | New in makeupShop now  [#collection-makeup-new-in-makeup -> route:/collections/makeup-new-in-makeup] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-new-in-makeup |
| PASS | notfound | Complexion editShop now  [#collection-makeup-complexion-edit -> route:/collections/makeup-complexion-edit] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=makeup-complexion-edit |
| PASS | notfound | Hair  [#collection -> route:/collections/hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair |
| PASS | notfound | Dryness  [#collection-hair-dryness -> route:/collections/hair-dryness] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-dryness |
| PASS | notfound | Frizz  [#collection-hair-frizz -> route:/collections/hair-frizz] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-frizz |
| PASS | notfound | Colour care  [#collection-hair-colour-care -> route:/collections/hair-colour-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-colour-care |
| PASS | notfound | Scalp care  [#collection-hair-scalp-care -> route:/collections/hair-scalp-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-scalp-care |
| PASS | notfound | Hair loss  [#collection-hair-hair-loss -> route:/collections/hair-hair-loss] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-hair-loss |
| PASS | notfound | Shampoo  [#collection-hair-shampoo -> route:/collections/hair-shampoo] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-shampoo |
| PASS | notfound | Conditioner  [#collection-hair-conditioner -> route:/collections/hair-conditioner] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-conditioner |
| PASS | notfound | Treatments  [#collection-hair-treatments -> route:/collections/hair-treatments] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-treatments |
| PASS | notfound | Styling  [#collection-hair-styling -> route:/collections/hair-styling] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-styling |
| PASS | notfound | Tools  [#collection-hair-tools -> route:/collections/hair-tools] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-tools |
| PASS | notfound | New in hairShop now  [#collection-hair-new-in-hair -> route:/collections/hair-new-in-hair] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-new-in-hair |
| PASS | notfound | Salon at homeShop now  [#collection-hair-salon-at-home -> route:/collections/hair-salon-at-home] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=hair-salon-at-home |
| PASS | notfound | Body  [#collection -> route:/collections/body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body |
| PASS | notfound | Body wash  [#collection-body-body-wash -> route:/collections/body-body-wash] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-wash |
| PASS | notfound | Body lotion  [#collection-body-body-lotion -> route:/collections/body-body-lotion] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-lotion |
| PASS | notfound | Body oil  [#collection-body-body-oil -> route:/collections/body-body-oil] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-oil |
| PASS | notfound | Scrubs  [#collection-body-scrubs -> route:/collections/body-scrubs] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-scrubs |
| PASS | notfound | Hand and foot care  [#collection-body-hand-and-foot-care -> route:/collections/body-hand-and-foot-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-hand-and-foot-care |
| PASS | notfound | Perfume  [#collection-body-perfume -> route:/collections/body-perfume] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-perfume |
| PASS | notfound | Body mist  [#collection-body-body-mist -> route:/collections/body-body-mist] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-body-mist |
| PASS | notfound | Deodorant  [#collection-body-deodorant -> route:/collections/body-deodorant] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-deodorant |
| PASS | notfound | Sun care  [#collection-body-sun-care -> route:/collections/body-sun-care] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-sun-care |
| PASS | notfound | Gifts and sets  [#collection-body-gifts-and-sets -> route:/collections/body-gifts-and-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gifts-and-sets |
| PASS | notfound | New in bodyShop now  [#collection-body-new-in-body -> route:/collections/body-new-in-body] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-new-in-body |
| PASS | notfound | Gift setsShop now  [#collection-body-gift-sets -> route:/collections/body-gift-sets] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=body-gift-sets |
| PASS | notfound | Search products  [#search -> action:search] | overlay open=true |
| PASS | notfound | Account  [#account -> action:unsupported:account] | Accounts and sign-in are not part of the wireframes. In Shopify this is the cust |
| PASS | notfound | Cart, 0 items  [#cart -> action:cart] | notfound drawer open=true |
| PASS | notfound | Best sellers  [#shop -> route:/collections/all] | 02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=all |
| PASS | notfound |   [#top -> inpage:#top] | target top exists, no navigation |
| PASS | notfound | Instagram  [# -> action:unsupported:social] | The social profile address is not set in the wireframe. In Shopify it is a theme |
| PASS | notfound | About us  [../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html -> file:../08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html] | 08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html |
| PASS | notfound | Our story  [../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html -> file:../09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html] | 09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html |
| PASS | notfound | Journal  [../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html -> file:../14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html] | 14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html |
| PASS | notfound | FAQ  [../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html -> file:../07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html] | 07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html |
| PASS | notfound | Contact us  [../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html -> file:../06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html |
| PASS | notfound | Support  [#help -> route:/pages/contact] | 06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html? |
| PASS | notfound | Shipping & Delivery  [../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html -> file:../10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html] | 10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html |
| PASS | notfound | Returns & Refunds  [../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html -> file:../11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html] | 11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html |
| PASS | notfound | Privacy policy  [../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html -> file:../12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html] | 12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html |
| PASS | notfound | Terms of service  [../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html -> file:../13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html] | 13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html |