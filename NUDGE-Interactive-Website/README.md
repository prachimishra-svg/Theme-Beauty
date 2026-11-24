# NUDGE Beauty: interactive website

One folder. Everything the website needs is inside it.

## Open it
1. If you received a .zip, **extract it fully first** (do not open files from inside the zip preview).
2. Open **index.html** (double-click, or drag it into Chrome, Edge, Firefox or Safari): it opens the homepage directly.
   You can also open `pages/home.html` directly.
3. No internet, server, Node or install is needed. Keep the folder together: move or share the whole `06-Interactive-Wireframes` folder.

## What works
Header and footer links, mega menu, collections with filters, product pages, add to bag, cart drawer and cart page (quantity, remove, undo), search, the journal with article pages and tags, policy and help pages, back, forward and refresh. The bag and recent searches are remembered in the browser.

## What is not real
Checkout, payment, accounts, wishlist, newsletter and contact form delivery, product reviews, real stock. Makeup, hair and body collections have no sample products. Products and prices are sample data. Details: `docs/missing-features-and-dependencies.md`.

## Tips
* Small pill at the bottom left of every page: **Load sample cart**, **Reset prototype data**, **View this page as plain wireframe**.
* Add `?ix=0` to a page address to see that page as the original wireframe.
* If a page looks unstyled or buttons do nothing, the folder was split or the zip was not fully extracted.
* Chrome and Edge give the best result.

## Homepage hero slider (add more pictures)
The big picture at the top of the Homepage is a slider: several pictures, small dots underneath, and it changes by itself every 4 seconds (it pauses while the mouse is over it, and stays still for people who ask their computer for reduced motion).
1. Save your pictures in `assets/images/hero/` and name them in the order they should appear: `hero-1.jpg`, `hero-2.jpg`, `hero-3.jpg` ... (.jpg, .png, .webp or .avif).
2. Double-click `assets/images/hero/update-slides.cmd`. It rewrites `slides.js`, the list the page reads.
3. Reload the Homepage. One picture shows no dots; two or more show the dots.
Picture tips: wide, about 2880 x 1620, with the person or product in the RIGHT half (the headline sits on the left), under about 400 KB each. `thumb-product.jpg` in the same folder is the small bottle picture in the "Featured" card, not a slide.
If you publish the folder (Vercel, GitHub), include `slides.js` along with the pictures.

## Folder map
* `index.html` entry point: opens the homepage directly
* `pages/` the 16 pages: home, collection, product, cart, cart-drawer, contact, faq, about, our-story, shipping-policy, returns-policy, privacy-policy, terms, blog, article, 404
* `assets/css`, `assets/js`, `assets/fonts` styles, scripts and fonts
* `assets/js/interactive/` the code that connects the pages (links, cart, search)
* `docs/` limits and Shopify notes