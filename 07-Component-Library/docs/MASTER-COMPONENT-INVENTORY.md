# Master Component Inventory

Generated from the rendered wireframes (all 16 pages, 1440 px, after scripts ran) on 2026-11-17. Evidence comes from the audit, not from assumptions: every line names where the component was found, or states that it is not present.

**Scope note.** The brief says 15 pages; the project has **16** wireframes (Homepage, PLP, PDP, Cart, Cart Drawer, Contact, FAQ, About, Our Story, Shipping Policy, Returns Policy, Privacy Policy, Terms and Conditions, Blog Listing, Blog Article, 404). The Cart Drawer is a dialog opened from the header, not a page, and it is audited with the others.

## How to read this

| Status | Meaning |
|---|---|
| Component | Implemented as a partial component and used by pages |
| Ready (not adopted) | A base component exists and validates; pages still use hand-written markup |
| Design System class | Only a CSS class in the Design System; the markup is written by hand on each page |
| Page-specific | Page markup or script with no shared component yet |
| Page-local | An icon defined inside a single page, not in the shared sprite |
| Not in wireframes | Requested in the brief, but not found on any page. Not created. |

## Totals

- Master entries: **229** in 12 groups
- Component: 100; Ready (not adopted): 12; Design System class: 44; Page-specific: 48; Page-local icons: 0; Not in wireframes: 25
- Implemented partial components in the project: **102** (13 base with manifests, 71 others without manifests)

## 01 Buttons

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C001 | Primary Button | Component | base/button variant=primary (.btn .btn-primary) | PLP x3, PDP x2, Cart x2, Drawer x2, Contact x1, FAQ x1, About x2, Story x1, Ship x2, Return x2, Privacy x2, Terms x2, BlogL x1, BlogA x1, 404 x1 | Variant exists in base/button; inner pages hand-write the same .btn markup |
| C002 | Secondary Button | Component | base/button variant=secondary (.btn-secondary) | PLP x22, Cart x2, Drawer x1, Contact x1, About x1, Story x1, Ship x2, Return x2, Privacy x2, Terms x2, BlogL x1, BlogA x1, 404 x1 | Variant exists in base/button; inner pages hand-write the same .btn markup |
| C003 | Tertiary / Text Button | Component | base/button variant=text (.btn-text) | PLP x5, Contact x1, About x1, 404 x1 | The Design System has one text-style tier; it serves as the tertiary button |
| C004 | Outline Button | Component | base/button variant=secondary (DS) and editorial-outline (Homepage) | Home x3, PLP x22, Cart x2, Drawer x1, Contact x1, About x1, Story x1, Ship x2, Return x2, Privacy x2, Terms x2, BlogL x1, BlogA x1, 404 x1 | Outline style is the secondary variant; not a separate system |
| C005 | Editorial Button | Component | base/button variant=editorial (.hp-btn) | Home x6 | Approved Homepage Editorial variant of the Button |
| C006 | Editorial Outline Button | Component | base/button variant=editorial-outline (.hp-btn-o) | Home x3 | Approved Homepage Editorial variant |
| C007 | Editorial Text Button | Ready (not adopted) | base/button variant=editorial-text | - | Variant defined; no page uses it yet |
| C008 | Icon Button | Component | base/icon-button variant=ds (.icon-btn) | PLP x2, PDP x6, Drawer x1 | Close, gallery arrows, zoom |
| C009 | Circular Icon Button | Component | base/icon-button variant=circle / circle-soft | Home x6 | Homepage scrollers and ritual controls |
| C010 | Announcement Arrow Button | Component | layout/announcement-arrow | all 16 pages (32) | Announcement bar, every page |
| C011 | Add to Cart Button | Design System class | .btn .btn-primary (text: Add to bag); cart add-on uses .btn-secondary Add | PLP x1, PDP x2, Cart x2, Drawer x1 | Same Button, different label; hand-written on PLP, PDP, Cart |
| C012 | Buy Now Button | Not in wireframes | - | - | Not in the wireframes |
| C013 | Quick View Button | Design System class | .btn .btn-secondary .pc-quick | PLP x19 | PLP product card action |
| C014 | Apply Filter Button | Design System class | .btn .btn-primary | PLP x1 | Filter drawer footer |
| C015 | Clear Filter Button | Design System class | .btn-primary (drawer), .btn-text (applied bar) | PLP x5 | Two styles of the same action |
| C016 | Load More Button | Not in wireframes | - | - | Not in the wireframes (PLP uses Pagination) |
| C017 | View All Button | Component | base/button editorial-outline / text | Home x1, PLP x1 | Homepage View all best sellers; PLP quick view link |
| C018 | Checkout Button | Design System class | .btn .btn-primary btn-block | Cart x1, Drawer x1 | Cart page and drawer |
| C019 | Continue Shopping Button | Design System class | .btn-primary (cart, 404) / .btn-text (contact) | Cart x1, Drawer x1, Contact x1, 404 x1 |  |
| C020 | Form Submit Button | Design System class | .btn .btn-primary type=submit | Home x1, Contact x1, BlogA x1 | Contact, comment, newsletter |
| C021 | Newsletter Subscribe Button | Component | base/button variant=editorial element=submit | Home x1 | Homepage newsletter |
| C022 | Back to Top Button | Component | layout/back-to-top | all 16 pages (16) | Footer, every page |
| C023 | Call-to-Action Button (page CTAs) | Component | base/button (any variant) | Home x5, PLP x2, Cart x1, Drawer x1, Contact x2, FAQ x1, About x4, Story x2, Ship x4, Return x4, Privacy x4, Terms x4, BlogL x2, 404 x3 | Shop now, Contact us, Read the FAQ and similar |
| C024 | Filters Open Button | Design System class | .btn .btn-secondary with filter icon | PLP x1 | Opens the mobile filter drawer |
| C025 | Disabled / Sold-out Button | Design System class | .btn .btn-secondary disabled | PLP x1 | PLP card state |
| C026 | Share Button | Design System class | .btn .btn-secondary btn-sm with share icon | BlogA x1 | Blog article |
| C027 | Remove Line Button | Design System class | .link style button | Cart x3, Drawer x3 | Cart line |
| C028 | Wizard Step Button (Next / Back) | Component | base/button editorial | Home x2 | Homepage guided finder |
| C029 | Play Video Button | Page-specific | Homepage video poster play control | Home x1, PDP x2 |  |

Requested but not present in this group: Buy Now Button; Load More Button.

## 02 Icons

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C030 | Search Icon | Component | base/icon name=search | all 16 pages (49) |  |
| C031 | Shopping Bag / Cart Icon | Component | base/icon name=bag | all 16 pages (17) | Header cart button |
| C032 | Account / User Icon | Component | base/icon name=account | all 16 pages (16) |  |
| C033 | Menu / Hamburger Icon | Component | base/icon name=menu | all 16 pages (16) |  |
| C034 | Close Icon | Component | base/icon name=close | all 16 pages (20) |  |
| C035 | Chevron Icons (up, down, left, right) | Component | base/icon name=chevron-* | all 16 pages (184) | Accordion, scrollers, pagination, selects |
| C036 | Arrow Icons (left, right) | Component | base/icon name=arrow-* | all 16 pages (224) | CTAs and navigation |
| C037 | Plus / Minus Icons | Component | base/icon name=plus / minus | all 16 pages (78) | Quantity controls, footer accordion |
| C038 | Heart Icon | Component | base/icon name=heart | Home x1 | Homepage benefit row only |
| C039 | Star / Rating Icon | Component | base/icon name=star | Home x34, PLP x40, PDP x30 | Rating |
| C040 | Filter Icon | Component | base/icon name=filter | PLP x1 | PLP |
| C041 | Sort Icon | Ready (not adopted) | base/icon name=sort (in sprite) | - | In the sprite and assets, not used on any page |
| C042 | Grid / List View Icon | Not in wireframes | - | - | Not in the wireframes |
| C043 | Location Icon | Component | base/icon name=location | all 16 pages (19) | Market selector, benefit row, contact |
| C044 | Phone Icon | Component | base/icon name=icon (now in the shared sprite and assets) | Contact x2 | Was defined inside one page; moved to the shared sprite |
| C045 | Email Icon | Component | base/icon name=icon (now in the shared sprite and assets) | Contact x2 | Was defined inside one page; moved to the shared sprite |
| C046 | Clock Icon | Component | base/icon name=icon (now in the shared sprite and assets) | Contact x2 | Was defined inside one page; moved to the shared sprite |
| C047 | Social Media Icons (Instagram, Facebook, YouTube) | Component | base/icon via layout/social-link | all 16 pages (48) | Footer |
| C048 | Payment Icons | Not in wireframes | footer shows text pills (layout/footer-payments) | - | No payment icons exist; payments are text labels |
| C049 | Security / Lock Icon | Component | base/icon name=lock | Cart x1, Drawer x1 | Cart secure checkout |
| C050 | Shipping Icon | Not in wireframes | - | - | Not in the wireframes |
| C051 | Wishlist Icon | Not in wireframes | - | - | No wishlist control exists; the heart icon is a benefit symbol only |
| C052 | Check / Check-circle Icons | Component | base/icon name=check / check-circle | all 16 pages (24) | Market selector, newsletter, messages |
| C053 | Warning Icon | Component | base/icon name=warning | PLP x1, PDP x1, Contact x1 | Validation and stock messages |
| C054 | Eye Icon | Component | base/icon name=eye | PLP x1 | PLP banner |
| C055 | Share Icon | Component | base/icon name=share | BlogA x1 | Blog article |
| C056 | Play Icon | Component | base/icon name=icon (now in the shared sprite and assets) | PDP x2 | Was defined inside one page; moved to the shared sprite |
| C057 | Zoom-in Icon | Component | base/icon name=icon (now in the shared sprite and assets) | PDP x1 | Was defined inside one page; moved to the shared sprite |
| C058 | Delivery / Returns / Trust / Pickup Icons (truck, rotate-ccw, shield-check, store) | Component | base/icon (in the shared sprite) | - | Defined for the PDP delivery block; no page source references them directly yet |
| C059 | Loader Icon | Component | base/icon name=loader (in the shared sprite) | - | Used by PDP and Cart loading states (script-built markup) |
| C060 | Info Icon | Ready (not adopted) | base/icon name=info (in sprite) | - | Not used on any page |
| C061 | Eye-off Icon | Ready (not adopted) | base/icon name=eye-off (in sprite) | - | Not used on any page |

Requested but not present in this group: Grid / List View Icon; Payment Icons; Shipping Icon; Wishlist Icon.

## 03 Forms and inputs

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C062 | Text Input | Design System class | .field + .input (base/input-field ready) | PDP x1, Cart x4, Drawer x3, Contact x3, BlogA x2 | Name, order number, quantity |
| C063 | Email Input | Design System class | .field + .input type=email | Home x1, Contact x1, BlogA x1 | Contact, comment, newsletter |
| C064 | Password Input | Not in wireframes | - | - | No account pages in the wireframes |
| C065 | Search Input | Design System class | .input type=search | 404 x1 | 404 page search |
| C066 | Phone Input | Design System class | .input type=tel | Contact x1 | Contact |
| C067 | Select Dropdown | Design System class | .select + .select-icon | PLP x1, Contact x1 | PLP sort, contact topic |
| C068 | Checkbox | Design System class | .choice + choice-input (facets, bundle) | PLP x60, PDP x3 | PLP facets, PDP routine |
| C069 | Radio Button | Design System class | .opt / .tile (PDP option cards) and swatch radios | PDP x10 | PDP variant and selling plan pickers |
| C070 | Toggle Switch | Not in wireframes | - | - | Not in the wireframes |
| C071 | Range Slider | Page-specific | Before and after compare slider | Home x1 | Homepage |
| C072 | Quantity Input | Ready (not adopted) | base/quantity (.qty .qty-btn .qty-input) | PDP x1, Cart x3, Drawer x3 | PDP, Cart, Drawer use hand-written .qty markup |
| C073 | Textarea | Design System class | .field + textarea | Cart x1, Contact x1, BlogA x1 | Contact, comment, order note |
| C074 | Newsletter Form | Component | homepage/newsletter-section + newsletter-field | Home x1 | Homepage |
| C075 | Filter Inputs (facet checkboxes, price range) | Component | plp/facet-groups | PLP x82 | PLP |
| C076 | Form Validation Message | Ready (not adopted) | base/message variant=error (.message-error) | PDP x1, Contact x2 | Contact, PDP |
| C077 | Input Label | Design System class | .field-label | Home x1, PLP x83, PDP x13, Cart x1, Contact x6, BlogA x3, 404 x1 |  |
| C078 | Input Helper Text | Not in wireframes | - | - | No helper text pattern in the wireframes |
| C079 | Contact Form | Page-specific | Contact page form | Contact x1 | Composite: fields, select, textarea, submit, success state |
| C080 | Comment Form | Page-specific | Blog article comments | BlogA x1 |  |
| C081 | Order Note Field | Page-specific | Cart note | Cart x1 |  |

Requested but not present in this group: Password Input; Toggle Switch; Input Helper Text.

## 04 Images and media

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C082 | Product Image | Page-specific | placeholder in PLP card (.pc-media), PDP gallery, Homepage product card | PDP x14 | base/media ready |
| C083 | Category Image | Component | homepage/category-card image | Home x1 |  |
| C084 | Hero Image | Component | homepage/hero-media | Home x1 |  |
| C085 | Banner Image | Component | homepage/promo-media; PLP collection banner | Home x1, PLP x1 |  |
| C086 | Thumbnail Image | Page-specific | PDP gallery thumbnails | PDP x4 |  |
| C087 | Lifestyle / Look Image | Component | homepage/look-section | Home x1 |  |
| C088 | Before / After Image | Component | homepage/compare-section + compare-layer | Home x1 |  |
| C089 | Video Thumbnail (poster) | Component | homepage/video-poster | Home x1 |  |
| C090 | Video Player | Not in wireframes | - | - | Only a poster exists; no player is in the wireframes |
| C091 | Image Gallery | Page-specific | PDP gallery; Homepage customer photos | Home x1, PDP x1 | Homepage gallery is a component; PDP gallery is page markup |
| C092 | Image Slider / Carousel | Page-specific | PDP gallery prev/next and dots | PDP x4 |  |
| C093 | Responsive Image (img with srcset) | Not in wireframes | - | - | Wireframes use labelled placeholders only |
| C094 | Placeholder Image | Ready (not adopted) | base/media (.ph, .ph-b, .ph-c) | all 16 pages (174) | Wireframe placeholder, ratios 1:1 to 16:9 |
| C095 | Customer Photo Tile | Component | homepage/gallery-tile | Home x1 |  |

Requested but not present in this group: Video Player; Responsive Image (img with srcset).

## 05 Cards

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C096 | Homepage Product Card | Component | homepage/product-card | Home x4 | Kept separate from the PLP card |
| C097 | PLP Product Card | Component | plp/product-card (uses base badge, price, rating, button, icon) | PLP x10 | Kept separate from the Homepage card; rendered by the PLP script from its own template |
| C098 | Hero Featured Product Card | Component | homepage/hero-featured-product | Home x1 |  |
| C099 | Category Card | Component | homepage/category-card | Home x1 |  |
| C100 | Collection Card | Not in wireframes | - | - | No separate collection card; collections are shown as category cards |
| C101 | Concern Card | Component | homepage/concern-card | Home x1 |  |
| C102 | Review Card | Component | homepage/review-card (+ PDP review list) | Home x1, PDP x1 | Homepage testimonials and PDP reviews |
| C103 | Testimonial Card | Component | homepage/review-card | Home x6 | Same as Review Card (merged) |
| C104 | Blog Card | Page-specific | Blog listing grid item | BlogL x1 |  |
| C105 | Article Card (featured) | Page-specific | Blog listing featured article | BlogL x1 |  |
| C106 | Ingredient Card | Component | homepage/ingredient-card | Home x1 | PDP shows ingredient blocks as page markup |
| C107 | Benefit Card (USP item) | Component | homepage/usp-item | Home x1 |  |
| C108 | Brand Card | Not in wireframes | - | - | Not in the wireframes (logo items only) |
| C109 | Lookbook Card | Component | homepage/look-row + look-pin | Home x1 |  |
| C110 | Promotional Card | Component | homepage/promo-banner; header/mega-card | Home x1 |  |
| C111 | Recommendation Card | Page-specific | PDP Complete your routine; cart add-on | PDP x1, Cart x1 |  |
| C112 | Related Product Card | Page-specific | PDP related products | PDP x1 | Uses the PLP-style card pattern |
| C113 | Recently Viewed Product Card | Not in wireframes | - | - | Not in the wireframes |
| C114 | Cart Item Card | Page-specific | cart line (.qty, price, remove) | Cart x3, Drawer x3 | Cart page and drawer |
| C115 | Contact Detail Card | Page-specific | Contact details list item | Contact x1 |  |
| C116 | Value Card | Page-specific | About values | About x1 |  |
| C117 | Timeline Milestone | Page-specific | Our Story timeline | Story x1 |  |
| C118 | At-a-glance Card | Page-specific | Policy summary items | Ship x1, Return x1, Privacy x1, Terms x1 | Four policy pages |
| C119 | Mega Menu Card | Component | header/mega-card | all 16 pages (128) | Header mega menu promotional cards |
| C120 | Quick Answer Card | Page-specific | Contact quick answers | Contact x1 |  |

Requested but not present in this group: Collection Card; Brand Card; Recently Viewed Product Card.

## 06 Typography

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C121 | Heading H1 | Design System class | .type-h1 / element default | all 16 pages (17) | One per page |
| C122 | Heading H2 | Design System class | .type-h2 | Home x12, PLP x6, PDP x6, Cart x2, Drawer x2, Contact x5, FAQ x5, About x4, Story x3, Ship x12, Return x13, Privacy x13, Terms x14, BlogL x3, BlogA x3 |  |
| C123 | Heading H3 | Design System class | .type-h3 | Home x8, PLP x13, PDP x7, Contact x1, About x3, Story x4, BlogL x9, BlogA x2 |  |
| C124 | Heading H4-H6 | Design System class | .type-h4 to .type-h6 | - |  |
| C125 | Section Heading | Component | base/section-heading | Home x6 | Homepage sections |
| C126 | Subheading / Lead | Component | section-heading lead property | - |  |
| C127 | Body Text / Paragraph | Design System class | .type-body, .type-body-lg, .type-body-sm | - | Element defaults, every page |
| C128 | Caption | Design System class | .type-caption | - |  |
| C129 | Overline | Design System class | .type-overline | - |  |
| C130 | Price Typography | Design System class | .type-price, .type-price-lg | PLP x10, PDP x9, Cart x3, Drawer x3 |  |
| C131 | Discount Text | Design System class | .price-sale / .price-compare | PLP x1 |  |
| C132 | Product Title | Design System class | .type-product-title | - |  |
| C133 | Label Text | Design System class | .type-label | Home x1, PLP x83, PDP x13, Cart x1, Contact x6, BlogA x3, 404 x1 |  |
| C134 | Rich Text Content | Page-specific | policy text, article body | Ship x1, Return x1, Privacy x1, Terms x1, BlogA x1 | Long-form content blocks |
| C135 | Pull Quote | Page-specific | Our Story pull quote | Story x1 |  |

## 07 Navigation

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C136 | Announcement Bar | Component | shared annbar (layout/announcement-arrow, announcement-dots) | all 16 pages (16) | Every page |
| C137 | Header | Component | shared header (logo, nav-item, search-button, account-button, cart-button, menu-button) | all 16 pages (16) | Every page |
| C138 | Desktop Navigation | Component | header/nav-item | all 16 pages (16) | Part of Header |
| C139 | Mega Menu | Component | header/mega-menu + menus/* + mega-column + mega-cards | all 16 pages (64) | 4 panels |
| C140 | Mobile Navigation / Hamburger Drawer | Component | header/menu-button + nav-close + nav panel | all 16 pages (16) | Part of Header |
| C141 | Market Selector | Component | header/market-selector | all 16 pages (16) | Country and currency |
| C142 | Breadcrumb | Ready (not adopted) | base/breadcrumb (.breadcrumb) | PLP x1, PDP x1, Contact x1, FAQ x1, About x1, Story x1, Ship x1, Return x1, Privacy x1, Terms x1, BlogL x1, BlogA x1 | Pages use hand-written .breadcrumb markup |
| C143 | Footer | Component | shared footer (footer-brand, footer-column, social-link, footer-payments) | all 16 pages (16) | Every page |
| C144 | Footer Link Group | Component | layout/footer-column | all 16 pages (64) |  |
| C145 | Pagination | Component | plp/pagination (items) inside plp/product-grid | PLP x2, BlogL x1 | PLP; the blog listing still uses hand-written markup |
| C146 | Tabs | Component | homepage/collection-tabs | Home x3 | Homepage featured collection |
| C147 | Accordion | Design System class | .accordion .accordion-item (details) | PLP x20, PDP x9, FAQ x17, Ship x1, Return x1, Privacy x1, Terms x1 | FAQ, PDP, PLP filters, footer |
| C148 | Sidebar Navigation (filter sidebar) | Component | plp/filters-sidebar | PLP x2 | PLP filter column |
| C149 | Sub-collection Links | Component | plp/subcollection-nav | PLP x1 | PLP chip row of sub-collections |

## 08 Commerce

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C150 | Product Price | Component | base/price (.price .price-current) | PLP x10, PDP x9, Cart x3, Drawer x3 | Hand-written on PLP, PDP, Cart |
| C151 | Compare-at Price | Component | base/price variant=sale (.price-compare) | PLP x1, PDP x1, Cart x1, Drawer x1 | Part of base/price, used by plp/product-card |
| C152 | Discount Badge | Component | base/badge variant=overlay-sale | PLP x6 | PLP badges |
| C153 | Bestseller Badge | Component | base/badge variant=overlay | PLP x6 | Metafield tag badge:<text> is pending merchant confirmation |
| C154 | New Badge | Component | base/badge variant=overlay | PLP x6 | Same badge, different label |
| C155 | Product Rating | Component | base/rating (.rating .rating-stars) | PLP x8, PDP x6 | PLP and PDP |
| C156 | Review Count | Component | base/rating count property | PLP x8, PDP x6 | Part of Rating |
| C157 | Product Variant Selector | Page-specific | PDP variant picker (swatch radios + option cards) | PDP x1 |  |
| C158 | Size Selector | Page-specific | PDP size options | PLP x4, PDP x1 |  |
| C159 | Color Swatch | Design System class | .swatch .swatch-chip (PLP), shade radios (PDP) | PLP x20 | Two different swatch patterns |
| C160 | Quantity Selector | Ready (not adopted) | base/quantity | PDP x1, Cart x3, Drawer x3 |  |
| C161 | Quick View Panel | Component | plp/quick-view-drawer + plp/quick-view-body | PLP x1 | PLP quick view side panel |
| C162 | Wishlist Control | Not in wireframes | - | - | Not in the wireframes |
| C163 | Stock Status | Page-specific | low-stock and sold-out text in PLP and PDP | PLP x1 |  |
| C164 | Delivery Information | Page-specific | PDP delivery, returns, pickup block | PDP x1 |  |
| C165 | Product Details Accordion | Page-specific | PDP details | PDP x1 |  |
| C166 | Selling Plan Picker | Page-specific | PDP subscribe or one-time | PDP x1 |  |
| C167 | Buy Buttons Group | Page-specific | PDP quantity + add to bag | PDP x1 |  |
| C168 | Product Gallery | Page-specific | PDP gallery with zoom viewer | PDP x1 |  |
| C169 | Product Zoom Viewer | Page-specific | PDP image dialog | PDP x1 |  |
| C170 | Cart Line Item | Page-specific | cart line | Cart x3, Drawer x3 | Same as Cart Item Card |
| C171 | Cart Summary | Page-specific | order summary | Cart x1 |  |
| C172 | Cart Drawer | Page-specific | cart drawer dialog | Drawer x1 |  |
| C173 | Cart Upsell | Page-specific | cart add-on | Cart x1 |  |
| C174 | Coupon / Discount Field | Not in wireframes | - | - | Not in the wireframes |
| C175 | Checkout Summary | Not in wireframes | - | - | Checkout is outside the wireframe scope |
| C176 | Free Shipping Progress | Page-specific | progress indicator in cart | Cart x1, Drawer x1 |  |

Requested but not present in this group: Wishlist Control; Coupon / Discount Field; Checkout Summary.

## 09 Feedback

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C177 | Badge | Component | base/badge | PLP x6 | base/badge, used by plp/product-card |
| C178 | Chip | Component | base/chip | Home x9, PLP x10, Cart x5, Drawer x5, FAQ x4, BlogL x6, BlogA x2, 404 x5 | Filter chips, concern chips, tags |
| C179 | Tag | Component | base/chip variant=editorial-tag | Home x9 |  |
| C180 | Tooltip | Not in wireframes | - | - | Not in the wireframes |
| C181 | Toast | Not in wireframes | - | - | Not in the wireframes |
| C182 | Alert / Message | Ready (not adopted) | base/message | PDP x3, Contact x1 |  |
| C183 | Success Message | Ready (not adopted) | base/message variant=success | PDP x2 |  |
| C184 | Error Message | Ready (not adopted) | base/message variant=error | PDP x1, Contact x1 |  |
| C185 | Empty State | Component | plp/empty-state (PLP); cart and blog still hand-written | Cart x1, BlogL x1 | PLP converted; cart and blog empty states remain page markup |
| C186 | Loading State | Not in wireframes | - | - | Not in the wireframes |
| C187 | Skeleton Loader | Not in wireframes | - | - | Not in the wireframes |
| C188 | Progress Indicator | Page-specific | free shipping progress | Cart x1, Drawer x1 |  |
| C189 | Modal Dialog | Design System class | native dialog (.drawer base) | PLP x2, PDP x1, Drawer x1 | PLP quick view, PDP zoom |
| C190 | Drawer | Design System class | .drawer .drawer-head .drawer-body .drawer-foot | PLP x2, PDP x1, Drawer x1 | Filters, quick view, zoom, cart |
| C191 | Popover / Disclosure Menu | Component | header/market-selector panel | all 16 pages (96) |  |
| C192 | Status / Live Region | Page-specific | polite announcements | all 16 pages (43) | Accessibility, no visible UI |

Requested but not present in this group: Tooltip; Toast; Loading State; Skeleton Loader.

## 10 Layout

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C193 | Section Container | Design System class | .sec / .sec__in | - | Every section |
| C194 | Content Wrapper | Design System class | .wrap | - | Every page |
| C195 | Grid | Design System class | Tailwind grid utilities with Design Variable gaps | - |  |
| C196 | Flex Layout | Design System class | Tailwind flex utilities | - |  |
| C197 | Divider | Design System class | .divider | Cart x1 | Cart |
| C198 | Spacer | Design System class | spacing tokens | - | No separate spacer element; spacing comes from tokens |
| C199 | Section Background | Design System class | bg-page, bg-surface, bg-subtle, bg-inverse, bg-brand | - | Homepage section rhythm |
| C200 | Responsive Layout Wrapper | Design System class | breakpoints at 600, 768, 1024, 1280 | - |  |
| C201 | Sticky Bar | Design System class | sticky header, sticky purchase panel | Home x1 |  |
| C202 | Floating Action Element | Not in wireframes | - | - | Not in the wireframes (back to top is in the footer) |
| C203 | Scroller (horizontal carousel) | Component | common/scroller-controls | Home x3 | Homepage scrollers |
| C204 | Wireframe Annotation Note | Page-specific | .ann (wireframe only) | - | Wireframe-only; not a theme component |

Requested but not present in this group: Floating Action Element.

## 11 Beauty

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C205 | Skin Concern Selector | Component | homepage/concern-section + concern-card | Home x1 |  |
| C206 | Skin Type Selector | Component | homepage/finder-card (skin-type chips) | Home x5 | Homepage guided finder |
| C207 | Guided Finder / Quiz | Component | homepage/finder-section | Home x1 |  |
| C208 | Ingredient Information | Component | homepage/ingredient-section | Home x1 | PDP story ingredients are page markup |
| C209 | Ingredient Benefits | Page-specific | PDP product storytelling ingredient list | PDP x1 |  |
| C210 | How to Use | Component | homepage/ritual-section | Home x1 | PDP has a how-to-use accordion |
| C211 | Routine Steps | Component | homepage/ritual-step, routine-step | Home x2 |  |
| C212 | Product Benefits | Component | homepage/usp-row | Home x1 |  |
| C213 | Before and After | Component | homepage/compare-section | Home x1 |  |
| C214 | Certifications / Awards / Press Logos | Component | homepage/logo-section + logo-item | Home x1 | One logo list serves all three |
| C215 | Expert Recommendations | Not in wireframes | - | - | Not in the wireframes |
| C216 | Beauty Results | Not in wireframes | - | - | Not in the wireframes (before and after only) |
| C217 | Product Comparison | Not in wireframes | - | - | Not in the wireframes |
| C218 | Shop the Look | Component | homepage/look-section | Home x1 |  |
| C219 | Complete Your Routine Bundle | Page-specific | PDP routine bundle with checkboxes | PDP x1 |  |

Requested but not present in this group: Expert Recommendations; Beauty Results; Product Comparison.

## 12 Additional

| ID | Component | Status | Implementation | Found on (detections) | Notes |
|---|---|---|---|---|---|
| C220 | Page Hero / Intro Block | Page-specific | About, Story, Contact, Blog intros | PLP x1, About x1, Story x1, 404 x1 |  |
| C221 | Policy Page Body | Page-specific | four policy pages | Ship x1, Return x1, Privacy x1, Terms x1 |  |
| C222 | Policy Ask Panel (contact CTA) | Page-specific | policy pages end block | Ship x1, Return x1, Privacy x1, Terms x1 |  |
| C223 | Closing Call-to-Action Block | Page-specific | About, Story, FAQ, Blog empty | FAQ x1, About x1, Story x1, BlogL x1 |  |
| C224 | FAQ Question Group | Page-specific | FAQ accordion groups | FAQ x1 | Uses the accordion |
| C225 | Collection SEO Description | Component | plp/seo-block | PLP x1 | PLP description block |
| C226 | Share Block | Page-specific | Blog share | BlogA x1 |  |
| C227 | Custom Liquid Section | Component | homepage/custom-liquid-section | Home x1 | Merchant-supplied code slot |
| C228 | Contact Details List | Page-specific | Contact details | Contact x1 |  |
| C229 | Wireframe Width Panel | Page-specific | #wp review panel (wireframe only) | - | Wireframe-only; not a theme component |

## Implemented components (index)

All partial components that exist today, with their level, the group they belong to, and what they contain.

| Component | Level | Folder | Manifest | Contains |
|---|---|---|---|---|
| base/badge | base | base | yes |  |
| base/breadcrumb | base | base | yes |  |
| base/button | base | base | yes | base/icon |
| base/chip | base | base | yes |  |
| base/icon | base | base | yes |  |
| base/icon-button | base | base | yes | base/icon |
| base/input-field | base | base | yes |  |
| base/media | base | base | yes |  |
| base/message | base | base | yes | base/icon |
| base/price | base | base | yes |  |
| base/quantity | base | base | yes | base/icon |
| base/rating | base | base | yes | base/icon |
| base/section-heading | base | base | yes |  |
| common/scroller-controls | sub | common | yes | base/icon-button |
| header/account-button | sub | header | yes |  |
| header/cart-button | sub | header | yes | header/cart-button-content |
| header/cart-button-content | sub | header | yes | base/icon |
| header/logo | sub | header | yes |  |
| header/market-selector | sub | header | yes |  |
| header/mega-card | sub | header | yes | base/icon |
| header/mega-cards | sub | header | yes | header/mega-card |
| header/mega-column | sub | header | yes |  |
| header/mega-menu | sub | header | yes | base/icon, header/menus/skin, header/menus/makeup, header/menus/hair, header/menus/body |
| header/menu-button | sub | header | yes | base/icon |
| header/menus/body | sub | header | yes | header/mega-column, header/mega-cards |
| header/menus/hair | sub | header | yes | header/mega-column, header/mega-cards |
| header/menus/makeup | sub | header | yes | header/mega-column, header/mega-cards |
| header/menus/skin | sub | header | yes | header/mega-column, header/mega-cards |
| header/nav-close | sub | header | yes | base/icon |
| header/nav-item | sub | header | yes | base/icon, header/mega-menu |
| header/search-button | sub | header | yes | base/icon |
| header/site-header | main | header | yes | header/menu-button, header/search-button, header/logo, header/nav-close, header/nav-item, header/market-selector, header/account-button, header/cart-button |
| homepage/category-card | sub | homepage | yes | base/icon |
| homepage/category-section | main | homepage | yes | base/section-heading, homepage/category-card |
| homepage/collection-tab | sub | homepage | yes |  |
| homepage/collection-tabs | sub | homepage | yes | homepage/collection-tab |
| homepage/compare-layer | sub | homepage | yes |  |
| homepage/compare-section | main | homepage | yes | homepage/compare-layer, base/icon |
| homepage/concern-card | sub | homepage | yes |  |
| homepage/concern-section | main | homepage | yes | base/section-heading, homepage/group-title, homepage/concern-card, homepage/routine-step |
| homepage/custom-liquid-section | main | homepage | yes |  |
| homepage/featured-collection | main | homepage | yes | base/section-heading, homepage/collection-tabs, homepage/product-card, base/button |
| homepage/finder-card | sub | homepage | yes | base/chip, base/button |
| homepage/finder-section | main | homepage | yes | homepage/finder-card |
| homepage/footer-section | main | homepage | yes | layout/site-footer |
| homepage/gallery-section | main | homepage | yes | base/section-heading, homepage/gallery-tile |
| homepage/gallery-tile | sub | homepage | yes |  |
| homepage/group-title | sub | homepage | yes |  |
| homepage/hero-banner | main | homepage | yes | homepage/hero-media, homepage/hero-content, homepage/hero-featured-product |
| homepage/hero-content | sub | homepage | yes | base/button |
| homepage/hero-featured-product | sub | homepage | yes | base/icon |
| homepage/hero-media | sub | homepage | yes |  |
| homepage/ingredient-card | sub | homepage | yes |  |
| homepage/ingredient-section | main | homepage | yes | base/section-heading, homepage/ingredient-card, base/chip |
| homepage/logo-item | sub | homepage | yes |  |
| homepage/logo-section | main | homepage | yes | common/scroller-controls, homepage/logo-item |
| homepage/look-pin | sub | homepage | yes |  |
| homepage/look-row | sub | homepage | yes |  |
| homepage/look-section | main | homepage | yes | homepage/look-pin, homepage/look-row |
| homepage/newsletter-field | sub | homepage | yes |  |
| homepage/newsletter-perk | sub | homepage | yes | base/icon |
| homepage/newsletter-section | main | homepage | yes | homepage/newsletter-field, base/button, homepage/newsletter-perk |
| homepage/product-card | sub | homepage | yes | base/icon |
| homepage/promo-banner | main | homepage | yes | homepage/promo-media, homepage/promo-copy |
| homepage/promo-copy | sub | homepage | yes | base/button |
| homepage/promo-media | sub | homepage | yes |  |
| homepage/review-card | sub | homepage | yes | homepage/review-stars, base/icon |
| homepage/review-stars | sub | homepage | yes | base/icon |
| homepage/ritual-controls | sub | homepage | yes | base/icon-button |
| homepage/ritual-section | main | homepage | yes | homepage/ritual-controls, homepage/ritual-step |
| homepage/ritual-step | sub | homepage | yes | base/icon |
| homepage/routine-step | sub | homepage | yes |  |
| homepage/testimonials-section | main | homepage | yes | base/section-heading, common/scroller-controls, homepage/review-card |
| homepage/usp-item | sub | homepage | yes | base/icon |
| homepage/usp-row | main | homepage | yes | homepage/usp-item |
| homepage/video-copy | sub | homepage | yes | base/button |
| homepage/video-poster | sub | homepage | yes |  |
| homepage/video-section | main | homepage | yes | homepage/video-poster, homepage/video-copy |
| layout/announcement-arrow | sub | layout | yes | base/icon |
| layout/announcement-bar | main | layout | yes | layout/announcement-arrow, layout/announcement-dots |
| layout/announcement-dots | sub | layout | yes |  |
| layout/back-to-top | sub | layout | yes | base/icon |
| layout/footer-brand | sub | layout | yes | layout/social-link |
| layout/footer-column | sub | layout | yes | base/icon |
| layout/footer-payments | sub | layout | yes |  |
| layout/site-footer | main | layout | yes | layout/footer-brand, layout/footer-column, layout/footer-payments, layout/back-to-top |
| layout/social-link | sub | layout | yes | base/icon |
| plp/applied-chips | sub | plp | yes | base/icon |
| plp/collection-banner | main | plp | yes |  |
| plp/empty-state | sub | plp | yes | base/icon, base/button |
| plp/facet-groups | sub | plp | yes | base/icon |
| plp/filters-drawer | main | plp | yes | base/icon-button, base/button |
| plp/filters-sidebar | main | plp | yes | base/button |
| plp/pagination | sub | plp | yes | base/icon |
| plp/product-card | sub | plp | yes | base/badge, base/button, base/rating, base/price, base/icon |
| plp/product-grid | main | plp | yes | plp/empty-state |
| plp/promo-tile | sub | plp | yes | base/button |
| plp/quick-view-body | sub | plp | yes | base/rating, base/price, base/icon |
| plp/quick-view-drawer | main | plp | yes | base/icon-button, base/button |
| plp/seo-block | main | plp | yes |  |
| plp/subcollection-nav | main | plp | yes |  |
| plp/toolbar | main | plp | yes | base/button, base/icon |
