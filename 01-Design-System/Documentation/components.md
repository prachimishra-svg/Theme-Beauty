# Components

All in `Styles/components.css`. Naming: `.block`, `.block__element`, `.block--modifier`. State hooks prefer native/ARIA: `:disabled`, `[aria-disabled]`, `[aria-invalid]`, `[aria-pressed]`, `:checked`.

Every interactive element gets the global focus ring (`:focus-visible`, 2px Rich Burgundy, 2px offset; Blush on `.surface-inverse`).

| Component | Variants / modifiers | States | Sizing | Accessibility | Responsive |
|---|---|---|---|---|---|
| **Button** `.btn` | `--primary`, `--secondary`, `--text`; `--sm` `--lg` `--block` `--block-mobile` | hover, active, focus, disabled (strike-through) | 48px default, 56 lg; 40px small with a 44px hit area | Use `<button>` / `<a>`; `aria-disabled` for links; text is real text | `--block-mobile`: full width < 600px |
| **Icon button** `.icon-btn` | `--filled`, `--round`, `__count` | hover, active, `aria-pressed`, disabled | 44 × 44 | Needs `aria-label`; icon `aria-hidden` | Same size everywhere |
| **Link** `.link` | `--subtle`, `--arrow`, `--standalone` | hover (thicker underline), focus | inherits; `--standalone` and `--arrow` are 44px high | Always underlined in running text. Use `--standalone` for a link that is not inside a sentence | — |
| **Text input / textarea** `.input` | in `.field` | hover, focus, `aria-invalid`, `--success`, disabled (dashed) | 48px, 16px text | Visible `<label for>`; errors via `aria-describedby`; message uses icon + text | Full width of field |
| **Select** `.select > .input` | — | as input | as input | Native `<select>`; chevron is decorative | Full width |
| **Checkbox / radio** `.choice > .choice__input` | checkbox, radio | checked, indeterminate, disabled, invalid | 24px box, ≥44px row | Native inputs, whole label clickable | — |
| **Field** `.field` | `--error`, `--success`; `__hint`, `__message` | — | — | Error is border + icon + text, never color alone | Two columns ≥ 600px via `.grid--2` |
| **Quantity** `.qty` | — | hover, focus-within, disabled at limits | 48px tall, 44px buttons | Buttons labeled; input `inputmode="numeric"` | — |
| **Swatch** `.swatches > .swatch` | `--sm` (decorative) | hover, checked (ring + gap), focus, disabled (diagonal line) | 44px hit, 32px chip | Native radio; hidden name text; selected name displayed | Wraps |
| **Badge** `.badge` | `--brand`, `--dark`, `--outline`, `--success`, `--warning`, `--error` | — | 12px uppercase | Status badges include icon + words | — |
| **Message** `.message` | `--success`, `--warning`, `--error` | — | — | Icon + text; use `role="alert"` only for dynamic errors | — |
| **Price** `.price` | `--sale`, `--lg`; `__compare`, `__unit` | — | — | Visually-hidden "Sale price / Regular price"; `<s>` for compare | Wraps |
| **Rating** `.rating` | — | — | 16px stars | `role="img"` + `aria-label` on stars; number shown | — |
| **Card** `.card` | `--flat`, `--raised`, `--interactive` | hover lift | content-driven | — | `__body` padding 20 → 24px |
| **Divider** `.divider` | `--strong`, `--vertical` | — | 1px | `<hr>` is a separator | — |
| **Product card** `.product-card` | `--soldout`; badges, wishlist, swatches, action | hover zoom (hover-capable only), focus ring on card | 4:5 media | One link (title) covers the card via `::after`; controls sit above | `.grid--products` 2 / 3 / 4 columns |
| **Breadcrumb** `.breadcrumb` | `__list`, `__item` | hover, focus, current page | links 44px tall, text 14px | `<nav aria-label="Breadcrumb">` + `<ol>`; last item `aria-current="page"`; separators are CSS, not text | Wraps; long names wrap |
| **Accordion** `.accordion` | `__item`, `__summary`, `__panel` | open/closed (chevron rotates), hover, focus | summary ≥ 44px | Native `<details>`/`<summary>`: keyboard and screen-reader support for free; `name=""` makes a group exclusive where supported | Full width, panel capped at reading width; rows open independently (no `name` attribute) |
| **Chip** `.chip` | toggle; removable (icon + hidden "Remove filter" text) | hover, `aria-pressed="true"` (tint + border + check), disabled (dashed) | 40px visual, 44px hit area | `<button aria-pressed>`; selected is never colour alone; a visually-hidden label names the remove action | Wraps in `.cluster` |
| **Pagination** `.pagination` | `__link`, `__gap` | hover, `aria-current="page"` (filled), `aria-disabled` (strike-through) | 44 × 44 | `<nav aria-label="Pagination">` + list; page links prefixed with hidden "Page "; gap is `aria-hidden` | Centres and wraps |

## Review of the four newest components (decision D7)

The four components added in the audit (finding F15) are the **filter chip, breadcrumb, accordion and pagination**. Each was reviewed against its use case, overlap with existing components, variants, states, responsive behavior and accessibility. All four are kept.

| Component | Use case (foreseeable page) | Overlap check | Variants and states | Responsive | Accessibility | Verdict |
|---|---|---|---|---|---|---|
| **Filter chip** | Skin-concern and product-type filters; active-filter pills with remove (collection pages) | Not a badge (static label) and not a button variant (pill shape, selected state, toggle semantics); `aria-pressed` toggle | Toggle: default, hover, pressed (tint + border + check), disabled. Removable: close icon + hidden "Remove filter" | Choice row `.chip-row`: one scrolling line on phones, wraps from 600px. Applied filters use `.cluster` and always wrap. 40px visual, 44px hit area | `<button aria-pressed>`; selection is shape + color; remove action named by hidden text | **Keep** |
| **Breadcrumb** | Collection and product pages | No existing equivalent (a link list is not a trail) | Default, hover, current page (`aria-current="page"`) | Below 600px: one line, parent + current page, current page truncated with an ellipsis (ancestors hidden). From 600px: full trail, wraps. Links ≥ 44px high and wide | `<nav aria-label="Breadcrumb">` + `<ol>`; separators are CSS, not text | **Keep** (phone pattern changed, awaiting owner approval: foundations.md section 14) |
| **Accordion** | Product details, ingredients, how to use, shipping; mobile footer and filter groups | Native `<details>` (no JS); not tabs or a drawer | Closed, open (chevron rotates), hover, focus | Full width, panel capped at reading width; rows open independently (no `name` attribute) | Native keyboard and screen-reader support; summary ≥ 44px | **Keep** |
| **Pagination** | Collection and search results | No existing equivalent | Numbered: default, hover, current (filled + `aria-current`), disabled (strike-through). Phones: **Load more** (`.load-more`) with loading, success, failure and last-page states | Tablet and up: numbered, centered, wraps; phones: Load more, 44px high. One wrapper `.pagination-switch`; CSS shows one of the two | `<nav aria-label="Pagination">`; page links prefixed with hidden "Page "; Load more is a real `<a href>`; status in `role="status"`, failure in `role="alert"`, `aria-busy` and `aria-disabled` while loading | **Keep**; Load more on phones is **provisional for implementation** (approved direction, demo loader only, nothing verified against Shopify: foundations.md section 14, risk A) |
| **Drawer** | Filter and sort, later cart and menu | Native `<dialog>`; not the accordion, not a page | Closed, open; phone sheet (`100%`) and 26rem panel from 600px; head with 44px close, scrolling body, pinned footer action | Full width below 600px, 26rem from 600px, scrim beside the panel | `<dialog aria-labelledby>`, modal (page inert), Escape, focus wrap, scroll lock, focus restore (`drawer.js`); close and action named | **Keep** (approved; tested in Chromium with real input, manual tests pending) |

Dependency check: the four components are used only by the showcase; nothing else depends on them, and they use no tokens of their own (only canonical ones).

**Subjective decisions** (approvals, evidence and limits in [foundations.md](foundations.md), section 14): all eight are approved. Behavior files for the theme: `Scripts/drawer.js`, `Scripts/load-more.js`, `Scripts/chip-row.js` (each is optional progressive enhancement of real links, buttons and a native `<dialog>`).

## Introduce a new component

1. Confirm it can't be composed from existing components + utilities (`.stack`, `.cluster`, `.grid`).
2. Add a section to `components.css` in the same format: header comment, base class, modifiers, states.
3. Use **only** tokens. Missing value? Add a token first ([tokens.md](tokens.md)).
4. Build mobile-first; only add `@media` at 600 / 1024 and only if the layout truly changes.
5. Use semantic HTML; add ARIA only where native elements don't cover it. Ensure ≥ 44px targets and a visible focus state.
6. No fixed heights on text containers (`min-height` only). Add `min-width: 0` to flex/grid children that hold text.
7. Add to the showcase in `index.html` (default, each variant, each state, narrow behavior) and to the table above.
8. Run through [accessibility.md](accessibility.md).

## Notes

- Placeholder imagery (`.placeholder-media`) is showcase-only; real themes use `<img>` inside `.ratio`.
- Colored swatches take their color from a `--swatch` inline custom property (merchant data). This is the one place a non-token color is expected.
- Component dimensions come from component tokens (`--choice-size`, `--qty-input-width`, `--swatch-size`, `--input-textarea-min-height`, `--icon-button-count-size`, `--product-card-*`, ...), defined in `02-Design-Variables/Tokens/components.json`. Nothing here is hardcoded except typographic `em` offsets and one optical alignment margin on the checkbox.
- Layout helpers accept optional overrides with built-in fallbacks: `--stack-gap`, `--cluster-gap`, `--cluster-align`, `--grid-min`, `--ratio`. They are intentionally not tokens.
- Hover-only effects (image zoom) are wrapped in `@media (hover: hover)`. The 44px target standard and its exceptions are in [foundations.md](foundations.md), section 8: the small button and chip have a 40px visual and an invisible 44px hit area.
- Product-card focus is progressive enhancement: the title link shows the normal ring by default; inside `@supports selector(:has(*))` the ring moves to the whole card. A browser without `:has()` (or without `@supports selector()`) keeps the link ring. The same pattern keeps the chip check mark visible by default; a removable chip that already has an icon hides it where `:has()` works. Disabled choice labels use `:has()` only for a muted color (cosmetic).
- Forced colors: a `@media (forced-colors: active)` block at the end of `components.css` redraws anything that relied on a background or color for meaning (checkbox and radio marks, swatch ring, current page, selected chip, separators, badge outlines).
- The checkbox tick uses a data-URI mask with `stroke='black'`; it's a mask (shape only), the visible color is `--color-text-on-brand`.
