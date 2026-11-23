# Homepage First Fold, v5.0: asymmetric editorial

> **Superseded by v6.0** (typographic editorial, no imagery). See `HERO-v6.0-DESIGN-NOTES.md`. The drawn portrait and packshot described here were removed. This file is kept for its storefront research.

**File:** `Homepage_Wireframe_Final.html`, sections 01 to 03 seen as one viewport. Only section 03's markup changed. On the homepage the header loses its bottom rule and, from 1024 px, is transparent until the page scrolls (scoped CSS only, through the `fold-home` class on `body`). v5.0 replaces v4.0 (`HERO-v4.0-DESIGN-NOTES.md`) and v3.0.

## Research (live storefronts, read 11 Nov 2026)
| Store | First hero, as read from the page text |
|---|---|
| Tatcha | One image (a desktop-labelled file), "Gift a Ritual of Care", one sentence, one button "Explore Gifts" |
| Dr. Barbara Sturm | Eyebrow "NEW ARRIVAL", headline "SKI CREAM", one line, "SHOP NOW"; two image files, one likely the mobile version |
| Rare Beauty | Eyebrow "NEW \| LIMITED TIME", one sentence, "SHOP NOW"; a mobile 4:5 file |
| Fenty Beauty | One promotional tile, "SHOP NOW"; an "M_" mobile file |
| Rhode | Product-led (Glazing Milk), line "Edited, efficacious, intentional", a swipe slider |
| Augustinus Bader | Product-led: The Overnight Restorative Cream at $365 with "Quick Shop", in a rotating carousel |
| Charlotte Tilbury | Blocked automated reading; not analysed |

**Patterns:** one message, an eyebrow, a short headline and one "Shop now" style button; separate mobile crops; luxury stores split between campaign-led and product-led heroes. Prestige offers the transparent header as a first-section setting (community-reported). Theme Store review figures are in `HERO-v4.0-DESIGN-NOTES.md`. **Limit:** layouts were read from page text, not screenshots, so full bleed versus split could not always be seen.

## Three structures (all built into the file: Hero A, Hero B and Hero C buttons, or `?dir=a`, `?dir=c`)
| | A. Editorial campaign | **B. Asymmetric editorial** | C. Lifestyle + product stage |
|---|---|---|---|
| Structure | Full-bleed landscape image under a transparent header; text bottom left on an ivory fade | Portrait from column 8 to the right edge, under the header; display headline on ivory in columns 1 to 6; packshot insert straddling the portrait's edge | 3:2 split: campaign image with the headline on it, packshot centred on a tinted stage |
| Text legibility with any photo | Depends on each photo | **Always on solid ivory** | Depends on each photo |
| Model stays whole | Text crosses the shoulders on phones | **Yes** | Headline meets the hair on desktop; crosses the face on phones |
| Shopping signal | Small product link | **Product, size, price and Shop now in the first screen** | Strongest |
| Header and hero as one viewport | Yes | **Yes: the logo stays on ivory, utilities sit on the portrait's top fade, everything shares one left edge** | Yes |
| Phones | Image with text over its lower part | **Portrait, product row, then text: everything up to the main button in the first screen down to 320 x 568** | Product band drops under the image |
| Verdict | Setting | **Chosen** | Setting |

**Why B:** it is the only structure where the typography and the photograph each get their own space and still read as one composition. The headline never fights the model, so the merchant can change campaign photos without breaking the layout. The packshot insert adds the product-led signal (Rhode, Augustinus Bader) without a product grid. A is the most common pattern but is closest to the retired v4.0, and C reads as a standard split banner.

## B, measured at 1440 x 900
Announcement bar 56 px; header 84 px, transparent, over the fold; fold 844 px. Portrait 599 x 844 (about 5:7) from column 8 (x 841) to the right edge. Text column x 80 to 656: eyebrow, 80 px Cormorant headline over two lines with one italic word, one line of body-large text, a 48 px button and a text link. Packshot insert 216 px wide (4:5 image, eyebrow, name, size and price, Shop now), positioned 60% on ivory and 40% on the portrait, 48 px from the bottom. At 1920 the same grid gives a 839 x 1024 portrait. At 1024 the insert shrinks to 180 px.

## Responsive
- **Tablet (768 to 1023 px):** header solid ivory without the rule; portrait 16:9 with a left gutter, bleeding off the right edge; product row overlapping its lower right; headline on one line.
- **Phone (390 px):** portrait 9:8 bleeding off the right edge; product row overlapping its lower edge; eyebrow, two-line headline, one line of text, the buttons. Short phones use a 16:10 or 2:1 crop and drop the supporting line.

## Shopify (Online Store 2.0)
Section settings: layout (B, A or C), transparent header (read by the header section; solid after scrolling), desktop and mobile campaign images with the native focal point (`image.presentation.focal_point` applied as `object-position`), media type and a Shopify-hosted video (`video_tag`: muted, loop, playsinline, poster; pause button; no autoplay under reduced motion), eyebrow, heading (`inline_richtext`), text, button and second link, a featured product (image, title, first variant option, price), colour scheme, and fade strength for A and C. No external libraries; the first image loads eagerly with `fetchpriority="high"`.

## Photography brief
A portrait at 5:7 (1600 x 2240) with the face in the upper middle and about 12% of headroom for the header; a 9:8 phone crop with the face centred; a 4:5 packshot on a plain blush or ivory ground; an optional 8 to 15 second muted loop under about 4 MB.

## Checks
Page self-test 10 of 10 in Chrome at 1920, 1440, 1024, 768, 390, 375 and 320 px for B (image and video), A and C. With B the main button is inside the first screen at all seven tested screen sizes. **Limits:** the portrait and the packshot are drawn stand-ins, not photography. Safari, Firefox, real phones and screen readers were not tested.
