# NUDGE Beauty Theme Design Variables

The **canonical, single source** of every design token for NUDGE, delivered in three consistent formats:

1. **JSON tokens** (`Tokens/`): the structured source of truth.
2. **CSS custom properties** (`Styles/variables.css`): generated; linked by the Design System and ready for the Shopify theme.
3. **Visual review dashboard** (`Preview/index.html`): inspect, compare across tiers, and validate the real tokens in a browser.

The Design System (`../01-Design-System/`) is a separate section. It links the CSS generated here and defines no tokens; a token change made here reaches it with no second edit (verified by an automated propagation test).

## Open the dashboard

Open `Preview/index.html` in a browser. No server or build step needed.

## Commands

```powershell
# regenerate CSS, matrix, token reference and dashboard data; run every builder check
powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Tokens/build-tokens.ps1

# browser test (Chrome or Edge): every token at 6 widths, dark-surface scope, dashboard, Design System touch
# targets and console output, static checks (encoding, CSS braces, JSON), the propagation test, and the
# structural scan (section 7: required files, local references, Markdown links, generated-output completeness
# and freshness, page structure at 320/390/1280px)
powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Tokens/test-tokens.ps1

# emulation + interaction test (Chrome or Edge, over the DevTools protocol): 390px phone with touch, reduced
# motion, forced colors, the no-:has() CSS path, and REAL key, wheel, mouse and touch input for the chip row,
# the drawer (phone sheet and side panel) and Load more
powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Tokens/test-emulation.ps1
```

Both test scripts accept `-BrowserPath <exe>` (for example Edge) and `test-emulation.ps1` accepts `-OutDir <folder>` to save screenshots. Builder exit codes: 0 ok · 1 invalid JSON, unresolved alias, duplicate name, alias cycle, bad tier or fluid value · 4 `01-Design-System/` not found · 5 the Design System defines a token, uses a deprecated alias, or uses an undefined custom property. Test exit codes: 0 passed · 1 a check failed · 2 could not run.

## Structure

```
02-Design-Variables/
├── README.md
├── responsive-token-matrix.md     GENERATED: tier tokens
├── Tokens/                        SOURCE OF TRUTH (edit the JSON)
│   ├── primitives.json            raw palette
│   ├── semantic.json              color roles + $scopes (dark surface)
│   ├── typography.json            families, weights, sizes (even px, tiered), line heights, letter spacing, type roles
│   ├── spacing.json               4px scale + tiered section spacing
│   ├── layout.json                containers, gutter, grid gap, products grid, header, drawer, aspect ratios
│   ├── breakpoints.json           tier boundaries
│   ├── components.json            sizes components need that no global token expresses
│   ├── effects.json               radius, borders, shadows, opacity, transitions, z-index
│   ├── build-tokens.ps1           generator + checks
│   ├── test-tokens.ps1            browser test
│   └── test-emulation.ps1         emulation test
├── Styles/
│   └── variables.css              GENERATED, mobile-first
├── Preview/                       dashboard (index.html's token data block is GENERATED)
├── Figma-Variables/               Figma variable specification (not a Figma file); has its own README
└── Documentation/
    ├── usage-guide.md             load, consume, extend, removed tokens, dark surfaces, dashboard
    └── token-reference.md         GENERATED: all tokens and scopes
```

## Numbers

**337 tokens:** 14 tier (media-query steps), 0 fluid, 323 static, across 8 JSON files (since the 2026-11-11 typography and spacing audit; before it, 333 tokens with 10 fluid). The Design System uses 274 of them; 9 deprecated compatibility aliases for old Design System names live in `01-Design-System/Styles/foundation.css`. See [responsive-token-matrix.md](responsive-token-matrix.md).

## What was verified (all executed)

- **`test-tokens.ps1` (Chrome, and again on Edge):** all 333 tokens match the JSON at 320, 599, 600, 1023, 1024 and 1440px; the `.surface-inverse` scope is correct; the dashboard's 70 checks report 0 failures at 390, 768 and 1440px (including the drawer measured at 8 widths as a phone sheet or a side panel, the thumbnail rail and the crop rule); 94 (at 390px) and 99 (at 1280px) Design System interactive elements measure 44 × 44px; the showcase and dashboard log nothing; the propagation test passes; no double-encoded characters in 60 files, CSS braces balance, JSON parses.
- **`test-emulation.ps1` (Chrome, and again on Edge):** a real 390 × 844 touch viewport at DPR 3 (no overflow, targets still 44px, no hover effects); reduced motion; forced colors (found and fixed real defects, see the Design System accessibility doc); the product-card focus and chip check mark still work with the `:has()` branch disabled.
- **Real-input behavior (Chrome and Edge, executed):** the Design System drawer (Enter opens a modal dialog, focus moves in and wraps both ways, the page behind is inert and does not scroll, the body scrolls on its own, Escape / close / action / scrim close it and focus returns), Load more (loading, success, failure, last page; demo loader) and the chip row (Tab scrolls a clipped chip into view; touch swipe). See `01-Design-System/Documentation/accessibility.md`.
- **Typography units (executed):** `build-tokens.ps1` and `test-tokens.ps1` section 8 enforce the convention: no `pt` anywhere (reported per file and token); every font size is `px` in every tier, whole and even (the builder refuses 13px or 17.5px; test 8e re-checks the generated CSS); spacing tokens sit on the 4px grid (builder, plus test 8f); theme CSS takes every `font-size` from a token. Fluid `clamp()` sizes are still parsed and validated if one is ever reintroduced, but none is in use. Deliberate breakages (a `12pt` or `9pt` token, a static `rem` size, `14px` and `12pt` in CSS, a hand-edited generated file) each failed with the file and token name.
- **Structural scan (executed):** `test-tokens.ps1` section 7; five deliberate breakages on a throwaway copy were each caught with a message naming the file.
- **The checks can fail:** reintroducing each earlier bug (a 42px hit area, a removed focus rule, double-encoded text, a deleted forced-colors block, an unconditional `outline: none` on the card link) made the matching check fail; the builder and tests fail on cycles, unresolved aliases, duplicate names, malformed fluid values, a Design System that defines tokens, and a missing Design System.
- **Migration safety:** a before/after snapshot of 1,341 Design System elements at 360, 768 and 1280px showed no change in typography, color, radius, shadow, margin or opacity; only the intended gutter and grid-gap change (at most 4.6px).

Not verified: Firefox, Safari, real devices, assistive technology, a real Windows contrast theme, use inside a real Shopify theme (see `01-Design-System/Documentation/manual-testing.md`).

## Known limitations

- 14 tokens have no static reference. All are accounted for: scale members (`--space-0`, `--radius-none`, `--z-base`), the reserved layers (`--z-dropdown/-overlay/-drawer/-modal/-toast`; note that the drawer is a native `<dialog>` in the browser's top layer and does not use them, so they are kept for non-dialog overlays such as menus and toasts), `--product-image-aspect-gallery` (a separate gallery ratio by intent), two members of the `input` type role kept so every role has the same five properties, and the three `--breakpoint-*` tokens, which the dashboard reads at runtime (invisible to a static scan).
- Breakpoint tokens are reference values: `@media` cannot read custom properties, so the generator writes the literals.
- Dashboard validation runs at the window's current tier; `test-tokens.ps1` covers all three.
- The dashboard's drawer and gallery are visual specimens. The Design System has a real drawer (`.drawer` + `01-Design-System/Scripts/drawer.js`), tested with real input in Chromium only; the gallery has no behavior yet (thumbnail selection is not built).
- The dashboard loads fonts from `05-Assets/Fonts/`; if that moves, update three `@font-face` URLs in `Preview/preview.css` (it falls back to system fonts meanwhile).
- The builder and tests are PowerShell (Windows PowerShell 5.1 tested). Chromium only; no Firefox or Safari is available.
