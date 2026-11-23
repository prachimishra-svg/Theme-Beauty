# Component Properties

Properties, variants, defaults and supported states. 102 of 102 components have manifests (Figma vocabulary: VARIANT, BOOLEAN, TEXT, LIST, INSTANCE_SWAP). Scope is the property class: design (fixed by the Design System), parent (passed from the parent), merchant (editable in the theme editor, only when a section exposes it) or wireframe (not carried to Shopify). The remaining components have no manifest yet; their properties are inferred from the template tokens and labelled as such.

## Badge (`base/badge`)

- Level: base; page scope: shared; status: ready
- A small label: Design System badges, and the labels laid over product images on the Homepage (Bestseller, New, Sale).
- Accessibility: Text label, not colour alone.
- Design Variable groups: badge radius, brand colours, caption type

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| variant | VARIANT | parent | ds | ds, ds-brand, ds-dark, ds-outline, overlay, overlay-sale | select | ds* = Design System; overlay = label on an image (Bestseller, New); overlay-sale = brand colour (Sale) |
| label | TEXT | parent | Bestseller | label, TEXT, Bestseller, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| labelWrap | VARIANT | parent | plain | plain, span |  | Passed by callers. Reclassified from design by the conversion check; it could later be derived from the variant |
| extra | TEXT | parent |  | extra, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| editHook | TEXT | wireframe |  | editHook, TEXT, , wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |

## Breadcrumb (`base/breadcrumb`)

- Level: base; page scope: shared; status: ready
- The trail of pages above the title; the last link is the current page.
- Accessibility: nav landmark named Breadcrumb; ordered list; aria-current on the last link.
- Design Variable groups: body-sm type, divider

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| items | LIST | merchant | list | items, LIST, System.Object[], System.Object[], One entry per level, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | blocks | One entry per level |

## Button (`base/button`)

- Level: base; page scope: shared; status: ready
- Primary, secondary and text actions in the Design System style, and the Homepage Editorial style (square, sentence case). One component, named variants.
- Accessibility: Native a / button. 44 px minimum touch target (min-h-touch in the Editorial style, control height in the Design System style). Focus ring from the Design System.
- Nested components: `base/icon`
- Design Variable groups: brand and button colours, button text style, control heights, radius

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| variant | VARIANT | parent | primary | primary, secondary, text, editorial, editorial-outline, editorial-text | select | primary, secondary, text = Design System; editorial* = Homepage Editorial |
| size | VARIANT | parent | md | sm, md, lg |  | Design System sizes |
| element | VARIANT | parent | link | link, button, submit |  | What it renders: a link, a button, or a form submit button |
| label | TEXT | merchant | Shop now | label, TEXT, Shop now, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text |  |
| href | TEXT | merchant | # | href, TEXT, #, Link target (element = link), merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | url | Link target (element = link) |
| icon | INSTANCE_SWAP | parent |  | icon, INSTANCE_SWAP, , System.Object[], Optional icon; empty = none, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], D10 (2026-11-17) | select | Optional icon; empty = none |
| iconPosition | VARIANT | parent | trailing | leading, trailing |  |  |
| labelWrap | VARIANT | parent | plain | plain, span |  | Passed by callers (Editorial buttons wrap the label in a span). Reclassified from design by the conversion check; it could later be derived from the variant |
| block | BOOLEAN | parent | False | block, BOOLEAN, False, Full-width (Design System btn-block), parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] | checkbox | Full-width (Design System btn-block) |
| disabled | BOOLEAN | parent | False | disabled, BOOLEAN, False, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| id | TEXT | parent |  | id, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| attrs | TEXT | parent |  | attrs, TEXT, , Raw attributes, for example data-drawer-close, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Raw attributes, for example data-drawer-close |
| extra | TEXT | parent |  | extra, TEXT, , Layout utilities set by the parent (margin, width, group), parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Layout utilities set by the parent (margin, width, group) |
| editHook | TEXT | wireframe |  | editHook, TEXT, , Wireframe review hook (data-c). Not used by the theme, wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Wireframe review hook (data-c). Not used by the theme |

## Chip (`base/chip`)

- Level: base; page scope: shared; status: ready
- A pill for filtering and tags: the Design System chip (toggle or link) and the Homepage Editorial chip (selectable) and tag (static).
- Accessibility: Toggle chips expose the pressed state. 44 px hit area.
- Design Variable groups: brand tint, border colours, pill radius

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| variant | VARIANT | parent | ds | ds, editorial, editorial-tag | select |  |
| element | VARIANT | parent | button | button, span, link |  |  |
| label | TEXT | parent | Hydration | label, TEXT, Hydration, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], D10 (2026-11-17) |  |  |
| selected | BOOLEAN | parent | False | selected, BOOLEAN, False, Selected state (Design System: aria-pressed; Editorial: tinted), parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Selected state (Design System: aria-pressed; Editorial: tinted) |
| href | TEXT | parent | # | href, TEXT, #, element = link, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], D10 (2026-11-17) |  | element = link |
| extra | TEXT | parent |  | extra, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| editHook | TEXT | wireframe |  | editHook, TEXT, , wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |

## Icon (`base/icon`)

- Level: base; page scope: shared; status: ready
- One glyph from the project icon set (Lucide, 24 px grid, 1.5 stroke), drawn from the shared sprite.
- Accessibility: Decorative (aria-hidden). The control that contains it carries the accessible name.
- Design Variable groups: icon sizes, currentColor

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| name | INSTANCE_SWAP | parent | arrow-right | name, INSTANCE_SWAP, arrow-right, System.Object[], Which icon, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Which icon |
| size | VARIANT | parent | md | sm, md, lg, custom |  | Passed by callers: small, medium, large or custom (size comes from extra). Reclassified from design by the conversion check: a value callers choose is a parameter |
| extra | TEXT | parent |  | extra, TEXT, , Layout utilities set by the parent (colour, margin, transitions), parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Layout utilities set by the parent (colour, margin, transitions) |

## Icon Button (`base/icon-button`)

- Level: base; page scope: shared; status: ready
- A square or round button that holds only an icon: the Design System icon button and the round Homepage controls (scrollers, ritual steps).
- Accessibility: aria-label is required: the icon alone has no name. 44 px target.
- Nested components: `base/icon`
- Design Variable groups: touch target, border colours

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| variant | VARIANT | parent | ds | ds, circle, circle-soft | select | ds = Design System; circle = dark outline (ritual steps); circle-soft = light outline (scrollers) |
| icon | INSTANCE_SWAP | parent | close | icon, INSTANCE_SWAP, close, System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] | select |  |
| label | TEXT | parent | Close | label, TEXT, Close, Accessible name (aria-label); not visible, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Accessible name (aria-label); not visible |
| disabled | BOOLEAN | parent | False | disabled, BOOLEAN, False, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| hook | TEXT | parent |  | hook, TEXT, , Class hook used by scripts, for example rit__prev, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Class hook used by scripts, for example rit__prev |
| attrs | TEXT | parent |  | attrs, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| extra | TEXT | parent |  | extra, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |

## Input Field (`base/input-field`)

- Level: base; page scope: shared; status: ready
- A labelled text input with an optional error line. The label is always visible.
- Accessibility: Label tied to the input; error text linked and announced when shown.
- Design Variable groups: input border and radius, control height, status error colour

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| label | TEXT | parent | Email | label, TEXT, Email, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| id | TEXT | parent | f-email | id, TEXT, f-email, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| name | TEXT | parent | contact[email] | name, TEXT, contact[email], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| type | VARIANT | parent | email | text, email, number, tel |  |  |
| autocomplete | TEXT | parent | email | autocomplete, TEXT, email, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| placeholder | TEXT | parent |  | placeholder, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| required | BOOLEAN | parent | True | required, BOOLEAN, True, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| error | TEXT | parent | Enter an email address like name@example.com. | error, TEXT, Enter an email address like name@example.com., Validation message (hidden until invalid); empty = none, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Validation message (hidden until invalid); empty = none |

## Media (`base/media`)

- Level: base; page scope: shared; status: ready
- An image area with a fixed shape and ratio. Without an image it shows the labelled placeholder used in the wireframes (label and size, no artwork).
- Accessibility: Images need alt text; the placeholder is decorative.
- Design Variable groups: placeholder tints (warm colours), aspect ratio tokens

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| shape | VARIANT | parent | rect | rect, circle |  |  |
| ratio | VARIANT | parent | portrait | portrait, square, landscape, wide |  | portrait 4:5, square 1:1, landscape 16:9, wide 2:1 |
| tone | VARIANT | wireframe | t1 | t1, t2, t3, t4 |  | Placeholder tint |
| label | TEXT | wireframe | Product photo: Face Serum | label, TEXT, Product photo: Face Serum, Placeholder label; empty = no placeholder text, wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Placeholder label; empty = no placeholder text |
| dim | TEXT | wireframe | 4:5, 800 x 1000 | dim, TEXT, 4:5, 800 x 1000, wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| image | TEXT | merchant |  | image, TEXT, , Image URL; when set the image replaces the placeholder look, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | image_picker | Image URL; when set the image replaces the placeholder look |
| alt | TEXT | parent |  | alt, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], D10 (2026-11-17) |  |  |
| nodim | BOOLEAN | wireframe | False | nodim, BOOLEAN, False, Hide the size line, wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Hide the size line |
| extra | TEXT | parent |  | extra, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |

## Message (`base/message`)

- Level: base; page scope: shared; status: ready
- A short status message with an icon: success, error or warning.
- Accessibility: role="status" for success, role="alert" for errors and warnings; never colour alone (icon and text).
- Nested components: `base/icon`
- Design Variable groups: status colours, border-left thick

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| variant | VARIANT | parent | success | success, error, warning | select |  |
| text | TEXT | merchant | Added to your bag. | text, TEXT, Added to your bag., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text |  |

## Price (`base/price`)

- Level: base; page scope: shared; status: ready
- A price, or a sale price with the regular price struck through, and an optional unit price.
- Accessibility: Screen-reader text names the sale and regular price.
- Design Variable groups: price type, muted text colour

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| variant | VARIANT | parent | regular | regular, sale | select |  |
| price | TEXT | parent | $32.00 | price, TEXT, $32.00, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| compare | TEXT | parent | $38.00 | compare, TEXT, $38.00, Regular price (sale only), parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Regular price (sale only) |
| unit | TEXT | parent |  | unit, TEXT, , Unit price, for example $1.07 / ml, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Unit price, for example $1.07 / ml |
| extra | TEXT | parent |  | extra, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Layout utilities set by the parent (for example top margin) |  | Layout utilities set by the parent (for example top margin) |
| unitExtra | TEXT | parent |  | unitExtra, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Layout utilities for the unit price line (for example basis-full inside a card) |  | Layout utilities for the unit price line (for example basis-full inside a card) |

## Quantity Selector (`base/quantity`)

- Level: base; page scope: shared; status: ready
- Minus, number, plus. Disabled at the limits.
- Accessibility: Group with a label; buttons have names; numeric keypad on touch.
- Nested components: `base/icon`
- Design Variable groups: control border, radius, touch target

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| value | TEXT | parent | 1 | value, TEXT, 1, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| label | TEXT | parent | Quantity | label, TEXT, Quantity, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| minusDisabled | BOOLEAN | parent | True | minusDisabled, BOOLEAN, True, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |
| plusDisabled | BOOLEAN | parent | False | plusDisabled, BOOLEAN, False, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  |  |

## Rating (`base/rating`)

- Level: base; page scope: shared; status: ready
- Five stars with the number of filled stars, an accessible value and an optional review count.
- Accessibility: role="img" with an aria-label such as "Rated 4.4 out of 5".
- Nested components: `base/icon`
- Design Variable groups: rating star colour, caption type

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| stars | VARIANT | parent | 4 | 0, 1, 2, 3, 4, 5 |  | Filled stars |
| value | TEXT | parent | 4.4 | value, TEXT, 4.4, Spoken rating, for example 4.4, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Spoken rating, for example 4.4 |
| text | TEXT | parent | 4.8 (212) | text, TEXT, 4.8 (212), parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Text after the stars, for example 4.8 (212) |  | Text after the stars, for example 4.8 (212) |
| extra | TEXT | parent |  | extra, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Layout utilities set by the parent (for example top margin) |  | Layout utilities set by the parent (for example top margin) |

## Section Heading (`base/section-heading`)

- Level: base; page scope: shared; status: ready
- The centred section title with the short rule underneath and an optional lead line.
- Accessibility: The title is the section's h2.
- Responsive: Spacing below grows at 600 and 1024 px.
- Design Variable groups: heading type, brand secondary rule, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| title | TEXT | merchant | Shop by category | title, TEXT, Shop by category, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text |  |
| lead | TEXT | merchant |  | lead, TEXT, , Optional supporting line; empty = hidden, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | textarea | Optional supporting line; empty = hidden |
| editHook | TEXT | wireframe |  | editHook, TEXT, , Wireframe review hook (data-c), wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object] |  | Wireframe review hook (data-c) |

## Scroller Controls (`common/scroller-controls`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- Previous and next circle buttons that scroll a horizontal list. Used by testimonials and logos.
- Accessibility: Two buttons with accessible names; hidden when the list does not scroll.
- Responsive: Shown only when the list overflows.
- Nested components: `base/icon-button`
- Design Variable groups: spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| hook | TEXT | parent | rec | hook, TEXT, rec, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Script hook prefix (hook__prev, hook__next) |  | Script hook prefix (hook__prev, hook__next) |
| end | BOOLEAN | parent | False | end, BOOLEAN, False, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Align the buttons to the end of the row |  | Align the buttons to the end of the row |
| prev | TEXT | parent | Previous | prev, TEXT, Previous, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name from a locale string |  | Accessible name from a locale string |
| next | TEXT | parent | Next | next, TEXT, Next, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name from a locale string |  | Accessible name from a locale string |

## Account Button (`header/account-button`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The account link in the header: user icon and, from 1024 px, the word Account.
- Accessibility: A link with an accessible name Account.
- Responsive: Icon only below 1024 px; icon and text from 1024 px.
- Design Variable groups: touch target, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- show_account (checkbox): Show or hide the account link


## Cart Button (`header/cart-button`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The cart control in the header. A link to the cart page, the same link when the cart page is current, or a button that opens the cart drawer.
- Accessibility: A link or a button with an accessible name that includes the count; the drawer button announces a dialog.
- Responsive: See Cart Button Content.
- Nested components: `header/cart-button-content`
- Design Variable groups: touch target

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| variant | VARIANT | parent | link | link, page, drawer | select | link goes to the cart page; page marks the cart page as current; drawer opens the cart drawer |
**Shopify-only settings (no wireframe equivalent):**
- cart_type (select): Theme setting that chooses page or drawer, as in the existing theme


## Cart Button Content (`header/cart-button-content`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The inside of the cart button: bag icon, the word Cart (from 1024 px) and the item count badge. The count is written by script.
- Accessibility: The count is part of the button name, which the script keeps current.
- Responsive: Icon and count below 1024 px; icon, text and count from 1024 px.
- Nested components: `base/icon`
- Design Variable groups: brand colour, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- cart_count (data): cart.item_count, filled by the theme script


## Logo (`header/logo`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The N-U-D-G-E wordmark as an inline SVG linking to the top of the page. In Shopify it links to the shop home.
- Accessibility: The SVG has role img and the name NUDGE; the link is named Store home.
- Responsive: Centred on small screens, left from 1024 px.
- Design Variable groups: ink colour

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- logo (image_picker): Optional uploaded logo; the inline wordmark is the default


## Market Selector (`header/market-selector`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The country and currency pill with its dropdown. The list is filled by the currency script from the markets in use.
- Accessibility: A disclosure button with aria-expanded; the menu is a labelled group.
- Responsive: Inside the mobile navigation below 1024 px; in the header bar from 1024 px.
- Design Variable groups: border colours, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- localization (data): localization.available_countries, rendered by the theme country form


## Mega Menu Card (`header/mega-card`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- One promotional card: image, title and a Shop now link.
- Accessibility: One link; the title names it.
- Responsive: Two cards side by side from 1024 px.
- Nested components: `base/icon`
- Design Variable groups: type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| key | TEXT | parent | skin | key, TEXT, skin, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Menu key used in the link anchor |  | Menu key used in the link anchor |
| title | TEXT | merchant | New in skin | title, TEXT, New in skin, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | title / text |  |
| tone | TEXT | wireframe | ph | tone, TEXT, ph, wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Placeholder tint class |  | Placeholder tint class |
**Shopify-only settings (no wireframe equivalent):**
- cta (text)
- link (url)
- image (image_picker)

**Wireframe-only, not carried to Shopify:** IMAGE PLACEHOLDER caption and tint


## Mega Menu Cards (`header/mega-cards`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The two promotional cards at the end of a mega menu (large screens only).
- Accessibility: Each card is one link.
- Responsive: Hidden below 1024 px.
- Nested components: `header/mega-card`
- Design Variable groups: spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| key | TEXT | parent | skin | key, TEXT, skin, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Menu key used in link anchors |  | Menu key used in link anchors |
| first | TEXT | merchant | New in skin | first, TEXT, New in skin, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Title of the first card | title / text | Title of the first card |
| second | TEXT | merchant | Skin routines | second, TEXT, Skin routines, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Title of the second card | title / text | Title of the second card |
**Shopify-only settings (no wireframe equivalent):**
- mega_card (blocks): menu_item, title, cta, link, image, tone


## Mega Menu Column (`header/mega-column`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- A titled column of links in a mega menu.
- Accessibility: A list of links under a title.
- Responsive: Stacked below 1024 px.
- Design Variable groups: type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| key | TEXT | parent | skin | key, TEXT, skin, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Menu key used in link anchors |  | Menu key used in link anchors |
| title | TEXT | parent | Shop by concern | title, TEXT, Shop by concern, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], linklist child link title, Column title |  | Column title |
| links | LIST | parent | Hydration/Brightening/Anti-ageing/Blemish care/Sensitive skin | links, LIST, Hydration/Brightening/Anti-ageing/Blemish care/Sensitive skin, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], linklist child links, Links, one per item |  | Links, one per item |

## Mega Menu (`header/mega-menu`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The dropdown panel under a navigation item: link columns, two promotional cards and a Shop all link. The panel for each key is an explicit branch, because Liquid cannot render a snippet by variable name.
- Accessibility: A panel opened by its navigation item; closes on Escape and outside click (script).
- Responsive: Full-width dropdown from 1024 px; an inline accordion panel below 1024 px.
- Nested components: `base/icon`, `header/menus/skin`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`
- Design Variable groups: page background, shadow, z-index

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| key | TEXT | parent | skin | key, TEXT, skin, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Which menu panel to show: skin, makeup, hair or body | select | Which menu panel to show: skin, makeup, hair or body |
| name | TEXT | parent | Skin | name, TEXT, Skin, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], linklist link title, Menu title used in the Shop all link |  | Menu title used in the Shop all link |

## Menu Button (`header/menu-button`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The hamburger button that opens the mobile navigation.
- Accessibility: aria-expanded and aria-controls point at the navigation; the script toggles them.
- Responsive: Visible below 1024 px only.
- Nested components: `base/icon`
- Design Variable groups: touch target

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|

## Mega Menu Content: Body (`header/menus/body`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The link columns and the two promotional cards inside the body mega menu. In the wireframe the links are fixed sample content.
- Accessibility: Plain lists of links.
- Responsive: Columns sit side by side from 1024 px.
- Nested components: `header/mega-column`, `header/mega-cards`
- Design Variable groups: spacing, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- menu (link_list): Columns come from the children of the navigation link list
- mega_card (blocks): Promotional cards are blocks (menu item, title, call to action, link, image)


## Mega Menu Content: Hair (`header/menus/hair`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The link columns and the two promotional cards inside the hair mega menu. In the wireframe the links are fixed sample content.
- Accessibility: Plain lists of links.
- Responsive: Columns sit side by side from 1024 px.
- Nested components: `header/mega-column`, `header/mega-cards`
- Design Variable groups: spacing, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- menu (link_list): Columns come from the children of the navigation link list
- mega_card (blocks): Promotional cards are blocks (menu item, title, call to action, link, image)


## Mega Menu Content: Makeup (`header/menus/makeup`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The link columns and the two promotional cards inside the makeup mega menu. In the wireframe the links are fixed sample content.
- Accessibility: Plain lists of links.
- Responsive: Columns sit side by side from 1024 px.
- Nested components: `header/mega-column`, `header/mega-cards`
- Design Variable groups: spacing, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- menu (link_list): Columns come from the children of the navigation link list
- mega_card (blocks): Promotional cards are blocks (menu item, title, call to action, link, image)


## Mega Menu Content: Skin (`header/menus/skin`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The link columns and the two promotional cards inside the skin mega menu. In the wireframe the links are fixed sample content.
- Accessibility: Plain lists of links.
- Responsive: Columns sit side by side from 1024 px.
- Nested components: `header/mega-column`, `header/mega-cards`
- Design Variable groups: spacing, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- menu (link_list): Columns come from the children of the navigation link list
- mega_card (blocks): Promotional cards are blocks (menu item, title, call to action, link, image)


## Navigation Close (`header/nav-close`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The close button inside the mobile navigation panel.
- Accessibility: A button named Close menu.
- Responsive: Visible below 1024 px only.
- Nested components: `base/icon`
- Design Variable groups: touch target

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|

## Navigation Item (`header/nav-item`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- One top-level navigation entry with its chevron and mega menu panel.
- Accessibility: A disclosure link with aria-haspopup and aria-expanded; arrow-key behaviour is script driven.
- Responsive: An accordion in the mobile panel; a hover or focus mega menu from 1024 px.
- Nested components: `base/icon`, `header/mega-menu`
- Design Variable groups: type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| key | TEXT | parent | skin | key, TEXT, skin, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], linklist link handle, Menu key used in ids and links |  | Menu key used in ids and links |
| name | TEXT | parent | Skin | name, TEXT, Skin, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], linklist link title, Menu title |  | Menu title |
| current | BOOLEAN | parent | False | current, BOOLEAN, False, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], link.current, Marks the current section for assistive technology |  | Marks the current section for assistive technology |

## Search Button (`header/search-button`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The search entry in the header. One component, three placements: an icon on small screens, a labelled field-style button in the header on large screens, and a full-width bar in the navigation panel.
- Accessibility: A link named by its label; the desktop field carries role search.
- Responsive: mobile: icon below 1024 px; desktop: field from 1024 px; bar: inside the navigation panel.
- Nested components: `base/icon`
- Design Variable groups: touch target, type roles, border colours

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| placement | VARIANT | parent | mobile | mobile, desktop, bar | select | Where it sits: mobile icon, desktop field, or navigation bar |
| label | TEXT | parent | Search | label, TEXT, Search, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name, from a locale string |  | Accessible name, from a locale string |
| role | BOOLEAN | parent | False | role, BOOLEAN, False, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Marks the desktop field as the search landmark |  | Marks the desktop field as the search landmark |
| text | TEXT | parent |  | text, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Visible text, from a locale string; empty shows the icon only |  | Visible text, from a locale string; empty shows the icon only |
**Shopify-only settings (no wireframe equivalent):**
- show_search (checkbox): Show or hide search


## Header (`header/site-header`)

- Level: main; page scope: shared; status: classified (D10 items pending)
- The sticky site header: menu button, search, logo, navigation with mega menus and the country selector, and the account and cart controls. Maps to the header section in the Shopify header group.
- Accessibility: A banner landmark with a labelled main navigation; the mobile panel traps focus while open.
- Responsive: Mobile: menu button, logo and cart, with the navigation in a side panel. From 1024 px: logo left, navigation centre, search, account and cart right.
- Nested components: `header/menu-button`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/market-selector`, `header/account-button`, `header/cart-button`
- Design Variable groups: page background, borders, z-index, touch target

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| cart | VARIANT | parent | link | link, page, drawer |  | How the cart control behaves on this page |
| nav | VARIANT | parent | none | none, skin |  | Which navigation entry is the current page: none or skin |
| extra | TEXT | parent |  | extra, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Layout utilities the page adds to the header bar (the Homepage makes it transparent over the hero) |  | Layout utilities the page adds to the header bar (the Homepage makes it transparent over the hero) |
**Shopify-only settings (no wireframe equivalent):**
- menu (link_list): Main navigation; its links become the navigation items
- transparent_on_home (checkbox): Replaces the extra property on the Homepage
- show_search (checkbox)
- show_account (checkbox)
- mega_card (blocks): Promotional cards in the mega menus

**Wireframe-only, not carried to Shopify:** data-c review hooks


## Category Card (`homepage/category-card`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- One photo tile with title, subtitle and a link, used in the Shop by Category mosaic. The four positions of the mosaic are one component with a layout variant.
- Accessibility: The whole tile is one link; the visible title names it. Image alt text comes from the image.
- Responsive: Below 768 px: caption under the image, wide tiles span two columns. From 768 px: caption sits on the image and the tile takes its mosaic cell.
- Nested components: `base/icon`
- Design Variable groups: page and text colours, type roles, spacing, motion

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| layout | VARIANT | parent | tall | tall, top-middle, top-right, wide | layout / select | Position in the four-tile mosaic; the section sets it per card. It is a layout choice, exposed to merchants as a select in the existing theme |
| href | TEXT | merchant | # | href, TEXT, #, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Link target; empty means the collection link in Shopify | link / url | Link target; empty means the collection link in Shopify |
| title | TEXT | merchant | Skin care | title, TEXT, Skin care, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Empty means the collection title in Shopify | title / text | Empty means the collection title in Shopify |
| subtitle | TEXT | merchant | Cleansers, serums and moisturisers | subtitle, TEXT, Cleansers, serums and moisturisers, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | subtitle / text |  |
| linkText | TEXT | merchant | Shop now | linkText, TEXT, Shop now, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | link_text / text |  |
| photo | TEXT | wireframe | Category photo | photo, TEXT, Category photo, wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Wireframe placeholder caption; replaced by the image setting in Shopify |  | Wireframe placeholder caption; replaced by the image setting in Shopify |
| dim | TEXT | wireframe | 4:5, 800 x 1000 | dim, TEXT, 4:5, 800 x 1000, wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Wireframe placeholder size caption |  | Wireframe placeholder size caption |
**Shopify-only settings (no wireframe equivalent):**
- collection (collection): When set, resolves the title and the link
- image (image_picker): Real image in place of the wireframe placeholder


## Shop by Category (`homepage/category-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- Primary category entry: four photo tiles in an asymmetric mosaic with a heading. Maps to the category grid section in the Shopify theme.
- Accessibility: Section heading is an h2; each tile is one link named by its title.
- Responsive: Below 768 px: wide Skin care tile, two portrait tiles side by side, wide Body tile; caption under each image. From 768 px: one tall tile and three smaller ones, caption on the image.
- Nested components: `base/section-heading`, `homepage/category-card`
- Design Variable groups: page background, spacing and grid gap, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| heading | TEXT | merchant | Shop by category | heading, TEXT, Shop by category, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| anchor | TEXT | merchant | s05 | anchor, TEXT, s05, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| items | LIST | merchant | list | items, LIST, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], System.Object[], One block per tile; fields are the Category Card properties, System.Object[] | blocks | One block per tile; fields are the Category Card properties |
**Exposed to the theme editor by this section:**
- homepage/category-card . layout via items.layout
- homepage/category-card . href via items.href
- homepage/category-card . title via items.title
- homepage/category-card . subtitle via items.subtitle
- homepage/category-card . linkText via items.linkText
- base/section-heading . title via heading

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks; photo and dim placeholder captions


## Collection Tab (`homepage/collection-tab`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- One tab of the featured-collection tab list.
- Accessibility: role=tab with aria-selected; 44 px minimum height.
- Responsive: Same at all widths.
- Design Variable groups: brand colour, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| on | BOOLEAN | parent | False | on, BOOLEAN, False, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Active tab class |  | Active tab class |
| selected | VARIANT | parent | false | true, false |  | aria-selected value |
| set | TEXT | parent | 0 | set, TEXT, 0, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Index of the product set this tab shows (script wiring) |  | Index of the product set this tab shows (script wiring) |
| label | TEXT | merchant | Best sellers | label, TEXT, Best sellers, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Tab label | label / text | Tab label |

## Collection Tabs (`homepage/collection-tabs`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- The tab list of the featured collection. Each tab is a block in the Shopify theme.
- Accessibility: role=tablist; arrow-key behaviour is script-driven.
- Responsive: Same at all widths.
- Nested components: `homepage/collection-tab`
- Design Variable groups: spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| tabs | LIST | merchant | list | tabs, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One block per tab; the first is active | blocks | One block per tab; the first is active |

## Compare Layer (`homepage/compare-layer`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- One of the two stacked images of the before and after slider, with its label. Before is the base layer, After the clipped top layer.
- Accessibility: The label is visible text; the slider carries the interaction.
- Responsive: Both layers share one size and crop.
- Design Variable groups: surface colours, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| layer | VARIANT | parent | before | before, after |  | Which layer: before (base) or after (top) |
| title | TEXT | merchant | Before | title, TEXT, Before, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Label on the layer | before_label / text | Label on the layer |
**Shopify-only settings (no wireframe equivalent):**
- before_image (image_picker)
- after_image (image_picker)

**Wireframe-only, not carried to Shopify:** placeholder caption (desc)


## Before and After (`homepage/compare-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- A full-width image comparison slider. Maps to the before-after section. Results shown must be real and substantiated by the merchant.
- Accessibility: A range input with a name describing left and right; keyboard operable.
- Responsive: Full width at all sizes; the handle stays touch sized.
- Nested components: `homepage/compare-layer`, `base/icon`
- Design Variable groups: surface colours, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| anchor | TEXT | merchant | s13 | anchor, TEXT, s13, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| beforeLabel | TEXT | merchant | Before | beforeLabel, TEXT, Before, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | before_label / text |  |
| afterLabel | TEXT | merchant | After | afterLabel, TEXT, After, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | after_label / text |  |
| start | TEXT | merchant | 50 | start, TEXT, 50, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Where the divider starts, in percent | start / range | Where the divider starts, in percent |
**Exposed to the theme editor by this section:**
- homepage/compare-layer . title via before_label, after_label

**Shopify-only settings (no wireframe equivalent):**
- before_image (image_picker)
- after_image (image_picker)

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks


## Concern Card (`homepage/concern-card`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- A round photo with the skin concern name under it.
- Accessibility: The tile is a link named by the concern.
- Responsive: Three columns below 1024 px, six from 1024 px.
- Design Variable groups: brand colour (hover ring), type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| tone | TEXT | wireframe |  | tone, TEXT, , wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Placeholder tint class |  | Placeholder tint class |
| name | TEXT | merchant | Dryness | name, TEXT, Dryness, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Concern name; empty means the collection title in Shopify | title / text | Concern name; empty means the collection title in Shopify |
**Shopify-only settings (no wireframe equivalent):**
- collection (collection): Resolves the name and link
- image (image_picker): Real photo in place of the wireframe placeholder


## Shop by Concern / Routine (`homepage/concern-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- Skin concerns as round photos and routine steps as numbered pills. Maps to the concern-routine section.
- Accessibility: Heading is an h2; every card and pill is a link.
- Responsive: Concern photos: three columns below 1024 px, six from 1024 px. Steps wrap.
- Nested components: `base/section-heading`, `homepage/group-title`, `homepage/concern-card`, `homepage/routine-step`
- Design Variable groups: surface background, grid gap, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| heading | TEXT | merchant | Shop by concern or routine | heading, TEXT, Shop by concern or routine, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| lead | TEXT | merchant | Start with what you want to look after, or build a routine step by step. | lead, TEXT, Start with what you want to look after, or build a routine step by step., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | lead / textarea |  |
| concernTitle | TEXT | merchant | By skin concern | concernTitle, TEXT, By skin concern, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | concern_title / text |  |
| routineTitle | TEXT | merchant | By routine step | routineTitle, TEXT, By routine step, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | routine_title / text |  |
| anchor | TEXT | merchant | s07 | anchor, TEXT, s07, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| concerns | LIST | merchant | list | concerns, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One block per concern | blocks | One block per concern |
| steps | LIST | merchant | list | steps, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One block per routine step | blocks | One block per routine step |
**Exposed to the theme editor by this section:**
- base/section-heading . title via heading
- base/section-heading . lead via lead
- homepage/group-title . text via concernTitle, routineTitle
- homepage/concern-card . name via concerns.name
- homepage/routine-step . label via steps.label

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c hooks; concern tone placeholder tints


## Custom Liquid Section (`homepage/custom-liquid-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- An optional, empty-by-default slot where the merchant can add their own Liquid. The wireframe shows a placeholder card; shoppers see nothing until code is added.
- Accessibility: Depends on the merchant code.
- Responsive: Depends on the merchant code.
- Design Variable groups: spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| anchor | TEXT | merchant | s18 | anchor, TEXT, s18, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
**Shopify-only settings (no wireframe equivalent):**
- custom_liquid (liquid): The merchant code; replaces the placeholder card

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks; the placeholder card text


## Featured Collection (`homepage/featured-collection`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- Best sellers, new launches and sets as tabs over a product grid, with a View all button. Maps to the featured-collection section.
- Accessibility: Heading is an h2; tabs follow the tab pattern; each card is one link.
- Responsive: Two product columns below 768 px, four from 768 px.
- Nested components: `base/section-heading`, `homepage/collection-tabs`, `homepage/product-card`, `base/button`
- Design Variable groups: page background, grid gap, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| heading | TEXT | merchant | Shop our favourites | heading, TEXT, Shop our favourites, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| anchor | TEXT | merchant | s06 | anchor, TEXT, s06, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| buttonLabel | TEXT | merchant | View all best sellers | buttonLabel, TEXT, View all best sellers, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_label / text |  |
| buttonHref | TEXT | merchant | # | buttonHref, TEXT, #, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_link / url |  |
| products | LIST | parent (data pending merchant confirmation) | list | products, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], collection.products, True, Sample products standing in for the collection. In Shopify this is data from the chosen collection, never typed |  | Sample products standing in for the collection. In Shopify this is data from the chosen collection, never typed |
**Exposed to the theme editor by this section:**
- base/section-heading . title via heading
- homepage/collection-tabs . tabs via tab blocks (label, collection)
- base/button . label via buttonLabel
- base/button . href via buttonHref

**Shopify-only settings (no wireframe equivalent):**
- products_to_show (range): How many products the grid shows
- collection (collection): Per tab: the collection whose products fill the grid

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c hooks; sample products and their placeholder photos


## Finder Card (`homepage/finder-card`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- The guided finder: a question with answer chips, Back and Next buttons, and a result with a link. A small native script moves through the steps; there is no quiz app.
- Accessibility: Chips are toggle buttons; the question is announced as the step changes; focus stays in the card.
- Responsive: Buttons share a row and wrap on narrow screens.
- Nested components: `base/chip`, `base/button`
- Design Variable groups: brand colour, type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| step | TEXT | parent | Step 1 of 3 | step, TEXT, Step 1 of 3, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Progress text, written by the script as the steps change |  | Progress text, written by the script as the steps change |
| question | TEXT | merchant | What is your skin type? | question, TEXT, What is your skin type?, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], The current question | question / text | The current question |
| options | LIST | merchant | list | options, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Answer chips; the first is selected | blocks | Answer chips; the first is selected |
| backLabel | TEXT | parent | Back | backLabel, TEXT, Back, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Button text from a locale string |  | Button text from a locale string |
| nextLabel | TEXT | parent | Next | nextLabel, TEXT, Next, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Button text from a locale string |  | Button text from a locale string |
| resultText | TEXT | merchant | Your starting routine: Cleanse, Treat, Moisturise | resultText, TEXT, Your starting routine: Cleanse, Treat, Moisturise, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Text of the result | result_text / text | Text of the result |
| resultButton | TEXT | merchant | See matching products | resultButton, TEXT, See matching products, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | result_button / text |  |
| resultHref | TEXT | merchant | #s06 | resultHref, TEXT, #s06, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | result_link / url |  |
**Shopify-only settings (no wireframe equivalent):**
- result_collection (collection): Collection the result links to

**Wireframe-only, not carried to Shopify:** the developer note line (Native JavaScript only ...)


## Guided Finder (`homepage/finder-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- Three quick questions that lead to a matching collection. Maps to the guided-finder section.
- Accessibility: Heading is an h2; the finder card handles focus.
- Responsive: Text above the card on small screens, side by side from 768 px.
- Nested components: `homepage/finder-card`
- Design Variable groups: subtle background, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| eyebrow | TEXT | merchant | Guided finder | eyebrow, TEXT, Guided finder, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | eyebrow / text |  |
| heading | TEXT | merchant | Not sure where to start? | heading, TEXT, Not sure where to start?, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| text | TEXT | merchant | Answer three quick questions and we will point you to a matching collection. | text, TEXT, Answer three quick questions and we will point you to a matching collection., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |
| anchor | TEXT | merchant | s08 | anchor, TEXT, s08, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
**Exposed to the theme editor by this section:**
- homepage/finder-card . question via question blocks
- homepage/finder-card . options via question blocks (options)
- homepage/finder-card . resultText via result_text
- homepage/finder-card . resultButton via result_button
- homepage/finder-card . resultHref via result_link

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks


## Footer Section (Homepage wrapper) (`homepage/footer-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- The Homepage wireframe wraps the shared footer in a numbered review section. The wrapper exists only in the wireframe; in Shopify the footer is the footer group section.
- Accessibility: See Footer.
- Responsive: See Footer.
- Nested components: `layout/site-footer`
- Design Variable groups: inverse background

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Wireframe-only, not carried to Shopify:** the whole numbered section wrapper, .ann annotation, data-section


## Customer Photo Gallery (`homepage/gallery-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- A mosaic of customer photos uploaded by the merchant. Maps to the customer-gallery section.
- Accessibility: Heading is an h2; photos need alt text from the image.
- Responsive: Two columns below 768 px; a six-tile mosaic from 768 px.
- Nested components: `base/section-heading`, `homepage/gallery-tile`
- Design Variable groups: page background, grid gap

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| heading | TEXT | merchant | Customer photos | heading, TEXT, Customer photos, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| lead | TEXT | merchant | Photos from customers, uploaded by the merchant. | lead, TEXT, Photos from customers, uploaded by the merchant., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | lead / text |  |
| anchor | TEXT | merchant | s15 | anchor, TEXT, s15, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| photos | LIST | merchant | list | photos, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One block per photo | blocks | One block per photo |
**Exposed to the theme editor by this section:**
- base/section-heading . title via heading
- base/section-heading . lead via lead
- homepage/gallery-tile . size via photos.size

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks


## Gallery Tile (`homepage/gallery-tile`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- One customer photo in the mosaic. Its size in the mosaic is a variant.
- Accessibility: Alt text comes from the image.
- Responsive: Mosaic: large and wide tiles span more cells from 768 px.
- Design Variable groups: spacing, grid gap

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| i | TEXT | wireframe | 1 | i, TEXT, 1, wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Placeholder caption number |  | Placeholder caption number |
| tone | TEXT | wireframe |  | tone, TEXT, , wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Placeholder tint class |  | Placeholder tint class |
| size | VARIANT | merchant | normal | normal, large, wide | size / select | Size in the mosaic: normal, large (2 x 2 on desktop) or wide (full row on desktop) |
**Shopify-only settings (no wireframe equivalent):**
- image (image_picker): Customer photo

**Wireframe-only, not carried to Shopify:** placeholder captions and tint


## Group Title (`homepage/group-title`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- The small uppercase title above a group of cards or steps.
- Responsive: Spacing above the second title grows with the width.
- Design Variable groups: brand colour, type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| position | VARIANT | parent | first | first, second |  | Spacing: first sits under the heading, second has more space above |
| text | TEXT | merchant | By skin concern | text, TEXT, By skin concern, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Group title text | text | Group title text |

## Hero Banner (`homepage/hero-banner`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- The first fold: one campaign image, label, headline, one line, a main button, a text link and a featured product card. Maps to the hero-banner section.
- Accessibility: Contains the one h1. Main actions are links.
- Responsive: See the three nested parts; the stage height follows the height setting.
- Nested components: `homepage/hero-media`, `homepage/hero-content`, `homepage/hero-featured-product`
- Design Variable groups: display type, overlay, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| anchor | TEXT | merchant | s03 | anchor, TEXT, s03, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| height | VARIANT | merchant | large | large, full | height / select | How tall the hero is |
| eyebrow | TEXT | merchant | The ritual edit &middot; AW26 | eyebrow, TEXT, The ritual edit &middot; AW26, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | eyebrow / text |  |
| heading | TEXT | merchant | Radiance, <em class="italic [font-weight:inherit] text-brand-secondary">Gently</em> Nudged. | heading, TEXT, Radiance, <em class="italic [font-weight:inherit] text-brand-secondary">Gently</em> Nudged., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Inline rich text with one emphasised word | heading / text | Inline rich text with one emphasised word |
| text | TEXT | merchant | Skin care, makeup, hair and body, chosen to work together. | text, TEXT, Skin care, makeup, hair and body, chosen to work together., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |
| buttonLabel | TEXT | merchant | Shop the edit | buttonLabel, TEXT, Shop the edit, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_label / text |  |
| buttonHref | TEXT | merchant | #s06 | buttonHref, TEXT, #s06, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_link / url |  |
| button2Label | TEXT | merchant | Find your routine | button2Label, TEXT, Find your routine, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_2_label / text |  |
| button2Href | TEXT | merchant | #s07 | button2Href, TEXT, #s07, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_2_link / url |  |
| featuredHref | TEXT | merchant | #s06 | featuredHref, TEXT, #s06, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | featured_url / url |  |
| featuredLabel | TEXT | merchant | Featured | featuredLabel, TEXT, Featured, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | featured_label / text |  |
| featuredTitle | TEXT | merchant | Face Serum | featuredTitle, TEXT, Face Serum, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | featured_title / text |  |
| featuredMeta | TEXT | merchant | 30 ml &middot; $32.00 | featuredMeta, TEXT, 30 ml &middot; $32.00, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | featured_meta / text |  |
| featuredAria | TEXT | parent | Featured in the campaign: Face Serum, 30 ml, $32.00. Shop now | featuredAria, TEXT, Featured in the campaign: Face Serum, 30 ml, $32.00. Shop now, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name of the featured card |  | Accessible name of the featured card |
**Exposed to the theme editor by this section:**
- homepage/hero-content . eyebrow via eyebrow
- homepage/hero-content . heading via heading
- homepage/hero-content . text via text
- homepage/hero-content . buttonLabel via button_label
- homepage/hero-content . buttonHref via button_link
- homepage/hero-content . button2Label via button_2_label
- homepage/hero-content . button2Href via button_2_link
- homepage/hero-featured-product . title via featured_title
- homepage/hero-featured-product . meta via featured_meta
- homepage/hero-featured-product . label via featured_label
- homepage/hero-featured-product . href via featured_url

**Shopify-only settings (no wireframe equivalent):**
- featured_product (product): Fills the featured card

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks


## Hero Content (`homepage/hero-content`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- The hero text block: eyebrow, the one H1 of the page, a line of text, a main button and a text link.
- Accessibility: The only h1 on the page. Both actions are real links with visible text.
- Responsive: Sits inside the stage on small screens and in the calm left of the photograph from 1024 px.
- Nested components: `base/button`
- Design Variable groups: display type, brand colours, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| eyebrow | TEXT | merchant | The ritual edit &middot; AW26 | eyebrow, TEXT, The ritual edit &middot; AW26, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | eyebrow / text |  |
| heading | TEXT | merchant | Radiance, <em class="italic [font-weight:inherit] text-brand-secondary">Gently</em> Nudged. | heading, TEXT, Radiance, <em class="italic [font-weight:inherit] text-brand-secondary">Gently</em> Nudged., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Inline rich text: one emphasised word is allowed (em). The emphasis styling belongs to the design, so the Shopify snippet applies it with CSS | heading / text | Inline rich text: one emphasised word is allowed (em). The emphasis styling belongs to the design, so the Shopify snippet applies it with CSS |
| text | TEXT | merchant | Skin care, makeup, hair and body, chosen to work together. | text, TEXT, Skin care, makeup, hair and body, chosen to work together., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |
| buttonLabel | TEXT | merchant | Shop the edit | buttonLabel, TEXT, Shop the edit, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_label / text |  |
| buttonHref | TEXT | merchant | #s06 | buttonHref, TEXT, #s06, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_link / url |  |
| button2Label | TEXT | merchant | Find your routine | button2Label, TEXT, Find your routine, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_2_label / text |  |
| button2Href | TEXT | merchant | #s07 | button2Href, TEXT, #s07, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_2_link / url |  |

## Hero Featured Product (`homepage/hero-featured-product`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- The small product card in the hero: packshot, label, name, size and price, linking to the product.
- Accessibility: One link with a full accessible name.
- Responsive: Bottom right of the hero from 1024 px; a row below the stage on smaller screens.
- Nested components: `base/icon`
- Design Variable groups: surface colours, type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| href | TEXT | merchant | #s06 | href, TEXT, #s06, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Link when no product is chosen | featured_url / url | Link when no product is chosen |
| label | TEXT | merchant | Featured | label, TEXT, Featured, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | featured_label / text |  |
| title | TEXT | merchant | Face Serum | title, TEXT, Face Serum, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], featured_product.title, Empty means the chosen product title | featured_title / text | Empty means the chosen product title |
| meta | TEXT | merchant | 30 ml &middot; $32.00 | meta, TEXT, 30 ml &middot; $32.00, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], featured_product.price, Empty means size and price of the chosen product | featured_meta / text | Empty means size and price of the chosen product |
| ariaLabel | TEXT | parent | Featured in the campaign: Face Serum, 30 ml, $32.00. Shop now | ariaLabel, TEXT, Featured in the campaign: Face Serum, 30 ml, $32.00. Shop now, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name, built from the title, meta and the Shop now locale string |  | Accessible name, built from the title, meta and the Shop now locale string |
**Shopify-only settings (no wireframe equivalent):**
- featured_product (product): Product shown in the card; fills title, meta and link
- packshot (image_picker)


## Hero Media (`homepage/hero-media`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- The campaign image behind the hero text, with the soft ivory fade. Wireframe placeholder today.
- Accessibility: Decorative background image.
- Responsive: Portrait stage below 768 px, landscape from 768 px.
- Design Variable groups: overlay colours

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- image (image_picker): Campaign image
- image_mobile (image_picker): Portrait crop for small screens

**Wireframe-only, not carried to Shopify:** placeholder captions


## Ingredient Card (`homepage/ingredient-card`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- A round macro photo with the ingredient name and a one-line description.
- Accessibility: Name and description are plain text; the photo is decorative.
- Responsive: Four across on large screens, two on small.
- Design Variable groups: border colour, type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| i | TEXT | wireframe | 1 | i, TEXT, 1, wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Placeholder caption number |  | Placeholder caption number |
| tone | TEXT | wireframe |  | tone, TEXT, , wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Placeholder tint class |  | Placeholder tint class |
| name | TEXT | merchant | Ingredient name 1 | name, TEXT, Ingredient name 1, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | name / text |  |
| desc | TEXT | merchant | One line on what it is and why it is used. Merchant to provide; no claims without evidence. | desc, TEXT, One line on what it is and why it is used. Merchant to provide; no claims without evidence., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], No claims without evidence | text / text | No claims without evidence |
**Shopify-only settings (no wireframe equivalent):**
- image (image_picker): Real macro photo


## Ingredient Spotlight (`homepage/ingredient-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- Four key ingredients with a free-from list and a source line. Maps to the ingredient-spotlight section. Ingredient claims are merchant content and need evidence.
- Accessibility: Heading is an h2; tags are plain text.
- Responsive: Two columns below 768 px, four from 768 px.
- Nested components: `base/section-heading`, `homepage/ingredient-card`, `base/chip`
- Design Variable groups: surface background, spacing, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| heading | TEXT | merchant | What is inside | heading, TEXT, What is inside, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| lead | TEXT | merchant | Key ingredients and where they come from. | lead, TEXT, Key ingredients and where they come from., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | lead / text |  |
| anchor | TEXT | merchant | s10 | anchor, TEXT, s10, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| ingredients | LIST | merchant | list | ingredients, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One block per ingredient | blocks | One block per ingredient |
| freeFromLabel | TEXT | merchant | Free from: | freeFromLabel, TEXT, Free from:, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | free_from_label / text |  |
| freeFrom | LIST | merchant | list | freeFrom, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One tag per line in the theme editor | textarea | One tag per line in the theme editor |
| sourceLine | TEXT | merchant | Source line: where the key ingredients come from (merchant to provide). | sourceLine, TEXT, Source line: where the key ingredients come from (merchant to provide)., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | source_line / text |  |
**Exposed to the theme editor by this section:**
- base/section-heading . title via heading
- base/section-heading . lead via lead
- homepage/ingredient-card . name via ingredients.name
- homepage/ingredient-card . desc via ingredients.text
- base/chip . label via free_from lines

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks; ingredient placeholder tints


## Logo Item (`homepage/logo-item`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- One certification, award or press logo with a small type tag.
- Accessibility: A link named by its accessible name; the logo is decorative.
- Responsive: Scrolls sideways with the list.
- Design Variable groups: border colours, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| aria | TEXT | merchant | Certification 1 (placeholder): verify the certificate | aria, TEXT, Certification 1 (placeholder): verify the certificate, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name of the link | aria_label / text | Accessible name of the link |
| lbl | TEXT | wireframe | Certification logo | lbl, TEXT, Certification logo, wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Placeholder caption; replaced by the logo image in Shopify |  | Placeholder caption; replaced by the logo image in Shopify |
| tag | TEXT | merchant | Certification | tag, TEXT, Certification, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Type tag: Certification, Award or Press | tag / text | Type tag: Certification, Award or Press |
**Shopify-only settings (no wireframe equivalent):**
- image (image_picker)
- link (url)


## Logo List (`homepage/logo-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- A sideways-scrolling row of certification, award and press logos. Maps to the logo-list section. Every logo must be verifiable by the merchant.
- Accessibility: The heading role and level are set explicitly; the list is a labelled, focusable region.
- Responsive: Scrolls sideways with controls on small screens.
- Nested components: `common/scroller-controls`, `homepage/logo-item`
- Design Variable groups: surface background, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| label | TEXT | merchant | As recognised by | label, TEXT, As recognised by, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | label / text |  |
| regionLabel | TEXT | merchant | Certifications, awards and press | regionLabel, TEXT, Certifications, awards and press, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name of the list | region_label / text | Accessible name of the list |
| anchor | TEXT | merchant | s16 | anchor, TEXT, s16, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| logos | LIST | merchant | list | logos, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One block per logo | blocks | One block per logo |
**Exposed to the theme editor by this section:**
- homepage/logo-item . aria via logos.aria_label
- homepage/logo-item . tag via logos.tag

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks; logo placeholder captions


## Look Pin (`homepage/look-pin`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- A numbered hotspot on the look photo; shows the product name and price on hover or focus.
- Accessibility: A button with an accessible name Product N; the tooltip shows on hover and focus.
- Responsive: Positions are percentages of the photo.
- Design Variable groups: brand colour, z-index, shadow

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| n | TEXT | parent | 1 | n, TEXT, 1, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Pin number, from the position in the list |  | Pin number, from the position in the list |
| top | TEXT | merchant | 24% | top, TEXT, 24%, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Vertical position on the photo | y / range | Vertical position on the photo |
| left | TEXT | merchant | 40% | left, TEXT, 40%, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Horizontal position on the photo | x / range | Horizontal position on the photo |
| tip | TEXT | parent | Foundation &middot; $30.00 | tip, TEXT, Foundation &middot; $30.00, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], pin.product.title, pin.product.price, Tooltip text: product title and price |  | Tooltip text: product title and price |
**Shopify-only settings (no wireframe equivalent):**
- product (product): The product the pin points to


## Look Row (`homepage/look-row`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- One product in the look list: number, thumbnail, name, price and a View button.
- Accessibility: Row content is read in order; the View control is a button-styled label for now.
- Responsive: Thumbnail grows with the width.
- Design Variable groups: border colour, spacing, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| n | TEXT | parent | 1 | n, TEXT, 1, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Row number, from the position in the list |  | Row number, from the position in the list |
| tone | TEXT | wireframe |  | tone, TEXT, , wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Placeholder tint class |  | Placeholder tint class |
| name | TEXT | parent | Foundation | name, TEXT, Foundation, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], pin.product.title |  |  |
| price | TEXT | parent | $30.00 | price, TEXT, $30.00, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], pin.product.price |  |  |

## Shop the Look (`homepage/look-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- A look photo with numbered product pins and the list of those products. Maps to the shop-the-look section.
- Accessibility: Heading is an h2; pins are buttons with names.
- Responsive: Photo above the list below 768 px, side by side from 768 px; two photo crops.
- Nested components: `homepage/look-pin`, `homepage/look-row`
- Design Variable groups: page background, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| heading | TEXT | merchant | Shop the look | heading, TEXT, Shop the look, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| text | TEXT | merchant | Everyday makeup, with the products used. | text, TEXT, Everyday makeup, with the products used., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |
| anchor | TEXT | merchant | s09 | anchor, TEXT, s09, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| pins | LIST | merchant | list | pins, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One block per pin: a product and its position on the photo | blocks | One block per pin: a product and its position on the photo |
| rows | LIST | parent | list | rows, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], pins.product, The product list under the heading. In Shopify it is built from the pins products, never typed |  | The product list under the heading. In Shopify it is built from the pins products, never typed |
**Exposed to the theme editor by this section:**
- homepage/look-pin . top via pins.y
- homepage/look-pin . left via pins.x

**Shopify-only settings (no wireframe equivalent):**
- image (image_picker): The look photograph

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks; look photo placeholder captions


## Newsletter Field (`homepage/newsletter-field`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- The email field of the newsletter form: a visible label and an underlined input.
- Accessibility: A real label tied to the input; error state uses aria-invalid; the message region is announced politely.
- Responsive: Fills the row beside the button from 640 px.
- Design Variable groups: ink colour, error colour, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| label | TEXT | parent | Email address | label, TEXT, Email address, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Visible label from a locale string |  | Visible label from a locale string |

## Newsletter Perk (`homepage/newsletter-perk`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- One short reason to subscribe, with a check icon.
- Accessibility: A list item; the icon is decorative.
- Responsive: Wraps into rows on small screens.
- Nested components: `base/icon`
- Design Variable groups: brand colour, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| label | TEXT | merchant | New launches first | label, TEXT, New launches first, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |

## Newsletter (`homepage/newsletter-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- Email sign-up with a heading, three perks and a legal line. Maps to the newsletter section. The form posts to Shopify customer marketing.
- Accessibility: Heading is an h2; the field has a real label; success and error messages are announced.
- Responsive: Text above the form below 1024 px; side by side from 1024 px.
- Nested components: `homepage/newsletter-field`, `base/button`, `homepage/newsletter-perk`
- Design Variable groups: subtle background, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| anchor | TEXT | merchant | s19 | anchor, TEXT, s19, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| eyebrow | TEXT | merchant | Stay in touch | eyebrow, TEXT, Stay in touch, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | eyebrow / text |  |
| heading | TEXT | merchant | Join the list | heading, TEXT, Join the list, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| text | TEXT | merchant | Launches, offers and routine tips by email. | text, TEXT, Launches, offers and routine tips by email., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |
| buttonLabel | TEXT | merchant | Subscribe | buttonLabel, TEXT, Subscribe, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_label / text |  |
| legal | TEXT | merchant | By subscribing you agree to receive emails. Unsubscribe at any time. | legal, TEXT, By subscribing you agree to receive emails. Unsubscribe at any time., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Legal line; the merchant confirms the wording | legal / text | Legal line; the merchant confirms the wording |
| perks | LIST | merchant | list | perks, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One block per perk | blocks | One block per perk |
**Exposed to the theme editor by this section:**
- base/button . label via button_label
- homepage/newsletter-perk . label via perks.text

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks


## Product Card (Homepage) (`homepage/product-card`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- The Homepage product card: photo, badge, title, size, key attribute, rating, optional swatches and price. Separate from the PLP card by decision; they share only base parts.
- Accessibility: The whole card is one link named by the product title (stretched link). Rating icon is decorative; the rating text is visible.
- Responsive: Two columns below 768 px, four from 768 px.
- Nested components: `base/icon`
- Design Variable groups: type roles, colour tokens, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| tone | TEXT | wireframe | t4 | tone, TEXT, t4, wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Placeholder tint class |  | Placeholder tint class |
| photo | TEXT | wireframe | Product (studio, soft shadow) | photo, TEXT, Product (studio, soft shadow), wireframe, System.Collections.Generic.Dictionary`2[System.String,System.Object], Placeholder caption; replaced by the product image in Shopify |  | Placeholder caption; replaced by the product image in Shopify |
| badge | TEXT | parent (data pending merchant confirmation) |  | badge, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.tags (badge:<text>), True, Badge text. Empty hides the badge |  | Badge text. Empty hides the badge |
| badgeStyle | VARIANT | parent | neutral | neutral, brand | select | Badge colour: neutral for labels, brand for offers |
| title | TEXT | parent | Face Cleanser | title, TEXT, Face Cleanser, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.title |  |  |
| size | TEXT | parent (data pending merchant confirmation) | 150 ml | size, TEXT, 150 ml, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.metafields.custom.size, True, Size line |  | Size line |
| attr | TEXT | parent (data pending merchant confirmation) | Best for: all skin types | attr, TEXT, Best for: all skin types, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.metafields.custom.highlight, True, Highlight line |  | Highlight line |
| rating | TEXT | parent (data pending merchant confirmation) | 4.6 (112) | rating, TEXT, 4.6 (112), parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.metafields.reviews.rating, reviews.rating_count, True, Rating and count shown together |  | Rating and count shown together |
| hideSwatches | BOOLEAN | parent | True | hideSwatches, BOOLEAN, True, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.options, Swatches show only when the product has colour options |  | Swatches show only when the product has colour options |
| price | TEXT | parent | $18.00 | price, TEXT, $18.00, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.price |  |  |
| was | TEXT | parent |  | was, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.compare_at_price, Compare-at price. Empty hides it |  | Compare-at price. Empty hides it |
| href | TEXT | parent | # | href, TEXT, #, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.url, Product link |  | Product link |
**Wireframe-only, not carried to Shopify:** tone and photo placeholder; data-c review hooks


## Promotional Banner (`homepage/promo-banner`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- A campaign banner: image, copy and one button. Maps to the promo-banner section. Offer details and dates must be real.
- Accessibility: Heading is an h2.
- Responsive: Stacked below 768 px, side by side from 768 px.
- Nested components: `homepage/promo-media`, `homepage/promo-copy`
- Design Variable groups: brand background, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| anchor | TEXT | merchant | s17 | anchor, TEXT, s17, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| eyebrow | TEXT | merchant | Gift sets | eyebrow, TEXT, Gift sets, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | eyebrow / text |  |
| heading | TEXT | merchant | Gift sets for every routine | heading, TEXT, Gift sets for every routine, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| text | TEXT | merchant | Real offer details and dates go here. | text, TEXT, Real offer details and dates go here., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |
| buttonLabel | TEXT | merchant | Shop gift sets | buttonLabel, TEXT, Shop gift sets, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_label / text |  |
| buttonHref | TEXT | merchant | # | buttonHref, TEXT, #, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_link / url |  |
**Exposed to the theme editor by this section:**
- homepage/promo-copy . eyebrow via eyebrow
- homepage/promo-copy . heading via heading
- homepage/promo-copy . text via text
- homepage/promo-copy . buttonLabel via button_label
- homepage/promo-copy . buttonHref via button_link

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks


## Promo Copy (`homepage/promo-copy`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- Eyebrow, heading, one line and a button for the campaign.
- Accessibility: Heading is an h2.
- Responsive: Stacks below 768 px.
- Nested components: `base/button`
- Design Variable groups: brand colours, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| eyebrow | TEXT | merchant | Gift sets | eyebrow, TEXT, Gift sets, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | eyebrow / text |  |
| heading | TEXT | merchant | Gift sets for every routine | heading, TEXT, Gift sets for every routine, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| text | TEXT | merchant | Real offer details and dates go here. | text, TEXT, Real offer details and dates go here., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |
| buttonLabel | TEXT | merchant | Shop gift sets | buttonLabel, TEXT, Shop gift sets, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_label / text |  |
| buttonHref | TEXT | merchant | # | buttonHref, TEXT, #, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_link / url |  |

## Promo Media (`homepage/promo-media`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- The image beside the promotional copy. Wireframe placeholder today.
- Accessibility: Decorative or described by alt text from the image.
- Responsive: Full width below 768 px; half from 768 px.
- Design Variable groups: radius, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- image (image_picker)

**Wireframe-only, not carried to Shopify:** placeholder captions


## Review Card (`homepage/review-card`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- One customer quote with the name and a link to the product.
- Accessibility: A figure with a blockquote and a caption.
- Responsive: Cards scroll sideways on small screens.
- Nested components: `homepage/review-stars`, `base/icon`
- Design Variable groups: page colours, type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| quote | TEXT | merchant | Easy to find what I needed, and it arrived quickly. | quote, TEXT, Easy to find what I needed, and it arrived quickly., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | quote / textarea |  |
| name | TEXT | merchant | Customer name | name, TEXT, Customer name, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | name / text |  |
| product | TEXT | merchant | Face Cleanser | product, TEXT, Face Cleanser, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Product link text | product_label / text | Product link text |
**Shopify-only settings (no wireframe equivalent):**
- product_link (url)


## Review Stars (`homepage/review-stars`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- A row of five filled stars used as a layout placeholder in review cards. Reviews are typed by the merchant; there is no review platform.
- Accessibility: Decorative (aria-hidden).
- Responsive: Same at all widths.
- Nested components: `base/icon`
- Design Variable groups: brand colour

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- rating (range): Stars per review


## Ritual Controls (`homepage/ritual-controls`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- The step counter and the previous and next buttons of the ritual scroller. The script updates the counter and disables the buttons at the ends.
- Accessibility: The counter is a polite live region; buttons have names.
- Responsive: Shown only while the steps scroll.
- Nested components: `base/icon-button`
- Design Variable groups: spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|

## How to Use / Routine Steps (`homepage/ritual-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- A scrolling ritual of four steps, each with the product it uses. Maps to the ritual-steps section.
- Accessibility: Heading is an h2; the step list is a labelled, focusable region; the counter is announced.
- Responsive: Steps scroll sideways below 1024 px and sit in a row from 1024 px.
- Nested components: `homepage/ritual-controls`, `homepage/ritual-step`
- Design Variable groups: subtle background, spacing, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| eyebrow | TEXT | merchant | Your daily ritual | eyebrow, TEXT, Your daily ritual, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | eyebrow / text |  |
| heading | TEXT | merchant | A simple ritual, step by step | heading, TEXT, A simple ritual, step by step, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| text | TEXT | merchant | Four steps, in order, each with the product it uses. | text, TEXT, Four steps, in order, each with the product it uses., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |
| note | TEXT | merchant | Optional closing tip, from the product labels. | note, TEXT, Optional closing tip, from the product labels., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | note / text |  |
| anchor | TEXT | merchant | s11 | anchor, TEXT, s11, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| steps | LIST | merchant | list | steps, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One block per step | blocks | One block per step |
**Exposed to the theme editor by this section:**
- homepage/ritual-step . name via steps.name
- homepage/ritual-step . desc via steps.text
- homepage/ritual-step . product via steps.product_label

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks; step image placeholders


## Ritual Step (`homepage/ritual-step`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- One step: image, number, name, how to apply, and the product it uses.
- Accessibility: A list item; the step number is spoken as Step N before the name.
- Responsive: Steps scroll sideways on small screens.
- Nested components: `base/icon`
- Design Variable groups: border colour, type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| n | TEXT | parent | 01 | n, TEXT, 01, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Zero-padded step number, from the position |  | Zero-padded step number, from the position |
| num | TEXT | parent | 1 | num, TEXT, 1, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Step number for assistive text, from the position |  | Step number for assistive text, from the position |
| name | TEXT | merchant | Cleanse | name, TEXT, Cleanse, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | name / text |  |
| desc | TEXT | merchant | How to apply, from the Face Cleanser label. | desc, TEXT, How to apply, from the Face Cleanser label., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / textarea |  |
| product | TEXT | merchant | Face Cleanser | product, TEXT, Face Cleanser, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Product link text | product_label / text | Product link text |
**Shopify-only settings (no wireframe equivalent):**
- product (product): Product the step links to
- image (image_picker)
- tip (text)
- time (text)


## Routine Step (`homepage/routine-step`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- A numbered pill linking to a routine step.
- Accessibility: A link; the number is part of the visible label.
- Responsive: Pills wrap on small screens.
- Design Variable groups: brand colour, radius, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| n | TEXT | parent | 1 | n, TEXT, 1, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Step number, derived from the position in the list |  | Step number, derived from the position in the list |
| label | TEXT | merchant | Cleanse | label, TEXT, Cleanse, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Step label | label / text | Step label |
**Shopify-only settings (no wireframe equivalent):**
- collection (collection): Resolves the link


## Testimonials (`homepage/testimonials-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- A sideways-scrolling row of customer quotes typed by the merchant. Maps to the testimonials section.
- Accessibility: Heading is an h2; the list is a labelled, focusable region with previous and next buttons.
- Responsive: Scrolls sideways with controls; several cards visible from 1024 px.
- Nested components: `base/section-heading`, `common/scroller-controls`, `homepage/review-card`
- Design Variable groups: surface background, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| heading | TEXT | merchant | What customers say | heading, TEXT, What customers say, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| anchor | TEXT | merchant | s14 | anchor, TEXT, s14, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| reviews | LIST | merchant | list | reviews, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One block per quote | blocks | One block per quote |
**Exposed to the theme editor by this section:**
- base/section-heading . title via heading
- homepage/review-card . quote via reviews.quote
- homepage/review-card . name via reviews.name
- homepage/review-card . product via reviews.product_label

**Shopify-only settings (no wireframe equivalent):**
- rating (range): Stars shown per review

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks; the note line about typed reviews


## USP Item (`homepage/usp-item`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- One benefit: an icon in a circle, a title and a short line. Four of them make the benefits row.
- Accessibility: The icon is decorative; the title and text carry the meaning.
- Responsive: Two columns below 600 px, four from 600 px.
- Nested components: `base/icon`
- Design Variable groups: brand colours, type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| icon | INSTANCE_SWAP | merchant | heart | icon, INSTANCE_SWAP, heart, System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Icon from the shared sprite; the existing theme lets merchants pick it | icon / select | Icon from the shared sprite; the existing theme lets merchants pick it |
| title | TEXT | merchant | Cruelty-free | title, TEXT, Cruelty-free, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | title / text |  |
| text | TEXT | merchant | Only if certified or verifiable | text, TEXT, Only if certified or verifiable, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |

## Benefits / USP Row (`homepage/usp-row`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- A row of four benefits under the hero. Maps to the usp-row section in the Shopify theme.
- Accessibility: A group of short statements; no interactive elements.
- Responsive: Two columns below 600 px with dividers, four across from 600 px.
- Nested components: `homepage/usp-item`
- Design Variable groups: surface background, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| anchor | TEXT | merchant | s04 | anchor, TEXT, s04, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| items | LIST | merchant | list | items, LIST, System.Object[], System.Object[], merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One block per benefit | blocks | One block per benefit |
**Exposed to the theme editor by this section:**
- homepage/usp-item . icon via items.icon
- homepage/usp-item . title via items.title
- homepage/usp-item . text via items.text

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute


## Video Copy (`homepage/video-copy`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- Eyebrow, heading, one line and a button beside the video.
- Accessibility: Heading is an h2.
- Responsive: Below the poster on small screens, beside it from 768 px.
- Nested components: `base/button`
- Design Variable groups: inverse colours, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| eyebrow | TEXT | merchant | Tutorial | eyebrow, TEXT, Tutorial, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | eyebrow / text |  |
| heading | TEXT | merchant | Watch: building a simple routine | heading, TEXT, Watch: building a simple routine, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| text | TEXT | merchant | A short tutorial that shows the steps in order. | text, TEXT, A short tutorial that shows the steps in order., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |
| buttonLabel | TEXT | merchant | Shop the products | buttonLabel, TEXT, Shop the products, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_label / text |  |
| buttonHref | TEXT | merchant | #s06 | buttonHref, TEXT, #s06, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_link / url |  |

## Video Poster (`homepage/video-poster`)

- Level: sub; page scope: homepage; status: classified (D10 items pending)
- The still image with a play control that opens the tutorial. The wireframe holds no player.
- Accessibility: The play control is a button with an accessible name.
- Responsive: Full width, 16:9.
- Design Variable groups: overlay, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- cover_image (image_picker)
- video_url (video_url): Hosted video the poster opens
- duration (text): Length shown on the poster

**Wireframe-only, not carried to Shopify:** placeholder captions


## Video Section (`homepage/video-section`)

- Level: main; page scope: homepage; status: classified (D10 items pending)
- A tutorial video poster with a short text and a button. Maps to the video-section section.
- Accessibility: Heading is an h2; the play control is a button.
- Responsive: Stacked below 768 px, side by side from 768 px.
- Nested components: `homepage/video-poster`, `homepage/video-copy`
- Design Variable groups: inverse background, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| anchor | TEXT | merchant | s12 | anchor, TEXT, s12, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], In-page anchor id | anchor / text | In-page anchor id |
| eyebrow | TEXT | merchant | Tutorial | eyebrow, TEXT, Tutorial, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | eyebrow / text |  |
| heading | TEXT | merchant | Watch: building a simple routine | heading, TEXT, Watch: building a simple routine, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| text | TEXT | merchant | A short tutorial that shows the steps in order. | text, TEXT, A short tutorial that shows the steps in order., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / text |  |
| buttonLabel | TEXT | merchant | Shop the products | buttonLabel, TEXT, Shop the products, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_label / text |  |
| buttonHref | TEXT | merchant | #s06 | buttonHref, TEXT, #s06, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_link / url |  |
**Exposed to the theme editor by this section:**
- homepage/video-copy . eyebrow via eyebrow
- homepage/video-copy . heading via heading
- homepage/video-copy . text via text
- homepage/video-copy . buttonLabel via button_label
- homepage/video-copy . buttonHref via button_link

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; data-c review hooks


## Announcement Arrow (`layout/announcement-arrow`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- Previous or next control of the announcement bar.
- Accessibility: A button with an accessible name.
- Responsive: Hidden on small screens where the dots show.
- Nested components: `base/icon`
- Design Variable groups: touch target

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| id | TEXT | parent | ann-prev | id, TEXT, ann-prev, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Script id |  | Script id |
| label | TEXT | parent | Previous message | label, TEXT, Previous message, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name from a locale string |  | Accessible name from a locale string |
| icon | INSTANCE_SWAP | parent | chevron-left | icon, INSTANCE_SWAP, chevron-left, System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Arrow icon | select | Arrow icon |

## Announcement Bar (`layout/announcement-bar`)

- Level: main; page scope: shared; status: classified (D10 items pending)
- A one-line message above the header with previous and next controls. Maps to the announcement-bar section.
- Accessibility: The message sits in a polite live region; the controls are buttons.
- Responsive: Arrows from 600 px; dots below 600 px.
- Nested components: `layout/announcement-arrow`, `layout/announcement-dots`
- Design Variable groups: brand background, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| message | TEXT | merchant | Free shipping on orders over $50 | message, TEXT, Free shipping on orders over $50, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], The message shown | text / text | The message shown |
**Shopify-only settings (no wireframe equivalent):**
- link (url): Optional link on the message
- autoplay (checkbox)
- interval (range)


## Announcement Dots (`layout/announcement-dots`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- Position dots shown on small screens when the announcement bar has several messages.
- Accessibility: Decorative (aria-hidden).
- Responsive: Visible below 600 px only.
- Design Variable groups: brand colour

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|

## Back to Top (`layout/back-to-top`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- A link at the end of the footer that returns to the top of the page.
- Accessibility: A link with visible text.
- Responsive: Full width below 600 px; inline from 600 px.
- Nested components: `base/icon`
- Design Variable groups: touch target, inverse colours

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
**Shopify-only settings (no wireframe equivalent):**
- show_back_to_top (checkbox)


## Footer Brand (`layout/footer-brand`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- Logo, one line about the brand and the social links.
- Accessibility: The logo link is named by the SVG.
- Responsive: Full width block on small screens.
- Nested components: `layout/social-link`
- Design Variable groups: inverse colours, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| text | TEXT | merchant | One line about the brand. | text, TEXT, One line about the brand., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Brand statement | brand_text / textarea | Brand statement |
**Shopify-only settings (no wireframe equivalent):**
- show_social (checkbox): Social links come from theme settings


## Footer Column (`layout/footer-column`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- A titled group of footer links. An accordion below 768 px, an open list from 768 px.
- Accessibility: A disclosure button on small screens; a plain list from 768 px.
- Responsive: Accordion below 768 px.
- Nested components: `base/icon`
- Design Variable groups: inverse colours, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| title | TEXT | merchant | Shop | title, TEXT, Shop, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Group heading | heading / text | Group heading |
| links | LIST | parent | Skin care::#collection/Makeup::#collection | links, LIST, Skin care::#collection/Makeup::#collection, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], linklist links, Links as label::address pairs |  | Links as label::address pairs |
**Shopify-only settings (no wireframe equivalent):**
- menu (link_list): The links of the group


## Footer Payments (`layout/footer-payments`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- The accepted payment methods shown as text labels.
- Accessibility: A labelled group of text labels.
- Responsive: Wraps.
- Design Variable groups: inverse colours

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| methods | LIST | merchant | Visa/Mastercard/UPI/Wallet | methods, LIST, Visa/Mastercard/UPI/Wallet, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One method per line in the theme editor | payment_methods / textarea | One method per line in the theme editor |

## Footer (`layout/site-footer`)

- Level: main; page scope: shared; status: classified (D10 items pending)
- The site footer: brand and social links, four link groups, payment methods, a trust line and Back to top. Maps to the footer section in the Shopify footer group.
- Accessibility: A contentinfo landmark; link groups are accordions on small screens.
- Responsive: Link groups stack as accordions below 768 px and sit in columns from 768 px.
- Nested components: `layout/footer-brand`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Design Variable groups: inverse background, spacing, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| brandText | TEXT | merchant | One line about the brand. | brandText, TEXT, One line about the brand., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | brand_text / textarea |  |
| paymentMethods | LIST | merchant | Visa/Mastercard/UPI/Wallet | paymentMethods, LIST, Visa/Mastercard/UPI/Wallet, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], One method per line | payment_methods / textarea | One method per line |
| trustText | TEXT | merchant | Secure checkout. Easy returns. Support when you need it. | trustText, TEXT, Secure checkout. Easy returns. Support when you need it., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | trust_text / text |  |
**Exposed to the theme editor by this section:**
- layout/footer-brand . text via brand_text
- layout/footer-payments . methods via payment_methods
- layout/footer-column . title via link_list blocks (heading)

**Shopify-only settings (no wireframe equivalent):**
- show_social (checkbox)
- show_back_to_top (checkbox)
- link_list (blocks): One block per footer link group (heading and menu)

**Wireframe-only, not carried to Shopify:** data-c review hooks


## Social Link (`layout/social-link`)

- Level: sub; page scope: shared; status: classified (D10 items pending)
- One social network link shown as an icon.
- Accessibility: A link with an accessible name.
- Responsive: Same at all widths.
- Nested components: `base/icon`
- Design Variable groups: touch target

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| label | TEXT | parent | Instagram | label, TEXT, Instagram, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name |  | Accessible name |
| icon | INSTANCE_SWAP | parent | instagram | icon, INSTANCE_SWAP, instagram, System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Network icon | select | Network icon |
**Shopify-only settings (no wireframe equivalent):**
- social_url (url): Theme settings social_instagram, social_facebook, social_youtube


## Applied Filter Chips (`plp/applied-chips`)

- Level: sub; page scope: plp; status: classified
- The removable chips for the filters that are applied, one per choice.
- Accessibility: Each chip is a toggle button with the words Remove filter for screen readers.
- Responsive: One scrolling line on phones; wraps from 600 px.
- Nested components: `base/icon`
- Design Variable groups: chip tokens, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| chips | LIST | parent | list | chips, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], collection.filters.active_values, One chip per applied filter |  | One chip per applied filter |

## Collection Banner (`plp/collection-banner`)

- Level: main; page scope: plp; status: classified
- Breadcrumb, the one H1, a short intro and, from 1024 px, a collection image on the right. Maps to the collection banner of the collection template.
- Accessibility: The H1 labels the section; the breadcrumb is a labelled nav with aria-current.
- Responsive: Text only below 1024 px; from 1024 px the image fills the right half.
- Design Variable groups: banner gradient, type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| breadcrumb | LIST | parent | list | breadcrumb, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], collection and shop links, Home and the current collection |  | Home and the current collection |
| eyebrow | TEXT | merchant | The collection | eyebrow, TEXT, The collection, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | eyebrow / text |  |
| heading | TEXT | parent | Skin care | heading, TEXT, Skin care, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], collection.title, The one H1 of the page |  | The one H1 of the page |
| intro | TEXT | parent | Cleansers, serums, moisturisers and sun care, chosen to work together. | intro, TEXT, Cleansers, serums, moisturisers and sun care, chosen to work together., parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], collection.description, Short intro, two lines at most |  | Short intro, two lines at most |
**Shopify-only settings (no wireframe equivalent):**
- show_image_on_mobile (checkbox): Show the collection image below 1024 px (default off, so products start early)
- collection_image (image_picker): Uses collection.image when empty

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute; collection image placeholder


## Empty Filter Result (`plp/empty-state`)

- Level: sub; page scope: plp; status: classified
- Shown in place of the grid when the filters match no products: a message, a Clear all filters button and category links.
- Accessibility: Plain text and links; focus moves to the filters control after Clear all.
- Responsive: Same at all widths.
- Nested components: `base/icon`, `base/button`
- Design Variable groups: spacing, chip tokens

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| heading | TEXT | parent | No products match these filters | heading, TEXT, No products match these filters, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Locale string |  | Locale string |
| text | TEXT | parent | Remove a filter or start from a category. | text, TEXT, Remove a filter or start from a category., parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Locale string |  | Locale string |
| buttonLabel | TEXT | parent | Clear all filters | buttonLabel, TEXT, Clear all filters, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Locale string |  | Locale string |
| links | LIST | parent | list | links, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], collection list, Category links |  | Category links |

## Filter Groups (`plp/facet-groups`)

- Level: sub; page scope: plp; status: classified
- The collapsible filter groups: checkbox options with counts, shade swatches and the price range. One form is placed in the sidebar from 768 px and in the left drawer below.
- Accessibility: Native details and summary groups; fieldsets with legends; swatches have text names and counts.
- Responsive: A left sidebar from 768 px; a left slide-in drawer below.
- Nested components: `base/icon`
- Design Variable groups: accordion tokens, choice and swatch styles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| groups | LIST | parent | list | groups, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], collection.filters, Filter groups with their options and counts. In Shopify these come from Search and Discovery filters set in the admin |  | Filter groups with their options and counts. In Shopify these come from Search and Discovery filters set in the admin |

## Filters Drawer (`plp/filters-drawer`)

- Level: main; page scope: plp; status: classified
- The left slide-in drawer that holds the filter form below 768 px, with Clear all and Apply filters (the count is kept current by the page script).
- Accessibility: A native dialog labelled by its title; focus is trapped while open and returns to the opener.
- Responsive: Used below 768 px only; above it the form sits in the sidebar.
- Nested components: `base/icon-button`, `base/button`
- Design Variable groups: drawer tokens, z-index

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| title | TEXT | parent | Filters | title, TEXT, Filters, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Locale string |  | Locale string |
| closeLabel | TEXT | parent | Close filters | closeLabel, TEXT, Close filters, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Locale string |  | Locale string |
| clearLabel | TEXT | parent | Clear all | clearLabel, TEXT, Clear all, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Locale string |  | Locale string |
| applyLabel | TEXT | parent | Apply filters (24) | applyLabel, TEXT, Apply filters (24), parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Locale string with the live count |  | Locale string with the live count |

## Filters Sidebar (`plp/filters-sidebar`)

- Level: main; page scope: plp; status: classified
- The filter column from 768 px: a heading with Clear all, and the one filter form (the groups are filled in by the filter groups component). Below 768 px the same form is moved into the filters drawer.
- Accessibility: A labelled aside; each group is a details element with a fieldset.
- Responsive: Left column from 768 px (about 240 px wide); below 768 px the form lives in the filters drawer.
- Nested components: `base/button`
- Design Variable groups: accordion tokens, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| title | TEXT | parent | Filters | title, TEXT, Filters, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Heading and accessible name, from a locale string |  | Heading and accessible name, from a locale string |
| clearLabel | TEXT | parent | Clear all | clearLabel, TEXT, Clear all, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Button text from a locale string |  | Button text from a locale string |
**Shopify-only settings (no wireframe equivalent):**
- filters (data): Filters come from Search and Discovery (collection.filters); the merchant chooses them in the Shopify admin

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute


## Pagination (`plp/pagination`)

- Level: sub; page scope: plp; status: classified
- Numbered pagination: Previous, the current page with its neighbours, ellipsis gaps and Next. The list items only; the nav landmark is in the product grid section.
- Accessibility: Links with aria-current on the current page and aria-disabled at the ends; Previous and Next keep their words for screen readers.
- Responsive: Previous and Next show words from 600 px and icons only below.
- Nested components: `base/icon`
- Design Variable groups: brand colour, radius, type roles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| items | LIST | parent | list | items, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], paginate.parts, Previous, page numbers, gaps and Next |  | Previous, page numbers, gaps and Next |

## Product Card (PLP) (`plp/product-card`)

- Level: sub; page scope: plp; status: classified
- The collection page product card: image with one badge, category, title, key attribute, rating, price with compare-at and unit price, shade dots, low-stock line and a Quick view action. Separate from the Homepage product card by decision; they share only base parts (icon, badge, price, rating, button).
- Accessibility: The whole card is one link (the title); the Quick view control is a separate labelled button; rating text and prices have screen reader text.
- Responsive: Hover and fine pointer: second image fades in and Quick view rises over the image. Touch: the labelled button sits under the card.
- Nested components: `base/badge`, `base/button`, `base/rating`, `base/price`, `base/icon`
- Design Variable groups: type roles, colours, spacing, radius

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| index | TEXT | parent | 0 | index, TEXT, 0, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Position of the product in the sample data; Quick view opens this product. In Shopify: the product id or handle |  | Position of the product in the sample data; Quick view opens this product. In Shopify: the product id or handle |
| title | TEXT | parent | Face Cleanser | title, TEXT, Face Cleanser, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.title |  |  |
| type | TEXT | parent | Cleanser | type, TEXT, Cleanser, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.type, Small category line above the title |  | Small category line above the title |
| attr | TEXT | parent (data pending merchant confirmation) | Best for: all skin types | attr, TEXT, Best for: all skin types, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.metafields.custom.highlight, True, Key attribute line |  | Key attribute line |
| soldOut | BOOLEAN | parent | False | soldOut, BOOLEAN, False, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.available, Sold out: dims the image, shows the Sold out badge and a disabled button |  | Sold out: dims the image, shows the Sold out badge and a disabled button |
| hasBadge | BOOLEAN | parent | True | hasBadge, BOOLEAN, True, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Whether a badge is shown (derived from the badge kind) |  | Whether a badge is shown (derived from the badge kind) |
| badgeKind | VARIANT | parent | label | none, soldout, sale, label |  | One quiet badge: sold out, sale percentage, or a merchant label |
| badgeText | TEXT | parent (data pending merchant confirmation) | Bestseller | badgeText, TEXT, Bestseller, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.tags (badge:<text>), True, Label text for the label badge |  | Label text for the label badge |
| salePct | TEXT | parent | 0 | salePct, TEXT, 0, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], compare_at_price and price, Percentage saved, for the sale badge |  | Percentage saved, for the sale badge |
| showRating | BOOLEAN | parent (data pending merchant confirmation) | True | showRating, BOOLEAN, True, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.metafields.reviews.rating_count, True, Shown only when the product has enough reviews |  | Shown only when the product has enough reviews |
| ratingStars | VARIANT | parent | 5 | 0, 1, 2, 3, 4, 5 |  | Filled stars, 0 to 5 |
| ratingValue | TEXT | parent (data pending merchant confirmation) | 4.8 | ratingValue, TEXT, 4.8, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.metafields.reviews.rating, True, Rating for assistive technology |  | Rating for assistive technology |
| ratingText | TEXT | parent (data pending merchant confirmation) | 4.8 (212) | ratingText, TEXT, 4.8 (212), parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], reviews.rating, reviews.rating_count, True, Rating and count shown after the stars |  | Rating and count shown after the stars |
| swatches | LIST | parent | list | swatches, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product option values (colour), Up to four shade dots |  | Up to four shade dots |
| swatchMore | TEXT | parent |  | swatchMore, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], How many more shades there are, empty for none |  | How many more shades there are, empty for none |
| lowStock | TEXT | parent |  | lowStock, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], variant.inventory_quantity, Units left, shown only with tracked inventory; empty hides the line |  | Units left, shown only with tracked inventory; empty hides the line |
| priceVariant | VARIANT | parent | regular | regular, sale |  | regular or sale |
| price | TEXT | parent | $18.00 | price, TEXT, $18.00, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.price |  |  |
| compare | TEXT | parent |  | compare, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.compare_at_price, Compare-at price, for the sale variant |  | Compare-at price, for the sale variant |
| unit | TEXT | parent | $0.12 / ml | unit, TEXT, $0.12 / ml, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], variant.unit_price, Unit price; empty hides it |  | Unit price; empty hides it |
| secondImage | BOOLEAN | parent | True | secondImage, BOOLEAN, True, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.media (second item), Second image that fades in on mouse screens |  | Second image that fades in on mouse screens |
| tone | VARIANT | wireframe | a | a, b, c |  | Placeholder tone |
**Wireframe-only, not carried to Shopify:** tone and placeholder captions (the image area)


## Product Grid (`plp/product-grid`)

- Level: main; page scope: plp; status: classified
- The product grid (2 to 4 columns, one card size), the optional promo tile after the eighth product on page one, the empty filter state and numbered pagination. The cards, tile and pagination items are rendered into it by the page script from their own components.
- Accessibility: A region labelled Products; the grid is a plain list of cards; pagination is a labelled nav.
- Responsive: Two columns below 600 px, three from 600 px, two beside the sidebar from 768 px, three from 1024 px, four from 1280 px.
- Nested components: `plp/empty-state`, `plp/product-card`, `plp/promo-tile`, `plp/pagination`
- Design Variable groups: grid gap, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| heading | TEXT | parent | Products | heading, TEXT, Products, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Hidden heading that names the region, from a locale string |  | Hidden heading that names the region, from a locale string |
| paginationLabel | TEXT | parent | Pagination | paginationLabel, TEXT, Pagination, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name of the pagination nav |  | Accessible name of the pagination nav |
**Shopify-only settings (no wireframe equivalent):**
- products_per_page (range): Products on each page (the wireframe shows 10)
- show_second_image (checkbox): Second image on hover (mouse screens only)
- show_rating (checkbox)
- promo_tile (blocks): Promo tile block: eyebrow, heading, text, button label and link

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute


## Promo Tile (`plp/promo-tile`)

- Level: sub; page scope: plp; status: classified
- An optional merchant tile in the product grid, after the eighth product on page one: a text card with a button.
- Accessibility: An aside landmark labelled Promotion.
- Responsive: Spans two columns from 600 px.
- Nested components: `base/button`
- Design Variable groups: inverse surface, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| eyebrow | TEXT | merchant | Gift sets | eyebrow, TEXT, Gift sets, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | eyebrow / text |  |
| heading | TEXT | merchant | Gifts for every routine | heading, TEXT, Gifts for every routine, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | heading / text |  |
| text | TEXT | merchant | Real offer details and dates go here. Image, text card or video tile; 2 columns from 600 px. | text, TEXT, Real offer details and dates go here. Image, text card or video tile; 2 columns from 600 px., merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | text / textarea |  |
| buttonLabel | TEXT | merchant | Shop gift sets | buttonLabel, TEXT, Shop gift sets, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_label / text |  |
| buttonHref | TEXT | merchant | #cat | buttonHref, TEXT, #cat, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object] | button_link / url |  |

## Quick View Content (`plp/quick-view-body`)

- Level: sub; page scope: plp; status: classified
- The content of the Quick view side panel: image, category, rating, price, key line, short description and, when the product has shades, a shade chooser. The panel itself (title, Add to bag, close) is the quick view drawer.
- Accessibility: Shade choices are radios inside a radiogroup; the added message is a status region.
- Responsive: A right side panel at every width.
- Nested components: `base/rating`, `base/price`, `base/icon`
- Design Variable groups: type roles, swatch styles

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| type | TEXT | parent | Cleanser | type, TEXT, Cleanser, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.type |  |  |
| showRating | BOOLEAN | parent (data pending merchant confirmation) | True | showRating, BOOLEAN, True, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], reviews.rating_count, True |  |  |
| ratingStars | VARIANT | parent | 5 | 0, 1, 2, 3, 4, 5 |  |  |
| ratingValue | TEXT | parent (data pending merchant confirmation) | 4.8 | ratingValue, TEXT, 4.8, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], reviews.rating, True |  |  |
| ratingText | TEXT | parent (data pending merchant confirmation) | 4.8 (212) | ratingText, TEXT, 4.8 (212), parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], reviews.rating, reviews.rating_count, True |  |  |
| priceVariant | VARIANT | parent | regular | regular, sale |  |  |
| price | TEXT | parent | $18.00 | price, TEXT, $18.00, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.price |  |  |
| compare | TEXT | parent |  | compare, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.compare_at_price |  |  |
| unit | TEXT | parent |  | unit, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], variant.unit_price |  |  |
| attr | TEXT | parent (data pending merchant confirmation) | Best for: all skin types | attr, TEXT, Best for: all skin types, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.metafields.custom.highlight, True |  |  |
| ml | TEXT | parent (data pending merchant confirmation) | 150 | ml, TEXT, 150, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.metafields.custom.size, True, Size in millilitres |  | Size in millilitres |
| firstShade | TEXT | parent |  | firstShade, TEXT, , parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Name of the selected shade |  | Name of the selected shade |
| shades | LIST | parent | list | shades, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product option values (colour), Shade choices |  | Shade choices |
**Wireframe-only, not carried to Shopify:** image placeholder and its caption; sample description text


## Quick View Drawer (`plp/quick-view-drawer`)

- Level: main; page scope: plp; status: classified
- The right side panel for Quick view: a title, the product content (rendered by the Quick View Content component), Add to bag and a link to the full product page.
- Accessibility: A native dialog labelled by its title; focus is trapped while open and returns to the opener.
- Responsive: A right side panel at every width.
- Nested components: `base/icon-button`, `base/button`, `plp/quick-view-body`
- Design Variable groups: drawer tokens, z-index

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| title | TEXT | parent | Quick view | title, TEXT, Quick view, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Replaced with the product name by the page script |  | Replaced with the product name by the page script |
| closeLabel | TEXT | parent | Close quick view | closeLabel, TEXT, Close quick view, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Locale string |  | Locale string |
| addLabel | TEXT | parent | Add to bag | addLabel, TEXT, Add to bag, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Locale string |  | Locale string |
| moreLabel | TEXT | parent | View full details | moreLabel, TEXT, View full details, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Locale string |  | Locale string |
| moreHref | TEXT | parent | #pdp | moreHref, TEXT, #pdp, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], product.url, Product page link |  | Product page link |

## Collection Description (`plp/seo-block`)

- Level: main; page scope: plp; status: classified
- A reading-width text block under the grid and pagination, so products stay first. In Shopify it is the collection description.
- Accessibility: A heading and plain paragraphs.
- Responsive: Reading width capped at the Design System text measure at every size.
- Design Variable groups: type roles, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| heading | TEXT | merchant | About our skin care | heading, TEXT, About our skin care, merchant, System.Collections.Generic.Dictionary`2[System.String,System.Object], Heading of the block | heading / text | Heading of the block |
| paragraphs | LIST | parent | list | paragraphs, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], collection.description, Paragraphs of the collection description |  | Paragraphs of the collection description |
**Shopify-only settings (no wireframe equivalent):**
- show_description (checkbox)

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute


## Sub-collection Links (`plp/subcollection-nav`)

- Level: main; page scope: plp; status: classified
- A row of chips that narrows the collection by category in one tap, before filtering. One scrolling line on phones, wrapping from 600 px.
- Accessibility: A labelled navigation; the current chip has aria-current.
- Responsive: One scrolling line below 600 px; wraps from 600 px.
- Design Variable groups: chip tokens, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| label | TEXT | parent | Skin care categories | label, TEXT, Skin care categories, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name of the navigation |  | Accessible name of the navigation |
| items | LIST | parent | list | items, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], collection list or link list, One chip per sub-collection; the current one is marked |  | One chip per sub-collection; the current one is marked |
**Shopify-only settings (no wireframe equivalent):**
- menu (link_list): The links shown as chips

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute


## Sort and Count Toolbar (`plp/toolbar`)

- Level: main; page scope: plp; status: classified
- The bar above the grid: the Filters button (phones), the sort select, the live product count, and the applied filter chips with Clear all.
- Accessibility: The count is a polite status region; the sort is a native select with a label.
- Responsive: From 768 px: count left, sort right. Below 768 px: Filters and Sort side by side, count beneath.
- Nested components: `base/button`, `base/icon`
- Design Variable groups: control tokens, spacing

| Property | Type | Scope | Default | Values | Shopify | Note |
|---|---|---|---|---|---|---|
| filtersLabel | TEXT | parent | Filters | filtersLabel, TEXT, Filters, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Filters button text from a locale string |  | Filters button text from a locale string |
| sortLabel | TEXT | parent | Sort products | sortLabel, TEXT, Sort products, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name of the sort select |  | Accessible name of the sort select |
| sortOptions | LIST | parent | list | sortOptions, LIST, System.Object[], System.Object[], parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], collection.sort_options, Sort choices |  | Sort choices |
| sortShort | TEXT | parent | Sort | sortShort, TEXT, Sort, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Short word shown on very narrow screens |  | Short word shown on very narrow screens |
| count | TEXT | parent | 24 products | count, TEXT, 24 products, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], collection.products_count, Live product count; the page script keeps it current |  | Live product count; the page script keeps it current |
| appliedLabel | TEXT | parent | Applied filters | appliedLabel, TEXT, Applied filters, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Accessible name of the chip group |  | Accessible name of the chip group |
| clearLabel | TEXT | parent | Clear all | clearLabel, TEXT, Clear all, parent, System.Collections.Generic.Dictionary`2[System.String,System.Object], Button text from a locale string |  | Button text from a locale string |
**Shopify-only settings (no wireframe equivalent):**
- sort_by (data): Native Shopify sorting

**Wireframe-only, not carried to Shopify:** .ann annotation block; data-section attribute


## Other implemented components (properties inferred from templates)

| Component | Level | Inferred properties |
|---|---|---|

## Supported states

States come from the Design System component classes; they are CSS states and are not separate components.

| Component | States |
|---|---|
| Button | default, hover, active, focus-visible, disabled; block (full width) |
| Icon Button | default, hover, focus-visible, disabled |
| Chip | default, hover, selected (aria-pressed), focus-visible |
| Input Field | default, focus, filled, error (aria-invalid), disabled |
| Quantity | default, minimum reached, maximum reached, disabled |
| Accordion | collapsed, expanded, focus-visible |
| Message | success, error, warning |
| Product card (PLP) | default, hover, sold out |
| Drawer / dialog | closed, open |
| Header navigation | default, hover, open (mega menu), mobile drawer open |
| Choice / swatch | default, hover, selected, sold out (disabled), focus-visible |

Responsive behaviour is defined per component in its manifest and by the Design Variable breakpoints (600, 768, 1024, 1280 px).
