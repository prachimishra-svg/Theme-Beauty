# Accessibility (Figma)

What can and cannot be checked in Figma, and the contrast results computed from the Figma specification's own values. Contrast is the only automated check here; the rest is design practice and handoff. **No screen reader, assistive technology, Figma plugin or real device was used.**

## Contrast, computed from the specification

WCAG relative luminance, from the resolved values in `variable-map.json` for the stated mode. Text needs 4.5:1, large text and interface boundaries 3:1. These values are identical to the web system's measured values, because the validator proves the Figma colours equal the web colours.

| Pair | Mode | Colours | Ratio | Needs | Result | Use |
|---|---|---|---|---|---|---|
| `color/text/primary` on `color/bg/page` | Default | #292126 on #FFF5F5 | 14.65:1 | 4.5:1 | Pass | Body text on the page |
| `color/text/secondary` on `color/bg/page` | Default | #5A4B53 on #FFF5F5 | 7.65:1 | 4.5:1 | Pass | Secondary text |
| `color/text/muted` on `color/bg/page` | Default | #6B5C64 on #FFF5F5 | 5.88:1 | 4.5:1 | Pass | Muted text |
| `color/text/muted` on `color/bg/subtle` | Default | #6B5C64 on #F2D5DC | 4.59:1 | 4.5:1 | Pass | Muted text on Rose Quartz |
| `color/text/on-brand` on `color/brand/primary` | Default | #FFFFFF on #713448 | 9.18:1 | 4.5:1 | Pass | Primary button label |
| `color/brand/primary` on `color/bg/page` | Default | #713448 on #FFF5F5 | 8.58:1 | 4.5:1 | Pass | Links, active states |
| `color/button/disabled-text` on `color/button/disabled-bg` | Default | #5A4B53 on #F2D5DC | 5.97:1 | 4.5:1 | Pass | Disabled label (exempt, but legible) |
| `color/border/strong` on `color/bg/page` | Default | #908088 on #FFF5F5 | 3.49:1 | 3:1 | Pass | Control border |
| `color/border/strong` on `color/bg/subtle` | Default | #908088 on #F2D5DC | 2.72:1 | 3:1 | **Fail** | **Not permitted**: never place a bare control on Rose Quartz |
| `color/focus/ring` on `color/bg/page` | Default | #713448 on #FFF5F5 | 8.58:1 | 3:1 | Pass | Focus ring |
| `color/focus/ring` on `color/bg/surface` | Default | #713448 on #FFFFFF | 9.18:1 | 3:1 | Pass | Focus ring on White |
| `color/focus/ring` on `color/bg/subtle` | Default | #713448 on #F2D5DC | 6.70:1 | 3:1 | Pass | Focus ring on Rose Quartz |
| `color/brand/secondary` on `color/bg/page` | Default | #AD526D on #FFF5F5 | 4.67:1 | 4.5:1 | Pass | Luxury Rose eyebrows and ratings; on Rose Quartz (3.65:1) large text and marks only |
| `color/brand/accent` on `color/bg/page` | Default | #D99BAA on #FFF5F5 | 2.13:1 | none | Decorative | **Not permitted** for text on light surfaces; rules, dividers and swatches only |
| `color/text/primary` on `color/bg/page` | Inverse | #FFF5F5 on #292126 | 14.65:1 | 4.5:1 | Pass | Primary text on the inverse surface |
| `color/text/secondary` on `color/bg/page` | Inverse | #F2D5DC on #292126 | 11.44:1 | 4.5:1 | Pass | Secondary text, inverse |
| `color/text/muted` on `color/bg/page` | Inverse | #BFB1B7 on #292126 | 7.60:1 | 4.5:1 | Pass | Muted text, inverse |
| `color/link/default` on `color/bg/page` | Inverse | #F2D5DC on #292126 | 11.44:1 | 4.5:1 | Pass | Links, inverse |
| `color/focus/ring` on `color/bg/page` | Inverse | #F2D5DC on #292126 | 11.44:1 | 3:1 | Pass | Focus ring, inverse (the Default ring is 1.71:1 on Midnight Plum and would fail) |
| `color/border/strong` on `color/bg/page` | Inverse | #BFB1B7 on #292126 | 7.60:1 | 3:1 | Pass | Control border, inverse |
| `color/status/error` on `color/status/error-bg` | Default | #A93226 on #FDECEA | 5.79:1 | 4.5:1 | Pass | Error text |
| `color/status/success` on `color/status/success-bg` | Default | #2F6B4F on #E9F3EE | 5.55:1 | 4.5:1 | Pass | Success text |
| `color/status/warning` on `color/status/warning-bg` | Default | #8A5A00 on #FBF1DC | 5.28:1 | 4.5:1 | Pass | Warning text |

The failing row and the decorative row are the **documented "not permitted" uses** inherited from the web system. The variables exist; the rule is that designers must not use those combinations. Figma cannot enforce it.

## Practice in Figma

- **Targets:** every interactive component is 44 x 44px or has a 44px hit area (`touch-target/min`). Components smaller than 44px (small button 40px, chip 40px, mini swatch) must include a transparent 44px frame behind them.
- **Focus:** every interactive component has a **Focus** state with the 2px ring and 2px offset bound to `focus/ring-width`, `focus/ring-offset` and `color/focus/ring`. In the Inverse mode the ring re-resolves to the lighter colour.
- **State is never colour alone:** errors use a thicker border plus an icon plus text; selection uses a tint plus a check mark plus a border; the current page uses a fill plus bold text.
- **Text:** body and input text 16px or more; no point units; paragraph measure capped by `layout/container/text`.
- **Alt text and names:** Figma cannot hold real alt text or accessible names. Use the **Accessible name** text properties (Icon Button), annotation frames and layer names to carry them into the handoff.
- **Reading order and headings:** document the intended heading levels and focus order with annotation layers on pattern frames; Figma has no native construct for them.
- **Both modes:** check every component in Default and Inverse; the table above shows the Inverse mode passes.
- **Reduced motion and forced colours:** not representable in Figma. They are implemented in the web system (tested in Chromium emulation only) and noted in each component's handoff.

## What was not done

No plugin (contrast, annotation or accessibility) was run, since nothing exists in Figma. The web system's own manual tests (real devices, screen readers, Safari and Firefox, real Windows high contrast) remain outstanding in `01-Design-System/Documentation/manual-testing.md`; this specification inherits those gaps.
