# Homepage Hero Banner, v4.0: full-bleed campaign

> **Superseded by v5.0** (asymmetric editorial first fold). See `HERO-v5.0-DESIGN-NOTES.md`. This file is kept for its research record (Theme Store review figures).

**File:** `Homepage_Wireframe_Final.html`, section 03 (the only homepage wireframe). v4.0 replaces the v3.0 editorial split described in `HERO-v3.0-DESIGN-NOTES.md`. Every other section is unchanged.

## What changed and why
v3.0 put the text on the left and an arch-cropped image on a blush panel on the right. It was tidy, but it read like a standard store banner: the image was small and framed, so it never felt like a campaign. v4.0 lets one art-directed photograph (or a muted loop video) fill the first screen and sets the text into the part of the photograph that is briefed to stay empty.

## Directions compared (all four are built into the file)
| Direction | How to see it | Verdict |
|---|---|---|
| Full-width campaign image | default | **Chosen.** Largest image and the strongest brand moment, and the fastest to load |
| Cinematic video | `?media=video` or the Hero: video button | Kept as a setting: same layout, the still is the poster, has a pause control, no autoplay under reduced motion |
| Image with text overlay | default | **Chosen** (same as above). Text sits on the calm side of the image over an ivory fade, never on the subject |
| Separate image and text (editorial split) | `?hero=split` or the Hero: split layout button | Kept as a setting: calm, but at 1440 px it reads like an ordinary split banner, and on short phones the button falls below the first screen |

## Research inputs
- **Shopify Theme Store (read 11 Nov 2026):** Prestige ($400) is 91% positive across 875 reviews and is marketed for "the ultimate luxury high-end aesthetic". Impulse ($500) is 94% positive across 1,305 reviews; its "Spotlight with shoppable hero" feature is the basis for the product link. Horizon (free) is 36% positive across 213 reviews; the negative reviews read were about price and sale display. None of the reviews read discuss the hero specifically. They were used only as evidence of what merchants value: a premium look, responsive behaviour and support.
- **Storefronts:** Byredo shows one campaign image with an eyebrow, a headline and a single "Discover" button. Glossier shows one image, one "Shop now" button, and separate desktop, tablet and mobile image files. Augustinus Bader leads with a product claim and one shop button. Aesop and Crème de la Mer blocked automated reading, so they were not analysed.
- **Trend sources:** an analysis of 312 beauty homepages (July 2026) groups heroes into people-led, product-led and mixed, without ranking which converts better. Trend articles point to quiet, minimal luxury and editorial serif display type. These are agency blogs, so they were treated as direction only.

## The design
- **Desktop (1024 px and up):** media fills the screen below the header (560 to 940 px high), 16:9 crop with the subject in the right 45%. Eyebrow with a hairline, a display-size Cormorant headline with one italic word, one sentence, a filled "Shop the edit" button with an arrow, and the "Find your routine" text link. The product link (thumbnail, name, price) sits bottom right.
- **Tablet (768 to 1023 px):** the same landscape crop at 16:10, with the text kept to the left half.
- **Mobile (below 768 px):** a separate 2:3 crop with the subject in the top half; the message sits in the lower third on an ivory fade, and the product link is top right. On short phones (screen height up to 740 px) the supporting sentence drops so the headline and button stay in the first screen.
- **System:** only existing tokens (ivory, blush, rose 50, 100 and 700, charcoal, the display size, the overline, Cormorant and DM Sans). No new colour, font or asset. Sharp corners, no card shadows, no decorative gradients on the interface.

## Shopify section (Online Store 2.0)
Settings: layout (overlay or split), media type (image or video), desktop and mobile images (`image_picker`), a Shopify-hosted video (`video` setting, rendered with `video_tag`: muted, loop, playsinline, poster), eyebrow, heading (`inline_richtext` for the italic word), text, button and second-link labels and URLs, a featured product, desktop text position, colour scheme, overlay strength (range 0 to 100), and height (fill screen or adapt to image). The focal point comes from Shopify's native image focal point (`image.presentation.focal_point`), applied as `object-position`. No external libraries. The first image loads eagerly with `fetchpriority="high"`.

## Photography brief
One set-up shot twice: 16:9 at 2880 x 1620 with a calm left 50%, and 2:3 at 1080 x 1620 with a calm lower 40%. Soft directional light. Optional 8 to 15 second muted loop of the same set-up, under about 4 MB. Keep the same light and colour grade as the rest of the page.

## Checks
- Page self-test 10 of 10 at 1920, 1440, 1024, 768, 390, 375 and 320 px in Chrome, for all four combinations of layout and media.
- With the overlay layout the main button is inside the first screen at 1920 x 1080, 1440 x 900, 1024 x 768, 768 x 1024, 390 x 844, 375 x 667 and 320 x 568.
- **Limits:** the still life is a drawn SVG stand-in in design-system colours, not photography, so the final look depends on the photography supplied. Safari, Firefox, real phones and screen readers were not tested.
