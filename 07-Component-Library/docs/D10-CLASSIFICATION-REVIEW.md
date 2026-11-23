# D10: the eight flagged property classifications (for review)

Status: **approved 2026-11-17.** All eight are Passed from Parent. Recorded in the manifests as `"approved": "D10 (2026-11-17)"`.

Evidence used: the existing theme's section schemas (read-only) expose button label and link, a USP icon select, and a gallery tile size select. They expose no button style, size or icon, no chip text, no image alt and no image ratio. Pages use button sizes by context: large on PDP, Cart, Cart Drawer and Contact (`btn-lg`), small on PLP and Blog Article (`btn-sm`), medium elsewhere.

| # | Property | Component | Recommended class | Why | Affects design? | Affects Theme Editor? |
|---|---|---|---|---|---|---|
| 1 | size | Button | Passed from Parent (draft: Fixed by Design System) | Three Design System sizes, chosen by context; a snippet needs the parameter; merchants never choose it today | Yes: control height and padding | No |
| 2 | variant | Button | Passed from Parent | Fixed per place (primary, secondary, Editorial); existing sections expose only label and link; could become a merchant select later in one section | Yes: look | No today |
| 3 | variant | Chip | Passed from Parent | Fixed per place (DS chip in filters, Editorial on Homepage, Editorial tag on ingredients) | Yes: look | No |
| 4 | icon | Button | Passed from Parent | The Editorial style brings its arrow; no existing section lets merchants pick a button icon (the USP icon select belongs to the USP item) | Yes: icon shown | No |
| 5 | label | Chip | Passed from Parent (draft: Merchant Editable) | Filter chip text is product data; Homepage chips are fixed copy; no chip setting in the existing theme | Content only | No today |
| 6 | href | Chip | Passed from Parent (draft: Merchant Editable) | Computed from the filter or collection | No | No |
| 7 | alt | Media | Passed from Parent | Must come from the image (Shopify image alt, edited in admin); empty for decorative images; a theme-editor field would duplicate and drift | No visual change; accessibility | No (edited on the image in Shopify admin) |
| 8 | ratio | Media | Passed from Parent | Design picks the crop per context from the aspect scale; none exposed in the existing theme (gallery tile size is a separate property) | Yes: crop and height | No, unless a section exposes a tile size |

Effect on the base-component totals (70 properties): Merchant Editable 10 to 7, Fixed by Design System 4 to 3, Passed from Parent 48 to 52, Wireframe-only 8.
