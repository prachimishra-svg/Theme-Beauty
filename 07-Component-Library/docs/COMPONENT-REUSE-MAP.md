# Component Reuse Map

Where each master component is used, by page. Numbers are detections at 1440 px (an element can match more than one master component, so totals are not a count of distinct DOM elements). A dash means the component was not found on that page.

## Summary

- Master entries: **229**; present in the wireframes or implemented: **204**; requested but not present: **25**
- Shared (found on 2 or more pages): **83**
- Page-specific (found on exactly one page): **100**
- Defined or structural, with no direct detector (type styles, layout, unused variants): **21**
- Total detections across all pages: **2780**
- Raw DOM census over all 16 pages: icons 802, accordion items 58, chips 46, placeholders 175, checkboxes 42, radios 10, product cards (PLP) 10, prices 26, ratings 14

## Key reuse questions

| Component | Homepage | PLP | PDP | Cart | Other pages |
|---|---|---|---|---|---|
| Primary Button | No | Yes (3) | Yes (2) | Yes (2) | Yes, 12 of 12 pages |
| Secondary Button | No | Yes (22) | No | Yes (2) | Yes: Drawer, Contact, About, Story, Ship, Return, Privacy, Terms, BlogL, BlogA, 404 |
| Icon Button | No | Yes (2) | Yes (6) | No | Yes: Drawer |
| Chip | Yes (9) | Yes (10) | No | Yes (5) | Yes: Drawer, FAQ, BlogL, BlogA, 404 |
| Badge | No | Yes (6) | No | No | No |
| Quantity Input | No | No | Yes (1) | Yes (3) | Yes: Drawer |
| Product Rating | No | Yes (8) | Yes (6) | No | No |
| Accordion | No | Yes (20) | Yes (9) | No | Yes: FAQ, Ship, Return, Privacy, Terms |
| Breadcrumb | No | Yes (1) | Yes (1) | No | Yes: Contact, FAQ, About, Story, Ship, Return, Privacy, Terms, BlogL, BlogA |
| Pagination | No | Yes (2) | No | No | Yes: BlogL |
| Drawer | No | Yes (2) | Yes (1) | No | Yes: Drawer |
| Header | Yes (1) | Yes (1) | Yes (1) | Yes (1) | Yes, 12 of 12 pages |
| Footer | Yes (1) | Yes (1) | Yes (1) | Yes (1) | Yes, 12 of 12 pages |

## Full matrix

| ID | Component | Home | PLP | PDP | Cart | Drawer | Contact | FAQ | About | Story | Ship | Return | Privacy | Terms | BlogL | BlogA | 404 | Pages | Reuse |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| | **01 Buttons** | | | | | | | | | | | | | | | | | | |
| C001 | Primary Button | - | 3 | 2 | 2 | 2 | 1 | 1 | 2 | 1 | 2 | 2 | 2 | 2 | 1 | 1 | 1 | 15 | shared |
| C002 | Secondary Button | - | 22 | - | 2 | 1 | 1 | - | 1 | 1 | 2 | 2 | 2 | 2 | 1 | 1 | 1 | 13 | shared |
| C003 | Tertiary / Text Button | - | 5 | - | - | - | 1 | - | 1 | - | - | - | - | - | - | - | 1 | 4 | shared |
| C004 | Outline Button | 3 | 22 | - | 2 | 1 | 1 | - | 1 | 1 | 2 | 2 | 2 | 2 | 1 | 1 | 1 | 14 | shared |
| C005 | Editorial Button | 6 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C006 | Editorial Outline Button | 3 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C007 | Editorial Text Button | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C008 | Icon Button | - | 2 | 6 | - | 1 | - | - | - | - | - | - | - | - | - | - | - | 3 | shared |
| C009 | Circular Icon Button | 6 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C010 | Announcement Arrow Button | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 16 | shared |
| C011 | Add to Cart Button | - | 1 | 2 | 2 | 1 | - | - | - | - | - | - | - | - | - | - | - | 4 | shared |
| C012 | Buy Now Button | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C013 | Quick View Button | - | 19 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C014 | Apply Filter Button | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C015 | Clear Filter Button | - | 5 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C016 | Load More Button | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C017 | View All Button | 1 | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C018 | Checkout Button | - | - | - | 1 | 1 | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C019 | Continue Shopping Button | - | - | - | 1 | 1 | 1 | - | - | - | - | - | - | - | - | - | 1 | 4 | shared |
| C020 | Form Submit Button | 1 | - | - | - | - | 1 | - | - | - | - | - | - | - | - | 1 | - | 3 | shared |
| C021 | Newsletter Subscribe Button | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C022 | Back to Top Button | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C023 | Call-to-Action Button (page CTAs) | 5 | 2 | - | 1 | 1 | 2 | 1 | 4 | 2 | 4 | 4 | 4 | 4 | 2 | - | 3 | 14 | shared |
| C024 | Filters Open Button | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C025 | Disabled / Sold-out Button | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C026 | Share Button | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | - | 1 | page-specific |
| C027 | Remove Line Button | - | - | - | 3 | 3 | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C028 | Wizard Step Button (Next / Back) | 2 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C029 | Play Video Button | 1 | - | 2 | - | - | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| | **02 Icons** | | | | | | | | | | | | | | | | | | |
| C030 | Search Icon | 3 | 4 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 16 | shared |
| C031 | Shopping Bag / Cart Icon | 1 | 1 | 2 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C032 | Account / User Icon | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C033 | Menu / Hamburger Icon | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C034 | Close Icon | 1 | 3 | 2 | 1 | 2 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C035 | Chevron Icons (up, down, left, right) | 10 | 29 | 20 | 9 | 8 | 9 | 21 | 8 | 8 | 9 | 9 | 9 | 9 | 10 | 8 | 8 | 16 | shared |
| C036 | Arrow Icons (left, right) | 36 | 12 | 12 | 12 | 12 | 18 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 14 | 12 | 16 | shared |
| C037 | Plus / Minus Icons | 4 | 4 | 6 | 10 | 10 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 16 | shared |
| C038 | Heart Icon | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C039 | Star / Rating Icon | 34 | 40 | 30 | - | - | - | - | - | - | - | - | - | - | - | - | - | 3 | shared |
| C040 | Filter Icon | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C041 | Sort Icon | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C042 | Grid / List View Icon | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C043 | Location Icon | 2 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C044 | Phone Icon | - | - | - | - | - | 2 | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C045 | Email Icon | - | - | - | - | - | 2 | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C046 | Clock Icon | - | - | - | - | - | 2 | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C047 | Social Media Icons (Instagram, Facebook, YouTube) | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 16 | shared |
| C048 | Payment Icons | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C049 | Security / Lock Icon | - | - | - | 1 | 1 | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C050 | Shipping Icon | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C051 | Wishlist Icon | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C052 | Check / Check-circle Icons | 5 | 1 | 4 | 1 | 1 | 2 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C053 | Warning Icon | - | 1 | 1 | - | - | 1 | - | - | - | - | - | - | - | - | - | - | 3 | shared |
| C054 | Eye Icon | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C055 | Share Icon | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | - | 1 | page-specific |
| C056 | Play Icon | - | - | 2 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C057 | Zoom-in Icon | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C058 | Delivery / Returns / Trust / Pickup Icons (truck, rotate-ccw, shield-check, store) | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C059 | Loader Icon | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C060 | Info Icon | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C061 | Eye-off Icon | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| | **03 Forms and inputs** | | | | | | | | | | | | | | | | | | |
| C062 | Text Input | - | - | 1 | 4 | 3 | 3 | - | - | - | - | - | - | - | - | 2 | - | 5 | shared |
| C063 | Email Input | 1 | - | - | - | - | 1 | - | - | - | - | - | - | - | - | 1 | - | 3 | shared |
| C064 | Password Input | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C065 | Search Input | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | 1 | page-specific |
| C066 | Phone Input | - | - | - | - | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C067 | Select Dropdown | - | 1 | - | - | - | 1 | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C068 | Checkbox | - | 60 | 3 | - | - | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C069 | Radio Button | - | - | 10 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C070 | Toggle Switch | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C071 | Range Slider | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C072 | Quantity Input | - | - | 1 | 3 | 3 | - | - | - | - | - | - | - | - | - | - | - | 3 | shared |
| C073 | Textarea | - | - | - | 1 | - | 1 | - | - | - | - | - | - | - | - | 1 | - | 3 | shared |
| C074 | Newsletter Form | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C075 | Filter Inputs (facet checkboxes, price range) | - | 82 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C076 | Form Validation Message | - | - | 1 | - | - | 2 | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C077 | Input Label | 1 | 83 | 13 | 1 | - | 6 | - | - | - | - | - | - | - | - | 3 | 1 | 7 | shared |
| C078 | Input Helper Text | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C079 | Contact Form | - | - | - | - | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C080 | Comment Form | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | - | 1 | page-specific |
| C081 | Order Note Field | - | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| | **04 Images and media** | | | | | | | | | | | | | | | | | | |
| C082 | Product Image | - | - | 14 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C083 | Category Image | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C084 | Hero Image | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C085 | Banner Image | 1 | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C086 | Thumbnail Image | - | - | 4 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C087 | Lifestyle / Look Image | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C088 | Before / After Image | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C089 | Video Thumbnail (poster) | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C090 | Video Player | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C091 | Image Gallery | 1 | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C092 | Image Slider / Carousel | - | - | 4 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C093 | Responsive Image (img with srcset) | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C094 | Placeholder Image | 8 | 8 | 27 | 13 | 15 | 8 | 8 | 10 | 9 | 8 | 8 | 8 | 8 | 18 | 10 | 8 | 16 | shared |
| C095 | Customer Photo Tile | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| | **05 Cards** | | | | | | | | | | | | | | | | | | |
| C096 | Homepage Product Card | 4 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C097 | PLP Product Card | - | 10 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C098 | Hero Featured Product Card | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C099 | Category Card | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C100 | Collection Card | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C101 | Concern Card | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C102 | Review Card | 1 | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C103 | Testimonial Card | 6 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C104 | Blog Card | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | - | - | 1 | page-specific |
| C105 | Article Card (featured) | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | - | - | 1 | page-specific |
| C106 | Ingredient Card | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C107 | Benefit Card (USP item) | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C108 | Brand Card | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C109 | Lookbook Card | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C110 | Promotional Card | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C111 | Recommendation Card | - | - | 1 | 1 | - | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C112 | Related Product Card | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C113 | Recently Viewed Product Card | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C114 | Cart Item Card | - | - | - | 3 | 3 | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C115 | Contact Detail Card | - | - | - | - | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C116 | Value Card | - | - | - | - | - | - | - | 1 | - | - | - | - | - | - | - | - | 1 | page-specific |
| C117 | Timeline Milestone | - | - | - | - | - | - | - | - | 1 | - | - | - | - | - | - | - | 1 | page-specific |
| C118 | At-a-glance Card | - | - | - | - | - | - | - | - | - | 1 | 1 | 1 | 1 | - | - | - | 4 | shared |
| C119 | Mega Menu Card | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 16 | shared |
| C120 | Quick Answer Card | - | - | - | - | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| | **06 Typography** | | | | | | | | | | | | | | | | | | |
| C121 | Heading H1 | 1 | 1 | 1 | 2 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C122 | Heading H2 | 12 | 6 | 6 | 2 | 2 | 5 | 5 | 4 | 3 | 12 | 13 | 13 | 14 | 3 | 3 | - | 15 | shared |
| C123 | Heading H3 | 8 | 13 | 7 | - | - | 1 | - | 3 | 4 | - | - | - | - | 9 | 2 | - | 8 | shared |
| C124 | Heading H4-H6 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C125 | Section Heading | 6 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C126 | Subheading / Lead | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C127 | Body Text / Paragraph | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C128 | Caption | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C129 | Overline | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C130 | Price Typography | - | 10 | 9 | 3 | 3 | - | - | - | - | - | - | - | - | - | - | - | 4 | shared |
| C131 | Discount Text | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C132 | Product Title | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C133 | Label Text | 1 | 83 | 13 | 1 | - | 6 | - | - | - | - | - | - | - | - | 3 | 1 | 7 | shared |
| C134 | Rich Text Content | - | - | - | - | - | - | - | - | - | 1 | 1 | 1 | 1 | - | 1 | - | 5 | shared |
| C135 | Pull Quote | - | - | - | - | - | - | - | - | 1 | - | - | - | - | - | - | - | 1 | page-specific |
| | **07 Navigation** | | | | | | | | | | | | | | | | | | |
| C136 | Announcement Bar | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C137 | Header | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C138 | Desktop Navigation | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C139 | Mega Menu | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 16 | shared |
| C140 | Mobile Navigation / Hamburger Drawer | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C141 | Market Selector | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C142 | Breadcrumb | - | 1 | 1 | - | - | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | - | 12 | shared |
| C143 | Footer | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 16 | shared |
| C144 | Footer Link Group | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 16 | shared |
| C145 | Pagination | - | 2 | - | - | - | - | - | - | - | - | - | - | - | 1 | - | - | 2 | shared |
| C146 | Tabs | 3 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C147 | Accordion | - | 20 | 9 | - | - | - | 17 | - | - | 1 | 1 | 1 | 1 | - | - | - | 7 | shared |
| C148 | Sidebar Navigation (filter sidebar) | - | 2 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C149 | Sub-collection Links | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| | **08 Commerce** | | | | | | | | | | | | | | | | | | |
| C150 | Product Price | - | 10 | 9 | 3 | 3 | - | - | - | - | - | - | - | - | - | - | - | 4 | shared |
| C151 | Compare-at Price | - | 1 | 1 | 1 | 1 | - | - | - | - | - | - | - | - | - | - | - | 4 | shared |
| C152 | Discount Badge | - | 6 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C153 | Bestseller Badge | - | 6 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C154 | New Badge | - | 6 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C155 | Product Rating | - | 8 | 6 | - | - | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C156 | Review Count | - | 8 | 6 | - | - | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C157 | Product Variant Selector | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C158 | Size Selector | - | 4 | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C159 | Color Swatch | - | 20 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C160 | Quantity Selector | - | - | 1 | 3 | 3 | - | - | - | - | - | - | - | - | - | - | - | 3 | shared |
| C161 | Quick View Panel | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C162 | Wishlist Control | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C163 | Stock Status | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C164 | Delivery Information | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C165 | Product Details Accordion | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C166 | Selling Plan Picker | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C167 | Buy Buttons Group | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C168 | Product Gallery | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C169 | Product Zoom Viewer | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C170 | Cart Line Item | - | - | - | 3 | 3 | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C171 | Cart Summary | - | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C172 | Cart Drawer | - | - | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C173 | Cart Upsell | - | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C174 | Coupon / Discount Field | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C175 | Checkout Summary | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C176 | Free Shipping Progress | - | - | - | 1 | 1 | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| | **09 Feedback** | | | | | | | | | | | | | | | | | | |
| C177 | Badge | - | 6 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C178 | Chip | 9 | 10 | - | 5 | 5 | - | 4 | - | - | - | - | - | - | 6 | 2 | 5 | 8 | shared |
| C179 | Tag | 9 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C180 | Tooltip | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C181 | Toast | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C182 | Alert / Message | - | - | 3 | - | - | 1 | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C183 | Success Message | - | - | 2 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C184 | Error Message | - | - | 1 | - | - | 1 | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C185 | Empty State | - | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | - | - | 2 | shared |
| C186 | Loading State | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C187 | Skeleton Loader | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C188 | Progress Indicator | - | - | - | 1 | 1 | - | - | - | - | - | - | - | - | - | - | - | 2 | shared |
| C189 | Modal Dialog | - | 2 | 1 | - | 1 | - | - | - | - | - | - | - | - | - | - | - | 3 | shared |
| C190 | Drawer | - | 2 | 1 | - | 1 | - | - | - | - | - | - | - | - | - | - | - | 3 | shared |
| C191 | Popover / Disclosure Menu | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 16 | shared |
| C192 | Status / Live Region | 4 | 3 | 7 | 3 | 3 | 3 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 16 | shared |
| | **10 Layout** | | | | | | | | | | | | | | | | | | |
| C193 | Section Container | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C194 | Content Wrapper | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C195 | Grid | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C196 | Flex Layout | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C197 | Divider | - | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C198 | Spacer | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C199 | Section Background | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C200 | Responsive Layout Wrapper | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| C201 | Sticky Bar | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C202 | Floating Action Element | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C203 | Scroller (horizontal carousel) | 3 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C204 | Wireframe Annotation Note | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |
| | **11 Beauty** | | | | | | | | | | | | | | | | | | |
| C205 | Skin Concern Selector | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C206 | Skin Type Selector | 5 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C207 | Guided Finder / Quiz | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C208 | Ingredient Information | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C209 | Ingredient Benefits | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C210 | How to Use | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C211 | Routine Steps | 2 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C212 | Product Benefits | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C213 | Before and After | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C214 | Certifications / Awards / Press Logos | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C215 | Expert Recommendations | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C216 | Beauty Results | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C217 | Product Comparison | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | not present |
| C218 | Shop the Look | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C219 | Complete Your Routine Bundle | - | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| | **12 Additional** | | | | | | | | | | | | | | | | | | |
| C220 | Page Hero / Intro Block | - | 1 | - | - | - | - | - | 1 | 1 | - | - | - | - | - | - | 1 | 4 | shared |
| C221 | Policy Page Body | - | - | - | - | - | - | - | - | - | 1 | 1 | 1 | 1 | - | - | - | 4 | shared |
| C222 | Policy Ask Panel (contact CTA) | - | - | - | - | - | - | - | - | - | 1 | 1 | 1 | 1 | - | - | - | 4 | shared |
| C223 | Closing Call-to-Action Block | - | - | - | - | - | - | 1 | 1 | 1 | - | - | - | - | 1 | - | - | 4 | shared |
| C224 | FAQ Question Group | - | - | - | - | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C225 | Collection SEO Description | - | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C226 | Share Block | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | - | 1 | page-specific |
| C227 | Custom Liquid Section | 1 | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C228 | Contact Details List | - | - | - | - | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | page-specific |
| C229 | Wireframe Width Panel | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | - | 0 | defined / structural |

## Where each component is used (sections)

Page and section names for every component that was detected. Up to 8 places are listed.

- **C001 Primary Button**: PLP: Product Grid; PLP: Filters; PLP: Quick view; PDP: Buy buttons; PDP: Complete your routine; Cart: Order summary; Cart: Empty cart; Drawer: Cart 3 items; +16 more
- **C002 Secondary Button**: PLP: Sort, Product Count and Applied Filters; PLP: Product Grid; PLP: Promotion; Cart: Cart upsell; Drawer: Cart 3 items; Contact: Contact form; About: Closing call to action; Story: What comes next; +11 more
- **C003 Tertiary / Text Button**: PLP: Filters and Product Grid; PLP: Filters; PLP: Sort, Product Count and Applied Filters; PLP: Quick view; Contact: Contact form; About: How products are made; 404: 404
- **C004 Outline Button**: Home: Featured Collection (Best Sellers / New Arrivals); Home: Guided Finder / Quiz; Home: Video Section; PLP: Sort, Product Count and Applied Filters; PLP: Product Grid; PLP: Promotion; Cart: Cart upsell; Drawer: Cart 3 items; +14 more
- **C005 Editorial Button**: Home: Hero Banner; Home: Guided Finder / Quiz; Home: Promotional / Campaign Banner; Home: Newsletter
- **C006 Editorial Outline Button**: Home: Featured Collection (Best Sellers / New Arrivals); Home: Guided Finder / Quiz; Home: Video Section
- **C008 Icon Button**: PLP: Filters; PLP: Quick view; PDP: Product: gallery and purchase panel; PDP: Product images; Drawer: Cart 3 items
- **C009 Circular Icon Button**: Home: How to Use / Routine Steps; Home: Testimonials / Customer Reviews; Home: Logo List (Awards, Certifications, Press, Partner Brands)
- **C010 Announcement Arrow Button**: Home: Announcement Bar; PLP: Announcement bar; PDP: Announcement bar; Cart: Announcement bar; Drawer: Announcement bar; Contact: Announcement bar; FAQ: Announcement bar; About: Announcement bar; +8 more
- **C011 Add to Cart Button**: PLP: Quick view; PDP: Buy buttons; PDP: Complete your routine; Cart: Cart upsell; Drawer: Cart 3 items
- **C013 Quick View Button**: PLP: Product Grid; PLP: Quick view
- **C014 Apply Filter Button**: PLP: Filters
- **C015 Clear Filter Button**: PLP: Filters and Product Grid; PLP: Filters; PLP: Sort, Product Count and Applied Filters; PLP: Product Grid
- **C017 View All Button**: Home: Featured Collection (Best Sellers / New Arrivals); PLP: Quick view
- **C018 Checkout Button**: Cart: Order summary; Drawer: Cart 3 items
- **C019 Continue Shopping Button**: Cart: Empty cart; Drawer: Cart 3 items; Contact: Contact form; 404: 404
- **C020 Form Submit Button**: Home: Newsletter; Contact: Contact form; BlogA: Comments
- **C021 Newsletter Subscribe Button**: Home: Newsletter
- **C022 Back to Top Button**: Home: Footer (navigation, about, contact, support, shipping & returns, policies, social, payment icons, trust line, back to top); PLP: Footer; PDP: Footer; Cart: Footer; Drawer: Footer; Contact: Footer; FAQ: Footer; About: Footer; +8 more
- **C023 Call-to-Action Button (page CTAs)**: Home: Hero Banner; Home: Guided Finder / Quiz; Home: Video Section; Home: Promotional / Campaign Banner; PLP: Product Grid; PLP: Promotion; Cart: Empty cart; Drawer: Cart 3 items; +16 more
- **C024 Filters Open Button**: PLP: Sort, Product Count and Applied Filters
- **C025 Disabled / Sold-out Button**: PLP: Product Grid
- **C026 Share Button**: BlogA: Article
- **C027 Remove Line Button**: Cart: Cart lines; Drawer: Cart 3 items
- **C028 Wizard Step Button (Next / Back)**: Home: Guided Finder / Quiz
- **C029 Play Video Button**: Home: Video Section; PDP: Product: gallery and purchase panel
- **C030 Search Icon**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PLP: Product Grid; PDP: Header; Cart: Header; Drawer: Header; Contact: Header; FAQ: Header; +9 more
- **C031 Shopping Bag / Cart Icon**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PDP: Header; PDP: Buy buttons; Cart: Header; Drawer: Header; Contact: Header; FAQ: Header; +9 more
- **C032 Account / User Icon**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PDP: Header; Cart: Header; Drawer: Header; Contact: Header; FAQ: Header; About: Header; +8 more
- **C033 Menu / Hamburger Icon**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PDP: Header; Cart: Header; Drawer: Header; Contact: Header; FAQ: Header; About: Header; +8 more
- **C034 Close Icon**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PLP: Filters; PLP: Quick view; PDP: Header; PDP: Product images; Cart: Header; Drawer: Header; +12 more
- **C035 Chevron Icons (up, down, left, right)**: Home: Announcement Bar; Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); Home: Before & After; Home: Footer (navigation, about, contact, support, shipping & returns, policies, social, payment icons, trust line, back to top); PLP: Announcement bar; PLP: Header; PLP: Filters and Product Grid; PLP: Filters; +57 more
- **C036 Arrow Icons (left, right)**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); Home: Hero Banner; Home: Benefits / USP Row; Home: Shop by Category; Home: How to Use / Routine Steps; Home: Testimonials / Customer Reviews; Home: Logo List (Awards, Certifications, Press, Partner Brands); Home: Newsletter; +18 more
- **C037 Plus / Minus Icons**: Home: Footer (navigation, about, contact, support, shipping & returns, policies, social, payment icons, trust line, back to top); PLP: Footer; PDP: Buy buttons; PDP: Footer; Cart: Cart lines; Cart: Footer; Drawer: Footer; Drawer: Cart 3 items; +11 more
- **C038 Heart Icon**: Home: Benefits / USP Row
- **C039 Star / Rating Icon**: Home: Featured Collection (Best Sellers / New Arrivals); Home: Testimonials / Customer Reviews; PLP: Product Grid; PDP: Product information and purchase; PDP: Reviews; PDP: Related products
- **C040 Filter Icon**: PLP: Sort, Product Count and Applied Filters
- **C043 Location Icon**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); Home: Benefits / USP Row; PLP: Header; PDP: Header; Cart: Header; Drawer: Header; Contact: Header; Contact: Other ways to reach us; +11 more
- **C044 Phone Icon**: Contact: Other ways to reach us; Contact: Contact details
- **C045 Email Icon**: Contact: Other ways to reach us; Contact: Contact details
- **C046 Clock Icon**: Contact: Other ways to reach us; Contact: Contact details
- **C047 Social Media Icons (Instagram, Facebook, YouTube)**: Home: Footer (navigation, about, contact, support, shipping & returns, policies, social, payment icons, trust line, back to top); PLP: Footer; PDP: Footer; Cart: Footer; Drawer: Footer; Contact: Footer; FAQ: Footer; About: Footer; +8 more
- **C049 Security / Lock Icon**: Cart: Order summary; Drawer: Cart 3 items
- **C052 Check / Check-circle Icons**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); Home: Benefits / USP Row; Home: Newsletter; PLP: Header; PDP: Header; PDP: Buy buttons; PDP: Complete your routine; Cart: Header; +13 more
- **C053 Warning Icon**: PLP: Product Grid; PDP: Variant picker; Contact: Contact form
- **C054 Eye Icon**: PLP: Collection Banner
- **C055 Share Icon**: BlogA: Article
- **C056 Play Icon**: PDP: Product: gallery and purchase panel
- **C057 Zoom-in Icon**: PDP: Product: gallery and purchase panel
- **C062 Text Input**: PDP: Buy buttons; Cart: Cart lines; Cart: Order note and gift message; Drawer: Cart 3 items; Contact: Contact form; BlogA: Comments
- **C063 Email Input**: Home: Newsletter; Contact: Contact form; BlogA: Comments
- **C065 Search Input**: 404: 404
- **C066 Phone Input**: Contact: Contact form
- **C067 Select Dropdown**: PLP: Sort, Product Count and Applied Filters; Contact: Contact form
- **C068 Checkbox**: PLP: Filters and Product Grid; PLP: Filters; PDP: Complete your routine
- **C069 Radio Button**: PDP: Variant picker; PDP: Selling plan picker
- **C071 Range Slider**: Home: Before & After
- **C072 Quantity Input**: PDP: Buy buttons; Cart: Cart lines; Drawer: Cart 3 items
- **C073 Textarea**: Cart: Order note and gift message; Contact: Contact form; BlogA: Comments
- **C074 Newsletter Form**: Home: Newsletter
- **C075 Filter Inputs (facet checkboxes, price range)**: PLP: Filters and Product Grid; PLP: Filters
- **C076 Form Validation Message**: PDP: Variant picker; Contact: Contact form
- **C077 Input Label**: Home: Newsletter; PLP: Filters and Product Grid; PLP: Filters; PLP: Sort, Product Count and Applied Filters; PDP: Variant picker; PDP: Selling plan picker; PDP: Complete your routine; Cart: Order note and gift message; +3 more
- **C079 Contact Form**: Contact: Contact form
- **C080 Comment Form**: BlogA: Comments
- **C081 Order Note Field**: Cart: Order note and gift message
- **C082 Product Image**: PDP: Product: gallery and purchase panel; PDP: Related products
- **C083 Category Image**: Home: Shop by Category
- **C084 Hero Image**: Home: Hero Banner
- **C085 Banner Image**: Home: Promotional / Campaign Banner; PLP: Collection Banner
- **C086 Thumbnail Image**: PDP: Product: gallery and purchase panel
- **C087 Lifestyle / Look Image**: Home: Shop the Look
- **C088 Before / After Image**: Home: Before & After
- **C089 Video Thumbnail (poster)**: Home: Video Section
- **C091 Image Gallery**: Home: Customer Photo Gallery; PDP: Product: gallery and purchase panel
- **C092 Image Slider / Carousel**: PDP: Product: gallery and purchase panel; PDP: Product images
- **C094 Placeholder Image**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PDP: Header; PDP: Product: gallery and purchase panel; PDP: Product storytelling; PDP: Complete your routine; PDP: Related products; PDP: Product images; +23 more
- **C095 Customer Photo Tile**: Home: Customer Photo Gallery
- **C096 Homepage Product Card**: Home: Featured Collection (Best Sellers / New Arrivals)
- **C097 PLP Product Card**: PLP: Product Grid
- **C098 Hero Featured Product Card**: Home: Hero Banner
- **C099 Category Card**: Home: Shop by Category
- **C101 Concern Card**: Home: Shop by Concern / Need / Routine
- **C102 Review Card**: Home: Testimonials / Customer Reviews; PDP: Reviews
- **C103 Testimonial Card**: Home: Testimonials / Customer Reviews
- **C104 Blog Card**: BlogL: Article grid
- **C105 Article Card (featured)**: BlogL: Featured article
- **C106 Ingredient Card**: Home: Ingredient / Material Spotlight
- **C107 Benefit Card (USP item)**: Home: Benefits / USP Row
- **C109 Lookbook Card**: Home: Shop the Look
- **C110 Promotional Card**: Home: Promotional / Campaign Banner
- **C111 Recommendation Card**: PDP: Complete your routine; Cart: Cart upsell
- **C112 Related Product Card**: PDP: Related products
- **C114 Cart Item Card**: Cart: Cart lines; Drawer: Cart 3 items
- **C115 Contact Detail Card**: Contact: Contact details
- **C116 Value Card**: About: Values
- **C117 Timeline Milestone**: Story: Timeline
- **C118 At-a-glance Card**: Ship: At a glance; Return: At a glance; Privacy: At a glance; Terms: At a glance
- **C119 Mega Menu Card**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PDP: Header; Cart: Header; Drawer: Header; Contact: Header; FAQ: Header; About: Header; +8 more
- **C120 Quick Answer Card**: Contact: Quick answers
- **C121 Heading H1**: Home: Hero Banner; PLP: Collection Banner; PDP: Product information and purchase; Cart: Cart; Cart: Empty cart; Drawer: Unnamed content in main; Contact: Unnamed content in main; FAQ: Unnamed content in main; +9 more
- **C122 Heading H2**: Home: Shop by Category; Home: Featured Collection (Best Sellers / New Arrivals); Home: Shop by Concern / Need / Routine; Home: Guided Finder / Quiz; Home: Shop the Look; Home: Ingredient / Material Spotlight; Home: How to Use / Routine Steps; Home: Video Section; +52 more
- **C123 Heading H3**: Home: Featured Collection (Best Sellers / New Arrivals); Home: How to Use / Routine Steps; PLP: Product Grid; PLP: Promotion; PDP: Product storytelling; PDP: Related products; Contact: Contact form; About: Values; +4 more
- **C125 Section Heading**: Home: Shop by Category; Home: Featured Collection (Best Sellers / New Arrivals); Home: Shop by Concern / Need / Routine; Home: Ingredient / Material Spotlight; Home: Testimonials / Customer Reviews; Home: Customer Photo Gallery
- **C130 Price Typography**: PLP: Product Grid; PDP: Product information and purchase; PDP: Complete your routine; PDP: Related products; Cart: Cart lines; Drawer: Cart 3 items
- **C131 Discount Text**: PLP: Product Grid
- **C133 Label Text**: Home: Newsletter; PLP: Filters and Product Grid; PLP: Filters; PLP: Sort, Product Count and Applied Filters; PDP: Variant picker; PDP: Selling plan picker; PDP: Complete your routine; Cart: Order note and gift message; +3 more
- **C134 Rich Text Content**: Ship: Policy text; Return: Policy text; Privacy: Policy text; Terms: Policy text; BlogA: Article
- **C135 Pull Quote**: Story: Pull quote
- **C136 Announcement Bar**: Home: Announcement Bar; PLP: Announcement bar; PDP: Announcement bar; Cart: Announcement bar; Drawer: Announcement bar; Contact: Announcement bar; FAQ: Announcement bar; About: Announcement bar; +8 more
- **C137 Header**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PDP: Header; Cart: Header; Drawer: Header; Contact: Header; FAQ: Header; About: Header; +8 more
- **C138 Desktop Navigation**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PDP: Header; Cart: Header; Drawer: Header; Contact: Header; FAQ: Header; About: Header; +8 more
- **C139 Mega Menu**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PDP: Header; Cart: Header; Drawer: Header; Contact: Header; FAQ: Header; About: Header; +8 more
- **C140 Mobile Navigation / Hamburger Drawer**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PDP: Header; Cart: Header; Drawer: Header; Contact: Header; FAQ: Header; About: Header; +8 more
- **C141 Market Selector**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); PLP: Header; PDP: Header; Cart: Header; Drawer: Header; Contact: Header; FAQ: Header; About: Header; +8 more
- **C142 Breadcrumb**: PLP: Collection Banner; PDP: Breadcrumb; Contact: Unnamed content in main; FAQ: Unnamed content in main; About: Intro; Story: Intro; Ship: Unnamed content in main; Return: Unnamed content in main; +4 more
- **C143 Footer**: Home: Footer (navigation, about, contact, support, shipping & returns, policies, social, payment icons, trust line, back to top); PLP: Footer; PDP: Footer; Cart: Footer; Drawer: Footer; Contact: Footer; FAQ: Footer; About: Footer; +8 more
- **C144 Footer Link Group**: Home: Footer (navigation, about, contact, support, shipping & returns, policies, social, payment icons, trust line, back to top); PLP: Footer; PDP: Footer; Cart: Footer; Drawer: Footer; Contact: Footer; FAQ: Footer; About: Footer; +8 more
- **C145 Pagination**: PLP: Product Grid; BlogL: Pagination
- **C146 Tabs**: Home: Featured Collection (Best Sellers / New Arrivals)
- **C147 Accordion**: PLP: Filters and Product Grid; PLP: Filters; PDP: Product details; PDP: Product FAQ; FAQ: Question groups; Ship: Unnamed content in main; Return: Unnamed content in main; Privacy: Unnamed content in main; +1 more
- **C148 Sidebar Navigation (filter sidebar)**: PLP: Filters
- **C149 Sub-collection Links**: PLP: Sub-collection Links
- **C150 Product Price**: PLP: Product Grid; PDP: Product information and purchase; PDP: Complete your routine; PDP: Related products; Cart: Cart lines; Drawer: Cart 3 items
- **C151 Compare-at Price**: PLP: Product Grid; PDP: Product information and purchase; Cart: Cart lines; Drawer: Cart 3 items
- **C152 Discount Badge**: PLP: Product Grid
- **C153 Bestseller Badge**: PLP: Product Grid
- **C154 New Badge**: PLP: Product Grid
- **C155 Product Rating**: PLP: Product Grid; PDP: Product information and purchase; PDP: Reviews; PDP: Related products
- **C156 Review Count**: PLP: Product Grid; PDP: Product information and purchase; PDP: Reviews; PDP: Related products
- **C157 Product Variant Selector**: PDP: Variant picker
- **C158 Size Selector**: PLP: Filters and Product Grid; PLP: Filters; PDP: Variant picker
- **C159 Color Swatch**: PLP: Filters and Product Grid; PLP: Filters
- **C160 Quantity Selector**: PDP: Buy buttons; Cart: Cart lines; Drawer: Cart 3 items
- **C161 Quick View Panel**: PLP: Quick view
- **C163 Stock Status**: PLP: Product Grid
- **C164 Delivery Information**: PDP: Delivery, returns, pickup and trust
- **C165 Product Details Accordion**: PDP: Product details
- **C166 Selling Plan Picker**: PDP: Selling plan picker
- **C167 Buy Buttons Group**: PDP: Buy buttons
- **C168 Product Gallery**: PDP: Product: gallery and purchase panel
- **C169 Product Zoom Viewer**: PDP: Product images
- **C170 Cart Line Item**: Cart: Cart lines; Drawer: Cart 3 items
- **C171 Cart Summary**: Cart: Order summary
- **C172 Cart Drawer**: Drawer: Cart 3 items
- **C173 Cart Upsell**: Cart: Cart upsell
- **C176 Free Shipping Progress**: Cart: Cart; Drawer: Cart 3 items
- **C177 Badge**: PLP: Product Grid
- **C178 Chip**: Home: Guided Finder / Quiz; Home: Ingredient / Material Spotlight; PLP: Sub-collection Links; PLP: Product Grid; Cart: Empty cart; Drawer: Cart 3 items; FAQ: Unnamed content in main; BlogL: Unnamed content in main; +2 more
- **C179 Tag**: Home: Guided Finder / Quiz; Home: Ingredient / Material Spotlight
- **C182 Alert / Message**: PDP: Variant picker; PDP: Buy buttons; PDP: Complete your routine; Contact: Contact form
- **C183 Success Message**: PDP: Buy buttons; PDP: Complete your routine
- **C184 Error Message**: PDP: Variant picker; Contact: Contact form
- **C185 Empty State**: Cart: Empty cart; BlogL: No articles
- **C188 Progress Indicator**: Cart: Cart; Drawer: Cart 3 items
- **C189 Modal Dialog**: PLP: Filters; PLP: Quick view; PDP: Product images; Drawer: Cart 3 items
- **C190 Drawer**: PLP: Filters; PLP: Quick view; PDP: Product images; Drawer: Cart 3 items
- **C191 Popover / Disclosure Menu**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); Home: Footer (navigation, about, contact, support, shipping & returns, policies, social, payment icons, trust line, back to top); PLP: Header; PLP: Footer; PDP: Header; PDP: Footer; Cart: Header; Cart: Footer; +24 more
- **C192 Status / Live Region**: Home: Announcement Bar; Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer); Home: How to Use / Routine Steps; Home: Newsletter; PLP: Announcement bar; PLP: Header; PLP: Sort, Product Count and Applied Filters; PDP: Announcement bar; +34 more
- **C197 Divider**: Cart: Order summary
- **C201 Sticky Bar**: Home: Header (logo, menu, search, account, cart, sticky, country selector, mobile drawer)
- **C203 Scroller (horizontal carousel)**: Home: How to Use / Routine Steps; Home: Testimonials / Customer Reviews; Home: Logo List (Awards, Certifications, Press, Partner Brands)
- **C205 Skin Concern Selector**: Home: Shop by Concern / Need / Routine
- **C206 Skin Type Selector**: Home: Guided Finder / Quiz
- **C207 Guided Finder / Quiz**: Home: Guided Finder / Quiz
- **C208 Ingredient Information**: Home: Ingredient / Material Spotlight
- **C209 Ingredient Benefits**: PDP: Product storytelling
- **C210 How to Use**: Home: How to Use / Routine Steps
- **C211 Routine Steps**: Home: Shop by Concern / Need / Routine; Home: How to Use / Routine Steps
- **C212 Product Benefits**: Home: Benefits / USP Row
- **C213 Before and After**: Home: Before & After
- **C214 Certifications / Awards / Press Logos**: Home: Logo List (Awards, Certifications, Press, Partner Brands)
- **C218 Shop the Look**: Home: Shop the Look
- **C219 Complete Your Routine Bundle**: PDP: Complete your routine
- **C220 Page Hero / Intro Block**: PLP: Collection Banner; About: Intro; Story: Intro; 404: 404
- **C221 Policy Page Body**: Ship: Policy text; Return: Policy text; Privacy: Policy text; Terms: Policy text
- **C222 Policy Ask Panel (contact CTA)**: Ship: ask; Return: ask; Privacy: ask; Terms: ask
- **C223 Closing Call-to-Action Block**: FAQ: Still need help; About: Closing call to action; Story: What comes next; BlogL: No articles
- **C224 FAQ Question Group**: FAQ: Question groups
- **C225 Collection SEO Description**: PLP: Collection SEO Description
- **C226 Share Block**: BlogA: Article
- **C227 Custom Liquid Section**: Home: Custom Liquid Section
- **C228 Contact Details List**: Contact: Contact details

## Reuse decisions

### Can be reused as one component with variants
- **Button**: Design System primary, secondary, text and the Homepage Editorial styles are one base/button with named variants. Add to bag, Quick view, Checkout, Continue shopping, Apply filters and Send message are the same Button with different labels.
- **Icon**: every icon on every page is one `base/icon` selected by name.
- **Chip and Tag**: one `base/chip` with ds, editorial and editorial-tag variants.
- **Price, Rating, Badge, Quantity, Message, Breadcrumb, Input field**: base components exist and are valid. The PLP, PDP, Cart and Drawer repeat the same markup by hand, so these can be adopted without a visual change.
- **Cart line item**: the Cart page and the Cart Drawer show the same line (image, title, quantity, price, remove). One component with a `context` variant.
- **Choice patterns**: `.choice` (PLP facets, PDP bundle), `.opt` (PDP option cards), `.tile` (PDP) and `.swatch` (PLP) are four patterns for one idea, a selectable option. Candidate for one `Choice` base component with checkbox, radio, option-card and swatch variants.
- **Accordion**: native details with the `.accordion` classes is used on FAQ, PDP, PLP filters and the footer; one component.
- **Section heading, scroller controls**: already shared.
### Should stay separate (different layout or behaviour)
- **Homepage Product Card** and **PLP Product Card**: different layout and behaviour (the PLP card has swatches, quick view and generated badges). They share only base parts (media, price, rating, badge).
- **Design System Button** and **Editorial Button**: kept as two named variants of the same component because they differ in shape and case, as approved.
- **PDP option cards** versus **PLP swatches**: different interaction (single-select options with price versus colour dots). Keep as variants, not merged into one look.
- **Header mega-menu card** versus **Homepage category card**: different size and caption position.
