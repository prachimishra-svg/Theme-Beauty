# Page linking map

Source of truth in code: `routing/routes.js` (routes) and `routing/navigation-config.js` (which link goes where). This table is the same map in words.

## Routes

| Route | Wireframe | Query the integration reads |
|-------|-----------|-----------------------------|
| `/` | Homepage | none |
| `/collections/all`, `/collections/skin`, `/collections/skin-hydration` … | PLP | `c` (handle), `f` (extra filter, e.g. `concern:Dryness;skin:Dry`) |
| `/products/:handle` | PDP | `p` |
| `/cart` | Cart page | none |
| (drawer) | Cart drawer (component built from wireframe 05) | none |
| `/pages/contact`, `/pages/faq`, `/pages/about`, `/pages/our-story` | Contact, FAQ, About, Story | none |
| `/policies/shipping-policy`, `refund-policy`, `privacy-policy`, `terms-of-service` | Policy pages | none |
| `/blogs/journal` | Blog listing | none |
| `/blogs/journal/tagged/:tag` | Blog listing, filtered | `t` |
| `/blogs/journal/:handle` | Article | `a` |
| `/404` and any unknown handle | 404 | none |
| `/search`, `/account`, `/checkout`, `/wishlist` | **No page** | notice, see missing-pages-and-interactions.md |

## Placeholder link vocabulary found in the wireframes → destination

| Wireframe href (count across pages) | Meaning | Destination |
|-------------------------------------|---------|-------------|
| `#collection` (144) | Top-level menu: Skin, Makeup, Hair, Body | `/collections/<group>` (all products if the text is not a group) |
| `#collection-<handle>` (54 distinct) | Mega menu and footer sub-collections | `/collections/<handle>` |
| `#top` (50) | Logo, Home crumb, back to top | `/` for the logo and Home; real jump for back to top |
| `#search` (48) | Header search | search overlay |
| `#shop` (23) | Continue shopping, empty-state chips, Shop now | last visited collection, or the named collection, or all |
| `#article` (21) | Article cards and titles | `/blogs/journal/<handle>` from the card title |
| `#pdp` (17) | Product cards, quick view details, cart line names | `/products/<handle>` from the card title |
| `#cart` (17) and `#bag` | Header cart, View bag | drawer (page: Cart page; inside a drawer: `/cart`) |
| `#account` (16) | Account icon | notice |
| `#cat` (16) | Sub-collection links, related products, PDP breadcrumb | collection by text, or product in "Related products" |
| `#help`, `#contact`, `#s-contact` | Support, contact links | `/pages/contact` |
| `#faq`, `#about`, `#story`, `#shipping`, `#returns`, `#privacy`, `#terms`, `#policy`, `#policies` | Cross links | the matching page or policy |
| `#tag` (8), `#blog` (5), `#prev`, `#next` | Journal navigation | tagged list, journal, neighbouring article |
| `#p0`…`#p3` | Blog pagination | notice (one sample page) |
| `#s06`, `#s07` | Homepage section anchors | `#s07` and hero "Shop the edit" keep scrolling to their section; product names, "See matching products" and "Shop the products" go to products or the PLP |
| `#s16` | Logo list | inert (placeholder logos have no destination) |
| `#` (74, bare) | Category tiles, concern tiles, routine steps, product names, promo banner | by section and text: category → collection; concern → filtered PLP; routine step → type filter; product name → PDP; "Shop gift sets" → `body-gift-sets` |
| `#main`, `#results`, `#product`, `#reviews`, `#s-*`, `#g-*` | Real in-page anchors | untouched |
| `../NN-…/file.html` (footer, 16 each) | Already real links | untouched |
| `#mail`, `#tel` | Placeholder contact details | notice |

## Journeys supported

Homepage → PLP → PDP → Cart → Checkout notice · Homepage → Category → Collection → PLP → PDP · Homepage → Search → PDP → Cart · Blog → Article → Next article → Tag list · PDP → Related → PDP · Cart → Continue shopping → PLP · Cart quantity, remove, undo. **Blocked:** Article → Related products → PDP (no such section).
