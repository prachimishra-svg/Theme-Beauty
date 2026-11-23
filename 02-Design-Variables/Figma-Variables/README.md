# NUDGE Beauty Theme Figma Variables (specification, not a Figma file)

A **Figma-specific** version of the NUDGE design variables, built to be compared with the web implementation in [`../`](../). It is independent: nothing here changes, imports from at run time, or is imported by the web system. The web system stays the source of truth for the website; this folder is a proposal for how the same design should be organised **inside Figma**.

> **Status.** Everything in this folder is a **file in VS Code**. **Nothing was created in Figma.** See "Figma integration" below for exactly what was and was not checked.

## What is here

| File | Kind | Purpose |
|---|---|---|
| `collections.source.json` | **Source** (edit this) | The 5 collections, their modes and the reasons for each mode (and the modes deliberately not created) |
| `primitives.json` | **Source** | Colour primitives (19) |
| `spacing.json` | **Source** | Spacing scale, radius, stroke and opacity primitives (24) and the 3 Effect Styles (shadows) |
| `typography.json` | **Source** | Font family and weight primitives (6), font sizes in px (21, Typography collection), and the 21 Text Styles |
| `semantic.json` | **Source** | Semantic colour roles (51), modes Default and Inverse |
| `layout.json` | **Source** | Layout variables (11) and the 3 Grid Styles |
| `component-variables.json` | **Source** | Component-level variables (41); only shared values, not one per property |
| `figma-tools.ps1` | Tool (library) | Loads the sources, resolves aliases per mode, reads the web tokens read-only |
| `build-figma-variables.ps1` | Tool (generator) | Writes the four generated files below |
| `validate-figma-variables.ps1` | Tool (validator) | Runs 14 check groups (13 checks plus an unexpected-error net) and writes `validation-report.md` |
| `variable-map.json` | **Generated** | The consolidated map: every variable, mode, alias and resolved value; text, grid and effect styles |
| `collections.md` | **Generated** | Readable collection, mode and variable tables |
| `mapping-report.md` | **Generated** | All 333 web tokens classified: shared, mapped differently, not a variable (with the Figma alternative), not promoted |
| `apply-variables.figma.js` | **Generated, NOT EXECUTED** | A Figma Plugin API script that would create the collections and variables |
| `validation-report.md` | **Generated** (by the validator) | The actual validation results |
| `web-baseline.manifest.json` | Baseline | SHA-256 of all 82 web-system files (01-Design-System without Figma-Specification, 02-Design-Variables without Figma-Variables, and 05-Assets), so the validator can prove the Figma tools did not touch the web system. First taken (64 files) **before** these folders were created; re-recorded on 2026-11-03 after the project was reorganised into numbered sections and renamed to NUDGE, which intentionally moved and edited web-system files. Re-recorded again on 2026-11-11 (82 files) after the typography and spacing audit, which deliberately changed 23 web-system files (tokens, generated CSS and docs, the Design System showcase and docs, the logo page). Re-take it again only after a deliberate web-system change |

**Rule:** edit only the `Source` files, then run the generators. Generated files are overwritten.

## The proposal in one table

| Collection | Modes | Variables | Why |
|---|---|---|---|
| **Primitives** | Value | 54 | Raw palette, spacing scale, radius, stroke, opacity, font families and weights (hidden from publishing) |
| **Semantic** | Default, Inverse | 51 | What a colour is for. **Inverse** mirrors the web `.surface-inverse` scope (11 roles change). No Dark mode: the web system has none |
| **Layout** | Mobile, Tablet, Desktop | 11 | The web's three tiers (seven tier tokens, including section spacing 48 / 64 / 96) |
| **Typography** | Mobile, Tablet, Desktop | 21 | Font sizes in **px**, whole and even; each mode holds the web tier value exactly (the web sizes are no longer fluid) |
| **Components** | Value | 41 | Touch target, control heights, icon, choice and swatch sizes, focus ring |

178 variables, 5 collections. Names mirror the web token path with `/` (`--color-bg-page` is `color/bg/page`), so a designer and a developer find the same value. Details: [collections.md](collections.md).

## Commands

```powershell
powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Figma-Variables/build-figma-variables.ps1     # regenerate variable-map.json, collections.md, mapping-report.md, apply-variables.figma.js
powershell -ExecutionPolicy Bypass -File 01-Design-System/Figma-Specification/build-figma-docs.ps1      # regenerate the component docs, typography styles and preview data
powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Figma-Variables/validate-figma-variables.ps1  # validate everything and write validation-report.md
```

## Figma integration: what was checked

- A Figma connection **is available** in this environment. The read-only account check succeeded (handle `ai-tools`, plan "Team Growisto's team", **Dev seat, guest role**).
- The connection exposes tools that can create a file and run the Plugin API, so writing to Figma is possible **in principle**.
- **No write was attempted, and nothing was created in Figma.** Reasons: the only account is a Dev seat with a guest role on a shared company team, which normally cannot create or edit design files; no target file was approved; and you asked me not to request access or change permissions.
- Not verified: whether that account may create files; the Plugin API calls in `apply-variables.figma.js`; whether Variables bind to Text Style properties as specified (see [typography-styles.md](../../01-Design-System/Figma-Specification/typography-styles.md)); the mode limit of your Figma plan (this proposal needs up to 3 modes in a collection).

## How to bring this into Figma (plan, untested)

1. **Approve a target**: a new, empty Figma design file (not an existing one) in a team where you have edit rights.
2. **Variables**: either create them by hand from `collections.md`, or run `apply-variables.figma.js` in that new file (Plugins, Development, New plugin, or the Plugin API console). Review the script first; it has never been run.
3. **Styles**: create the 21 Text Styles, 3 Effect Styles and 3 Grid Styles from [typography-styles.md](../../01-Design-System/Figma-Specification/typography-styles.md) and `variable-map.json`.
4. **Components**: build from [components.md](../../01-Design-System/Figma-Specification/components.md), binding every named variable.
5. **Verify** the result by reading the variables back and comparing with `variable-map.json`.
6. The Figma Variables **REST API** can also write variables, but it is documented as an Enterprise-plan feature; this account is on a Pro-tier team, and no payload was generated or tested.

## Validation

Run the validator and read [validation-report.md](validation-report.md). It covers JSON syntax and schema, duplicate and conflicting names, alias resolution and layering, unsupported value forms, typography units (px, no points), consistency with the web tokens (every variable and text style that names a web token is compared per mode against an independent resolution of the web value), coverage of all 333 web tokens, component bindings, generated-file freshness, preview data consistency, and separation from the web system.

## Limitations

- A **specification**, not a Figma library. It has not been opened, imported or tested in Figma.
- Since the 2026-11-11 audit the web has no fluid sizes, so the Mobile, Tablet and Desktop modes match the web tiers exactly (before, nine fluid sizes were sampled at 360, 768 and 1280px).
- Fonts: Figma uses installed or library fonts with no fallback stack; weights are applied by style name.
- There is **no automatic synchronisation** with the web tokens. Keeping the two aligned is manual, supported by the validator, which compares them but does not repair anything.
