# Homepage First Fold, v8.0: campaign

**File:** `Homepage_Wireframe_Final.html`, section 03. v8.0 replaces v7.0 (`HERO-v7.0-DESIGN-NOTES.md`) and keeps the homepage-only compact bar and header.

## Direction
Large campaign photography is the main visual, as at Aesop, Rhode, Glossier and Summer Fridays. One full-width image (or muted loop video) runs up behind a transparent header, which turns solid once the page scrolls. The label, a display-size serif headline (two lines, one italic word), one sans-serif line, a filled "Shop the edit" button and the "Find your routine" text link sit bottom left in the photograph's calm area. A soft ivory fade keeps them readable on any image and stays when real media is added. A small featured-product card (packshot, name, size, price) sits bottom right and ties the model to the product. The fold stops 56 px short of the screen bottom so the next section peeks.

The wireframe holds no imagery, only one quiet labelled placeholder. The composition is set by the photography brief below, not by the placeholder.

## Photography brief
| Breakpoint | Ratio and size | Subject | Calm area for text |
|---|---|---|---|
| Desktop | 16:9, 2880 x 1620 | right half | left 40%, light and low detail |
| Tablet | 4:3, 2048 x 1536 | upper right | lower left |
| Phone | 2:3, 1080 x 1620 | top half | lower half |
| Video | 1920 x 1080, 8 to 15 s, muted | as desktop | poster = the desktop image (static fallback) |
| Packshot | 4:5, 800 x 1000 | product centred | plain warm ground |

Pearl, rose quartz and blush-rose tones with a deeper burgundy accent in styling or packaging; no beige or muddy nudes; natural skin texture; soft directional light.

## Measurements
- **1440 x 900:** bar 36 px; image 1440 x 808 under a 72 px transparent header; text 64 px above the image bottom, up to 544 px wide; product card 300 px at the right grid edge.
- **1920:** image capped at 860 px tall.
- **768:** a 614 px stage with the text inside, the product row below.
- **390:** a 540 px stage (64% of the screen) with the text inside, the product row below, the button at 615 px.

## Shopify settings
- **Images:** desktop and mobile `image_picker`, served through `<picture>` (WebP or AVIF via `image_url`, eager loading with `fetchpriority="high"`). The native focal point is applied as `object-position`.
- **Video:** desktop and mobile Shopify-hosted video (`video_tag`) with the image as poster. Pause button; no autoplay under reduced motion.
- **Content:** label, heading, text, primary and secondary button labels and links, featured product.
- **Layout and style:** text position (bottom left, centre left, bottom centre), fade strength, colour scheme, transparent header (checkbox), height (large or full), content bottom spacing.

## Checks
- **Self-test:** 10 of 10 in Chrome at 1920, 1440, 1024, 768, 390, 375 and 320 px, for image, video and full height.
- **First screen:** the main button is inside it at every size. The featured product is too, except at 320 x 568.
- **Header:** the transparent-to-solid change was verified with real wheel scrolling.
- **Not tested:** Safari, Firefox, real phones, screen readers, real media.
