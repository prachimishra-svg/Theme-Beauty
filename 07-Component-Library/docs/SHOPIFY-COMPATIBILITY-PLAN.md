# Shopify Compatibility Plan and Revised Component Architecture

Revision 2, 2026-11-17. This revises `03-Wireframes/00-Shared-Tailwind-Foundation/COMPONENT-SYSTEM-PLAN.md`. Nothing here touches a Shopify store, and nothing in `06-Shopify-Theme/` has been changed.

## 0. Status

| Item | Status |
|---|---|
| Missing icons | **Done and verified.** Ten icons (not five) were defined inside single pages: mail, phone, clock, zoom-in, play, truck, rotate-ccw, shield-check, store, loader. All are now in the single icon source (`05-Assets/Icons/build-icons.ps1`), the standalone SVGs and the shared sprite (39 icons). The page-local copies were removed. |
| Icon proof | All 16 pages are identical outside the sprite, every earlier symbol is unchanged, no id is defined twice, every `<use>` resolves, and all ten icons draw in the library (`tools/verify-sprite-change.ps1`, `tools/test-library.ps1`: 29 of 29 checks). The equivalence baseline was refreshed after that proof. |
| `06-Shopify-Theme/` baseline | **Recorded, read-only:** SHA-256 of all 103 files in `shopify/06-baseline.json`. The theme's sprite still has 29 icons; it is not updated until you approve. |
| Property classification | **Approved and applied** to every manifest (87 components). D10 approved. The conversion check reclassified icon.size and the two label_wrap properties from design to parent, because callers set them. |
| Conversion check | **Built and proven** (section 4): `tools/check-shopify-sync.ps1`, a Library to Liquid transpiler (`tools/liquid-kit.ps1`, `tools/generate-liquid-staging.ps1`), and `tools/test-sync-check.ps1` (12 scenarios). 13 base components are generated into `shopify/staging/snippets` and render identically to the library (83 renders). Report: `docs/SHOPIFY-SYNC-REPORT.md`. |
| Page componentization | Not started; waits for your approval of this plan (section 5). |
| Product metafields | Documented as pending, never hardcoded (section 6). |

## 1. Rules that every component must follow

1. **Template-first.** A component's markup lives in one template. No markup in JavaScript strings. Scripts only change state, classes and text of markup that a template already rendered. (PLP, PDP and Cart currently break this rule; section 5.)
2. **Explicit inputs only.** A component reads only its declared properties (and, for data-bound components, a declared data contract). Liquid's `render` also isolates scope, so this maps one to one.
3. **No hidden dependencies.** Every nested component is named in the template with explicit arguments. No dynamic component names (Liquid cannot render a snippet by variable name).
4. **Design Variables only.** Colour, type, spacing, radius and motion come from the Design Variables through the Tailwind mapping. Fixed values are listed in the token report and are not added.
5. **Every property is classified** (section 3) and every data field is declared (section 6).
6. **Wireframe-only things are marked** and stay out of Shopify: annotation notes, the width panel, `data-c` hooks, placeholder captions and tones.
7. **One name everywhere** (section 8).

## 2. Revised architecture

```
Design Variables (02) ──► Tailwind mapping ──► Design System classes
                                                      │
Base components   (icon, button, chip, icon-button, badge, media, price, rating, quantity, message, breadcrumb, input-field, section-heading, + choice, cart-line, accordion-item, pagination, drawer to come)
        │ used by
Sub-components    (cards, steps, menu columns, footer columns ...)
        │ used by
Main components   (one per section: header, footer, hero, product grid, cart ...)
        │ composed into
Pages             (16 wireframes)

Shopify contract layer (new, in 07-Component-Library/shopify/)
   shopify-map.json            component  <->  snippet / section, parameter names, test cases
   property scopes             in each manifest (design | parent | merchant)
   data contracts              Shopify object fields each data-bound component reads
   sync-lock.json              hash of what was last in sync
   06-baseline.json            protects the existing theme
   staging/                    any new or changed Liquid, never written into 06 without approval
```

### How each library element becomes Liquid

| Library | Shopify | Rule |
|---|---|---|
| Base or sub-component | `snippets/<name>.liquid`, called with `{% render 'name', param: value %}` | Parameter names are the property names in snake_case. Variant values are identical strings. |
| Main component (section) | `sections/<name>.liquid` with a `{% schema %}` | Merchant properties become settings; each LIST becomes a block type. |
| LIST property | blocks (or a link list / collection setting) | `itemFields` become block settings. |
| INSTANCE_SWAP | a `select` setting (if merchant) or a parameter (if parent) | Icon names match the sprite ids. |
| BOOLEAN | `checkbox` setting or a parameter | |
| VARIANT | `select` setting or a parameter | Values never renamed. |
| Variant class tables | `{% case %}` blocks | Liquid has no maps. |
| Shared sprite | `snippets/icon-sprite.liquid` generated from `05-Assets/Icons` | |
| Header, footer, announcement bar | section groups | As in the existing theme. |

Template language translation (mechanical, so it can be checked): `{{x}}` to `{{ x | escape }}`; `{{if x}}` to `{% if x %}`; `{{if x=v}}` to `{% if x == 'v' %}`; `{{each l}}` to `{% for item in l %}` with `forloop.first/last/index`; `@@PARTIAL` to `{% render %}`.

Known structural limits to design for now: no dynamic snippet names (the header mega menu picks a menu by name and must become an explicit `case`); `render` passes no outer variables; a section is limited to 50 blocks (verify against current Shopify documentation before relying on any limit).

## 3. Property classification

Three origins for every value, plus one exclusion.

| Class | Meaning | In Liquid |
|---|---|---|
| **Fixed by Design System** | Decided by the Design System or derived from another property. Nobody sets it per use. | Hard-coded in the snippet or CSS; not a parameter, not a setting. |
| **Passed from Parent** | Supplied by the calling snippet or section in code: structure, state, variant choice, data from Shopify objects, wiring, translatable text. | A `render` parameter. |
| **Merchant Editable** | Typed or chosen by the merchant in the theme editor. | A setting or block setting in the section schema, passed down as a parameter. |
| *Wireframe-only* (exclusion) | Review aids that do not exist in the theme. | Dropped. |

Two refinements, so the classes stay honest:
- **The class is a default at the base level.** The section decides what it exposes. A section's manifest gets an `exposes` list naming which child properties become settings. A base property is never exposed unless a section lists it.
- **Merchant-editable only exists at section or block level.** A merchant can never edit a property of a snippet directly; they edit a setting that a section passes down.

### Manifest additions (applied when each manifest is written or revised)
```json
{ "name": "label", "type": "TEXT", "default": "Shop now",
  "scope": "merchant",
  "shopify": { "param": "label", "setting": "text", "translatable": false } }
```
`scope` is `design`, `parent`, `merchant` or `wireframe`. The validator will require `scope` on every property and `shopify.setting` on every merchant property.

### Draft result for the 13 base components (70 properties)
| Class | Count | Properties |
|---|---|---|
| Merchant Editable | 10 | button.label, button.href, chip.label, chip.href, breadcrumb.items, media.image, media.alt, message.text, section-heading.title, section-heading.lead |
| Fixed by Design System | 0 | None of the 70 properties. The conversion check showed that every property a caller can set is a parameter (icon.size and the label_wrap properties were first drafted as design-fixed and were reclassified). The class still applies to what is not a property: tokens, CSS and values derived from another property |
| Passed from Parent | 55 | variants, elements, states, data (price, compare, unit, rating, count, quantity), wiring (id, attrs, hook, extra), form wiring, accessible names (locale strings) |
| Wireframe-only | 8 | editHook (x4), media tone, media dim, media nodim, media label |

**Items for your review (marked `needsReview` in the file):** button.size (design versus a merchant choice of small, medium, large), button.variant and chip.variant (parent, or a merchant style select), button.icon, chip.label and chip.href (setting versus data), media.alt (setting versus Shopify image alt), media.ratio (design scale versus a merchant select).

## 4. Conversion check (library versus Shopify)

Goal: whenever a library component changes, say whether the Shopify implementation needs updating, and prove it, not guess it.

### Inputs
- `shopify/shopify-map.json`: for each component, its Liquid artifact in `06-Shopify-Theme/` (or staging), parameter mapping, and test cases. A draft is produced by name rules; 48 of 84 components match an existing snippet or section by name today (section 4.3).
- `shopify/sync-lock.json`: for each mapped component, the library hash and Liquid hash at the last confirmed sync.
- `shopify/06-baseline.json`: file hashes of the existing theme (done).

### Four layers, run by one command (`tools/check-shopify-sync.ps1`)
1. **Contract hash (fast).** Hash of the manifest (names, types, defaults, values, scopes), the template with whitespace and token names normalised, and the class list. Differs from the lock: the component is **STALE** and the report lists exactly what changed (property added, variant value changed, class changed).
2. **Output equivalence (the reliable part).** Render the library component for every variant combination and the real call-site examples, render the mapped Liquid with the same inputs (using the LiquidJS renderer already used by `06-Shopify-Theme/tools`), normalise both, compare. A difference is **DIFFERS** with the first differing fragment.
3. **Property consistency.** `design`: no parameter or setting exists. `parent`: the snippet accepts the parameter. `merchant`: the section schema has a setting of the declared type and id. Missing or extra items are listed.
4. **Shared assets.** Design Variables file versus the theme copy (today equal apart from one generated header line), the icon sprite versus `icon-sprite.liquid` (today 39 versus 29), and whether every CSS class a component uses exists in the theme CSS.

### Statuses shown per component
`IN SYNC`, `STALE` (library changed since the lock), `DIFFERS` (outputs differ), `DRIFT` (the Liquid changed without a library change), `NOT MAPPED`, `NOT IN SHOPIFY YET`, `PENDING DATA` (reads an unconfirmed metafield). The library shows the status on each component, and the check writes `docs/SHOPIFY-SYNC-REPORT.md` and returns a failing exit code if anything is STALE, DIFFERS or DRIFT.

### Workflow
Edit a component, run the check, read the STALE list, update the Liquid in `shopify/staging/`, run the check again, accept the new lock only when layers 2 and 3 pass. The existing theme is read, never written. Anything that needs to change in `06-Shopify-Theme/` is listed for your approval first.

### 4.3 What a first run would report today (read-only scan)
- **Matched by name: 48 of 84.** Sections map as expected (for example category-section to `category-grid`, compare-section to `before-after`). Names differ in places: the library has one `base/button` and one `base/chip` with variants, while the theme has `button-editorial`, `chip-editorial` and `chip-tag`; `homepage/product-card` is `product-card-home`.
- **Not matched: 36.** Base components added after the theme was built (badge, breadcrumb, icon-button, input-field, media, message, price, quantity, rating), parts the theme inlines inside sections (hero parts, promo parts, video parts, menu panels, newsletter parts, footer brand and payments, ritual controls and others), and three header parts (account-button, market-selector, search-button) that exist in the theme as `header-account`, `header-localization` and `header-search`, so the map needs those exceptions.
- **Theme-only snippets:** cart-line, chip-tag, fonts, header-account, header-localization, header-search, icon-sprite.
- **Variables:** in step. **Icon sprite:** theme has 29, library 39 (the ten icons are not in the theme yet; needs your approval).
- The check is therefore expected to start with many `NOT MAPPED` and a few `DIFFERS`. That is information, not failure. The map is completed per page as pages are converted.

## 4.4 What the conversion check found while being built

- A bare `size` parameter evaluates to 0 in LiquidJS, so `size == nil` never applies a default. Properties named size, first or last now carry an explicit Shopify parameter name (icon_size, button_size, mega_cards_first, gallery_tile_size, product_card_size).
- Properties callers can set are parameters, never design-fixed: three were reclassified.
- Wireframe-only properties are forced empty in Liquid and blanked on the library side, so both are compared without them.
- A broken wireframe build, a changed theme file, library changes with stale Liquid, and hand-edited Liquid are each reported and fail the check (proved by the 12 scenarios in `tools/test-sync-check.ps1`).
- Limits: LiquidJS is not Shopify; layer 2 proves the two outputs agree under LiquidJS only, and the final proof still needs a store. The transpiler covers the base components; string-pair lists ({{href}}) and sections are the next transpiler steps. The theme CSS is extracted from the Homepage only, so class coverage for other pages is informational until the Tailwind build.

## 5. Page componentization (before any Liquid conversion)

### Method for every page
1. Write each new component's manifest with `scope` on every property and a data contract where it reads Shopify data.
2. **Template-first refactor.** Move markup out of page scripts into component templates. The page script keeps its behaviour but renders nothing new from strings. Sample data (JSON in the library) feeds the wireframe, the same shape Shopify objects will feed later.
3. Convert the page to components with **no visual change**: equivalence check (16 of 16), pixel comparison, library tests.
4. Add the page's components to the sync map as `NOT IN SHOPIFY YET`.
5. Show you the result; no Liquid until you approve that page.

### New base components needed (from the audit)
Choice (checkbox, radio, option card, swatch variants), Cart Line Item (page and drawer variants), Accordion Item, Pagination, Drawer, plus adoption of the existing Badge, Price, Rating, Quantity, Message, Breadcrumb, Input Field and Media.

### Order (one page per step, each with its own approval)
1. Homepage sections: manifests, scopes, `exposes` lists (the markup is already componentized).
2. Shared chrome: header (including the explicit mega-menu `case`), footer, announcement bar, cart drawer.
3. PLP (largest script-built markup: cards, facets, chips).
4. PDP (pickers, gallery, buy buttons).
5. Cart (and the drawer line shared with it).
6. Content pages: Contact, FAQ, About, Our Story.
7. Policy pages (Shipping, Returns, Privacy, Terms), Blog Listing, Blog Article, 404.

## 6. Product data and metafields

All of these stay documented as **PENDING MERCHANT CONFIRMATION** and are never assumed or hardcoded:

| Field | Used for | Rule until confirmed |
|---|---|---|
| `custom.size` | size text on cards | declared in the data contract, shown only if present |
| `custom.highlight` | card highlight line | same |
| `reviews.rating` | rating stars | same; no default number |
| `reviews.rating_count` | review count | same |
| tag `badge:<text>` | product badges | same; no default badge text |

Rules: a component that reads one of these declares it in its data contract with `pending: true`; the wireframe shows clearly labelled sample data; the sync check reports the component as `PENDING DATA`; when a field is absent the component hides that part rather than showing a made-up value. Sample data lives in the library only and is never copied into the theme.

## 7. Protecting the existing theme

- `06-Shopify-Theme/` is read-only for this work. Its 103 files are hashed in `shopify/06-baseline.json`; the check reports any file that changes.
- New or changed Liquid is written only to `shopify/staging/`. Promotion into `06-Shopify-Theme/` is a separate step that needs your approval and a diff.
- No store connection, push or publish.

## 8. One naming scheme

| Thing | Library | Shopify |
|---|---|---|
| Component id | `group/kebab-name` | snippet `kebab-name` (base and common), `group-name` for header and layout parts; exceptions in `shopify-map.json` |
| Section | `homepage/xxx-section` | `sections/xxx.liquid` (existing names kept via the map) |
| Property | camelCase | snake_case (`iconPosition` becomes `icon_position`) |
| Variant values | kebab strings | identical strings |
| Icons | sprite id `icon-name` | same id in `icon-sprite.liquid` |
| Design variables | `--color-...`, `--space-...` | the same file, copied unchanged |
| Block types | LIST property name | snake_case block type |

Variable and sprite copies are checked by layer 4.

## 9. Decisions needed

| # | Decision | Recommendation |
|---|---|---|
| D7 | Approve the three-class vocabulary plus the wireframe-only exclusion, and the `scope` and `shopify` manifest fields | Approve |
| D8 | Approve the `exposes` rule: a property is merchant-editable only when a section lists it | Approve |
| D9 | Approve the staging rule: new Liquid goes to `shopify/staging/`, never into `06-Shopify-Theme/` without approval | Approve |
| D10 | The 8 flagged classifications: **approved 2026-11-17**, all Passed from Parent | Done |
| D11 | Approve the template-first refactor of the script-built PLP, PDP and Cart markup (no visual change, verified) | Approve |
| D12 | Approve adding the ten icons to the theme sprite later (as part of the first sync) | Approve, later |
| D13 | Confirm the page order in section 5 | Confirm |

## 10. Risks and limits

- The conversion check is new and unproven until built; layer 2 depends on LiquidJS matching Shopify's Liquid closely, so a final proof still needs a store.
- Any classification can be revisited, but changing a property's class after Liquid exists means a schema change, so decide classes before conversion.
- Template-first refactoring of PLP, PDP and Cart touches the largest, most script-heavy pages; each is gated by the equivalence and pixel checks and your approval.
- Theme-editor limits (blocks per section, setting counts) must be checked against current Shopify documentation when each section schema is written.
