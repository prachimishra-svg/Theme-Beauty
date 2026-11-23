# Developer handoff (Figma to web)

How a value, style or component in the proposed Figma system corresponds to the existing web system, what Dev Mode would show, and what cannot be handed off. The correspondence is machine-readable: every Figma variable in `02-Design-Variables/Figma-Variables/variable-map.json` has a `webToken` and a `webRelation` (shared, mapped, figma-only).

## Name correspondence

| Figma | Web | Rule |
|---|---|---|
| Variable `color/bg/page` | `--color-bg-page` | Path joined with `-` and prefixed `--` (shared) |
| Variable `space/4` | `--space-4` | Same |
| Variable `radius/control` | `--radius-control` | Same |
| Variable `font-size/h1` | `--font-size-h1` | **Shared**: the web tier values (36 / 48 / 60px) are the Figma Mobile / Tablet / Desktop values exactly |
| Variable `font-size/body` | `--font-size-body` | Shared: `16px` in both |
| Variable `layout/gutter` | `--layout-gutter` | Shared per tier: Mobile, Tablet, Desktop modes are the web's 0 to 599, 600 to 1023, 1024 and up |
| Variable `layout/section-spacing` | `--space-section` | **Shared**: web tier 48 / 64 / 96px, Figma aliases space/12, space/16, space/24 |
| Variable `layout/drawer-width` | `--layout-drawer-width` | **Mapped**: web is `100%` below 600px; Figma Mobile value is reference-only |
| Variable `color/link/default` | `--color-link` | **Mapped by name** (Figma groups the four link roles) |
| Variable `color/overlay/scrim` | `--color-overlay-scrim` | **Mapped**: a literal colour with alpha in Figma; a colour and an opacity token on the web |
| Semantic mode **Inverse** | the class `.surface-inverse` | A frame in Inverse mode is an element with that class |
| Text Style `Label/Button` | `.btn` text role, `--type-button-*` | The 21 styles are the web's 21 composite type roles |
| Effect Style `Elevation/Medium` | `--shadow-md` | Same layers |
| Grid Style `Grid/Products Mobile` | `--grid-columns-products` (2) | The web changes the column count with a media query |
| Component `Button` | `.btn`, `.btn--primary`, `.btn--secondary`, `.btn--text` | Variant property to modifier class |

The full list, including the 152 web tokens that are **not variables** in Figma and their alternatives, is in [../../02-Design-Variables/Figma-Variables/mapping-report.md](../../02-Design-Variables/Figma-Variables/mapping-report.md).

## What Dev Mode would show (to verify once a file exists)

- Variable names and the alias chain for bound properties (for example `color/button/primary-bg` to `color/brand/primary` to `palette/rose/700`). That chain is the same as the web token chain.
- Text Style names and their properties. Line height and letter spacing appear as percentages (the web uses unitless ratios and em values: 110% is `1.1`, -1.5% is `-0.015em`).
- Auto Layout as flex properties. Fill, Hug and Fixed map to `width: 100%`, `fit-content` and a fixed size; a bound gap or padding shows the variable name.
- Component properties as props. Variant properties become modifier classes or data attributes; booleans show or hide child elements; text properties are content; instance swaps are slots.

Dev Mode behaviour was **not** verified here: no Figma file exists.

## Responsive handoff

Figma has no media queries. A design set to the Mobile, Tablet or Desktop **mode** corresponds to the web system's three tiers. The developer implements the change with the web's `@media (min-width: 37.5rem)` and `(min-width: 64rem)`, which already generate the tier values from `02-Design-Variables`. Fluid sizes and section spacing are **continuous** on the web; do not hard-code the three sampled values.

## What cannot be handed off from Figma

- Behaviour: the drawer's focus trap, Escape, scroll lock and focus restore; Load more states, URL synchronisation and recovery; the chip row's scroll-into-view; the accordion's native toggling. They are specified in the component notes and implemented (in Chromium-tested form) in the web system.
- Accessible names, roles, fieldset and legend semantics, reading order and live-region announcements: documented in annotation text only.
- Real photography: none exists; crop and focal point are undefined.
- Loading and error timing, bfcache and network behaviour.

## Keeping Figma and the web aligned (options, none implemented)

| Option | State |
|---|---|
| **Manual** (designer updates Figma from the web value, or the reverse), checked by `validate-figma-variables.ps1`, which compares them | Works today; the validator detects drift but does not repair it |
| **Plugin API script** (`apply-variables.figma.js`) to create variables from `variable-map.json` | Generated, **never executed** |
| **Figma Variables REST API** to write or read variables | Documented as an Enterprise feature; not available to this account; nothing generated or tested |
| **Third-party token sync tools** | Not evaluated |
| **Automatic synchronisation** between the two systems | **Does not exist** |

Because the web `02-Design-Variables` JSON is canonical and the Figma specification is separate, a change must be made in both places. The recommended review step before adopting either approach is in `FIGMA-VS-WEB-SYSTEM.md`.
