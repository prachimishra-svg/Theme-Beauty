# Other / Global features CRO plan

_Source: Copy of CRO Points for ABM.xlsx (38 tabs read). Facts from the workbook are marked as source statements; reasoning, implementation and priority are our assessment. The workbook has no conversion data, so none is claimed. Detail for every row is in cro-master-feature-matrix.xlsx._

## What the workbook says

Global items cover performance (layout shift, LCP, lazy loading), navigation and search, analytics events, and the checkout journey. Checkout items (CHK-xx) concern Shopify-controlled pages, so they are recorded for verification and configuration, not theme work.

## Summary

| ID | Feature | Rec. | Priority | Companies |
|---|---|---|---|---|
| GLB-01 | Zero layout shift (CLS) | KEEP | P0 | 6 |
| GLB-02 | Fast LCP with preloaded hero image | KEEP | P0 | 1 |
| GLB-03 | Lazy-load below-the-fold images | KEEP | P0 | 4 |
| GLB-04 | Responsive pages without horizontal scroll | KEEP | P0 | 3 |
| GLB-05 | Mobile menu with drill-down panels | KEEP | P0 | 5 |
| GLB-06 | Search with suggestions and one-tap open | KEEP | P0 | 4 |
| GLB-09 | Cart icon item count | KEEP | P0 | 1 |
| GLB-11 | Brand logo in header | KEEP | P0 | 1 |
| GLB-12 | GA4 e-commerce events: one clean event per action | KEEP | P0 | 10 |
| GLB-07 | Search relevance and synonyms | NEEDS RESEARCH | P1 | 2 |
| GLB-08 | No-results recovery with related or popular products | KEEP | P1 | 6 |
| GLB-10 | Sticky navigation | MODIFY | P1 | 1 |
| CHK-01 | Checkout form: retain entries, one page, billing same as shipping | SKIP | P2 | 4 |
| CHK-02 | Checkout layout: payment button in first fold, item images, link back to cart | SKIP | P2 | 3 |
| CHK-04 | COD OTP verification before confirming orders | NEEDS RESEARCH | P2 | 2 |
| CHK-05 | Guest checkout without gateway phone login | NEEDS RESEARCH | P2 | 3 |
| CHK-06 | Failed or cancelled payment returns users to cart with items kept | NEEDS RESEARCH | P2 | 2 |
| GLB-14 | Order tracking link | KEEP | P2 | 1 |
| GLB-15 | Account sign-up with minimal fields | NEEDS RESEARCH | P2 | 1 |
| GLB-16 | Form validation and field help text | MODIFY | P2 | 3 |
| CHK-03 | Checkout autofill and field hints | NEEDS RESEARCH | P3 | 2 |
| CHK-07 | Order cancellation only from order details | NEEDS RESEARCH | P3 | 1 |
| GLB-13 | Language switcher and matching currency | MODIFY | P3 | 2 |
| GLB-17 | Service, booking and B2B lead-generation flows | SKIP | P3 | 5 |
| GLB-18 | Content hygiene: test products and broken videos | SKIP | P3 | 2 |

## P0 - core must-have

### GLB-01 - Zero layout shift (CLS)

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Other / Global | **Secondary:** Homepage

- **Source says (6 companies):** Content moves vertically while loading, causing wrong clicks on slow networks.
- **Original description (first source, GoDPS Music (15 Companies!r8)):** The layout shift on a page should be zero to avoid users from making incorrect clicks on the website while the website is loading
- **Sources:** GoDPS Music; Tangent; Zelouf Fabrics; Bearded Crew; Svibe; StyleFox _[15 Companies!r8; 15 Companies!r15; 15 Companies!r27; 15 Companies!r51; 15 Companies!r56; 15 Companies!r72]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Stable layout.
- **Our reasoning:** Six entries; a theme-level engineering requirement.
- **Suggested implementation:** Reserve image and embed dimensions, font-display strategy, no late-injecting banners.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### GLB-02 - Fast LCP with preloaded hero image

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Other / Global | **Secondary:** Homepage

- **Source says (1 company):** Svibe: LCP takes more than 4 seconds; preferably under 2.5 seconds.
- **Original description (first source, Svibe (15 Companies!r58)):** The LCP on the page should be preloaded so that users are not kept waiting to interact with the website while it is loading, preferably the LCP load time should be <2.5 seconds
- **Sources:** Svibe _[15 Companies!r58]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Fast first impression.
- **Our reasoning:** Theme performance requirement.
- **Suggested implementation:** Preload and fetchpriority high for the hero image; do not lazy-load it.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### GLB-03 - Lazy-load below-the-fold images

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Other / Global | **Secondary:** Homepage

- **Source says (4 companies):** Images far below the fold are loaded in the first fold.
- **Original description (first source, Bearded Crew (15 Companies!r54)):** Images which are not present in the current fold and are accessible only when the users scrolls down the page, should be loaded only when user scroll to the respective section
- **Sources:** Bearded Crew; Svibe; Helios Pickleball; Wdrobe Apparel _[15 Companies!r54; 15 Companies!r57; 15 Companies!r61; 15 Companies!r66]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Reduce load time.
- **Our reasoning:** Four entries.
- **Suggested implementation:** Native lazy loading below the fold, eager for the first sections.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### GLB-04 - Responsive pages without horizontal scroll

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Other / Global | **Secondary:** Cart

- **Source says (3 companies):** Pages need horizontal scrolling on mobile and look broken.
- **Original description (first source, Oxyfresh (15 Companies!r22)):** The pages should not break on mobile screens so that users can easily navigate the website
- **Sources:** Oxyfresh; Glam Foods LLC; Pick Your Trail _[15 Companies!r22; httpsglamfoodsllc.com!r2; httpspickyourtrail.com!r9]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Trust and usability on mobile.
- **Our reasoning:** Theme baseline.
- **Suggested implementation:** Test at 320px; no fixed widths.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### GLB-05 - Mobile menu with drill-down panels

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Other / Global | **Secondary:** Homepage

- **Source says (5 companies):** Sub-categories should open in a separate view with a back button so no top-level item moves off screen.
- **Original description (first source, Blue Tokai Coffee (15 Companies!r2)):** Subcategories should be shown in a separate tab with back button to view the parent categories so that non of the categories move off the screen
- **Sources:** Blue Tokai Coffee; Oxyfresh; Max Protein; bebe; Pick Your Trail _[15 Companies!r2; 15 Companies!r21; httpsmaxprotein.in!r10; httpswww.bebe.com!r3; httpspickyourtrail.com!r16]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Discoverability.
- **Our reasoning:** Five entries.
- **Suggested implementation:** Drawer menu with sliding levels and back button; accessible and fully scrollable.
- **Desktop:** Mega menu. | **Mobile:** Sliding panels.
- **Unresolved questions:** None.

### GLB-06 - Search with suggestions and one-tap open

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Other / Global | **Secondary:** PLP / Collection

- **Source says (4 companies):** Search bar needs two clicks to open and shows no suggestions; blank search bar; Bearded Crew: users scan manually for products.
- **Original description (first source, Mivi (httpswww.mivi.in!r13)):** The search bar doesn't show dynamic recommendation when not in use
- **Sources:** Mivi; Life Long India; Wellversed; Bearded Crew _[httpswww.mivi.in!r13; LifelongIndia!r4; Wellversed!r3; 15 Companies!r52]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Faster discovery.
- **Our reasoning:** Four entries.
- **Suggested implementation:** Predictive search with trending queries, products and collections.
- **Desktop:** Inline bar or panel. | **Mobile:** Full-screen search.
- **Unresolved questions:** Native predictive search or an app.

### GLB-09 - Cart icon item count

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Other / Global | **Secondary:** Cart

- **Source says (1 company):** Cart icon does not show the number of items.
- **Original description (first source, Life Long India (LifelongIndia!r9)):** Number of items in the cart should be shown on the cart icon
- **Sources:** Life Long India _[LifelongIndia!r9]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Show cart status.
- **Our reasoning:** Basic pattern.
- **Suggested implementation:** Count badge with accessible label.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### GLB-11 - Brand logo in header

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Other / Global | **Secondary:** Homepage

- **Source says (1 company):** Header has only a navigation menu and no logo.
- **Original description (first source, Glam Foods LLC (httpsglamfoodsllc.com!r7)):** The header should display the logo of te brand so that website looks authentic and trust worthy
- **Sources:** Glam Foods LLC _[httpsglamfoodsllc.com!r7]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Authenticity and trust.
- **Our reasoning:** Basic.
- **Suggested implementation:** Logo (image or text) required in header settings.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### GLB-12 - GA4 e-commerce events: one clean event per action

**Recommendation:** KEEP | **Priority:** P0 | **Primary page:** Other / Global | **Secondary:** Cart

- **Source says (10 companies):** Begin checkout, shipping info and payment info events missing; duplicate add_to_cart events with wrong values; checklist: view product, add to cart, begin checkout, shipping info, billing info, purchase.
- **Original description (first source, Oxyfresh (15 Companies!r25)):** Importanat events like begin checkout, add to cart etc. should be setup on the website which enable marketers to make informed decisions and improved conversions
- **Sources:** Oxyfresh; Sugar Lash Pro; Apo Shop; Wdrobe Apparel; Borosil; Navneet; Flo Mattress; IBA Cosmetics; Legacy Health and Wellness; How To Do (process note) _[15 Companies!r25; 15 Companies!r44; 15 Companies!r49; 15 Companies!r70; Borosil!r10; Navneet!r7; Flomattress!r15; Flomattress!r16; IBA Cosmetics!r2; httpswww.legacyhealthwellness.c!r9; How To Do!r5]_
- **Beauty-category sources:** Sugar Lash Pro; IBA Cosmetics
- **Purpose / user problem:** Measure and optimise the funnel.
- **Our reasoning:** Eleven entries. Storefront events can come from the theme; checkout events depend on Shopify pixels and plan.
- **Suggested implementation:** Single dataLayer push per action in the theme; document which events come from Customer Events.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Which analytics stack (GTM, native GA4 channel)?

## P1 - should have in first release

### GLB-07 - Search relevance and synonyms

**Recommendation:** NEEDS RESEARCH | **Priority:** P1 | **Primary page:** Other / Global | **Secondary:** PLP / Collection

- **Source says (2 companies):** Search for red returns an unrelated product; searching a long name fails unless the abbreviation is known.
- **Original description (first source, bebe (httpswww.bebe.com!r10)):** Search results should be shown for searches which match the keyword entered so that users discover the correct products and is able to make a purchase decision
- **Sources:** bebe; Legacy Health and Wellness _[httpswww.bebe.com!r10; httpswww.legacyhealthwellness.c!r7]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Relevant results.
- **Our reasoning:** Depends on search engine quality; synonyms need a search app.
- **Suggested implementation:** Keep native predictive search; optional search app.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Search app in scope?

### GLB-08 - No-results recovery with related or popular products

**Recommendation:** KEEP | **Priority:** P1 | **Primary page:** Other / Global | **Secondary:** PLP / Collection

- **Source says (6 companies):** No-results pages show only a message; expected related products or products the user may like.
- **Original description (first source, Lotus Botanicals (httpswww.lotusbotanicals.com!r6)):** Along with the message, users should also be shown the related products to the searched term. In case no related products are found then users should be show products which they might be interested in.
- **Sources:** Lotus Botanicals; Aroma Magic; Khadi Natural; Fablestreet; Ambrane; Kazo _[httpswww.lotusbotanicals.com!r6; httpswww.aromamagic.com!r7; httpswww.khadinatural.com!r6; httpswww.fablestreet.com!r6; httpswww.ambraneindia.com!r7; httpswww.kazo.com!r8]_
- **Beauty-category sources:** Lotus Botanicals; Aroma Magic; Khadi Natural
- **Purpose / user problem:** Avoid dead ends.
- **Our reasoning:** Six entries, three in beauty.
- **Suggested implementation:** No-results state with suggestions, popular collections and best sellers.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### GLB-10 - Sticky navigation

**Recommendation:** MODIFY | **Priority:** P1 | **Primary page:** Other / Global | **Secondary:** Homepage

- **Source says (1 company):** Legacy Health: navigation should stay reachable while scrolling. The text says the header should 'move off the screen' and navigation appear sticky.
- **Original description (first source, Legacy Health and Wellness (httpswww.legacyhealthwellness.c!r4)):** When users scrolls through the website, header should move off the screen and naviagtion menu should appear as a sticky to the top of the website which is accessible at all time for the users for easier navigation and enhanced user experience
- **Sources:** Legacy Health and Wellness _[httpswww.legacyhealthwellness.c!r4]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Always-available navigation.
- **Our reasoning:** Intent is clear but the wording is contradictory. Keep it compact so it does not take viewport.
- **Suggested implementation:** Sticky header, announcement bar scrolls away, option to hide on scroll down and reveal on scroll up.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Confirm intent of the Legacy Health row.

## P2 - optional / later

### CHK-01 - Checkout form: retain entries, one page, billing same as shipping

**Recommendation:** SKIP | **Priority:** P2 | **Primary page:** Other / Global | **Secondary:** Cart

- **Source says (4 companies):** Entries are lost on reload; multi-step checkout; billing address must be entered separately.
- **Original description (first source, Max Protein (httpsmaxprotein.in!r5)):** When users have filed in the shipping address n the checkout page and page is relaoded due to any reason the fileds should retain the previously entered value in the current browser session to reduce user fatigue and motivate users to convert
- **Sources:** Max Protein; Legacy Health and Wellness; Melorra; Meolaa _[httpsmaxprotein.in!r5; httpswww.legacyhealthwellness.c!r2; httpswww.legacyhealthwellness.c!r3; Melorra!r2; Melorra!r4; httpsmeolaa.com!r3]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Fast checkout.
- **Our reasoning:** Shopify checkout is controlled by the platform, not the theme. Verify these behaviours on the target store before treating them as gaps.
- **Suggested implementation:** Record as checkout configuration to verify.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Which checkout plan is the store on?

### CHK-02 - Checkout layout: payment button in first fold, item images, link back to cart

**Recommendation:** SKIP | **Priority:** P2 | **Primary page:** Other / Global | **Secondary:** Cart

- **Source says (3 companies):** Payment button only after scroll; only titles shown instead of images; no way back to cart.
- **Original description (first source, Melorra (Melorra!r3)):** Users should be shown the payment button on the first fold itself so that users quickly click on the payment button and complete their purchase
- **Sources:** Melorra; GKB Optical; Biotique _[Melorra!r3; httpswww.gkboptical.com!r3; httpswww.biotique.com!r10]_
- **Beauty-category sources:** Biotique
- **Purpose / user problem:** Clarity in checkout.
- **Our reasoning:** Platform-controlled checkout; theme cannot change it.
- **Suggested implementation:** Record as checkout configuration to verify.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### CHK-04 - COD OTP verification before confirming orders

**Recommendation:** NEEDS RESEARCH | **Priority:** P2 | **Primary page:** Other / Global | **Secondary:** Cart

- **Source says (2 companies):** No OTP for COD allows spam orders; OTP asked after the confirmation is confusing.
- **Original description (first source, Flo Mattress (Flomattress!r17)):** User received the order confirmation mail on email ann whatsapp. After that user is asked to validate OTP on the screen for order confirmation, which is confusing.
- **Sources:** Flo Mattress; Navneet _[Flomattress!r17; Navneet!r2]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Reduce fake COD orders and RTO.
- **Our reasoning:** Needs an app or integration, not the theme.
- **Suggested implementation:** Integration only.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Is COD in scope?

### CHK-05 - Guest checkout without gateway phone login

**Recommendation:** NEEDS RESEARCH | **Priority:** P2 | **Primary page:** Other / Global | **Secondary:** Cart

- **Source says (3 companies):** Razorpay asks for a phone number login before payment, creating friction.
- **Original description (first source, Borosil (Borosil!r29)):** Guest checkout is not available due to mandatory login on razorpay dashboard
- **Sources:** Borosil; Myborosil; Meolaa _[Borosil!r29; httpsmyborosil.com!r5; httpsmeolaa.com!r2]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Remove friction.
- **Our reasoning:** Payment gateway configuration.
- **Suggested implementation:** Configuration only.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Which gateway.

### CHK-06 - Failed or cancelled payment returns users to cart with items kept

**Recommendation:** NEEDS RESEARCH | **Priority:** P2 | **Primary page:** Other / Global | **Secondary:** Cart

- **Source says (2 companies):** After payment failure items are removed or an inventory error shows; cancelled payment sends users to the homepage.
- **Original description (first source, GKB Optical (httpswww.gkboptical.com!r2)):** When the payment fails  the users should be redirected back to the cart page with the original products maintained in the cart so that users are able to retry the pruchase
- **Sources:** GKB Optical; Meolaa _[httpswww.gkboptical.com!r2; httpsmeolaa.com!r4]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Recover failed payments.
- **Our reasoning:** Gateway and checkout behaviour; theme can only provide the cart page.
- **Suggested implementation:** Verify on the store.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### GLB-14 - Order tracking link

**Recommendation:** KEEP | **Priority:** P2 | **Primary page:** Other / Global | **Secondary:** Homepage

- **Source says (1 company):** Track order is not shown while competitors show it prominently.
- **Original description (first source, Borosil (Borosil!r23)):** Track order is not shown on the website as opposed to competitors which show it prominently
- **Sources:** Borosil _[Borosil!r23]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Post-purchase support.
- **Our reasoning:** Single source; low effort.
- **Suggested implementation:** Track order link in footer and header utility; uses a tracking page or app.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Tracking provider.

### GLB-15 - Account sign-up with minimal fields

**Recommendation:** NEEDS RESEARCH | **Priority:** P2 | **Primary page:** Other / Global | **Secondary:** Homepage

- **Source says (1 company):** Sign-up asks for many fields; allow account creation with a mobile number only.
- **Original description (first source, Meolaa (httpsmeolaa.com!r8)):** The user should be able to create account using the mobile number only. The user then can add the other information after going in to the profile section
- **Sources:** Meolaa _[httpsmeolaa.com!r8]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Reduce sign-up drop-off.
- **Our reasoning:** Account methods are controlled by Shopify customer accounts settings.
- **Suggested implementation:** Theme links to Shopify-hosted customer accounts.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Which account type is in use.

### GLB-16 - Form validation and field help text

**Recommendation:** MODIFY | **Priority:** P2 | **Primary page:** Other / Global | **Secondary:** Cart

- **Source says (3 companies):** No error messages on forms; unclear error text; information lost on reload; field examples and pincode auto-fill are missing.
- **Original description (first source, Tangent (15 Companies!r13)):** Users should be clearly shown the error which are restricting the users from submitting the form, to enable to users to make minimal mistakes during submission
- **Sources:** Tangent; Awood Railing; Flo Mattress _[15 Companies!r13; 15 Companies!r14; 15 Companies!r16; 15 Companies!r20; Flomattress!r13; Flomattress!r14; Flomattress!r11]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Fewer form errors.
- **Our reasoning:** Applies to newsletter and contact forms in the theme; checkout is separate (CHK items).
- **Suggested implementation:** Inline error messages, helper text, and retained values on error for all theme forms.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

## P3 - later phase or low value

### CHK-03 - Checkout autofill and field hints

**Recommendation:** NEEDS RESEARCH | **Priority:** P3 | **Primary page:** Other / Global | **Secondary:** Cart

- **Source says (2 companies):** No field examples; no city auto-fill from pincode.
- **Original description (first source, Flo Mattress (Flomattress!r13)):** Provide field suggestions to fasten up the checkout process and reduce the cognitive load
- **Sources:** Flo Mattress; Life Long India _[Flomattress!r13; Flomattress!r14; LifelongIndia!r8]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Less typing.
- **Our reasoning:** Depends on the checkout and address autocomplete options.
- **Suggested implementation:** Verify on the store.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### CHK-07 - Order cancellation only from order details

**Recommendation:** NEEDS RESEARCH | **Priority:** P3 | **Primary page:** Other / Global | **Secondary:** Cart

- **Source says (1 company):** Cancel button on the confirmation page invites impulsive cancellations.
- **Original description (first source, Flo Mattress (Flomattress!r18)):** Order cancellation is avaialable on the confirmation page which increaase the probability of users changing their purchase decision and potential for loss of sale
- **Sources:** Flo Mattress _[Flomattress!r18]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Reduce cancellations.
- **Our reasoning:** Thank-you page and order status are platform pages.
- **Suggested implementation:** Verify.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### GLB-13 - Language switcher and matching currency

**Recommendation:** MODIFY | **Priority:** P3 | **Primary page:** Other / Global | **Secondary:** Homepage

- **Source says (2 companies):** Site in German with no language switcher; currency does not follow language.
- **Original description (first source, Apo Shop (15 Companies!r46)):** The website which serve multiple countries having different languages should allow the users  to switch language and easily navigate through the website
- **Sources:** Apo Shop; StyleFox _[15 Companies!r46; 15 Companies!r74]_
- **Beauty-category sources:** none
- **Purpose / user problem:** Serve multi-language stores.
- **Our reasoning:** Relevant only for multi-market stores; Shopify Markets handles it.
- **Suggested implementation:** Localisation selectors from Shopify Markets as an optional header or footer element.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** Multi-market scope.

### GLB-17 - Service, booking and B2B lead-generation flows

**Recommendation:** SKIP | **Priority:** P3 | **Primary page:** Other / Global | **Secondary:** Homepage

- **Source says (5 companies):** Booking forms, service pages, contact forms and travel-site UI defects.
- **Original description (first source, Legacy Health and Wellness (httpswww.legacyhealthwellness.c!r5)):** Users should be asked minimal information needed to confirm, appointments, for this purpose, prefilling address and email id/ phone number from user accounts, prefilling the service needed by identifying the page from which book now was clicked and simlpy asking users to choose date and time and validate the OTP would improve user experienece and significantly reduce the time to book an appointment
- **Sources:** Legacy Health and Wellness; Glam Foods LLC; Awood Railing; The Design Group; Pick Your Trail _[httpswww.legacyhealthwellness.c!r5; httpswww.legacyhealthwellness.c!r6; httpswww.legacyhealthwellness.c!r8; httpsglamfoodsllc.com!r3; httpsglamfoodsllc.com!r6; 15 Companies!r19; 15 Companies!r32; httpspickyourtrail.com!r10; httpspickyourtrail.com!r11; httpspickyourtrail.com!r12; httpspickyourtrail.com!r13; httpspickyourtrail.com!r14]_
- **Beauty-category sources:** none
- **Purpose / user problem:** n/a
- **Our reasoning:** These sheets concern service, travel or B2B sites that are not e-commerce beauty flows.
- **Suggested implementation:** None in core.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

### GLB-18 - Content hygiene: test products and broken videos

**Recommendation:** SKIP | **Priority:** P3 | **Primary page:** Other / Global | **Secondary:** Homepage

- **Source says (2 companies):** INR 1 test products visible in search; broken videos.
- **Original description (first source, Vicco Labs (httpswww.viccolabs.com!r6)):** User should not be shown any products meeant for testing purpose. Such product should not appear in searches and product listing pages
- **Sources:** Vicco Labs; Glam Foods LLC _[httpswww.viccolabs.com!r6; httpsglamfoodsllc.com!r4]_
- **Beauty-category sources:** Vicco Labs
- **Purpose / user problem:** Credibility.
- **Our reasoning:** Merchandising and QA work, not theme features. Keep in the QA checklist.
- **Suggested implementation:** None.
- **Desktop:** n/a | **Mobile:** n/a
- **Unresolved questions:** None.

