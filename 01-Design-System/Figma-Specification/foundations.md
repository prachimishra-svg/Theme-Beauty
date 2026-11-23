# Foundations (Figma)

How the NUDGE foundations are organised inside Figma. Values are not repeated here; they live in the Variables ([../../02-Design-Variables/Figma-Variables/collections.md](../../02-Design-Variables/Figma-Variables/collections.md)). This page says **which mechanism holds what** and the rules for using it.

## Which Figma mechanism holds what

| Foundation | Mechanism | Collection or style | Why |
|---|---|---|---|
| Colour palette | Variables (COLOR) | Primitives | Raw values; hidden from publishing so designers do not bind them directly |
| Colour roles | Variables (COLOR) with modes | Semantic (Default, Inverse) | Roles must re-resolve on an inverse surface |
| Spacing scale, radius, stroke, opacity | Variables (FLOAT) | Primitives | One 4px scale shared by every component |
| Page gutter, grid gap, header height, section spacing, containers | Variables (FLOAT) with modes | Layout (Mobile, Tablet, Desktop) | These change by tier in the web system |
| Font family and weight | Variables (STRING, FLOAT) | Primitives | Bound into Text Styles |
| Font size (px) | Variables (FLOAT) with modes | Typography (Mobile, Tablet, Desktop) | Sizes change by tier |
| Line height, letter spacing, case | Text Style properties | 21 Text Styles | Web values are ratios and em values; stored as percentages |
| Shadows | Effect Styles | 3 styles | A shadow is a bundle; a Variable cannot hold it |
| Product grid columns | Grid Styles | 3 styles | Column count cannot be bound to a Variable |
| Aspect ratios | Frame sizing with locked proportions | n/a | Not a Variable type |
| Motion | Prototype interaction settings | n/a | Timing cannot bind to Variables |
| Component sizes shared by several components | Variables (FLOAT) | Components | Touch target, control heights, icon, choice and swatch sizes, focus ring |

## Rules

1. **Bind, do not type.** Every fill, stroke, text colour, gap, padding, radius and size in a component is bound to a Semantic, Layout or Components variable. Primitives are never bound in a component (they are hidden from the picker for that reason).
2. **Colour comes from Semantic.** Choose `color/text/primary`, not `palette/charcoal`. On a footer or promotional frame set the **Semantic mode to Inverse**; do not recolour by hand.
3. **Tier comes from the mode.** On a page frame set **Layout and Typography to the same tier** (Mobile, Tablet or Desktop). Reference widths: 360, 768, 1280 (`layout/frame-width`).
4. **Never place a bare control directly on Rose Quartz** (`color/bg/subtle`): the control border is 2.72:1 there. Put controls on Pearl Pink or White. Muted text passes on Rose Quartz (4.59:1).
5. **Font sizes are px.** Never point values. Body and input text are never below 16px.
6. **One focus ring.** 2px, offset 2px, `color/focus/ring` (the Inverse mode swaps it to the lighter ring, because the default ring is 1.71:1 on Midnight Plum).
7. **44px targets.** `touch-target/min`. Components that are visually smaller (small button, chip) carry a 44px hit area.

## Colour

Palette and roles: see the preview (section 2) and [collections.md](../../02-Design-Variables/Figma-Variables/collections.md). Rich Burgundy (`palette/rose/700`, `color/brand/primary`) is the CTA and active-state colour. Luxury Rose (`palette/rose/500`, `color/brand/secondary`) marks recognisable brand moments; small text only on Pearl Pink or White. Blush Rose (`palette/rose/400`, `color/brand/accent`) is decorative on light surfaces. Pearl Pink, Rose Quartz and Midnight Plum are the foundation colours. Status colours (red, green, amber) each have a solid and a tint used for text on its tint. The only literals (not aliases) in Semantic are two colours with alpha, because a Figma alias cannot change alpha: `color/border/inverse-subtle` (Pearl Pink 20%) and `color/overlay/scrim` (Midnight Plum 50%).

## Typography

Heading family **Cormorant** (Display and H1 to H6), body family **DM Sans** (body, labels, navigation, buttons, forms, product titles, prices). Sizes, weights, line heights and letter spacing: [typography-styles.md](typography-styles.md). Canonical units are **px**; fluid web sizes are sampled per tier mode.

## Spacing and layout

A 4px scale (`space/0` to `space/24`). Layout tier values: gutter 16 / 24 / 40, grid gap 16 / 24 / 32, header 64 / 64 / 80, section spacing 48 / 64 / 96 (aliases of space/12, space/16, space/24), card padding 20 / 20 / 24. Containers: 1280, 1440, 896, 640. The web system has **no 12-column page grid** (a proposed 4/8/12 grid was not adopted), so none is invented; only the product grid (2, 3, 4 columns) is specified as Grid Styles.

## Elevation

Three Effect Styles, **Elevation/Small**, **Medium**, **Large**, matching the web shadow tokens (Midnight Plum at 6 to 12% alpha). Cards use none by default; drawers use Large.

## Imagery (provisional)

The **4:5** frame is the **provisional default product-card canvas**, not a universal image rule; hero, editorial (3:2), collection tiles (3:4) and banners (16:9) use their own ratios (see the web `01-Design-System/Documentation/foundations.md`). No real photography exists, so crop, focal point, packaging visibility and responsive fit are **awaiting validation with representative assets**. Placeholder frames in Figma must be labelled as placeholders and are not evidence of image quality.

## Iconography

One Icon component set (24px, stroke from `icon/stroke`, 1.5px) with one variant per icon: account, arrow-left, arrow-right, bag, check-circle, check, chevron-down, chevron-left, chevron-right, chevron-up, close, eye-off, eye, filter, heart, info, location, menu, minus, plus, search, sort, star, warning. Source: the 24 SVGs in the web system (`05-Assets/Icons`); importing them into Figma is a manual step.
