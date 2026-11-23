# Figma file and page structure (proposal)

One Figma **design file** named, for example, `NUDGE Design System (Figma-native)`. **Create it as a new file.** Never reorganise or overwrite an existing Figma file without explicit approval. Pages are only listed where they have a purpose; there are no empty placeholder pages.

| Page | What belongs here | How designers use it |
|---|---|---|
| `00 Cover & Documentation` | Cover frame; status legend (stable, provisional, awaiting assets); how to use the file; the collection and mode guide (a one-screen version of [collections.md](../../02-Design-Variables/Figma-Variables/collections.md)); change log; links to the web system and the Figma specification | Read first. Check the legend before using Load more or the 4:5 image canvas, both provisional |
| `01 Foundations` | Colour (primitive and semantic swatches, shown in Default and Inverse), typography specimens (the 21 styles at Mobile, Tablet and Desktop), spacing, radius and stroke, elevation, layout grids per tier, the icon set, imagery ratios | Reference and review. Specimens are built from variables and styles, so they change when the variables change |
| `02 Variables & Styles` | Documentation frames for the variable architecture (alias chains from semantic to primitive), the Text Style, Effect Style and Grid Style galleries, and a **mode demo**: the same component frame in Default and Inverse | Learn which mechanism holds what; verify a mode switch before using it |
| `03 Components` | One section per component (Button, Icon Button, Input Field, Choice, Chip, Swatch, Badge, Message, Quantity Selector, Rating, Accordion Item, Breadcrumb, Pagination, Drawer, Product Card, Icons): the component set, an annotation frame (properties, bindings, accessibility, handoff) and a state matrix | Source of every instance. Edit components here only; never detach |
| `04 Patterns` | The four patterns in [components.md](components.md): Filter row, Product grid, Filter drawer, Product detail information, each assembled from instances | Copy a pattern, not a page. These are patterns, not page designs |
| `05 Responsive Intent` | For each component and pattern that changes by tier, the Mobile, Tablet and Desktop versions side by side with the mode set on each frame (for example Breadcrumb Compact vs Full, Pagination Load more vs Numbered, Drawer Sheet vs Panel, Chip row scrolling vs wrapping) | Check that a change of mode produces the intended result. **Not wireframes and not page layouts**: page and storefront design are a later phase |

## Conventions

- Page names: two-digit prefix and a plain title; sections inside a page are named after the component or topic.
- **Status badge** on every section header: Stable, Provisional or Awaiting assets.
- Keep one frame per tier at the reference widths (360, 768, 1280) and set both the **Layout** and **Typography** modes on the frame.
- Publish the file as a library only when you decide to adopt this system. Variables in Primitives are hidden from publishing; everything else is published.

## What is not created

A `Pages` or `Wireframes` page, storefront screens, Shopify theme screens and an archive page. They are outside this phase.
