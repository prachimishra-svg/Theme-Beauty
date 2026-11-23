# NUDGE Beauty: Tailwind foundation for the wireframes

- `tailwind.config.js` maps Tailwind's theme (colours, spacing, type, radius, shadow, z-index, breakpoints, drawer width, aspect ratios) to the existing Design Variables (`02-Design-Variables/Styles/variables.css`). It defines no new values, so the tokens stay the single source and their responsive tiers carry through.
- `tailwindcss-play-3.4.17.js` is a local copy of the official Tailwind Play script (SHA-256 176E894661AA9CDC9A5CBA6C720044CBBF7B8BD80D1C9A142A7C24B1B6C50D15), used so the wireframes render offline. It compiles utilities in the browser and is for wireframes only.
- A page uses it with, in order: `variables.css`, the Play script, then `tailwind.config.js`.
- In the Shopify theme, the same object becomes the `theme` of a normal `tailwind.config.js` and the CSS is compiled with the Tailwind CLI into `assets/`; the Play script is not shipped.
- Breakpoints: `sm` 600, `md` 768, `lg` 1024, `xl` 1280, `2xl` 1536 (mobile-first).
- `build.ps1 -All` rebuilds every page from `src/` and the shared `partials/` into its numbered folder (see `../README.md` for the order); `build.ps1 -Page <name>` builds one. Page folder names are set in the `$pages` list at the top of the script.
- `currency.js` is the shared market and currency behaviour for the header pill and every price (see `../README.md`); `tools/test-currency.ps1` drives the dropdown on a page and checks the prices.
- `tools/` holds the checks used on every page: `run-selftest.ps1` (in-page tests at any width list), `pixel-diff.ps1` (compare two versions of a page), `rect-probe.ps1` (element positions) and `shot.ps1` (screenshots).
- Components: partials/components/ (79 nested components, parents are the Homepage sections and the shared header, footer and announcement bar). The catalogue is COMPONENT-INVENTORY.md, the analysis and decisions are COMPONENT-ANALYSIS.md. 	ools/check-equivalence.ps1 proves a change left all 16 pages unchanged (baseline in 	ools/baseline/); 	ools/test-mega.ps1 tests the mega menu and drawer.
