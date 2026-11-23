# Page-wise Component Breakdown

Every page, every section in document order, read from the rendered wireframes. A section is a named block of the page: shared chrome (announcement bar, header, footer), page sections and their nested sub-sections, landmarks, and overlays (dialogs and drawers). Counts are at 1440 px after the page scripts ran, so script-generated parts (PLP grid, PDP pickers, cart lines) are included.

"Main component" names the partial that renders the section today. Where it says *page markup*, the section is hand-written on that page and is not yet a component (see COMPONENT-AUDIT-REPORT.md).

## Page 01 – Homepage

- File: `01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html`
- Total sections: **20** (0 shared chrome, 20 page sections, 0 landmarks, 0 overlays, 0 unnamed content)

### Section 01 – Announcement Bar

- Type: page section, id `s01`, stage '01 · Orient'
- Main component: `layout/announcement-bar`
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region
- Responsive note (wireframe): Responsive: One wrapping line. Arrows from 600 px; dots below. Messages rotate with the arrows.

### Section 02 – Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer)

- Type: page section, id `s02`, stage '02 · Orient'
- Main component: `header/site-header`
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region; C201 Sticky Bar
- Responsive note (wireframe): Responsive: Below 1024 px: menu button, centred logo, account and cart, search on its own full-width row; menu links and country selector sit in the drawer. From 1024 px: links left, logo centred, search and icons right. No mega menu: the Beauty header is the centred-logo variant with four plain links; sub-categories appear as chips on the collection page. Sticky at every size.

### Section 03 – Hero Banner

- Type: page section, id `s03`, stage '03 · Attract'
- Main component: `homepage/hero-banner`
- Nested sub-components: `homepage/hero-media`, `homepage/hero-content`, `base/button`, `base/icon`, `homepage/hero-featured-product`
- Subsections (headings): h1: Radiance, Gently Nudged.
- Buttons and controls: button: editorial: Shop the edit / button: editorial: Find your routine
- Icons: arrow-right x2
- Cards and tiles: Hero Featured Product Card
- Images and media: placeholder: Campaign image / placeholder: Product
- Inputs and interactive elements: none
- Reusable component references: C005 Editorial Button; C023 Call-to-Action Button (page CTAs); C036 Arrow Icons (left, right); C084 Hero Image; C098 Hero Featured Product Card; C121 Heading H1
- Responsive note (wireframe): Responsive: from 1024 px the image runs up behind a transparent header (solid once the page scrolls) and fills the fold less 56 px, so the next section peeks (560 to 860 px); text in the calm left of the photograph, product card bottom right. 768 to 1023 px: a 520 to 640 px stage with the text inside it, the product row below. Below 768 px: a portrait stage (460 to 600 px, 64% of the screen) with the text inside it, the product row below, all in the first screen; short phones use a shorter stage and drop the line.

### Section 04 – Benefits / USP Row

- Type: page section, id `s04`, stage '04 · Attract'
- Main component: `homepage/usp-row`
- Nested sub-components: `homepage/usp-item`, `base/icon`
- Subsections (headings): none
- Buttons and controls: none
- Icons: heart x1, check-circle x1, location x1, arrow-left x1
- Cards and tiles: Benefit Card (USP item)
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C036 Arrow Icons (left, right); C038 Heart Icon; C043 Location Icon; C052 Check / Check-circle Icons; C107 Benefit Card (USP item); C212 Product Benefits
- Responsive note (wireframe): Responsive: 2 by 2 below 600 px, one row of four from 600 px.

### Section 05 – Shop by Category

- Type: page section, id `s05`, stage '05 · Discover'
- Main component: `homepage/category-section`
- Nested sub-components: `base/section-heading`, `homepage/category-card`, `base/icon`
- Subsections (headings): h2: Shop by category
- Buttons and controls: none
- Icons: arrow-right x4
- Cards and tiles: tile x4, Category Card
- Images and media: placeholder: Category photo: Skin care / placeholder: Category photo: Makeup / placeholder: Category photo: Hair / placeholder: Category photo: Body
- Inputs and interactive elements: none
- Reusable component references: C036 Arrow Icons (left, right); C083 Category Image; C099 Category Card; C122 Heading H2; C125 Section Heading
- Responsive note (wireframe): Responsive: Below 768 px: wide Skin care tile, two portrait tiles side by side, wide Body tile; the caption sits under each image. From 768 px: one tall tile and three smaller ones in an asymmetric grid, caption on the image.

### Section 06 – Featured Collection (Best Sellers / New Arrivals)

- Type: page section, id `s06`, stage '06 · Discover'
- Main component: `homepage/featured-collection`
- Nested sub-components: `base/section-heading`, `homepage/collection-tabs`, `homepage/collection-tab`, `homepage/product-card`, `base/icon`, `base/button`
- Subsections (headings): h2: Shop our favourites / h3: Face Cleanser / h3: Face Serum / h3: Moisturiser / h3: Lip Colour
- Buttons and controls: tab: Best sellers / tab: New launches / tab: Sets / button: editorial-outline: View all best sellers
- Icons: star x4
- Cards and tiles: Homepage Product Card
- Images and media: placeholder: Product photo: Face Cleanser (studio, soft shadow) / placeholder: Product photo: Face Serum (studio, soft shadow) / placeholder: Product photo: Moisturiser (studio, soft shadow) / placeholder: Product photo: Lip Colour (studio, soft shadow)
- Inputs and interactive elements: tabs x1
- Reusable component references: C004 Outline Button; C006 Editorial Outline Button; C017 View All Button; C039 Star / Rating Icon; C096 Homepage Product Card; C122 Heading H2; C123 Heading H3; C125 Section Heading; C146 Tabs
- Responsive note (wireframe): Responsive: Tabs wrap and centre. Products 2 columns below 768 px, 4 from 768 px. The whole card is the link to its product page. There is no Add to bag button and no image rollover on the card: Quick Add and second image on hover are No for Beauty in the revised PLP sheet (Beauty shades and sizes are chosen on the product page); Quick View is Yes for Beauty but only after the first listing. A key-attribute line sits under the size; shade dots appear only on products that have shades. Tabs switch the sample product set.

### Section 07 – Shop by Concern / Need / Routine

- Type: page section, id `s07`, stage '07 · Discover'
- Main component: `homepage/concern-section`
- Nested sub-components: `base/section-heading`, `homepage/group-title`, `homepage/concern-card`, `homepage/routine-step`
- Subsections (headings): h2: Shop by concern or routine
- Buttons and controls: none
- Icons: none
- Cards and tiles: tile x6, Concern Card
- Images and media: placeholder: Concern: Dryness / placeholder: Concern: Dullness / placeholder: Concern: Breakouts / placeholder: Concern: Sensitivity / placeholder: Concern: Uneven tone / placeholder: Concern: Texture
- Inputs and interactive elements: none
- Reusable component references: C101 Concern Card; C122 Heading H2; C125 Section Heading; C205 Skin Concern Selector; C211 Routine Steps
- Responsive note (wireframe): Responsive: Concern circles 3 columns below 1024 px, 6 from 1024 px. Routine steps are four compact numbered links that wrap and centre; they carry no images because the same four steps are shown with images in How to Use.

### Section 08 – Guided Finder / Quiz

- Type: page section, id `s08`, stage '08 · Decide'
- Main component: `homepage/finder-section`
- Nested sub-components: `homepage/finder-card`, `base/chip`, `base/button`, `base/icon`
- Subsections (headings): h2: Not sure where to start?
- Buttons and controls: chip: Dry / chip: Normal / chip: Oily / chip: Combination / chip: Sensitive / button: editorial-outline: Back / button: editorial: Next / button: editorial: See matching products
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C004 Outline Button; C005 Editorial Button; C006 Editorial Outline Button; C023 Call-to-Action Button (page CTAs); C028 Wizard Step Button (Next / Back); C122 Heading H2; C178 Chip; C179 Tag; C206 Skin Type Selector; C207 Guided Finder / Quiz
- Responsive note (wireframe): Responsive: Stacked below 768 px, two columns from 768 px. Chips wrap. Three-step flow works with JavaScript only.

### Section 09 – Shop the Look

- Type: page section, id `s09`, stage '09 · Decide'
- Main component: `homepage/look-section`
- Nested sub-components: `homepage/look-pin`, `homepage/look-row`
- Subsections (headings): h2: Shop the look
- Buttons and controls: other control: 1Foundation · ₹2,490 / other control: 2Blush · ₹1,660 / other control: 3Lip Colour · ₹1,328
- Icons: none
- Cards and tiles: Lookbook Card
- Images and media: placeholder: Look photo with product pins (editorial, natural light) / placeholder: Thumb
- Inputs and interactive elements: none
- Reusable component references: C087 Lifestyle / Look Image; C109 Lookbook Card; C122 Heading H2; C218 Shop the Look
- Responsive note (wireframe): Responsive: Stacked below 768 px (square image, then list), side by side from 768 px. From 1024 px the list card overlaps the image edge. Pins use percentages; a pin shows its product name on hover or focus.

### Section 10 – Ingredient / Material Spotlight

- Type: page section, id `s10`, stage '10 · Educate'
- Main component: `homepage/ingredient-section`
- Nested sub-components: `base/section-heading`, `homepage/ingredient-card`, `base/chip`
- Subsections (headings): h2: What is inside
- Buttons and controls: none
- Icons: none
- Cards and tiles: Ingredient Card
- Images and media: placeholder: Ingredient macro texture 1 / placeholder: Ingredient macro texture 2 / placeholder: Ingredient macro texture 3 / placeholder: Ingredient macro texture 4
- Inputs and interactive elements: none
- Reusable component references: C106 Ingredient Card; C122 Heading H2; C125 Section Heading; C178 Chip; C179 Tag; C208 Ingredient Information
- Responsive note (wireframe): Responsive: Circular ingredient images, 2 columns below 768 px, 4 from 768 px. Free-from chips wrap and centre.

### Section 11 – How to Use / Routine Steps

- Type: page section, id `s11`, stage '11 · Educate'
- Main component: `homepage/ritual-section`
- Nested sub-components: `homepage/ritual-controls`, `base/icon-button`, `base/icon`, `homepage/ritual-step`
- Subsections (headings): h2: A simple ritual, step by step / h3: Step 1. Cleanse / h3: Step 2. Treat / h3: Step 3. Moisturise / h3: Step 4. Protect
- Buttons and controls: icon button: Previous step / icon button: Next step
- Icons: arrow-left x1, arrow-right x5
- Cards and tiles: none
- Images and media: placeholder: Step image
- Inputs and interactive elements: none
- Reusable component references: C009 Circular Icon Button; C036 Arrow Icons (left, right); C122 Heading H2; C123 Heading H3; C192 Status / Live Region; C203 Scroller (horizontal carousel); C210 How to Use; C211 Routine Steps
- Responsive note (wireframe): Responsive: from 1024 px four cards in a row, steps 2 and 4 set 72 px lower. Below 1024 px a swipeable row with a counter and 44 px arrows: cards 44% wide from 600 px (about two and a quarter in view), 78% below 600 px (the next one peeking). Everything in a card is always visible.

### Section 12 – Video Section

- Type: page section, id `s12`, stage '12 · Educate'
- Main component: `homepage/video-section`
- Nested sub-components: `homepage/video-poster`, `homepage/video-copy`, `base/button`, `base/icon`
- Subsections (headings): h2: Watch: building a simple routine
- Buttons and controls: other control: ▶ / button: editorial-outline: Shop the products
- Icons: none
- Cards and tiles: none
- Images and media: placeholder: Video poster (loads on tap)
- Inputs and interactive elements: none
- Reusable component references: C004 Outline Button; C006 Editorial Outline Button; C023 Call-to-Action Button (page CTAs); C029 Play Video Button; C089 Video Thumbnail (poster); C122 Heading H2
- Responsive note (wireframe): Responsive: Stacked below 768 px with the text card overlapping the poster; from 768 px the card overlaps the poster edge. 16:9 poster scales with width.

### Section 13 – Before & After

- Type: page section, id `s13`, stage '13 · Trust'
- Main component: `homepage/compare-section`
- Nested sub-components: `homepage/compare-layer`, `base/icon`
- Subsections (headings): none
- Buttons and controls: none
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: placeholder: Before image / placeholder: After image
- Inputs and interactive elements: range: Before and after comparison: left shows before, ri
- Reusable component references: C035 Chevron Icons (up, down, left, right); C071 Range Slider; C088 Before / After Image; C213 Before and After
- Responsive note (wireframe): Responsive: the frame spans the full page width with no padding and fits one screen: 1:1 below 600 px, 16:9 from 600 px, 21:9 from 1024 px (capped at 76% of the screen height). The divider starts at 50%. BEFORE sits bottom left on the Before layer and AFTER bottom right on the After layer; each fades out once the divider reaches it, so neither is ever cut in half.

### Section 14 – Testimonials / Customer Reviews

- Type: page section, id `s14`, stage '14 · Trust'
- Main component: `homepage/testimonials-section`
- Nested sub-components: `base/section-heading`, `common/scroller-controls`, `base/icon-button`, `base/icon`, `homepage/review-card`, `homepage/review-stars`
- Subsections (headings): h2: What customers say
- Buttons and controls: icon button: Previous reviews / icon button: Next reviews
- Icons: arrow-left x1, arrow-right x7, star x30
- Cards and tiles: Review Card, Testimonial Card
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C009 Circular Icon Button; C036 Arrow Icons (left, right); C039 Star / Rating Icon; C102 Review Card; C103 Testimonial Card; C122 Heading H2; C125 Section Heading; C203 Scroller (horizontal carousel)
- Responsive note (wireframe): Responsive: one horizontal scroll row with previous and next buttons and scroll snap (swipe or trackpad on touch). One card 85% wide below 600 px so the next one peeks, two from 600 px, three from 1024 px. All cards share one size and style, so more reviews can be added without changing the layout.

### Section 15 – Customer Photo Gallery

- Type: page section, id `s15`, stage '15 · Trust'
- Main component: `homepage/gallery-section`
- Nested sub-components: `base/section-heading`, `homepage/gallery-tile`
- Subsections (headings): h2: Customer photos
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: placeholder: Customer photo 1 / placeholder: Customer photo 2 / placeholder: Customer photo 3 / placeholder: Customer photo 4 / placeholder: Customer photo 5 / placeholder: Customer photo 6
- Inputs and interactive elements: none
- Reusable component references: C091 Image Gallery; C095 Customer Photo Tile; C122 Heading H2; C125 Section Heading
- Responsive note (wireframe): Responsive: Mosaic: 2 columns below 768 px (wide first and last), 3 columns from 768 px with one large image.

### Section 16 – Logo List (Awards, Certifications, Press, Partner Brands)

- Type: page section, id `s16`, stage '16 · Trust'
- Main component: `homepage/logo-section`
- Nested sub-components: `common/scroller-controls`, `base/icon-button`, `base/icon`, `homepage/logo-item`
- Subsections (headings): none
- Buttons and controls: icon button: Previous logos / icon button: Next logos
- Icons: arrow-left x1, arrow-right x1
- Cards and tiles: none
- Images and media: placeholder: Certification logo / placeholder: Award logo / placeholder: Publication logo
- Inputs and interactive elements: none
- Reusable component references: C009 Circular Icon Button; C036 Arrow Icons (left, right); C203 Scroller (horizontal carousel); C214 Certifications / Awards / Press Logos
- Responsive note (wireframe): Responsive: from 1024 px label, logos and arrows share one line (6 logos per view). Below 1024 px the label and arrows sit above the row: 4 logos per view from 600 px, about 2.5 on phones with swipe.

### Section 17 – Promotional / Campaign Banner

- Type: page section, id `s17`, stage '17 · Convert'
- Main component: `homepage/promo-banner`
- Nested sub-components: `homepage/promo-media`, `homepage/promo-copy`, `base/button`, `base/icon`
- Subsections (headings): h2: Gift sets for every routine
- Buttons and controls: button: editorial: Shop gift sets
- Icons: none
- Cards and tiles: Promotional Card
- Images and media: placeholder: Campaign image: gift set styled on a soft surface
- Inputs and interactive elements: none
- Reusable component references: C005 Editorial Button; C023 Call-to-Action Button (page CTAs); C085 Banner Image; C110 Promotional Card; C122 Heading H2
- Responsive note (wireframe): Responsive: Image above, text card overlapping it, below 768 px. From 768 px the card overlaps the image from the left.

### Section 18 – Custom Liquid Section

- Type: page section, id `s18`, stage '18 · Convert'
- Main component: `homepage/custom-liquid-section`
- Nested sub-components: none
- Subsections (headings): none
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C227 Custom Liquid Section
- Responsive note (wireframe): Responsive: Takes no space on the storefront while it is empty. In the theme editor it shows as this dashed slot at container width.

### Section 19 – Newsletter

- Type: page section, id `s19`, stage '19 · Convert'
- Main component: `homepage/newsletter-section`
- Nested sub-components: `homepage/newsletter-field`, `base/button`, `base/icon`, `homepage/newsletter-perk`
- Subsections (headings): h2: Join the list
- Buttons and controls: button: editorial: Subscribe
- Icons: arrow-right x1, check x3
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: email: Email address
- Reusable component references: C005 Editorial Button; C020 Form Submit Button; C021 Newsletter Subscribe Button; C036 Arrow Icons (left, right); C052 Check / Check-circle Icons; C063 Email Input; C074 Newsletter Form; C077 Input Label; C122 Heading H2; C133 Label Text; C192 Status / Live Region
- Responsive note (wireframe): Responsive: from 1024 px heading left (columns 1 to 5) and form right (columns 7 to 12). Below 1024 px heading, then form. The field and button sit on one line from 600 px and stack below.

### Section 20 – Footer (navigation, about, contact, support, shipping & returns, policies, social, payment icons, trust line, back to top)

- Type: page section, id `s20`, stage '20 · Close'
- Main component: `layout/site-footer`
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu
- Responsive note (wireframe): Responsive: Link groups are tap-to-open rows below 768 px, four columns from 768 px. Back to top is a full-width button below 600 px.

## Page 02 – PLP

- File: `02-NUDGE-Beauty-PLP-Wireframe/PLP.html`
- Total sections: **13** (3 shared chrome, 6 page sections, 2 landmarks, 2 overlays, 0 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – Collection Banner

- Type: page section, id `banner`, stage '01 · Orient'
- Main component: `plp/collection-banner`
- Nested sub-components: none
- Subsections (headings): h1: Skin care
- Buttons and controls: none
- Icons: eye x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C054 Eye Icon; C085 Banner Image; C121 Heading H1; C142 Breadcrumb; C220 Page Hero / Intro Block
- Responsive note (wireframe): Responsive: text only below 1024 px (setting: show image on mobile, default off) so products start early; from 1024 px the image fills the right half (placeholder, 16:9, subject right). Breadcrumb shows parent and current page below 600 px.

### Section 04 – Sub-collection Links

- Type: page section, id `subnav`, stage '02 · Navigate'
- Main component: `plp/subcollection-nav`
- Nested sub-components: none
- Subsections (headings): none
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C149 Sub-collection Links; C178 Chip
- Responsive note (wireframe): Responsive: one scrolling line below 600 px (the cut-off chip shows it scrolls), wraps from 600 px. Current page is tint, thick border and bold.

### Section 05 – Filters and Product Grid

- Type: page section
- Main component: *page markup (not a component yet)*
- Nested patterns found: Tertiary / Text Button; Clear Filter Button; Chevron Icons (up, down, left, right); Checkbox; Filter Inputs (facet checkboxes, price range); Input Label; Accordion; Size Selector; Color Swatch
- Subsections (headings): h2: Filters / summary: Skin concern / legend: Skin concern / summary: Skin type / legend: Skin type / summary: Product type / legend: Product type / summary: Key ingredients / legend: Key ingredients / summary: Benefits / legend: Benefits / summary: Shade / summary: Size / legend: Size / summary: Price / summary: Availability / legend: Availability
- Buttons and controls: button: text: Clear all
- Icons: chevron-down x9
- Cards and tiles: choice x34, swatch-chip x5
- Images and media: none
- Inputs and interactive elements: checkbox: Dryness9 / checkbox: Dullness7 / checkbox: Breakouts3 / checkbox: Sensitivity4 / checkbox: Uneven tone5 / checkbox: Texture7 / checkbox: Dry16 / checkbox: Normal16 / checkbox: Oily10 / checkbox: Combination13 / checkbox: Sensitive9 / checkbox: Cleanser5 / ... +18 more / accordion x10
- Reusable component references: C003 Tertiary / Text Button; C015 Clear Filter Button; C035 Chevron Icons (up, down, left, right); C068 Checkbox; C075 Filter Inputs (facet checkboxes, price range); C077 Input Label; C122 Heading H2; C133 Label Text; C147 Accordion; C158 Size Selector; C159 Color Swatch

### Section 06 – Filters

- Type: landmark, id `faceted-sidebar`, stage '03 · Narrow'
- Main component: `plp/filters-sidebar`
- Nested sub-components: `base/button`, `base/icon`
- Subsections (headings): h2: Filters / summary: Skin concern / legend: Skin concern / summary: Skin type / legend: Skin type / summary: Product type / legend: Product type / summary: Key ingredients / legend: Key ingredients / summary: Benefits / legend: Benefits / summary: Shade / summary: Size / legend: Size / summary: Price / summary: Availability / legend: Availability
- Buttons and controls: button: text: Clear all
- Icons: chevron-down x9
- Cards and tiles: choice x34, swatch-chip x5
- Images and media: none
- Inputs and interactive elements: checkbox: Dryness9 / checkbox: Dullness7 / checkbox: Breakouts3 / checkbox: Sensitivity4 / checkbox: Uneven tone5 / checkbox: Texture7 / checkbox: Dry16 / checkbox: Normal16 / checkbox: Oily10 / checkbox: Combination13 / checkbox: Sensitive9 / checkbox: Cleanser5 / ... +18 more / accordion x10
- Reusable component references: C001 Primary Button; C003 Tertiary / Text Button; C008 Icon Button; C014 Apply Filter Button; C015 Clear Filter Button; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C068 Checkbox; C075 Filter Inputs (facet checkboxes, price range); C077 Input Label; C122 Heading H2; C133 Label Text; C147 Accordion; C148 Sidebar Navigation (filter sidebar); C158 Size Selector; C159 Color Swatch; C189 Modal Dialog; C190 Drawer
- Responsive note (wireframe): Responsive: left column from 768 px (about 240 px wide, scrolls with the page); below 768 px the same groups open in a left slide-in drawer with a sticky Apply filters button.

### Section 07 – Sort, Product Count and Applied Filters

- Type: page section, id `toolbar`, stage '04 · Orient'
- Main component: `plp/toolbar`
- Nested sub-components: `base/button`, `base/icon`
- Subsections (headings): none
- Buttons and controls: button: secondary: Filters / button: text: Clear all
- Icons: filter x1, chevron-down x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: select: Sort productsselect x1
- Reusable component references: C002 Secondary Button; C003 Tertiary / Text Button; C004 Outline Button; C015 Clear Filter Button; C024 Filters Open Button; C035 Chevron Icons (up, down, left, right); C040 Filter Icon; C067 Select Dropdown; C077 Input Label; C133 Label Text; C192 Status / Live Region
- Responsive note (wireframe): Responsive: from 768 px count left and sort right (filters are in the sidebar). Below 768 px Filters and Sort sit side by side at 48 px with the count beneath. Applied chips stay on one line below 600 px.

### Section 08 – Product Grid

- Type: page section, id `grid-section`, stage '05 · Choose'
- Main component: `plp/product-grid`
- Nested sub-components: `plp/empty-state`, `base/icon`, `base/button`
- Subsections (headings): h2: Products / h3: Face Cleanser / h3: Gel Cleanser / h3: Cream Cleanser / h3: Balm Cleanser / h3: Face Serum / h3: Hydrating Serum / h3: Brightening Serum / h3: Calming Serum / h3: Gifts for every routine / h3: Smoothing Serum / h3: Moisturiser / h3: No products match these filters
- Buttons and controls: button: secondary: Quick view (x18) / button: secondary: Sold out / button: secondary: Shop gift sets / button: primary: Clear all filters
- Icons: star x40, warning x1, search x1, chevron-left x1, chevron-right x1
- Cards and tiles: product-card x10, pc-media x10, PLP Product Card
- Images and media: none
- Inputs and interactive elements: pagination x2
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C013 Quick View Button; C015 Clear Filter Button; C023 Call-to-Action Button (page CTAs); C025 Disabled / Sold-out Button; C030 Search Icon; C035 Chevron Icons (up, down, left, right); C039 Star / Rating Icon; C053 Warning Icon; C097 PLP Product Card; C122 Heading H2; C123 Heading H3; C130 Price Typography; C131 Discount Text; C145 Pagination; C150 Product Price; C151 Compare-at Price; C152 Discount Badge; C153 Bestseller Badge; C154 New Badge; C155 Product Rating; C156 Review Count; C163 Stock Status; C177 Badge; C178 Chip
- Responsive note (wireframe): Responsive: 2 columns below 600 px, 3 from 600, then beside the sidebar 2 from 768, 3 from 1024, 4 from 1280. Promo tile spans the row on phones, two columns from 600 px. Numbered pagination at every width; Previous and Next show icons only on phones.

### Section 09 – Promotion

- Type: landmark
- Main component: `plp/promo-tile`
- Nested sub-components: `base/button`, `base/icon`
- Subsections (headings): h3: Gifts for every routine
- Buttons and controls: button: secondary: Shop gift sets
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C123 Heading H3

### Section 10 – Collection SEO Description

- Type: page section, id `seo`, stage '06 · Support'
- Main component: `plp/seo-block`
- Nested sub-components: none
- Subsections (headings): h2: About our skin care
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C122 Heading H2; C225 Collection SEO Description
- Responsive note (wireframe): Responsive: reading width capped at the Design System text measure; same on every device.

### Section 11 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

### Section 12 – Filters

- Type: overlay (dialog or drawer), id `faceted-drawer`
- Main component: `plp/filters-drawer`
- Nested sub-components: `base/icon-button`, `base/icon`, `base/button`
- Subsections (headings): h2: Filters
- Buttons and controls: icon button: Close filters / button: text: Clear all / button: primary: Apply filters (24)
- Icons: close x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C003 Tertiary / Text Button; C008 Icon Button; C014 Apply Filter Button; C015 Clear Filter Button; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C068 Checkbox; C075 Filter Inputs (facet checkboxes, price range); C077 Input Label; C122 Heading H2; C133 Label Text; C147 Accordion; C148 Sidebar Navigation (filter sidebar); C158 Size Selector; C159 Color Swatch; C189 Modal Dialog; C190 Drawer

### Section 13 – Quick view

- Type: overlay (dialog or drawer), id `quick-view`
- Main component: `plp/quick-view-drawer`
- Nested sub-components: `base/icon-button`, `base/icon`, `base/button`
- Subsections (headings): h2: Quick view
- Buttons and controls: icon button: Close quick view / button: primary: Add to bag / button: text: View full details
- Icons: close x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C003 Tertiary / Text Button; C008 Icon Button; C011 Add to Cart Button; C013 Quick View Button; C017 View All Button; C034 Close Icon; C122 Heading H2; C161 Quick View Panel; C189 Modal Dialog; C190 Drawer

## Page 03 – PDP

- File: `03-NUDGE-Beauty-PDP-Wireframe/PDP.html`
- Total sections: **17** (3 shared chrome, 13 page sections, 0 landmarks, 1 overlays, 0 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – Breadcrumb

- Type: page section, stage '01 · Orient'
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): none
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C142 Breadcrumb
- Responsive note (wireframe): Responsive: parent and current page on one line below 600 px, the current page truncated with an ellipsis; the full trail from 600 px.

### Section 04 – Product: gallery and purchase panel

- Type: page section, id `product`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Icon Button; Play Video Button; Chevron Icons (up, down, left, right); Play Icon; Zoom-in Icon; Product Image; Thumbnail Image; Image Gallery; Image Slider / Carousel; Placeholder Image; Product Gallery; Status / Live Region
- Subsections (headings): none
- Buttons and controls: icon button: Previous image / icon button: Next image / icon button: Zoom image / other control: Show image 1: Pack shot / other control: Show image 2: Texture / other control: Show image 3: Application / other control: Show image 4: Ingredients / icon button: Show image 5: Video / other control: Go to image 1: Pack shot / other control: Go to image 2: Texture / other control: Go to image 3: Application / other control: Go to image 4: Ingredients / other control: Go to image 5: Video
- Icons: play x2, chevron-left x1, chevron-right x1, zoom-in x1
- Cards and tiles: none
- Images and media: 10 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C008 Icon Button; C029 Play Video Button; C035 Chevron Icons (up, down, left, right); C056 Play Icon; C057 Zoom-in Icon; C082 Product Image; C086 Thumbnail Image; C091 Image Gallery; C092 Image Slider / Carousel; C094 Placeholder Image; C168 Product Gallery; C192 Status / Live Region

### Section 05 – Product information and purchase

- Type: page section, id `product-info`, stage '03 · Decide'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Star / Rating Icon; Product Price; Compare-at Price; Product Rating; Review Count
- Subsections (headings): h1: Tinted Moisturiser
- Buttons and controls: none
- Icons: star x5
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C039 Star / Rating Icon; C121 Heading H1; C130 Price Typography; C150 Product Price; C151 Compare-at Price; C155 Product Rating; C156 Review Count
- Responsive note (wireframe): Responsive: one column on phones with the sticky bottom bar for the action; two columns from 768 px (information at 50%), 7 / 5 from 1024 px. Shade tiles wrap; size options fill the width.

### Section 06 – Variant picker

- Type: page section, id `variants`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Warning Icon; Radio Button; Form Validation Message; Input Label; Product Variant Selector; Size Selector; Alert / Message; Error Message
- Subsections (headings): legend: ShadeSelect a shade / legend: Size50 ml
- Buttons and controls: none
- Icons: warning x1
- Cards and tiles: tile x5, opt x3
- Images and media: none
- Inputs and interactive elements: radio: Rose / radio: Berry (sold out) / radio: Peach / radio: Mauve / radio: Coral / radio: 30 ml (sold out)₹1,826 / radio: 50 ml₹2,656 / radio: Duo pack₹4,814Save ₹498
- Reusable component references: C053 Warning Icon; C069 Radio Button; C076 Form Validation Message; C077 Input Label; C133 Label Text; C157 Product Variant Selector; C158 Size Selector; C182 Alert / Message; C184 Error Message

### Section 07 – Selling plan picker

- Type: page section, id `plan`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Radio Button; Input Label; Selling Plan Picker
- Subsections (headings): legend: Purchase options
- Buttons and controls: none
- Icons: none
- Cards and tiles: choice x2
- Images and media: none
- Inputs and interactive elements: radio: One-time purchase / radio: Subscribe and saveEvery 8 weeks, cancel any time. 
- Reusable component references: C069 Radio Button; C077 Input Label; C133 Label Text; C166 Selling Plan Picker

### Section 08 – Buy buttons

- Type: page section, id `buy`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Add to Cart Button; Shopping Bag / Cart Icon; Plus / Minus Icons; Check / Check-circle Icons; Text Input; Quantity Input; Quantity Selector; Buy Buttons Group; Alert / Message; Success Message; Status / Live Region
- Subsections (headings): none
- Buttons and controls: quantity control: Decrease quantity / quantity control: Increase quantity / button: primary: Add to bag
- Icons: minus x1, plus x1, bag x1, check-circle x2
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: text: Quantityquantity x1
- Reusable component references: C001 Primary Button; C011 Add to Cart Button; C031 Shopping Bag / Cart Icon; C037 Plus / Minus Icons; C052 Check / Check-circle Icons; C062 Text Input; C072 Quantity Input; C160 Quantity Selector; C167 Buy Buttons Group; C182 Alert / Message; C183 Success Message; C192 Status / Live Region

### Section 09 – Delivery, returns, pickup and trust

- Type: page section, id `assure`
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): none
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C164 Delivery Information

### Section 10 – Product details

- Type: page section, id `details`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Chevron Icons (up, down, left, right); Accordion; Product Details Accordion
- Subsections (headings): summary: Description / summary: How to use / summary: Full ingredients / summary: Suitability and safety / summary: Certifications and claims
- Buttons and controls: none
- Icons: chevron-down x5
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: accordion x5
- Reusable component references: C035 Chevron Icons (up, down, left, right); C147 Accordion; C165 Product Details Accordion

### Section 11 – Product storytelling

- Type: page section, id `story`, stage '04 · Story'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Placeholder Image; Ingredient Benefits
- Subsections (headings): h2: Hydration, a sheer tint and nothing you do not need / h3: Hyaluronic acid / h3: Squalane / h3: Niacinamide
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: 1 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C094 Placeholder Image; C122 Heading H2; C123 Heading H3; C209 Ingredient Benefits
- Responsive note (wireframe): Responsive: image beside text from 1024 px, image first then text below.

### Section 12 – Complete your routine

- Type: page section, id `routine`, stage '05 · Complete'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Add to Cart Button; Check / Check-circle Icons; Checkbox; Input Label; Placeholder Image; Recommendation Card; Product Price; Alert / Message; Success Message; Status / Live Region; Complete Your Routine Bundle
- Subsections (headings): h2: Pairs well with
- Buttons and controls: button: primary: Add selected to bag
- Icons: check-circle x1
- Cards and tiles: Recommendation Card
- Images and media: 3 labelled placeholder(s)
- Inputs and interactive elements: checkbox: CleanserFace Cleanser₹1,494 / checkbox: SerumFace Serum₹2,656 / checkbox: Sun careDaily Sunscreen₹2,158
- Reusable component references: C001 Primary Button; C011 Add to Cart Button; C052 Check / Check-circle Icons; C068 Checkbox; C077 Input Label; C094 Placeholder Image; C111 Recommendation Card; C122 Heading H2; C130 Price Typography; C133 Label Text; C150 Product Price; C182 Alert / Message; C183 Success Message; C192 Status / Live Region; C219 Complete Your Routine Bundle
- Responsive note (wireframe): Responsive: list and summary side by side from 1024 px; stacked below.

### Section 13 – Reviews

- Type: page section, id `reviews`, stage '06 · Trust'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Star / Rating Icon; Review Card; Product Rating; Review Count
- Subsections (headings): h2: Customer reviews
- Buttons and controls: none
- Icons: star x5
- Cards and tiles: Review Card
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C039 Star / Rating Icon; C102 Review Card; C122 Heading H2; C155 Product Rating; C156 Review Count
- Responsive note (wireframe): Responsive: summary beside the slot from 1024 px, stacked below.

### Section 14 – Related products

- Type: page section, id `related`, stage '07 · Discover'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Star / Rating Icon; Product Image; Placeholder Image; Related Product Card; Product Price; Product Rating; Review Count
- Subsections (headings): h2: Related products / h3: Hydrating Serum / h3: Gel Moisturiser / h3: Barrier Cream / h3: Eye Cream
- Buttons and controls: none
- Icons: star x20
- Cards and tiles: Related Product Card
- Images and media: 4 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C039 Star / Rating Icon; C082 Product Image; C094 Placeholder Image; C112 Related Product Card; C122 Heading H2; C123 Heading H3; C130 Price Typography; C150 Product Price; C155 Product Rating; C156 Review Count
- Responsive note (wireframe): Responsive: 2 columns on phones, 3 from 600 px, 4 from 1024 px (Design System grid tokens).

### Section 15 – Product FAQ

- Type: page section, id `faq`, stage '08 · Answer'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Chevron Icons (up, down, left, right); Accordion
- Subsections (headings): h2: Frequently asked / summary: Can I use it every day? / summary: How do I choose my shade? / summary: Is it suitable for sensitive skin?
- Buttons and controls: none
- Icons: chevron-down x3
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: accordion x4
- Reusable component references: C035 Chevron Icons (up, down, left, right); C122 Heading H2; C147 Accordion
- Responsive note (wireframe): Responsive: reading width capped; 44 px headers on every device.

### Section 16 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

### Section 17 – Product images

- Type: overlay (dialog or drawer), id `zoom`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Icon Button; Close Icon; Chevron Icons (up, down, left, right); Image Slider / Carousel; Placeholder Image; Product Zoom Viewer; Modal Dialog; Drawer; Status / Live Region
- Subsections (headings): h2: Product images
- Buttons and controls: icon button: Close image viewer / icon button: Previous image / icon button: Next image
- Icons: close x1, chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: 1 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C008 Icon Button; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C092 Image Slider / Carousel; C094 Placeholder Image; C122 Heading H2; C169 Product Zoom Viewer; C189 Modal Dialog; C190 Drawer; C192 Status / Live Region

## Page 04 – Cart

- File: `04-NUDGE-Beauty-Cart-Wireframe/Cart_Page.html`
- Total sections: **9** (3 shared chrome, 6 page sections, 0 landmarks, 0 overlays, 0 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – Cart

- Type: page section, id `full`, stage '01 · Review'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Free Shipping Progress; Progress Indicator; Status / Live Region
- Subsections (headings): h1: Cart
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C121 Heading H1; C176 Free Shipping Progress; C188 Progress Indicator; C192 Status / Live Region
- Responsive note (wireframe): Responsive: title and link share a row; the link wraps under the title when narrow.

### Section 04 – Cart lines

- Type: page section, id `c-linescol`, stage '02 · Lines'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Remove Line Button; Plus / Minus Icons; Text Input; Quantity Input; Placeholder Image; Cart Item Card; Product Price; Compare-at Price; Quantity Selector; Cart Line Item
- Subsections (headings): none
- Buttons and controls: quantity control: Decrease quantity (x3) / quantity control: Increase quantity (x3) / other control: Remove (x3)
- Icons: minus x3, plus x3
- Cards and tiles: Cart Item Card
- Images and media: 3 labelled placeholder(s)
- Inputs and interactive elements: text: Quantityquantity x3
- Reusable component references: C027 Remove Line Button; C037 Plus / Minus Icons; C062 Text Input; C072 Quantity Input; C094 Placeholder Image; C114 Cart Item Card; C130 Price Typography; C150 Product Price; C151 Compare-at Price; C160 Quantity Selector; C170 Cart Line Item
- Responsive note (wireframe): Responsive: one row per line from 768 px (image, details, quantity, total); below that the image sits beside the details with the quantity and Remove under them.

### Section 05 – Order note and gift message

- Type: page section, id `c-note`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Chevron Icons (up, down, left, right); Text Input; Textarea; Input Label; Order Note Field
- Subsections (headings): summary: Add a note or gift message
- Buttons and controls: none
- Icons: chevron-down x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: textarea: Order note or gift message
- Reusable component references: C035 Chevron Icons (up, down, left, right); C062 Text Input; C073 Textarea; C077 Input Label; C081 Order Note Field; C133 Label Text

### Section 06 – Cart upsell

- Type: page section, id `c-up`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Secondary Button; Outline Button; Add to Cart Button; Placeholder Image; Recommendation Card; Cart Upsell
- Subsections (headings): h2: Add to your order
- Buttons and controls: button: secondary: Add (x2)
- Icons: none
- Cards and tiles: Recommendation Card
- Images and media: 2 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C002 Secondary Button; C004 Outline Button; C011 Add to Cart Button; C094 Placeholder Image; C111 Recommendation Card; C122 Heading H2; C173 Cart Upsell

### Section 07 – Order summary

- Type: page section, id `c-sum`, stage '03 · Pay'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Checkout Button; Security / Lock Icon; Cart Summary
- Subsections (headings): h2: Order summary
- Buttons and controls: button: primary: Checkout
- Icons: lock x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C018 Checkout Button; C049 Security / Lock Icon; C122 Heading H2; C171 Cart Summary; C197 Divider
- Responsive note (wireframe): Responsive: sticky beside the lines from 1024 px; below that it follows the lines, with a sticky checkout bar on phones.

### Section 08 – Empty cart

- Type: page section, id `empty`, stage '04 · Empty'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Continue Shopping Button; Call-to-Action Button (page CTAs); Chip; Empty State
- Subsections (headings): h1: Your cart is empty
- Buttons and controls: button: primary: Continue shopping
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C019 Continue Shopping Button; C023 Call-to-Action Button (page CTAs); C121 Heading H1; C178 Chip; C185 Empty State
- Responsive note (wireframe): Responsive: centred column, chips wrap.

### Section 09 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

## Page 05 – Cart Drawer

- File: `05-NUDGE-Beauty-Cart-Drawer-Wireframe/Cart_Drawer_Wireframe_v1.html`
- Total sections: **5** (3 shared chrome, 0 page sections, 0 landmarks, 1 overlays, 1 unnamed content)
- This is not a page: it is the cart drawer dialog shown over a page. It is audited as the page that hosts it.

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €) / other control: Cart3
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

### Section 04 – Cart 3 items

- Type: overlay (dialog or drawer), id `cart-drawer`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Icon Button; Add to Cart Button; Checkout Button; Continue Shopping Button; Call-to-Action Button (page CTAs); Remove Line Button; Close Icon; Plus / Minus Icons; Security / Lock Icon; Text Input; Quantity Input; Placeholder Image; Cart Item Card; Product Price; Compare-at Price; Quantity Selector; Cart Line Item; Cart Drawer; Free Shipping Progress; Chip; Progress Indicator; Modal Dialog; Drawer; Status / Live Region
- Subsections (headings): h2: Cart 3 items / h2: Add to your order
- Buttons and controls: icon button: Close cart / quantity control: Decrease quantity (x3) / quantity control: Increase quantity (x3) / other control: Remove (x3) / button: secondary: Add / button: primary: Continue shopping / button: primary: Checkout
- Icons: close x1, minus x3, plus x3, lock x1
- Cards and tiles: Cart Item Card
- Images and media: 4 labelled placeholder(s)
- Inputs and interactive elements: text: Quantityquantity x3
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C008 Icon Button; C011 Add to Cart Button; C018 Checkout Button; C019 Continue Shopping Button; C023 Call-to-Action Button (page CTAs); C027 Remove Line Button; C034 Close Icon; C037 Plus / Minus Icons; C049 Security / Lock Icon; C062 Text Input; C072 Quantity Input; C094 Placeholder Image; C114 Cart Item Card; C122 Heading H2; C130 Price Typography; C150 Product Price; C151 Compare-at Price; C160 Quantity Selector; C170 Cart Line Item; C172 Cart Drawer; C176 Free Shipping Progress; C178 Chip; C188 Progress Indicator; C189 Modal Dialog; C190 Drawer; C192 Status / Live Region

### Section 05 – Unnamed content in main

- Type: unnamed content in main
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): h1: Page behind the drawer
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: 3 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C094 Placeholder Image; C121 Heading H1

## Page 06 – Contact

- File: `06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html`
- Total sections: **8** (3 shared chrome, 3 page sections, 1 landmarks, 0 overlays, 1 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – Contact form

- Type: page section, id `form-col`, stage '02 · Ask'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Tertiary / Text Button; Outline Button; Continue Shopping Button; Form Submit Button; Call-to-Action Button (page CTAs); Chevron Icons (up, down, left, right); Check / Check-circle Icons; Warning Icon; Text Input; Email Input; Phone Input; Select Dropdown; Textarea; Form Validation Message; Input Label; Contact Form; Alert / Message; Error Message; Status / Live Region
- Subsections (headings): h2: Send us a message / h3: Thanks, your message is on its way
- Buttons and controls: button: secondary: Read the FAQ / button: text: Continue shopping / button: primary: Send message
- Icons: warning x1, check-circle x1, chevron-down x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: text: Name / email: Email / tel: Phone (optional) / select: What is this about? / text: Order number (optional) / textarea: Message / select x1
- Reusable component references: C001 Primary Button; C002 Secondary Button; C003 Tertiary / Text Button; C004 Outline Button; C019 Continue Shopping Button; C020 Form Submit Button; C023 Call-to-Action Button (page CTAs); C035 Chevron Icons (up, down, left, right); C052 Check / Check-circle Icons; C053 Warning Icon; C062 Text Input; C063 Email Input; C066 Phone Input; C067 Select Dropdown; C073 Textarea; C076 Form Validation Message; C077 Input Label; C079 Contact Form; C122 Heading H2; C123 Heading H3; C133 Label Text; C182 Alert / Message; C184 Error Message; C192 Status / Live Region
- Responsive note (wireframe): Responsive: name and email share a row from 600 px; everything stacks on phones; the button is full width on phones.

### Section 04 – Other ways to reach us

- Type: landmark
- Main component: *page markup (not a component yet)*
- Nested patterns found: Arrow Icons (left, right); Location Icon; Phone Icon; Email Icon; Clock Icon
- Subsections (headings): h2: Other ways to reach us / h2: Quick answers
- Buttons and controls: none
- Icons: mail x1, phone x1, clock x1, location x1, arrow-right x3
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C036 Arrow Icons (left, right); C043 Location Icon; C044 Phone Icon; C045 Email Icon; C046 Clock Icon; C122 Heading H2

### Section 05 – Contact details

- Type: page section, id `details`, stage '03 · Reach'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Location Icon; Phone Icon; Email Icon; Clock Icon; Contact Detail Card
- Subsections (headings): h2: Other ways to reach us
- Buttons and controls: none
- Icons: mail x1, phone x1, clock x1, location x1
- Cards and tiles: Contact Detail Card
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C043 Location Icon; C044 Phone Icon; C045 Email Icon; C046 Clock Icon; C115 Contact Detail Card; C122 Heading H2; C228 Contact Details List
- Responsive note (wireframe): Responsive: sits beside the form from 1024 px, under it below that.

### Section 06 – Quick answers

- Type: page section, id `quick`, stage '04 · Deflect'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Arrow Icons (left, right); Quick Answer Card
- Subsections (headings): h2: Quick answers
- Buttons and controls: none
- Icons: arrow-right x3
- Cards and tiles: Quick Answer Card
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C036 Arrow Icons (left, right); C120 Quick Answer Card; C122 Heading H2
- Responsive note (wireframe): Responsive: stacked list at every width.

### Section 07 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

### Section 08 – Unnamed content in main

- Type: unnamed content in main
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): h1: Contact us
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C121 Heading H1; C142 Breadcrumb

## Page 07 – FAQ

- File: `07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html`
- Total sections: **6** (3 shared chrome, 2 page sections, 0 landmarks, 0 overlays, 1 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – Question groups

- Type: page section, id `groups`, stage '03 · Answer'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Chevron Icons (up, down, left, right); Accordion
- Subsections (headings): h2: Orders and delivery / summary: How long will my order take to arrive? / summary: Do you offer free shipping? / summary: How can I track my order? / summary: Can I change or cancel my order? / h2: Returns / summary: What is your returns policy? / summary: How do I start a return? / summary: When will I get my refund? / h2: Products and skin / summary: How do I choose the right product for my skin? / summary: Where can I find the full ingredient list? / summary: How should I store my products? / h2: Account and payment / summary: Which payment methods do you accept? / summary: Do I need an account to order? / summary: How do I reset my password?
- Buttons and controls: none
- Icons: chevron-down x13
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: accordion x17
- Reusable component references: C035 Chevron Icons (up, down, left, right); C122 Heading H2; C147 Accordion; C224 FAQ Question Group
- Responsive note (wireframe): Responsive: single column at every width; answers keep the reading width.

### Section 04 – Still need help

- Type: page section, id `help`, stage '04 · Escalate'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Call-to-Action Button (page CTAs)
- Subsections (headings): h2: Still need help?
- Buttons and controls: button: primary: Contact us
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C223 Closing Call-to-Action Block
- Responsive note (wireframe): Responsive: beside the groups from 1024 px, under them below that.

### Section 05 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

### Section 06 – Unnamed content in main

- Type: unnamed content in main
- Main component: *page markup (not a component yet)*
- Nested patterns found: Breadcrumb; Chip
- Subsections (headings): h1: Frequently asked questions
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C121 Heading H1; C142 Breadcrumb; C178 Chip

## Page 08 – About

- File: `08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html`
- Total sections: **8** (3 shared chrome, 5 page sections, 0 landmarks, 0 overlays, 0 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – Intro

- Type: page section, stage '01 · Introduce'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Call-to-Action Button (page CTAs); Placeholder Image; Breadcrumb
- Subsections (headings): h1: Skincare made to be simple to use
- Buttons and controls: button: primary: Shop the collection
- Icons: none
- Cards and tiles: none
- Images and media: 1 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C023 Call-to-Action Button (page CTAs); C094 Placeholder Image; C121 Heading H1; C142 Breadcrumb; C220 Page Hero / Intro Block
- Responsive note (wireframe): Responsive: text above the image on phones; text and image side by side from 1024 px.

### Section 04 – Mission

- Type: page section, stage '02 · Believe'
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): h2: Our mission
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C122 Heading H2
- Responsive note (wireframe): Responsive: centred column; the type steps down with the Design System scale.

### Section 05 – Values

- Type: page section, stage '03 · Prove'
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): h2: What we stand for / h3: Skin first / h3: Clear information / h3: Made to be used
- Buttons and controls: none
- Icons: none
- Cards and tiles: Value Card
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C116 Value Card; C122 Heading H2; C123 Heading H3
- Responsive note (wireframe): Responsive: stacked on phones, three columns from 768 px.

### Section 06 – How products are made

- Type: page section, stage '04 · Show'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Tertiary / Text Button; Call-to-Action Button (page CTAs); Placeholder Image
- Subsections (headings): h2: How we make our products
- Buttons and controls: button: text: Browse our ingredients
- Icons: none
- Cards and tiles: none
- Images and media: 1 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C003 Tertiary / Text Button; C023 Call-to-Action Button (page CTAs); C094 Placeholder Image; C122 Heading H2
- Responsive note (wireframe): Responsive: image above text on phones; side by side from 768 px, image on the left.

### Section 07 – Closing call to action

- Type: page section, stage '05 · Continue'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Call-to-Action Button (page CTAs)
- Subsections (headings): h2: Ready to start your routine?
- Buttons and controls: button: primary: Shop now / button: secondary: Read our story
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C223 Closing Call-to-Action Block
- Responsive note (wireframe): Responsive: centred; buttons stack on phones and sit side by side from 600 px.

### Section 08 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

## Page 09 – Our Story

- File: `09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html`
- Total sections: **8** (3 shared chrome, 5 page sections, 0 landmarks, 0 overlays, 0 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – Intro

- Type: page section, stage '01 · Begin'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Placeholder Image; Breadcrumb
- Subsections (headings): h1: How NUDGE began
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: 1 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C094 Placeholder Image; C121 Heading H1; C142 Breadcrumb; C220 Page Hero / Intro Block
- Responsive note (wireframe): Responsive: image keeps a wide ratio on tablet and desktop and a shorter 4:3 box on phones.

### Section 04 – Opening note

- Type: page section, stage '02 · Open'
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): h2: Where it started
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C122 Heading H2
- Responsive note (wireframe): Responsive: single reading column at every width, centred from 768 px.

### Section 05 – Timeline

- Type: page section, stage '03 · Trace'
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): h2: The road so far / h3: [Milestone one] / h3: [Milestone two] / h3: [Milestone three] / h3: [Milestone four]
- Buttons and controls: none
- Icons: none
- Cards and tiles: Timeline Milestone
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C117 Timeline Milestone; C122 Heading H2; C123 Heading H3
- Responsive note (wireframe): Responsive: year above the text on phones; year in a left column from 768 px.

### Section 06 – Pull quote

- Type: page section, stage '04 · Pause'
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): none
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C135 Pull Quote
- Responsive note (wireframe): Responsive: centred; the type steps down with the Design System scale.

### Section 07 – What comes next

- Type: page section, stage '05 · Continue'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Call-to-Action Button (page CTAs)
- Subsections (headings): h2: What comes next
- Buttons and controls: button: primary: Shop now / button: secondary: About us
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C223 Closing Call-to-Action Block
- Responsive note (wireframe): Responsive: centred; buttons stack on phones and sit side by side from 600 px.

### Section 08 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

## Page 10 – Shipping Policy

- File: `10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html`
- Total sections: **7** (3 shared chrome, 2 page sections, 1 landmarks, 0 overlays, 1 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – At a glance

- Type: page section, id `glance`
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): h2: At a glance
- Buttons and controls: none
- Icons: none
- Cards and tiles: At-a-glance Card
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C118 At-a-glance Card; C122 Heading H2

### Section 04 – Policy text

- Type: page section, id `policy-body`, stage '04 · Read'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Call-to-Action Button (page CTAs)
- Subsections (headings): h2: Processing time / h2: Shipping rates and regions / h2: Delivery times / h2: Order tracking / h2: Delays and lost parcels / h2: Address changes / h2: Duties and taxes / h2: Contact / h2: Still have a question?
- Buttons and controls: button: primary: Contact us / button: secondary: Read the FAQ
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C134 Rich Text Content; C221 Policy Page Body
- Responsive note (wireframe): Responsive: single reading column at every width, no wider than the reading width.

### Section 05 – ask

- Type: landmark, id `ask`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Call-to-Action Button (page CTAs)
- Subsections (headings): h2: Still have a question?
- Buttons and controls: button: primary: Contact us / button: secondary: Read the FAQ
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C222 Policy Ask Panel (contact CTA)

### Section 06 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

### Section 07 – Unnamed content in main

- Type: unnamed content in main
- Main component: *page markup (not a component yet)*
- Nested patterns found: Chevron Icons (up, down, left, right); Breadcrumb; Accordion
- Subsections (headings): h1: Shipping and delivery policy / summary: On this page / h2: On this page
- Buttons and controls: none
- Icons: chevron-down x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: accordion x1
- Reusable component references: C035 Chevron Icons (up, down, left, right); C121 Heading H1; C122 Heading H2; C142 Breadcrumb; C147 Accordion

## Page 11 – Returns Policy

- File: `11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html`
- Total sections: **7** (3 shared chrome, 2 page sections, 1 landmarks, 0 overlays, 1 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – At a glance

- Type: page section, id `glance`
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): h2: At a glance
- Buttons and controls: none
- Icons: none
- Cards and tiles: At-a-glance Card
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C118 At-a-glance Card; C122 Heading H2

### Section 04 – Policy text

- Type: page section, id `policy-body`, stage '04 · Read'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Call-to-Action Button (page CTAs)
- Subsections (headings): h2: Return window / h2: What can be returned / h2: What cannot be returned / h2: How to start a return / h2: Return shipping / h2: Refunds / h2: Exchanges / h2: Damaged or wrong items / h2: Contact / h2: Still have a question?
- Buttons and controls: button: primary: Contact us / button: secondary: Read the FAQ
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C134 Rich Text Content; C221 Policy Page Body
- Responsive note (wireframe): Responsive: single reading column at every width, no wider than the reading width.

### Section 05 – ask

- Type: landmark, id `ask`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Call-to-Action Button (page CTAs)
- Subsections (headings): h2: Still have a question?
- Buttons and controls: button: primary: Contact us / button: secondary: Read the FAQ
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C222 Policy Ask Panel (contact CTA)

### Section 06 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

### Section 07 – Unnamed content in main

- Type: unnamed content in main
- Main component: *page markup (not a component yet)*
- Nested patterns found: Chevron Icons (up, down, left, right); Breadcrumb; Accordion
- Subsections (headings): h1: Returns and refund policy / summary: On this page / h2: On this page
- Buttons and controls: none
- Icons: chevron-down x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: accordion x1
- Reusable component references: C035 Chevron Icons (up, down, left, right); C121 Heading H1; C122 Heading H2; C142 Breadcrumb; C147 Accordion

## Page 12 – Privacy Policy

- File: `12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html`
- Total sections: **7** (3 shared chrome, 2 page sections, 1 landmarks, 0 overlays, 1 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – At a glance

- Type: page section, id `glance`
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): h2: At a glance
- Buttons and controls: none
- Icons: none
- Cards and tiles: At-a-glance Card
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C118 At-a-glance Card; C122 Heading H2

### Section 04 – Policy text

- Type: page section, id `policy-body`, stage '04 · Read'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Call-to-Action Button (page CTAs)
- Subsections (headings): h2: Information we collect / h2: How we use information / h2: Cookies and similar technologies / h2: Who we share information with / h2: Your choices and rights / h2: How long we keep information / h2: How we protect information / h2: Changes to this policy / h2: Contact / h2: Still have a question?
- Buttons and controls: button: primary: Contact us / button: secondary: Read the FAQ
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C134 Rich Text Content; C221 Policy Page Body
- Responsive note (wireframe): Responsive: single reading column at every width, no wider than the reading width.

### Section 05 – ask

- Type: landmark, id `ask`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Call-to-Action Button (page CTAs)
- Subsections (headings): h2: Still have a question?
- Buttons and controls: button: primary: Contact us / button: secondary: Read the FAQ
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C222 Policy Ask Panel (contact CTA)

### Section 06 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

### Section 07 – Unnamed content in main

- Type: unnamed content in main
- Main component: *page markup (not a component yet)*
- Nested patterns found: Chevron Icons (up, down, left, right); Breadcrumb; Accordion
- Subsections (headings): h1: Privacy policy / summary: On this page / h2: On this page
- Buttons and controls: none
- Icons: chevron-down x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: accordion x1
- Reusable component references: C035 Chevron Icons (up, down, left, right); C121 Heading H1; C122 Heading H2; C142 Breadcrumb; C147 Accordion

## Page 13 – Terms and Conditions

- File: `13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html`
- Total sections: **7** (3 shared chrome, 2 page sections, 1 landmarks, 0 overlays, 1 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – At a glance

- Type: page section, id `glance`
- Main component: *page markup (not a component yet)*
- Nested patterns found: none
- Subsections (headings): h2: At a glance
- Buttons and controls: none
- Icons: none
- Cards and tiles: At-a-glance Card
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C118 At-a-glance Card; C122 Heading H2

### Section 04 – Policy text

- Type: page section, id `policy-body`, stage '04 · Read'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Call-to-Action Button (page CTAs)
- Subsections (headings): h2: Using our store / h2: Products and pricing / h2: Orders and payment / h2: Shipping, returns and refunds / h2: Accounts / h2: Intellectual property / h2: Limits of liability / h2: Governing law / h2: Changes to these terms / h2: Contact / h2: Still have a question?
- Buttons and controls: button: primary: Contact us / button: secondary: Read the FAQ
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C134 Rich Text Content; C221 Policy Page Body
- Responsive note (wireframe): Responsive: single reading column at every width, no wider than the reading width.

### Section 05 – ask

- Type: landmark, id `ask`
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Call-to-Action Button (page CTAs)
- Subsections (headings): h2: Still have a question?
- Buttons and controls: button: primary: Contact us / button: secondary: Read the FAQ
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C222 Policy Ask Panel (contact CTA)

### Section 06 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

### Section 07 – Unnamed content in main

- Type: unnamed content in main
- Main component: *page markup (not a component yet)*
- Nested patterns found: Chevron Icons (up, down, left, right); Breadcrumb; Accordion
- Subsections (headings): h1: Terms and conditions / summary: On this page / h2: On this page
- Buttons and controls: none
- Icons: chevron-down x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: accordion x1
- Reusable component references: C035 Chevron Icons (up, down, left, right); C121 Heading H1; C122 Heading H2; C142 Breadcrumb; C147 Accordion

## Page 14 – Blog Listing

- File: `14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html`
- Total sections: **8** (3 shared chrome, 4 page sections, 0 landmarks, 0 overlays, 1 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – Featured article

- Type: page section, id `featured`, stage '03 · Lead'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Placeholder Image; Article Card (featured)
- Subsections (headings): h2: [Sample title: a simple morning skincare routine]
- Buttons and controls: none
- Icons: none
- Cards and tiles: Article Card (featured)
- Images and media: 1 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C094 Placeholder Image; C105 Article Card (featured); C122 Heading H2
- Responsive note (wireframe): Responsive: image above text on phones; side by side from 1024 px.

### Section 04 – Article grid

- Type: page section, stage '04 · Browse'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Placeholder Image; Blog Card
- Subsections (headings): h2: Latest articles / h3: [Sample title: How to layer your skincare] / h3: [Sample title: A simple evening routine] / h3: [Sample title: What is niacinamide?] / h3: [Sample title: Skin prep before makeup] / h3: [Sample title: Caring for dry skin on the body] / h3: [Sample title: Sunscreen basics, explained] / h3: [Sample title: Building a routine for sensitive skin] / h3: [Sample title: A guide to common cleansing ingredients] / h3: [Sample title: Seasonal skin changes]
- Buttons and controls: none
- Icons: none
- Cards and tiles: Blog Card
- Images and media: 9 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C094 Placeholder Image; C104 Blog Card; C122 Heading H2; C123 Heading H3
- Responsive note (wireframe): Responsive: one column on phones, two from 600 px, three from 1024 px.

### Section 05 – Pagination

- Type: page section, stage '05 · Page'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Chevron Icons (up, down, left, right); Pagination
- Subsections (headings): none
- Buttons and controls: none
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: pagination x1
- Reusable component references: C035 Chevron Icons (up, down, left, right); C145 Pagination
- Responsive note (wireframe): Responsive: wraps and stays centred at every width.

### Section 06 – No articles

- Type: page section, id `empty`, stage '06 · Empty'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Outline Button; Call-to-Action Button (page CTAs); Empty State
- Subsections (headings): h2: No articles here yet
- Buttons and controls: button: primary: Shop now / button: secondary: All articles
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C001 Primary Button; C002 Secondary Button; C004 Outline Button; C023 Call-to-Action Button (page CTAs); C122 Heading H2; C185 Empty State; C223 Closing Call-to-Action Block
- Responsive note (wireframe): Responsive: centred column.

### Section 07 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

### Section 08 – Unnamed content in main

- Type: unnamed content in main
- Main component: *page markup (not a component yet)*
- Nested patterns found: Breadcrumb; Chip
- Subsections (headings): h1: Journal
- Buttons and controls: none
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C121 Heading H1; C142 Breadcrumb; C178 Chip

## Page 15 – Blog Article

- File: `15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html`
- Total sections: **5** (3 shared chrome, 2 page sections, 0 landmarks, 0 overlays, 0 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – Article

- Type: page section, id `article`, stage '01 · Details'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Secondary Button; Outline Button; Share Button; Arrow Icons (left, right); Share Icon; Placeholder Image; Breadcrumb; Chip
- Subsections (headings): h1: [Sample title: the layered morning routine, step by step] / h2: [Section heading] (x2) / h3: [Sub-heading]
- Buttons and controls: button: secondary: Share
- Icons: share x1, arrow-left x1, arrow-right x1
- Cards and tiles: none
- Images and media: 2 labelled placeholder(s)
- Inputs and interactive elements: none
- Reusable component references: C002 Secondary Button; C004 Outline Button; C026 Share Button; C036 Arrow Icons (left, right); C055 Share Icon; C094 Placeholder Image; C121 Heading H1; C122 Heading H2; C123 Heading H3; C134 Rich Text Content; C142 Breadcrumb; C178 Chip; C226 Share Block
- Responsive note (wireframe): Responsive: the title steps down with the Design System scale; the details line wraps on narrow screens.

### Section 04 – Comments

- Type: page section, id `comments`, stage '05 · Comments'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Form Submit Button; Text Input; Email Input; Textarea; Input Label; Comment Form
- Subsections (headings): h2: Comments / h3: Leave a comment
- Buttons and controls: button: primary: Post comment
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: text: Name / email: Email / textarea: Comment
- Reusable component references: C001 Primary Button; C020 Form Submit Button; C062 Text Input; C063 Email Input; C073 Textarea; C077 Input Label; C080 Comment Form; C122 Heading H2; C123 Heading H3; C133 Label Text
- Responsive note (wireframe): Responsive: one column; name and email share a row from 600 px.

### Section 05 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

## Page 16 – 404

- File: `16-NUDGE-Beauty-404-Wireframe/404_Page_Wireframe_v1.html`
- Total sections: **4** (3 shared chrome, 1 page sections, 0 landmarks, 0 overlays, 0 unnamed content)

### Section 01 – Announcement bar

- Type: shared chrome, id `annbar`
- Main component: `layout/announcement-bar` (shared partial, identical on every page)
- Nested sub-components: `layout/announcement-arrow`, `base/icon`, `layout/announcement-dots`
- Subsections (headings): none
- Buttons and controls: icon button: Previous message / icon button: Next message
- Icons: chevron-left x1, chevron-right x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C010 Announcement Arrow Button; C035 Chevron Icons (up, down, left, right); C136 Announcement Bar; C192 Status / Live Region

### Section 02 – Header

- Type: shared chrome, id `site-header`
- Main component: `header/site-header` (shared partial, identical on every page)
- Nested sub-components: `header/menu-button`, `base/icon`, `header/search-button`, `header/logo`, `header/nav-close`, `header/nav-item`, `header/mega-menu`, `header/menus/skin`, `header/mega-column`, `header/mega-cards`, `header/mega-card`, `header/menus/makeup`, `header/menus/hair`, `header/menus/body`, `header/market-selector`, `header/account-button`, `header/cart-button`, `header/cart-button-content`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Open menu / other control: Close / disclosure toggle: India (INR) / other control: India (INR ₹) / other control: United States (USD $) / other control: United Kingdom (GBP £) / other control: Eurozone (EUR €)
- Icons: menu x1, search x3, close x1, chevron-down x5, arrow-right x12, location x1, check x1, account x1, bag x1
- Cards and tiles: Mega Menu Card
- Images and media: placeholder: IMAGE PLACEHOLDER4:5 (8 placeholders)
- Inputs and interactive elements: none
- Reusable component references: C030 Search Icon; C031 Shopping Bag / Cart Icon; C032 Account / User Icon; C033 Menu / Hamburger Icon; C034 Close Icon; C035 Chevron Icons (up, down, left, right); C036 Arrow Icons (left, right); C043 Location Icon; C052 Check / Check-circle Icons; C094 Placeholder Image; C119 Mega Menu Card; C137 Header; C138 Desktop Navigation; C139 Mega Menu; C140 Mobile Navigation / Hamburger Drawer; C141 Market Selector; C191 Popover / Disclosure Menu; C192 Status / Live Region

### Section 03 – 404

- Type: page section, id `nf`, stage '01 · Say it'
- Main component: *page markup (not a component yet)*
- Nested patterns found: Primary Button; Secondary Button; Tertiary / Text Button; Outline Button; Continue Shopping Button; Call-to-Action Button (page CTAs); Search Input; Input Label; Chip
- Subsections (headings): h1: We cannot find that page
- Buttons and controls: button: secondary: Search / button: primary: Continue shopping / button: text: Go to the homepage
- Icons: none
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: search: Search our store
- Reusable component references: C001 Primary Button; C002 Secondary Button; C003 Tertiary / Text Button; C004 Outline Button; C019 Continue Shopping Button; C023 Call-to-Action Button (page CTAs); C065 Search Input; C077 Input Label; C121 Heading H1; C133 Label Text; C178 Chip; C220 Page Hero / Intro Block
- Responsive note (wireframe): Responsive: the number and title step down with the Design System scale; text stays centred in a column no wider than the reading width.

### Section 04 – Footer

- Type: shared chrome
- Main component: `layout/site-footer` (shared partial, identical on every page)
- Nested sub-components: `layout/footer-brand`, `layout/social-link`, `base/icon`, `layout/footer-column`, `layout/footer-payments`, `layout/back-to-top`
- Subsections (headings): none
- Buttons and controls: disclosure toggle: Shop / disclosure toggle: About / disclosure toggle: Support / disclosure toggle: Policies
- Icons: instagram x1, facebook x1, youtube x1, plus x4, chevron-up x1
- Cards and tiles: none
- Images and media: none
- Inputs and interactive elements: none
- Reusable component references: C022 Back to Top Button; C035 Chevron Icons (up, down, left, right); C037 Plus / Minus Icons; C047 Social Media Icons (Instagram, Facebook, YouTube); C143 Footer; C144 Footer Link Group; C191 Popover / Disclosure Menu

