# Foundations, boundaries and coverage

Governance for the NUDGE Design System: the principles behind the tokens, what belongs where, and which components exist, are deferred, or are deliberately not part of the system. Token mechanics are in [tokens.md](tokens.md); components in [components.md](components.md); accessibility in [accessibility.md](accessibility.md).

Items marked **proposed** are sensible defaults that have not had design sign-off.

## 1. Brand principles

1. **Product first.** Imagery and product names carry the page. UI recedes: pearl and white surfaces, restrained borders, one CTA colour.
2. **A clear colour hierarchy.** Rich Burgundy is the CTA and active-state colour. Luxury Rose marks recognisable brand moments (eyebrows, ratings, heading rules, large serif accents). Blush Rose is a decorative accent. Pearl Pink, white and Rose Quartz carry the page; Midnight Plum carries the type and the dark bands. Emphasis comes from weight, size and space before color.
3. **Editorial, not decorative.** A refined serif for names and headlines, a clear sans for everything functional.
4. **Calm and generous.** Generous space, slow gentle motion, soft radii. Nothing blinks, bounces or shouts.
5. **Practical beauty.** Every element must work with real content: long product names, missing images, many shades, small screens, one hand.

## 2. Responsive strategy (hybrid, mobile first)

Two mechanisms. A third, fluid `clamp()`, was retired in the 2026-11-11 typography and spacing audit because it produced odd and fractional font sizes and off-grid spacing between breakpoints. The full, generated list is [02-Design-Variables/responsive-token-matrix.md](../../02-Design-Variables/responsive-token-matrix.md).

| Mechanism | Used for | Why | Not used for |
|---|---|---|---|
| **Tier** (3 media-query steps, 600px and 1024px) | Gutter, grid gap, product columns, header height, drawer width, card padding, section spacing (48 / 64 / 96px), and the scaled type sizes (display, h1 to h4, product title, large price) | Values that must change together with a layout change at a breakpoint (columns, header navigation, a phone sheet becoming a side panel) | Anything without a layout reason |
| **Static** | Colors, spacing scale, radii, shadows, touch target, most component sizes | Nothing is gained by varying them per viewport | |

Rules:

- **The 4px spacing scale is the default and the only spacing.** `--space-1` to `--space-24` give 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 48, 56, 64, 80 and 96px (28, 36 and 56 were added in the audit). Every spacing value, including the tiers, sits on the 4px grid; `build-tokens.ps1` refuses one that does not, and `test-tokens.ps1` check 8f re-checks it. Section padding is a tier token: 48px on phones, 64px on tablets, 96px on desktop (was fluid, 48 to 104px).
- **Type is stepped and even.** Every font size is a whole, even px value; the scaled sizes step at 600 and 1024px (see typography.md). The order h4 > body large > h5 >= 16px (decision 8) still holds at every width: h4 20 / 24 / 24, body large 18, h5 16. Limitation (unchanged): h5 is the same size as body text, so it differs from body by family (Cormorant) and weight (bold) and not by size.
- **Add a tier token only with a stated reason** (a `$description` explaining which layout change it follows). Otherwise the token is static. Several candidate tier tokens were made static in the decision review because they had no layout reason (large button height and padding, product-card gap, form field gap, thumbnail size). The drawer width was one of them and has since gained a layout reason (a full-width sheet on phones, a 26rem panel from 600px; see section 12), so it is a tier token again.
- **Mobile first, `min-width` only.** Breakpoints are 600px (tablet) and 1024px (desktop); wide screens change nothing (content stays capped at 1280px).
- **Measured change from the previous model:** gutter and grid gap are now stepped (16 / 24 / 40px and 16 / 24 / 32px) instead of fluid. Differences are at most 4.6px (for example, container padding at 1280px went from 36.2px to 40px). Typography was unchanged by that step (it changed later, in the 2026-11-11 audit). **Validated (decision 7):** the computed gutter at 320 to 1920px is 16px below 600, 24px from 600 and 40px from 1024, matching the tokens; the showcase and the dashboard have no horizontal overflow at 320, 360, 390, 599, 600, 768, 1023, 1024, 1280 and 1920px (20 page and width combinations); no product card's content overflows it, down to a 129px card (the showcase grid sits in a padded panel; a bare 16px-gutter grid gives 136px at 320px). The cost of stepping is a visible jump at 600 and 1024px (gutter +8px and +16px per side), which coincides with the column change (2 to 3, 3 to 4).

## 3. Layout and grid

- **Containers:** content is capped at `--container-max` (1280px); extra width becomes margin. Forms and editorial use `--container-narrow` (896px); long text `--container-text` (640px, about 65 characters).
- **Gutter, grid gap:** tier tokens (`--layout-gutter`, `--layout-grid-gap`). **Section space:** tier (`--space-section`, 48 / 64 / 96px). Never hardcode them.
- **Product grid:** 2 columns on phones, 3 from 600px, 4 from 1024px (`.grid--products`). Use `minmax(0, 1fr)` so long names cannot widen a column.
- **No fixed column system (12-col) is defined.** Sections use `.grid--auto` (content-driven), `.grid--2` and `.grid--split`. See section 12 for the deferred page-grid decisions.
- Text-holding components never get fixed heights; use `min-height` only.

## 4. Borders, radius, elevation

| Token | Use |
|---|---|
| `--border-width-thin` (1px) | Dividers, card and control borders |
| `--border-width-thick` (2px) | Errors, selected state, focus; never for decoration |
| `--radius-sm` (4px) | Controls, badges |
| `--radius-md` (8px) | Cards, images |
| `--radius-lg` (16px) | Large panels |
| `--radius-pill` | Chips, swatches, count bubbles |
| `--shadow-sm` | Floating icon buttons |
| `--shadow-md` | Raised cards, popovers |
| `--shadow-lg` | Hover lift, drawers and dialogs |

Prefer a border to a shadow for resting elements; shadows signal "above the page".

## 5. Iconography

One family: **Lucide** (lucide.dev, ISC licence, geometry from lucide-static 0.469.0, only the 29 icons used, never the full library). 24px grid, 1.5 stroke (project standard; Lucide's default is 2), round joins, `currentColor`). Sizes 16 / 20 / 24 / 32 via `.icon--sm/ /lg/xl`. Decorative icons are `aria-hidden`; icon-only buttons carry an accessible name and a 44px target. No emoji or text symbols as UI icons, no second icon set. Names: `search, account (Lucide user), bag (shopping-bag), menu, close (x), plus, minus, chevron-*, arrow-*, filter (sliders-horizontal), sort (arrow-up-down), heart, star, location (map-pin), check, check-circle (circle-check), info, warning (triangle-alert), eye, eye-off, share (share-2), instagram, facebook, youtube`. Filled state only for the selected wishlist heart and rating stars (CSS `.icon--filled`). Lucide has no Pinterest or TikTok icon: do not add one from another set. New icon: add it to `05-Assets/Icons/build-icons.ps1`.

## 6. Imagery and product photography (proposed)

### Ratios and crop

| Use | Ratio | Class / token |
|---|---|---|
| Product card (the default product canvas) | **4:5** portrait | `.ratio--portrait` / `--aspect-portrait`, `--product-image-aspect-card` |
| PDP gallery (follows the card by default) | **4:5** portrait | `--product-image-aspect-gallery` (its own token, so the gallery can diverge without touching cards) |
| Thumbnails | **1:1** | `.ratio--square` / `--aspect-square`, `--product-image-aspect-thumb` |
| Editorial, blog | **3:2** | `.ratio--landscape` / `--aspect-landscape` |
| Collection tiles | **3:4** | `.ratio--tall` / `--aspect-tall` |
| Banners | **16:9** | `.ratio--wide` / `--aspect-wide` |
| Hero | decided in the hero section | see "Hero and promotional imagery" and section 12 |

- Images **fill the frame and crop, never stretch**: `object-fit: var(--product-image-fit)` (cover). Frames are `.ratio` boxes, so space is reserved before the image loads (no layout shift) and no image dimension is hardcoded in CSS.
- **Object position:** default is the centre (`--product-image-position: 50% 50%`). When the subject is not centred, set a per-image focal point inline: `style="--image-position: 50% 20%"` (in Shopify, from the image's focal-point setting). This is data per image, not a token.
- **One background style and one crop per collection.**

### Where 4:5 applies and where it does not (decision 6)

**4:5 is the provisional default canvas for product-card images, and nothing else.** It is a working assumption about how product photography will be mastered, not a validated rule and not a house ratio for every image. **Real product photography has not been supplied**; see "Real product photography: awaiting assets" below.

| Image | Ratio | Rule |
|---|---|---|
| Product card, and the PDP gallery that reuses the same master | **4:5** | The default. The PDP gallery is provisional (it has its own token, decided with the product-page layout) |
| Hero | Set by the hero section: proposed 4:5 / 3:2 / 16:9 (phone / tablet / desktop) | Exception. Art-directed crops through `<picture>`; the subject is re-framed, not stretched. Not the product canvas |
| Editorial, blog, lifestyle | **3:2** (`--aspect-landscape`) | Exception. Composed photography is not re-shot to fit a packshot canvas |
| Collection tiles | **3:4** (`--aspect-tall`) | Exception |
| Promotional banners | **16:9** (`--aspect-wide`), or the ratio the campaign needs | Exception. Text stays live and sits on a solid panel or a scrim; never a product crop |
| Thumbnails | **1:1** | Derived from the 4:5 master; the central 80% of its height must hold the product (checked by the dashboard) |

An exception is a different `.ratio` modifier on a different component, never a different crop of the same product image. Evidence and limits: the ratios are tokens (`aspect.*`) used by the showcase and by `.ratio`; the packaging, 80%-crop and thumbnail specimens are measured by the dashboard. Not verified: real photography (none exists yet), so the canvas rule and the 60 to 80% fill guidance are a proposal to test on the first shoot.

### Real product photography: awaiting assets

No real product photography has been supplied, and none is invented here. The showcase uses gradient placeholders (`.placeholder-media`) and the dashboard uses drawn SVG packaging shapes; **neither is evidence of image quality**. They prove that the frames, tokens and layout behave, not that real photographs will look right in them. Everything below is therefore unvalidated, and the guidance in this section is a proposal until it is tested with representative assets (section 14, risk B):

- the 4:5 canvas itself, including whether it suits both tall slim bottles and wide short jars
- crop with `object-fit: cover`, and the per-image focal point (`--image-position`)
- complete packaging visibility inside the central 80% of the card, and the 60 to 80% fill guidance
- responsive image fit across the 2, 3 and 4 column grids and the thumbnail
- image loading behavior: the `srcset` and `sizes` values, eager versus lazy loading, layout stability while loading, and the failure fallback

### Packaging proportions (the canvas rule)

Products range from tall slim bottles to wide short jars. One crop rule cannot fit all of them, so the **image canvas** is standardised instead of the crop:

- Deliver every **product** image (not hero, editorial or promotional images) on a **4:5 canvas** with the product centred. A tall bottle should fill about 60 to 80% of the height; a wide jar about 60 to 80% of the width. Keep the whole product inside the **central 80% of the height**, because a square thumbnail of a 4:5 image keeps exactly 80% (the dashboard computes this from the aspect tokens and fails if the tokens change and the rule no longer holds).
- **Do not upload extreme-ratio photos and rely on the crop.** A raw 1:3 bottle photo in a 4:5 card with `cover` shows only the middle 42% of its height (see the dashboard specimen). If an image cannot be re-framed, use `object-fit: contain` for that image: the whole product shows, letterboxed on `--product-image-background`. That is a per-image exception, not the default.
- **Cards and the product page use the same canvas master** (card, gallery main image, thumbnails, hover image), so the product looks the same in the listing and on its page. `--product-image-aspect-card` and `-aspect-gallery` are separate tokens only so they can diverge deliberately.

### Hero and promotional imagery

- **Hero:** reserve space with an `aspect-ratio` on the hero section (proposed 4:5 on phones, 3:2 on tablet, 16:9 on desktop; section 12), never a fixed height. The hero image is the page's largest image: load it eagerly with `fetchpriority="high"`, `sizes="100vw"`. A `<picture>` with different crops per viewport is appropriate here, and only here.
- **Text over images:** never rely on the photograph for contrast. Put text on a solid panel, or over a `--color-overlay-scrim` layer, and check contrast against the scrimmed pixels (4.5:1 for text, 3:1 for large text). Keep a text-safe zone away from the subject. No text baked into the image.
- **Promotional tiles** (collection tiles 3:4, banners 16:9) follow the same loading rules; lazy-load unless above the fold. Alt text names the destination, or is empty when a visible heading link already says it.

### Responsive delivery

- **Upload** at least 1600px on the longest edge so zoom stays sharp. **Serve** resized variants through Shopify's image URL filter with a `srcset` of about 360, 540, 720, 900, 1080 and 1440px; the CDN negotiates WebP/AVIF.
- **`sizes` mirrors the grid.** Product card: `sizes="(min-width: 1024px) 25vw, (min-width: 600px) 33vw, 50vw"`. Hero: `100vw`. PDP main image: `(min-width: 1024px) 50vw, 100vw`. Thumbnail: `64px` with a `srcset` of 128, 192 and 256px (1x, 2x, 3x). Update `sizes` when the grid columns change.
- **Loading:** the first visible image is eager with high priority; everything else `loading="lazy"`. Always set intrinsic `width` and `height`, or use a `.ratio` frame.

### Gallery thumbnails (64px, retained)

- `--product-image-thumb-size` is **64px**, 1:1, `cover`, positioned by `--product-image-position`. One size serves every viewport; per-viewport variants are not justified.
- **Interactive:** a thumbnail is a `<button>` (`aria-label`, `aria-current="true"` for the shown image). Its 64px box already exceeds the 44px target, with an 8px gap. The selected one has a 2px border, so selection is not colour alone.
- **Layout:** on phones a horizontally scrolling rail; on desktop it may be a vertical rail beside the main image. **Four thumbnails fit the narrowest supported width** (320px viewport: 4 × 64 + 3 × 8 = 280px in a 288px container); more scroll. 72px would fit only three; 56px would still not fit five (312px).

### Fallbacks and content

| Case | Behavior |
|---|---|
| Missing or failed image | The frame shows `--product-image-background` (Blush); the card must still read: name, price, action. Intrinsic `width`/`height` keep the frame from collapsing. Shopify: render its placeholder SVG inside the frame |
| Alt text | Describe the product and shade, not "image of". If an image fails, the alt text is what shows, so make it meaningful. Decorative lifestyle crops may use empty alt when the caption says the same |
| Text in images | None. Anything that must be read (offers, claims) is live text |
| Shade swatches | Colors come from product data (`--swatch`), never baked into UI tokens; verify swatch accuracy against the real product |
| Sold out | Reduced opacity (`--opacity-muted`) plus a visible "Sold out" badge; never opacity alone |
| Over photography | Do not place bare focusable controls or small text directly on photos; use a solid container (see section 9) |
## 7. Interaction and motion

- **States, in order of priority:** focus (always visible), error, selected, disabled, active, hover. Hover never carries information that other states don't.
- **Hover effects only for hover-capable devices** (`@media (hover: hover)`), for example the product-card image zoom (`--product-card-hover-zoom`).
- **Motion:** `--duration-fast/base/slow` (120 / 200 / 320 ms) with the standard ease; opacity, color and transform only. Reduced-motion preference disables all transitions globally.
- **Feedback is immediate and calm:** color/border/tint change plus a shape or text cue; no bouncing, no shake on error.

## 8. Touch targets (standard: 44 × 44 CSS px)

`--touch-target-min` (44px) is the default size of every interactive target, in both dimensions, **as its box or as an equivalent hit area**.

| Element | How it meets 44px |
|---|---|
| Buttons (default 48px, large 56px), inputs, selects | Box |
| **Small button** (40px visual) and **chip** (40px visual) | Invisible `::after` hit area to 44px high plus a 44px minimum width. The inset also cancels the 1px border (a first version measured only 42px; found by measurement). Keep at least 4px between adjacent small controls so hit areas do not overlap |
| Icon buttons, quantity buttons, swatches, pagination links | Box (44 × 44) |
| Checkbox and radio | The whole label row (≥ 44px high); the 24px box is only the visual |
| Accordion summary, breadcrumb links, navigation links, text button | Box (≥ 44px high; breadcrumb and nav links also ≥ 44px wide) |
| **Standalone links** (footer lists, "View all", arrow links, card titles) | `.link--standalone` (44px high); `.link--arrow` includes it |
| Product card | The whole card is the link target |

**Exceptions (documented, not violations):**

| Exception | Reason |
|---|---|
| Links inside a sentence or paragraph | WCAG 2.5.8 inline exception; enlarging them would break the line |
| Disabled controls | Cannot be activated |
| Skip link | Off-screen until focused; when focused it is a full-size control |
| Decorative mini swatches on product cards (`.swatch--sm`) | Not interactive (`<span>`); if one ever becomes interactive it must use the full `.swatch` |
| Native checkbox/radio input box (24px) | The label row is the target |

An automated audit (`02-Design-Variables/Tokens/test-tokens.ps1`, section 3b) measures every interactive element of the showcase at 390 and 1280px (92 measured at 390px and 94 at 1280px, none below 44px; the two breadcrumb ancestors that are hidden on phones account for the difference) and prints these exceptions.

## 9. Focus indicators

**Ring:** `--focus-ring` = 2px solid `--color-focus-ring`, offset 2px (`--focus-ring-width`, `--focus-ring-offset`). The ring is a **shape** (an outline around the element), not a color change alone; inputs add a border-color change on top of it. It is visible on every interactive element.

**Interpretation of "Blush ring":** Rose Quartz (`#F2D5DC`) is the focus color on **dark surfaces** (11.4:1 on Midnight Plum). It cannot be the default on light surfaces: against Pearl Pink it is about 1.28:1 and against White about 1.37:1, which is invisible. On light surfaces the accessible alternative is **Rich Burgundy** (the brand colour), the ring used everywhere else. So: Rich Burgundy on light and tinted surfaces, Blush on dark.

**Measured with real keyboard focus** (the Design Variables dashboard focuses a button on each surface with `focus()` and reads the rendered outline; needs 3:1, solid, ≥ 2px, offset ≥ 2px):

| Surface | Ring | Ratio | Result |
|---|---|---|---|
| Page (Pearl Pink) | Rich Burgundy | 8.58:1 | Pass |
| Surface (White) | Rich Burgundy | 9.18:1 | Pass |
| Subtle (Rose Quartz) | Rich Burgundy | 6.70:1 | Pass |
| Brand tint / tint strong | Rich Burgundy | 7.92 / 6.53:1 | Pass |
| Error / success / warning tint | Rich Burgundy | 8.03 / 8.10 / 8.18:1 | Pass |
| Dark (`.surface-inverse`) | Rose Quartz | 11.44:1 | Pass |
| Rich Burgundy fill, default ring | Rich Burgundy | **1.00:1** | **Not permitted** |
| Rich Burgundy fill, inverse ring | Rose Quartz | 6.70:1 | Pass |

Rules: on a Rich Burgundy fill use the inverse ring (`--color-focus-ring-inverse`, and also set `--focus-ring: var(--focus-ring-width) solid var(--color-focus-ring-inverse)`, because the composite does not follow a re-mapped color); on dark surfaces use `.surface-inverse`; never put bare focusable controls on photography (use a solid container). Changing a ring token re-runs these checks in the dashboard.

Not verified: a person tabbing through each component, screen readers, forced-colors (high contrast) mode, and focus over photography.

## 10. Responsive navigation (replaces generic show/hide utilities)

There are no `hide-mobile` / `hide-desktop` utilities: a generic `display` reset cannot restore flex or grid. Switch arrangement inside the component, mobile first:

```css
.site-nav__links { display: none; }                 /* phones: links live in the drawer */
.site-nav__menu-button { display: inline-flex; }
@media (min-width: 64rem) {
  .site-nav__links { display: flex; }               /* desktop: inline links */
  .site-nav__menu-button { display: none; }
}
```

The header and drawer themselves are theme sections, built in the storefront phase.

## 11. What belongs where

| Layer | Belongs here | Does not belong here |
|---|---|---|
| **Foundations** | Principles, color roles, type hierarchy, spacing, grid, imagery, motion rules | Page layouts |
| **Tokens** | Named values, defined only in `02-Design-Variables/` | Anywhere else |
| **Components** | Reusable, content-agnostic UI with states (button, input, card, accordion...) | Merchant copy, page structure |
| **Patterns / compositions** | Documented arrangements of components (promo bar = `.surface-inverse` + `.text-utility`; empty state = stack + heading + button) | New CSS unless it repeats |
| **Page sections** | Header, footer, hero, collection grid, PDP layout, cart | Not in the design system; built as Shopify sections |
| **Shopify-specific** | Liquid, section schema, theme settings, predictive search, cart API | Not in the design system |

## 12. Deferred layout decisions (page-specific, not global tokens)

These were proposed as global tokens and removed from the token set because they are page decisions, not reusable layout rules: nothing in the Design System uses them, and they depend on wireframes. They are recorded here with proposed values so they are not lost. A global token is added back only when a layout-consistency need is shown.

| Item | Proposed value | Where it belongs |
|---|---|---|
| Page column grid | 4 / 8 / 12 columns at mobile / tablet / desktop | Only if wireframes need a column grid; the Design System has none |
| Collection tiles, blog, feature blocks | 1 / 2 / 3 columns | The section that renders them |
| Footer link groups | 1 / 2 / 4 columns | The footer section |
| Hero media ratio | 4:5 / 3:2 / 16:9 at mobile / tablet / desktop | A `--hero-ratio` custom property defined inside the hero section; the taller phone ratio keeps the subject large. The generic `.ratio--wide` (16:9) already exists |
| Announcement bar height | None (content-driven) | The bar uses spacing-scale padding and `.text-utility`; a fixed height would clip wrapped text. If a sticky header must sit below it, measure the bar's height and set a section-level `--announcement-height` |
| Drawer width | `100%` below 600px, `26rem` from 600px | Tier token `--layout-drawer-width`. **Phones get a full-width sheet** (decision 5, approved): measured on a specimen at 8 widths, a 26rem cap alone is already full width up to 416px but leaves a 1 to 44px sliver of page at 417 to 460px (12px at 430px), and a fixed 44px peek strip is a dismiss target nobody can discover. From 600px a 26rem panel leaves at least 182px of page. **Built:** `.drawer` in `components.css` and `Scripts/drawer.js` (native `<dialog>`); behavior tested with real key, wheel and mouse events in Chromium, see section 14 and `accessibility.md`. Not tested in Safari, Firefox, with a screen reader or on a real phone |

## 13. Component coverage

| Item | Status | Notes |
|---|---|---|
| Buttons, icon buttons, links | **Built** | |
| Inputs, select, textarea, checkbox, radio, validation | **Built** | Native controls, restyled |
| Quantity, swatches, badges, price, rating | **Built** | |
| Message / inline feedback | **Built** | `.message` |
| Cards, product card, product image containers | **Built** | |
| Breadcrumb, accordion, pagination, filter chip | **Built, reviewed and kept** | See the review in [components.md](components.md) |
| Header, navigation, mobile menu, footer | Page section | Storefront phase |
| Filter drawer (any modal side panel) | **Built**, tested in Chromium only | `.drawer` + `Scripts/drawer.js`: native `<dialog>`, focus wrap, Escape, scroll lock, focus restore, 44px close button, scrolling body, pinned primary action. Needs the manual tests in `manual-testing.md` section 7 |
| Cart drawer | Deferred | Reuse `.drawer`; its content and add-to-cart feedback are decided with the cart design |
| Load more (phones) and numbered pagination (tablet and up) | **Built**, demo loader only | `.pagination-switch`, `.load-more`, `Scripts/load-more.js`; the default fetch loader and Shopify URLs are untested (section 14) |
| Chip row scroll helper | **Built** | `Scripts/chip-row.js` keeps a focused chip fully visible |
| Tabs | Not needed | Accordion covers product information |
| Search with suggestions | Shopify feature | Native search input + predictive search |
| Cart feedback / toast | Deferred | Decide with the cart design; `.message` covers inline cases |
| Promotional banner | Pattern | `.surface-inverse` + `.text-utility` |
| Loading skeleton | Not needed now | Add only if filters or cart become asynchronous |
| Empty / error / success / disabled states | Pattern + existing states | Empty search or collection is page content |
| Reviews list, wishlist page, ingredient tables | Page-specific / app | |

## 14. Subjective decisions: owner approvals and what is verified (decisions 1 to 8)

The owner approved all eight directions (decision 4 as "Load more on phones, numbered on tablet and up"). Two of them stay **provisional** because the evidence to close them does not exist: decision 4 (Load more, risk A) and decision 6 (the 4:5 canvas, risk B). The register after the table lists every open risk and what would close it. **Approved is not verified**: the last column says what an executed check shows and what still needs a person or a real environment. "Chromium" means Chrome and Edge, which share an engine.

| # | Decision | Status | Implemented as | Executed evidence | Not verified / needs |
|---|---|---|---|---|---|
| 1 | Breadcrumb on phones | Approved, implemented | Below 600px: one line, parent plus current page, the current page truncated with an ellipsis; from 600px the full wrapping trail. CSS only | Long name: full trail 88px tall, compact 44px, 215 to 283px of the name visible; 44px targets; no overflow at 320 to 600px; screenshot at 390px | Hidden ancestors are absent from the accessibility tree on phones; screen reader and real phone |
| 2 | Filter chips | Approved, implemented | `.chip-row`: one scrolling line below 600px, wraps from 600px. `chip-row.js` scrolls a focused chip fully into view. Applied filters stay on `.cluster` and wrap | Real events at 390px: a chip is cut off at the edge (discoverable); Tab to the clipped chip scrolls it fully into view; a touch swipe scrolls the row and not the page; 2px ring not clipped. **Found:** browsers scroll a focused control into view only when it is completely hidden, so a partly clipped chip stayed clipped until `chip-row.js` (a plain row of plain buttons behaves the same). Removing the script makes the check fail | A real phone swipe; screen reader; Safari and Firefox focus-scroll behavior |
| 3 | Accordion | Approved, implemented | Rows open independently; `name="pdp"` removed from the showcase (it contradicted the documented default). Exclusive only where a documented use case needs it (none today) | Attribute count 3 to 0 | Safari and Firefox |
| 4 | Phone pagination | Approved direction; **provisional for implementation** (demo loader only; nothing here is verified against Shopify) | Phones: **Load more**; tablet and up: numbered pagination (`.pagination-switch`). Both are real links; the numbered list is `display: none` on phones so a screen reader meets one control. States: loading (list `aria-busy`, button `aria-disabled` and "Loading...", focus stays on the button), success (items appended, status "Showing 8 of 16 products" announced, focus moves to the first new item, address bar updated), failure (alert, nothing appended, URL unchanged, button reads "Try again"), last page (button removed, "All 16 products shown") | Real taps at 390px with the demo loader: all states pass; at 1280px numbered shows and Load more is hidden | **The default fetch loader and everything about Shopify are untested** (no theme exists). See the analysis below |
| 5 | Phone filter drawer | Approved, behaviors implemented | Full-width sheet below 600px, 26rem panel from 600px; native `<dialog>` plus `drawer.js` | Real keys, wheel and mouse, phone sheet at 390px and panel at 1280px: Enter opens a modal dialog; focus moves in; the accessibility tree exposes a dialog named "Filters"; Tab through all 22 controls stays inside and wraps both ways; focus on the page behind is refused; the page does not scroll behind it and the body scrolls on its own; close button 44px and the primary action stay on screen; Escape, close button, action and (panel) scrim each close it and focus returns to the opener; scroll lock and page position restored. Removing the Tab wrap, the scroll lock and the focus-restore line together made 10 drawer checks fail across the two viewports (the focus restore itself is masked by the browser) | iOS Safari (its `overflow: hidden` scroll lock can differ), Android back button, VoiceOver, TalkBack, NVDA, Firefox. Chrome restores focus natively; `drawer.js` adds its own restore as a safeguard |
| 6 | Imagery guidance | Approved as a **provisional** default; awaiting validation with real photography | 4:5 is the product-card canvas only; hero, editorial, collection tiles, banners and promotions are listed exceptions (section 6) | Ratios are tokens used by the showcase; the dashboard's 80% crop rule, packaging and thumbnail specimens pass (70 checks); `--product-image-fit` is `cover` and `--product-image-position` is `50% 50%`, overridable per image | No real photography: crop on real packaging, focal points and the 60 to 80% fill guidance are proposals for the first shoot |
| 7 | Gutter and grid gap | Confirmed | Unchanged: 16/24/40px and 16/24/32px | Tokens match computed values at 10 widths; 0 horizontal overflow at 320 to 1920px; renders at 320, 430, 600, 768 and 1280px show clean reflow (2, 2, 3, 3, 4 columns). **Found:** at 320px the "Sale" badge ran under the wishlist button on a 129 to 136px card; fixed (the badge area now reserves room and the label wraps) and a scan check now catches it | The margin steps at 600 and 1024px together with the columns; no real page reviewed |
| 8 | h5 and body-large fluid sizing | Confirmed | Unchanged | 1,601 widths: monotonic, within bounds, h4 > body large > h5 >= 16px everywhere; renders at 320 to 1280px read cleanly | On phones h5 equals body size (16px) and differs by family and weight only (Cormorant bold, since 2026-11-03) |

### Risk A: Shopify collection pagination and Load more (documented, not implemented, not verified)

**Status:** the phone Load more direction is approved but **provisional for implementation**. What exists is a showcase pattern with a demo loader. No Shopify theme exists, nothing here was run against Shopify, and the default fetch loader in `load-more.js` has never been executed against a real response. The statements about Shopify's `paginate` tag below come from its documentation, not from a test.

**The risk to record.** `paginate` renders only the requested page. If JavaScript appends pages 2 and 3 to the interface and the address bar then says `?page=3`, a reload, a shared link, a bookmark or a restored tab can show **page 3 alone**, without the items that were above it. The user loses their place, and a recipient of a shared link sees something different from the sender.

**Future implementation requirements** (each is a requirement to meet and then test, not a claim that it works):

| Area | Requirement | Open question to settle with the theme |
|---|---|---|
| URL synchronization | The address bar always names a real, loadable collection URL that reflects the furthest page shown, and keeps the collection's other parameters (sort, filters, `view`) | `replaceState` (Back leaves the collection) or `pushState` (Back steps through pages). The showcase uses `replaceState`; this is untested against real history behavior |
| Reload | Reloading must not silently drop what the user was looking at | Whether the server can render pages 1 to N, or the theme shows page N with a way back |
| Shared links and bookmarks | A link to `?page=3` must be intelligible to someone who never saw pages 1 and 2, and must be crawlable | What a recipient should see first |
| Back and forward | Back and forward must be predictable and must not strand the user | Behavior with the browser's back-forward cache, and what is restored |
| Scroll restoration | After Back, a reload or a recovery action, the user returns to the item they were on | Whether to use `history.state` plus `scrollRestoration`, or an anchor to the last viewed product |
| Loading state | Visible and announced, the control cannot be activated twice, and focus is not lost | Confirm with a real network and a screen reader |
| Error state | Failure is announced, nothing is appended, the URL does not advance, and retry works | Offline, timeouts, non-200 and malformed responses |
| Filters and sort | Applying a filter or sort must reset the page and the appended list cleanly | How this interacts with the filter drawer's Apply action |
| No JavaScript | Load more remains an ordinary link to the next page | Keep the link's `href` correct after each load |
| **Recovery from a mid-list URL** | **Evaluate a "Load previous" link (shown above the list when `paginate.previous` exists on phones) or an equivalent mechanism, such as rendering pages 1 to N or a visible "start from the beginning" link** | This is the main design question and has not been decided or built |

**Why the showcase uses `replaceState`:** with `pushState`, Back would step through `?page=2` and `?page=1`, each a shorter page; with `replaceState`, Back leaves the collection, as from one scrolling list. This is a reasoned default, not a tested one.

**Tablet and desktop** use numbered links; a phone in landscape (600px or wider) also gets the numbered list.

### Open risks register

Nothing below is implemented or verified unless stated. A risk is closed only when the evidence in the last column exists.

| Risk | Decision it affects | Status | What exists today | What is not verified | Evidence or assets needed to close it |
|---|---|---|---|---|---|
| **A. Shopify collection pagination and Load more** | 4 | Provisional for implementation | A showcase pattern with a demo loader; real-tap tests of its states in Chromium; a documented requirement list (above) | The default fetch loader; Shopify `paginate` URLs, reload, shared links, back and forward, bfcache, scroll restoration, filters with `page`, real network failure; any Load previous or equivalent recovery | A Shopify theme (a later phase, not started here) with a real collection of more than 3 pages; run the requirements table above in Chrome, Safari and Firefox on a real phone; an owner decision on the recovery mechanism |
| **B. Real product photography** | 6 | Provisional (4:5 is a default, not a validated rule) | Tokens, `.ratio` frames, drawn and gradient placeholders, dashboard checks of the 80% crop arithmetic | Crop, focal points, complete packaging visibility, responsive image fit, image loading behavior and fallbacks on real images | Representative product assets: the tallest and widest packaging, a product with a transparent or white background, a lifestyle shot, a hero image, in the real master size (at least 1600px on the long edge); reviewed in the card, the PDP gallery and the thumbnail at 320, 390, 768 and 1280px, with real `srcset` delivery |
| C. Drawer, chip row and Load more on real devices and assistive technology | 2, 4, 5 | Implemented; Chromium-tested | Real-input tests in Chrome and Edge | iOS Safari, Android, Firefox, VoiceOver, TalkBack, NVDA | The manual tests in `manual-testing.md` sections 7 and 8, recorded in its results log |
| D. Everything else listed under "Not verified" in `AUDIT-REPORT.md` | n/a | Open | n/a | Safari, Firefox, real phone, real Windows high contrast, axe, Lighthouse | `manual-testing.md` |
### When Load more is the wrong choice

Use numbered pagination everywhere if people compare pages, return to a position, or share a page. Infinite scroll is not recommended (the footer becomes unreachable and focus management is hard).