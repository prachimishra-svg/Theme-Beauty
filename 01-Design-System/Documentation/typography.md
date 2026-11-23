# Typography

Headings (H1 to H6 and the display size): **Cormorant** (the Shopify font-library family; changed from Cormorant Garamond on 2026-11-04 so the theme can use the native `font_picker` setting). Everything else, including body text, navigation, buttons, product names and prices, forms and the footer: **DM Sans**. No other family is used; the only other font stack in the project is the system monospace stack for code samples in the showcase and the dashboard.

Direction (2026-11-03): luxury beauty look, classic serif headings over a clean sans. This replaces the earlier choice of DM Sans for H5, H6 and product titles.

## Fonts, loading, licensing

- Both are on Google Fonts under the **SIL Open Font License 1.1** (free for commercial use, embedding and modification; fonts may not be sold on their own). Include the OFL notice if you redistribute the font files in a packaged theme. Verify the license text at fonts.google.com before shipping — it was not re-checked in this session beyond the family listing.
- Files were downloaded from Google Fonts (latin subset, woff2) and are self-hosted — no third-party request, no GDPR font-CDN concern.
  - `cormorant-var.woff2` (~35 KB), variable, declared 400–700 (the file carries the full axis; measured in Chrome). **In use: 500, 600 and 700.** 400 is available but unused.
  - `cormorant-italic-500.woff2` (~24 KB)
  - `dm-sans-var.woff2` (~37 KB) weights 400–700
- `font-display: swap` shows the fallback immediately, then swaps. In the **theme** (served over http) preload the two main files with `crossorigin`. The local showcase deliberately has no preload tags: on `file://` the `crossorigin` preload is blocked by CORS and logged console errors. Expect a small layout shift on swap; to reduce it later, add `size-adjust` fallback `@font-face` rules.
- Fallbacks: heading → Iowan Old Style, Palatino, Georgia, serif. Body → system-ui stack.
- Verified in headless Chrome and Edge: both families report `loaded` at every tested width.

## Scale

Type is **stepped** (changed 2026-11-11 in the typography and spacing audit): every size is a whole, **even** px value, and the larger roles step up at the system's two breakpoints (tablet from 600px, desktop from 1024px) instead of growing continuously with `clamp()`. The end values of the earlier fluid sizes were kept wherever they were already even; the tablet step sits on the 4px scale. All values live in `02-Design-Variables/Tokens/typography.json`; the generated table of tier tokens is [02-Design-Variables/responsive-token-matrix.md](../../02-Design-Variables/responsive-token-matrix.md). Each role is one set of composite tokens (`--type-<role>-font-family|size|weight|line-height|letter-spacing`, plus `text-transform` for the three uppercase roles), and `base.css` styles every role class from them: the role is defined once, in Design Variables.

| Token / class | Family · weight | Size mobile / tablet / desktop (px) | Line height | Letter spacing | Use |
|---|---|---|---|---|---|
| `text-display` | Cormorant 500 | 44 / 60 / 80 | 1.1 | −0.015em | Hero only |
| `h1` | Cormorant 500 | 36 / 48 / 60 | 1.1 | −0.01em | Page title |
| `h2` | Cormorant 500 | 32 / 36 / 44 | 1.1 | −0.01em | Section title |
| `h3` | Cormorant 500 | 24 / 28 / 32 | 1.25 | 0 | Sub-section |
| `h4` | Cormorant 600 | 20 / 24 / 24 | 1.25 | 0 | Card title |
| `h5` | Cormorant 700 | 16 | 1.25 | 0 | Minor heading |
| `h6` | Cormorant 700 | 16 | 1.25 | 0.04em | Group label |
| `text-body-lg` | DM Sans 400 | 18 | 1.6 | 0 | Lead paragraph |
| `p` / `text-body` | DM Sans 400 | 16 | 1.6 | 0 | Default text |
| `text-body-sm` | DM Sans 400 | 14 | 1.5 | 0 | Supporting copy |
| `text-caption` | DM Sans 400 | 12 | 1.5 | 0 | Fine print |
| `text-overline` | DM Sans 600, uppercase | 12 | 1.5 | 0.14em | Eyebrow |
| `text-label` | DM Sans 500 | 14 | 1.25 | 0 | Field label |
| `.btn` | DM Sans 600, uppercase | 14 | 1.25 | 0.08em | Buttons |
| `text-nav` | DM Sans 500 | 16 | 1.25 | 0.04em | Navigation |
| `text-product-title` | DM Sans 500 | 16 / 16 / 18 | 1.25 | 0 | Product names |
| `text-price` | DM Sans 500, tabular | 16 | 1.25 | 0 | Card price |
| `text-price-lg` | DM Sans 500, tabular | 20 / 24 / 24 | 1.25 | 0 | PDP price |
| `text-validation` | DM Sans 500 | 14 | 1.5 | 0 | Errors / success |
| `text-utility` | DM Sans 500, uppercase | 12 | 1.5 | 0.08em | Promo bar, badges |
| input text | DM Sans 400 | 16 | 1.5 | 0 | Prevents iOS zoom |

Sizes are `--font-size-*` tokens; weights, line heights and letter spacings also have tokens. One token per role; the tier steps are generated media queries, not per-viewport duplicates.

**What the 2026-11-11 audit changed:** caption 13 → 12px, button 13 → 14px, navigation 15 → 16px, validation 13 → 14px, body large 17–19 → 18px, h2 mobile 30 → 32px, h5 16–18 → 16px (keeps h4 > body large > h5), and the nine fluid sizes became the tiers above. Body line height 1.65 → 1.6 (inside the 1.4–1.6 body range); overline, utility and validation 1.25 → 1.5 (small text sits at 1.3–1.5). Labels, buttons, navigation and prices keep 1.25: they are single-line control text, not running copy. Uppercase buttons stay at 14px rather than 16px because 0.08em tracking at 16px outweighs the body text.

### Heading weights

Display, H1, H2 and H3 use 500 for a refined, light-handed serif. H4 uses 600. H5 and H6 use 700 because Cormorant's strokes are thin at 16 to 18px. DM Sans uses 400 for reading text, 500 for labels, navigation, product names and prices, and 600 for buttons and small caps labels. 700 is available for DM Sans but no role uses it. Avoid inventing other weights.

### Uppercase headings

`text-transform: uppercase` is applied with the `.heading-caps` modifier (or in the wireframe's heading rules), never by retyping the content, so the authored text stays in normal case for search engines, screen readers and merchants. Tracking comes from one token, `--letter-spacing-uppercase` (0.06em), so uppercase headings stay elegant and not spaced out.

- Use on headings only: hero, section, category, collection, promotional, testimonial, newsletter and footer headings.
- Do not use on body text, product names or descriptions, long copy, navigation or small labels. Overline, button and utility roles are already uppercase by their own tokens; nothing else becomes uppercase automatically.
- Keep the heading's own size and line height. Uppercase Cormorant at the H1 maximum (60px) at 1920px and the minimum (36px) at 320px both fit without clipping (checked in the wireframe).

### Names used by the brief and the token that provides each

| Brief | Token in this system |
|---|---|
| font-family-heading / font-family-body | `--font-family-heading` / `--font-family-body` |
| font-weight-regular / medium / semibold / bold | `--font-weight-regular` (400) / `-medium` (500) / `-semibold` (600) / `-bold` (700) |
| font-size-h1 to font-size-h6 | `--font-size-h1` to `--font-size-h6` |
| font-size-body-large / body / body-small / caption | `--font-size-body-lg` / `--font-size-body` / `--font-size-body-sm` / `--font-size-caption` (the existing `-lg` and `-sm` suffixes were kept) |
| line-height-heading / line-height-body | `--line-height-tight` (display, H1, H2) and `--line-height-snug` (H3 to H6) / `--line-height-relaxed` (body) and `--line-height-normal` (small text) |
| letter-spacing-heading | `--letter-spacing-tight` and `--letter-spacing-display` (headings in normal case), set per role |
| letter-spacing-uppercase | `--letter-spacing-uppercase` (new, 0.06em) |

### Sizes at the supported viewports (px; exact, no interpolation)

| Token | 320 | 375 | 390 | 768 | 1024 | 1440 | 1920 |
|---|---|---|---|---|---|---|---|
| display | 44 | 44 | 44 | 60 | 80 | 80 | 80 |
| h1 | 36 | 36 | 36 | 48 | 60 | 60 | 60 |
| h2 | 32 | 32 | 32 | 36 | 44 | 44 | 44 |
| h3 | 24 | 24 | 24 | 28 | 32 | 32 | 32 |
| h4 | 20 | 20 | 20 | 24 | 24 | 24 | 24 |
| h5 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |
| h6 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |
| body large | 18 | 18 | 18 | 18 | 18 | 18 | 18 |
| body | 16 | 16 | 16 | 16 | 16 | 16 | 16 |
| product title | 16 | 16 | 16 | 16 | 18 | 18 | 18 |
| large price | 20 | 20 | 20 | 24 | 24 | 24 | 24 |

Order kept: display > h1 > h2 > h3 > h4 > body large > h5 at every width (the owner-approved rule from decision 8).
## Responsive behavior

- Large headings and two commerce sizes step up at 600px and 1024px. Body, labels, buttons and form text are fixed so they never shrink below readable on mobile.
- Line length is capped at `--container-text` (640px ≈ 65 characters) via `.measure`.
- Headings use `text-wrap: balance`.
- H5 and H6 use Cormorant at weight 700 (and H6 at 16px, up from 14px) so the serif stays legible at small sizes; the earlier sans-serif choice for H5/H6 was replaced on 2026-11-03.
- **Units convention (updated 2026-11-11):** every font size is `px`, whole and **even** (10, 12, 14, 16, 18, 20, 24, 28, 32, 36, 44, 48, 60, 80). Points (`pt`) are never used; if a source arrives in points, convert at 1pt = 1.3333px, then round to the nearest even px. `build-tokens.ps1` refuses an odd or fractional font size, and `test-tokens.ps1` checks 8b (px in every tier) and 8e (whole, even generated sizes).
- **Effect on the open unit finding** (AUDIT-REPORT.md Part 10): with no `rem` sizes left, a changed browser default font size no longer inverts the hierarchy (it used to make h5 and body large smaller than body text at a 12px default); all sizes now stay put together. Browser zoom still scales everything.
- Line heights are unitless ratios (they scale with the size). Where a line height is written in px (the wireframe's count badge), it sits on the 4px grid.

## Don'ts

- Don't request weights other than those loaded.
- Don't set `font-size` in components; use a role class or a `--font-size-*` token.
- Don't use Cormorant below 16px, and don't set it in all-caps outside headings (use `.heading-caps`, which keeps the tracking at `--letter-spacing-uppercase`).
- Don't use DM Sans for headings or Cormorant for product names, body text, buttons or forms.
- Don't declare `font-family` in a component: use a role class or a `--font-family-*` token.

## Shopify theme mapping (added 2026-11-04)

- Library handles: heading "Cormorant" = `cormorant_n5`, `cormorant_n6`, `cormorant_n7` (italic `cormorant_i5`); body "DM Sans" = `dm_sans_n4`, `dm_sans_n5`, `dm_sans_n6`. "Cormorant Garamond" is not in Shopify's font library, which is why the heading family moved to "Cormorant" (same design, the library's cut).
- In the theme use `font_picker` settings `type_heading_font` (default `cormorant_n5`) and `type_body_font` (default `dm_sans_n4`), output with the `font_face` filter and `font_modify` for the bolder weights. The self-hosted woff2 files here remain the design-system and wireframe source.
- Uppercase: the wireframe no longer forces uppercase on H1 to H3. Uppercase stays opt-in through `.heading-caps`.