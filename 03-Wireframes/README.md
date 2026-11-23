# NUDGE Beauty: wireframes

One responsive HTML file per page, built with Tailwind utilities mapped to the Design Variables. Open any file directly in a browser (no build step). Each page has a review bar with **Annotations** and **Width preview** (1920, 1440, 1280, 1024, 768, 430, 390, 320 px).

## Folder order = page order

Folders are numbered in storefront order, one folder per page. The number is the sequence; new pages are added by renumbering with the script, not by editing the files.

| No. | Folder | Page | Group |
|---|---|---|---|
| 00 | `00-Shared-Tailwind-Foundation` | Shared Tailwind config, partials, build script, cart code, test tools (not a page) | Shared |
| 01 | `01-NUDGE-Beauty-Homepage-Wireframe` | Homepage | Shopping flow |
| 02 | `02-NUDGE-Beauty-PLP-Wireframe` | Product listing (collection) | Shopping flow |
| 03 | `03-NUDGE-Beauty-PDP-Wireframe` | Product detail | Shopping flow |
| 04 | `04-NUDGE-Beauty-Cart-Wireframe` | Cart page | Shopping flow |
| 05 | `05-NUDGE-Beauty-Cart-Drawer-Wireframe` | Cart drawer | Shopping flow |
| 06 | `06-NUDGE-Beauty-Contact-Wireframe` | Contact us | Support |
| 07 | `07-NUDGE-Beauty-FAQ-Wireframe` | FAQ | Support |
| 08 | `08-NUDGE-Beauty-About-Wireframe` | About us | Brand |
| 09 | `09-NUDGE-Beauty-Story-Wireframe` | Our story | Brand |
| 10 | `10-NUDGE-Beauty-Shipping-Policy-Wireframe` | Shipping and delivery policy | Policies |
| 11 | `11-NUDGE-Beauty-Returns-Policy-Wireframe` | Returns and refund policy | Policies |
| 12 | `12-NUDGE-Beauty-Privacy-Policy-Wireframe` | Privacy policy | Policies |
| 13 | `13-NUDGE-Beauty-Terms-Wireframe` | Terms and conditions | Policies |
| 14 | `14-NUDGE-Beauty-Blog-Listing-Wireframe` | Journal (blog listing) | Journal |
| 15 | `15-NUDGE-Beauty-Blog-Article-Wireframe` | Journal article | Journal |
| 16 | `16-NUDGE-Beauty-404-Wireframe` | 404 page not found | System |

Not built yet (from the original page list): beauty guides, ingredient library, skin quiz, store locator, login, register, forgot password, search results, search with no results, wishlist, order tracking, password page.

## Rules every page follows

- Design System and Variables are linked, never copied: `../../01-Design-System` and `../../02-Design-Variables`. Neither folder is edited by this work.
- Shared sections (announcement bar, header, footer) come from `00-Shared-Tailwind-Foundation/partials`, so they are identical on every page. The homepage header is the one approved variation (transparent over the hero).
- Footer links to pages that exist are real relative links, written as `@@LINK:<page>@@` in `partials/footer.html` and resolved by `build.ps1` from the page list, so they stay correct if folders are renumbered. About column: About us, Our story, Journal, FAQ. Links without a page yet (Shop categories, Support) stay as `#` placeholders.
- Currency: the one existing header pill (`#market-btn`) opens a market and currency list; no second selector exists. `00-Shared-Tailwind-Foundation/currency.js` (loaded by every page) shows every price through one formatter. Sample prices in the files are base amounts written "$nn.nn"; other symbols come from `Intl.NumberFormat`, never from the page text, and the sample rates exist only for the wireframe. The live theme uses the native `localization` form (Shopify Markets) and `{{ price | money }}`. Review shortcuts: `?cur=INR|USD|GBP|EUR`, `?market=open`. Checkout and payment are not designed; the pages only show labelled slots for Shopify's own checkout buttons.
- Tablet footer (768 to 1279 px): narrow brand column and content-sized link columns, so no link wraps; equal columns from 1280 px.
- Placeholders only: labelled boxes, no photography. All policy and article text is bracketed sample content.
- Native Shopify features only (JSON templates, sections, blocks, snippets, native cart, search, forms). No app-dependent widgets.
- Breakpoints: 600, 768, 1024, 1280 (mobile-first). Content container is 1360 px with 40 px gutters from 1024 px; reading text is 640 px.

## Rebuilding

Sources live in `00-Shared-Tailwind-Foundation/src`. To rebuild every page after editing a shared partial or a source:

```
powershell -File 00-Shared-Tailwind-Foundation\build.ps1 -All
```

or one page: `build.ps1 -Page contact`. Test tools are in `00-Shared-Tailwind-Foundation/tools` (`run-selftest.ps1`, `pixel-diff.ps1`, `rect-probe.ps1`, `shot.ps1`).
