# Figma-native system versus the web system

An evidence-based comparison of the two parallel systems in this project, for review. **Nothing here claims that the Figma system exists in Figma, or that the two synchronise automatically.** The Figma system is a specification in VS Code; no Figma file was created, and nothing was tested inside Figma.

| | Web system | Figma-specific system |
|---|---|---|
| Folders | [`01-Design-System/`](../), [`02-Design-Variables/`](../../02-Design-Variables/) | [`01-Design-System/Figma-Specification/`](./), [`02-Design-Variables/Figma-Variables/`](../../02-Design-Variables/Figma-Variables/) |
| State | Implemented, tested in Chromium (Chrome, Edge) | A specification plus a browser preview of that specification; **not created in Figma, not tested in Figma** |
| Separation | Not touched by the Figma tools: all 82 files match a baseline manifest (validator check 12). The baseline was first taken (64 files) before the Figma folders existed and was re-recorded on 2026-11-03 after the project was reorganised into numbered sections and renamed to NUDGE, which intentionally moved and edited web-system files, and again on 2026-11-11 after the typography and spacing audit and the luxury colour palette update | Independent: it reads the web tokens read-only and never writes into the web folders |

## 1. Purpose and source of truth

| | Web | Figma |
|---|---|---|
| Purpose | Define and ship the tokens and components a storefront theme consumes | Organise the same design for designers working in Figma: modes, styles, components, handoff |
| Source of truth | `02-Design-Variables/Tokens/*.json` (canonical); CSS, the matrix and the token reference are generated | `02-Design-Variables/Figma-Variables/*.json` and `01-Design-System/Figma-Specification/components.json` (sources); `variable-map.json`, the docs and the preview data are generated |
| Relationship | Authoritative for the website | A proposal. It **mirrors** the web values and is compared to them by the validator; **there is no automatic link** |

## 2. Token structure

| | Web | Figma |
|---|---|---|
| Count | 341 tokens in 8 files: 14 tier, 0 fluid, 327 static (since the 2026-11-11 typography, spacing and colour updates) | 178 Variables in 5 collections, plus 21 Text Styles, 3 Effect Styles, 3 Grid Styles |
| Layers | Primitive, semantic, component, by file | Collections: **Primitives** (54), **Semantic** (51), **Layout** (11), **Typography** (21), **Components** (41) |
| Responsive | Media queries (tier tokens) | **Modes**: Layout and Typography have Mobile, Tablet, Desktop |
| Inverse surface | `.surface-inverse` scope; the build re-declares dependent tokens by hand | **Semantic mode Inverse**; aliases re-resolve automatically, including dependents |
| Dark mode | None | None (not invented) |
| Naming | `--color-bg-page` | `color/bg/page` (the web path with `/`) |

**Classification of all 341 web tokens** (`02-Design-Variables/Figma-Variables/mapping-report.md`, generated):

| Category | Count | Meaning |
|---|---|---|
| Shared | 170 | A Figma variable holds the same value (since the audit this includes every font size and the section spacing, which were sampled before) |
| Mapped differently | 10 | Representation differs: drawer width, 2 font families (no fallback stack), 2 colours with alpha, 2 renamed link roles, 3 breakpoints (frame widths) |
| Not a variable | 153 | No suitable Variable type: 108 composite type tokens (Text Styles), line heights and letter spacing (stored in Text Styles), shadows (Effect Styles), motion, z-index, aspect ratios, grid column count, image fit |
| Not promoted | 8 | Single-component values kept as component properties |
| Figma-only variable | 1 | `layout/frame-width` (reference page widths 360, 768, 1280) |

## 3. Colour and typography mapping

**Colour: shared.** All 21 palette values and 51 semantic roles hold the same colour as the web in every mode (the Luxury Rose + Rich Burgundy palette: Pearl Pink, Rose Quartz, Blush Rose, Luxury Rose, Rich Burgundy, Midnight Plum). The validator compared 290 variable-mode values against an independent resolution of the web value: **289 exact, 0 sampled, 1 documented non-numeric** (the Mobile drawer width, which is `100%` on the web); 0 mismatches. Contrast computed from the Figma values reproduces the web's measured ratios, including its two "not permitted" pairs ([01-Design-System/Figma-Specification/accessibility.md](accessibility.md)).

**Typography: px, shared.**
- Every font size is **px**, whole and even, in both systems. No value is in points.
- Since the 2026-11-11 audit the web has no fluid sizes: the scaled sizes step at 600 and 1024px, and Figma's Mobile, Tablet and Desktop modes hold exactly those values (display 44 / 60 / 80, h1 36 / 48 / 60, h2 32 / 36 / 44, h3 24 / 28 / 32, h4 20 / 24 / 24, product title 16 / 16 / 18, large price 20 / 24 / 24). Section spacing is 48 / 64 / 96 in both.
- **Drift:** none for sizes. The earlier drift (up to 8.6px for Display between Figma's samples and the continuous web value, and up to 13px for section spacing) is gone. A design at a width between breakpoints now matches the web exactly, because the web does not interpolate either.
- All 21 text roles map to 21 Text Styles with equal family, weight, line height (as a percentage), letter spacing (as a percentage) and case, compared by the validator. The text styles bind family, weight and size to Variables; line height and letter spacing stay in the style.
- Fonts: the web self-hosts Latin subsets with a fallback stack; Figma uses its own font library with no fallback. Weights apply by style name in Figma (to verify with the installed fonts).

## 4. Responsive behaviour

| | Web | Figma |
|---|---|---|
| Mechanism | Three stepped tiers by media query | Discrete modes on a frame |
| Granularity | Three tiers (below 600, 600 to 1023, from 1024px) | The three modes (same values as the tiers) |
| Fluid values | None since the 2026-11-11 audit | None |
| Behaviour (scroll, wrap, truncate, hide) | CSS | Intent only: documented per component (breadcrumb Compact, chip row, Load more, drawer Sheet vs Panel) |

## 5. Component architecture

| | Web | Figma |
|---|---|---|
| Unit | CSS classes and native elements (some with small scripts) | Component sets with typed properties |
| Selected | All shipped components | **15 components and 4 patterns**, chosen for genuine reuse; page sections and deferred items deliberately excluded |
| States | CSS pseudo-classes and attributes | A State variant property (Default, Hover, Pressed, Focus, Disabled where relevant) |
| Variants | Modifier classes | Variant, Boolean, Text and Instance-swap properties; variant counts 2 to 45 (Button 3 x 3 x 5), under 60 each |
| Behaviour | Drawer focus trap, Escape, scroll lock, focus restore; Load more states; chip scroll-into-view | **Cannot be represented**; documented as notes and handoff |
| Bindings | Token `var()` references | 'Bindings' tables naming the Variable for each fill, stroke, radius, gap and size; every named variable exists (validator check 9) |

## 6. Developer handoff

The correspondence is explicit: each Figma variable carries its `webToken` and `webRelation` in `variable-map.json`; names map by joining the path with `-`; the Inverse mode is the `.surface-inverse` class; the three modes are the three media-query tiers. Details and what Dev Mode would show (to verify): [01-Design-System/Figma-Specification/developer-handoff.md](developer-handoff.md). **What cannot be handed off from Figma:** behaviour, accessible names and semantics, real photography, loading and network behaviour.

## 7. Import and synchronisation options

| Option | State |
|---|---|
| Create everything by hand from `collections.md` and `components.md` | Always possible; slow |
| `apply-variables.figma.js` (Plugin API) creates the collections and 178 variables | **Generated, never executed.** Its API calls are unverified |
| Figma Variables REST API | Understood to be an Enterprise-plan feature (not re-checked against current Figma documentation here); this account's team is Pro-tier; **no payload generated or tested** |
| Third-party token tools | Not evaluated |
| **Automatic two-way synchronisation** | **Does not exist.** Drift is detected by `validate-figma-variables.ps1` (it compares the Figma specification with the web tokens) but not repaired |

**Figma integration found in this environment:** a connection responds (account handle `ai-tools`, plan "Team Growisto's team", Dev seat, guest role) and exposes write-capable tools. **No write was attempted**: that seat normally cannot create design files, it is a shared company team, no target file was approved, and permissions must not be requested without you. So nothing exists in Figma.

## 8. Limitations and maintenance cost

| | Web | Figma |
|---|---|---|
| Duplication | None; one canonical JSON | A **second** set of values to maintain: every token change is made twice |
| Drift risk | Low (generated CSS; propagation test) | Real; mitigated by the validator, not eliminated |
| Type and spacing steps | Exact | Exact (same tier values) |
| Tooling | PowerShell build and Chromium tests | PowerShell build and validator; nothing run in Figma |
| Verified | Builder, token tests (Chrome, Edge), structural scan, emulated interaction tests | Specification validation only (14 groups, all pass); preview rendered in Chrome; **no Figma, no real device, no screen reader** |
| Unknowns | Safari, Firefox, real devices, Shopify, real photography | All of those, plus: whether Variables bind to Text Style properties as specified, plan limits on modes, Dev Mode output, the Plugin API script |

## 9. Provisional items carried into the Figma system

Load more on phones (nothing verified against Shopify; no "Load previous" recovery designed) and the 4:5 product image canvas (no real photography). Both are marked in the component specifications and the preview.

## 10. Recommended next step

1. Review the **preview** (`01-Design-System/Figma-Specification/Preview/index.html`) and this comparison.
2. Decide whether a **second set of values** is worth its maintenance cost (since the audit the font sizes and spacing match exactly; the remaining cost is maintaining every change twice).
3. If yes, **approve a target**: a new, empty Figma design file in a team where you can edit. Then build the variables (script or by hand), verify them by reading them back against `variable-map.json`, and build one component (Button) end to end before the rest.
4. If no, keep the web system as the single source and use `variable-map.json` and `mapping-report.md` as a reference for designers.
