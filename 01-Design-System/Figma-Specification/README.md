# NUDGE Beauty Theme Figma Design System (specification, not a Figma file)

A **Figma-specific** design system specification for NUDGE, a premium beauty and skincare brand. It sits beside, and does not replace, the web Design System in [`../`](../). Use it to review and compare how the same system could be organised for **Figma workflows** before deciding how to proceed.

> **Status.** This folder contains files written in VS Code. **Nothing was created in Figma.** The preview page is a preview of a **proposed** Figma system, not a Figma file. See [../../02-Design-Variables/Figma-Variables/README.md](../../02-Design-Variables/Figma-Variables/README.md) for the Figma integration findings.

## Contents

| File | Kind | Purpose |
|---|---|---|
| [components.json](components.json) | **Source** | The component architecture: properties, variants, auto layout, bindings, state styles, accessibility and handoff notes for 15 components and 4 patterns |
| [components.md](components.md) | **Generated** | The component specifications in readable form |
| [component-properties.md](component-properties.md) | **Generated** | Every property of every component in one table, and what each property type means |
| [typography-styles.md](typography-styles.md) | **Generated** | The 21 Text Styles, and how Variables, Styles and properties differ |
| [foundations.md](foundations.md) | Authored | Colour, type, spacing, layout, elevation, imagery and iconography rules for Figma |
| [page-structure.md](page-structure.md) | Authored | The proposed Figma file and page structure |
| [accessibility.md](accessibility.md) | Authored | Contrast results computed from the Figma values, and Figma-specific accessibility practice |
| [developer-handoff.md](developer-handoff.md) | Authored | How a Figma value maps to a web token, what Dev Mode shows, and what cannot be handed off |
| [build-figma-docs.ps1](build-figma-docs.ps1) | Tool | Generates the three Markdown files and `Preview/preview-data.js` |
| [Preview/](Preview/index.html) | Preview | A browser review page; it reads `Preview/preview-data.js` (generated) and holds no values of its own |

Variables live in [`../../02-Design-Variables/Figma-Variables/`](../../02-Design-Variables/Figma-Variables/); this folder never defines a value, it only binds to variables by name (and the validator proves every named variable exists).

## How to review

1. Open `Preview/index.html` in a browser (no server needed).
2. Read [FIGMA-VS-WEB-SYSTEM.md](FIGMA-VS-WEB-SYSTEM.md) for the comparison with the web system.
3. Run the validator (see the variables README) and read `../../02-Design-Variables/Figma-Variables/validation-report.md`.

## Selected components

Button, Icon Button, Input Field, Choice (checkbox and radio), Chip, Swatch, Badge, Message, Quantity Selector, Rating, Accordion Item, Breadcrumb, Pagination (numbered and Load more), Drawer, Product Card. They were chosen because each has a real use in collection, product or filter flows; the others in the web system (header, navigation, footer, toast, cart drawer content) are page sections or deferred and are deliberately not specified here.

## Provisional and unverified

- **Load more on phones** is provisional (nothing verified against Shopify); the Pagination component marks it and does not design a "Load previous" recovery.
- **The 4:5 product image canvas** is a provisional default; no real photography exists.
- **Drawer behaviour** (focus trap, Escape, scroll lock, focus restore) cannot be shown in Figma; it exists in the web implementation, tested in Chromium only.
- Nothing here has been tested in Figma.

## Browser preview (review dashboard)

Open `01-Design-System/Figma-Specification/Preview/index.html` directly in Chrome or Edge. No server is needed: the page loads generated scripts (`preview-data.js`, `validation-data.js`) instead of fetching JSON, which `file://` blocks.

- **This is a browser preview of a proposed specification, not a Figma file and not a Figma Variables panel.** Nothing has been created in Figma.
- Every value is read from the generated data, which is built from the Figma-specific sources. Regenerate with `02-Design-Variables/Figma-Variables/build-figma-variables.ps1`, then `01-Design-System/Figma-Specification/build-figma-docs.ps1`, then `02-Design-Variables/Figma-Variables/validate-figma-variables.ps1` (this writes `validation-data.js`).
- Fonts (Cormorant, DM Sans) are borrowed read-only from `05-Assets/Fonts`. If they fail to load, the page says so.
- Test: `powershell -ExecutionPolicy Bypass -File 01-Design-System/Figma-Specification/test-preview.ps1 [-OutDir <screenshot folder>]` drives Chrome or Edge over the DevTools protocol (Blink only; not Firefox, Safari, a real phone or a screen reader). It never modifies the project.
- The headline never says "fully validated": it reports specification checks only, and flags out-of-date or missing validator data.
