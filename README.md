# NUDGE Beauty Theme

Design foundation, page wireframes and CRO research for the **NUDGE Beauty Theme**, a premium beauty and skincare Shopify theme. Sixteen page wireframes are built (see `03-Wireframes/README.md` for the order); the Shopify theme code itself has not started.

## Project structure

The sections are numbered in working order: Design System, then Design Variables, then Wireframes, then the research behind them, then shared assets.

```
NUDGE-BEAUTY-THEME/
├── 01-Design-System/               showcase page, Styles, Scripts, Documentation, Figma-Specification
├── 02-Design-Variables/            CANONICAL token source (JSON), generated CSS, review dashboard, builder and tests, Figma-Variables
├── 03-Wireframes/                  00 shared Tailwind foundation, then 01 to 16 one numbered folder per page (storefront order), 99 archive
├── 04-CRO-Research/                Original-Research, CRO-Comparison, Documentation
└── 05-Assets/                      Fonts, Icons (with build-icons.ps1), Logos
```

| Section | Start here |
|---|---|
| 01-Design-System | [Documentation/README.md](01-Design-System/Documentation/README.md); open `01-Design-System/index.html` for the live showcase |
| 02-Design-Variables | [README.md](02-Design-Variables/README.md); open `02-Design-Variables/Preview/index.html` for the token dashboard |
| 03-Wireframes | [README.md](03-Wireframes/README.md) lists every page in order; start with [Homepage.html](03-Wireframes/01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html) (open in a browser; no build step) |
| 04-CRO-Research | `Original-Research/` holds the untouched source workbook; `CRO-Comparison/` the homepage comparison and the feature decision matrices; `Documentation/` the audit and per-page plans |
| 05-Assets | `Logos/logo.html` previews every logo variant; brand rules are in [brand.md](01-Design-System/Documentation/brand.md) |

- **Tokens live in `02-Design-Variables/` only.** The Design System links the CSS generated from them and defines none. Change a token in `02-Design-Variables/Tokens/*.json`, rebuild, and everything updates.
- **Fonts, icons and logos live in `05-Assets/` only.** The Design System and the wireframe link to them by relative path.
- **The Figma folders are specifications, not Figma files.** `01-Design-System/Figma-Specification/` and `02-Design-Variables/Figma-Variables/` describe how the same system could be organised in Figma.

## Commands

```powershell
powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Tokens/build-tokens.ps1                       # regenerate tokens + all checks
powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Tokens/test-tokens.ps1                        # browser test (Chrome or Edge)
powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Tokens/test-emulation.ps1                      # phone/touch, reduced motion, forced colors, no-:has() path
powershell -ExecutionPolicy Bypass -File 05-Assets/Icons/build-icons.ps1                                    # regenerate icons + sprite
powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Figma-Variables/build-figma-variables.ps1       # regenerate the Figma variable specification
powershell -ExecutionPolicy Bypass -File 01-Design-System/Figma-Specification/build-figma-docs.ps1          # regenerate the Figma component specification
powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Figma-Variables/validate-figma-variables.ps1    # validate the Figma specification
```

"NUDGE" is a working name: it has not been checked for trademark or Shopify Theme Store availability.
