/* N-U-D-G-E Beauty: Tailwind theme mapped to the existing Design Variables.
   Every value is a CSS variable from 02-Design-Variables/Styles/variables.css, so the tokens stay the single source
   and their responsive tiers (type, spacing, gutters, drawer width) carry through. Nothing here defines a new value.
   Loaded after tailwindcss-play-*.js: the Play script reads the global `tailwind.config`.
   In the Shopify theme build the same object is the `theme` of a normal tailwind.config.js (Tailwind CLI). */
tailwind.config = {
  theme: {
    /* breakpoints follow the Design System tiers (phone, 600, tablet 768, laptop 1024, desktop 1280) */
    screens: { sm: '600px', md: '768px', lg: '1024px', xl: '1280px', '2xl': '1536px' },
    spacing: {
      0: '0px', px: '1px',
      1: 'var(--space-1)', 2: 'var(--space-2)', 3: 'var(--space-3)', 4: 'var(--space-4)', 5: 'var(--space-5)',
      6: 'var(--space-6)', 7: 'var(--space-7)', 8: 'var(--space-8)', 9: 'var(--space-9)', 10: 'var(--space-10)',
      12: 'var(--space-12)', 14: 'var(--space-14)', 16: 'var(--space-16)', 20: 'var(--space-20)', 24: 'var(--space-24)',
      gutter: 'var(--layout-gutter)', 'grid-gap': 'var(--layout-grid-gap)', section: 'var(--space-section)',
      touch: 'var(--touch-target-min)', 'control-x': 'var(--control-padding-x)', 'control-x-sm': 'var(--control-padding-x-sm)', 'control-x-lg': 'var(--control-padding-x-lg)', qty: 'var(--qty-input-width)'
    },
    colors: {
      transparent: 'transparent', current: 'currentColor',
      page: 'var(--color-bg-page)', surface: 'var(--color-bg-surface)', subtle: 'var(--color-bg-subtle)', inverse: 'var(--color-bg-inverse)',
      brand: {
        DEFAULT: 'var(--color-brand-primary)', hover: 'var(--color-brand-primary-hover)', active: 'var(--color-brand-primary-active)',
        secondary: 'var(--color-brand-secondary)', accent: 'var(--color-brand-accent)',
        tint: 'var(--color-brand-tint)', 'tint-strong': 'var(--color-brand-tint-strong)'
      },
      ink: {
        DEFAULT: 'var(--color-text-primary)', secondary: 'var(--color-text-secondary)', muted: 'var(--color-text-muted)',
        disabled: 'var(--color-text-disabled)', inverse: 'var(--color-text-inverse)',
        'inverse-secondary': 'var(--color-text-inverse-secondary)', 'on-brand': 'var(--color-text-on-brand)'
      },
      line: {
        DEFAULT: 'var(--color-border-subtle)', strong: 'var(--color-border-strong)',
        inverse: 'var(--color-border-inverse)', 'inverse-subtle': 'var(--color-border-inverse-subtle)'
      },
      status: {
        error: 'var(--color-status-error)', 'error-bg': 'var(--color-status-error-bg)',
        success: 'var(--color-status-success)', 'success-bg': 'var(--color-status-success-bg)',
        warning: 'var(--color-status-warning)', 'warning-bg': 'var(--color-status-warning-bg)'
      },
      link: { DEFAULT: 'var(--color-link)', hover: 'var(--color-link-hover)' },
      btn: {
        primary: 'var(--color-button-primary-bg)', 'primary-hover': 'var(--color-button-primary-bg-hover)', 'primary-active': 'var(--color-button-primary-bg-active)', 'primary-text': 'var(--color-button-primary-text)',
        secondary: 'var(--color-button-secondary-border)', 'secondary-hover': 'var(--color-button-secondary-bg-hover)', 'secondary-hover-text': 'var(--color-button-secondary-text-hover)',
        disabled: 'var(--color-button-disabled-bg)', 'disabled-text': 'var(--color-button-disabled-text)'
      },
      focus: 'var(--color-focus-ring)', scrim: 'var(--color-overlay-scrim)', rating: 'var(--color-rating-star)',
      warm: 'var(--warm)', 'warm-deep': 'var(--warm-deep)' /* mixes of existing tokens, defined in partials/base.tw.css */
    },
    fontFamily: { heading: ['var(--font-family-heading)'], body: ['var(--font-family-body)'] },
    /* font sizes from the --type-* role tokens. Size only, like the Design System components: line height, weight and letter spacing come from
       the element defaults (partials/base.tw.css) or from a full role class (.type-h2, .type-body-lg ... in partials/components.tw.css). */
    fontSize: Object.fromEntries(['display','h1','h2','h3','h4','h5','h6','body-lg','body','body-sm','caption','overline','label','button','nav','utility','input','price','price-lg','product-title'].map(function (r) {
      return [r, 'var(--type-' + r + '-font-size)'];
    })),
    lineHeight: { touch: 'var(--touch-target-min)', tight: 'var(--line-height-tight)', snug: 'var(--line-height-snug)', normal: 'var(--line-height-normal)', relaxed: 'var(--line-height-relaxed)' },
    letterSpacing: {
      display: 'var(--letter-spacing-display)', tight: 'var(--letter-spacing-tight)', normal: 'var(--letter-spacing-normal)',
      wide: 'var(--letter-spacing-wide)', uppercase: 'var(--letter-spacing-uppercase)', wider: 'var(--letter-spacing-wider)', widest: 'var(--letter-spacing-widest)'
    },
    fontWeight: { regular: 'var(--font-weight-regular)', medium: 'var(--font-weight-medium)', semibold: 'var(--font-weight-semibold)', bold: 'var(--font-weight-bold)' },
    borderRadius: {
      none: 'var(--radius-none)', sm: 'var(--radius-sm)', md: 'var(--radius-md)', lg: 'var(--radius-lg)',
      control: 'var(--radius-control)', card: 'var(--radius-card)', badge: 'var(--radius-badge)', pill: 'var(--radius-pill)', full: 'var(--radius-pill)'
    },
    borderWidth: { DEFAULT: 'var(--border-width-thin)', 0: '0px', thin: 'var(--border-width-thin)', thick: 'var(--border-width-thick)' },
    boxShadow: { none: 'none', sm: 'var(--shadow-sm)', md: 'var(--shadow-md)', lg: 'var(--shadow-lg)' },
    zIndex: {
      auto: 'auto', 0: '0', base: 'var(--z-base)', raised: 'var(--z-raised)', sticky: 'var(--z-sticky)', dropdown: 'var(--z-dropdown)',
      overlay: 'var(--z-overlay)', drawer: 'var(--z-drawer)', modal: 'var(--z-modal)', toast: 'var(--z-toast)', skip: 'var(--z-skip)'
    },
    opacity: { 0: '0', 100: '1', disabled: 'var(--opacity-disabled)', muted: 'var(--opacity-muted)', pressed: 'var(--opacity-pressed)' },
    transitionDuration: { DEFAULT: 'var(--duration-base)', fast: 'var(--duration-fast)', base: 'var(--duration-base)', slow: 'var(--duration-slow)' },
    transitionTimingFunction: { DEFAULT: 'var(--ease-standard)', standard: 'var(--ease-standard)', out: 'var(--ease-out)' },
    aspectRatio: { auto: 'auto', portrait: 'var(--aspect-portrait)', square: 'var(--aspect-square)', landscape: 'var(--aspect-landscape)', tall: 'var(--aspect-tall)', wide: 'var(--aspect-wide)' },
    maxWidth: {
      none: 'none', full: '100%', container: 'var(--container-max)', wide: 'var(--container-wide)', narrow: 'var(--container-narrow)', text: 'var(--container-text)',
      drawer: 'var(--layout-drawer-width)'
    },
    extend: {
      width: { drawer: 'var(--layout-drawer-width)' },
      minHeight: { 'control-sm': 'var(--control-height-sm)', 'control-md': 'var(--control-height-md)', 'control-lg': 'var(--control-height-lg)' }
    }
  }
};


/* INTERACTIVE PROTOTYPE EARLY HOOK (dormant; see interactive-website/documentation/architecture notes in README.md). This file runs synchronously in <head>, before the body is parsed, so the reviewer panel and
   annotation notes can be hidden BEFORE first paint when interactive mode is on (hiding them later, from the deferred nav.js, caused a large layout shift). Same activation as the hook at the end of nav.js.
   Opened directly with interactive mode off, nothing happens. Not copied into the Shopify theme. */
(function () {
  try {
    var on = /[?&]ix=1(&|$)/.test(location.search);
    if (!on) { try { on = localStorage.getItem('nudge.interactive') === '1'; } catch (e) { on = false; } if (!on && String(window.name).indexOf('nudge') === 0) on = true; }
    if (!on) return;
    var s = document.createElement('style'); s.id = 'ix-hide-review';
    s.textContent = '.rv,#wp,.ann,section[data-section="Custom Liquid Section"]{display:none!important}';
    document.head.appendChild(s);
    /* PDP of a product other than the wireframe's own: its shade and size pickers are removed by the layer; hide them now too so nothing jumps afterwards (the layer shows the shade picker again for products that have shades) */
    var pm = /[?&]p=([a-z0-9-]+)/.exec(location.search);
    if (pm && pm[1] !== 'tinted-moisturiser' && /03-NUDGE-Beauty-PDP/.test(location.pathname)) { var s2 = document.createElement('style'); s2.id = 'ix-early-pdp'; s2.textContent = 'fieldset:has(#shade-tiles),fieldset:has(#size-opts){display:none!important}'; document.head.appendChild(s2); }
    /* pages whose content the layer fills from shared state (PLP filters, PDP product, Cart lines): keep the content and footer invisible (layout kept, so nothing visible shifts) until the layer is ready; a timer removes this in case the layer never loads */
    if (/0[2-5]-NUDGE-Beauty-(PLP|PDP|Cart)/.test(location.pathname)) { var s3 = document.createElement('style'); s3.id = 'ix-early-main'; s3.textContent = 'html:not([data-ix]) main,html:not([data-ix]) footer{visibility:hidden}'; document.head.appendChild(s3); setTimeout(function () { s3.remove(); }, 6000); }
  } catch (e) { /* never break the page */ }
})();