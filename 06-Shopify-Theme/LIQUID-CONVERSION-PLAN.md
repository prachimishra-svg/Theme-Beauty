# NUDGE Beauty: Shopify Liquid conversion plan

Status: decisions D1-D3 approved, D4 declined (no store push). **M0 to M5 done and verified, M6 verification done (see README.md for results and the pending manual checks).**

## 1. Findings from the analysis (read this first)

1. **There is no Shopify theme in the project yet.** No `.liquid` files, no `layout/`, `templates/`, `sections/`, `snippets/`, `config/settings_schema.json`, `locales/`, no `shopify.theme.toml`. What exists is the wireframe build (HTML + Tailwind + PowerShell). The brief assumed an existing theme; this phase therefore **creates the theme scaffold** in a new folder `06-Shopify-Theme/` (numbered like the other top-level folders). Existing folders are not touched.
2. **Reusable inputs that already exist:** tokens `02-Design-Variables/Styles/variables.css` (generated from `Tokens/*.json`), Design System CSS `01-Design-System/Styles/{foundation,base,components}.css`, three self-hosted fonts and the icon set + `sprite.svg` in `05-Assets/`, the 79 component files, and the wireframe behaviour scripts: `nav.js` (mega menu), `01-Design-System/Scripts/drawer.js`, `chip-row.js`, `load-more.js`, `cart-render.js`, `currency.js`, plus about 10 KB of Homepage page script (tabs, finder quiz, ritual scroller, scrollers, compare slider, look pins, footer accordion).
3. **Tooling available on this machine:** Windows PowerShell 5.1 and Google Chrome (headless, DevTools protocol). **Not available:** Node/npm, Shopify CLI, Theme Check, Ruby, Python (only the Microsoft Store stub), git, Tailwind CLI. Consequences: no `shopify theme check`, no `shopify theme dev`, no Tailwind CLI compile, no off-the-shelf Liquid engine. Section 8 explains how each validation requirement is still met, and which cannot be met without a store.
4. **Tailwind in production.** The wireframes use the Tailwind Play script (compiles in the browser; wireframe only, not shippable). A theme needs compiled CSS in `assets/`. Interim, available now: extract the CSS the Play script generates from the rendered pages into `assets/theme.css` (identical to what the approved pages use). Final: run the Tailwind CLI with the existing `tailwind.config.js` once Node or the standalone Tailwind binary is available. See decision D2.
5. **The wireframe-only pieces that must not ship:** review annotations (`.ann`), `data-c` edit hooks, review bar and width preview, the in-page self-test, the Tailwind Play script, `currency.js` sample rates (replaced by Shopify's native localization form), `cart-render.js` sample cart (replaced by the real `cart` object and `/cart.js`).

## 2. Target theme structure

```
06-Shopify-Theme/
  layout/theme.liquid                  <head> (CSS, fonts preload, content_for_header), skip link, section groups, cart drawer
  templates/index.json                 the 20 Homepage sections in order (default settings = wireframe copy)
  sections/                            header-group.json, footer-group.json + one .liquid per section (table 3)
  snippets/                            reusable nested components (table 3)
  assets/                              theme.css, variables.css (generated copy), fonts, sprite, nav.js, drawer.js, homepage.js, cart.js
  config/settings_schema.json          theme settings (table 5), settings_data.json
  locales/en.default.json, en.default.schema.json
```
Out of scope this phase: collection, product, cart, search, blog, article, page, 404, password, gift card templates (their wireframes stay as wireframes); they will reuse the same header, footer, announcement bar, icon, button, price, chip snippets later. A minimal `templates/index.json` only.

## 3. Component mapping (79 source files)

Rule: **section** = an independently placeable and configurable page section. **Snippet** = a reusable nested component. **Block** = a repeated, merchant-editable item inside a section. **Inline** = a one-off structure that stays in its parent.

### Shared (common/)
| Wireframe component | Becomes | Notes |
|---|---|---|
| `common/icon` | snippet `icon` (`name`, `class`) | sprite rendered once in layout (`icon-sprite`) |
| `common/section-heading` | snippet `section-heading` (`title`, `lead`) | |
| `button-editorial`, `-btn`, `-submit` (3 files) | **one** snippet `button-editorial` (`element`: link / button / submit, `label`, `url`, `class`, `arrow`) | Liquid conditionals replace the three files; names preserved |
| `chip-editorial`, `chip-tag` | snippets `chip-editorial`, `chip-tag` | |
| `icon-button-circle` | snippet | |
| `scroller-controls` | snippet | used by Testimonials and Logo List |

### Header, Announcement Bar, Footer (shared by every page; section groups)
| Wireframe component | Becomes | Settings / blocks |
|---|---|---|
| Announcement Bar parent + `announcement-arrow`, `-dots` | **section** `announcement-bar` (header group) + 2 snippets | blocks `message` (text, link); autoplay toggle |
| Header parent | **section** `header` (header group) | settings: menu, logo override, show search/account/country selector, sticky |
| `logo`, `menu-button`, `nav-close`, `search-button` ×3, `account-button`, `cart-button` + `cart-button-content` | snippets `header-logo`, `header-menu-button`, `header-nav-close`, `header-search`, `header-account`, `cart-button` | cart count from `cart.item_count` (bubble updated by cart.js) |
| `nav-item`, `mega-menu`, `mega-column` | snippets `header-nav-item`, `header-mega-menu`, `header-mega-column` | **data comes from the native menu**: level 1 = nav item, level 2 = column heading, level 3 = links. This removes the four `menus/*` config files |
| `mega-cards`, `mega-card` | snippet `header-mega-card` + block `mega_card` (menu item handle, image, title, link) | placeholder when no image |
| `market-selector` | snippet `header-localization` using Shopify's native `{% form 'localization' %}` | replaces `currency.js` in the theme; the wireframe keeps `currency.js` |
| Mobile side drawer (`#nav`) | stays in `header` section | |
| Footer parent + `footer-brand`, `social-link`, `footer-column`, `footer-payments`, `back-to-top` | **section** `footer` (footer group) + snippets `social-link`, `footer-column`, `back-to-top` | blocks `link_list` (heading + menu), brand text, newsletter off (Homepage has its own); socials from theme settings; payments from `shop.enabled_payment_types` |

### Homepage sections (20)
| # | Section (Liquid file) | Nested -> becomes | Blocks / key settings |
|---|---|---|---|
| 01 | `announcement-bar` | see above | |
| 02 | `header` | see above | |
| 03 | `hero-banner` | `hero-media`, `hero-content`, `hero-featured-product` -> inline + snippet `media-placeholder` | image/video-less: image_picker (desktop, mobile), label, heading, text, 2 buttons (label + link), featured product picker, overlay strength, height |
| 04 | `usp-row` | `usp-item` -> block `usp_item` | icon select (from sprite), title, text |
| 05 | `category-grid` | `category-card` -> block `category_card` | collection or link, image, title, subtitle, link text, tone |
| 06 | `featured-collection` | `collection-tabs`/`collection-tab` -> blocks `tab` (collection picker, label); `product-card` -> snippet `product-card-home` (`product`) | products per tab, button label/link |
| 07 | `concern-routine` | `concern-card` -> block `concern`; `routine-step` -> block `routine_step`; `group-title` -> settings | |
| 08 | `guided-finder` | `finder-card` -> blocks `question` (text) + `option` (label, result collection) | native JS only, result links to a collection |
| 09 | `shop-the-look` | `look-pin` -> block `pin` (product, x%, y%); `look-row` -> rendered from pins | image |
| 10 | `ingredient-spotlight` | `ingredient-card` -> block `ingredient`; `chip-tag` -> block `free_from` | |
| 11 | `ritual-steps` | `ritual-step` -> block `step`; `ritual-controls` -> snippet | |
| 12 | `video-section` | `video-poster`, `video-copy` | `video_url` (YouTube/Vimeo) + cover image; loads on tap |
| 13 | `before-after` | `compare-layer` ×2 | two image_pickers |
| 14 | `testimonials` | `review-card` -> block `review`; `review-stars` -> snippet | typed by the merchant, no review app |
| 15 | `customer-gallery` | `gallery-tile` -> block `photo` | |
| 16 | `logo-list` | `logo-item` -> block `logo` (image, label, tag, link) | |
| 17 | `promo-banner` | `promo-media`, `promo-copy` | image, text, button |
| 18 | `custom-liquid` | single slot | native `custom_liquid` setting |
| 19 | `newsletter` | `newsletter-field`, `newsletter-perk` -> block `perk` | native `{% form 'customer' %}` with `contact[tags]=newsletter`; no app |
| 20 | `footer` | see above | |

Product Card: the Homepage card stays its own snippet (decision D2 from the previous phase); no `product/` shared card.

### Cart Drawer (required for interaction testing)
The Cart Drawer wireframe becomes `snippets/cart-drawer.liquid` rendered in the layout, `assets/cart.js` (fetch `/cart.js`, `/cart/change.js`, `/cart/add.js` and the Section Rendering API), `assets/drawer.js` (existing, native `<dialog>`). The Cart page stays a wireframe this phase.

## 4. Argument limitations (`@`, `"`, `|`)

- **In Liquid they do not exist.** Snippet parameters are typed values (`{% render 'x', label: "a | b", html: block.settings.text %}`); strings may use either quote; lists are arrays or blocks, never `|`-joined text. The theme is a separate artifact, so nothing breaks.
- **Wireframe build engine (kept working, unchanged behaviour by default):** add entity escapes decoded inside component arguments and list items: `&quot;`, `&#64;`, `&#124;`. Existing call sites contain none of these, so output stays identical (proved by `check-equivalence.ps1`). Done in milestone M0.

## 5. Settings model

Theme settings (`config/settings_schema.json`): Branding (logo image, logo text, favicon), Social links (Instagram, Facebook, YouTube URLs), Localization (show country/currency selector), Cart (type: drawer or page), Announcement (autoplay). **No colour, font-size or spacing settings**: the Design Variables stay the single source (`variables.css`); the schema shows an info note saying so. Section settings carry content only (text, images, links, collections, products, toggles, select options such as tone and alignment).

Defaults: every text/link default equals the wireframe copy, so a fresh theme renders the approved Homepage. Images default to blank and render the same **labelled placeholder** as the wireframe (snippet `media-placeholder`); once an image is chosen it renders a responsive `<img>` (`image_url`, `srcset`, width/height, lazy loading except the hero).

## 6. Behaviour (JavaScript)

Wireframe scripts are ported to assets and made Theme Editor safe: initialise on load and on `shopify:section:load`, clean up on `shopify:section:unload`; no inline `onclick`; one file per concern (`nav.js` mega menu and drawer, `drawer.js`, `homepage.js` for tabs / finder / ritual / scrollers / compare / look pins / footer accordion, `cart.js`). Selectors and class hooks are unchanged so the CSS keeps working.

## 7. Milestones (each ends with its own validation; nothing is marked done unproven)

| M | Scope | Exit criteria |
|---|---|---|
| M0 | Foundations: scaffold, `layout/theme.liquid`, `settings_schema`, `locales`, CSS pipeline (interim extraction), icon sprite, engine entity escapes, static linter, Liquid renderer harness | linter passes, an empty page renders, wireframe equivalence still 16/16 |
| M1 | Snippets for common/ + `announcement-bar`, `header` (incl. mega menu, localization), `footer` section groups | rendered header/footer equal the wireframe DOM at default settings; mega-menu interaction tests |
| M2 | Hero, USP, Category, Featured Collection (+ `product-card-home`) | rendered DOM equals baseline for these sections |
| M3 | Concern, Finder, Look, Ingredient, Ritual | same |
| M4 | Video, Before/After, Testimonials, Gallery, Logo list, Promo, Custom Liquid, Newsletter | same |
| M5 | Cart drawer + `cart.js` | drawer interaction tests with real `cart` data shape |
| M6 | Full Homepage assembly, `templates/index.json`, final validation, docs | Homepage rendered at defaults equals the baseline Homepage; all 16 wireframe pages still equal the baseline; accessibility and live-browser interaction pass |

## 8. Validation plan, and what cannot be proven here

| Requirement | How | Limit |
|---|---|---|
| Liquid syntax | (a) own static linter in PowerShell: balanced `if/for/case/unless/capture/form/paginate/comment/raw`, every `render`/`section` target exists, no stray `@@`/`{{ }}` mismatches, snippet params used but undefined; (b) a real Liquid engine (**LiquidJS**, vendored into `06-Shopify-Theme/tools/vendor/`) run in headless Chrome with Shopify-style stubs for `image_url`, `money`, `asset_url`, `t` and the `schema` tag | Not Shopify's own parser. Differences are possible (strict filters, `{% liquid %}` edge cases). Final proof needs Shopify's Theme Check or an upload to a store |
| Section schemas and settings | linter checks every `{% schema %}`: valid JSON, unique setting ids, valid `type`, `default` on select/range/radio, `presets`, `max_blocks`, block types used in the markup exist, `{{ block.shopify_attributes }}` on every block root, locale keys exist | |
| Theme Editor compatibility | static checks above + `shopify:section:load/unload` handlers + templates using only JSON sections | **Cannot be proven without a store.** Offer: push to a development store with the connected Shopify tools (outward-facing, only with your OK) |
| Responsive | wireframe self-tests + rendered-DOM equality + screenshots at 1920 to 320 | |
| Mega menu and cart drawer | existing `test-mega.ps1` against the rendered theme; new cart drawer tests with `cart`-shaped data | |
| 16-page baseline | `check-equivalence.ps1` after every milestone | |
| Real mouse, touch, accessibility | a Chrome DevTools Protocol driver (PowerShell): **trusted** `Input.dispatchMouseEvent` / `dispatchTouchEvent` / `dispatchKeyEvent` (hover, click, tap, Tab order, Escape, arrow keys), hit-testing, `Accessibility.getFullAXTree` (roles, names, states, focus order), contrast and target-size checks; optionally the open-source axe-core engine (vendored) | This is real browser input but **not** a physical device and **not** a screen reader (NVDA/JAWS/VoiceOver). Those need manual testing; I will list exactly what to test by hand |

## 9. Decisions needed before M0

- **D1. Theme location:** new folder `06-Shopify-Theme/` (recommended), since no theme exists. OK?
- **D2. CSS pipeline:** interim extraction from the Play script now (recommended, no downloads), then Tailwind CLI later, or install Node / the standalone Tailwind binary first?
- **D3. Third-party validation code:** may I download **LiquidJS** (and optionally **axe-core**), both open source single JS files, into `06-Shopify-Theme/tools/vendor/` and run them only in headless Chrome? Without LiquidJS I cannot render or verify any Liquid here.
- **D4. Development store:** do you have one and want the theme pushed there for the real Theme Editor check? Not done without your explicit OK.
