# 08-High-Fidelity-Design

High-fidelity page designs, one numbered folder per page, built **from** the wireframes, the Design System, the Design Variables and the Component Library. Those folders are only read; nothing in them was changed.

| Page | Folder | Open |
|---|---|---|
| 01 Homepage | `01-Homepage/` | `01-Homepage/Homepage-HiFi.html` (double-click; no build step) |

## How the Homepage is made
* `build-hifi.ps1` takes the **built** Homepage wireframe, so every section is the real component markup with the real tokens, fonts and icons, in the wireframe's exact order (20 sections), and writes `Homepage-HiFi.html`.
* `hifi.css` is the only styling added. It hides the wireframe scaffolding (review panel, annotation notes, captions), handles photographs and adds a gentle scroll reveal. It defines no colours, fonts or sizes of its own; everything uses the design variables.
* `hifi.js` fills the photo slots and the reveal. The wireframe's own scripts (header, tabs, finder, comparison slider, carousels, cart count) are untouched and keep working.
* Copy: the wireframe's merchant notes ("Ingredient name 1", "Merchant to provide...", "Item 1", "from the label") are replaced by design copy inside `build-hifi.ps1` (each replacement is checked, so a wireframe change cannot silently skip one).

## Photographs (the one thing still needed)
The project has no photography, only icons, fonts and logos, and this project's rule is that photographs are supplied by the brand and never drawn or generated. The page therefore has **54 photo slots** wired and ready:
1. Open `01-Homepage/images/SHOT-LIST.md` for the exact file name, ratio, size and brief of every slot.
2. Save the photographs in `01-Homepage/images/` with those file names (`.jpg`, `.webp`, `.png` or `.avif`; logos `.svg`).
3. Double-click `01-Homepage/update-images.cmd` (or run `build-hifi.ps1`) and reload the page.
A slot without a file shows a calm tonal brand surface with no caption. Add `?review=1` to the page address to see which file each empty slot expects.

## Copy that the merchant must confirm
Design copy is written to be believable, not verified: the "Cruelty-free" and "Clean" lines, the four ingredient names and descriptions (taken from the ingredient list already used in the PLP data), the "Free from" list, the routine step directions, and the sample customer quotes (labelled as sample on the page). Check each against real products and evidence before launch. Product metafields stay pending merchant confirmation.

## Check
The page was verified in headless Chrome: 20 of 20 wireframe sections present in order, no wireframe or merchant notes in the visible text, no horizontal overflow from 320 to 3840 px, sticky header, scroll reveal, and the photo-slot mechanism (tested with temporary images, then removed). It is **not** a finished photographic design until the 54 photographs are in place.