# Vendored test tools (verification only; never shipped in the theme)

| File | Package | Version | SHA-256 | Source |
|---|---|---|---|---|
| liquid.browser.min.js | liquidjs | 10.21.0 | 3B798F82470334D4D29FC331D595F012F41D06275A799D8AE8BBAE8A144B6605 | https://cdn.jsdelivr.net/npm/liquidjs@10.21.0/dist/liquid.browser.min.js |
| axe.min.js | axe-core | 4.10.2 | B511CD9DEC01C76F4B2AD1723B66B6DB37D4C2EB4ED199076E1829D9EE7B75E3 | https://cdn.jsdelivr.net/npm/axe-core@4.10.2/axe.min.js |

Downloaded on 2026-11-17 with the user's approval (decision D3). Both are open source. They are loaded only by pages that headless Chrome opens from tools/ (the Liquid harness and the accessibility test), never by the theme itself. To check integrity, recompute the SHA-256 and compare with the table.