# NUDGE Beauty Theme Design System

Design foundation for a premium beauty and skincare Shopify theme. **NUDGE is a working name**: it has not been checked for trademark or Shopify Theme Store availability.

Open `01-Design-System/index.html` in a browser to see the live showcase (no build step, no server needed).

## Contents

| File | Purpose |
|---|---|
| [tokens.md](tokens.md) | How the Design System consumes the canonical tokens, load order, color rules, deprecated aliases |
| [typography.md](typography.md) | Type hierarchy, stepped even-px sizing, font loading and licensing |
| [foundations.md](foundations.md) | Brand principles, responsive strategy, grid, elevation, imagery, motion and interaction rules, focus, touch targets, what belongs where, component coverage, the eight subjective decisions with status, evidence and limits |
| [brand.md](brand.md) | NUDGE logo: wordmark, monogram, favicon, colours, clear space, minimum sizes, usage rules, file list |
| [components.md](components.md) | Variants, states, sizing and responsive rules per component; the review of the four newest components; how to add one |
| [accessibility.md](accessibility.md) | Requirements, measured contrast and focus results, and the checklist with verified / not-yet-verified status |
| [manual-testing.md](manual-testing.md) | What automated checks cannot cover (real devices, screen readers, Safari and Firefox, a real contrast theme, Shopify): steps, expected results, results log |

## Project layout

```
NUDGE-BEAUTY-THEME/
├── 01-Design-System/               this section
│   ├── index.html                  showcase (uses the real shared CSS)
│   ├── Styles/
│   │   ├── foundation.css          @font-face + deprecated aliases (NOT tokens)
│   │   ├── base.css                reset, type roles, layout primitives, utilities
│   │   ├── components.css          component styles (canonical tokens only)
│   │   └── preview.css             showcase chrome, not part of the theme
│   ├── Scripts/                    drawer.js, load-more.js, chip-row.js (theme behaviour); preview.js (showcase only)
│   ├── Documentation/              these documents, brand.md and the audit report
│   └── Figma-Specification/        Figma component specification and its review page (not a Figma file)
├── 02-Design-Variables/            CANONICAL token source (JSON), generated CSS, review dashboard, tests
├── 03-Wireframes/                  Beauty homepage wireframe
├── 04-CRO-Research/                original CRO research and comparisons
└── 05-Assets/                      Fonts (self-hosted woff2, OFL), Icons (28 Lucide SVGs, sprite.svg, build-icons.ps1), Logos
```

## Single source of truth

`02-Design-Variables/` owns every token. This section links its generated CSS and defines nothing. Change a token there and run its builder; no edit is needed here (verified by an automated propagation test). See [tokens.md](tokens.md).

## Ready for future Shopify Liquid integration

| Part | Shopify path (future) | Notes |
|---|---|---|
| `variables.css`, `foundation.css`, `base.css`, `components.css` | `assets/` | Plain CSS. Load with `asset_url`. `@font-face` URLs in `foundation.css` are relative (`../fonts/`); Shopify needs flat assets, so use `{{ 'file.woff2' \| asset_url }}` in a `.css.liquid` file or a `<style>` block. Preload the two main fonts in the theme (served over http) |
| Icons | `snippets/icon.liquid` | Each icon becomes one case, or inline the sprite once in `layout/theme.liquid` |
| Merchant colors | `:root` override block | Map theme settings onto the `--palette-*` primitives only |
| Swatch colors, image focal points | Inline `--swatch`, `--image-position` | Per-item data, deliberately not tokens |
| Component markup | `snippets/`, `sections/` | Class names and ARIA hooks are stable |

Not ready / not done: no Liquid, no section schemas, no cart or variant-selection behavior, no real images, nothing tested inside a Shopify theme. Built behavior: `Scripts/drawer.js` (filter drawer), `Scripts/load-more.js` (phone Load more, demo loader only) and `Scripts/chip-row.js`; tested in Chromium only. Two decisions stay provisional: phone Load more (nothing verified against Shopify) and the 4:5 product canvas (no real photography supplied); see [foundations.md](foundations.md) section 14 for the open-risk register.

## Limitations and assumptions

- Fonts include the **latin subset only**. Other scripts fall back to system fonts until more subsets are added.
- Cormorant is declared at weights 400 to 700 (500, 600 and 700 are used) plus italic 500; DM Sans is variable 400 to 700.
- Breakpoints cannot be read from custom properties in `@media`; the two values (600 / 1024px) are written out in CSS (`37.5rem`, `64rem`) and generated into `variables.css` from `breakpoints.json`.
- Dark surfaces: only the `.surface-inverse` scope (text, links, focus ring, secondary button, form controls). No site-wide dark mode.
- `:has()` is used only as an enhancement (product-card focus moves to the whole card; a removable chip hides its check mark; disabled choice labels are muted). Without it the title link keeps a focus ring and the chip keeps its check mark.
- Native select, date and file inputs keep their native pickers; only the closed state is styled.
- Showcase prose that states numbers (the contrast table, descriptive notes) is a dated snapshot; the always-current values are in the Design Variables dashboard.
