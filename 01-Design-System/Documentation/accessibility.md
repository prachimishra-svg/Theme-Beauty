# Accessibility

Target: WCAG 2.2 AA. Status below distinguishes what was **measured by an executed automated check**, what was **inspected visually**, and what still needs **manual testing** (instructions in [manual-testing.md](manual-testing.md)). Automated checks run in Chromium only (Chrome, and Edge, which is the same engine).

## Measured contrast

Computed (WCAG relative luminance) from the canonical token values. The always-current version is the Validation panel of the Design Variables dashboard (34 pairs); rerun after any palette change.

| Combination | Ratio | Needs | Result |
|---|---|---|---|
| White on Rich Burgundy `#713448` | 9.18 | 4.5 | Pass |
| White on Rose 800 / 900 (hover / active) | 11.23 / 13.47 | 4.5 | Pass |
| Rich Burgundy on Pearl Pink / White / Rose Quartz | 8.58 / 9.18 / 6.70 | 4.5 | Pass |
| Midnight Plum on Pearl Pink / White / Rose Quartz | 14.65 / 15.67 / 11.44 | 4.5 | Pass |
| Neutral 600 (secondary) on Pearl / White / Rose Quartz | 7.65 / 8.18 / 5.97 | 4.5 | Pass |
| Neutral 500 (muted) on Pearl / White | 5.88 / 6.29 | 4.5 | Pass |
| Neutral 500 (muted) on Rose Quartz | 4.59 | 4.5 | Pass |
| Neutral 400 border on Pearl / White | 3.49 / 3.73 | 3 | Pass |
| Neutral 400 border on **Rose Quartz** | 2.72 | 3 | **Fail: controls must not sit bare on Rose Quartz** |
| Error / success / warning text on own tint | 5.79 / 5.55 / 5.28 | 4.5 | Pass |
| Pearl / Rose Quartz on Midnight Plum | 14.65 / 11.44 | 4.5 | Pass |
| Focus ring Rich Burgundy on Pearl / White / Rose Quartz / brand tint / strong tint | 8.58 / 9.18 / 6.70 / 7.92 / 6.53 | 3 | Pass |
| Focus ring Rich Burgundy on error / success / warning tint | 8.03 / 8.10 / 8.18 | 3 | Pass |
| Focus ring Rose Quartz on Midnight Plum | 11.44 | 3 | Pass |
| Focus ring / links in **Rich Burgundy on Midnight Plum** | 1.71 | 3 / 4.5 | **Fail, not permitted: use the Rose Quartz ring and links on dark surfaces (`.surface-inverse` does this)** |
| Focus ring **Rich Burgundy on a Rich Burgundy fill** | 1.00 | 3 | **Fail, not permitted: use the Rose Quartz (inverse) ring on brand fills (6.70:1)** |
| **Rose Quartz as the default ring** on Pearl / White | 1.28 / 1.37 | 3 | **Fail: Rose Quartz is only the ring on dark surfaces** |
| Luxury Rose `#AD526D` on Pearl / White / Rose Quartz | 4.67 / 4.99 / 3.65 | 4.5 / 3 large | Pass on Pearl and White; **large text and marks only on Rose Quartz**. White on Luxury Rose 4.99 (badges) |
| Blush Rose `#D99BAA` on Pearl / White / Rose Quartz | 2.13 / 2.28 / 1.66 | none | **Decorative only on light surfaces** (rules, dividers, swatches); 6.88:1 on Midnight Plum |
| Midnight Plum on Blush Rose | 6.88 | 4.5 | Pass (text may sit on Blush Rose; white may not) |

Not covered: disabled text and controls (exempt from WCAG contrast, but kept legible and given non-color cues), and merchant swatch colors (the selection ring, not the swatch, carries the 3:1 requirement: Midnight Plum ring on Pearl 14.7:1).

## Requirements built into the system

- Color is never the only signal: errors (icon + text + thick border), selection (ring + displayed name), disabled (strike-through or dashed), pressed (`aria-pressed` + filled icon), links (underlined in text).
- Visible focus on every interactive element: a 2px solid outline with a 2px offset (a shape, not a color change), at least 3:1 on every supported surface. Rich Burgundy on light and tinted surfaces, Rose Quartz on dark ones (see [foundations.md](foundations.md), section 9).
- Touch targets 44 × 44px (`--touch-target-min`) as the default, as a box or as an invisible hit area. The small button and chip keep a 40px visual with a 44px hit area; standalone links use `.link--standalone`. Exceptions (inline links, disabled controls, skip link, decorative mini swatches) are in [foundations.md](foundations.md), section 8.
- Form inputs 16px; labels always visible; errors linked with `aria-describedby`.
- Native elements first (`button`, `a`, `input`, `select`, `fieldset/legend`, `details`).
- Icons decorative by default (`aria-hidden`); icon buttons carry `aria-label`.
- `prefers-reduced-motion` collapses transitions and animations.
- Forced colors: system-color rules redraw anything that relied on a background or color for meaning.
- Skip link, landmarks (`header`, `nav`, `main`, `footer`), one `h1`, logical heading order in the showcase.
- Text resizes with browser zoom (both `px` and `rem` sizes scale); layout reflows without horizontal scroll down to 320px. **Limit:** every font size is `px`, so none follows a changed browser default font size (zoom still works). Since the 2026-11-11 audit there are no `rem` sizes left, so a changed default no longer inverts the hierarchy (AUDIT-REPORT.md Part 10).

## Checklist

Legend: ✅ verified by an executed automated check · 👁 inspected visually · ⚠️ built in, not verified · ⬜ needs manual testing.

### Verified by automated checks (Chromium)
- ✅ **No horizontal overflow** on the showcase and the dashboard at 320, 390, 768, 1280 and 1920px (`test-tokens.ps1`, structural scan).
- ✅ **Touch targets:** 94 interactive elements at 390px and 99 at 1280px measure at least 44 × 44px (box or `::after` hit area; elements hidden at a width, such as the numbered pagination on phones, are not counted there), and again under touch emulation. Reintroducing the earlier 42px hit-area bug makes the check fail (11 elements).
- ✅ **Focus ring on surfaces:** with real `focus()` on a button per surface, the rendered ring is 2px solid, offset 2px, 6.53:1 to 11.44:1 on all 9 supported surfaces (recomputed for the Luxury Rose and Rich Burgundy palette); the one unsupported combination (Rich Burgundy fill, default ring, 1.00:1) is documented and has a passing alternative (6.70:1). Removing the global focus rule makes the check fail.
- ✅ **Emulated phone and touch:** a true 390 × 844 viewport at device pixel ratio 3 with `pointer: coarse` and `hover: none`: no overflow, all targets still 44px, hover-only image zoom does not apply.
- ✅ **Emulated forced colors:** found and fixed real defects (checked checkbox and radio marks vanished, every swatch showed a ring, the current pagination page and selected chip looked the same, breadcrumb separators vanished). The separator probe now checks a separator that is actually rendered at 390px (the last item's; the first one belongs to a hidden item on phones) and fails if the forced-colors fix is deleted. Now the focus ring, check marks, radio dots, swatch ring, current page, selected chip and separators are distinguishable. Two probes passed falsely at first and were tightened; deleting the fix makes 6 checks fail.
- ✅ **Emulated reduced motion:** transitions collapse to ~0.
- ✅ **`:has()` progressive enhancement (CSS path):** with the `:has()` branch disabled the product-card title link still shows a 2px focus ring and a selected chip still shows its check mark; with it enabled the whole card is ringed. The earlier fallback was wrong (an `@supports not selector()` block is ignored by exactly the browsers that need it); it is now the default with `:has()` as the enhancement.
- ✅ **Drawer (decision 5), real key, wheel and mouse events over the DevTools protocol:** at 390px (phone sheet) and 1280px (panel). Enter opens a modal dialog; focus moves onto the close button; the accessibility tree exposes a dialog named "Filters"; Tab through all 22 controls stays inside and returns to the first; Shift+Tab and Tab wrap at the ends; focusing the page behind is refused; the page does not scroll behind (scrollY unchanged) while the body scrolls on its own; the 44px close button and the primary action stay on screen while scrolled; every focused control shows a 2px solid ring; Escape, the close button, the action and (panel) a scrim click each close it and return focus to the opener; the scroll lock is released with the page position unchanged. Sabotage: removing the Tab wrap or the scroll lock made 10 drawer checks fail across the two viewports. Chrome restores focus natively, so the explicit restore in `drawer.js` is a safeguard that this test cannot distinguish.
- ✅ **Load more (decision 4), real taps at 390px with a demo loader:** the button is a real link 48px high; the loading state sets `aria-busy` on the list and `aria-disabled` on the button while focus stays on it; success announces "Showing 8 of 16 products" and moves focus to the first new item; failure shows an alert, appends nothing, keeps the URL and offers "Try again"; the last page removes the button and says "All 16 products shown". Numbered pagination shows from 600px and Load more is hidden there.
- ✅ **Chip row (decision 2), real Tab and touch swipe at 390px:** a chip is cut off at the edge; Tab to a clipped chip scrolls it fully into view (needs `chip-row.js`: browsers scroll only completely hidden controls); a swipe scrolls the row and not the page. **Harness note:** in this headless build touch swipes stop scrolling once real key events have been sent to the same page load, so the test does the swipe first.
- ✅ **Structural scan (`test-tokens.ps1`, section 7):** required files, local references, Markdown links, generated-output completeness and freshness, and page structure at 320, 390 and 1280px (ids, ARIA and anchor references, icon references, names, labels, headings, `lang`, title, dialogs, Load more markup, badge and wishlist overlap, overflow). Five deliberate breakages on a throwaway copy were each caught.- ✅ **Structural scan** of both pages at 320 to 1920px: no duplicate ids, no broken `aria-*` references, no unlabeled form controls, no unnamed buttons or links, no skipped heading levels, one `h1`, `lang` and `<title>` present, scrollable regions keyboard-focusable.
- ✅ **Console output:** the showcase and the dashboard opened directly from disk log nothing (an earlier showcase logged CORS errors from font preload tags).
- ✅ **Static integrity:** no double-encoded characters in any text file, balanced CSS braces, valid JSON (reintroducing an encoding error makes the check fail).
- ✅ Both font families load; all icon references resolve; the product grid is 2 / 3 / 4 columns at the three tiers.

### Inspected visually
- 👁 The focus-on-surfaces panel (ring visible on every light and tinted surface and on the dark one; invisible by design on the Rich Burgundy fill with the default ring), the drawer, packaging and thumbnail specimens, the new components, and the dark-surface demo, at desktop width. The phone layout is verified by geometry in emulation, not by looking at every section.

### Built in, not verified
- ⚠️ Focus ring on each *component* by a person tabbing (the ring is measured per surface; component overrides are in the CSS).
- ⚠️ Keyboard operation of demo behaviors (quantity, password toggle, wishlist, validation): native elements, not tested with a keyboard.
- ⚠️ The `:has()` fallback in a browser that really lacks `:has()` (the CSS path is tested; no such browser is available).
- ⚠️ Accordion, breadcrumb, pagination and chip keyboard and screen-reader behavior (native elements).
- ⚠️ Phone breadcrumb: ancestors above the parent are `display: none` below 600px, so they are absent from the accessibility tree there. Geometry is tested, the announcement is not.
- ⚠️ Scrolling chip row (`.chip-row`): the ring and the 44px hit area are not clipped (4px and 2px of room measured), and chips are real buttons that scroll into view on focus; no person has tabbed or swiped it.
- ⚠️ Drawer: behavior is tested in Chromium with real events (below); not tested in iOS Safari (its scroll lock differs), Firefox, the Android back button, or any screen reader.

### Needs manual testing (see [manual-testing.md](manual-testing.md))
- ⬜ Screen readers (NVDA, VoiceOver, TalkBack): labels, error announcements, `role="alert"` summary, rating `role="img"`, accordion and pagination state.
- ⬜ A real phone and tablet (tap accuracy, iOS input zoom, hover stickiness).
- ⬜ Safari and Firefox (`:has()`, masks, `text-wrap: balance`, `<details>`). Only Chromium is available here; Edge is the same engine.
- ⬜ A real Windows contrast theme (the emulation covers the main cases).
- ⬜ 200% and 400% zoom and text-spacing overrides.
- ⬜ Behavior inside a real Shopify theme.
- ⬜ Automated axe or Lighthouse audit (no Node or those tools are installed here).

### Per-component review (use when adding or changing a component)
- [ ] Native element or correct role
- [ ] Accessible name (visible label, `aria-label`, or hidden text)
- [ ] Keyboard: reachable, operable, logical order, no traps
- [ ] Focus visible on every supported surface; not clipped by `overflow: hidden`
- [ ] States not color-only, and still distinguishable in forced colors
- [ ] Text at least 4.5:1, UI boundaries at least 3:1 on each background
- [ ] 44 × 44px target (box or hit area)
- [ ] Works at 320px, no horizontal scroll, wraps long words
- [ ] Respects reduced motion
