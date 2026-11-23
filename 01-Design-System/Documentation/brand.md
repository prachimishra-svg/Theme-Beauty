# NUDGE Beauty Theme: brand and logo

How the NUDGE identity is built and used. The logo files are in [`../../05-Assets/Logos/`](../../05-Assets/Logos/); open [`../../05-Assets/Logos/logo.html`](../../05-Assets/Logos/logo.html) to see every variant on light and dark backgrounds.

**NUDGE is a working name.** It has not been checked for trademark or Shopify Theme Store availability. The logo is original artwork drawn for this project (see "How it is built"); it has not been checked for similarity with existing marks either.

## Identity in one paragraph

The wordmark is five wide-spaced capitals in a geometric sans, drawn from straight strokes and circular arcs. One detail makes it recognisable: in the **N** the two stems are nudged in opposite directions, the left stem sits down on the baseline and the right stem rises to the cap line. The same N is the monogram and the favicon. Everything else stays plain on purpose, so the logo reads as modern, simple and premium and sits quietly beside product photography.

## Colours

The logo uses two colours that already exist in the design variables. No new brand colour was added and no token was renamed.

| Use | Colour | Token (primitive) | Contrast with its background |
|---|---|---|---|
| Logo on light surfaces | `#292126` Midnight Plum | `palette.charcoal` | 14.7:1 on Pearl Pink, 15.7:1 on White, 11.4:1 on Rose Quartz |
| Logo on dark surfaces (`.surface-inverse`) | `#FFF5F5` Pearl Pink | `palette.ivory` | 14.7:1 on Midnight Plum |
| Favicon tile | Midnight Plum tile, Pearl Pink N | same two | 14.7:1 |

Rich Burgundy (`#713448`, `palette.rose.700`) is the CTA colour and Luxury Rose (`#AD526D`, `palette.rose.500`) the recognisable brand rose; neither is used for the logo. Burgundy reaches 8.6:1 on Pearl Pink but only 1.7:1 on Midnight Plum, so a burgundy logo would not work on dark surfaces. Contrast figures were calculated from the hex values with the WCAG formula.

The palette was updated on 2026-11-11 to Luxury Rose + Rich Burgundy + Pearl + Plum (Pearl Pink, Rose Quartz, Blush Rose, Luxury Rose, Rich Burgundy, Midnight Plum). The logo files and PNG icons were re-coloured to the new Midnight Plum and Pearl Pink; the artwork is unchanged.

## Typography

The logo is drawn artwork (outlined shapes), not live text, so it needs no font and renders the same everywhere. The interface typefaces are unchanged: Cormorant for headings and DM Sans for body text (see [typography.md](typography.md)). The wordmark is not set in either font.

## Variants and files

| File | Use |
|---|---|
| `nudge-wordmark.svg` | Primary logo on light surfaces (Charcoal) |
| `nudge-wordmark-light.svg` | Primary logo on dark surfaces (Ivory) |
| `nudge-wordmark-currentcolor.svg` | Inline use; takes the text colour of its container, so it follows `.surface-inverse` automatically |
| `nudge-monogram.svg`, `-light.svg`, `-currentcolor.svg` | The N alone, for small or square spaces |
| `nudge-favicon.svg` | Browser tab icon (Charcoal rounded tile, Ivory N) |
| `nudge-favicon-32.png`, `nudge-icon-192.png`, `nudge-icon-512.png`, `nudge-apple-touch-icon.png` | PNG fallbacks and app icons (the Apple icon is a square tile because iOS rounds it) |

### Which variant where

| Context | Variant | Size |
|---|---|---|
| Desktop header | Wordmark | 22 to 28 px high |
| Mobile header | Wordmark | 16 to 20 px high (about 83 to 104 px wide) |
| Mobile drawer header, avatars, social profile, anywhere narrower than 80 px | Monogram | 24 px high or more |
| Browser tab | Favicon | 16 and 32 px; the SVG is preferred |
| Footer on a dark band | Light wordmark | 20 to 24 px high |

The mobile header uses the same wordmark as desktop, only smaller, so the brand looks the same on every device. The wordmark stays legible down to 16 px high; below that use the monogram.

## Clear space and minimum size

- **Clear space:** keep at least half the wordmark height free on every side. For a 24 px wordmark that is 12 px.
- **Minimum size:** wordmark 16 px high (about 83 px wide); monogram 16 px high; favicon 16 px square.
- Keep the aspect ratio (wordmark 5.2:1, monogram 0.82:1).

## Do and do not

- Do use Midnight Plum on Ivory, White or Blush, and Pearl Pink on Midnight Plum.
- Do use the `currentcolor` files when the background can change.
- Do not use Rich Burgundy, Luxury Rose, Blush Rose, gradients, outlines, shadows or other colours.
- Do not stretch, rotate, re-space or retype the wordmark, and do not redraw the N with level stems.
- Do not place the logo on busy photography; use a flat overlay or the light variant on a dark overlay.

## How it is built

All shapes use a cap height of 100 units and a stroke of 16 units. N, U, D and E are filled polygons and arcs; G is one 16-unit stroked arc plus a bar. The nudge is a vertical offset of 14 units between the N stems. Wordmark viewBox `0 0 520 100`, monogram `0 0 82 100`, favicon `0 0 64 64`. Letter gaps are 24 units.

## Using the logo in the theme (future Shopify work)

- Header and footer: inline the `currentcolor` SVG in the logo snippet, or load the SVG file with `asset_url`. Offer a merchant image setting that overrides it.
- Favicon: `<link rel="icon" href="nudge-favicon.svg" type="image/svg+xml">` plus the 32 px PNG and the Apple touch icon. Shopify's own favicon setting accepts a single image, so decide whether the theme or the store setting owns it.
- Accessible name: the SVG files carry `<title>NUDGE</title>`. When the logo is a link, the link text or `aria-label` should say what it does (for example "NUDGE home").

## Status

Checked: the SVGs render in headless Edge (Chromium) on Ivory and Charcoal, and the favicon is legible at 16 and 32 px. Not yet checked: trademark and Theme Store name availability, rendering in Safari and Firefox, and a designer's review. Add these to [manual-testing.md](manual-testing.md) when that review happens.
