# NUDGE Beauty: local component system (Figma-like): audit and plan

Status: **audit and plan only. Nothing has been changed.** Shopify/Liquid work is paused and not touched by this plan.
Companion documents: `COMPONENT-INVENTORY.md` (the 79 components built so far), `COMPONENT-ANALYSIS.md`, `01-Design-System/Figma-Specification/components.json` (the Design System's own Figma-style property spec).

## 1. Audit: what exists

### 1.1 What already works (keep)
| Area | Finding |
|---|---|
| Component files | 79 files in `partials/components/{common 9, header 17, homepage 46, layout 7}`; max nesting depth 3; one engine in `build.ps1` (arguments, lists, conditionals, nested includes, escapes) with unit tests |
| Reuse that is real | `icon` 30 call sites, `section-heading` 6, `button-editorial` 6, `mega-column` 8, `logo-item` 8, `gallery-tile` 6, `review-card` 6, `concern-card` 6; header, footer and announcement bar are shared by all 16 pages |
| Design variables | Single source `02-Design-Variables/Styles/variables.css`; `tailwind.config.js` maps 133 `var(--...)` references into Tailwind; component markup has **0 hex colours** and uses token colour utilities throughout (196 on the Homepage); 12 `color-mix()` uses are built from tokens |
| Change safety | Every extraction so far was proved against a stored baseline (16 of 16 pages, per-element compare, pixel diff, behaviour and accessibility tests). A shared update to one component file already reaches every page that uses it, at the next build |
| Design System spec | `components.json` already defines **15 base components** (Button, Icon Button, Input Field, Choice, Chip, Swatch, Badge, Message, Quantity Selector, Rating, Accordion Item, Breadcrumb, Pagination, Drawer, Product Card) with Figma-style properties (VARIANT, BOOLEAN, TEXT, INSTANCE_SWAP), states, bindings and responsive notes |

### 1.2 What needs restructuring
| # | Finding | Evidence |
|---|---|---|
| R1 | **43 of 79 components are fixed markup with no properties.** All 20 Homepage section parents (hero, categories, finder, ritual ...) hold their copy inside the file, so they cannot be configured, only copied | audit |
| R2 | **Variants are raw class strings, not named variants.** 17 components take `class`, `tile`, `img`, `ratio`, `extra`, `bstyle`, `tone`, `hook` arguments (button-editorial, search-button, category-card, gallery-tile, product-card ...). Changing a variant means editing every call site | audit |
| R3 | **The "common" layer mixes levels.** `button-editorial` (3 files), `chip-editorial`, `chip-tag`, `icon-button-circle` are really *variants* of base Button, Chip and Icon Button; `scroller-controls` is a sub-component | audit |
| R4 | **The Design System base components exist only as CSS classes** (`.btn`, `.chip`, `.badge`, `.price`, `.rating`, `.field`, `.qty`, `.accordion`, `.message`, `.drawer` ...) pasted inline in page markup. They have no component file, properties or variants | PLP uses `btn` 14x, `chip` 15x, `accordion` 4x ...; PDP `btn` 11x, `price` 11x, `accordion` 26x |
| R5 | **PLP, PDP, Cart page and Cart drawer are monolithic.** 21 to 71 KB each, **0 component calls**; PLP has 6 sections, PDP 13, Cart 6 (+ the drawer), all inline | audit |
| R6 | **73 fixed pixel values inside components** (Homepage 57, header 7, common 5, layout 4): 2px x13 (hairlines/offsets), 10px x8, 14px x8, 18px x7, 6px x5, 22px x4 ... Several are type or icon sizes with no matching token | audit |
| R7 | **No machine-readable component description.** Properties exist only as prose in `COMPONENT-INVENTORY.md`, and nothing records which variables a component depends on | audit |
| R8 | **Folder layout** is `partials/components/{common,header,homepage,layout}`, not the requested `base/ common/ header/ homepage/<section>/ plp/ pdp/ cart/` | audit |

### 1.3 What is missing
1. A **base layer** of real components (the 15 Design System ones plus Icon, Media/Image, Price, Link, Section Heading, Text roles) with properties and variants.
2. **Properties and content for sections** (R1): heading, text, items, images, buttons as data, with defaults equal to the approved copy.
3. **Main / sub / base classification** and parent-child relationships recorded in one place.
4. **PLP, PDP, Cart page and Cart drawer** component trees (kept separate from the Homepage).
5. **A local component preview** (nothing like it exists; `01-Design-System/index.html` is a static showcase of Design System elements with 1 control, and `02-Design-Variables/Preview` previews tokens, not components).
6. **Documentation generated from the components**: hierarchy, where each is reused, properties, variable dependencies.
7. **Proofs** that a shared update reaches all instances while an instance edit stays local.

## 2. Target architecture

### 2.1 Three levels
| Level | Meaning | Examples (existing in italics) |
|---|---|---|
| **Base** | Smallest reusable UI element; driven only by design variables; no knowledge of any page | Button, Icon Button, Chip, Badge, Input Field, Choice, Quantity Selector, Rating, Price, Swatch, Message, Accordion Item, Breadcrumb, Pagination, Media (image / placeholder), Link, Section Heading, Icon, Text roles |
| **Sub-component** | Belongs to one main component (or a few); assembled from base components | Hero Content, Benefit Item, Category Card, Product Card parts, Tab, Review Card, Ritual Step, Look Pin, Cart Line, Footer Column, Nav Item, Mega Column |
| **Main** | A complete section or page block, placed on a page; owns sub-components and base instances | Announcement Bar, Header, Mega Menu, Footer, Hero Banner, Benefits, Category Grid, Featured Collection ... Cart Drawer, PLP Filters, PDP Gallery ... |

### 2.2 Figma behaviours and how each is delivered
| Figma behaviour | Local equivalent |
|---|---|
| Main component + instances | One component file; every use is an instance (`@@PARTIAL ...`) |
| Variant properties | Named variants defined once in the component's manifest (a table from variant name to its classes); instances choose by name. No raw class strings at call sites |
| Boolean / Text / Instance-swap properties | Same property types as `components.json`: `{{if}}` toggles, text values, and slots that accept another component |
| Nested instances | Components include components; the manifest records children and which nested properties are exposed |
| Edit the main, all instances update | Edit the component file (or its variant table) and rebuild; the library page re-renders every instance live |
| Override an instance without affecting others | Per-instance property values; verified by test |
| Variables / styles | Tailwind theme and DS classes read `variables.css`; changing a variable changes every component that uses it (shown live in the library with a token override) |
| Responsive | The same breakpoints (600/768/1024/1280); library previews at 1440, 1024, 768, 390 |

### 2.3 Component manifest (new, one per component)
Same vocabulary as `components.json` so a later Figma library maps one to one. Fields: `id`, `name`, `level` (base / sub / main), `page` (shared / homepage / plp / pdp / cart), `summary`, `properties` (type VARIANT | BOOLEAN | TEXT | INSTANCE_SWAP | LIST, values, default), `variants` (name -> class set), `slots` and `children`, `tokens` (generated, not hand-written), `usedIn` (generated), `responsive`, `accessibility`, `status`. Hand-written part is small; everything derivable is generated.

### 2.4 Data for sections (fixes R1)
Extend the template language (backward compatible, the old call sites keep working): list items may be objects (`{{each items}}{{item.title}}{{/each}}`), and each section has a defaults file with the approved copy. This is the same data model already designed for the Liquid sections (settings and blocks), so the two stay consistent. Section parents become real templates; their defaults equal today's markup, proved by the existing equivalence tools.

### 2.5 Folder structure (decision D1)
Requested: `components/{base,common,header,homepage/<section>/,plp,pdp,cart}`.
Today the build reads `partials/components/`. **Recommendation:** keep that single implementation root and reshape it into the requested layout (about 80 files move, every include path is rewritten by script, and the move is proved by 16 of 16 equality, so there is no visual risk and no second copy). The library app and docs go in a new top-level folder `07-Component-Library/` (viewer, generated registry, generated docs), because they are a product of the components, not components themselves. Alternative: leave paths alone and only add the registry; I do not recommend it because the structure would stay hard to browse.

### 2.6 Keeping Homepage, PLP, PDP and Cart separate
Page-specific main and sub-components live in their own folder (`homepage/`, `plp/`, `pdp/`, `cart/`). They share only base components and the shared header/footer. The Homepage product card and the PLP product card stay two main components (already approved), built from the same base parts (Media, Title, Price, Badge, Rating, Swatch dots), so their different structure is respected while the parts stay in sync.

## 3. The local library (preview environment)
A static page set (no server, no Node), generated by a PowerShell build, opened from disk in a browser: `07-Component-Library/index.html`.
- **Navigation:** tree by level (Base / Common / Header / Homepage sections / PLP / PDP / Cart), search, status filter.
- **Preview:** each component rendered live, alone, in a resizable frame with width presets 1440 / 1024 / 768 / 390.
- **Properties panel:** generated from the manifest: VARIANT as a select, BOOLEAN as a checkbox, TEXT as a field, LIST as an editable list, INSTANCE_SWAP as a picker. The preview updates as you edit; "reset" returns to defaults.
- **Variants view:** all variants side by side (and states where they exist).
- **Hierarchy tab:** the nested tree with the properties each level exposes.
- **Reuse tab:** every place the component is used (pages and sections, with counts) and the same component rendered in two or three of those contexts.
- **Tokens tab:** which Design Variables control it (colours, type, spacing, radius, shadow), with the resolved values and a live override (change `--color-brand-primary` and watch every instance update), plus any literal values that are not tokens (R6).
- **Docs tab:** properties table, accessibility notes, status.
Rendering uses a JavaScript copy of the template engine plus the already vendored Tailwind Play script and the project's `tailwind.config.js`, so previews look exactly like the wireframes. **Engine parity test:** the JavaScript engine renders every component call in all 16 pages and the output must equal the PowerShell build.

## 4. Implementation plan (each phase is verified before the next; no visual change to approved pages)
| Phase | Work | Exit proof |
|---|---|---|
| P0 Foundations | Manifest format; JS template engine and parity test; registry builder; token-map tool (class -> variable); token-coverage report for the 73 literals (R6) | parity: 100% of call sites equal; 16/16 pages unchanged |
| P1 Base layer | Base components for the 15 DS ones + Icon, Media, Price, Link, Section Heading with named variants; fold button-editorial / chip-editorial / chip-tag / icon-button-circle into Button, Chip, Icon Button variants (Editorial, Circle); replace raw class arguments with variants (R2, R3) | 16/16 equal; manifests valid; each variant rendered in the library |
| P1.5 Library v1 | Library app showing the base layer (preview, props, variants, tokens, reuse) so the system can be seen and judged early | you can drive it in a browser; checks A below |
| P2 Homepage | Reshape into `homepage/<section>/`; every section parent gets properties and defaults; sub-components built from base ones; classification main/sub/base recorded | 16/16 equal; Homepage pixel diff unchanged; library shows all 20 sections |
| P3 Shared chrome | Header (+ mega menu), footer, announcement bar, cart drawer as main components with properties | equal + interaction tests |
| P4 PLP, PDP, Cart | Decompose each page into main / sub / base (sections found: PLP 6, PDP 13, Cart 6 + drawer), page by page with an approval gate after each page | each page equal to its baseline; page-separate folders |
| P5 Docs | Generated hierarchy, reuse map, property tables, variable dependencies | docs regenerate with no manual edits |
| P6 Proofs | Shared-update and independence tests (below); full regression | all green |

### Verification of the Figma-like behaviour (P6, also available live in the library)
1. **Shared update:** change a variant in a base component (for example Button Primary) in a scratch copy: every instance of that variant on every page changes, other variants do not.
2. **Variable update:** change `--color-brand-primary` (or a spacing token): computed styles of every dependent component change; components that do not use it do not.
3. **Instance independence:** override a property on one instance: its siblings stay as they were.
4. **Reuse:** the same base component renders identically in two different sections.
5. Existing suites: pixel diff, per-element equality, behaviour, real-input and accessibility tests, axe-core.

## 5. Risks and how they are handled
- **Visual drift while reshaping:** every step is gated by the existing equality and pixel tools (stored baselines).
- **Over-componentising:** a component is created only when it is reused, has variants, or is a main/sub unit of an approved section; the count is not a goal. Expect the file count to change both ways (fewer button/chip files, more base files).
- **Homepage vs PLP differences:** not merged (rule); shared only at base level.
- **Token gaps (R6):** a literal value is mapped to a token only when it renders identically; anything else is listed for your approval, never silently changed or invented.
- **Effort:** PLP and PDP are the largest (64 and 71 KB). They are staged page by page with an approval gate.

## 6. Decisions needed before building
1. **D1 Folder:** reshape inside `partials/components/` into the requested layout and put the library in `07-Component-Library/` (recommended), or keep current paths and add only a registry.
2. **D2 Token gaps:** may I produce the token-coverage report for the 73 literal values and bring it to you, with no changes until you approve? (recommended)
3. **D3 Base variants:** Button, Chip, Icon Button and Badge keep their approved styles as variants of one component each (Design System style and Homepage Editorial style). OK?
4. **D4 Preview technology:** static HTML and JavaScript using the vendored Tailwind Play script, no Node and no new installs. OK?
5. **D5 Order:** build the base layer and the library first (P0 to P1.5) so you can see and judge it, then the Homepage, shared chrome, then PLP, PDP and Cart one page at a time with approval after each. OK?
6. **D6 Section data:** use the same properties and blocks model as the Liquid sections (so the two stay aligned), with the approved copy as defaults. OK?

---

## Revision 2 (2026-11-17): Shopify compatibility

Superseding notes. The full revised architecture, property classification, conversion check design and page order are in `07-Component-Library/docs/SHOPIFY-COMPATIBILITY-PLAN.md`.

- Phase P0 and P1 (engine, base layer) and Component Library v1 are complete; the master inventory, page-wise breakdown, reuse map, hierarchy, properties and audit report are in `07-Component-Library/docs/`.
- The ten page-local icons are now in the shared sprite (39 icons). Done and verified.
- New rules: template-first (no markup in script strings), explicit inputs, every property classified (design, parent, merchant), data contracts for Shopify-bound components, product metafields pending merchant confirmation.
- New work before any Liquid conversion: conversion check (library versus Shopify snippets), staged Liquid in `07-Component-Library/shopify/staging/`, the existing `06-Shopify-Theme/` stays untouched and is protected by `shopify/06-baseline.json`.
- Revised phase order: P2 Homepage manifests and scopes, P3 shared chrome, P4 PLP, then PDP, then Cart and Drawer, then content pages (one page at a time, each with an approval gate), P5 conversion check built and first Liquid pilot (on approval only), P6 documentation and full verification.