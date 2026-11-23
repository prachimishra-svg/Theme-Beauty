# NUDGE Beauty: Homepage component inventory

Live registry of the component library. It lists only files that exist. Companion: `COMPONENT-ANALYSIS.md` (project analysis, decisions, verification log).

**How components work here** (static HTML + Tailwind + a PowerShell build, no JS framework):
- A component is `partials/components/<group>/<name>.html`, included with `@@PARTIAL components/<group>/<name> key=value key="a value"@@` from a page source or another component. Components nest.
- Tokens: `{{arg}}` `{{slug:arg}}` `{{lower:arg}}` `{{if arg}}…{{/if}}` `{{each list}}…{{item}}{{href}}{{/each}}` (list items separated by `|`, optional `label::href` pairs). A missing argument fails the build.
- Parents: Homepage section parents are `partials/components/homepage/<section>.html`; the shared Announcement Bar, Header and Footer parents stay at `partials/annbar.html`, `partials/header.html`, `partials/footer.html`. `homepage.src.html` is now one include line per section for sections 03-20 (`@@PARTIAL components/homepage/<section>@@`); sections 01 and 02 keep their review-annotation wrapper around the shared `annbar` and `header` partials.
- Groups: `common/` (independent, shared), `layout/` (announcement bar and footer pieces), `header/` (header, mega menu, cart), `homepage/` (section parents and their nested pieces). `product/` is not created: see decision D2.
- Styling uses only the existing Design Variables through the Tailwind theme and the shared classes. No tokens added. Buttons: the Homepage **Editorial Button** is the approved `.hp-btn` (decision D1); PLP, PDP and Cart keep the Design System `.btn`.
- In the Shopify theme: each component file becomes a Liquid snippet, each section parent a section.
- 79 component files in total (common 9, header 17, homepage 46, layout 7).

**Verification per section:** rebuild all 16 pages, then `tools/check-equivalence.ps1` (16 of 16 pages must equal the stored pre-componentisation baseline, ignoring only whitespace, class-token order, `<use/>` vs `<use></use>` and a redundant `xlink:href`), then the Homepage self-test at 1440/1024/768/390/320. Final run: self-tests on all 16 pages at 8 widths (128/128), mega-menu interaction test on all pages (see Analysis).

Status: **Done** = built, integrated and verified. **Not in wireframe** = named in the brief but absent from the approved page, not created.

---

## Independent / shared components (`components/common/`)

| Component | File | Call sites | Config |
|---|---|---|---|
| Icon | `common/icon` | 30+ | `name`, `class` |
| Section Heading (h2 + gold rule, optional lead) | `common/section-heading` | 6 | `title`, `lead` |
| Editorial Button (link, `.hp-btn`) | `common/button-editorial` | 6 | `class`, `href`, `c`, `label`, `arrow` |
| Editorial Button (button element) | `common/button-editorial-btn` | 2 | `class`, `id`, `label` |
| Editorial Button (submit, with arrow) | `common/button-editorial-submit` | 1 | `class`, `label` |
| Chip (editorial, selectable) | `common/chip-editorial` | 5 | `on`, `label` |
| Chip Tag (static) | `common/chip-tag` | 4 | `label` |
| Circle Icon Button | `common/icon-button-circle` | 2 | `hook`, `label`, `icon`, `disabled` |
| Scroller Controls (prev/next) | `common/scroller-controls` | 2 | `hook`, `prev`, `next`, `end` |

## 01. Announcement Bar — Done
Parent `partials/annbar.html`. Nested: `layout/announcement-arrow` (×2: `id`, `label`, `icon`), `layout/announcement-dots`, Icon. The message text is a regular element. Close button: **Not in wireframe**.

## 02. Header — Done
Parent `partials/header.html` (build args `CART`, `NAV`, `EXTRA`).

| Component | File | Config |
|---|---|---|
| Menu Button (mobile trigger) | `header/menu-button` | — |
| Logo | `header/logo` | — |
| Search Button (×3 uses) | `header/search-button` | `class`, `label`, `text`, `role` |
| Nav Close | `header/nav-close` | — |
| Navigation Item (×4) | `header/nav-item` | `key`, `name`, `current` |
| Mega Menu | `header/mega-menu` | `key`, `name` |
| Mega content configurations | `header/menus/{skin,makeup,hair,body}` | column + card lists |
| Menu Column (×8) | `header/mega-column` | `key`, `title`, `links` |
| Featured Cards pair (×4) / Card (×8) | `header/mega-cards`, `header/mega-card` | `key`, `first`, `second` / `title`, `tone` |
| Market Selector | `header/market-selector` | — |
| Account Button | `header/account-button` | — |
| **Cart Button** | `header/cart-button` + `header/cart-button-content` | `link` \| `page` \| `drawer` (was inline in `build.ps1`) |

Mobile Side Drawer is the `#nav` container in the parent; behaviour is `nav.js` plus each page's open/close script. Wishlist Button: **Not in wireframe**.

## 03. Hero Banner — Done
Parent `homepage/hero-banner`. Nested: `hero-media`, `hero-content` (uses Editorial Button ×2), `hero-featured-product`. Slider controls and pagination: **Not in wireframe** (the hero is one campaign image, no carousel).

## 04. Benefits / USP Row — Done
Parent `homepage/usp-row`. Nested: `usp-item` ×4 (`icon`, `title`, `text`).

## 05. Shop by Category — Done
Parent `homepage/category-section`. Nested: Section Heading, `category-card` ×4 (`tile`, `img`, `ratio`, `photo`, `dim`, `title`, `sub`, `link`).

## 06. Featured Collection — Done
Parent `homepage/featured-collection`. Nested: Section Heading, `collection-tabs` → `collection-tab` ×3 (`on`, `selected`, `set`, `label`), `product-card` ×4 (`tone`, `photo`, `badge`, `bstyle`, `title`, `size`, `attr`, `rating`, `swhide`, `price`, `was`), Editorial Button. This card is the **Homepage** product card, kept separate from the PLP card (decision D2).

## 07. Shop by Concern / Routine — Done
Parent `homepage/concern-section`. Nested: Section Heading (with lead), `group-title` ×2, `concern-card` ×6 (`tone`, `name`), `routine-step` ×4 (`n`, `label`).

## 08. Guided Finder / Quiz — Done
Parent `homepage/finder-section`. Nested: `finder-card` (stepper, question, Chip Editorial ×5, Editorial Button element ×2, result with Editorial Button). Behaviour stays in the page script.

## 09. Shop the Look — Done
Parent `homepage/look-section`. Nested: `look-pin` ×3 (`n`, `top`, `left`, `tip`), `look-row` ×3 (`n`, `tone`, `name`, `price`).

## 10. Ingredient Spotlight — Done
Parent `homepage/ingredient-section`. Nested: Section Heading (with lead), `ingredient-card` ×4 (`i`, `tone`, `desc`), Chip Tag ×4.

## 11. How to Use / Routine — Done
Parent `homepage/ritual-section`. Nested: `ritual-controls` (count + Circle Icon Button ×2), `ritual-step` ×4 (`n`, `num`, `name`, `desc`, `product`).

## 12. Video — Done
Parent `homepage/video-section`. Nested: `video-poster` (poster, play, duration), `video-copy` (Editorial Button).

## 13. Before & After — Done
Parent `homepage/compare-section`. Nested: `compare-layer` ×2 (`img`, `title`, `desc`, `tag`), handle icons via Icon. The slider is a native range input; behaviour in the page script.

## 14. Testimonials — Done
Parent `homepage/testimonials-section`. Nested: Section Heading, Scroller Controls, `review-card` ×6 (`quote`, `name`, `product`) → `review-stars` → Icon ×5.

## 15. Customer Photo Gallery — Done
Parent `homepage/gallery-section`. Nested: Section Heading (with lead), `gallery-tile` ×6 (`i`, `tone`, `extra`).

## 16. Logo List — Done
Parent `homepage/logo-section`. Nested: Scroller Controls (shared with Testimonials), `logo-item` ×8 (`aria`, `lbl`, `tag`).

## 17. Promotional Banner — Done
Parent `homepage/promo-banner`. Nested: `promo-media`, `promo-copy` (Editorial Button).

## 18. Custom Liquid — Done
Parent `homepage/custom-liquid-section` (single merchant slot; no nested components by design).

## 19. Newsletter — Done
Parent `homepage/newsletter-section`. Nested: `newsletter-field`, Editorial Button (submit), `newsletter-perk` ×3. Native form; no app.

## 20. Footer — Done
Parent `partials/footer.html`, wrapped on the Homepage by `homepage/footer-section`. Nested: `layout/footer-brand` (logo, line, `layout/social-link` ×3), `layout/footer-column` ×4 (`title`, `links` as `label::href` pairs), `layout/footer-payments` (`methods`), `layout/back-to-top`, Icon. Footer is shared by all 16 pages.

---

## Not extracted (deliberately)
Static text, decorative frames, review annotations (`.ann`), and one-off layout wrappers stay regular HTML inside their parent. Components that exist only once (hero media, video poster, compare layers) are nested components for manageability, not for reuse.
