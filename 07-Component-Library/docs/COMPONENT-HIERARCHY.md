# Component Hierarchy

Main component > sub-component > nested component, taken from the real include graph of the partial components (`@@PARTIAL` calls inside each template). The Homepage and the shared header, footer and announcement bar are built from components. The other 14 pages are page markup and have no hierarchy yet.

## Levels

- **Base**: one UI idea, no layout of its own (Button, Icon, Chip, Icon Button, Badge, Media, Price, Rating, Quantity, Message, Breadcrumb, Input Field, Section Heading).
- **Sub-component**: a part used inside a section (a card, a step, a menu column).
- **Main**: a whole section or shared region that contains sub-components.

## Shared chrome (every page)

- `layout/announcement-bar` (main)
  - `layout/announcement-arrow` (sub)
    - `base/icon` (base)
  - `layout/announcement-dots` (sub)
- `header/site-header` (main)
  - `header/menu-button` (sub)
    - `base/icon` (base)
  - `header/search-button` (sub)
    - `base/icon` (base)
  - `header/logo` (sub)
  - `header/nav-close` (sub)
    - `base/icon` (base)
  - `header/nav-item` (sub)
    - `base/icon` (base)
    - `header/mega-menu` (sub)
      - `base/icon` (base)
      - `header/menus/skin` (sub)
        - `header/mega-column` (sub)
        - `header/mega-cards` (sub)
          - `header/mega-card` (sub)
            - `base/icon` (base)
      - `header/menus/makeup` (sub)
        - `header/mega-column` (sub)
        - `header/mega-cards` (sub)
          - `header/mega-card` (sub)
            - `base/icon` (base)
      - `header/menus/hair` (sub)
        - `header/mega-column` (sub)
        - `header/mega-cards` (sub)
          - `header/mega-card` (sub)
            - `base/icon` (base)
      - `header/menus/body` (sub)
        - `header/mega-column` (sub)
        - `header/mega-cards` (sub)
          - `header/mega-card` (sub)
            - `base/icon` (base)
  - `header/market-selector` (sub)
  - `header/account-button` (sub)
  - `header/cart-button` (sub)
    - `header/cart-button-content` (sub)
      - `base/icon` (base)
- `layout/site-footer` (main)
  - `layout/footer-brand` (sub)
    - `layout/social-link` (sub)
      - `base/icon` (base)
  - `layout/footer-column` (sub)
    - `base/icon` (base)
  - `layout/footer-payments` (sub)
  - `layout/back-to-top` (sub)
    - `base/icon` (base)

## Homepage, section by section

### Hero Banner
- `homepage/hero-banner` (main)
  - `homepage/hero-media` (sub)
  - `homepage/hero-content` (sub)
    - `base/button` (base)
      - `base/icon` (base)
  - `homepage/hero-featured-product` (sub)
    - `base/icon` (base)

### Benefits / USP Row
- `homepage/usp-row` (main)
  - `homepage/usp-item` (sub)
    - `base/icon` (base)

### Shop by Category
- `homepage/category-section` (main)
  - `base/section-heading` (base)
  - `homepage/category-card` (sub)
    - `base/icon` (base)

### Featured Collection (Best Sellers / New Arrivals)
- `homepage/featured-collection` (main)
  - `base/section-heading` (base)
  - `homepage/collection-tabs` (sub)
    - `homepage/collection-tab` (sub)
  - `homepage/product-card` (sub)
    - `base/icon` (base)
  - `base/button` (base)
    - `base/icon` (base)

### Shop by Concern / Need / Routine
- `homepage/concern-section` (main)
  - `base/section-heading` (base)
  - `homepage/group-title` (sub)
  - `homepage/concern-card` (sub)
  - `homepage/routine-step` (sub)

### Guided Finder / Quiz
- `homepage/finder-section` (main)
  - `homepage/finder-card` (sub)
    - `base/chip` (base)
    - `base/button` (base)
      - `base/icon` (base)

### Shop the Look
- `homepage/look-section` (main)
  - `homepage/look-pin` (sub)
  - `homepage/look-row` (sub)

### Ingredient / Material Spotlight
- `homepage/ingredient-section` (main)
  - `base/section-heading` (base)
  - `homepage/ingredient-card` (sub)
  - `base/chip` (base)

### How to Use / Routine Steps
- `homepage/ritual-section` (main)
  - `homepage/ritual-controls` (sub)
    - `base/icon-button` (base)
      - `base/icon` (base)
  - `homepage/ritual-step` (sub)
    - `base/icon` (base)

### Video Section
- `homepage/video-section` (main)
  - `homepage/video-poster` (sub)
  - `homepage/video-copy` (sub)
    - `base/button` (base)
      - `base/icon` (base)

### Before & After
- `homepage/compare-section` (main)
  - `homepage/compare-layer` (sub)
  - `base/icon` (base)

### Testimonials / Customer Reviews
- `homepage/testimonials-section` (main)
  - `base/section-heading` (base)
  - `common/scroller-controls` (sub)
    - `base/icon-button` (base)
      - `base/icon` (base)
  - `homepage/review-card` (sub)
    - `homepage/review-stars` (sub)
      - `base/icon` (base)
    - `base/icon` (base)

### Customer Photo Gallery
- `homepage/gallery-section` (main)
  - `base/section-heading` (base)
  - `homepage/gallery-tile` (sub)

### Logo List (Awards, Certifications, Press, Partner Brands)
- `homepage/logo-section` (main)
  - `common/scroller-controls` (sub)
    - `base/icon-button` (base)
      - `base/icon` (base)
  - `homepage/logo-item` (sub)

### Promotional / Campaign Banner
- `homepage/promo-banner` (main)
  - `homepage/promo-media` (sub)
  - `homepage/promo-copy` (sub)
    - `base/button` (base)
      - `base/icon` (base)

### Custom Liquid Section
- `homepage/custom-liquid-section` (main)

### Newsletter
- `homepage/newsletter-section` (main)
  - `homepage/newsletter-field` (sub)
  - `base/button` (base)
    - `base/icon` (base)
  - `homepage/newsletter-perk` (sub)
    - `base/icon` (base)

## Pages that are not yet componentized

- **Page 02 PLP**: Collection Banner; Sub-collection Links; Filters and Product Grid; Filters; Sort, Product Count and Applied Filters; Product Grid; Promotion; Collection SEO Description; Filters; Quick view
- **Page 03 PDP**: Breadcrumb; Product: gallery and purchase panel; Product information and purchase; Variant picker; Selling plan picker; Buy buttons; Delivery, returns, pickup and trust; Product details; Product storytelling; Complete your routine; Reviews; Related products; Product FAQ; Product images
- **Page 04 Cart**: Cart; Cart lines; Order note and gift message; Cart upsell; Order summary; Empty cart
- **Page 05 Cart Drawer**: Cart 3 items; Unnamed content in main
- **Page 06 Contact**: Contact form; Other ways to reach us; Contact details; Quick answers; Unnamed content in main
- **Page 07 FAQ**: Question groups; Still need help; Unnamed content in main
- **Page 08 About**: Intro; Mission; Values; How products are made; Closing call to action
- **Page 09 Our Story**: Intro; Opening note; Timeline; Pull quote; What comes next
- **Page 10 Shipping Policy**: At a glance; Policy text; ask; Unnamed content in main
- **Page 11 Returns Policy**: At a glance; Policy text; ask; Unnamed content in main
- **Page 12 Privacy Policy**: At a glance; Policy text; ask; Unnamed content in main
- **Page 13 Terms and Conditions**: At a glance; Policy text; ask; Unnamed content in main
- **Page 14 Blog Listing**: Featured article; Article grid; Pagination; No articles; Unnamed content in main
- **Page 15 Blog Article**: Article; Comments
- **Page 16 404**: 404

## Orphans (components that nothing includes)

`base/breadcrumb`, `base/input-field`, `base/media`, `base/message`, `base/quantity`, `plp/applied-chips`, `plp/facet-groups`, `plp/pagination`, `plp/product-card`, `plp/promo-tile`, `plp/quick-view-body`

Base components that exist but no page or component calls yet: `base/breadcrumb`, `base/input-field`, `base/media`, `base/message`, `base/quantity`.
