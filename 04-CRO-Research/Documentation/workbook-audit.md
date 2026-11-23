# Workbook audit

**File:** `Copy of CRO Points for ABM.xlsx` (6.9 MB). **Method:** read the .xlsx package directly (no Python or Excel available; PowerShell XML parsing of every worksheet, shared strings and hyperlink relationships). **Result:** all 38 worksheets read; none hidden; no cell comments or threaded comments found; no formulas needed.

## Headline findings

- The workbook is a **general CRO audit library for many non-beauty brands** (electronics, apparel, home, food, services, travel). Beauty or personal-care tabs: Plum Goodness, IBA Cosmetics, Lotus Botanicals, Aroma Magic, Vicco Labs, Khadi Natural, Joy Personal Care, Biotique, plus Sugar Lash Pro inside 15 Companies.
- **Sheet1 is an account tracker, not a CRO list.** Its Link column points to external Google Docs/Sheets that were not opened (you asked not to rely on external links). Portronics, VIP Bags and Boult Audio are marked Done but only link to a Google Doc; Lavie World, Utsav Fashion, Bajaj Electricals, Skillmatics, Inc5shop and Beco carry the label CRO Points for ABM with no tab here; Gynoveda has only a website link. Their pointers may exist only in external files, so their content is **not covered**.
- The Opportunity-to-Lead and Deals rows (TIGC, Van Heusen, Peter England and others) carry only tracker data.
- **No numbers on impact.** The Impact column holds expectations such as Improved conversions, not measurements.
- Process tabs (**funnel**, **How To Do**) describe the sales and audit method and contain no theme features; they were kept for reference only. How To Do lists the GA4 events to verify (view product, add to cart, begin checkout, enter shipping info, enter billing info, purchase), which feed GLB-12.
- Plum Goodness lists competitors **Pilgrim, mCaffeine, Mamaearth** and the notes Page speed and conversion focused development / No GA / ETA 14 April.
- **Screenshots are not inspected.** 24 embedded images (Myborosil, Meolaa, Biotique, Happilo tabs) and the Jam.dev / Drive evidence links were not opened.

## Quality issues and ambiguities to confirm

- Pick Your Trail and Borosil tabs carry identical traffic, mobile/desktop split, page-speed and top-country values (2.758M visits, 89:11, India 95%); Mivi repeats the same page-speed values with no traffic figure. Pick Your Trail (a travel site) matching Borosil is almost certainly copy-paste, so these figures were not used.
- Havells and Fire-Boltt tabs are word-for-word duplicates, including the same Jam link.
- Happilo and Biotique reuse wording written for other brands (portion size, installation benefit). Happilo is food and the installation text is copied from Eureka Forbes; only the principles were used.
- Max Protein row 2 has Expected and Actual swapped; row 9 is labelled Serviceability Checker but describes reviews.
- XYXX row 5 is labelled PDP but describes filters (PLP); Biotique row 6 section says Sticky Add to Cart but describes filters.
- Legacy Health row 4 says the header should move off the screen and navigation appear sticky (contradictory).
- Flo Mattress row 7 (Only can be added after Price per night) is unclear.
- Lotus Botanicals row 3 evidence link looks malformed.
- Borosil row 32 has a Recommendations heading with no content.
- Plum Goodness: Pilgrim ne badhia kia hua hai and Link to page to be given are fragments without context.
- Design System and Figma Variables were not read in this step, so no suggestion is tied to specific tokens or components yet.
- The project and theme name is NUDGE; earlier drafts used other spellings of the working name.

## Sheet-by-sheet

| # | Worksheet | Company | Beauty? | Content type | Read | Cells | Data rows | Images | Notes |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Sheet1 | All tracked accounts | No | Tracker (no CRO pointers) | Yes | 542 | 0 | 0 | Account tracker (SN, Company Name, Source, Link, Website, Assigned To, Status, Tech Potential). Contains no CRO pointers itself; its Link column holds 137 hyperlinks, many to external Google Docs / Sheets that were not opened. |
| 2 | Plum Goodness | Plum Goodness | Yes | Notes | Yes | 2 | 2 | 0 | Free-form notes in two cells (A2, E2). Beauty-direct. Mixed Hindi/English fragments; some notes are not full sentences. |
| 3 | httpswww.mivi.in | Mivi | No | CRO observations | Yes | 18 | 11 | 0 | Parameter/Comments table. Rows 5 (number of products) blank. Page-speed values are identical to the Pick Your Trail and Borosil tabs, which looks copy-pasted. |
| 4 | httpspickyourtrail.com | Pick Your Trail | No | CRO observations | Yes | 29 | 14 | 0 | Parameter/Comments table. Travel site. Traffic, page speed and top-country values are identical to the Borosil tab (likely copy-paste). Row 15 holds only a link. |
| 5 | funnel |  | No | Process note (no features) | Yes | 17 | 0 | 0 | Sales-process note (Funnel: marketing reach-out, meeting, sales). No CRO feature content. |
| 6 | 15 Companies | 17 companies (see sheet) | Partly (Sugar Lash Pro) | CRO observations | Yes | 357 | 67 | 0 | 17 companies in blocks (company URL in column A of the first row of each block). Task / Page / Section / Expected / Actual / Impact. Rows 6, 7, 26, 39, 45, 50, 55, 60, 65, 71, 75, 76 blank separators. Some typos in source. |
| 7 | How To Do | How To Do (process note) | No | Process note (no features) | Yes | 7 | 0 | 0 | Process checklist (audit method, GA4 event list, checklist link). No feature content. |
| 8 | Borosil | Borosil | No | CRO observations | Yes | 40 | 29 | 0 | Parameter/Comments table with 22 observations (rows 9-30). Row 32 has the heading Recommendations with nothing under it. Some comments in column C. |
| 9 | httpshavells.com | Havells | No | CRO observations | Yes | 19 | 2 | 0 | 2 observations. Content and the Jam link are identical to the Fire-Boltt tab (duplicate). |
| 10 | httpswww.fireboltt.com | Fire-Boltt | No | CRO observations | Yes | 19 | 2 | 0 | 2 observations. Identical to the Havells tab (duplicate). |
| 11 | httpsmaxprotein.in | Max Protein | No | CRO observations | Yes | 61 | 9 | 0 | Row 2: Expected and Actual text appear swapped. Row 9 is labelled Serviceability Checker but is about reviews. |
| 12 | httpsglamfoodsllc.com | Glam Foods LLC | No | CRO observations | Yes | 43 | 6 | 0 | Service-site observations (contact, press, logo); little e-commerce relevance. |
| 13 | httpswww.legacyhealthwellness.c | Legacy Health and Wellness | No | CRO observations | Yes | 54 | 8 | 0 | Service and booking site; one header row has two Impact lines. Tab name truncated by Excel to 31 characters. |
| 14 | httpswww.bebe.com | bebe | No | CRO observations | Yes | 71 | 9 | 0 | Has an extra Mobile / Desktop column (D). Some Screenshot cells hold two links. |
| 15 | httpswww.gkboptical.com | GKB Optical | No | CRO observations | Yes | 19 | 2 | 0 | 2 observations (checkout). |
| 16 | IBA Cosmetics | IBA Cosmetics | Yes | CRO observations | Yes | 49 | 7 | 0 | Beauty-direct. 7 observations. |
| 17 | Melorra | Melorra | No | CRO observations | Yes | 43 | 6 | 0 | 6 observations. |
| 18 | XYXX | XYXX | No | CRO observations | Yes | 43 | 6 | 0 | 6 observations; row 5 is labelled PDP but describes filters (PLP). |
| 19 | Flomattress | Flo Mattress | No | CRO observations | Yes | 76 | 16 | 0 | Rows 2-8 are only one-line notes in column A (no structure); rows 11-19 are structured. Row 7 text is unclear. |
| 20 | Navneet | Navneet | No | CRO observations | Yes | 42 | 6 | 0 | 6 observations. |
| 21 | httpswww.lotusbotanicals.com | Lotus Botanicals | Yes | CRO observations | Yes | 42 | 6 | 0 | Beauty-direct. Column order differs (Page, Section, Actual, Expected). Row 3 evidence link looks malformed (ends in ...ea1a111bdaa/ ...ea1a9f111a1ff10). |
| 22 | httpswww.aromamagic.com | Aroma Magic | Yes | CRO observations | Yes | 42 | 6 | 0 | Beauty-direct. Same template as Lotus Botanicals. |
| 23 | httpswww.viccolabs.com | Vicco Labs | Yes | CRO observations | Yes | 48 | 7 | 0 | Beauty-direct (personal care). |
| 24 | httpswww.khadinatural.com | Khadi Natural | Yes | CRO observations | Yes | 42 | 6 | 0 | Beauty-direct. Names skin type and hair type filters. |
| 25 | httpswww.fablestreet.com | Fablestreet | No | CRO observations | Yes | 42 | 6 | 0 | Observations 1-5 share the Lotus / Aroma Magic template wording. |
| 26 | httpswww.ambraneindia.com | Ambrane | No | CRO observations | Yes | 54 | 8 | 0 | Row 5 impact says Higher AOV for a price-summary item (odd). |
| 27 | httpswww.kazo.com | Kazo | No | CRO observations | Yes | 48 | 7 | 0 | Typo in search example ("dressses"). |
| 28 | httpsitsybitsy.in | Itsy Bitsy | No | CRO observations | Yes | 48 | 7 | 0 | Duplicated template wording. |
| 29 | httpswww.joypersonalcare.com | Joy Personal Care | Yes | CRO observations | Yes | 48 | 7 | 0 | Beauty-direct (sunscreen product named in row 3). |
| 30 | httpsmyborosil.com | Myborosil | No | CRO observations | Yes | 50 | 7 | 6 | 6 embedded images (screenshots) not inspected; no screenshot hyperlinks; row 8 label cut (PDP/PL). |
| 31 | httpsmeolaa.com | Meolaa | No | CRO observations | Yes | 66 | 8 | 6 | 6 embedded images (screenshots) not inspected; S.No stored as numbers (1.0 ...). |
| 32 | safaribags.com | Safari Bags | No | CRO observations | Yes | 49 | 6 | 0 | 6 observations. |
| 33 | zodiaconline.com | Zodiac | No | CRO observations | Yes | 21 | 2 | 0 | 2 observations; a SimilarWeb link and a note (Mobile traffic major) in columns J. |
| 34 | httpeurekaforbes.com | Eureka Forbes | No | CRO observations | Yes | 49 | 6 | 0 | 6 observations. |
| 35 | httpswww.biotique.com | Biotique | Yes | CRO observations | Yes | 68 | 15 | 6 | Beauty-direct. 6 embedded images not inspected. Rows 27-32 hold the leftover How To Do checklist. Rows 2-3 and 7 ask for portion size (food wording copied from Happilo); row 6 section label says Sticky Add to Cart but describes filters. |
| 36 | httpshappilo.com | Happilo | No | CRO observations | Yes | 50 | 7 | 6 | 6 embedded images not inspected. Row 8 repeats the Eureka Forbes wording (shipping discount and installation benefit) which does not fit a food brand. |
| 37 | LifelongIndia | Life Long India | No | CRO observations | Yes | 61 | 8 | 0 | 8 observations; screenshots are Drive file links. |
| 38 | Wellversed | Wellversed | No | CRO observations | Yes | 28 | 3 | 0 | 3 observations. |

## Extraction counts

- Populated cells across all tabs: **2407**. All of them are reproduced in the Source Extract (raw) sheet of the matrix.
- Consolidated features: **83** (Homepage 9, PLP 12, PDP 20, Cart 17, Other / Global 25).
