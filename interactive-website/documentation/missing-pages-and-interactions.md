# Missing pages and interactions (audit)

Method: `tools/audit-links.ps1` opened all 16 wireframe pages in headless Chrome at 1440 px and recorded every link, button, summary, input, select and textarea (tag, text, href, context, data attributes). Evidence: `documentation/data/link-inventory.json` (2,300+ controls). The wireframes were only read.

## 1. Page inventory (what exists)

| # | Page | File | Shopify route used |
|---|------|------|--------------------|
| 01 | Homepage | 01-…/Homepage.html | `/` |
| 02 | PLP | 02-…/PLP.html | `/collections/:handle` (incl. `all`) |
| 03 | PDP | 03-…/PDP.html | `/products/:handle` |
| 04 | Cart page | 04-…/Cart_Page.html | `/cart` |
| 05 | Cart drawer (wireframe page) | 05-…/Cart_Drawer_Wireframe_v1.html | the drawer, opened from any page |
| 06 | Contact | 06-… | `/pages/contact` |
| 07 | FAQ | 07-… | `/pages/faq` |
| 08 | About | 08-… | `/pages/about` |
| 09 | Our story | 09-… | `/pages/our-story` |
| 10 | Shipping policy | 10-… | `/policies/shipping-policy` |
| 11 | Returns policy | 11-… | `/policies/refund-policy` |
| 12 | Privacy policy | 12-… | `/policies/privacy-policy` |
| 13 | Terms | 13-… | `/policies/terms-of-service` |
| 14 | Blog listing | 14-… | `/blogs/journal`, `/blogs/journal/tagged/:tag` |
| 15 | Blog article | 15-… | `/blogs/journal/:handle` |
| 16 | 404 | 16-… | `/404` (unknown handles) |

## 2. Pages that do NOT exist in the wireframes

Reported, not designed. Where a minimal stand-in was needed to make a link work it is labelled.

| Missing | Effect on the site | What the prototype does | Needed |
|---------|-------------------|-------------------------|--------|
| **Search panel and results page** | Header search link and the "Search products" field had no destination (48 links) | **NEW stand-in, needs design sign-off:** a small overlay (products only, popular and recent searches, loading, results, no-results). It uses existing tokens and classes only | Design for the search panel and a `/search` results page; Shopify Predictive Search API and `search.liquid` |
| **Checkout** | Checkout buttons (cart page, drawer, sticky bar) | Clear notice that checkout is not simulated; nothing is stored or paid | Shopify Checkout (hosted by Shopify) |
| **Account, login, orders** | Header Account icon (16 links) | Notice; user state stays signed out | Shopify customer accounts |
| **Wishlist** | No control anywhere (the PDP list marks it "Removed: apps") | State API exists (`NudgeSite.wishlist`) but no UI calls it | Design decision and a wishlist app |
| **Article → Related products** | Journey Blog → Article → Related products → PDP cannot be completed | **Blocked.** The Article wireframe has no related-products section. Data hook ready: `NudgeSite.blog.relatedProducts(handle)` | Add the section to the Article design (approval needed) |
| **Collection pages for makeup, hair, body** | 3 of 4 top-level categories and ~40 sub-collections | Open the PLP's own "no products" state. The PLP sample data holds skin care only | Product catalogue for makeup, hair, body |
| **Blog pagination (pages 2, 3)** | Pagination links | Notice that the sample shows one page | More sample articles or real pagination in Shopify |
| **Per-product PDP content** | Gallery, description, FAQ, ratings, shades are the Tinted Moisturiser's | Only title, price, compare-at, breadcrumb, document title and cart identity change per product. Shade and size pickers are hidden for products without them | Shopify product data (media, metafields, variants) |
| **Product reviews** | `#reviews` is a labelled app slot | Anchor scrolls to the slot | Reviews app |
| **Homepage "Shop the Look" add or product links** | The three look items are hotspot buttons only | Unchanged | Design decision (add link or add button) |
| **Order note on the Cart page** | The Cart wireframe has no note field | Not added; persistence is wired if a `textarea` appears | Design decision |
| **Discount code** | Excluded in the approved cart decisions (Shopify takes codes at checkout) | None | Shopify Checkout |

## 3. Prototype assumptions (not in the wireframes, written down so nobody mistakes them for design)

* Product groups for items outside the PLP data (Lip Colour, Foundation, Blush, Setting Mist, Lip Balm: makeup; Body Lotion, Hand Cream: body; Travel Cleanser: skin). Prices are the ones shown on the Homepage and Cart wireframes.
* Collection filter presets (for example Hydration → concern Dryness, Cleansers → type Cleanser). See `data/collections.js`.
* Journal tags per article and the related products per article. See `data/blog-data.js`.
* Quantity cap: stock or 10, as in the Cart wireframe.
* Product metafields (`custom.size`, `custom.highlight`, `reviews.rating`, `reviews.rating_count`, `badge:` tags) stay **PENDING MERCHANT CONFIRMATION**. The PLP sample values appear only because the PLP wireframe already shows them; nothing new is hard-coded.

## 4. Controls that are not links and how they are handled

| Control | Handling |
|---------|----------|
| Header menu button, mega menu, country selector | Existing page scripts (`nav.js`, `NudgeMarket`) |
| Mobile menu accordion | Existing; the resolver leaves accordion toggles alone below 1024 px |
| Filters, sort, pager, quick view (PLP) | Existing `NudgePLP`; quick view "Add to bag" now writes to the shared cart |
| Variant picker, quantity, selling plan, gallery, zoom (PDP) | Existing `NudgePDP`; "Add to bag" and "Add selected to bag" write to the shared cart |
| Quantity, remove, undo, upsell add (Cart, drawer) | Existing `NudgeCart`; edits are written back to the shared cart |
| Guided finder (Homepage) | Existing; "See matching products" opens the PLP with the chosen skin type |
| Newsletter | Validates, shows a notice, stores nothing |
| Contact form, FAQ accordion | Existing page behaviour (the contact form sends nothing) |
| Carousels, video play, before-and-after slider | Existing page behaviour; video has no real video |
| Review-only panels (`.rv`, `#wp`, state buttons) | Untouched; they are reviewer tools and do not write to the shared cart |

## 5. Remaining unsupported or pending

See `interaction-testing-report.md` section "Pending, blocked and unsupported" for the tested list.
