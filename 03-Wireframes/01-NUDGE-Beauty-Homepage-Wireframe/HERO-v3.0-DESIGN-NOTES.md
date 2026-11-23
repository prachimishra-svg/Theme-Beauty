# Beauty Homepage Hero Banner, FINAL v3.0

> **Superseded by v4.0** (full-bleed campaign hero). See `HERO-v4.0-DESIGN-NOTES.md`. This file is kept as the record of the earlier design.

**File:** `Homepage_Wireframe_Final.html` (the single master; the duplicate `Beauty_Homepage_HeroBanner_FINAL_v3.0.html` and the pre-v3.0 backup have been removed). Only the Hero Banner (section 03) changed; every other section is byte-for-byte unchanged apart from the sprite and earlier approved edits.

## What was weak in the previous hero
A centred white card with a drop shadow laid over a plain rectangular image is the default Shopify starter layout. The headline was one size down from the display size, the second action was a second heavy outlined button, the image had no shape or framing, and nothing tied the hero to a product.

## Directions compared
| Direction | Verdict |
|---|---|
| A. Full-bleed campaign image with text on top | Rejected: text over busy photos is a Plan 4.6 mistake (Be Yours, Wag, Paw Prints) |
| B. Centred minimal text over a small image | Rejected: reads as generic, little product story |
| **C. Editorial split: text left, arch-topped image on a blush stage, small product inset** | **Chosen**: the arch echoes the How to Use step images, keeps text on a solid ivory ground, and the inset puts a product in the first screen (Plan 4.6 "no product in the first screens") |

## The design
- **Desktop (1024 px and up):** display-size Cormorant headline (token display size) with one italic word, balanced over two lines; overline with a hairline; one sentence; one filled button with an arrow icon plus a text link as the second action. Right: arch image (4:5) standing on a blush panel that runs to the screen edge, with a "Featured: Face Serum" link card overlapping its lower left. The arch width is capped by viewport height so it stays in the first screen on laptops.
- **Mobile and tablet (below 1024 px):** composed separately, not scaled. The message comes first so the headline and main button are inside the first phone screen (390 px: headline top at about y 190, button at about y 400), then the arch on its blush stage with the product link. Tablet is the same order, centred.
- **System:** only existing tokens (colours, Cormorant and DM Sans, display size, spacing, shadow) and Lucide arrow icons. No new colour, font or asset.
- **CRO and feedback rules kept:** one H1, one primary action, secondary "Find your routine" still links to the routine section, 44 px minimum targets, no timer, no pop-up, no text on the photo, no invented numbers.

## Checks
- Page self-test 10 of 10 at 1920, 1440, 1024, 768, 390, 375 and 320 px in Edge and Chrome (includes one H1, touch targets, clipping, overlap, typography families).
- Screenshots reviewed at 1440, 1280, 768, 390 and 360 px.
- **Limit:** the image is a labelled placeholder; real campaign photography is not in the project, so the final impression depends on the photo supplied. Real phones, Safari and Firefox were not tested.