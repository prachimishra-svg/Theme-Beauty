# Manual testing guide

What automated checks cannot cover. Each section says what to do, what correct looks like, and which automated check it complements. Record results in the table at the end.

Automated coverage today (all run from `02-Design-Variables/Tokens/`): `build-tokens.ps1`, `test-tokens.ps1` (tokens at 6 widths, touch targets, focus on surfaces, console, static checks, propagation) and `test-emulation.ps1` (390px phone with touch, reduced motion, forced colors, `:has()` fallback path). All of that is **Chrome/Chromium only**.

## 0. Serve the showcase

Real devices cannot open `file://` paths on your computer. From the project root:

```powershell
python -m http.server 8000      # then open http://<your-computer-ip>:8000/01-Design-System/index.html on the device
```

(The showcase links `../02-Design-Variables/Styles/variables.css`, so serve the project root, not the `01-Design-System` folder.) Also open `http://<ip>:8000/02-Design-Variables/Preview/index.html`.

## 1. Real phone (iOS Safari, Android Chrome)

- Layout: no sideways scrolling on any section; text is not zoomed or clipped; product grid is 2 columns.
- Inputs: tap each text input. **iOS must not zoom the page** (inputs are 16px).
- Touch: tap every button, chip, swatch, pagination link, quantity button and accordion row with a thumb. Each should be easy to hit without grazing a neighbour (44px targets; small buttons and chips rely on an invisible hit area, check that adjacent ones do not steal each other's taps).
- Rails and scroll: the thumbnail rail in the dashboard scrolls sideways and the page does not.
- Hover-only effects must not stick after a tap (product-card image zoom).
- Rotate to landscape and back.

## 2. Screen readers (NVDA with Firefox or Chrome, VoiceOver on Safari and iOS, TalkBack)

Walk each item with the reader on; the expected announcement is in the right column.

| Item | Expected |
|---|---|
| Heading structure (headings list) | One level-1 heading, no skipped levels |
| Breadcrumb | "Breadcrumb navigation"; last item announced as the current page. On a phone (below 600px) a 2-item list: parent and current page; on a tablet or desktop the full trail (decision 1) |
| Accordion | Each summary announced with expanded/collapsed state; Enter or Space toggles |
| Filter chips | Announced as toggle buttons with pressed/not pressed; removable chips say "Remove filter" |
| Pagination | "Pagination navigation"; "Page 1, current page"; Previous disabled |
| Form with errors (dashboard validation demo in the Design System) | Submitting empty moves focus to the first error; the summary and each field's message are read |
| Rating | "Rated 4 out of 5" (the stars are one image) |
| Icon buttons (wishlist, close) | Named ("Add to wishlist"); wishlist announces pressed state |
| Product card | The title link is the single link; the card is not read twice |
| Filter drawer (open it with Enter or Space) | Announced as a dialog named "Filters"; the page behind is not reachable or readable; the close button is named "Close filters"; the filter options are reachable as a group named "Skin concern"; closing returns focus to the Filters button |
| Load more (phones) | A link or button named "Load more products"; "Loading more products" is announced, then "Showing 8 of 16 products"; the failure message is read as an alert and the control then reads "Try again"; the numbered list is not present on phones |
| Chip row (choices) | Toggle buttons with pressed state; Tab reaches a chip that is cut off at the edge and brings it into view |

## 3. Safari and Firefox (desktop)

Open the showcase and the dashboard in each. Look specifically at: the selected checkbox and radio marks and chip check marks (CSS masks), `text-wrap: balance` on headings, the stepped type at several window widths (it changes at 600 and 1024px only), the accordion (`<details>`), `aspect-ratio` image frames, the product-card focus ring (Tab to a card title: the whole card should be ringed where `:has()` is supported, the link otherwise), and that the dashboard's Validation panel reports no failures.

## 4. Forced colors (real Windows high contrast)

Windows Settings → Accessibility → Contrast themes → choose "Night sky" then "Desert"; open the showcase in Edge or Chrome. The emulation test already checks the main cases; confirm by eye: focus ring visible on every control; checked boxes and radios show their mark; the selected swatch has a ring and the others do not; the current page in pagination is clearly different; selected chips differ; breadcrumb separators show; badges are outlined; the swatch colors themselves remain visible.

## 5. Keyboard walkthrough (no mouse)

Tab through the whole showcase (an automated walk with real Tab presses visited 103 stops at 1280px and 98 at 390px, every one with a visible ring, none trapped, none out of DOM order; a person still has to judge whether the order makes sense). The focus ring must be visible on every control and on each surface (light, tinted, dark footer area). Check: logical order; the skip link appears first and works; accordion rows toggle with Enter and Space; chips toggle with Space; swatches change with arrow keys; no keyboard trap; focus never hidden under the sticky header (the header is sticky: `scroll-padding-top` is set).

## 6. Zoom and text spacing

**Browser default font size** (all font sizes are now `px`, so none should follow the setting; this check confirms the hierarchy stays intact): in Chrome open Settings, Appearance, Font size, and set Very large, then Small; in Firefox set Settings, General, Fonts, Size. Open the showcase and check body, caption, headings and the lead paragraph. At the default, nothing should change. Record whether the hierarchy still reads correctly (headings above body, lead paragraph above body) and whether body text follows the setting (it does not, by design; see typography.md). Repeat in Safari, where the setting works differently.

At 200% and 400% browser zoom: no loss of content or function, no horizontal scroll apart from intentional rails and tables. Apply a text-spacing override (line height 1.5, paragraph spacing 2x, letter spacing 0.12em, word spacing 0.16em, for example with a bookmarklet or browser extension): nothing clipped or overlapping.

## 7. Phone behavior of decisions 1 to 5 (real phone, then a screen reader)

Behaviors 1 to 5 were verified in Chrome and Edge only, with real key, wheel, mouse and touch events for the drawer, Load more and chip row, and by geometry for the rest. A person has to confirm the feel and the assistive-technology behavior.

| Decision | Do this on a real phone (and in a window narrower than 600px) | Correct looks like |
|---|---|---|
| 1 Breadcrumb | Open the breadcrumb with the long product name | One line: parent, chevron, current page ending in an ellipsis; tapping the parent works without grazing the current page. Widen past 600px: the full trail returns and wraps. With VoiceOver or TalkBack, confirm hiding the earlier ancestors is acceptable |
| 2 Chip row | Swipe the choice chips sideways; Tab through them with a keyboard | The page does not scroll sideways; a chip is cut off at the edge so scrolling is discoverable; the focus ring is fully visible (not clipped top or bottom); focusing a hidden chip scrolls it into view; the row of applied filters wraps and shows every filter |
| 3 Accordion | Open all three rows | All stay open at once. Repeat in Safari and Firefox |
| 4 Phone pagination | Load more at 320 and 390px, then widen past 600px | A 44px-tall Load more with the status above it; the numbered list is absent below 600px and present from 600px; with VoiceOver or TalkBack the control is announced once; ctrl-click or long-press opens `?page=2` as a normal link |
| 5 Filter drawer | Open Filters on a real phone: scroll the page first, open, scroll inside, Tab (external keyboard), Escape, rotate, then use the Android back button or iOS swipe-back | Full-width sheet; the page behind does not move, **including on iOS Safari**; focus stays inside; Escape and the 44px close button close it; focus returns to the Filters button; rotating keeps the action visible; back does not strand a dimmed page. With VoiceOver, TalkBack and NVDA: announced as a dialog named "Filters", the page behind is not reachable |
| 4b Load more states | Use the demo: tap Load more, then "Simulate an error", tap again, then retry | Status is announced ("Loading more products", then "Showing 8 of 16 products"); focus lands on the first new item; the error is announced and the button reads "Try again" |
| 2b Chip row | Swipe the choice chips; Tab with an external keyboard | A chip is cut off at the edge; swiping scrolls the row only; a keyboard user never sits on a half-hidden chip |

## 8. When the Shopify theme exists

Closing the open risks needs this section and real photography: the requirement table for Load more (URL synchronization, reload, shared links, back and forward, scroll restoration, loading and error states, the Load previous question) and the asset list for the 4:5 canvas are in [foundations.md](foundations.md) section 14, "Open risks register". Record each result in the log below.

Load `variables.css` through `asset_url`; confirm fonts load from `assets/`; test merchant color-scheme overrides against the focus and contrast table; add `class="surface-inverse"` to the footer; test predictive search, filter drawer and cart drawer with a keyboard and a screen reader (focus trap, Escape, returning focus), check that `paginate` produces working numbered links and shareable `?page=` URLs (and, if "Load more" is built, that it degrades to the link and keeps Back working), and run `test-tokens.ps1` against the built CSS.

## Results log

| Date | Tester | Device / browser / reader | Section | Result | Notes |
|---|---|---|---|---|---|
| | | | | | |
