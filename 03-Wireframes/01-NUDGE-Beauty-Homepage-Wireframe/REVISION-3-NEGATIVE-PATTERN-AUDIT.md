# NUDGE Beauty Homepage Wireframe: Revision 3, negative UI pattern audit

**File revised in place:** `Homepage_Wireframe_Final.html` (previously `NUDGE-Beauty-Homepage-Wireframe.html`; Revision 2 summary is kept beside it).
**Evidence read:** `Nudge-Theme-Plan.pdf` section 4 (annotated competitor studies, Beauty: Be Yours, Blockshop, Splendor, Magic), section 4.6 (13 "mistake seen / our rule" rows), the review-mining notes in the evidence register (678 negative Beauty and Clothing reviews counted), and `Homepage_CRO_5_Theme_Final_Comparison_Revised_Final.xlsx` (Beauty column) as the feature source.
**Evidence limits:** no separate client-feedback document exists in the project. The only quoted negative customer review in the Plan text is Magic ("Glitchy and too many bugs", Habrok Athletics, 2025-11-16), and it is about bugs and speed, not layout. The 678-review count is stated, but its cause table is not in the Plan text, so no pattern below is justified by it.
**Pages:** only the Homepage wireframe exists. There is no PLP, PDP or Cart wireframe in the project to improve; they are not created here.

## A. Negative pattern audit

Type: **R** = explicitly marked as a mistake in the Plan (red mark or 4.6 row), **N** = negative customer review, **W** = weak-theme observation, **I** = acceptable, needs improvement.

| # | Pattern | Source | Type | Negative impact | Action | Alternative in the wireframe | Status in current wireframe |
|---|---|---|---|---|---|---|---|
| 1 | Countdown timer in the announcement bar | Be Yours, Plan p21; 4.6 "Fake or placeholder content" | R | Fake urgency | Do not use | Plain real-offer message, arrows, no timer | Already avoided (Rev 2) |
| 2 | Floating "GET OFF" tab | Be Yours, p21; 4.6 "Pop-ups and floating tabs" | R | Covers page | Do not use | None; offers live in the bar and banner | Avoided |
| 3 | Dark hero with near-invisible headline | Be Yours, p21; 4.6 "Text over busy photos" | R | Low contrast | Do not use | Headline on a solid ivory card beside the image | Avoided |
| 4 | Cookie banner covering the hero, pale Accept/Decline | Splendor, p23 | R | Hides the first screen, weak buttons | Do not build in the page | Use Shopify's native consent banner at build time; it must not cover the hero button and Accept and Decline must have equal weight (build check, not wireframe UI) | Not in wireframe |
| 5 | Hero headline is not an H1 | Splendor, p22-23; 4.6 "No H1" | R | SEO and accessibility | Fix | One H1, heading level a setting | Self-test checks one H1 |
| 6 | Full-screen picture with no headline or button in the first screen | Magic, p23-24 | R | No message or action above the fold | Fix if present | Headline and main button inside the first phone screen | **Found and fixed in Rev 3** (see C) |
| 7 | "Limited Time Only" with no date | Magic, p24 | R | Vague urgency | Do not use | Offers marked "real data only", no default text | Avoided |
| 8 | Very small menu text and tap targets | Blockshop, p22 | R | Hard to read and tap | Check | 15 px menu at 1440 (17 px on phones), 44 px targets below 1024 px | Measured: passes; footer payment chips raised from 11 to 12 px in Rev 3 |
| 9 | No announcement, offer or trust message at the top | Blockshop, p22 | R | Missed reassurance | Keep our version | Announcement bar plus a four-item benefit row | Present |
| 10 | Dense header (several bars, long menu) | 4.6 | R | Clutter | Avoid | One header row, four links, no mega menu | Present (two rows only on phones: menu row and search row, kept because the workbook wants search always visible) |
| 11 | Pop-ups and floating tabs | 4.6 | R | Cover the page | Avoid | Newsletter is an in-page form | Present |
| 12 | Heavy page, slow mobile | Magic 29,901 KB; 4.6 | R, N | Slow, buggy feel | Control in build | Image ratios and sizes labelled; budget check in build | Wireframe only; measured as a build check |
| 13 | Very long mobile home page | Be Yours 19,427 px vs Splendor 4,819 and Pipeline 8,613, p20-21 | W | Fatigue, poor discovery | Keep, monitor | All 20 Yes sections stay (workbook). Measured length without the review notes: **13,188 px at 390 px**, less than Be Yours | Kept as is, flagged below |
| 14 | Missing alt text and unnamed buttons | Magic, 4.6 | R | Accessibility | Build requirement | Icon buttons carry labels; alt text is a build task | Icons labelled; alt is a build task |
| 15 | Placeholder or invented content | 4.6 | R | Fake proof | Avoid | Star rows and quotes labelled as layout placeholders; no counts or timers | Present |
| 16 | Broken or unnamed swatches | 4.6 | R | Variant confusion | Avoid | Shade dots only where a product has shades; named swatches on the product page | Present |
| 17 | No product or category in the first scrolls | 4.6 (Lumen) | R | Weak discovery | Avoid | Featured product tag in the hero, categories right after the benefit row | Present |
| 18 | No market selector in the mobile header | 4.6 (Pipeline, Formula) | R | Wrong currency or language | Avoid | Country selector in the mobile drawer | Present |
| 19 | Locked layouts and few options | 4.6 (Calm, Enterprise, Focal reviews) | N | Merchants cannot adapt | Theme build rule | Not a wireframe element; every block movable, Custom Liquid section present (section 18) | Present |
| 20 | Slow or no support, stale updates | 4.6 | N | Support | Not a UI pattern | Out of scope for wireframes | Excluded |

## B. Decisions on the examples in the task

- **Mega menu:** removed in Rev 2 (workbook: Beauty uses the centred-logo header). Not reintroduced.
- **Product cards:** Quick Add and second-image hover are No for Beauty in the workbook; Rev 2 removed them and added the key-attribute line. Unchanged.
- **Repetitive sections:** the four-tile routine row repeated How to Use; replaced by compact numbered links in Rev 2. No other duplicate found.
- **Filters, galleries, PDP and cart patterns:** not evaluated, because those wireframes do not exist.

## C. Change summary (Revision 3)

| Page / Section | Previous UI | Issue | New UI implemented | Reason |
|---|---|---|---|---|
| Homepage, Hero (below 768 px) | Square (1:1) hero image, so the main button started at about y 730 px of a 390 px phone | Magic's red mark: no headline or button in the first screen. With browser bars on a phone the main button fell below the fold | 4:3 image (1200 x 900). Measured at 390 px: image bottom 545 to 452, headline top 560 to 467, main button 730 to 636 | The headline and main button now sit inside a typical visible phone screen. No content, section order or CRO feature changed |
| Homepage, Footer payment chips | 11 px text | Small text, same family of issue as Blockshop's small menu | 12 px | Legibility; one line of CSS |

Everything else in the wireframe already complied with the audit, so it was left untouched on purpose.

## D. Excluded patterns (intentionally not used)

Countdown timer, floating discount tab, dark hero with weak contrast, cookie banner over the hero, vague urgency copy, pop-ups, mega menu, mixed header rows, scrolling slogan bands, fake ratings or counts. Sources are in table A.

## E. Validation

- Page self-test, 10 checks per width: **10 of 10** at 1920, 1440, 1024, 768, 390, 375 and 320 px in Edge and Chrome after the hero change.
- Hero first-screen positions measured at 390, 375, 360 and 1440 px (see C).
- Cross-check: all 20 Yes sections of the workbook's Beauty column are still present in order and no No section was added; typography (Cormorant and DM Sans), logo and Lucide icons were not touched.
- **Not done:** PLP, PDP and Cart review, because no such wireframes exist; real phones, Safari, Firefox and screen readers were not tested.
- **Open for your decision:** the mobile page is long (13,188 px) because the workbook marks 20 sections Yes. Shortening it would mean demoting sections, which is a CRO decision, not a layout fix.
