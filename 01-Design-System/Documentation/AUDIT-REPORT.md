# NUDGE Beauty Theme: Design System and Design Variables Audit

> **Paths in this record.** The audit was written against the earlier folder layout (`design-system/`, `design-variables/`, `figma-design-system/`, `figma-variables/`, with fonts, icons and logos under `design-system/assets/`). Current locations: `01-Design-System/`, `02-Design-Variables/`, `01-Design-System/Figma-Specification/`, `02-Design-Variables/Figma-Variables/`, and fonts, icons and logos in `05-Assets/`. Statements below describe the project as it was when each part was written. Typography changed on 2026-11-03: H5, H6 and product titles moved to match the luxury direction (H5/H6 now Cormorant Garamond bold, product titles DM Sans), so findings below that mention DM Sans H5/H6 or a Cormorant product title describe the earlier state; see typography.md.

**Part 1 is the initial assessment, written before any file was changed (kept as written; see Part 2 for what changed and what was found later).** Part 2 (implementation record, validation, decisions, readiness) follows it.

Method: every file in both sections was inspected, and the findings below come from scripts and a real browser (headless Chrome) run against the actual files, not from the READMEs. Evidence is cited per finding.

---

# Part 1: Initial assessment (pre-change)

## A. What was reviewed

The project has **no `design-system/` folder**. The Design System lives at the project root; `design-variables/` is its own folder.

| Section | Files inspected |
|---|---|
| Design System (root) | `index.html` (726 lines), `assets/css/{tokens,base,components,preview}.css`, `assets/js/preview.js`, `assets/fonts/*.woff2` (3), `assets/icons/*.svg` (24 + sprite), `docs/*.md` (5), `scripts/build-icons.ps1` |
| Design Variables | `tokens/*.json` (8), `tokens/build-tokens.ps1`, `styles/variables.css` (378 custom properties), `preview/{index.html,preview.css,preview.js}`, `docs/{usage-guide,token-reference}.md`, `responsive-token-matrix.md`, `README.md` |

Analyses run: custom-property declaration vs reference scan on both sections; alias-chain depth; static usage of every token; hardcoded-literal scan of DS component CSS; unused-class scan; DS vs DV name and value comparison; fluid-vs-stepped type comparison at 5 widths; brace balance; doc-claim spot checks; a browser structural scan (duplicate ids, ARIA references, labels, accessible names, heading order, scrollable-region focus, target sizes) at 390 and 1280px on both pages.

## B. What exists and works

- **Token integrity:** 0 broken `var()` references in either section; 0 duplicate token names; 0 alias cycles; maximum alias depth 2. JSON → CSS generation is deterministic; all 378 tokens matched the JSON in-browser at 3 tiers (earlier runs).
- **Parity:** 142 static tokens share a name between DS `tokens.css` and DV and have identical values (build-enforced).
- **Contrast:** 28 pairs verified in the dashboard; the 3 failing pairs are documented rules (muted text on Blush, strong border on Blush; small button is a size note).
- **Structure/a11y (browser scan):** no duplicate ids, no broken ARIA references, no unlabeled controls, no unnamed buttons/links, correct heading order (no skipped levels), `lang` and `<title>` present on both pages, no horizontal overflow at 320–1920px.
- **DS components** cover buttons, icon buttons, links, inputs/selects/textarea, checkbox/radio, validation, quantity, swatches, badges, messages, price, rating, cards, product card, dividers, icons; mobile-first, `min-width` queries only (0 `max-width` queries in any CSS).
- Docs numbers spot-checked against code: typography clamp min/max (9 tokens), icon count (24), file sizes, 28 contrast pairs, 46 checks.

## C. Findings

Severity: **Critical / High / Medium / Low**. "Now" = safe to implement in this phase; "Decision" = needs your judgment.

### C1. Confirmed bugs and inconsistencies

| ID | Sev | Finding | Evidence | Action |
|---|---|---|---|---|
| F01 | Medium | Dashboard has 7 horizontally scrollable table regions that keyboard users cannot reach or scroll (WCAG 2.1.1) | Browser scan @390: `scrollNoFocus` = 7 × `.pv-tablewrap` | **Now** |
| F02 | Low | Dashboard has no `h1`; DS showcase has two (hero + the "Heading one" type specimen) | Scan: DV `h1: 0`, DS `h1: 2` | **Now** |
| F03 | Medium | DS says every tap target ≥ 44px, but `.btn--sm` is 40px and is used for quick-add on mobile product cards | Scan: `btn--sm` 292×40, 163×40 @390; `docs/accessibility.md`; `index.html` product cards | **Now** (coarse-pointer rule); confirm in D5 |
| F04 | Low | `.hide-mobile` / `.hide-desktop` are unused and incorrect (`display: initial` turns flex/grid into inline) | `base.css` end; unused-class scan; 0 uses in html/js/docs | **Now** (remove) |
| F05 | Medium | Docs claim stepped DV type is "within 3px" of the DS fluid scale. True only at the 3 sample widths (max 2.6px). Elsewhere it diverges: display up to 9.6px at 1000px (DS 65.6 vs DV 56) and 8px at ≥1440px; h1 6px at ≥1440px | Fluid-vs-stepped table at 360/768/1280/1440/1920 and @600/@1000; claim in DV `README.md` and `usage-guide.md` | **Now** (correct docs, add automated delta report); model choice is D2 |
| F06 | Medium | DV has no inverse-surface tokens. The default focus ring (Deep Rose) on Charcoal is **2.3:1** (needs 3:1); the DS handles this only through `.surface-inverse`. A dark footer or promo bar built from DV tokens would have a failing focus indicator | Contrast computed: rose on charcoal 2.3:1; blush 12.11:1; `.surface-inverse` exists only in DS `tokens.css` | **Now** (5 tokens + pairs) |
| F07 | Low | Product-card focus visibility relies on `:has()`; browsers without it get no focus indicator on the title link | `components.css`: `.product-card__title a:focus-visible { outline: none }` + `:has()` ring | **Now** (`@supports` fallback) |
| F08 | Low | Product-card positioning declared three times (`position: relative` then `absolute` again) | `components.css` product-card block | **Now** (tidy) |
| F09 | Medium | Dashboard shows only the file for a token (not its JSON path), only the first 5 mismatches, and no usage information | `preview.js` `runValidation` (`slice(0,5)`); token table columns | **Now** |
| F10 | Medium | Verification is not reproducible from the repo. The all-tier browser test used so far was ad hoc; the builder has no cycle check; the dashboard validates only the live tier | `build-tokens.ps1` (no cycle detection; deep recursion in `Lit`/`Disp` on a cyclic alias); no test script in repo | **Now** (`test-tokens.ps1`, cycle check, delta + unused report) |

### C2. Architecture and duplication

| ID | Sev | Finding | Evidence | Action |
|---|---|---|---|---|
| F11 | **High** | **Two parallel token sets for the same decisions.** DS `tokens.css` (fluid type, hardcoded component sizes) and DV JSON (stepped type, component tokens). 11 responsive tokens share a name but intentionally differ; the DS hardcodes at least 12 component dimensions that DV tokenizes (checkbox 1.375rem, quantity input 3rem, swatch 2rem, textarea 7rem, check 1rem, dot 0.625rem, count bubble 1.125rem, …); the two sets of docs describe different edit workflows (DS: edit `tokens.css`; DV: edit JSON and rebuild) | `audit2`: DS-only names, hardcoded-literal scan; `docs/tokens.md` vs DV `usage-guide.md` | **Decision D1.** Interim: cross-reference notes, extended parity checks |
| F12 | Info | DV component tokens are mostly shallow aliases of global tokens (e.g. `--button-height-md` → `--control-height-md` → `3rem`) and their only consumer is the dashboard; real DS components do not use them | Usage scan: 108 of 378 tokens not statically referenced; DS components.css has none of the `--button-*`, `--input-*`, `--choice-*` names | **Decision D1/D3**; no change |
| F13 | Info | 126 composite type-role tokens = 33% of the system (18 are `text-transform: none`). Coherent (one place defines each text style) but heavy | Token counts by file | **Decision D3**; no change |

### C3. Missing items

| ID | Sev | Finding | Action |
|---|---|---|---|
| F14 | Medium | Foundations are implied by code but not documented: imagery / product photography guidance, motion principles, interaction-state rules, elevation usage, grid/container usage, component coverage and boundaries | **Now:** `docs/foundations.md` |
| F15 | Medium | Components required by foreseeable storefront features have no implementation: **accordion** (PDP details, ingredients), **breadcrumb**, **pagination**, **filter chips** (active filters) | **Now** (reusing existing tokens only) |

### C4. Unnecessary or speculative items

| ID | Sev | Item | Why | Dependencies checked | Action |
|---|---|---|---|---|---|
| F16 | Low | DV `layout.announcement-height` | Fixed height for text that can wrap; contradicts the content-driven rule; no consumer | Only generated docs/data | **Remove** |
| F17 | Low | DV `aspect.hero` (4:5 / 3:2 / 16:9) | Page-specific hero decision, not in DS, no consumer; belongs to wireframe phase | Dashboard renders all `aspect-*` by loop only | **Remove** |
| F18 | Low | DV `grid.columns.page / collections / features / blog / footer` | Page layouts decided in the wireframe phase; the DS has no 12-col grid; no consumer. Keep `grid.columns.products` (matches DS) | Dashboard loops `grid-columns-*`; docs counts | **Remove 5** |
| F19 | Low | DV `input.select-padding-right`, `product-card.action-offset` | Pure aliases of `--space-12` / `--space-1`; DS does not use them; no consumer | none | **Remove 2** |
| F20 | Info | DS tokens never referenced: `--bp-*` (reference values), `--z-base/dropdown/overlay/drawer/modal/toast` (reserved for drawer/modal/toast, not yet built), `--header-height`, `--color-border-disabled`, `--space-0`, `--radius-none`, `--letter-spacing-normal` | Scale members or reserved; not harmful | **Keep**; documented. `--header-height` and `--color-border-disabled` flagged for D3 |

### C5. Future development risks

| ID | Sev | Risk | Evidence | Action |
|---|---|---|---|---|
| R1 | Medium | Font swap can shift layout: self-hosted with `font-display: swap`, no metric-matched fallback (`size-adjust`) | `tokens.css` `@font-face` | Document; needs measurement (not changed) |
| R2 | Medium | Shopify merchant colour schemes are scoped per section; DV defines only `:root` | `variables.css` | **Now:** document scope pattern; inverse tokens added (F06) |
| R3 | Low | Breakpoints (600/1024) are literals duplicated across files: tokens 1+1, base 1+2, components 1+1, DS preview 2+5; generated DV css 4+4 | Literal count | Document; inherent to CSS |
| R4 | Medium | Stepped type changes at 600 and 1024px | F05 | **Decision D2** |
| R5 | Low | Dashboard fonts load from `../../assets/fonts/`; breaks silently (falls back) if the DS folder moves | `preview.css` | Documented; relevant to D4 |
| R6 | Medium | Structure differs from the agreed layout: no `design-system/` folder | `Test-Path design-system` = False | **Decision D4** |
| R7 | Low | `@font-face` URLs are relative (`../fonts`); Shopify requires flat `assets/` | `tokens.css` | Documented (DS README) |

## D. Component coverage classification

Required **now**: implemented (accordion, breadcrumb, pagination, filter chip). Already covered: button, link, inputs, validation, checkbox/radio, quantity, swatch, badge, price, rating, card, product card, product image container, divider, message.

| Item | Classification | Reason |
|---|---|---|
| Header / navigation / mobile menu / footer | Page-level section (Shopify section) | Composition of existing tokens; layout depends on wireframes |
| Filter / sort **drawer**, cart drawer | Required for foreseeable features, **but not now** | Behavior (JS, focus trap, side vs bottom sheet) and contents come from wireframes. Tokens already reserved: `--z-drawer`, `layout-drawer-width`, scrim |
| Tabs | Unnecessary now | Accordion covers PDP info on all sizes; tabs add ARIA/JS complexity |
| Search + autocomplete | Required later, JS-dependent | Native `<input type="search">` + Shopify predictive search; not a styling gap |
| Cart feedback / toast | Better handled by existing `.message` or cart drawer | Decide with cart design |
| Promotional banner | Pattern | `.surface-inverse` + `.text-utility` |
| Loading skeleton | Unnecessary now | Not needed by the OS 2.0-style flow; add only if filters/cart go async |
| Empty / error / success / disabled states | Pattern + existing states | `.message`, disabled variants, `.field--error`; empty search is page content |
| Reviews list, wishlist page, ingredient lists | Page-specific / app content | Not design-system |

## E. Decisions needing your judgment (identified up front)

- **D1** Single token source: should `design-variables` become canonical, with the DS consuming the generated CSS and its hardcoded component sizes migrated (recommended), or stay two sets with parity checks?
- **D2** Type model: stepped per tier (DV) or fluid (DS) for the theme?
- **D3** Keep or trim shallow-alias component tokens, the 18 `text-transform: none` role tokens, and unreferenced DS tokens (`--header-height`, `--color-border-disabled`)?
- **D4** Move the Design System into `design-system/` (the agreed structure)?
- **D5** Confirm 44px small buttons on touch devices (implemented as the default).
- **D6** Confirm Blush as the focus ring on dark surfaces (12.1:1; DS already does this).

---

# Part 2: Implementation record, validation and readiness

## F. Additional findings made while implementing

| ID | Sev | Finding | Evidence | Status |
|---|---|---|---|---|
| F24 | **High** | **The Design System's `.surface-inverse` was broken for focus, secondary buttons and inputs.** Custom-property aliases resolve where they are declared, so re-mapping `--color-focus-ring` etc. inside the scope did not update the tokens built from them. On dark surfaces: the focus ring stayed Deep Rose (2.3:1, fails 3:1) although the docs said Blush; the secondary button border was Charcoal on Charcoal (invisible; hover did nothing); input text was Ivory on a white field (unreadable) | Browser probe of a link, a `.btn--secondary` and an `.input` inside `.surface-inverse`: ring `rgb(143,63,80)`, border `rgb(36,32,31)`, input text `rgb(250,247,242)` on `rgb(255,255,255)` | **Fixed** (DS) and **prevented** (DV generates scopes with dependents) |
| F25 | Medium | Opening the DS showcase directly from disk logged CORS console errors for both fonts: the `<link rel="preload" … crossorigin>` hints cannot be fetched from a `file://` origin. This contradicts the original "no console errors" requirement. **My earlier statements that console output was clean covered only the dashboard, not the DS showcase** | Direct load, plain `file://`: 6 console lines; after removing the tags: 0, with a positive control confirming the logger reports errors | **Fixed** (preload removed from the showcase; documented as a theme recommendation) |
| F26 | Medium | The builder silently skipped the Design System parity check when `tokens.css` was not found (exit 0). Moving the Design System folder would have disabled the check unnoticed | Negative test on a copy: exit 0 with checks skipped | **Fixed**: now exit 4 unless `-AllowMissingDesignSystem`; also looks in `design-system/` |
| F27 | Low | The DS showcase "Removable chip" markup used a chevron instead of a close icon (my own error, caught in visual review) | Screenshot | **Fixed** |

## G. Changes implemented

### Design System (existing files changed; nothing deleted except two faulty utilities)

| File | Change |
|---|---|
| `assets/css/tokens.css` | `.surface-inverse`: re-declares `--focus-ring`, muted text, control background/borders and secondary-button colours so the scope actually works (F24) |
| `assets/css/base.css` | Removed unused, incorrect `.hide-mobile` / `.hide-desktop` utilities; replaced by a comment pointing to the component-level pattern (F04) |
| `assets/css/components.css` | `.btn--sm` grows to 44px on `pointer: coarse` (F03); product-card position tidy and `@supports not selector(:has(*))` focus fallback (F07, F08); **new** `.accordion`, `.breadcrumb`, `.pagination`, `.chip` (F15), using existing tokens only |
| `index.html` | One `h1` (F02); new "Navigation & disclosure" section and nav link, sections renumbered; dark-surface demo with a secondary button and input; "Deep Rose on Charcoal" contrast row; font preload tags removed (F25); chip icon fix (F27) |
| `assets/js/preview.js` | Demo toggle for filter chips |
| `docs/foundations.md` | **New**: brand principles, grid, borders/radius/elevation, iconography, imagery and photography guidelines (proposed), interaction and motion, responsive-navigation pattern, what belongs where, component coverage (F14) |
| `docs/components.md`, `accessibility.md`, `typography.md`, `README.md`, `tokens.md` | Four new components; touch rule; verified vs unverified items; Deep Rose on Charcoal; preload note; relationship to `design-variables/` and the open single-source decision; layout-helper override hooks |

Not touched: fonts, icons, `scripts/build-icons.ps1`, `assets/css/preview.css`.

### Design Variables

| File | Change |
|---|---|
| `tokens/layout.json` | Removed `announcement-height`, `aspect.hero`, and five page-layout grid columns (`page`, `collections`, `features`, `blog`, `footer`); `header-height` documented as min-height (F16–F18) |
| `tokens/components.json` | Removed `input.select-padding-right`, `product-card.action-offset` (F19) |
| `tokens/semantic.json` | **Added** 6 inverse-surface tokens (`text.inverse-secondary`, `border.inverse`, `border.inverse-subtle`, `link-inverse`, `link-inverse-hover`, `focus.ring-inverse`) and a `$scopes` definition for `.surface-inverse` (F06, F24) |
| `tokens/build-tokens.ps1` | Alias-cycle detection; scope generation with automatic re-declaration of dependent tokens; JSON path and static-reference data for the dashboard; fluid-vs-stepped measurement with tolerances (exit 3); Design System required (exit 4); reads `design-system/` too (F10, F16, F26) |
| `tokens/test-tokens.ps1` | **New**: headless-browser test of every token at 6 widths, the dark-surface scope, the dashboard (3 widths) and console output of both pages (F10, F25) |
| `styles/variables.css`, `responsive-token-matrix.md`, `docs/token-reference.md` | Regenerated: 378 → **375** tokens (−9 removed, +6 added), responsive 32 → **26** |
| `preview/index.html`, `preview.css`, `preview.js` | One `h1`; keyboard-focusable scroll regions (F01, F02); source (file › JSON path) and static-reference columns, "Not referenced" filter, full mismatch table, 6 inverse contrast pairs (34 total), info row for unreferenced tokens (F09) |
| `README.md`, `docs/usage-guide.md` | Corrected the "within 3px" claim (F05); commands, exit codes, generated dark-surface scope, updated counts and limitations |

## H. Items intentionally not added

- **Drawers (filter, cart, menu), toast, tabs, search/autocomplete, skeleton loaders, header, footer, mega-menu, promo banner CSS, cart line items, reviews, wishlist:** see the coverage table in `docs/foundations.md` for the reason for each (JS-dependent and wireframe-driven, native/Shopify feature, pattern of existing parts, or page-level section). Layering, scrim and drawer-width tokens already exist for the drawers.
- **A 12-column grid, collection/footer/feature/blog column tokens, hero aspect ratio:** page-layout decisions for the wireframe phase.
- **`size-adjust` font fallbacks, reduced-motion token overrides, a Shopify theme:** need measurement or belong to the theme phase.
- **Merging the two token sets or removing shallow-alias component tokens:** changes the architecture; left for D1/D3.
- **No unused DS token was deleted** (scale members and reserved layers; see F24 in Part 1, now F-ref "C4 note").

## I. Validation results (all executed)

| Check | Result |
|---|---|
| All 8 token JSON files parse | Pass |
| Builder: aliases resolve, no duplicates, no cycles, 142 shared tokens equal the DS, fluid-vs-stepped within tolerance at sample widths | Pass (exit 0) |
| Builder negative tests (cycle, unresolved alias, duplicate name, missing mobile, parity mismatch, tolerance breach, missing DS, DS under `design-system/`) | Each produced the expected exit code (1, 1, 1, 1, 2, 3, 4, 0) |
| Browser: 375 tokens at 320/599/600/1023/1024/1440px vs JSON | 0 mismatches at every width |
| Browser: `.surface-inverse` scope (6 checks) | Pass; sabotaging only the generated `--focus-ring` re-declaration failed exactly the focus-ring and light-surface checks |
| Browser: dashboard at 390/768/1440px | 52 checks, 0 failures; no overflow; one `h1`; no duplicate ids; scroll regions focusable; simulator columns 2/3/4 |
| Browser: console output, dashboard and DS showcase opened from disk | 0 lines (a positive control logged 1) |
| Structural scan of both pages at 320/390/768/1280/1920px | No duplicate ids, broken ARIA references, unlabeled controls, unnamed buttons/links, skipped headings; one `h1` each; no overflow |
| CSS brace balance (6 files); broken `var()` references (both sections) | Balanced; none (the two `--cluster-*` names are optional hooks with fallbacks) |
| DS: fonts, icons, scripts, `preview.css` unchanged | Confirmed by modification time |

**Not run or not verifiable here:** `@media (pointer: coarse)` and `@supports not selector(:has())` behavior (headless Chrome uses a mouse pointer; the fallback cannot trigger in current browsers); screen readers and keyboard walkthroughs of the new components; Safari and Firefox; real devices; `<details name>` exclusivity support; `scripts/build-icons.ps1` (unchanged, not re-run, to avoid touching 25 icon files); any behavior inside a real Shopify theme; whether `docs/foundations.md` imagery guidance suits the brand (proposed).

## J. Decisions for you

| # | Decision | Recommendation |
|---|---|---|
| D1 | **Single token source.** Keep two sets, or make `design-variables` canonical and have the Design System consume its CSS (migrating the DS's hardcoded component sizes to tokens)? | Make `design-variables` canonical before the theme build. Today every shared change must be made twice (the build guards it) |
| D2 | **Type and spacing model:** stepped per tier, or fluid? Stepped diverges from fluid by up to ~10px (type) and ~14px (spacing) between samples | Choose one for the theme. Fluid is smoother; stepped is more explicit. If fluid, drop the stepped type tokens |
| D3 | Keep or trim shallow-alias component tokens, the 18 `text-transform: none` role tokens, and unreferenced DS tokens (`--header-height`, `--color-border-disabled`)? | Trim only after D1; they are harmless now |
| D4 | Move the Design System into `design-system/`? | Yes, to match the agreed structure. The builder and test already look there; the dashboard's three font URLs need updating |
| D5 | Small buttons and chips become 44px on touch screens | Keep (implemented) |
| D6 | Blush focus ring and links on dark surfaces | Keep (implemented, 12.1:1) |
| D7 | Visual approval of the four new components and the **proposed** imagery/motion guidelines | Review in the showcase and `docs/foundations.md` |
| D8 | Was removing the 5 page-grid column tokens, the hero ratio and the announcement height acceptable? | They can return in the wireframe phase if needed |

## K. Readiness assessment

**Design System: ready for the next design phase (wireframes).** Foundations, tokens and the components a collection page, product page and form need are in place and tested at 320–1920px; the accessibility defects found (dark-surface focus/buttons/inputs, 40px touch buttons, console errors, heading structure) are fixed. It is *not* verified on real devices, with assistive technology, or in Safari/Firefox, and the filter/cart drawers are deliberately deferred until wireframes define them.

**Design Variables: ready as a reference for wireframes now; ready to be the theme's token source only after D1 and D2.** The JSON, CSS, dashboard and tests are consistent and reproducible (375 tokens, all verified at all tiers). The unresolved issue is architectural, not a defect: two parallel token sets with different responsive models. Nothing blocks wireframing, but resolving D1 and D2 should precede Shopify theme development.


---

# Part 3: Resolving decisions D1 to D8

*Paths in Parts 1 and 2 are as they were at the time (the Design System was at the project root). Part 3 moves it to `design-system/`.*

## 3.1 Plan, recorded before any edit

Evidence inspected: the audit's Parts 1 and 2; every `var()` the Design System (DS) uses against the canonical tokens; the DV component-alias table with DS and dashboard consumers; the text-transform role tokens; the 14 unreferenced DS tokens (direct, aliased and documented use); every reference to the tokens removed in D8; every path that points into the DS.

| # | Intended change | Key evidence |
|---|---|---|
| **D4** (first, so everything else lands in final paths) | Move `index.html`, `assets/`, `docs/`, `scripts/` into `design-system/`. Update the dashboard's font URLs, the builder, the test and every doc reference. Keep `AUDIT-REPORT.md` at the root. Verify the final tree | Path scan: 3 font URLs in `preview.css`; builder and test already look in `design-system/`; `build-icons.ps1` resolves its root relative to itself |
| **D1** | `design-variables` is the only token source. The DS links `variables.css` instead of defining tokens. `assets/css/tokens.css` is replaced by `foundation.css` holding only `@font-face` (the DS owns the font files) and a short, documented **deprecated-alias** block for the names that are renamed. DS CSS moves to canonical names and to component tokens for its hardcoded sizes. The builder's "parity" check (two sets) is replaced by a DS **consumption** check (no duplicate definitions, every `var()` resolves). A propagation test proves a JSON change reaches the DS with no second edit | DS uses 157 properties; only 7 are not canonical: `--gutter`, `--grid-gap`, `--section-space`, `--grid-cols-products`, `--line-height-display` and two optional hooks (`--cluster-gap`, `--cluster-align`) with fallbacks |
| **D2** | Hybrid: **type is fluid** (the 9 approved `clamp()` values kept exactly, so rendered sizes are unchanged); **spacing scale stays static**; semantic spacing stays **stepped by tier** (gutter, grid gap, stacks); **one documented fluid spacing**: section padding. Fluid tokens are validated by the builder and documented with their pixel size at 7 widths. Gutter and grid gap change from fluid (DS) to stepped (DV): a small, measured, documented change | Fluid-vs-stepped measurement from the audit; DV already defines the stepped spacing |
| **D3** | Remove 20 redundant component aliases that restate a control or global token with no component intent; keep aliases with component-level intent. Remove the 18 `text-transform: none` role tokens, keep the 3 uppercase ones. Remove `color.border.disabled` (no use anywhere). Keep reserved `z-*` layers, scale members and tokens aliased by another token. Migrate the DS typography classes to the composite role tokens so those tokens have a real consumer. Document deprecated names with their replacements | DS consumes none of the 20 aliases; role tokens had 0 DS uses (92 dashboard); `--color-border-disabled` aliased by nothing |
| **D5** | 44 × 44px default. Small button and chip keep a 40px visual and get a 44px hit area (`::after`) plus a minimum width, replacing the touch-only media rule. A browser audit measures every interactive element (box or hit area) and lists the justified exceptions | Audit scan: 40px `.btn--sm` and `.chip` |
| **D6** | Blush stays the focus ring **on dark surfaces**. It cannot be the default on light surfaces (about 1.2:1 on Ivory), so Deep Rose stays the light-surface ring: the "accessible alternative" the decision allows. Measure ring contrast on every light, tinted, dark and brand surface; add a focus-on-surfaces panel to the dashboard; test the real rendered outline per surface | Computed contrasts to be recorded |
| **D7** | The four components are **accordion, breadcrumb, pagination and filter chip** (audit F15). Review each; keep all four (distinct use cases, no overlap); add product-image crop/position tokens and extend the imagery guidance; defer the subjective choices with options | Audit F15; Part 2 section G |
| **D8** | Keep the removals. Document each as page-specific (hero ratio, announcement bar) or wireframe-phase (page grids) in the DS foundations doc with proposed values, rather than as global tokens. Page-grid tokens return only when a global layout consistency need is shown | DS has no 12-column grid; nothing references the removed tokens |

Safety net: before any edit, snapshot the DS's computed styles (about 1,500 elements, 20 properties, at 360, 768 and 1280px). After the changes, compare. Every difference must be an intended one.


## 3.2 Results by decision

### D1: One canonical token source
**Decision:** `design-variables/` is the only token source. `design-system/` links `variables.css` and defines no tokens.
**Changed:** `design-system/assets/css/tokens.css` removed and replaced by `foundation.css` (3 `@font-face` blocks and 9 deprecated aliases only); `base.css`, `components.css`, `preview.css`, `preview.js`, `index.html` migrated to canonical names and component tokens; `design-variables/tokens/build-tokens.ps1` (DS consumption check replaces the old two-set parity check), `test-tokens.ps1` (propagation test); docs on both sides.
**Retained / added / modified / removed:** retained every Design System component and showcase; added the consumption check, the propagation test, `foundation.css`; modified the type classes to use the composite role tokens (the role is defined once) and 20 hardcoded component sizes to use component tokens; removed 171 duplicate token definitions (`tokens.css` re-declared 171 canonical tokens before the migration).
**Evidence:** before: the consumption check reported 171 problems against the unmigrated Design System. After: 271 canonical tokens used by Design System code, 0 defined, 0 deprecated aliases used, 0 problems.
**Validated:** propagation test (temporary copy, brand color edited in the JSON, rebuilt): builder exit 0; Design System files byte-identical; the DS primary button computed `rgb(18, 52, 86)`; original project untouched. Negative tests: a DS-defined token, a deprecated alias, an undefined property, a bad alias and a literal alias each exit 5; a fallback is allowed; a missing DS exits 4. Style snapshot (1,341 elements at 360, 768, 1280px): no typography, color, radius, shadow, margin or opacity change.
**Open:** the 9 deprecated aliases stay until the theme phase (remove then).

### D2: Hybrid responsive strategy
**Decision:** type fluid (the 9 approved `clamp()` values, unchanged); spacing scale static and the default; semantic spacing stepped by tier; one documented fluid spacing, section padding; tier tokens only with a stated reason.
**Changed:** `typography.json` (9 sizes to `clamp()`), `spacing.json` (`section` fluid), `layout.json`, `components.json` (tier values removed where unjustified); builder (fluid parsing and validation, fluid section in the matrix); dashboard (fluid sizes, simulation at reference widths); docs.
**Retained / added / modified / removed:** retained approved type exactly; added fluid validation (format, min < max, font minimum ≥ 16px) and a pixel table at 7 widths; modified gutter and grid gap from fluid (Design System) to stepped; removed unjustified tiers: `control.height-lg`, `control.padding-x`, `control.padding-x-lg`, `product-card.gap`, `form.field-gap`, `thumb-size`, `drawer-width` became static at the Design System's shipped values; `header-height` and `card.padding` now match the Design System's shipped two-step behavior. Tier tokens went from 26 to 5.
**Evidence:** measured change: container padding 24.9 to 24px at tablet and 36.2 to 40px at desktop; grid gap 16.3 to 16, 21.2 to 24, 27.4 to 32px (at most 4.6px). Type: zero difference.
**Validated:** all 333 tokens match the JSON at 6 widths (fluid values compare their `clamp()` string); dashboard simulator and monotonic checks pass; 3 negative tests for malformed fluid values exit 1.
**Open:** confirm the gutter and gap change visually (at most 4.6px). h5 and body large change by only 2px over the whole range; they stay fluid so every scaled size shares one formula, and could be made fixed if you prefer.

### D3: Aliases, text-transform and unused tokens
**Decision:** remove redundant aliases and the `none` text-transform tokens; keep intent-bearing aliases and reserved tokens; document migrations.
**Changed:** `components.json`, `typography.json`, `semantic.json`, `spacing.json`; dashboard references; `usage-guide.md` (full removal and migration table).
**Removed (checked for direct and indirect references first):** 20 component aliases that restated a global token (the Design System used none; the dashboard did, and was remapped), 18 `text-transform: none` role tokens (kept the 3 uppercase ones; the Design System now consumes the role tokens), `color.border.disabled` (aliased by nothing), `space.section-sm` and `space.stack-sm/md/lg` (no consumer outside the dashboard, no layout reason).
**Kept:** component aliases with their own intent, the reserved `--z-*` layers, scale members, `--letter-spacing-normal` (role tokens use it), `--header-height` (planned header; now `--layout-header-height`). Also removed: `--transition-shadow` (unreferenced, no planned use).
**Evidence:** Design System unreferenced tokens were 14 direct; checked aliasing and documented plans: `--bp-*` and `--header-height` were renamed (aliases kept), `--color-border-disabled` removed, `--z-*` reserved for planned drawers, `--space-0`/`--radius-none` scale members. Static usage is now 21 of 334 tokens unreferenced anywhere, all scale members, reserved layers or intent tokens.
**Validated:** no dangling `var()` in either section (builder DS check; dashboard scan); dashboard 59 checks pass; JSON valid.
**Open:** none required. 15 tokens have no static reference; each is a scale member, a reserved layer for planned drawers, an intent token, a composite role member, or read at runtime (the 3 breakpoints). The first scan reported 21: 5 were used by the generated `.surface-inverse` scope (the scan now counts scope references), and `--transition-shadow` was removed as genuinely unused. The Design System now also uses `--transition-colors` and `--transition-transform` instead of repeating their values.

### D4: Normalize the folder
**Decision:** the Design System moved into `design-system/`.
**Changed:** `index.html`, `assets/`, `docs/`, `scripts/` moved with `Move-Item` (41 files, none overwritten, no stale copy at the root); dashboard font URLs; builder and test paths; every doc reference; new root `README.md`.
**Evidence:** final tree: root = `design-system/`, `design-variables/`, `AUDIT-REPORT.md`, `README.md`. `build-icons.ps1` ran from its new location (24 icons; a second run changed nothing; the sprite inlined in `index.html` equals `sprite.svg`).
**Validated:** full browser test, builder, scans (see 3.3). **Not available:** file history. The project is not under version control, so there is no history to preserve; the move preserved every file's content.
**Open:** none.

### D5: 44 × 44px touch targets
**Decision:** 44px is the default target, as a box or an invisible hit area; documented exceptions.
**Changed:** `components.css` (small button and chip: 40px visual, `::after` hit area, minimum width; `.link--standalone`; `.link--arrow` and breadcrumb links sized; the touch-only media rule removed), `preview.css`, `index.html`, dashboard CSS and a new hit-area validation, docs, `test-tokens.ps1` (audit).
**Evidence:** measurement found two real defects in the first implementation: the hit area was 42px (an absolutely positioned box ignores the border; fixed by compensating for it), and 8 standalone elements were 24 to 32px (the showcase logo link, 6 standalone links, a 38px-wide breadcrumb link); all fixed.
**Validated:** the audit measures 94 interactive elements at 390 and 1280px: 0 below 44px. Exceptions recorded: inline links in sentences, disabled controls, the skip link, decorative mini swatches.
**Not verified:** behavior on a real touch device.

### D6: Focus ring
**Decision:** Blush is the ring on dark surfaces; Deep Rose is the accessible alternative on light surfaces (Blush is 1.25:1 on Ivory, 1.33:1 on White). The decision text could also be read as "Blush everywhere"; that cannot meet 3:1 on light surfaces, so this interpretation is the one that satisfies the decision's own accessibility condition.
**Changed:** dashboard focus-on-surfaces panel and validation group; `foundations.md` section 9; `accessibility.md`; tests.
**Evidence (real keyboard focus, rendered outline):** 2px solid, offset 2px; Ivory 6.56, White 7.01, Blush 5.26, brand tint 5.98, tint strong 4.96, error tint 6.13, success tint 6.18, warning tint 6.25, dark (Blush ring) 12.11; Deep Rose fill with the default ring 1.00 (not permitted; Blush ring 5.26). The ring is an outline shape, not a color change alone.
**Validated:** dashboard validation group and visual review of the panel. A bug in my first measurement (it read the outline style after blurring) was found and fixed.
**Not verified:** a person tabbing through each component, screen readers, forced-colors mode, focus over photography.

### D7: Four components and imagery guidance
**The four components** (audit F15): filter chip, breadcrumb, accordion, pagination. Reviewed for use case, overlap, variants, states, responsive and accessibility; all kept (table in `design-system/docs/components.md`). No other component was invented or approved.
**Changed:** chip hit area (D5), breadcrumb link width, `components.md` review, `foundations.md` sections 6 and 14, new tokens `--product-image-position`, `--icon-button-count-size`; `.ratio` now uses the aspect, fit, position and background tokens.
**Imagery extended:** ratios with class and token names, crop and `object-position` with a per-image focal point, responsive delivery (`srcset` widths, `sizes` mirroring the grid, loading and priority, art direction), fallbacks (missing image, alt text, sold out, over photography). Marked proposed.
**Deferred (needs your judgment):** breadcrumb on phones (full trail vs back link), filter chip row (wrap vs scroll), accordion exclusivity, numbered pagination vs "Load more", each with options and a default.
**Validated:** the components pass the structural scan and the touch audit; their keyboard and screen-reader behavior is native but not tested with assistive technology.

### D8: Page-grid tokens, hero ratio, announcement height
**Decision:** keep removed as global tokens; relocate to documentation.
**Evidence (references inspected):** after the audit's removal, the only references were in the audit report itself; the Design System has no column grid and nothing used the tokens.
**Classification:** page grids = page-specific, decided with wireframes; hero ratio = page-specific section value; announcement height = a fixed height for wrapping text, a layout-instability risk if kept.
**Changed:** `foundations.md` section 12 records each with a proposed value and where it belongs (a section-level `--hero-ratio`; content-driven announcement bar; the generic `.ratio--wide` already exists). `--grid-columns-products` and the static `--layout-drawer-width` remain.
**Validated:** no dangling references; dashboard and tests pass.
**Open:** none; they can return as global tokens if wireframes show a layout-consistency need.

## 3.3 Validation (all executed on the final files)

| Check | Result |
|---|---|
| 8 token JSON files parse | Pass |
| Builder: aliases, no duplicates, no cycles, fluid values valid, DS consumption (271 used, 0 problems) | Pass, exit 0 |
| Builder negative tests (DS defines a token, deprecated alias, undefined property, bad alias, literal alias, missing DS, malformed fluid, font minimum, min above max) | Expected exit codes 5, 5, 5, 5, 5, 4, 1, 1, 1; fallback allowed (0) |
| Browser: 333 tokens × 6 widths | 0 mismatches |
| Browser: `.surface-inverse` scope (6 checks) | Pass |
| Browser: dashboard at 390 / 768 / 1440px | 59 checks, 0 failures, no overflow |
| Browser: Design System touch targets | 94 measured, 0 below 44px |
| Browser: propagation test (5 checks) | Pass |
| Console output, dashboard and Design System opened from disk | 0 lines |
| Style snapshot, 1,341 elements × 3 widths, before vs after | No typography, color, radius, shadow, margin or opacity change; only the intended gutter and grid gap |
| Structural scan, both pages, 320 to 1920px | No duplicate ids, broken ARIA references, unlabeled controls, unnamed buttons or links, skipped headings, overflow; one `h1` each |
| CSS brace balance, mojibake scan, dangling references | Clean |
| `build-icons.ps1` from its new location | Runs; second run changes nothing; sprite consistent |

**Not run or not verifiable here:** a real touch device; screen readers; Safari and Firefox; forced-colors mode; a person tabbing through each component; behavior inside a Shopify theme; the `@supports not selector(:has())` fallback (cannot trigger in current browsers).

## 3.4 Problems found and fixed during this phase

- **`design-system/assets/css/base.css` contained double-encoded characters** (each em dash and arrow in its comments had become three stray characters) from one of my earlier edits (PowerShell 5.1 read a UTF-8 file as ANSI). Found by chance while reading the file; repaired exactly and every other file scanned clean.
- **The 44px hit area measured 42px** (see D5). **The focus measurement read a live style object after `blur()`** (see D6). Both were found by running the checks, not by reading code.
- **The builder silently skipped its Design System comparison** if the Design System was missing (found in the previous phase; now exit 4).

## 3.5 Remaining items for your judgment

1. **D7 deferred choices** (breadcrumb on phones, chip row, accordion exclusivity, pagination vs "Load more"): options and defaults are in `design-system/docs/foundations.md`, section 14.
2. **Gutter and grid gap** changed from fluid to stepped (at most 4.6px): confirm visually.
3. **h5 and body large** stay fluid despite a 2px range: keep, or make them fixed?
4. **D6 interpretation** (Deep Rose ring on light surfaces, Blush on dark): confirm.
5. **Proposed, unapproved content:** the imagery and photography guidelines, the provisional drawer width (26rem) and thumbnail size (64px).
6. **Theme phase:** remove the 9 deprecated aliases; decide the drawers and the page grids with the wireframes.


---

# Part 4: Final validation and remaining decisions

## 4.1 Decisions finalized

| Item | Decision | Evidence |
|---|---|---|
| **Drawer width** | Changed from `min(100%, 26rem)` to `min(calc(100% - 44px), 26rem)`. The 26rem cap is **retained** | There is no drawer component (it is deferred), so the evidence comes from a specimen built from the token and measured at 8 viewport widths. Old value, same specimen: 2, 2, 2 and 14px of page left at 320, 360, 390 and 430px (no usable area to tap to dismiss). New value: 44px or more at every width. **[Corrected in Part 5: the specimen frame has a 1px border on each side, so the real strips were 0, 0, 0 and 12px, and this whole row is superseded by decision 5.]** Both: close button 44px and inside, no overflow, body scrolls, last row and footer reachable; 416px cap leaves 184px of page at 600px |
| **Thumbnail size** | **64px retained**; one size for all viewports | They are interactive buttons (the 64px box exceeds the 44px target; 8px gap). Four fit the narrowest supported width (4 × 64 + 3 × 8 = 280px in a 288px container); 72px fits three, 56px still cannot fit five. The rail scrolls without widening the page (measured). A square thumbnail of a 4:5 image keeps 80% of its height (computed from the tokens; the dashboard fails if that stops being true) |
| **Imagery guidance** | Extended | Added: the packaging canvas rule (4:5 canvas, product in the central 80%; raw extreme-ratio photos shown with `cover` crop to 42%, use `contain` as a per-image exception), hero and promotional imagery (reserved space, eager and high priority, scrim for text, no baked-in text, art direction only for the hero), thumbnail sizing and delivery (`srcset` 128/192/256), card-and-PDP consistency, an unavailable-image row. Retained: ratios, `object-fit`/`object-position` tokens, `sizes` mirroring the grid, fallbacks. No image dimension is hardcoded |
| **`:has()` fallback** | Reworked as progressive enhancement | The old fallback (`@supports not selector(:has(*))`) is ignored by exactly the browsers that need it. Now the link ring and the chip check mark are the default, and `:has()` inside `@supports selector(:has(*))` is the enhancement. Both CSS paths are tested |

## 4.2 Defects found and fixed in this phase

- **Forced colors (new emulation):** checked checkbox and radio marks vanished; every swatch showed a ring so the selected one was indistinguishable; the current pagination page and a selected chip looked the same as the others; breadcrumb separators vanished. Fixed with a `forced-colors` block. Two of my first probes passed falsely and were tightened.
- **Documentation damage from my own edits:** several earlier edits dropped content (a PowerShell argument-mode quirk silently discarded text after a `+`). `accessibility.md` had lost three contrast rows and two verified bullets that I had reported as present. Rewritten whole; other documents scanned for expected content.
- **Dashboard specimen overflow** at 390px (a grid column sized to its scrolling rail); fixed.

## 4.3 Commands run and outcomes (final files)

| Command | Outcome |
|---|---|
| `build-tokens.ps1` | Exit 0. 333 tokens (5 tier, 10 fluid, 318 static); Design System uses 271, defines none, 0 deprecated aliases used, 0 problems; 14 tokens with no static reference, all accounted for |
| `test-tokens.ps1` (Chrome, full) | **All passed.** 333 tokens × 6 widths, 0 mismatches; dark-surface scope 6/6; dashboard 70 checks, 0 failures at 390, 768, 1440px; console 0 (dashboard and showcase); 94 interactive elements 0 below 44px (exceptions documented); propagation 5/5; static checks (encoding in 60 files, CSS braces, JSON) pass |
| `test-tokens.ps1 -BrowserPath msedge.exe` (full) | All passed (after ignoring Edge's own extension console message) |
| `test-emulation.ps1` (Chrome) | **All passed:** phone viewport 390 × 844 at DPR 3 with touch (no overflow, 94 targets 44px, no hover effects), reduced motion, forced colors (9 checks), the no-`:has()` path (4 checks) |
| `test-emulation.ps1 -BrowserPath msedge.exe` | All passed |
| Style snapshot, 1,341 elements × 3 widths, vs the pre-decisions baseline | Only the intended gutter and grid-gap change (at most 4.6px); no typography, color, radius, shadow, margin or opacity change |
| `build-icons.ps1` | Exit 0; a second run changes nothing (verified earlier this phase) |

**Re-verification of the earlier fixes (each by reintroducing the bug in a throwaway copy):** the 42px hit area (hit area without the border compensation) made the touch audit fail with 11 elements at 42px; removing the focus rule made 10 focus-surface rows fail (so the measurement reads the real rendered outline, not a value read after blurring); reintroducing double-encoded text made the encoding check name the file. The forced-colors block removed made 6 checks fail; an unconditional `outline: none` on the card link made the no-`:has()` check fail.

## 4.4 What the available tools could and could not test

| Previously unavailable | Now |
|---|---|
| Real phone render and touch | **Emulated** (true 390px viewport, DPR 3, `pointer: coarse`, `hover: none`). Not a real device |
| Forced colors | **Emulated**, tested, defects fixed. Not a real Windows contrast theme |
| Reduced motion | **Emulated**, passes |
| `:has()` fallback | **CSS path tested** with the `:has()` branch disabled. No browser without `:has()` is available |
| Safari, Firefox | **Still unavailable.** Edge was run, but it is the same Chromium engine |
| Screen readers | **Still unavailable** |
| Shopify theme | **Still unavailable** (no theme exists yet) |
| axe / Lighthouse | **Still unavailable** (no Node installed) |

Manual instructions for everything still unverified: `design-system/docs/manual-testing.md`. Automated checks are Chromium-only, so this is **not** a production-readiness claim.

## 4.5 Observations not acted on

- A phone-emulation screenshot taken about 900ms after load showed the heading in the fallback serif (the `swap` web font had not loaded yet). The dashboard's own font check passes. Fallback metric matching (`size-adjust`) remains an open recommendation, not done.

## 4.6 Remaining items for your judgment

1. ~~D7 deferred choices: breadcrumb on phones, chip row wrap or scroll, accordion exclusivity, numbered pagination vs "Load more".~~ **Resolved in Part 5, decisions 1 to 4.**
2. ~~Drawer on phones: peek drawer or full-screen sheet.~~ **Resolved in Part 5, decision 5** (full-width sheet below 600px, awaiting owner approval).
3. The imagery and photography guidance is still **proposed**; approve or adjust, especially the 4:5 canvas rule with the product in the central 80%.
4. Gutter and grid-gap change from fluid to stepped (at most 4.6px), and h5 and body large staying fluid: confirm.
5. Run the manual tests (real phone, screen readers, Safari, Firefox, a real contrast theme) before any production claim.

---

# Part 5: Final decisions prepared for approval

Scope kept: no wireframes, no storefront, no folder moves or renames; the Design System and Design Variables stay separate; JSON stays canonical and `variables.css` is regenerated, never hand-edited. I inspected the code, tokens and docs for each decision first, measured, and changed only what the measurements supported. **Nothing below is approved by me or by a test; each "changed" item needs your approval.**

## 5.1 The eight decisions

Evidence key: **E** = automated check or measurement executed in Chrome/Edge this phase; **G** = geometry in a headless or emulated browser; **V** = I looked at a rendered screenshot; **M** = needs a person (see `design-system/docs/manual-testing.md`, section 7).

| # | Decision | Status | Change (files and tokens) | Evidence | Remaining limits and manual tests | Shopify dependencies |
|---|---|---|---|---|---|---|
| 1 | Breadcrumb on phones | **Changed**, awaiting owner approval | `components.css`: below 600px one line, parent plus truncated current page; full wrapping trail from 600px. Markup unchanged. No token | E/G: with a long name the full trail was 88px tall at 320 to 390px; now 44px with 215 to 283px of the name; truncation without hiding ancestors left 58px at 320px. 44px targets, no overflow. V at 390px | Ancestors are `display: none` on phones, so absent from the accessibility tree there. M: screen reader and phone | The theme must emit the same `nav > ol > li > a[aria-current]` markup from `breadcrumbs`/collection data |
| 2 | Filter chip row | **Changed**, awaiting owner approval | `components.css`: new `.chip-row` (scrolls below 600px, wraps from 600px); showcase markup uses it for the choice row; the applied-filters row stays `.cluster` | E/G: 8 chips = 196px (4 lines) wrapped, 48px as a scrolling row (58px with the thin scrollbar); 4px ring room and 2px hit-area room, nothing clipped; 4 to 6 chips cut off at the edge. V | Discoverability rests on the cut-off chip. M: swipe, Tab and screen reader | Chips come from `collection.filters`/`storefront filtering`; hidden chips must stay in the DOM order |
| 3 | Accordion | **Changed**, awaiting owner approval | `index.html`: removed `name="pdp"` from 3 rows (it made them exclusive, contradicting the documented default). No CSS or token | E: attribute count 3 to 0 | Exclusive stays a documented option; `name` support differs by browser. M: Safari and Firefox | Native `<details>`; no JavaScript needed |
| 4 | Pagination vs Load more | **Retained** numbered; phone form **provisional** | Docs only (`foundations.md` section 14: when to use each) | E/G: numbered pagination has 44px targets and no overflow; wraps to 2 rows (92px) at 320 to 390px | Needs your choice: keep the 2-row wrap or a compact "Previous, Page 2 of 12, Next". "Load more" is not built | `{% paginate %}`, `paginate.parts`, `?page=` URLs; Load more needs a real next-page link plus Section Rendering API |
| 5 | Filter drawer on phones | **Changed**, awaiting owner approval | `layout.json`: `layout.drawer-width` is a tier token (`100%`, `26rem`, `26rem`); generated into `variables.css`, matrix and token reference. Dashboard: frames now take their own width's tier; criteria changed; builder text now lists the token as a tier token | E: dashboard measures 8 widths: sheets fill the frame, panels are 416px with 182px or more of page; close button 44px and inside, body scrolls, last row and primary action reachable, no overflow. Sabotage: phones set to 26rem, or tablets set to 100%, each fail the dashboard (2 failures); restoring passes | A sheet has no strip to tap: close button and Escape are the exit. Focus trap, Escape, scroll lock, focus return are not built. M: real drawer with keyboard and screen reader | The drawer section/JS must implement the dialog behavior; `width: var(--layout-drawer-width)` on a panel anchored to the edge |
| 6 | Imagery and the 4:5 canvas | **Changed** (wording), awaiting owner approval | `foundations.md` section 6: 4:5 is the product-card canvas only, with a table of exceptions (hero, editorial, tiles, banners, promotions, thumbnails). `layout.json` description of `aspect.portrait`; `base.css` comment | E: ratios are tokens used by the showcase; the dashboard's packaging, crop (80%) and thumbnail checks pass | No real photography exists; the 60 to 80% fill rule and the PDP gallery sharing the card ratio are proposals. M: test on the first photo shoot | Shopify image URL filter and `srcset` per the guidance; focal point as `--image-position` |
| 7 | Gutter and grid gap | **Retained**, awaiting owner approval | None (description of `grid.columns.products` corrected, see 5.3) | E: computed gutters 16/24/40px match the tokens at 10 widths; 0 horizontal overflow in 20 page and width combinations (320 to 1920px); no card overflow down to 129px. Earlier snapshot: at most 4.6px from the previous fluid values | The margin steps at 600 and 1024px together with the columns. No real page reviewed | None beyond the theme using the same tokens |
| 8 | h5 and body-large fluid sizing | **Retained**, awaiting owner approval | None | E: 1,601 widths (320 to 1920px): monotonic; h5 16 to 18px, body large 17 to 19px; order h4 > body large > h5 >= 16px at every width; computed values equal the tokens at 6 widths in the browser | On phones h5 equals body size (16px) and differs by weight only; both move at most 2px, so fixing them would be a valid simplification | Theme CSS must use the same `clamp()` tokens |

## 5.2 Commands and checks run (final files)

| Check | Kind | Result |
|---|---|---|
| `build-tokens.ps1` | Automated | Exit 0: 333 tokens (6 tier, 10 fluid, 317 static); Design System uses 271, defines none, 0 deprecated aliases used, 0 problems; 14 tokens with no static reference (all accounted for) |
| Token JSON validity, alias references, duplicates, cycles, fluid values | Automated (builder) | Pass |
| JSON to CSS consistency | Automated (browser) | 333 tokens x 6 widths (320, 599, 600, 1023, 1024, 1440px), 0 mismatches |
| Generated output freshness | Automated | The builder was rerun and regenerated `variables.css`, the matrix, the token reference and the dashboard data; SHA-256 of all four generated files (`variables.css`, the matrix, the token reference, the dashboard page) is identical before and after a second builder run |
| `test-tokens.ps1`, Chrome | Automated + browser | **All passed**: dark-surface scope 6/6; dashboard 70 checks, 0 failures at 390, 768 and 1440px; console 0 lines (dashboard and showcase); touch targets 92 at 390px and 94 at 1280px, none below 44px; propagation 5/5; static checks (encoding in 60 files, CSS braces, JSON) |
| `test-tokens.ps1 -BrowserPath msedge.exe` | Automated + browser | All passed (same counts) |
| `test-emulation.ps1`, Chrome and Edge | Browser emulation | **All passed**: 390 x 844 touch viewport at DPR 3 (no overflow, 92 targets 44px, no hover effects); reduced motion; forced colors (9 checks); no-`:has()` CSS path (4 checks) |
| Measurement harness (breadcrumb, chip row, pagination) at 320, 360, 390, 599 and 600px | Browser measurement (ad hoc script) | Candidate CSS and then the real edited CSS gave identical results |
| Overflow and card width at 320, 360, 390, 599, 600, 768, 1023, 1024, 1280, 1920px, both pages | Browser measurement (ad hoc script) | 0 overflow in 20 combinations; 0 card overflow |
| Structural scan, both pages at 320, 390, 1280px | Browser measurement (ad hoc script) | 0 problems: no duplicate ids, broken ARIA or anchor references, missing icons, unnamed controls, unlabeled inputs or heading skips; one `h1`; `lang` and title present |
| Type hierarchy sweep, 1,601 widths | Calculation from the token expressions | 0 violations |
| Screenshot of the navigation components at a true 390px viewport | Visual inspection | Breadcrumb on one line with ellipsis; choice row scrolls with a cut-off chip; applied filters wrap |
| Sabotage: drawer phone value to 26rem; tablet value to 100%; forced-colors separator fix deleted | Check validity | Each made the matching check fail; restored files are byte-identical or regenerated |

**Not verified (unchanged from Part 4):** Firefox, Safari, a real phone or tablet, any screen reader, a real Windows contrast theme, use inside Shopify, axe or Lighthouse, a browser that truly lacks `:has()`. Edge is the same engine as Chrome. These results are not a production-readiness claim.

## 5.3 Defects and corrections found in this phase

- **A wrong measurement of mine, corrected.** The drawer specimen frame has a 1px border, so `100%` is the frame's interior. My earlier "2, 2, 2 and 14px of page left" at 320 to 430px (Part 3, Part 4, `foundations.md`, `usage-guide.md`) included that 2px: the real strips were 0, 0, 0 and 12px. `min(100%, 26rem)` was already a full-width sheet up to 416px and left an unusable sliver only between 417 and 460px. The dashboard check and all the text now use the frame's interior. The 44px-strip value I introduced in Part 4 did not need to exist.
- **A false statement in the token description:** `grid.columns.products` said an image is "at least about 150px" wide on a phone. It is 136px at 320px, 156px at 360px and 171px at 390px. Corrected.
- **A forced-colors probe could pass without measuring anything** at phone width (the first breadcrumb separator belongs to a hidden item). It now measures a rendered separator and fails when the fix is removed.
- **The accordion contradicted its own documentation** (exclusive in the showcase, "any number open" in the docs). Fixed in the showcase.
- **Touch-target count:** 94 at 390px was wrong after decision 1; it is 92 at 390px and 94 at 1280px (the two hidden breadcrumb links).
- **Not found in any committed script:** the "structural scan" reported in Part 3 came from an ad hoc script. I reran an equivalent scan this phase (above); it is not part of `test-tokens.ps1`. Adding it there is a choice for you.

## 5.4 Files changed

Design System: `index.html`, `assets/css/components.css`, `assets/css/base.css` (one comment), `docs/foundations.md`, `docs/components.md`, `docs/accessibility.md`, `docs/manual-testing.md`.
Design Variables: `tokens/layout.json` (source), `tokens/build-tokens.ps1` (one line of generated text), `tokens/test-emulation.ps1` (one probe), `preview/preview.js`, `preview/index.html` (note text and the regenerated data block), `docs/usage-guide.md`, `README.md`; **generated**: `styles/variables.css`, `responsive-token-matrix.md`, `docs/token-reference.md`.
Root: `AUDIT-REPORT.md` (this part and three annotations in Part 4).
No file or folder was moved, renamed, created beyond these edits, or deleted. Scratch scripts and screenshots are outside the project, in the session scratchpad.

## 5.5 Readiness

- **Design Variables:** ready for your review. Tokens, generated CSS, matrix, reference and dashboard agree, and every automated check passes in Chrome and Edge.
- **Design System:** ready for your review of decisions 1, 2, 3, 5, 6 (changes) and 4, 7, 8 (retained/provisional). It is not ready to be called production-ready: it has only been tested in Chromium and has no manual or assistive-technology results.

## 5.6 What I need from you

1. Approve or revert decisions 1, 2, 3, 5 and 6 (each is a small, independent change).
2. Decision 4: keep the 2-row numbered pagination on phones, or ask for a compact "Previous, Page 2 of 12, Next" form.
3. Decisions 7 and 8: confirm the retention (8 could become fixed sizes with no visible loss).
4. Whether to add the structural scan to `test-tokens.ps1`.
5. Run the manual tests before any production claim.

---

# Part 6: Approved decisions implemented and validated

Scope kept: no wireframes, no storefront or theme, no folder moves or renames, Design System and Design Variables separate, JSON canonical with `variables.css` regenerated. I inspected the existing files before editing. **Production readiness is not claimed**: the drawer, Load more and chip behaviors are tested in Chromium only, and the manual tests below are not done.

## 6.1 Status by kind of evidence

| Decision (as approved) | Implemented | Automated check | Browser emulation, real input | Manual (not done) |
|---|---|---|---|---|
| 1 Compact breadcrumb | Yes (CSS) | Structural scan: no overflow at 320/390/1280px | Measured at 320 to 600px with the real CSS; screenshot at 390px | Screen reader; real phone |
| 2 Scrolling chip row | Yes (`.chip-row`, `chip-row.js`) | Scan: ring and hit-area room measured earlier | Tab to a clipped chip scrolls it fully into view; touch swipe scrolls the row, not the page; chip cut off at the edge | Real swipe; screen reader; Safari, Firefox |
| 3 Independent accordion rows | Yes (`name` removed) | Attribute count 3 to 0 | none | Safari, Firefox |
| 4 Load more (phones), numbered (tablet and up) | Yes (`.pagination-switch`, `.load-more`, `load-more.js`) | Scan: markup contract (real link, target list), no overflow | Real taps at 390px with a **demo loader**: loading, success, failure and retry, last page; focus, status text, address bar; numbered shows at 1280px | **Shopify URLs, the default fetch loader, back/forward and reload behavior, real network failure, screen reader** |
| 5 Full-screen filter sheet | Yes (`.drawer`, `drawer.js`) | Dashboard: width token at 8 widths | Phone sheet (390px) and panel (1280px): focus trap and wrap, background inert, scroll lock and restore, independent scrolling, Escape, close, action, scrim, focus return, dialog role and name in the accessibility tree | **iOS Safari scroll lock, Android back button, VoiceOver, TalkBack, NVDA, Firefox** |
| 6 4:5 product-card canvas, exceptions | Docs (section 6) | Dashboard 80% crop, packaging and thumbnail checks (70 checks) | none | Real photography: crop on real packaging, focal points |
| 7 Gutter and grid gap | Retained | Tokens vs computed at 10 widths; 0 overflow at 320 to 1920px | Renders at 320, 430, 600, 768, 1280px | A real page layout |
| 8 Fluid h5 and body large | Retained | 1,601-width sweep | Renders at 320 to 1280px | none beyond a design review |
| Structural scan | Yes (`test-tokens.ps1` section 7) | 38 required files, references, links, generated completeness and freshness, page structure | n/a | n/a |

## 6.2 Defects found in this phase (all fixed unless noted)

- **Focus did not scroll a partly clipped chip into view.** Found by a control experiment: a plain row of plain buttons behaves the same, because browsers scroll a focused control only when it is completely hidden. A keyboard user could land on a half-hidden chip. Fixed with `chip-row.js`; removing it makes the check fail.
- **The "Sale" badge ran under the wishlist button at 320px** (a 129 to 136px card). No earlier test measured it; found by looking at a render. Fixed (badge area reserves room, label wraps); the structural scan now checks it and failed on the old CSS.
- **Demo links rendered in the browser's default blue** (`link--standalone` is a modifier; it needs `link`). Fixed.
- **My first drawer demo had 12 options, which fit on an 844px phone**, so "the body scrolls" could not be tested; the test refused to pass. The demo now has 20.
- **Test-harness findings (not product defects):** headless Chrome ignored synthesized gestures (replaced with explicit touch events); touch swipes stop scrolling after real key events in the same page load (the test swipes first); smooth scrolling made early measurements land off-screen (instant scrolling in the helpers); a variable named `$id` collided with the protocol counter; an earlier scratch script of mine nested two here-strings, ran leftover lines at the top level, and was blocked from deleting a path; I verified the project was intact (44 Design System and 19 Design Variables files, all edited files present).
- **Not distinguishable by the test:** `drawer.js` restores focus itself, but Chrome's native `<dialog>` already does, so removing my line changes nothing in Chromium.

## 6.3 Commands and results (final files)

| Command | Result |
|---|---|
| `build-tokens.ps1` | Exit 0: 333 tokens (6 tier, 10 fluid, 317 static); the Design System uses 273, defines none, no deprecated alias used, 0 problems; 14 tokens with no static reference, all accounted for. Rebuilding leaves the four generated files byte-identical |
| `test-tokens.ps1`, Chrome | **All passed:** 333 tokens x 6 widths, 0 mismatches; dark-surface scope 6/6; dashboard 70 checks, 0 failures at 390, 768, 1440px; console 0 lines (dashboard and showcase); touch targets 94 at 390px and 99 at 1280px, none below 44px; propagation 5/5; encoding (63 files), CSS braces, JSON; structural scan 7a to 7f |
| `test-tokens.ps1 -BrowserPath msedge.exe` | All passed, same counts |
| `test-emulation.ps1`, Chrome and Edge | **All passed on each:** 73 checks passed, 0 failed, 1 informational (badge colors in forced colors). Groups: mobile and touch, reduced motion, forced colors, no-`:has()` path, chip row, drawer (phone sheet and panel), Load more (phone) and numbered pagination (desktop) |
| Sabotage, emulation: Tab wrap, scroll lock, focus-restore line and `chip-row.js` removed together | 11 checks failed (10 drawer, 1 chip row); restored files byte-identical |
| Sabotage, structural scan, on a throwaway copy: a deleted `drawer.js`, a broken Markdown link, a hand-edited `variables.css`, a duplicate id | Groups 7a, 7b, 7c, 7d, 7e and 7f each failed with a message naming the file; the real project was untouched |
| Screenshots inspected | Drawer open on a phone and on desktop; Load more; navigation components at 390px; product cards at 320, 430, 600, 768, 1280px; typography at the same widths |

**Not verified:** Firefox, Safari, a real phone or tablet, any screen reader, real Windows high contrast, Shopify (including URLs and the default Load more loader), axe or Lighthouse, a browser lacking `:has()` or `<dialog>`. Edge is the same engine as Chrome.

## 6.4 Files changed in this phase

New: `design-system/assets/js/drawer.js`, `load-more.js`, `chip-row.js`.
Changed: `design-system/index.html`, `assets/css/components.css`, `assets/js/preview.js`; docs `foundations.md`, `components.md`, `accessibility.md`, `manual-testing.md`, `README.md`; `design-variables/tokens/test-tokens.ps1` (structural scan), `test-emulation.ps1` (interaction groups), `README.md`; this report. Generated files were rebuilt and are unchanged by a second build. Nothing was moved, renamed or deleted in the project.

## 6.5 Not ready, and what is needed

1. **Drawer:** behaviors are implemented and tested in Chromium, but not on iOS Safari, Android, Firefox or with a screen reader (manual-testing section 7).
2. **Load more:** works with a demo loader. The real behavior against Shopify collection URLs is unverified, and the risk of losing position after a reload (Shopify's `paginate` returns only the requested page) is open: see foundations.md section 14.
3. **Imagery:** no real photography exists to confirm crop, focal points and packaging fit.
4. The manual tests have not been run. No production-readiness claim.

---

# Part 7: Remaining risks documented (no new scope)

This part adds documentation only. It builds nothing, creates no Shopify theme or storefront, and changes no behavior. The full register, the requirement table and the assets needed are in `design-system/docs/foundations.md` section 14 ("Risk A" and "Open risks register") and section 6 ("Real product photography: awaiting assets"); they are not repeated here.

## 7.1 Where each risk is recorded

| Risk | Recorded in |
|---|---|
| A. Shopify collection pagination and Load more (URL synchronization, reload, shared links, back and forward, loading and error states, scroll restoration, the "page 3 alone after a reload" risk, evaluating Load previous or an equivalent) | `foundations.md` section 14: decision 4 row, "Risk A", the requirement table, the register; `components.md` pagination row; `design-system/docs/README.md`; `manual-testing.md` section 8 |
| B. Real product photography not supplied (4:5 canvas, crop, focal point, complete packaging visibility, responsive fit, loading behavior) | `foundations.md` section 6 (opening and "awaiting assets"), section 14 decision 6 row and register; the `aspect.portrait` description in `layout.json` (so also the generated token reference and the dashboard) |

## 7.2 Wording superseded in Part 6

Part 6 calls decisions 4 and 6 "approved". The accurate state is: **decision 4 is an approved direction, provisional for implementation** (a showcase pattern with a demo loader; nothing verified against Shopify; the default fetch loader never run), and **decision 6 is an approved, provisional default** (4:5 is a working assumption, not a validated rule; no real photography exists). Section 6.5 items 2 and 3 are the same two risks. Placeholders and drawn SVG packaging are not evidence of image quality.

## 7.3 Provisional decisions

| Decision | Provisional because |
|---|---|
| 4: Load more on phones, numbered on tablet and up | No Shopify theme; Shopify behavior is documentation-based, not tested; the recovery mechanism (Load previous or equivalent) is undecided and unbuilt |
| 6: 4:5 as the product-card canvas | No representative product assets; crop, focal point, packaging visibility, responsive fit and loading behavior are unvalidated |

All other decisions keep the status in `foundations.md` section 14 (implemented and Chromium-tested, or retained on evidence). Nothing was changed about them.

## 7.4 Checks run for this change (documentation and one token description)

| Check | Result |
|---|---|
| `build-tokens.ps1` | Exit 0; 333 tokens (6 tier, 10 fluid, 317 static); the Design System uses 273, 0 problems. Only `token-reference.md` and the dashboard data changed (they carry the description text); `variables.css` and the matrix are unchanged; a second build is identical |
| `test-tokens.ps1`, Chrome | All passed: 333 tokens x 6 widths 0 mismatches; dashboard 70 checks; console 0; touch targets 94 (390px) and 99 (1280px); propagation 5/5; encoding in 63 files, CSS braces, JSON; structural scan 7a to 7f (including Markdown links and a fresh-build comparison) |
| `test-tokens.ps1`, Edge | All passed |
| `test-emulation.ps1`, Chrome | All passed (73 checks, 0 failed) |

Not run (no code changed): `test-emulation.ps1` on Edge, which passed in Part 6 on the same code.

## 7.5 Evidence needed to close each risk

See the last column of the register in `foundations.md` section 14. In short: **A** needs a Shopify theme (a later phase, not started) with a collection of more than three pages, the requirement table run in Chrome, Safari and Firefox on a real phone, and an owner decision on the recovery mechanism. **B** needs representative product assets (tallest and widest packaging, a transparent or white-background product, a lifestyle shot, a hero image, masters of at least 1600px) reviewed in the card, gallery and thumbnail at 320, 390, 768 and 1280px with real `srcset` delivery.

## 7.6 Readiness

- **Design review:** the Design System and Design Variables are ready for design review, with the two provisional decisions flagged. Their tokens, generated files and documentation agree, and all automated checks pass in Chrome and Edge.
- **Production readiness: not claimed.** Behaviors are tested in Chromium only; the manual tests are not done; Load more is unverified against Shopify; no real photography has been supplied.

---

# Part 8: Comprehensive re-audit, 2026-10-22

A re-audit of the existing Design System and Design Variables. It rebuilds nothing, moves nothing, and starts no wireframes, page designs or Shopify work. I inspected the actual files first (45 Design System files, 19 Design Variables files, seven audit parts, 21 component sections in `components.css`) and did not assume that earlier recommendations were implemented correctly. Earlier parts are kept as history; where a later phase corrected them, the correction is stated in that later part (for example Part 5 section 5.3 and Part 7 section 7.2).

## 8.1 Overall status

| Area | Status |
|---|---|
| **Design System** | Ready for design review. No critical or high findings. Two Medium contrast defects in the showcase's own chrome and one Medium dashboard overflow were found and fixed. Open gaps are listed in 8.3 |
| **Design Variables** | Ready for design review. An independent parse agrees with the builder (333 tokens); 0 naming, duplicate, reference, cycle or layering problems; generated files are fresh and complete |
| **Drawer** | **Implemented**, not just designed: focus trap with wrap, Escape, scroll lock, focus restore, dialog semantics and name, independent scrolling, 44px close and a pinned action. Tested with real input in Chromium only (8.8) |
| **Production** | **Not ready** (8.13) |

## 8.2 What I audited, and how (evidence kind in brackets)

| Area | Method | Result |
|---|---|---|
| Token integrity [static, independent script] | Parsed all eight JSON files myself (not the builder): names, duplicates, references, cycles, alias depth, layering, units | 333 tokens (matches the builder); 0 problems; max alias depth 2 (138 / 180 / 15 at depths 0 / 1 / 2); no primitive aliases anything, no semantic token points at a component token, no component token bypasses semantic to a palette value; 185 tokens are single aliases (105 typography composites by design, 47 colour roles, 33 component tokens), none removed; literal units: rem 86, vw 10, px 5 (`radius-pill`, `border-width-thin/-thick`, `focus-ring-width/-offset`), em 5, ms 3 |
| Hardcoded values [static] | Scanned `foundation.css`, `base.css`, `components.css` outside `var()`, comments, data URIs and `@font-face` | **0 hex or rgb colours except one** (`rgb(var(--shadow-color) / 0.25)` on the swatch ring: a literal alpha), 0 `z-index` literals; length literals are optical `em` offsets, the 1px visually-hidden box, the 0.01ms reduced-motion duration, a `-0.0625rem` checkbox nudge and the 1px disabled-swatch line |
| Breakpoints [static] | Listed every `@media` in the Design System, dashboard and generated CSS | Only `(min-width: 37.5rem)`, `(min-width: 64rem)`, `(hover: hover)`, `(prefers-reduced-motion: reduce)`, `(forced-colors: active)`: consistent with `breakpoints.json` |
| Unreferenced tokens [static] | Recomputed with real token paths (a first attempt with a naive matcher gave 22: my error, not the project's) | 11 plus the 3 `--breakpoint-*` tokens the dashboard reads at runtime = **the documented 14, same names**. Kept: the rules forbid removing a token only because it is unused. Correction: the README said the `--z-*` layers were for "planned dialogs", but the drawer is a native `<dialog>` in the top layer and uses none of them; the note now says so |
| Component states [static] | Read the CSS for the questionable states (a first regex matrix was too crude to trust and is not reported) | Global `:focus-visible` rule plus component overrides; the only `outline: none` rules are `:focus:not(:focus-visible)` and the product-card title link inside `@supports selector(:has(*))`. See 8.3 for missing states |
| Contrast [browser, ad hoc script] | Every visible text node: computed colour against the effective background (alpha blended through ancestors), 4.5:1 or 3:1 for large text | Showcase 726 nodes at 1280px and 720 at 390px; dashboard 3,106 nodes. See 8.3 for the failures found and fixed. After the fixes: **0 failures in the showcase**; the dashboard's 5 remaining are its deliberate "known fail" specimen pairs, labelled as documented rules |
| Responsive sweep [browser, ad hoc script] | 13 widths (320, 321, 360, 390, 430, 599, 600, 768, 1023, 1024, 1280, 1440, 1920) on both pages: horizontal scroll against the **client** width, elements beyond the viewport outside scroll containers, text clipped without an ellipsis | After the fix, 0 problems on either page at all 13 widths |
| Layout shift [browser, ad hoc script] | `layout-shift` observer, buffered | 0 shifts at 1280px and 390px, on a local file, so fonts load instantly: **this does not show what happens on a real network** |
| Keyboard walk [browser, real Tab presses] | Tab from the top of the showcase until focus leaves the page | 1280px: 103 stops, a visible ring on every one, none obscured, none off screen, no trap, no positive `tabindex`, DOM order monotonic. 390px: 98 stops, same results except two tall scrollable table wrappers partly under the 119px sticky header (not entirely hidden: WCAG 2.2 AA met; the stricter AAA criterion is not). My first run reported 30 and 122 stops "not in viewport": the page uses smooth scrolling and I measured mid-scroll, so that run was discarded and the walk rerun with instant scrolling |
| Forced colors and reduced motion on the new components [browser emulation] | Opened the drawer under both emulations | The drawer edge is a 1px solid system-colour border, the close button shows a 2px solid ring, the action keeps its border; `scroll-behavior` is `auto`; the drawer has no animation |
| Documentation consistency [static] | Searched every current document for stale numbers, phrases and decision statements | Fixed 3 stale statements (8.4); the eight decisions now read consistently in `foundations.md` section 14, `components.md`, the Design System README, the usage guide, the generated matrix and Parts 5 to 7. Nothing documented earlier was removed (14 foundations sections, 7 audit parts, 17 contrast rows and all accessibility sections still present) |
| The structural scan itself [static + sabotage] | Read its code; ran it against deliberate breakages | Meaningful: it checks a fixed, documented list of 38 required files (everything else is optional and never required), local references, Markdown links, generated completeness and freshness, and page structure; every message names the file and the action. Limits: 7b follows `link`, `script`, `img`, `source` and `url()` only (no `srcset` or `<use href="file#id">`, none of which exist today); the required list must be edited when files are added on purpose; 7f is a fixed set of heuristics. It was hardened in this audit (8.4) |

## 8.3 Findings

**Critical: none. High: none.**

| # | Severity | Finding | Status |
|---|---|---|---|
| 1 | Medium | The showcase's own `.ds-code` chips put `--color-text-muted` on Blush (4.46:1), a pair the accessibility document forbids | **Fixed**: `design-system/assets/css/preview.css` (secondary text, 5.61:1) |
| 2 | Medium | The "Derived" label on the Neutral 400 colour tile was 3.74:1; neither white (3.74) nor Charcoal (4.31) reaches 4.5:1 on that mid-tone | **Fixed**: `design-system/index.html` (the label is now a `.badge--dark` pill) |
| 3 | Medium | The token dashboard overflowed horizontally at 320 and 321px when a classic 15px scrollbar took width (the tier simulator was 299px in a 273px column). My earlier overflow checks compared the page width to the **window** width, not the **client** width, so they could not see it | **Fixed**: `design-variables/preview/preview.css` (button padding), and both overflow checks now compare to `clientWidth`. Proven by reverting only the fix on a throwaway copy: scan 7f failed with "the page is 315px wide but only 305px is visible" |
| 4 | Medium | The generated responsive matrix's behaviour table did not mention the breadcrumb, chip row, collection paging or drawer presentation, and the manual screen-reader table had no rows for the drawer, Load more or the chip row | **Fixed**: `build-tokens.ps1` (4 rows, matrix regenerated), `manual-testing.md` (3 rows) |
| 5 | Low | The dashboard's scrim tile label was 2.99:1 | **Fixed**: `design-variables/preview/preview.css` |
| 6 | Low | Stale statements: the usage guide's tier list omitted drawer width; the Design Variables README quoted 92 and 94 touch targets (now 94 and 99) and the `--z-*` note | **Fixed** (8.4) |
| 7 | Medium | **No loading state exists for the base button** (for example a pending add to bag). Only Load more shows one (`aria-busy` and `aria-disabled`, with a progress cursor) | **Unresolved, deliberately.** A button loading style is a new design decision; recommendation: an `aria-busy` state with a spinner icon, label kept, and `aria-disabled` rather than `disabled` so focus is not lost. Needs your approval before the cart or product-page work |
| 8 | Low | No `:hover` on `.choice`, and no `:active` on chips, pagination or choices | Unresolved: native label behaviour is acceptable; add pressed states only if the design review wants them |
| 9 | Low | One literal alpha (`0.25`) on the swatch inset ring | Unresolved: replacing it means adding a token; recorded here instead |
| 10 | Low | At 390px the sticky showcase header is 119px tall (14% of an 844px screen) and partly covers two tall scrollable regions on focus | Unresolved: showcase chrome, not a theme component; WCAG 2.2 AA is met, the AAA criterion is not |
| 11 | Info | The dashboard's contrast table deliberately shows pairs that fail (muted on Blush 4.46, Neutral 400 on white and Ivory, Deep Rose on Charcoal 2.30, and others), each labelled as a documented rule | Not a defect; exempted in the numbers above |
| 12 | Info | Browser focus scrolling brings a control into view only when it is completely hidden, so a partly clipped chip stayed clipped on Tab | Found in an earlier phase; fixed by `chip-row.js`, re-verified here by the keyboard walk |

## 8.4 Files changed in this re-audit

- `design-system/assets/css/preview.css`: `.ds-code` colour (finding 1)
- `design-system/index.html`: Neutral 400 label (finding 2)
- `design-variables/preview/preview.css`: simulator button padding, scrim label (findings 3, 5); the dashboard's embedded token data was regenerated because the CSS usage it records changed
- `design-variables/tokens/test-tokens.ps1`: dashboard overflow and scan 7f compare to `clientWidth`; a leftover `|| true` condition removed
- `design-variables/tokens/build-tokens.ps1`: four behaviour rows (finding 4); `responsive-token-matrix.md` regenerated
- `design-variables/docs/usage-guide.md`, `design-variables/README.md`, `design-system/docs/manual-testing.md`: findings 4 and 6
- `AUDIT-REPORT.md`: this part only

Nothing was moved, renamed, merged or deleted. The ad hoc audit scripts (independent token audit, hardcoded-value scan, contrast, sweep, keyboard walk) are in the session scratchpad, **not in the project**; promoting the contrast audit and the keyboard walk into the test suite would be a scope decision for you.

## 8.5 Token JSON and CSS consistency

Independent parse: 333 tokens across eight JSON files. Builder: 333 tokens (6 tier, 10 fluid, 317 static), 0 problems; the Design System uses 273 and defines none; no deprecated alias used. Browser: all 333 computed values equal the JSON at 320, 599, 600, 1023, 1024 and 1440px (0 mismatches). Scan 7d: the dashboard's token set and the custom properties in `variables.css` are the same set, every `var()` is declared, every token appears in the token reference. Scan 7e: a fresh build on a temporary copy is byte-identical to the committed generated files; a second build leaves them unchanged.

## 8.6 Accessibility and responsive results

See 8.2 for the numbers: 0 contrast failures in the showcase, a visible 2px ring on every Tab stop at 1280px and 390px, no keyboard trap, no overflow at 13 widths on either page, forced colors and reduced motion on the drawer. The drawer and Load more, chip-row and structural-scan results from Part 6 were re-run unchanged (73 emulation checks).

## 8.7 Tests actually run in this re-audit

| Command or method | Result |
|---|---|
| Independent token audit (`audit-tokens.ps1`, scratchpad, PowerShell) | 333 tokens; 0 problems |
| Hardcoded-value, media-query and unreferenced-token scan (`audit-css.ps1`) | As in 8.2 (one run's 22 unreferenced tokens were my matcher's error; recomputed with real paths: 11 + 3) |
| Static CSS inspection of component states and `outline: none` rules | As in 8.2 and 8.3 |
| Runtime audit over the DevTools protocol (scratchpad): contrast, 13-width sweep, layout shift, keyboard walk, forced colors on the drawer | As in 8.2 and 8.3. The first keyboard walk was discarded (smooth scrolling); the first sweep's "clipped text" hits were the dashboard's visually-hidden class (my filter), not defects |
| `build-tokens.ps1` | Exit 0; 333 tokens; 273 used by the Design System; 0 problems; generated files unchanged by a second build |
| `test-tokens.ps1`, Chrome | **All passed**: 333 x 6 widths 0 mismatches; dashboard 70 checks at 390, 768, 1440px; console 0; touch targets 94 (390px) and 99 (1280px), none below 44px; propagation 5/5; encoding in 63 files, CSS braces, JSON; scan 7a to 7f |
| `test-tokens.ps1 -BrowserPath msedge.exe` | All passed (33 passed, 0 failed) |
| `test-emulation.ps1`, Chrome and Edge | All passed on each (73 passed, 0 failed, 1 informational) |
| Sabotage: dashboard fix reverted on a throwaway copy | Scan 7f failed with a message naming the page, the width and the pixels |

## 8.8 Manual and external verification still required

Everything in `design-system/docs/manual-testing.md`, none of it done: a real phone and tablet; iOS Safari (scroll lock), Android (back button); Safari and Firefox; NVDA, VoiceOver and TalkBack (drawer as a dialog, Load more announcements, chip row, breadcrumb on phones); real Windows high contrast; 200% and 400% zoom and text spacing; axe and Lighthouse (not installed here); a browser that really lacks `:has()` or `<dialog>`; font loading on a real network (layout shift here is measured on a local file); Shopify theme integration.

| Kind of evidence | What this project has |
|---|---|
| Static inspection | Yes (8.2) |
| Automated tests | Yes: builder, `test-tokens.ps1`, structural scan |
| Browser emulation and real-input automation | Yes, Chromium only (Chrome and Edge share an engine) |
| Manual browser testing | **None** |
| Real devices | **None** |
| Screen readers and assistive technology | **None** (the accessibility tree was read through the browser, which is not a screen reader) |
| Shopify integration | **None** |

## 8.9 Provisional decisions and external dependencies

- **Decision 4, Load more on phones:** provisional for implementation. Nothing is verified against Shopify; the default fetch loader is unexercised; the reload, shared-link, back/forward, scroll-restoration and Load previous questions are open (`foundations.md` section 14, Risk A).
- **Decision 6, 4:5 canvas:** provisional default. No real photography exists; crop, focal point, packaging visibility, responsive fit and loading are awaiting assets (Risk B). Placeholders are not evidence.
- **Decisions 1, 2, 3, 5, 7, 8:** approved and implemented or retained on the evidence in section 14; assistive-technology and real-device confirmation pending (Risk C).
- **External:** a Shopify theme (a later phase), product assets, real devices, assistive technology.

## 8.10 Readiness

- **Ready for design review: yes**, with decisions 4 and 6 flagged as provisional.
- **Ready for wireframe work: yes, on conditions.** (1) Wireframes must not depend on Load more or the 4:5 ratio as fixed facts (use the documented alternatives where they matter). (2) Decide finding 7 (a loading state for the base button) before cart or product-page wireframes. (3) The owner should read section 14 and confirm that decisions 4 and 6 stay provisional. The manual tests are not a precondition for wireframes, but they are for building.
- **Production-ready: no.** Behaviour is tested in Chromium only; no manual, device or assistive-technology test has been run; Load more and the image guidance are unverified against Shopify and real photography; the base button has no loading state; no theme exists.

---

# Part 9: Re-audit with a mandatory typography unit audit, 2026-10-22 (second pass)

**About the request.** The brief ended mid-sentence ("Preview dashboard and specimens"), so I worked from its clear objective: a complete recheck of the existing system, with the typography unit audit as the new mandatory item (no canonical font-size value in points). Part 8, written earlier the same day, is the complete audit; this pass repeated its runtime audit on the current files, added the typography audit and made one addition to the test suite. Nothing was rebuilt, moved, renamed, merged or deleted.

## 9.1 Typography unit audit (mandatory item)

**Result: no point units exist anywhere, and every canonical font size is in `rem`.**

| Source inspected | Method | Result |
|---|---|---|
| Whole project (CSS, JSON, JS, HTML, SVG, Markdown, PowerShell) | Searched for any number followed by `pt` | **0 matches** |
| `typography.json`, all 21 `font.size.*` tokens (and their aliases) | Parsed the values | 12 are plain `rem` values (`0.75rem` to `1rem`); 9 are `clamp(Arem, Brem + Cvw, Drem)` with `rem` bounds. No `px`, `pt`, `em` or `%` |
| `clamp()` expressions | Checked bounds | Minimum below maximum in all 9; max/min ratios 1.82 (display), 1.67, 1.47, 1.33, 1.20, 1.13, 1.12, 1.17, 1.20: all within the 2.5 limit that keeps text zoom effective, and the `rem` bounds scale with the browser's font-size setting |
| Generated `variables.css`, 42 font-size custom properties | Listed every unit | `rem` (39) and `vw` (9) only; the 21 primitives hold the values and the `--type-*-font-size` composites are `var()` aliases |
| Theme CSS: `foundation.css`, `base.css`, `components.css` | Read every `font-size` declaration | 0 and 20 and 21 declarations, **all through `var()`**; the only `font` shorthand is `font: inherit` |
| Showcase and dashboard stylesheets (chrome, not components) | Same | `0.85em` for inline code (relative, no points); one literal `1.5rem` on the dashboard's `.pv-brand` wordmark (`rem`, scales with zoom, no equivalent token: H3 is fluid up to 2rem). Recorded as Low, not changed |
| Dashboard and showcase scripts and inline styles | Searched | Font sizes come from `var(--type-*-font-size)`; the pixel figures the specimens print are computed from the browser at run time and are labelled as derived, not canonical |
| Documentation | Read | The px figures in `typography.md` are readings at 1rem = 16px. The units rule was **not stated explicitly**, so it now is (`typography.md`, `usage-guide.md`) |
| Computed values | `test-tokens.ps1` section 1 | All 333 tokens equal their JSON values at 320, 599, 600, 1023, 1024 and 1440px |

**Permanent enforcement added** (`test-tokens.ps1` section 8, described in its header and the Design Variables README): 8a no `pt` unit in any CSS, JSON, JS, HTML or SVG file; 8b every canonical font-size token is `Nrem` or a valid `clamp()` with `rem` bounds, min <= max, max/min <= 2.5; 8c the theme CSS takes every `font-size` from a token; 8d the generated font-size properties use only `rem` and `vw`. Proof it can fail: on a throwaway copy, `10.5pt` in the JSON, `12pt` and `14px` in `components.css`, a 4x `clamp()` and `10pt` hand-edited into `variables.css` made 8a, 8b, 8c and 8d each fail with the file, the line and the fix, and made the freshness scan fail for the hand-edited generated file. The real project was untouched.

## 9.2 The rest of the audit, re-run on the current files

All of Part 8 stands. Re-run today with the current files: the independent token audit (333 tokens, 0 problems), the hardcoded-value scan, the contrast audit (showcase 726 and 720 text nodes, **0 failures**; the dashboard's 5 are its deliberate "known fail" specimen pairs), the 13-width sweep on both pages (0 problems), the keyboard walk with real Tab presses (103 stops at 1280px and 98 at 390px, a visible ring on every stop, no trap; two tall scrollable regions partly under the sticky header at 390px, as in Part 8), forced colors and reduced motion on the drawer. Layout shift measured 0 and 0.001 on a local file (variance; it says nothing about a real network).

## 9.3 Findings

No critical or high findings. No new defect beyond the Low literal in 9.1 and an editing slip of mine, below. The unresolved items of Part 8 (finding 7, no loading state on the base button; findings 8, 9 and 10) are unchanged and still need your decision.

**A slip of mine, caught and fixed:** while adding a README line I passed a string expression to a function without parentheses, which PowerShell reads as separate arguments; the replacement text silently dropped the next bullet's heading ("Structural scan"). I found it by reading the result, restored the heading, and verified all five verified-result bullets are present.

## 9.4 Files changed in this pass

`design-variables/tokens/test-tokens.ps1` (section 8 and its header); `design-system/docs/typography.md` and `design-variables/docs/usage-guide.md` (the units rule); `design-variables/README.md` (the new check); `AUDIT-REPORT.md` (this part). No generated file changed (a rebuild leaves all four byte-identical).

## 9.5 Tests run in this pass

| Command or method | Result |
|---|---|
| Whole-project `pt` search; units census of the JSON, generated CSS, theme CSS and specimens (ad hoc scripts in the session scratchpad) | 0 points; `rem` and `vw` only; as in 9.1 |
| `build-tokens.ps1` | Exit 0; 333 tokens (6 tier, 10 fluid, 317 static); the Design System uses 273; 0 problems; rebuild changes nothing |
| `test-tokens.ps1`, Chrome | **All passed (37 passed, 0 failed):** 333 x 6 widths 0 mismatches; dashboard 70 checks; console 0; touch targets 94 (390px) and 99 (1280px); propagation; encoding in 63 files; scan 7a to 7f; typography 8a to 8d |
| `test-tokens.ps1 -BrowserPath msedge.exe` | All passed (37 passed, 0 failed) |
| `test-emulation.ps1`, Chrome and Edge | All passed on each (73 passed, 0 failed, 1 informational) |
| Runtime audit (scratchpad, DevTools protocol) | As in 9.2 |
| Sabotage of the new typography checks on a throwaway copy | 8a, 8b, 8c and 8d each failed as designed |

## 9.6 Still not verified, and readiness

Unchanged from Part 8: no manual browser test, no real device, no screen reader, no Safari or Firefox, no real Windows high contrast, no axe or Lighthouse, no font loading on a real network, no Shopify. Decisions 4 (Load more) and 6 (4:5 canvas) remain provisional. **Ready for design review: yes. Ready for wireframes: yes, on the three conditions in section 8.10. Production-ready: no.**

---

# Part 10: Re-audit with the px font-size convention, 2026-10-22 (third pass)

The brief this time was complete. It repeats the re-audit and adds a convention: canonical font-size token values are in `px`, no value in points, and valid `rem`, `em` and `clamp()` expressions may remain where they are part of the responsive implementation. Parts 8 and 9 hold the earlier passes and are unchanged; this part records what changed and what was re-run.

## 10.1 Design decision taken for this pass

The brief's requirement 1 (use `px`) and requirement 6 (do not convert `rem` and `clamp()` blindly) allowed more than one reading, and the choice has accessibility consequences, so I asked. **Decision (owner, 2026-10-22): the 12 static font sizes are canonical in `px`; the 9 fluid `clamp()` sizes keep their approved `rem` expressions as a documented exception.** The other options offered were all-`px` including the clamp bounds, and keeping `rem`.

## 10.2 Typography audit results

| Item | Result |
|---|---|
| Font-size values in points anywhere | **None**, in tokens, aliases, generated CSS, theme CSS, dashboard, specimens and scripts. So nothing was converted from points |
| Remaining text matches of a number followed by `pt` | 6 lines in 5 files (`typography.md`, `build-tokens.ps1`, `test-tokens.ps1`, the Design Variables README, this report), **all explanatory**: the rule statement, the validation error messages, test descriptions and this history. 0 in any token file, stylesheet, script or page |
| Converted | 12 static tokens in `design-variables/tokens/typography.json`, `rem` to `px`: `h6` 0.875 to **14px**, `body` 1 to **16px**, `body-sm` 0.875 to **14px**, `caption` 0.8125 to **13px**, `overline` 0.75 to **12px**, `label` 0.875 to **14px**, `button` 0.8125 to **13px**, `nav` 0.9375 to **15px**, `utility` 0.75 to **12px**, `input` 1 to **16px**, `validation` 0.8125 to **13px**, `price` 1 to **16px**. Every value is an exact multiple of 16, so no rounding was needed |
| Not changed | The 9 fluid sizes (`display`, `h1` to `h5`, `body-lg`, `product-title`, `price-lg`) and their approved expressions; all weights, families, line heights, letter spacing, spacing, widths and heights; icon and component sizes (`1rem` icon tokens are not font sizes) |
| Visual scale | Identical at the default browser font size: measured in Chrome, every size in the showcase matches the previous values exactly at a 16px default (display 74.6, h1 54.4, h2 41.0, h3 30.6, h4 23.4, h5 17.4, h6 14.0, body large 18.9, body 16.0, body small 14.0, caption 13.0, button 13.0 at 1280px) |
| Generated CSS | `variables.css` and `token-reference.md` regenerated by the builder (px for the 12 static sizes); the matrix, which lists fluid tokens, is unchanged; a second build changes nothing |
| Theme CSS | Every `font-size` in `foundation.css`, `base.css` and `components.css` comes from a token (0 literals); dashboard and showcase chrome has the two relative or `rem` literals recorded in Part 9 |
| Documentation | Convention, exception and measured consequence now in `typography.md`; `usage-guide.md`, the Design Variables README, `accessibility.md` and `manual-testing.md` updated (they previously said "use rem always" and "browser font-size preference is respected", which is no longer true for the static sizes) |

**Validation added or changed.**
- `build-tokens.ps1` now fails the build (exit 1) when any token value contains a point unit, naming the file, the token path and the CSS name, and when a static `font-size-*` token is not written in `px` (the fluid form is exempt). Shown on a throwaway copy with `12pt` and with a static `0.8125rem`.
- `test-tokens.ps1` section 8 is rewritten for the new convention: **8a** no point unit in any token file (reported per file and token name) or in any stylesheet, script, page or SVG (per line); **8b** the 12 static font-size tokens are `px` and the 9 fluid ones are valid `rem` clamp expressions with max/min of at most 2.5; **8c** theme CSS takes every font-size from a token; **8d** generated font-size properties are `px` (static) or `rem` and `vw` (fluid). On a throwaway copy, a `9pt` token, `12pt` and `14px` in `components.css` and a hand-edited generated file each failed with the file and, for tokens, the token name.

## 10.3 Finding caused by the convention (measured)

**High (decision needed): mixing `px` and `rem` makes the type hierarchy depend on the user's browser default font size.** Measured in Chrome by changing the default font size and reading the computed sizes on the same page:

| Browser default | Static sizes (px) | Fluid sizes (rem bounds) | Effect |
|---|---|---|---|
| 16px (normal) | body 16, caption 13 | h5 17.4, body large 18.9, display 74.6 | Unchanged from before the conversion |
| 24px (larger) | body 16, caption 13 (**did not follow**) | h5 25.2, body large 27.0, display 91.4 (**grew 1.5x**) | The setting reaches headings and the lead paragraph but **not body text**; before the conversion everything scaled together (body 24, caption 19.5) |
| 12px (smaller) | body 16, caption 13 | h5 **13.5**, body large **14.3**, display 60 | **h5 and body large fall below body text**: the hierarchy inverts |

Browser zoom scales `px` and `rem` equally and is unaffected. WCAG 1.4.4 (resize text) is still met through zoom; the loss is the user's own default-size preference for body text, and the hierarchy shift. **I recommended the option the owner chose before measuring this**; the measurement shows it carries this cost. Options, none applied without approval:
1. **Convert the fluid expressions to `px` bounds too** (for example `clamp(44px, 33.6px + 3.2vw, 80px)`, identical sizes at the default). The hierarchy is then stable at any default, but no size follows the browser default. This keeps the "canonical values are px" rule consistent.
2. **Revert to `rem` everywhere** and show `px` only as derived values. Honours the preference for all text; does not meet requirement 1.
3. **Keep the mixed state** and accept the behaviour, documented as done in `typography.md`.

## 10.4 The rest of the audit, re-run on the converted files

All of Part 8 stands. Re-run: the independent token and hardcoded-value audits (Part 8), the contrast audit (showcase **0 failures** across 726 and 720 text nodes; the dashboard's 5 are its labelled "known fail" specimen pairs), the 13-width sweep (**0 problems** on both pages), the keyboard walk with real Tab presses (103 stops at 1280px, 98 at 390px, a visible ring on every stop, no trap; two tall scrollable regions partly under the sticky header at 390px, as before), forced colors and reduced motion on the drawer, and layout shift (0 and 0.001 on a local file). **Drawer status unchanged: focus trap, Escape, scroll lock and focus restore are implemented and tested with real input in Chromium; not tested on iOS Safari, Android, Firefox or with a screen reader.** The design decisions (breadcrumb, chip row, accordion, paging, drawer presentation, imagery, gutters, fluid h5 and body large) read consistently across the implementation and the documents (`foundations.md` section 14); decisions 4 and 6 stay provisional.

## 10.5 Findings by severity

| Severity | Finding | Status |
|---|---|---|
| Critical | None | n/a |
| High | Mixed `px` and `rem` font sizes: hierarchy and body text depend on the browser default font size (10.3) | **Open: needs your decision** |
| Medium | The base button has no loading state (Part 8, finding 7) | Open: new design decision |
| Low | `.choice` hover and chip, pagination and choice pressed states; the literal `0.25` swatch alpha; the 119px sticky showcase header on a phone; the dashboard's `1.5rem` wordmark | Open: recorded in Parts 8 and 9 |
| Fixed this pass | Documentation that still said "use rem always" and "browser preference is respected"; the typography checks now enforce the new convention | Done |

## 10.6 Files changed in this pass

Source and validation: `design-variables/tokens/typography.json` (12 values), `build-tokens.ps1` (units validation), `test-tokens.ps1` (section 8 and its header). Generated by the builder: `design-variables/styles/variables.css`, `design-variables/docs/token-reference.md`, and the data block of `design-variables/preview/index.html`. Documentation: `design-system/docs/typography.md`, `accessibility.md`, `manual-testing.md`, `design-variables/docs/usage-guide.md`, `design-variables/README.md`, and this report. Nothing was moved, renamed, merged or deleted, and no Shopify or wireframe work was started.

## 10.7 Tests run in this pass

| Command or method | Result |
|---|---|
| Whole-project point-unit search; type-scale measurement at browser default sizes 16, 24 and 12px (ad hoc, Chrome) | 0 point values; the table in 10.3 |
| `build-tokens.ps1` | Exit 0; 333 tokens (6 tier, 10 fluid, 317 static); 273 used by the Design System; 0 problems; a rebuild changes nothing |
| `test-tokens.ps1`, Chrome | **All passed (37 passed, 0 failed):** 333 x 6 widths 0 mismatches; dashboard 70 checks; console 0; touch targets 94 and 99; propagation; encoding in 63 files; scan 7a to 7f; typography 8a to 8d |
| `test-tokens.ps1 -BrowserPath msedge.exe` | All passed (37 passed, 0 failed) |
| `test-emulation.ps1`, Chrome and Edge | All passed on each (73 passed, 0 failed, 1 informational) |
| Runtime audit (ad hoc, DevTools protocol) | As in 10.4 |
| Sabotage on throwaway copies: builder with a `12pt` token and a static `rem` size; the test with a `9pt` token, CSS literals and a hand-edited generated file | Each failed with the file and token name; the real project was untouched |

## 10.8 Remaining manual tests, provisional decisions and readiness

- **Manual tests still required** (none done): everything in `manual-testing.md`, now including the browser default font size test (section 6), plus real devices, screen readers, Safari and Firefox, real Windows high contrast, axe and Lighthouse, font loading on a real network, and Shopify.
- **Provisional:** Load more on phones (nothing verified against Shopify; URL synchronisation, reload, shared links, back and forward, scroll restoration and a Load previous mechanism are future requirements) and the 4:5 canvas (no real photography; crop, focal point, packaging visibility and responsive fit await representative assets).
- **Ready for design review: yes**, with the 10.3 decision, decisions 4 and 6, and the base-button loading state flagged.
- **Before wireframes:** the three conditions in section 8.10, plus the 10.3 decision (it changes the typography tokens the wireframes will reference).
- **Production-ready: no.** Chromium-only testing; no manual, device or assistive-technology test; Load more and image guidance unverified; an open High finding on font units; no theme.