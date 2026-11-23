# NUDGE Beauty: component analysis (Phase 1) and open decisions

Companion to `COMPONENT-INVENTORY.md`. Read-only findings about the existing project, written before any section beyond Announcement Bar and Header was touched.

## 1. Project architecture (discovered, not assumed)

- Static HTML wireframes, **no JS framework**. Styling is Tailwind (Play script, offline) mapped to the Design Variables; production plan is the Tailwind CLI and Shopify Liquid.
- `03-Wireframes/00-Shared-Tailwind-Foundation/`: `tailwind.config.js` (theme = Design Variables), `partials/` (shared markup and CSS), `src/<page>.src.html` (page sources), `build.ps1` (assembles 16 pages into `01`–`16` folders), `nav.js`, `currency.js`, `cart-render.js`, `tools/` (self-test, screenshots, pixel diff, interaction tests).
- Pages: 01 Homepage, 02 PLP, 03 PDP, 04 Cart page, 05 Cart drawer, 06–13 support and policy pages, 14 Blog listing, 15 Blog article, 16 404.

## 2. Design System and Variables

- Tokens: `02-Design-Variables/Styles/variables.css` (single source). Mapped in `tailwind.config.js`; no new values defined there.
- Design System: `01-Design-System/` (CSS in `Styles/`, Figma specification in `Figma-Specification/components.md`: Button, Icon Button, Input Field, Choice, Chip, Swatch, Badge, Message, Quantity Selector, Rating, Accordion Item, Breadcrumb, Pagination, Drawer, Product Card).
- Shared component classes for Tailwind pages: `partials/components.tw.css` (`.btn`, `.chip`, `.badge`, `.price`, `.rating`, `.accordion`, `.field`, `.input`, `.qty`, `.drawer`, `.pagination`, …).

## 3. Before this work

Only three shared pieces existed as partials: announcement bar, header, footer (plus sprite, head, review CSS). Every Homepage section was hand-written markup on one line per section in `src/homepage.src.html` (1–10 KB each), with its own page-local classes.

## 4. What was built

- **Engine** in `build.ps1`: nested includes, arguments, lists (`label::href` pairs), conditionals, slug/lowercase tokens; `Links()` resolves `@@LINK:page@@` before footer arguments are parsed. A missing argument fails the build.
- **79 component files** under `partials/components/` (common 9, header 17, homepage 46, layout 7). All 20 Homepage sections are parents with nested components; `homepage.src.html` is one include line per section for sections 03-20; sections 01 and 02 keep their review-annotation wrapper around the shared partials `annbar` and `header`. Announcement Bar, Header (with the mega menu and Cart Button) and Footer are shared by all 16 pages.
- **Cart Button** moved out of `build.ps1` into `header/cart-button` (variants `link`, `page`, `drawer`).
- Tools added: `tools/check-equivalence.ps1` + `tools/baseline/` (the 16 pages as they were before componentisation), `tools/test-mega.ps1`.

## 5. Decisions (approved by the user)

- **D1** Homepage keeps `.hp-btn` as the approved Editorial Button (components `button-editorial`, `-btn`, `-submit`, plus `chip-editorial`); PLP, PDP and Cart keep the Design System `.btn`.
- **D2** Homepage and PLP Product Cards stay separate; only genuinely common pieces are shared (Icon). No `product/` folder yet.
- **D3** Announcement Close, Wishlist Button and Hero slider controls are not in the wireframes, so were not added.

## 6. Verification log (final run)

- Equivalence: 16 of 16 pages equal the baseline after every section. Differences ignored by the check are render-neutral only: whitespace, class-token order, `<use/>` vs `<use></use>`, and a redundant legacy `xlink:href` next to `href` (the icon component emits `href` only).
- Self-tests: all 16 pages at 1920, 1440, 1280, 1024, 768, 430, 390, 320: 128 of 128 pass (the Homepage self-test was also run after every section at 1440, 1024, 768, 390, 320).
- Mega-menu interaction test: all 16 pages at 1920, 1440, 1024, 768, 390, 320 clean; the Cart drawer host page needed the test to close its on-load modal first and a fresh width measurement, after which it is clean at all 8 widths.
- Currency test on the Homepage at 1440: passes.
- Not tested: real mouse/touch/screen-reader behaviour in a live browser (tests dispatch events in headless Chrome); Homepage JS behaviour (tabs, finder, ritual scroller, compare slider) is covered only by the existing self-test and by the DOM being identical.

## 7. Notes and limits

- Removing the redundant `xlink:href` on `<use>` is the only markup difference from the original Homepage source; `href` takes precedence in current browsers.
- Components keep hand-written wireframe copy as arguments, so merchant text still lives in the call sites; in Liquid these become section/block settings.
- Component arguments and list items can carry `"`, `@` and `|` through the escapes `&quot;`, `&#64;` and `&#124;` (decoded when used; covered by `tools/test-engine.ps1`). Existing call sites use none, so output is unchanged. In the Shopify theme these limits do not exist (typed snippet parameters, arrays, blocks); see `06-Shopify-Theme/LIQUID-CONVERSION-PLAN.md`.
## 8. Folder structure (as built)

```
partials/
  header.html, annbar.html, footer.html      parents (unchanged location)
  components/
    common/      icon, section-heading, button-editorial(-btn/-submit), chip-editorial, chip-tag, icon-button-circle, scroller-controls
    layout/      announcement-arrow, announcement-dots, footer-brand, footer-column, footer-payments, social-link, back-to-top
    header/      logo, menu-button, nav-close, nav-item, search-button, account-button,
                 market-selector, cart-button(+content), mega-menu, mega-column, mega-cards, mega-card, menus/{skin,makeup,hair,body}
    homepage/    all 20 section parents and their nested components (46 files)
    product/     (not created; see D2)
```
