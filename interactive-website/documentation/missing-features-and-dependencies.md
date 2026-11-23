# Missing features and dependencies

Checked against the 16 wireframe pages and the interactive layer (see also `missing-pages-and-interactions.md` for the control-by-control audit). Nothing in this list was created without a decision, except the search overlay, which is labelled as a stand-in.

Type key: **WF** = missing wireframe component, **INT** = missing interactive functionality, **SHOP** = needs Shopify integration, **EXT** = needs a backend or external service.

| Missing item | Type | Required page | Priority | Reason | Recommended action |
|---|---|---|---|---|---|
| Search results page (`/search`) | WF + SHOP | New "Search results" page | High | Header search (48 links) needs a destination for "see all results", filters and pagination. Only a small overlay exists | Design the page by reusing the PLP grid, filters and empty state; Shopify `search.liquid` + Predictive Search API |
| Search overlay design sign-off | WF | Header | High | The overlay in the prototype is a stand-in built from existing tokens; it is not in the approved wireframes | Approve or redesign; keep the same states (empty, loading, results, no results) |
| Search no-results state | INT (exists in overlay) | Overlay and results page | Medium | Works in the overlay with suggestions and a way out; the results page does not exist | Carry the same copy to the results page |
| Wishlist page and heart control | WF + INT + SHOP | PLP card, PDP, new Wishlist page | Medium | The wireframes have no wishlist control (the PDP list marks it "Removed: apps"); state API exists but nothing calls it | Decide whether wishlist is in scope; if yes design the control and page; Shopify needs a wishlist app (customer metafield or app proxy) |
| Account, Login | WF + SHOP | New pages | High | Header Account icon (16 links) has no page. The prototype shows a "not available" notice | Design login and account pages; Shopify customer accounts (new customer accounts are Shopify-hosted) |
| Register | WF + SHOP | New page | High | Same as above | Same as above |
| Forgot password | WF + SHOP | New page | Medium | Same as above | Same as above |
| Order tracking and order history | WF + SHOP | Account area, `/account/orders` | Medium | The Shipping policy only describes tracking (anchor `#s-tracking`); there is no tracking page | Design an orders list and order detail; Shopify order status page |
| Checkout and payment | SHOP | `/checkout` | High (launch) | Must stay Shopify-native. The prototype shows a "not simulated" notice and sends nothing | Keep Shopify Checkout; configure payment, shipping and taxes in the store |
| Discount code | SHOP | Checkout | Low | Excluded in the approved cart decisions | Leave to Shopify Checkout |
| Product reviews | SHOP + EXT | PDP `#reviews`, Homepage testimonials | Medium | PDP shows a labelled app slot; Homepage quotes are merchant-typed samples | Reviews app; keep metafields `reviews.rating` and `reviews.rating_count` as pending merchant confirmation |
| Product recommendations | SHOP | PDP "Complete your routine" and "Related products" | Medium | Both are static sample markup, the same four related products for every product | Shopify Product Recommendations API (complementary and related) |
| Article related products | WF | Blog article | Medium | The Article wireframe has no such section, so Blog → Article → Related products → PDP is blocked | Approve a related-products section; data hook `NudgeSite.blog.relatedProducts()` already exists |
| Blog pagination (pages 2 and 3) | WF + SHOP | Blog listing | Low | The wireframe shows one page of 10 sample articles | Shopify `paginate` over `blog.articles` |
| Makeup, hair, body products and collections | SHOP (data) | PLP, PDP | High | The PLP sample data is skin care only; ~40 sub-collections open the PLP's own "no products" state | Load the real catalogue (products, collections, metafields) |
| Per-product PDP content | SHOP (data) | PDP | High | Gallery, description, FAQ, shades and ratings are the Tinted Moisturiser's for every product | Shopify product object: media, variants, metafields |
| Product metafields (`custom.size`, `custom.highlight`, `reviews.rating`, `reviews.rating_count`, tag `badge:<text>`) | SHOP | PLP, PDP | High | PENDING MERCHANT CONFIRMATION; never hard-coded | Merchant confirms; then wire in Liquid |
| Error states | INT (partial) | All forms and cart | Medium | Present: PDP shade error, cart quantity limit, newsletter invalid email, sold-out add, unknown handle → 404. Not present: network failure, out-of-stock race at checkout, contact form server error | Add network error handling when `/cart/*.js` replaces the prototype cart |
| Loading states | INT (partial) | PDP, search | Low | Present: PDP "Adding…" button, search "Searching…". Not present: PLP filtering and cart drawer loading | Add skeleton or busy states when data is remote |
| Success notifications | INT | Cart, PDP, newsletter | Done | PDP "Added to your bag", quick view message, newsletter and sample-cart notices exist | None |
| Mobile navigation | INT | Header | Done | Existing menu button, drawer and accordion work; tested at 320 to 844 px | None |
| Currency switcher | INT (prototype rates) | Header | Medium | The existing market pill works (INR, USD, GBP, EUR) with sample exchange rates | Shopify Markets and `{% form 'localization' %}` |
| Newsletter and contact form delivery | SHOP + EXT | Homepage, Contact | Medium | Forms validate but send nothing | `{% form 'customer' %}` and `{% form 'contact' %}`; email tool for campaigns |
| Real inventory and stock | SHOP | PLP, PDP, Cart | Medium | Stock and "only N left" are sample numbers | Inventory-aware Liquid and `/cart/add.js` errors |
| Persistent cart across devices | SHOP | All | Medium | The prototype cart lives in one browser (localStorage and `window.name`) | The Shopify cart cookie and Cart AJAX API |
| Third-party apps | EXT | — | — | Reviews, wishlist, search enhancements: none installed or simulated, by instruction | Decide per app; none is assumed |

Nothing here introduces a non-Shopify payment interface or a third-party app.
