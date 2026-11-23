# Tokens

**The Design System defines no tokens.** Every token (colors, type, spacing, layout, component sizes, radii, shadows, motion, z-index) lives in `02-Design-Variables/` and nowhere else:

```
02-Design-Variables/Tokens/*.json   -- the only place a token is edited (source of truth)
02-Design-Variables/Styles/variables.css   -- generated CSS custom properties; the Design System links this
```

To change, add or remove a token, follow [../../02-Design-Variables/Documentation/usage-guide.md](../../02-Design-Variables/Documentation/usage-guide.md) (section "Add or change a token"), then run `02-Design-Variables/Tokens/build-tokens.ps1`. The Design System needs no matching edit. This is tested: `02-Design-Variables/Tokens/test-tokens.ps1` changes a primitive in a temporary copy, rebuilds, and confirms the Design System's button color changes while none of its files do.

## How the Design System consumes tokens

Load order in every page:

```html
<link rel="stylesheet" href="../02-Design-Variables/Styles/variables.css">   <!-- all tokens + .surface-inverse -->
<link rel="stylesheet" href="Styles/foundation.css">                  <!-- @font-face + deprecated aliases -->
<link rel="stylesheet" href="Styles/base.css">
<link rel="stylesheet" href="Styles/components.css">
```

- `base.css` and `components.css` use only canonical tokens (plus a few documented local hooks with fallbacks: `--stack-gap`, `--cluster-gap`, `--cluster-align`, `--grid-min`, `--ratio`, `--swatch`, `--image-position`).
- `foundation.css` holds the `@font-face` rules (the Design System owns the font files) and the deprecated aliases below. It declares no other custom property.
- The builder fails (exit 5) if Design System code re-declares a canonical token, uses a deprecated alias, or uses an undefined custom property without a fallback.

## Layers (defined in Design Variables)

1. **Primitive** (`--palette-*`): raw values. Never used inside components.
2. **Semantic** (`--color-*`): what a value is *for*. Components use these.
3. **Scale and role tokens**: spacing scale, type roles (`--type-<role>-*`), layout, effects.
4. **Component** (`--control-*`, `--choice-*`, `--swatch-*`, `--product-image-*`, `--radius-control`...): sizes a component needs that no global token expresses.

Example: `--palette-rose-700` (primitive) → `--color-brand-primary` → `--color-button-primary-bg` (semantic) → `.btn--primary`.

## Color rules

- **Rich Burgundy (`--color-brand-primary`) is the primary brand and CTA colour.** Its hover/active/tint values are shades of the same hue.
- **Luxury Rose (`--color-brand-secondary`) marks recognisable brand moments**: eyebrows, ratings, heading rules, large serif accents. Small text only on Pearl Pink or white (4.67 / 4.99:1); large text and marks only on Rose Quartz (3.65:1).
- **Blush Rose (`--color-brand-accent`) is decorative** on light surfaces (rules, dividers, swatches; 2.13:1 on Pearl Pink), and may carry links and marks on Midnight Plum (6.88:1).
- Pearl Pink, White, Rose Quartz and Midnight Plum are neutrals. Neutral 300 to 600 are warm greys derived to hit contrast targets.
- Red / green / amber exist **only** for status, always with icon and text.
- Never rely on `--color-border-strong` against Rose Quartz (2.72:1). Muted text passes there (4.59:1).
- Never put white text on Blush Rose; Midnight Plum text passes on it (6.88:1). White on Luxury Rose passes (4.99:1).
- Never convey error, success, selection or disabled by color alone.
- Re-mapping a semantic token inside a scope does **not** update tokens built from it (aliases resolve where they are declared). Use the generated `.surface-inverse` scope, or add a scope in `semantic.json` (`$scopes`), which re-declares dependents automatically.

## Colour token categories

The palette update kept the existing names, so no role has two tokens. Common generic names map to these tokens:

| Category | Generic name | Token in this system | Value |
|---|---|---|---|
| Brand | brand primary | `--color-brand-primary` (hover `-primary-hover`, active `-primary-active`) | Rich Burgundy `#713448` (`#5E2A3B`, `#4B2130`) |
| Brand | brand secondary | `--color-brand-secondary` | Luxury Rose `#AD526D` |
| Brand | brand accent | `--color-brand-accent` | Blush Rose `#D99BAA`, decorative on light surfaces |
| Brand | brand tint | `--color-brand-tint`, `--color-brand-tint-strong` | `#FBEAEE`, `#F0D2DA` |
| Background | background primary | `--color-bg-page` | Pearl Pink `#FFF5F5` |
| Background | background secondary | `--color-bg-subtle` | Rose Quartz `#F2D5DC` |
| Background | surface / card | `--color-bg-surface` | White |
| Background | inverse | `--color-bg-inverse` | Midnight Plum `#292126` |
| Text | text primary / heading | `--color-text-primary` | Midnight Plum |
| Text | text secondary / muted / disabled | `--color-text-secondary` / `-muted` / `-disabled` | `#5A4B53` / `#6B5C64` / `#BFB1B7` |
| Text | on brand / inverse | `--color-text-on-brand` / `--color-text-inverse` | White / Pearl Pink |
| Border | border default / divider | `--color-border-subtle` | Rose Quartz |
| Border | input border | `--color-control-border` (= `--color-border-strong`), hover `--color-control-border-hover` | `#908088`, Midnight Plum |
| Button | primary | `--color-button-primary-bg` / `-bg-hover` / `-bg-active` / `-text` | Berry 700 / 800 / 900, White |
| Button | secondary | `--color-button-secondary-border`, `-bg-hover`, `-text-hover` | Midnight Plum outline, fills on hover |
| Button | disabled | `--color-button-disabled-bg` / `-text` | Rose Quartz / `#5A4B53` |
| State | focus | `--color-focus-ring` / `-ring-inverse` | Rich Burgundy / Rose Quartz |
| State | link | `--color-link` / `-hover` | Rich Burgundy / `#4B2130` |
| Status | error / success / warning (+ `-bg`) | `--color-status-*` | Unchanged red, green, amber |

## Deprecated aliases (migration)

Kept in `Styles/foundation.css` for any external code that used the old Design System names. Design System code does not use them. Remove them at the theme phase.

| Old name | Use instead | Note |
|---|---|---|
| `--gutter` | `--layout-gutter` | Now **stepped** (16 / 24 / 40px) instead of fluid |
| `--grid-gap` | `--layout-grid-gap` | Now **stepped** (16 / 24 / 32px) instead of fluid |
| `--section-space` | `--space-section` | Same token; now a tier value (48 / 64 / 96px, was fluid) |
| `--grid-cols-products` | `--grid-columns-products` | |
| `--header-height` | `--layout-header-height` | Same values (64px, 80px from desktop) |
| `--line-height-display` | `--line-height-tight` | Same value |
| `--bp-tablet` / `--bp-laptop` / `--bp-wide` | `--breakpoint-tablet` / `-desktop` / `-wide` | Reference values only |
| `--color-border-disabled` | `--color-border-subtle` | Removed, no alias: nothing used it; same value |

Tokens removed outright (nothing in the Design System used them): the 20 redundant component aliases and unused role tokens listed in `02-Design-Variables/Documentation/usage-guide.md` ("Removed and deprecated tokens").

## Customize for another merchant

Edit primitives in `02-Design-Variables/Tokens/primitives.json` (brand `palette.rose.*`, neutrals), font families in `typography.json`, radius and shadow in `effects.json`; rebuild. Re-measure contrast: the Design Variables dashboard's Validation panel does it live. In Shopify, expose primitives as theme settings and emit a `:root` override after `variables.css`.
