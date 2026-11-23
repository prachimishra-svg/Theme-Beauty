# Builds THE shareable interactive website: ONE self-contained folder, <project>/NUDGE-Interactive-Website.
#   index.html                start page
#   README.md                 how to open it and what is not real
#   pages/                    the 16 pages (home.html, collection.html, product.html, cart.html ...)
#   assets/css, assets/js, assets/fonts, assets/js/interactive   everything the pages load
#   docs/                     what is missing or needs Shopify
# No design-system, design-variable, wireframe or component-library folders: their files are copied in and every reference is rewritten.
# Source files are COPIED; nothing in the project is moved or changed. Interactive mode is ON by default in the copy; add ?ix=0 to see a page plain.
# Usage: .\tools\build-single-folder.ps1 [-Name NUDGE-Interactive-Website]
param([string]$Name = 'NUDGE-Interactive-Website')
$ErrorActionPreference = 'Stop'
$IW = Split-Path -Parent $PSScriptRoot; $PRJ = Split-Path -Parent $IW; $utf8 = New-Object Text.UTF8Encoding($false)
& (Join-Path $PSScriptRoot 'build-bundle.ps1') | Out-Null
$out = Join-Path $PRJ $Name; $marker = Join-Path $out '.single-folder-build'
if (Test-Path $out) { if (-not (Test-Path $marker)) { throw "$out exists and was not created by this script; refusing to touch it" }; Remove-Item $out -Recurse -Force }
foreach ($d in 'pages', 'assets\css', 'assets\js\interactive', 'assets\fonts', 'docs') { New-Item -ItemType Directory -Force (Join-Path $out $d) | Out-Null }
[IO.File]::WriteAllText($marker, "generated $(Get-Date -Format s) by tools/build-single-folder.ps1`n", $utf8)
function Src($rel) { $p = Join-Path $PRJ $rel; if (-not (Test-Path $p)) { throw "missing source $rel" }; $p }
function Clean($x) { $x.Replace('../../02-Design-Variables/Styles/', '').Replace('../../02-Design-Variables/Tokens/', 'the design tokens/').Replace('02-Design-Variables/Tokens/build-tokens.ps1', 'the token build script').Replace('02-Design-Variables/Styles/', '').Replace('03-Wireframes/00-Shared-Tailwind-Foundation/build.ps1', 'the wireframe build script').Replace('03-Wireframes/00-Shared-Tailwind-Foundation/', 'assets/js/').Replace('(03-Wireframes)', '').Replace('03-Wireframes', 'wireframes').Replace('01-Design-System', 'Design System').Replace('02-Design-Variables', 'Design Variables').Replace('07-Component-Library', 'Component Library').Replace('00-Shared-Tailwind-Foundation', 'shared foundation').Replace('05-Assets', 'assets') }
function Put($rel, $text) { [IO.File]::WriteAllText((Join-Path $out $rel), (Clean $text), $utf8) }
function CopyClean($srcRel, $destRel) { Put $destRel ([IO.File]::ReadAllText((Src $srcRel), $utf8)) }
function Rep($text, $old, $new, $what) { if (-not $text.Contains($old)) { throw "pattern not found ($what): $old" }; $text.Replace($old, $new) }
# ---- page names ----
$names = [ordered]@{ '01' = 'home'; '02' = 'collection'; '03' = 'product'; '04' = 'cart'; '05' = 'cart-drawer'; '06' = 'contact'; '07' = 'faq'; '08' = 'about'; '09' = 'our-story'; '10' = 'shipping-policy'; '11' = 'returns-policy'; '12' = 'privacy-policy'; '13' = 'terms'; '14' = 'blog'; '15' = 'article'; '16' = '404' }
$byOld = @{}; $dirs = Get-ChildItem (Join-Path $PRJ '03-Wireframes') -Directory | Where-Object { $_.Name -match '^(\d\d)-NUDGE' } | Sort-Object Name
foreach ($d in $dirs) { $n = $d.Name.Substring(0, 2); $f = Get-ChildItem $d.FullName -Filter *.html -File | Where-Object { $_.Name -notmatch '\.bk\.' } | Select-Object -First 1; $byOld[$f.Name] = $names[$n] + '.html' }
# ---- assets ----
$F = '03-Wireframes\00-Shared-Tailwind-Foundation'
Copy-Item (Src "$F\tailwindcss-play-3.4.17.js") (Join-Path $out 'assets\js\tailwind-play.js')
foreach ($j in 'currency.js', 'cart-render.js') { CopyClean "$F\$j" "assets\js\$j" }
foreach ($j in 'drawer.js', 'chip-row.js') { CopyClean "01-Design-System\Scripts\$j" "assets\js\$j" }
CopyClean '07-Component-Library\engine.js' 'assets\js\engine.js'
CopyClean '02-Design-Variables\Styles\variables.css' 'assets\css\variables.css'
$css = [IO.File]::ReadAllText((Src '01-Design-System\Styles\foundation.css'), $utf8); $css = Rep $css 'url("../../05-Assets/Fonts/' 'url("../fonts/' 'font urls'; Put 'assets\css\foundation.css' $css
Get-ChildItem (Src '05-Assets\Fonts') -File | ForEach-Object { Copy-Item $_.FullName (Join-Path $out "assets\fonts\$($_.Name)") }
# ---- Tailwind config with the early hook (interactive on by default) ----
$cfg = [IO.File]::ReadAllText((Src "$F\tailwind.config.js"), $utf8); $i = $cfg.IndexOf('/* INTERACTIVE PROTOTYPE EARLY HOOK'); if ($i -lt 0) { throw 'tailwind.config.js hook marker not found' }
$hookCfg = @'
/* INTERACTIVE WEBSITE EARLY HOOK. Runs in <head> before the body is parsed: hides the reviewer panel, annotation notes and the empty Custom Liquid slot before first paint, and keeps the pages that the
   interactive layer fills (collection, product, cart) invisible until it is ready, so nothing visibly jumps. ?ix=0 turns all of this off for that page view. */
(function () {
  try {
    if (/[?&]ix=0(&|$)/.test(location.search)) return;
    var s = document.createElement('style'); s.id = 'ix-hide-review';
    s.textContent = '.rv,#wp,.ann,section[data-section="Custom Liquid Section"]{display:none!important}';
    document.head.appendChild(s);
    var pm = /[?&]p=([a-z0-9-]+)/.exec(location.search);
    if (pm && pm[1] !== 'tinted-moisturiser' && /\/product\.html$/.test(location.pathname)) { var s2 = document.createElement('style'); s2.id = 'ix-early-pdp'; s2.textContent = 'fieldset:has(#shade-tiles),fieldset:has(#size-opts){display:none!important}'; document.head.appendChild(s2); }
    if (/\/(collection|product|cart|cart-drawer)\.html$/.test(location.pathname)) { var s3 = document.createElement('style'); s3.id = 'ix-early-main'; s3.textContent = 'html:not([data-ix]) main,html:not([data-ix]) footer{visibility:hidden}'; document.head.appendChild(s3); setTimeout(function () { s3.remove(); }, 6000); }
  } catch (e) { /* never break the page */ }
})();
'@
Put 'assets\js\tailwind.config.js' ($cfg.Substring(0, $i) + $hookCfg)
# ---- nav.js with the loader (interactive on by default) ----
$nav = [IO.File]::ReadAllText((Src "$F\nav.js"), $utf8); $i = $nav.IndexOf('/* INTERACTIVE PROTOTYPE HOOK'); if ($i -lt 0) { throw 'nav.js hook marker not found' }
$hookNav = @'
/* INTERACTIVE WEBSITE: the interactive layer is ON by default. Add ?ix=0 to a page address to see it as the plain wireframe. Loads interactive/boot.js. */
(function () {
  try {
    if (/[?&]ix=0(&|$)/.test(location.search)) return;
    var me = document.currentScript || document.querySelector('script[src$="nav.js"]'); if (!me || !me.src) return;
    var s = document.createElement('script'); s.src = new URL('interactive/boot.js', me.src).href; document.head.appendChild(s);
  } catch (e) { /* never break the page */ }
})();
'@
Put 'assets\js\nav.js' ($nav.Substring(0, $i) + $hookNav)
# ---- the interactive layer ----
$boot = [IO.File]::ReadAllText((Src 'interactive-website\runtime\boot.js'), $utf8)
$boot = Rep $boot "b.src = ROOT + 'runtime/interactive.bundle.js';" "b.src = new URL('interactive.bundle.js', NS.base).href;" 'boot bundle url'
$boot = Rep $boot "b.onerror = function () { loadEach(); };" "b.onerror = function () { NS.log.errors.push('interactive.bundle.js not found'); document.documentElement.setAttribute('data-ix', 'error'); };" 'boot fallback'
Put 'assets\js\interactive\boot.js' $boot
$b = [IO.File]::ReadAllText((Src 'interactive-website\runtime\interactive.bundle.js'), $utf8)
$b = Rep $b "'../../03-Wireframes/00-Shared-Tailwind-Foundation/cart-render.js'" "'../cart-render.js'" 'cart-render path'
$b = Rep $b "'../../01-Design-System/Scripts/drawer.js'" "'../drawer.js'" 'drawer path'
foreach ($old in $byOld.Keys) { $b = [regex]::Replace($b, "\['\d\d-NUDGE-Beauty-[A-Za-z0-9-]+', '" + [regex]::Escape($old) + "'\]", "['pages', '" + $byOld[$old] + "']") }
if ($b -match '\d\d-NUDGE-Beauty') { throw 'a page folder name is still referenced in the bundle' }
# comments that name the old folders: point them at the new layout
$b = $b.Replace('03-Wireframes/00-Shared-Tailwind-Foundation/cart-render.js', 'assets/js/cart-render.js').Replace('03-Wireframes/05-.../Cart_Drawer_Wireframe_v1.html', 'pages/cart-drawer.html').Replace('03-Wireframes/00-Shared-Tailwind-Foundation/', 'assets/js/')
$b = Rep $b "new URL('../' + PAGES[r.page][0] + '/' + PAGES[r.page][1] + '?'" "new URL(PAGES[r.page][1] + '?'" 'route href'
$b = Rep $b "if (PAGES[k][0] === f[0]) key = k;" "if (PAGES[k][1] === f[1]) key = k;" 'current page'
$oldExit = "if (a === 'exit') { try { g.localStorage.removeItem('nudge.interactive'); } catch (x) { /* blocked */ } g.name = ''; var u = new URL(g.location.href); u.searchParams.delete('ix'); g.location.href = u.href; }"
$b = Rep $b $oldExit "if (a === 'exit') { var u = new URL(g.location.href); u.searchParams.set('ix', '0'); g.location.href = u.href; }" 'pill exit'
$b = Rep $b 'Exit interactive mode' 'View this page as plain wireframe' 'pill label'
Put 'assets\js\interactive\interactive.bundle.js' $b
# ---- the 16 pages with every reference rewritten ----
foreach ($d in $dirs) {
  $f = Get-ChildItem $d.FullName -Filter *.html -File | Where-Object { $_.Name -notmatch '\.bk\.' } | Select-Object -First 1; $t = [IO.File]::ReadAllText($f.FullName, $utf8)
  $t = $t.Replace('../00-Shared-Tailwind-Foundation/tailwindcss-play-3.4.17.js', '../assets/js/tailwind-play.js')
  foreach ($j in 'tailwind.config.js', 'currency.js', 'nav.js', 'cart-render.js') { $t = $t.Replace("../00-Shared-Tailwind-Foundation/$j", "../assets/js/$j") }
  $t = $t.Replace('../../01-Design-System/Scripts/', '../assets/js/').Replace('../../01-Design-System/Styles/foundation.css', '../assets/css/foundation.css').Replace('../../02-Design-Variables/Styles/variables.css', '../assets/css/variables.css').Replace('../../07-Component-Library/engine.js', '../assets/js/engine.js')
  $t = [regex]::Replace($t, '\.\./\d\d-NUDGE-[A-Za-z-]+/([A-Za-z0-9_]+\.html)', { param($m) $k = $m.Groups[1].Value; if (-not $byOld.ContainsKey($k)) { throw "link to unknown page $k" }; $byOld[$k] })
  if ($t -match '(?:src|href)="[^"]*(\.\./\d\d-NUDGE|00-Shared-Tailwind-Foundation|01-Design-System|02-Design-Variables|07-Component-Library|05-Assets)') { throw "old folder reference left in $($f.Name)" }
  # the remaining mentions are in CSS comments and the hidden review notes: name the things instead of the old folders
  $t = $t.Replace('01-Design-System', 'Design System').Replace('02-Design-Variables', 'Design Variables').Replace('07-Component-Library', 'Component Library').Replace('00-Shared-Tailwind-Foundation', 'shared foundation').Replace('05-Assets', 'assets')
  Put "pages\$($byOld[$f.Name])" $t
}
# ---- start page, README, docs ----
$indexHtml = @'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>NUDGE Beauty: interactive website</title>
<link rel="stylesheet" href="assets/css/variables.css">
<style>
 body{margin:0;font:16px/1.5 var(--font-body,system-ui,sans-serif);background:var(--color-bg-page);color:var(--color-text-primary);display:grid;place-items:center;min-height:100vh;padding:24px}
 main{max-width:36rem}
 h1{font-size:28px;margin:0 0 8px;font-family:var(--font-heading,inherit)} p{margin:0 0 16px}
 a.btn{display:inline-block;background:var(--color-bg-inverse);color:var(--color-text-inverse);padding:12px 24px;border-radius:var(--radius-pill);text-decoration:none;min-height:24px}
 ul{padding-left:20px;margin:0 0 16px} li{margin:4px 0} a.q{color:var(--color-text-primary)}
</style>
</head>
<body>
<main>
 <h1>NUDGE Beauty: interactive website</h1>
 <p>A clickable prototype built from the approved wireframes. Browse collections, open products, add to bag, search, read the journal. It runs from this folder, offline, with nothing to install.</p>
 <p><a class="btn" href="pages/home.html">Open the website</a></p>
 <ul>
  <li><a class="q" href="README.md">How to use it and what is not real</a></li>
  <li><a class="q" href="docs/missing-features-and-dependencies.md">What is missing or needs Shopify</a></li>
 </ul>
 <p style="font-size:14px">Checkout, accounts, payments and wishlist are not simulated. Products and prices are sample data.</p>
</main>
</body>
</html>
'@
Put 'index.html' $indexHtml
$readme = @'
# NUDGE Beauty: interactive website

One folder. Everything the website needs is inside it.

## Open it
1. If you received a .zip, **extract it fully first** (do not open files from inside the zip preview).
2. Open **index.html** (double-click, or drag it into Chrome, Edge, Firefox or Safari) and click **Open the website**.
   You can also open `pages/home.html` directly.
3. No internet, server, Node or install is needed. Keep the folder together: move or share the whole `NUDGE-Interactive-Website` folder.

## What works
Header and footer links, mega menu, collections with filters, product pages, add to bag, cart drawer and cart page (quantity, remove, undo), search, the journal with article pages and tags, policy and help pages, back, forward and refresh. The bag and recent searches are remembered in the browser.

## What is not real
Checkout, payment, accounts, wishlist, newsletter and contact form delivery, product reviews, real stock. Makeup, hair and body collections have no sample products. Products and prices are sample data. Details: `docs/missing-features-and-dependencies.md`.

## Tips
* Small pill at the bottom left of every page: **Load sample cart**, **Reset prototype data**, **View this page as plain wireframe**.
* Add `?ix=0` to a page address to see that page as the original wireframe.
* If a page looks unstyled or buttons do nothing, the folder was split or the zip was not fully extracted.
* Chrome and Edge give the best result.

## Folder map
* `index.html` start page
* `pages/` the 16 pages: home, collection, product, cart, cart-drawer, contact, faq, about, our-story, shipping-policy, returns-policy, privacy-policy, terms, blog, article, 404
* `assets/css`, `assets/js`, `assets/fonts` styles, scripts and fonts
* `assets/js/interactive/` the code that connects the pages (links, cart, search)
* `docs/` limits and Shopify notes
'@
Put 'README.md' $readme
Put 'docs\missing-features-and-dependencies.md' ([IO.File]::ReadAllText((Join-Path $IW 'documentation\missing-features-and-dependencies.md'), $utf8))
# ---- verify ----
$bad = @(); $abs = @(); $count = 0
foreach ($f in (Get-ChildItem $out -Recurse -File | Where-Object { $_.Extension -in '.html', '.css', '.js' -and $_.Name -ne 'tailwind-play.js' })) { $t = [IO.File]::ReadAllText($f.FullName, $utf8); $dir = Split-Path $f.FullName
  if ($f.Extension -in '.html', '.css') { $refs = @(); $refs += [regex]::Matches($t, '(?:src|href)="([^"#][^"]*)"') | ForEach-Object { $_.Groups[1].Value }; $refs += [regex]::Matches($t, 'url\(([^)]+)\)') | ForEach-Object { $_.Groups[1].Value.Trim('"', "'") }
    foreach ($r in ($refs | Select-Object -Unique)) { if ($r -match '^(https?:|mailto:|tel:|data:|#|javascript:)') { if ($r -match '^https?:') { $abs += "$($f.Name): external $r" }; continue }; $clean = ($r -split '[?#]')[0]; if (-not $clean -or $clean -notmatch '\.(js|css|woff2?|png|jpe?g|svg|webp|ico|json|html|md)$') { continue }; $count++; if (-not (Test-Path ([IO.Path]::GetFullPath((Join-Path $dir ($clean -replace '/', '\')))))) { $bad += "$($f.Name) -> $r" } } }
  if ($t -match '(?i)[A-Z]:\\(Users|UI UX)|file:///[A-Za-z]:|PRACHI|Prachi|UI UX Folder|beauty-theme|localhost|127\.0\.0\.1|03-Wireframes|00-Shared-Tailwind|01-Design-System|02-Design-Variables|07-Component-Library|05-Assets') { $abs += "$($f.Name): machine-specific text or old folder name" } }
$n = (Get-ChildItem $out -Recurse -File).Count; $size = [Math]::Round((Get-ChildItem $out -Recurse -File | Measure-Object Length -Sum).Sum / 1KB)
"folder: $out"; "files: $n ($size KB); references checked: $count; unresolved: $($bad.Count); machine-specific or old-folder or external: $(@($abs | Select-Object -Unique).Count)"
$bad | ForEach-Object { "UNRESOLVED $_" }; $abs | Select-Object -Unique | ForEach-Object { "FLAGGED $_" }
if ($bad.Count -or $abs.Count) { throw 'verification failed' }
(Get-ChildItem $out -Directory | ForEach-Object { $_.Name + '/' }) -join '  '
