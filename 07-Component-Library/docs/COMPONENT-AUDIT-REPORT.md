# Component Audit Report

Date: 2026-11-17. Scope: all 16 wireframe pages, the Design System, the shared partials and the 84 implemented components.

## 1. What exists

- **16 wireframes** (the brief says 15; the Cart Drawer is the sixteenth and is a dialog, not a page).
- **75 page sections** plus shared chrome and overlays; the Homepage has 20 sections, the other pages 1 to 7 each.
- **102 partial components**: 13 base (with manifests), 21 header and layout parts, and the Homepage section parents and their sub-components.
- **The Homepage, the PLP and the shared header, footer and announcement bar are built from components.** PDP, Cart, Cart Drawer, Contact, FAQ, About, Our Story, the four policy pages, Blog Listing, Blog Article and 404 are hand-written markup in their source files, using Design System CSS classes.
- **Design System components** (Button, Chip, Badge, Price, Rating, Field, Quantity, Accordion, Message, Drawer, Pagination, Breadcrumb) exist as CSS classes in the shared stylesheet.
- **Master inventory**: 229 entries in 12 groups (100 components, 12 ready but not adopted, 44 Design System classes, 48 page-specific, 0 page-local icons, 25 not present).

## 2. What works

- Buttons, chips, icon buttons and section headings are shared components used by the Homepage, with named variants (Design System and Homepage Editorial).
- One Icon component serves every icon; 25 call sites plus the header and footer.
- All 16 pages still match the approved baseline after the component work.
- The template engine is proven identical in the build and in the browser library (40 of 40 real calls).

## 3. Findings

1. **Resolved: ten icons that were defined inside single pages (clock, mail, phone, play, zoom-in, loader, truck, rotate-ccw, shield-check, store) are now in the shared sprite and the icon assets** (39 icons). The page-local copies were removed; all 16 pages were verified identical outside the sprite.
2. **Icons in the assets and sprite that no page uses:** eye-off, info, loader, rotate-ccw, shield-check, sort, store, truck. Kept. truck, rotate-ccw, shield-check and store were defined for the PDP delivery block; loader is used by script-built loading markup that the audited state does not show; sort, info and eye-off are available for later.
3. **Inner pages hand-write what the base components already provide:** 71 raw svg icons (class icon, same sprite) and every .btn button in the PDP, Cart, Drawer, Contact, FAQ, About, Story, policy, Blog and 404 sources; the Icon and Button components are called by the Homepage, the PLP and the shared header and footer. Same sprite and classes, so converting them is a no-visual-change migration.
3b. **Eight base components are ready but no page uses them:** Media, Badge, Price, Rating, Quantity, Message, Breadcrumb and Input Field. PLP, PDP, Cart and Drawer repeat the same markup by hand. Adoption is a no-visual-change migration, planned per page.
4. **PDP and Cart still build parts of their markup in JavaScript templates** (pickers, prices, ratings, cart lines); the PLP no longer does, its cards, tile, pagination, chips, filter groups and quick view render from component templates. Those templates must be shared with the components in one place before the pages can be converted.
5. **Four patterns for one idea (a selectable option):** .choice, .opt, .tile and .swatch. Recommendation: one Choice base component with variants.
6. **Duplicate cart line markup:** the Cart page and the Cart Drawer each hand-write the same line. Recommendation: one Cart Line Item component with a context variant.
7. **Duplicate accordion markup** across FAQ, PDP, PLP filters and footer: same classes, hand-written each time. One Accordion component.
8. **Two button systems that are one component:** the Design System Button and the Homepage Editorial Button are variants of base/button (approved). No further consolidation needed.
9. **Homepage and PLP product cards are separate by decision** and stay separate; they share only base parts.
10. **71 of 84 components have no manifest.** They preview with inferred properties; manifests are written when their page is converted.
11. **No payment icons exist:** the footer shows text labels. The brief lists payment icons; none are in the wireframes, so none were created.
12. **Requested but not present in any wireframe** (25): Buy Now Button; Load More Button; Grid / List View Icon; Payment Icons; Shipping Icon; Wishlist Icon; Password Input; Toggle Switch; Input Helper Text; Video Player; Responsive Image (img with srcset); Collection Card; Brand Card; Recently Viewed Product Card; Wishlist Control; Coupon / Discount Field; Checkout Summary; Tooltip; Toast; Loading State; Skeleton Loader; Floating Action Element; Expert Recommendations; Beauty Results; Product Comparison. They were not invented; they will be designed only if you decide the theme needs them.

## 4. Missing components (recommended, drawn from real repetition)

| Recommended component | Replaces | Pages |
|---|---|---|
| Choice (checkbox, radio, option card, swatch variants) | .choice, .opt, .tile, .swatch | PLP, PDP |
| Cart Line Item | hand-written cart line | Cart, Cart Drawer |
| Accordion Item | hand-written details markup | FAQ, PDP, PLP, footer |
| Pagination | .pagination markup | PLP, Blog Listing |
| Drawer | .drawer markup | PLP filters, quick view, PDP zoom, cart |
| Page Hero | repeated intro block | About, Story, Contact, Blog, 404 |
| Policy Page Body | the four policy pages | Shipping, Returns, Privacy, Terms |
| Empty State | empty cart, no articles, no results | Cart, Blog, PLP |
| Product Card Parts (shared media, price, rating, badge) | duplicated parts of both cards | Homepage, PLP, PDP related |

## 5. Duplicates and overlaps

- Button text styles: .btn-text and the Editorial text variant are two text-button looks; both kept (approved).
- Chip: DS chip (filters) and the editorial chip (Homepage concern and skin-type); one component, variants.
- Price: PLP, PDP and Cart repeat the .price markup; one base/price.
- Rating: PLP and PDP repeat the stars markup; one base/rating.

## 6. Recommendations (in order)

1. Review this inventory and the library, then approve the page order for conversion (suggested: Homepage sections, shared chrome, PLP, PDP, Cart, then the content pages).
2. Done: the ten page-local icons are in the shared sprite and assets (verified).
3. Approve creating Choice, Cart Line Item, Accordion Item, Pagination and Drawer as base components.
4. Review the token report before any fixed pixel value is mapped to a token.
5. Convert one page at a time, with the 16-page equality check and the library tests after each.

## 7. Counts for the record

- Button detections by kind: button: editorial 6; button: editorial-outline 3; button: primary 25; button: secondary 39; button: text 8; chip 5; disclosure toggle 96; icon button 48; other control 100; quantity control 14; tab 3
- Distinct icons used: 31; icon uses: 802
