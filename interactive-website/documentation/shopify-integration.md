# Shopify compatibility and what needs real integration

## What is prototype-only (disappears in Shopify)

| Prototype piece | Replaced in Shopify by |
|-----------------|------------------------|
| `runtime/boot.js`, the hook at the end of `nav.js`, `index.html` launcher, status pill | not copied; no equivalent |
| `routing/routes.js` page map and `href()` | theme templates served at the real URLs |
| `routing/navigation-config.js` and `route-resolver.js` | real hrefs written by Liquid: `{{ product.url }}`, `{{ collection.url }}`, `{{ routes.cart_url }}`, `{{ routes.search_url }}`, `{{ article.url }}`, `{{ routes.account_url }}` |
| `data/*.js` (products, collections, blog) | `product`, `collection`, `blog` and `article` objects |
| `state/store.js` | none: the server owns the cart, the customer owns the account |

## What the prototype keeps in the same shape

* Route shapes: `/collections/:handle`, `/products/:handle`, `/cart`, `/pages/:handle`, `/policies/:handle`, `/blogs/journal/:article`, `/blogs/journal/tagged/:tag`, `/search?q=`.
* Cart lines keyed by product handle (Shopify: variant id). Quantity cap and sold-out refusal mirror `/cart/add.js` errors.
* Quantity changes and removal map to `/cart/change.js`; the drawer is a section re-rendered with the Section Rendering API.

## Features that need Shopify or a backend (NOT working in the prototype)

1. **Checkout and payment**: Shopify-hosted `/checkout`. The prototype shows a notice only.
2. **Customer accounts, login, order history**.
3. **Discount codes** (entered at checkout).
4. **Real inventory, stock warnings, sold-out state** (sample values come from the wireframes).
5. **Predictive Search and the `/search` results page**.
6. **Newsletter subscription** (customer form), **contact form** (`{% form 'contact' %}`).
7. **Wishlist** (app), **product reviews** (app), **back-in-stock** (app).
8. **Product data for makeup, hair and body**, per-product media, variants, shades, metafields (`custom.size`, `custom.highlight`, `reviews.rating`, `reviews.rating_count`, `badge:` tags: still pending merchant confirmation).
9. **Markets, currency and duties** beyond the existing sample selector.
10. **Persistent cart across devices**: the prototype's cart lives in this browser only (localStorage and `window.name`).

## Safety of the layer

* The wireframes are unchanged except for one dormant block appended to `03-Wireframes/00-Shared-Tailwind-Foundation/nav.js` (original copy: `tools/nav.js.original`). It runs only when interactive mode is on.
* `06-Shopify-Theme/` and the component library were not modified; their fingerprint is re-checked in the test report.
* Nothing is sent to a store. No Shopify tool was called for this work.
