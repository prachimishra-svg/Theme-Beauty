# Usage guide

How to load, consume, extend and review the NUDGE design variables. For the complete token list see [token-reference.md](token-reference.md) (generated); for tier values see [../responsive-token-matrix.md](../responsive-token-matrix.md) (generated).

**`02-Design-Variables/` is the single source of truth for every token.** The Design System (`01-Design-System/`) links the CSS generated here and defines no tokens of its own.

## 1. Load

```html
<link rel="stylesheet" href="02-Design-Variables/Styles/variables.css">
```

`variables.css` contains custom properties and the generated `.surface-inverse` scope only: no resets, classes or font loading. The Design System adds `@font-face` and its components after it (load order: `variables.css`, `foundation.css`, `base.css`, `components.css`).

## 2. Consume

```css
.hero__title {
  font-family: var(--type-display-font-family);
  font-size:   var(--type-display-font-size);        /* tier: 44 / 60 / 80px */
  font-weight: var(--type-display-font-weight);
  line-height: var(--type-display-line-height);
  letter-spacing: var(--type-display-letter-spacing);
}
.section      { padding-block: var(--space-section); padding-inline: var(--layout-gutter); }
.product-grid { display: grid; gap: var(--layout-grid-gap);
                grid-template-columns: repeat(var(--grid-columns-products), minmax(0, 1fr)); }
.card__media  { aspect-ratio: var(--aspect-portrait); object-fit: var(--product-image-fit); }
.btn          { min-height: var(--control-height-md); padding-inline: var(--control-padding-x);
                border-radius: var(--radius-control); transition: var(--transition-colors); }
```

Use semantic, scale, role and component tokens in components, not raw `--palette-*`. Roles with uppercase text (`overline`, `button`, `utility`) also have `--type-<role>-text-transform`; other roles do not need one. Uppercase **headings** are not a role: add the `.heading-caps` modifier (Design System `base.css`), which sets `text-transform: uppercase` and `letter-spacing: var(--letter-spacing-uppercase)`.

## 3. Architecture

| Layer | File | Role |
|---|---|---|
| Primitive | `primitives.json` | Raw palette |
| Semantic | `semantic.json` | What a color is for (aliases to primitives), plus `$scopes` |
| Scales | `typography.json`, `spacing.json`, `layout.json`, `breakpoints.json` | Type, spacing, layout, tier boundaries |
| Component | `components.json` | Sizes a component needs that no global token expresses |
| Effects | `effects.json` | Radius, borders, shadows, opacity, motion, z-index |

A token may reference tokens in its own layer or a lower one.

**JSON format** (three kinds of value):

```json
"padding-x": { "$value": "{space.6}" }                                                  // static (alias)
"gutter":    { "$value": { "mobile": "{space.4}", "tablet": "{space.6}", "desktop": "{space.10}" }, "$description": "why it changes" }   // tier
"display":   { "$value": { "mobile": "44px", "tablet": "60px", "desktop": "80px" } }     // tier font size (even px)
```

- A leaf is an object with `$value` (and optional `$description`); anything else is a group.
- A tier value needs `mobile`; omitted tiers inherit. Every tier token states **why** it changes in its `$description`.
- **Scale rules (2026-11-11 audit):** a font size is a whole, even `px` value on every tier, and a `space.*` value sits on the 4px grid. `build-tokens.ps1` refuses anything else and names the token. Fluid `clamp()` values are no longer used, because they gave odd and fractional sizes between breakpoints. The builder would still parse one (`clamp(Xrem, Yrem + Zvw, Wrem)`, min below max, never under 16px for text), but adding one needs a documented reason.
- **Font-size units:** a `font.size.*` token is written in `px` (for example `16px`), static or as a `{mobile, tablet, desktop}` tier. Points (`pt`) are not allowed anywhere. `build-tokens.ps1` rejects a point value, a static `rem` size or an odd size and names the file and the token; `test-tokens.ps1` section 8 re-checks the source, the generated CSS and the theme stylesheets. See the unit history in `01-Design-System/Documentation/typography.md`.
- `{path.to.token}` is an alias, usable inside any string; it becomes `var(--path-to-token)`.

**Naming:** CSS name = `--` + JSON path joined by `-` (`color.bg.page` → `--color-bg-page`). Type roles add composite tokens `--type-<role>-<font-family|font-size|font-weight|line-height|letter-spacing>`.

**Generated, never hand-edited:** `Styles/variables.css`, `responsive-token-matrix.md`, `Documentation/token-reference.md` and the data block in `Preview/index.html`.

## 4. Responsive strategy (hybrid)

Tier (scaled type sizes, section spacing, gutter, grid gap, product columns, header height, drawer width, card padding) and static (everything else). Fluid was retired in the 2026-11-11 audit. The rules, rationale and measured behavior are in [../../01-Design-System/Documentation/foundations.md](../../01-Design-System/Documentation/foundations.md), section 2, and the generated matrix. In short:

- The 4px spacing scale is the only spacing; section padding is a tier of it (48 / 64 / 96px).
- A token gets tier values only with a stated layout reason; otherwise it is static.
- Mobile first; `min-width` queries at 600px and 1024px, written by the generator from `breakpoints.json`.

## 5. Add or change a token

1. Search [token-reference.md](token-reference.md) for an existing token.
2. Pick the file by layer. Prefer an alias to an existing scale value over a new literal. Add a component token only if it holds a value no global token expresses, or is a component-specific override point; do not add an alias that restates a global token for the same property.
3. Tier value → a `{mobile, tablet, desktop}` leaf **with a reason**. Font sizes stay whole, even px; spacing stays on the 4px grid.
4. Run the builder:
   ```powershell
   powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Tokens/build-tokens.ps1
   ```
5. A color needs its contrast pairs added to `PAIRS` in `Preview/preview.js` and a pass in the dashboard.
6. Run the browser test (needs Chrome or Edge):
   ```powershell
   powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Tokens/test-tokens.ps1
   ```
7. For anything touching color, focus, forced colors or touch behavior, also run `02-Design-Variables/Tokens/test-emulation.ps1`.
8. Commit the JSON and every regenerated file together.

**The Design System needs no edit.** The test proves it: it copies the project to a temp folder, changes the brand color in the JSON, rebuilds, and confirms the Design System's primary button changes while none of its files do.

Builder exit codes: 0 ok · 1 invalid JSON, unresolved alias, duplicate CSS name, alias cycle, tier token without `mobile`, malformed fluid value, odd or fractional font size, spacing off the 4px grid · 4 `01-Design-System/` not found (`-AllowMissingDesignSystem` skips the check deliberately) · 5 the Design System re-declares a canonical token, uses a deprecated alias, or uses an undefined custom property without a fallback. Test exit codes: 0 passed · 1 a check failed · 2 could not run.

## 6. Removed and deprecated tokens

Everything below was checked for references (Design System code, dashboard, docs, other tokens) before removal.

**Deprecated Design System names** (aliases remain in `01-Design-System/Styles/foundation.css`; Design System code no longer uses them; remove at the theme phase): `--gutter` → `--layout-gutter`, `--grid-gap` → `--layout-grid-gap`, `--section-space` → `--space-section`, `--grid-cols-products` → `--grid-columns-products`, `--header-height` → `--layout-header-height`, `--line-height-display` → `--line-height-tight`, `--bp-tablet/-laptop/-wide` → `--breakpoint-tablet/-desktop/-wide`.

**Removed, replaced by an existing token** (20 component aliases that restated a global token with no component intent; the Design System used none of them, only the dashboard did):

| Removed | Use instead |
|---|---|
| `--button-height-sm` / `-md` / `-lg` | `--control-height-sm` / `-md` / `-lg` |
| `--button-padding-x-sm` / `--button-padding-x` / `--button-padding-x-lg` | `--control-padding-x-sm` / `--control-padding-x` / `--control-padding-x-lg` |
| `--button-radius`, `--input-radius` | `--radius-control` |
| `--card-radius`, `--product-card-radius`, `--product-image-radius` | `--radius-card` |
| `--badge-radius` | `--radius-badge` |
| `--button-border-width`, `--input-border-width`, `--card-border-width` | `--border-width-thin` |
| `--input-height` | `--control-height-md` |
| `--input-font-size` | `--font-size-input` |
| `--choice-min-height`, `--qty-button-size`, `--swatch-hit` | `--touch-target-min` |
| `--space-section-sm`, `--space-stack-sm/-md/-lg` | the spacing scale (`--space-*`); no one used the tiers |
| `--color-border-disabled` | `--color-border-subtle` (same value; nothing used it) |
| `--type-<role>-text-transform` for the 18 roles that are `none` | omit the property (default `none`); only `overline`, `button`, `utility` keep the token |

**Kept on purpose** (component-level intent even though some alias a scale value): `--button-gap`, `--button-icon-size`, `--input-padding-x/-y`, `--choice-gap`, `--form-label-gap`, `--swatch-gap/-ring-width/-ring-offset/-radius`, `--badge-padding-*/-gap/-icon-size`, `--rating-*`, `--card-gap`, `--product-card-body-gap/-badge-offset`, `--product-image-*`, `--radius-control/-card/-badge`. Also kept: the reserved layers `--z-dropdown/-overlay/-drawer/-modal/-toast` (planned drawers and dialogs), scale members (`--space-0`, `--radius-none`, `--z-base`) and `--letter-spacing-normal`, which role tokens use.

**Made static** (they had tier values with no layout reason; set to the Design System's shipped value): `--control-height-lg` (56px), `--control-padding-x` (24px), `--control-padding-x-lg` (32px), `--product-card-gap`, `--form-field-gap`, `--product-image-thumb-size` (64px, retained after review). `--layout-drawer-width` was made static and then became a tier token again (below).

**Tier again, with a reason:** `--layout-drawer-width` is `100%` below 600px (a full-width sheet) and `26rem` from 600px (a side panel, 416px, leaving at least 182px of page). History: it was `min(100%, 26rem)`, then `min(calc(100% - var(--touch-target-min)), 26rem)`. The earlier measurements of "2, 2, 2 and 14px of page" at 320, 360, 390 and 430px included the specimen frame's own 2px border: the real page strip was 0, 0, 0 and 12px, so `min(100%, 26rem)` was already a full-width sheet up to 416px and left an unusable 1 to 44px sliver only between 417 and 460px. Use the token as the `width` of a panel anchored to the viewport edge. Because it is a tier token, a simulated frame in the dashboard takes the tier its own width belongs to. Whether a phone should get this sheet or a peek drawer is recorded as decision 5 in `01-Design-System/Documentation/foundations.md` (changed, awaiting owner approval). **Made fluid:** the 9 scaled type sizes and `--space-section` (the approved `clamp()` values, unchanged).

**Removed earlier as page-specific or speculative** (see the deferred table in the Design System foundations): `--layout-announcement-height`, `--aspect-hero`, `--grid-columns-page/-collections/-features/-blog/-footer`, `--input-select-padding-right`, `--product-card-action-offset`.

**Added:** `--icon-button-count-size`, `--product-image-position` (default object-position), and the 6 inverse-surface tokens.

## 7. Customize for another merchant

Edit `primitives.json` (brand `palette.rose.*`, neutrals), font families in `typography.json`, radii and shadows in `effects.json`, then rebuild. Re-measure contrast (white on the brand ≥ 4.5:1; brand on page and white ≥ 4.5:1; the ring on every surface): the dashboard does it live. `rose` is a brand-scale name; optionally rename it to `brand` in one pass.

## 8. Dark surfaces and scopes

Rich Burgundy is only 1.7:1 on Midnight Plum, so the default focus ring and links fail on a dark footer or promo bar. `variables.css` ships a generated scope: put `class="surface-inverse"` on the dark container and everything inside uses the inverse tokens (Ivory text, Blush links and focus ring, light control borders, transparent inputs, an Ivory secondary button).

The scope is defined once in `semantic.json` (`$scopes`). One CSS rule makes this non-obvious: **a custom-property alias resolves where it is declared**, so re-mapping `--color-focus-ring` inside a scope does not change `--focus-ring`. The builder re-declares every token that aliases an overridden one (currently `--focus-ring`, the secondary-button border and hover fill, control borders, `--color-rating-star-empty`). The browser test checks the scope. A Rich Burgundy **fill** needs the inverse ring set by hand (`--focus-ring: var(--focus-ring-width) solid var(--color-focus-ring-inverse)`); the default ring is 1.00:1 there. Shopify colour schemes can use the same mechanism (add a scope; never re-map primitives).

## 9. Review dashboard

Open `Preview/index.html` directly in a browser (no server needed). Data is embedded at build time. Fonts are read from `05-Assets/Fonts/` (if that path changes, update the three `@font-face` URLs at the top of `preview.css`; the dashboard falls back to system fonts).

- **Simulate** (header): apply Mobile / Tablet / Desktop values to the Color-to-Components sections without resizing. Tier tokens switch.
- **Compare tiers**, **Matrix** (tier tokens) and **All tokens** (search by name, value, description or JSON path; source file › path; static references from tokens, the dashboard and the Design System; **Not referenced** lists candidates to review, not proof a token is dead).
- **Focus ring on surfaces:** a button is focused for real on each surface and the rendered outline is measured.
- **Specimens:** product-image frames with different packaging (tall bottle, wide jar, a raw 1:3 photo with `cover` and `contain`), interactive gallery thumbnails in a scrolling rail, and a drawer you can set to 320, 390, 768 and 1280px. The Validation panel measures the drawer off-screen at 8 widths (width, strip of page left, close button inside and 44px, no overflow, body scrolls, last row and footer reachable) and checks that a square thumbnail keeps at least 80% of a card-ratio image.
- **Validation:** JSON ↔ CSS for every token at the current tier, alias integrity, 4px grid, ascending breakpoints, tier tokens never shrinking, type hierarchy, ≥ 16px text, 44px targets measured on the specimens (box or hit area), font availability, the focus-ring results, and 34 WCAG contrast pairs. "Known" marks documented exceptions.

Validation runs at the tier the window is in; `test-tokens.ps1` covers all three.

## 10. Future Shopify use

Plain CSS custom properties (not yet tested inside an actual Shopify theme): upload `variables.css` to a theme's `assets/` and load it with `asset_url`. Merchant-editable colors and fonts can be emitted as a `:root { … }` block after it that overrides primitives only. Swatch colors and image focal points come from Liquid data as inline `--swatch` / `--image-position`, deliberately not tokens. The JSON stays in the repo as a design artifact and is not shipped.
