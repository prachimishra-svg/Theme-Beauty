# NUDGE Beauty: Shopify theme

Converted from the approved wireframe component library (`03-Wireframes/00-Shared-Tailwind-Foundation`). Plan and decisions: `LIQUID-CONVERSION-PLAN.md`. Design Variables, fonts, icons and the drawer script are **not** copied by hand: `tools/build-theme.ps1` regenerates them from `02-Design-Variables`, `05-Assets` and the Design System, so there is one source of truth. Nothing has been pushed to any Shopify store.

## What is in the theme (milestones M0 to M5 done; M6 verification done, see "Pending")
- **Layout, settings, locale:** `layout/theme.liquid`, `config/settings_schema.json` (branding, social links, cart type, country selector), `locales/en.default.json`. Colours, type, spacing and radius are deliberately not theme settings (the Design Variables stay the single source).
- **Section groups:** `announcement-bar`, `header` (mega menu from the native menu, country/currency selector from Shopify's localization form, cart button), `footer`.
- **Homepage sections (templates/index.json, 17 in page order):** `hero-banner`, `usp-row`, `category-grid`, `featured-collection` (tabs, Homepage product card), `concern-routine`, `guided-finder`, `shop-the-look`, `ingredient-spotlight`, `ritual-steps`, `video-section`, `before-after`, `testimonials`, `customer-gallery`, `logo-list`, `promo-banner`, `custom-liquid` (renders nothing to shoppers while empty), `newsletter` (Shopify's own customer form, no app).
- **Cart drawer:** `sections/cart-drawer.liquid` + `snippets/cart-line.liquid` + `assets/cart.js` (AJAX Cart API + Section Rendering API), used when Theme settings > Cart > Cart type is "Cart drawer".
- **Snippets (37):** the nested components (icon, section heading, buttons, chips, scroller controls, cards, header and footer parts ...). PLP, PDP and Cart *pages* are not part of this theme yet and stay wireframes; they will reuse the same header, footer, icon, button, chip and price pieces.
- **Scripts:** `theme.js` (drawer menu, announcement bar, footer accordion), `nav.js` (mega menu), `localization.js`, `homepage.js` (tabs, finder, ritual, slider, scrollers, newsletter, video), `cart.js`, `drawer.js` (Design System). All are delegated or re-initialised on `shopify:section:load`, so the Theme Editor can re-render a section.
- **CSS:** `variables.css` (generated), `theme.css` (INTERIM: the CSS the Tailwind Play script generates for the rendered pages; replace with a Tailwind CLI build when Node or the standalone binary is allowed), `theme-shopify.css` (hand-written wrapper rules).

## Tools (`tools/`, PowerShell + headless Chrome; no Node needed)
`build-theme.ps1` regenerate assets; `render-theme.ps1` LiquidJS renderer (`-LocalAssets -SettingsJson -CartState -StaticJson`); `compare-theme.ps1` equality with the wireframe (differences listed in its header); `theme-pixel-diff.ps1` pixel diff against the approved Homepage; `lint-theme.ps1`; `test-presets.ps1` (every section fresh from its preset and emptied); `test-homepage.ps1`, `test-cart.ps1` (mock Shopify cart API), `test-axe.ps1` (axe-core), `test-input.ps1` (trusted mouse/touch/keyboard input and the accessibility tree through the DevTools protocol), `probe.ps1`; fixtures: `make-sample-data.ps1`, `make-cart-fixtures.ps1`, `make-index-json.ps1` (regenerates `templates/index.json` with the wireframe copy). Vendored test libraries: `tools/vendor/` (LiquidJS 10.21.0, axe-core 4.10.2, hashes in VENDOR.md).

## Verification results (2026-11-17)
| Check | Result |
|---|---|
| Lint (own linter) | 0 errors, 0 warnings, 59 Liquid files |
| Element equality with the approved wireframe | 19 of 19 Homepage elements + the cart drawer in 5 states (multi, one, free, long, empty) |
| Pixel comparison, whole Homepage (about 12,000 px) | 0.01% to 0.02% of pixels differ at 1920, 1440, 1280, 1024, 768, 390 and 320 px |
| Theme Editor robustness | all 17 sections render with no errors when freshly added from their preset and when emptied |
| Behaviour (synthetic events) | Homepage 22 to 25 checks at 5 widths; mega menu/drawer 6 widths; cart drawer 23 checks at 2 widths |
| Real browser input and accessibility tree | 46 of 46: real hover, click, tap, Tab/Shift+Tab, Enter, Space, Escape, arrow keys; drawer focus trap and focus return; landmarks, one H1, accessible names, lists, no duplicate ids, no positive tabindex, touch targets |
| axe-core | 0 violations in default, mega-menu-open, mobile-drawer-open and cart-drawer-open states |
| Cart drawer pixels (real click opens it) | 0.00% of pixels differ from the approved drawer at 1440 and 390 px, Checkout lock icon included |
| Colour contrast of solid token pairs | 20 of 20 meet WCAG 2.2 AA |
| Wireframes (Homepage, PLP, PDP, Cart and the 12 other pages) | unchanged: 16 of 16 equal to their baseline; engine tests pass |

## Deliberate differences from the wireframe
Real store URLs; the mega menu's "Shop all" link uses the menu item's own URL; the announcement bar, finder and tabs keep their source data in hidden lists/templates; the country list is Shopify's localization form (prices come from Shopify, not the wireframe's sample rates); the finder's and newsletter's review notes, the Custom Liquid slot box and the focal-point guides are not shipped; the cart drawer reads the real cart (stock limits, undo and add-on use the AJAX API). Accessibility fixes made in the theme only: `role="search"` removed from a link, `role="group"` on the payment list, `role="region"` removed from two scrollable lists, footer column headings are not focusable controls on desktop (the wireframe has them as inert buttons), mega-menu panels no longer open on keyboard focus (ArrowDown or Space opens them, Escape closes and no longer re-opens). The complete list with reasons is at the top of `tools/compare-theme.ps1`.

## Pending: needs a person, a store or a decision
The full checklist with what is completed and what is not (NVDA, JAWS, VoiceOver, TalkBack, physical devices, colour contrast, store checks) is in **MANUAL-CHECKS.md**.

1. **Product metafields (not assumed; pending merchant confirmation, marked in snippets/product-card-home.liquid).** The Homepage product card reads `custom.size`, `custom.highlight`, `reviews.rating`, `reviews.rating_count` and the tag `badge:<text>`. These names are placeholders: the merchant's real configuration could not be checked because the Shopify connector needs re-authorisation in this session. Confirm or rename them in `snippets/product-card-home.liquid`.
2. **Theme Editor and a real store.** Not pushed (decision D4). Theme Check, real Shopify rendering, `/cart/change.js` responses and the Section Rendering API have only been tested against a local stand-in and a mock.
3. **Screen reader and devices.** NVDA, JAWS, VoiceOver, TalkBack and physical touch devices are not covered; the automated tests use real browser input and the accessibility tree, not assistive technology.
4. **Colour contrast on gradients and overlapped areas** (axe "needs review"): check by eye or with a contrast tool on the hero, placeholders and footer.
5. **Wireframe findings to decide:** the Checkout button in the wireframe uses an `icon-lock` that is not in the icon sprite (blank icon); the theme keeps the reference, add a lock icon to `05-Assets/Icons` to fix both.
6. **CSS pipeline:** replace the interim extracted `theme.css` with a Tailwind CLI build; until then re-run `tools/build-theme.ps1 -ExtraHtml <rendered page>` after adding markup with new classes (script-only classes go in `tools/js-classes.html`).
7. **Not converted yet:** PLP, PDP, Cart page, and the other 12 wireframe pages (they remain wireframes). Add Liquid for them in the same way; the Homepage conversion is the template.
8. **Content:** images are empty by default and show the approved labelled placeholders until chosen in the Theme Editor.