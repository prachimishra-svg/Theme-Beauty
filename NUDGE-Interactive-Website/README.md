# NUDGE Beauty: interactive website

One folder. Everything the website needs is inside it.

## Open it
1. If you received a .zip, **extract it fully first** (do not open files from inside the zip preview).
2. Open **index.html** (double-click, or drag it into Chrome, Edge, Firefox or Safari) and click **Open the website**.
   You can also open `pages/home.html` directly.
3. No internet, server, Node or install is needed. Keep the folder together: move or share the whole `NUDGE-Interactive-Website` folder.

## What works
Header and footer links, mega menu, collections with filters, product pages, add to bag, cart drawer and cart page (quantity, remove, undo), search, the journal with article pages and tags, policy and help pages, back, forward and refresh. The bag and recent searches are remembered in the browser.

## What is not real
Checkout, payment, accounts, wishlist, newsletter and contact form delivery, product reviews, real stock. Makeup, hair and body collections have no sample products. Products and prices are sample data. Details: `docs/missing-features-and-dependencies.md`.

## Tips
* Small pill at the bottom left of every page: **Load sample cart**, **Reset prototype data**, **View this page as plain wireframe**.
* Add `?ix=0` to a page address to see that page as the original wireframe.
* If a page looks unstyled or buttons do nothing, the folder was split or the zip was not fully extracted.
* Chrome and Edge give the best result.

## Folder map
* `index.html` start page
* `pages/` the 16 pages: home, collection, product, cart, cart-drawer, contact, faq, about, our-story, shipping-policy, returns-policy, privacy-policy, terms, blog, article, 404
* `assets/css`, `assets/js`, `assets/fonts` styles, scripts and fonts
* `assets/js/interactive/` the code that connects the pages (links, cart, search)
* `docs/` limits and Shopify notes