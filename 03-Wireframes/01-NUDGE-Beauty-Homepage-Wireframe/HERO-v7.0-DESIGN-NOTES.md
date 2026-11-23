# Homepage First Fold, v7.0: framed editorial

> **Superseded by v8.0** (campaign). See `HERO-v8.0-DESIGN-NOTES.md`.

**File:** `Homepage_Wireframe_Final.html`, section 03. v7.0 replaces v6.0 (`HERO-v6.0-DESIGN-NOTES.md`). It keeps v6.0's homepage-only compact bar and header.

## Why v6.0 was replaced
The 140 px staggered headline crossed into the media frame and fought it. The placeholder's diagonals, hatched type zone, crop marks and focal labels made the first screen look like a technical drawing rather than a storefront.

## The composition
- **Desktop (1024 px and up):** one 12-column composition inside the content grid.
  - **Text:** columns 1 to 5, vertically centred: label, display-token headline over two balanced lines with one italic word, one line of body-large text, the "Shop the edit" button and the "Find your routine" link.
  - **Frame:** one campaign frame (image or muted loop video) in columns 6 to 12 for the full fold height (560 to 880 px).
  - **Spacing:** nothing overlaps.
- **Tablet (768 to 1023 px):** a 16:10 frame edge to edge, then the text.
- **Phone:** a 1:1 frame edge to edge, then the text; short phones use 4:3 or 2:1 and drop the supporting line.
- **Placeholder:** one flat field with a single small label (Campaign image, ratio and size). The focal-point marker shows only with the "Hero: focal point guide" button.

## Settings
- **Layout:** editorial (default), mirrored (frame left), or overlay (frame edge to edge, text bottom left on a soft fade).
- **Media:**
  - Image: separate desktop and mobile images, with the native focal point applied as `object-position`.
  - Video: Shopify-hosted, muted loop, pause button, no autoplay under reduced motion.
- **Content:** label, heading (one italic word), text, button and second link, colour scheme.

## Checks
- **Self-test:** 10 of 10 in Chrome at 1920, 1440, 1024, 768, 390, 375 and 320 px for editorial (image and video), mirrored and overlay.
- **First screen:** the main button is inside it in every case.
- **Not tested:** Safari, Firefox, real phones, screen readers, real media.
