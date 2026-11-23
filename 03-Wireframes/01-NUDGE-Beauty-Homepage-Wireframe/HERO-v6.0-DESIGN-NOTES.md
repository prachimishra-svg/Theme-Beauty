# Homepage First Fold, v6.0: typographic editorial

> **Superseded by v7.0** (framed editorial). See `HERO-v7.0-DESIGN-NOTES.md`. The compact header and announcement-bar proportions described here are still in use.

**File:** `Homepage_Wireframe_Final.html`, section 03 plus homepage-only proportions for the announcement bar and header (CSS scoped to `body.fold-home`; their markup is unchanged). v6.0 replaces v5.0 (`HERO-v5.0-DESIGN-NOTES.md`), v4.0 and v3.0.

## What was removed
Every image-like element in the hero: the drawn model portrait, the drawn bottle packshot and their SVG definitions (v5.0), and the earlier still life (v4.0). No image was generated, downloaded or inserted. The featured-product insert went too, because it depended on a packshot.

## The composition
- **Oversized staggered headline.** Cormorant at 1.75 times the display token (capped at 21.5vw): 140 px at 1440, about 81 px at 390. One line per step, each indented one more grid column: "Radiance," / *gently* / "nudged."
- **One large media frame.** On desktop it runs from column 5 to the right edge for the full fold height. The headline's first and last lines cross its left edge into a hatched **type zone**, which photography must keep calm. Type and frame overlap instead of sitting side by side, so it reads as neither a split banner nor text on a photo.
- **Anchors.** The campaign label sits top left. The supporting line, the filled "Shop the edit" button and the "Find your routine" text link sit bottom left in columns 1 to 4, always on ivory.
- **Placeholders.** A flat warm field with hairline diagonals, crop marks, a small icon, "IMAGE PLACEHOLDER" or "VIDEO PLACEHOLDER", the ratio and pixel size for the current breakpoint, a focal-point marker and the type zone.

## First-fold proportions (homepage only)
| | Before | v6.0 |
|---|---|---|
| Desktop announcement bar | 56 px | 36 px |
| Desktop header | 85 px with a bottom rule | 72 px, no rule |
| Fold at 1440 x 900 | 759 px | 792 px |
| Mobile header (360 px and up) | two rows, about 116 px (full search field) | one row, about 56 px: menu and search icons, centred logo, account and cart |

Below 360 px the header keeps its original two-row layout, because five icons and the logo do not fit.

## Responsive
- **1920 / 1440 / 1024:** frame 7:6-ish (1165 x 972 at 1920, 923 x 792 at 1440, 661 x 660 at 1024); type zone width = 1.7 x headline size.
- **Tablet (768 to 1023 px):** headline over two lines ("Radiance, *gently*" / "nudged."), a 16:9 frame bleeding off the right edge with the last line crossing its top band, copy left and buttons right.
- **Phone (390 px):** label, three-line headline, a 5:4 frame bleeding off the right edge with "nudged." crossing its top band, copy, buttons. Short phones: 4:3 (up to 740 px tall) or 2:1 (up to 600 px) and no supporting line.

## Settings (Online Store 2.0 section)
Layout: editorial (default), overlay (the frame fills the fold, text bottom left on a soft fade) or separate (the frame from column 7, text in columns 1 to 5, no crossing). Media: image (separate desktop and mobile `image_picker`, native focal point applied as `object-position`) or Shopify-hosted video (`video_tag` muted, loop, playsinline, poster; pause button; no autoplay under reduced motion). Label, heading (`inline_richtext`, one italic word, line breaks set the steps), text, button and second link, colour scheme, and fade strength for overlay. Review buttons in the file: Hero: editorial / overlay / separate / video / content-safe guides; or `?layout=`, `?media=video`, `?guides=1`.

## Photography brief
- **Desktop:** 7:6 (2800 x 2400), subject in the right two thirds, left 24% calm.
- **Tablet:** 16:9 (2048 x 1152), calm top band.
- **Phone:** 5:4 (1350 x 1080), calm top band.
- **Video:** 1920 x 1080, 8 to 15 seconds, muted, under about 4 MB, cropped to fit.

## Final quality check
1. **Contemporary?** Yes. It is type-led, with an editorial stagger and the type overlapping the frame, unlike the stacked banner and split layouts before it.
2. **Luxury beauty?** Large Cormorant italic, ivory ground, one restrained button and generous whitespace.
3. **Media balanced?** The frame takes about 64% of the width at 1440 and the full fold height; on phones it is the largest element.
4. **Editorial hierarchy?** Label, then a 140 px headline, then body-large copy, then one button and one link.
5. **Engaging without photography?** The headline carries the fold on its own; the placeholder reads as a deliberate frame, not an empty box.
6. **Will it hold with real images?** Yes, as long as the type zone is respected. The copy and button never sit on the image, so only the headline's crossing needs a calm area.
7. **Mobile premium?** Yes. It has its own composition (headline first, frame bleeding right, last line crossing it), not a scaled desktop.

## Trade-offs
- The product no longer appears in the hero, which Plan 4.6 asks for early. Brief the campaign photograph to show the product, or bring back a product block once real packshots exist.
- At 1024 px the existing header search field wraps its placeholder text onto two lines. That predates v6.0 and is not specific to the homepage, so it was left alone.
- Separate misses the first screen by 1 px at 320 x 568.

## Checks
- Page self-test 10 of 10 in Chrome at 1920, 1440, 1024, 768, 390, 375 and 320 px for editorial (image and video), overlay and separate.
- With editorial, the main button is inside the first screen at all seven sizes.
- **Not tested:** Safari, Firefox, real phones, screen readers, real media.
