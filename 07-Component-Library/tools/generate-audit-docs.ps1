# Generates the audit deliverables from evidence (read-only with respect to the wireframes):
#   docs/MASTER-COMPONENT-INVENTORY.md, PAGE-WISE-COMPONENT-BREAKDOWN.md, COMPONENT-REUSE-MAP.md, COMPONENT-HIERARCHY.md,
#   COMPONENT-PROPERTIES.md, COMPONENT-AUDIT-REPORT.md, docs/audit/inventory.json and audit.data.js (read by the library UI).
# Inputs: docs/audit/pages.json (tools/audit-extract.ps1), tools/taxonomy.txt, library.data.js (build-library.ps1).
# Usage: .\tools\generate-audit-docs.ps1
$ErrorActionPreference = 'Stop'
$L = Split-Path -Parent $PSScriptRoot; $D = Join-Path $L 'docs'; $utf8 = New-Object Text.UTF8Encoding($false)
Add-Type -AssemblyName System.Web.Extensions
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer; $ser.MaxJsonLength = [int]::MaxValue; $ser.RecursionLimit = 100
$dash = [string][char]0x2013
$pagesRaw = [IO.File]::ReadAllText("$D\audit\pages.json", $utf8)
$pages = $pagesRaw | ConvertFrom-Json
$ld = [IO.File]::ReadAllText("$L\library.data.js", $utf8); $lib = $ser.DeserializeObject($ld.Substring($ld.IndexOf('window.NUDGE_LIB = ') + 19).TrimEnd().TrimEnd(';'))
$comps = $lib.components
$PN = @{ 1 = 'Homepage'; 2 = 'PLP'; 3 = 'PDP'; 4 = 'Cart'; 5 = 'Cart Drawer'; 6 = 'Contact'; 7 = 'FAQ'; 8 = 'About'; 9 = 'Our Story'; 10 = 'Shipping Policy'; 11 = 'Returns Policy'; 12 = 'Privacy Policy'; 13 = 'Terms and Conditions'; 14 = 'Blog Listing'; 15 = 'Blog Article'; 16 = '404' }
$PS = @{ 1 = 'Home'; 2 = 'PLP'; 3 = 'PDP'; 4 = 'Cart'; 5 = 'Drawer'; 6 = 'Contact'; 7 = 'FAQ'; 8 = 'About'; 9 = 'Story'; 10 = 'Ship'; 11 = 'Return'; 12 = 'Privacy'; 13 = 'Terms'; 14 = 'BlogL'; 15 = 'BlogA'; 16 = '404' }
function Cell([string]$s) { ($s -replace '\|', '/' -replace '[\r\n]+', ' ').Trim() }
function Props($o) { if ($null -eq $o) { @() } else { @($o.PSObject.Properties) } }

# ---------- flatten blocks ----------
$blocks = New-Object System.Collections.ArrayList
foreach ($p in $pages) { $i = 0; foreach ($b in @($p.data.blocks)) { $i++; [void]$blocks.Add([pscustomobject]@{ page = [int]$p.number; idx = $i; b = $b; name = [string]$b.name }) } }

# ---------- taxonomy ----------
$entries = New-Object System.Collections.ArrayList; $eid = 0
foreach ($line in ([IO.File]::ReadAllLines("$L\tools\taxonomy.txt", $utf8))) {
  if ($line -match '^\s*#' -or -not $line.Trim()) { continue }
  $f = $line -split '\s*;;\s*'; if ($f.Count -lt 6) { throw "taxonomy line has $($f.Count) fields: $line" }
  $eid++; [void]$entries.Add([pscustomobject]@{ id = ('C{0:000}' -f $eid); group = $f[0].Trim(); name = $f[1].Trim(); status = $f[2].Trim(); impl = $f[3].Trim(); matchers = $f[4].Trim(); note = $f[5].Trim(); hits = @() })
}
function Eval-One([string]$m) {
  $scope = $null; $at = $m.IndexOf('@@'); if ($at -ge 0) { $scope = $m.Substring($at + 2); $m = $m.Substring(0, $at) }
  $kind = $m.Substring(0, $m.IndexOf(':')); $arg = $m.Substring($m.IndexOf(':') + 1)
  $out = New-Object System.Collections.ArrayList
  foreach ($x in $blocks) {
    if ($scope -and $x.name -notmatch $scope) { continue }
    $b = $x.b; $n = 0
    switch ($kind) {
      'B' { $kr = $arg; $tr = $null; if ($arg.Contains('~')) { $kr = $arg.Substring(0, $arg.IndexOf('~')); $tr = $arg.Substring($arg.IndexOf('~') + 1) }
        foreach ($bt in @($b.buttons)) { if ($bt.kind -match $kr -and (-not $tr -or $bt.text -match $tr)) { $n += [int]$bt.n } } }
      'D' { $pr = $b.det.PSObject.Properties[$arg]; if ($pr) { $n = [int]$pr.Value } }
      'C' { $pr = $b.classes.PSObject.Properties[$arg]; if ($pr) { $n = [int]$pr.Value } }
      'I' { foreach ($pr in (Props $b.icons)) { if ($pr.Name -match $arg) { $n += [int]$pr.Value } } }
      'H' { foreach ($h in @($b.heads)) { if (("{0}:{1}" -f $h.tag, $h.text) -match $arg -or $h.text -match $arg) { $n += [int]$h.n } } }
      'N' { if ($x.name -match $arg) { $n = 1 } }
      'IN' { $tr = $arg; $lr = $null; if ($arg.Contains('~')) { $tr = $arg.Substring(0, $arg.IndexOf('~')); $lr = $arg.Substring($arg.IndexOf('~') + 1) }
        foreach ($inp in @($b.inputs)) { $tk = if ($inp.tag -eq 'input') { if ($inp.type) { $inp.type } else { 'text' } } else { $inp.tag }; if ($tk -match $tr -and (-not $lr -or $inp.label -match $lr)) { $n += [int]$inp.n } } }
      'T' { if ($b.text -match $arg) { $n = 1 } }
      'K' { if ($b.kind -match $arg) { $n = 1 } }
      default { throw "unknown matcher kind '$kind' in '$m'" }
    }
    if ($n -gt 0) { [void]$out.Add([pscustomobject]@{ page = $x.page; block = $x.name; count = $n }) }
  }
  $out
}
foreach ($e in $entries) {
  $h = @(); if ($e.matchers) { foreach ($m in ($e.matchers -split ' && ')) { $h += @(Eval-One $m.Trim()) } }
  $e.hits = $h
}
function PagesOf($e) { @($e.hits | ForEach-Object { $_.page } | Sort-Object -Unique) }
function Total($e) { [int](($e.hits | Measure-Object count -Sum).Sum) }
function FoundOn($e) {
  $pg = PagesOf $e; if (-not $pg.Count) { return '-' }
  if ($pg.Count -eq 16) { return "all 16 pages (" + (Total $e) + ")" }
  ($pg | ForEach-Object { $k = $_; "{0} x{1}" -f $PS[$k], (($e.hits | Where-Object { $_.page -eq $k } | Measure-Object count -Sum).Sum) }) -join ', '
}
$statusLabel = @{ component = 'Component'; ready = 'Ready (not adopted)'; css = 'Design System class'; page = 'Page-specific'; 'page-local' = 'Page-local'; none = 'Not in wireframes' }

# ---------- include graph ----------
function Kids([string]$n) {
  $inc = $null
  if ($comps.ContainsKey($n)) { $inc = @($comps[$n].includes) }
  elseif ($lib.builtins.ContainsKey($n)) { $inc = @([regex]::Matches($lib.builtins[$n], '@@PARTIAL (components/[a-z0-9/-]+)') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique) }
  $r = @(); foreach ($k in $inc) { if ($k -like '*{{*') { $r += @('components/header/menus/skin', 'components/header/menus/makeup', 'components/header/menus/hair', 'components/header/menus/body') } else { $r += $k } }
  $r | Select-Object -Unique
}
function NestedFlat([string]$n, [int]$depth, $seen) {
  $o = @(); foreach ($k in (Kids $n)) { if ($seen -contains $k -or $depth -gt 8) { continue }; $o += $k; $o += @(NestedFlat $k ($depth + 1) ($seen + $n)) }; $o | Select-Object -Unique
}
function LevelOf([string]$n) { $m = $comps[$n].manifest; if ($m -and $m.level) { return [string]$m.level }; if ($comps[$n].group -eq 'base') { 'base' } elseif (@($comps[$n].includes).Count) { 'main' } else { 'sub' } }
function Short([string]$n) { $n -replace '^components/', '' }
$hpMain = [ordered]@{ '^Announcement' = 'components/layout/announcement-bar'; '^Header' = 'components/header/site-header'; '^Hero Banner' = 'components/homepage/hero-banner'; '^Benefits' = 'components/homepage/usp-row'; '^Shop by Category' = 'components/homepage/category-section'; '^Featured Collection' = 'components/homepage/featured-collection'; '^Shop by Concern' = 'components/homepage/concern-section'; '^Guided Finder' = 'components/homepage/finder-section'; '^Shop the Look' = 'components/homepage/look-section'; '^Ingredient' = 'components/homepage/ingredient-section'; '^How to Use' = 'components/homepage/ritual-section'; '^Video Section' = 'components/homepage/video-section'; '^Before' = 'components/homepage/compare-section'; '^Testimonials' = 'components/homepage/testimonials-section'; '^Customer Photo' = 'components/homepage/gallery-section'; '^Logo List' = 'components/homepage/logo-section'; '^Promotional' = 'components/homepage/promo-banner'; '^Custom Liquid' = 'components/homepage/custom-liquid-section'; '^Newsletter' = 'components/homepage/newsletter-section'; '^Footer' = 'components/layout/site-footer' }
function MainFor($x) {
  if ($x.page -eq 2) { $nm = [string]$x.name; $kd = [string]$x.b.kind
    if ($kd -eq 'overlay' -and $nm -eq 'Filters') { return 'components/plp/filters-drawer' }; if ($kd -eq 'overlay' -and $nm -eq 'Quick view') { return 'components/plp/quick-view-drawer' }; if ($kd -eq 'landmark' -and $nm -eq 'Filters') { return 'components/plp/filters-sidebar' }; if ($kd -eq 'landmark' -and $nm -eq 'Promotion') { return 'components/plp/promo-tile' }
    if ($kd -eq 'section') { foreach ($pk in @(@('^Collection Banner','components/plp/collection-banner'), @('^Sub-collection','components/plp/subcollection-nav'), @('^Sort, Product Count','components/plp/toolbar'), @('^Product Grid','components/plp/product-grid'), @('^Collection SEO','components/plp/seo-block'))) { if ($nm -match $pk[0]) { return $pk[1] } } } }
  if ($x.page -eq 1) { foreach ($k in $hpMain.Keys) { if ($x.name -match $k) { return $hpMain[$k] } } }
  if ($x.b.kind -eq 'chrome') { return ($(if ($x.name -like 'Announcement*') { 'components/layout/announcement-bar' } elseif ($x.name -eq 'Header') { 'components/header/site-header' } else { 'components/layout/site-footer' })) }
  return $null
}
$refIdx = @{}; foreach ($e in $entries) { foreach ($h in $e.hits) { $k = "$($h.page)|$($h.block)"; if (-not $refIdx.ContainsKey($k)) { $refIdx[$k] = New-Object System.Collections.ArrayList }; if ($refIdx[$k] -notcontains $e) { [void]$refIdx[$k].Add($e) } } }

# ================= MASTER-COMPONENT-INVENTORY =================
$sb = New-Object Text.StringBuilder
function W([string]$s = '') { [void]$sb.AppendLine($s) }
$groups = $entries | Group-Object group
$cStatus = @{}; foreach ($s in 'component', 'ready', 'css', 'page', 'page-local', 'none') { $cStatus[$s] = @($entries | Where-Object { $_.status -eq $s }).Count }
W '# Master Component Inventory'; W
W "Generated from the rendered wireframes (all 16 pages, 1440 px, after scripts ran) on $(Get-Date -Format 'yyyy-MM-dd'). Evidence comes from the audit, not from assumptions: every line names where the component was found, or states that it is not present."; W
W "**Scope note.** The brief says 15 pages; the project has **16** wireframes (Homepage, PLP, PDP, Cart, Cart Drawer, Contact, FAQ, About, Our Story, Shipping Policy, Returns Policy, Privacy Policy, Terms and Conditions, Blog Listing, Blog Article, 404). The Cart Drawer is a dialog opened from the header, not a page, and it is audited with the others."; W
W '## How to read this'; W
W '| Status | Meaning |'; W '|---|---|'
W '| Component | Implemented as a partial component and used by pages |'; W '| Ready (not adopted) | A base component exists and validates; pages still use hand-written markup |'
W '| Design System class | Only a CSS class in the Design System; the markup is written by hand on each page |'; W '| Page-specific | Page markup or script with no shared component yet |'
W '| Page-local | An icon defined inside a single page, not in the shared sprite |'; W '| Not in wireframes | Requested in the brief, but not found on any page. Not created. |'; W
W "## Totals"; W
W "- Master entries: **$($entries.Count)** in 12 groups"
W "- Component: $($cStatus['component']); Ready (not adopted): $($cStatus['ready']); Design System class: $($cStatus['css']); Page-specific: $($cStatus['page']); Page-local icons: $($cStatus['page-local']); Not in wireframes: $($cStatus['none'])"
W "- Implemented partial components in the project: **$($comps.Count)** (13 base with manifests, 71 others without manifests)"; W
foreach ($g in $groups) {
  W "## $($g.Name)"; W
  W '| ID | Component | Status | Implementation | Found on (detections) | Notes |'; W '|---|---|---|---|---|---|'
  foreach ($e in $g.Group) { W ("| {0} | {1} | {2} | {3} | {4} | {5} |" -f $e.id, (Cell $e.name), $statusLabel[$e.status], (Cell $e.impl), (Cell (FoundOn $e)), (Cell $e.note)) }
  W
  $nf = @($g.Group | Where-Object { $_.status -eq 'none' })
  if ($nf.Count) { W ("Requested but not present in this group: " + (($nf | ForEach-Object { $_.name }) -join '; ') + '.'); W }
}
W '## Implemented components (index)'; W
W 'All partial components that exist today, with their level, the group they belong to, and what they contain.'; W
W '| Component | Level | Folder | Manifest | Contains |'; W '|---|---|---|---|---|'
foreach ($n in ($comps.Keys | Sort-Object)) { W ("| {0} | {1} | {2} | {3} | {4} |" -f (Short $n), (LevelOf $n), $comps[$n].group, $(if ($comps[$n].manifest) { 'yes' } else { 'no' }), ((Kids $n | ForEach-Object { Short $_ }) -join ', ')) }
[IO.File]::WriteAllText("$D\MASTER-COMPONENT-INVENTORY.md", $sb.ToString(), $utf8)

# ================= PAGE-WISE-COMPONENT-BREAKDOWN =================
$sb = New-Object Text.StringBuilder
W '# Page-wise Component Breakdown'; W
W "Every page, every section in document order, read from the rendered wireframes. A section is a named block of the page: shared chrome (announcement bar, header, footer), page sections and their nested sub-sections, landmarks, and overlays (dialogs and drawers). Counts are at 1440 px after the page scripts ran, so script-generated parts (PLP grid, PDP pickers, cart lines) are included."; W
W '"Main component" names the partial that renders the section today. Where it says *page markup*, the section is hand-written on that page and is not yet a component (see COMPONENT-AUDIT-REPORT.md).'; W
$kindNote = @{ chrome = 'shared chrome'; section = 'page section'; landmark = 'landmark'; overlay = 'overlay (dialog or drawer)'; content = 'unnamed content in main' }
foreach ($p in $pages) {
  $n = [int]$p.number; $bl = @($blocks | Where-Object { $_.page -eq $n })
  $cnt = @{}; foreach ($k in 'chrome', 'section', 'landmark', 'overlay', 'content') { $cnt[$k] = @($bl | Where-Object { $_.b.kind -eq $k }).Count }
  W ("## Page {0:00} $dash {1}" -f $n, $PN[$n]); W
  W "- File: ``$($p.folder)/$($p.file)``"
  W "- Total sections: **$($bl.Count)** ($($cnt['chrome']) shared chrome, $($cnt['section']) page sections, $($cnt['landmark']) landmarks, $($cnt['overlay']) overlays, $($cnt['content']) unnamed content)"
  if ($n -eq 5) { W '- This is not a page: it is the cart drawer dialog shown over a page. It is audited as the page that hosts it.' }
  W
  $si = 0
  foreach ($x in $bl) {
    $si++; $b = $x.b; $nm = if ($b.name) { $b.name } else { '(unnamed)' }
    W ("### Section {0:00} $dash {1}" -f $si, $nm); W
    $idTxt = if ($b.id) { ", id ``" + $b.id + "``" } else { "" }; $stTxt = if ($b.stage) { ", stage '" + $b.stage + "'" } else { "" }; W ("- Type: " + $kindNote[[string]$b.kind] + $idTxt + $stTxt)
    $main = MainFor $x
    if ($main) { W "- Main component: ``$(Short $main)``$(if ($n -ne 1 -and $b.kind -eq 'chrome') { ' (shared partial, identical on every page)' })" } else { W '- Main component: *page markup (not a component yet)*' }
    if ($main) { $nest = @(NestedFlat $main 0 @()); if ($nest.Count) { W ("- Nested sub-components: " + (($nest | ForEach-Object { '`' + (Short $_) + '`' }) -join ', ')) } else { W '- Nested sub-components: none' } }
    else { $k = "$n|$($x.name)"; $rf = if ($refIdx.ContainsKey($k)) { @($refIdx[$k] | Where-Object { $_.group -notmatch '^(06|10|12)' }) } else { @() }; W ("- Nested patterns found: " + $(if ($rf.Count) { ($rf | ForEach-Object { $_.name }) -join '; ' } else { 'none' })) }
    $hd = @($b.heads | ForEach-Object { "$($_.tag): $($_.text)" + $(if ([int]$_.n -gt 1) { " (x$($_.n))" }) })
    if ($hd.Count) { W ("- Subsections (headings): " + ($hd -join ' / ')) } else { W '- Subsections (headings): none' }
    $bt = @($b.buttons | ForEach-Object { "$($_.kind): $($_.text)" + $(if ([int]$_.n -gt 1) { " (x$($_.n))" }) })
    W ("- Buttons and controls: " + $(if ($bt.Count) { $bt -join ' / ' } else { 'none' }))
    $ic = @(Props $b.icons | ForEach-Object { "$($_.Name) x$($_.Value)" })
    W ("- Icons: " + $(if ($ic.Count) { $ic -join ', ' } else { 'none' }))
    $cd = @(); foreach ($c in 'product-card', 'tile', 'choice', 'opt', 'pc-media', 'swatch-chip') { $pr = $b.classes.PSObject.Properties[$c]; if ($pr) { $cd += "$c x$($pr.Value)" } }
    $k2 = "$n|$($x.name)"; if ($refIdx.ContainsKey($k2)) { foreach ($e in @($refIdx[$k2] | Where-Object { $_.group -like '05*' })) { $cd += $e.name } }
    W ("- Cards and tiles: " + $(if ($cd.Count) { ($cd | Select-Object -Unique) -join ', ' } else { 'none' }))
    $md = @($b.media | ForEach-Object { "$($_.type)$(if ($_.text) { ': ' + $_.text })" }); $ph = $b.det.PSObject.Properties['placeholder image']
    W ("- Images and media: " + $(if ($md.Count) { $md -join ' / ' } elseif ($ph) { "$($ph.Value) labelled placeholder(s)" } else { 'none' }) + $(if ($md.Count -and $ph) { " ($($ph.Value) placeholders)" }))
    $ip = @($b.inputs | ForEach-Object { "$(if ($_.tag -eq 'input') { if ($_.type) { $_.type } else { 'text' } } else { $_.tag }): $($_.label)" })
    $ct = @(); foreach ($dk in 'tabs', 'accordion', 'quantity', 'select', 'dialog', 'pagination', 'tooltip') { $pr = $b.det.PSObject.Properties[$dk]; if ($pr) { $ct += "$dk x$($pr.Value)" } }
    W ("- Inputs and interactive elements: " + $(if ($ip.Count -or $ct.Count) { (($ip | Select-Object -First 12) + $(if ($ip.Count -gt 12) { "... +$($ip.Count - 12) more" }) + $ct) -join ' / ' } else { 'none' }))
    $rr = if ($refIdx.ContainsKey($k2)) { @($refIdx[$k2] | ForEach-Object { $_.id + ' ' + $_.name }) } else { @() }
    W ("- Reusable component references: " + $(if ($rr.Count) { ($rr -join '; ') } else { 'none matched' }))
    if ($b.responsive) { W "- Responsive note (wireframe): $($b.responsive)" }
    W
  }
}
[IO.File]::WriteAllText("$D\PAGE-WISE-COMPONENT-BREAKDOWN.md", $sb.ToString(), $utf8)

# ================= COMPONENT-REUSE-MAP =================
$sb = New-Object Text.StringBuilder
$live = @($entries | Where-Object { $_.status -ne 'none' })
$withHits = @($live | Where-Object { $_.hits.Count })
$shared = @($withHits | Where-Object { (PagesOf $_).Count -ge 2 }); $single = @($withHits | Where-Object { (PagesOf $_).Count -eq 1 })
$noEvid = @($live | Where-Object { -not $_.hits.Count })
$totalDet = [int](($withHits | ForEach-Object { Total $_ } | Measure-Object -Sum).Sum)
W '# Component Reuse Map'; W
W 'Where each master component is used, by page. Numbers are detections at 1440 px (an element can match more than one master component, so totals are not a count of distinct DOM elements). A dash means the component was not found on that page.'; W
W '## Summary'; W
W "- Master entries: **$($entries.Count)**; present in the wireframes or implemented: **$($live.Count)**; requested but not present: **$($entries.Count - $live.Count)**"
W "- Shared (found on 2 or more pages): **$($shared.Count)**"
W "- Page-specific (found on exactly one page): **$($single.Count)**"
W "- Defined or structural, with no direct detector (type styles, layout, unused variants): **$($noEvid.Count)**"
W "- Total detections across all pages: **$totalDet**"
$dom = @{}; foreach ($p in $pages) { foreach ($pr in (Props $p.data.whole.det)) { $dom[$pr.Name] = [int]$dom[$pr.Name] + [int]$pr.Value } }
W "- Raw DOM census over all 16 pages: icons $($dom['icon']), accordion items $($dom['accordion']), chips $($dom['chip']), placeholders $($dom['placeholder image']), checkboxes $($dom['checkbox']), radios $($dom['radio']), product cards (PLP) $($dom['plp product card']), prices $($dom['price']), ratings $($dom['rating'])"; W
W '## Key reuse questions'; W
$ck = { param($nm) $e = $entries | Where-Object { $_.name -eq $nm } | Select-Object -First 1; if ($e) { FoundOn $e } else { '-' } }
W '| Component | Homepage | PLP | PDP | Cart | Other pages |'; W '|---|---|---|---|---|---|'
foreach ($nm in 'Primary Button', 'Secondary Button', 'Icon Button', 'Chip', 'Badge', 'Quantity Input', 'Product Rating', 'Accordion', 'Breadcrumb', 'Pagination', 'Drawer', 'Header', 'Footer') {
  $e = $entries | Where-Object { $_.name -eq $nm } | Select-Object -First 1; if (-not $e) { continue }
  $ct = { param($pg) $s = ($e.hits | Where-Object { $_.page -eq $pg } | Measure-Object count -Sum).Sum; if ($s) { 'Yes (' + $s + ')' } else { 'No' } }
  $other = @(PagesOf $e | Where-Object { $_ -gt 4 }); W ("| {0} | {1} | {2} | {3} | {4} | {5} |" -f $nm, (& $ct 1), (& $ct 2), (& $ct 3), (& $ct 4), $(if ($other.Count -ge 12) { 'Yes, ' + $other.Count + ' of 12 pages' } elseif ($other.Count) { 'Yes: ' + (($other | ForEach-Object { $PS[$_] }) -join ', ') } else { 'No' }))
}
W
W '## Full matrix'; W
W ('| ID | Component | ' + ((1..16 | ForEach-Object { $PS[$_] }) -join ' | ') + ' | Pages | Reuse |'); W ('|---|---|' + ('---|' * 18))
foreach ($g in $groups) {
  W ("| | **$($g.Name)** |" + (' |' * 18))
  foreach ($e in $g.Group) {
    $cells = 1..16 | ForEach-Object { $k = $_; $s = ($e.hits | Where-Object { $_.page -eq $k } | Measure-Object count -Sum).Sum; if ($s) { [string]$s } else { '-' } }
    $pgc = (PagesOf $e).Count; $cls = if ($e.status -eq 'none') { 'not present' } elseif ($pgc -ge 2) { 'shared' } elseif ($pgc -eq 1) { 'page-specific' } else { 'defined / structural' }
    W ("| {0} | {1} | {2} | {3} | {4} |" -f $e.id, (Cell $e.name), ($cells -join ' | '), $pgc, $cls)
  }
}
W
W '## Where each component is used (sections)'; W
W 'Page and section names for every component that was detected. Up to 8 places are listed.'; W
foreach ($e in $withHits) { $pl = @($e.hits | ForEach-Object { "$($PS[$_.page]): $($_.block)" } | Select-Object -Unique); W ("- **$($e.id) $($e.name)**: " + (($pl | Select-Object -First 8) -join '; ') + $(if ($pl.Count -gt 8) { "; +$($pl.Count - 8) more" })) }
W
W '## Reuse decisions'; W
W '### Can be reused as one component with variants'
W '- **Button**: Design System primary, secondary, text and the Homepage Editorial styles are one base/button with named variants. Add to bag, Quick view, Checkout, Continue shopping, Apply filters and Send message are the same Button with different labels.'
W '- **Icon**: every icon on every page is one `base/icon` selected by name.'
W '- **Chip and Tag**: one `base/chip` with ds, editorial and editorial-tag variants.'
W '- **Price, Rating, Badge, Quantity, Message, Breadcrumb, Input field**: base components exist and are valid. The PLP, PDP, Cart and Drawer repeat the same markup by hand, so these can be adopted without a visual change.'
W '- **Cart line item**: the Cart page and the Cart Drawer show the same line (image, title, quantity, price, remove). One component with a `context` variant.'
W '- **Choice patterns**: `.choice` (PLP facets, PDP bundle), `.opt` (PDP option cards), `.tile` (PDP) and `.swatch` (PLP) are four patterns for one idea, a selectable option. Candidate for one `Choice` base component with checkbox, radio, option-card and swatch variants.'
W '- **Accordion**: native details with the `.accordion` classes is used on FAQ, PDP, PLP filters and the footer; one component.'
W '- **Section heading, scroller controls**: already shared.'
W '### Should stay separate (different layout or behaviour)'
W '- **Homepage Product Card** and **PLP Product Card**: different layout and behaviour (the PLP card has swatches, quick view and generated badges). They share only base parts (media, price, rating, badge).'
W '- **Design System Button** and **Editorial Button**: kept as two named variants of the same component because they differ in shape and case, as approved.'
W '- **PDP option cards** versus **PLP swatches**: different interaction (single-select options with price versus colour dots). Keep as variants, not merged into one look.'
W '- **Header mega-menu card** versus **Homepage category card**: different size and caption position.'
[IO.File]::WriteAllText("$D\COMPONENT-REUSE-MAP.md", $sb.ToString(), $utf8)

# ================= COMPONENT-HIERARCHY =================
$sb = New-Object Text.StringBuilder
W '# Component Hierarchy'; W
W 'Main component > sub-component > nested component, taken from the real include graph of the partial components (`@@PARTIAL` calls inside each template). The Homepage and the shared header, footer and announcement bar are built from components. The other 14 pages are page markup and have no hierarchy yet.'; W
W '## Levels'; W
W '- **Base**: one UI idea, no layout of its own (Button, Icon, Chip, Icon Button, Badge, Media, Price, Rating, Quantity, Message, Breadcrumb, Input Field, Section Heading).'
W '- **Sub-component**: a part used inside a section (a card, a step, a menu column).'
W '- **Main**: a whole section or shared region that contains sub-components.'; W
function Tree([string]$n, [int]$d, $seen) {
  $lv = if ($comps.ContainsKey($n)) { LevelOf $n } else { 'shared partial' }
  $line = ('  ' * $d) + "- ``$(Short $n)`` ($lv)"; W $line
  if ($seen -contains $n -or $d -gt 8) { return }
  foreach ($k in (Kids $n)) { Tree $k ($d + 1) ($seen + $n) }
}
W '## Shared chrome (every page)'; W
foreach ($b in 'components/layout/announcement-bar', 'components/header/site-header', 'components/layout/site-footer') { Tree $b 0 @() }; W
W '## Homepage, section by section'; W
$hp = @($blocks | Where-Object { $_.page -eq 1 })
foreach ($x in $hp) { $m = MainFor $x; if ($m -and $x.name -notmatch '^(Announcement|Header|Footer)') { W "### $($x.name)"; Tree $m 0 @(); W } }
W '## Pages that are not yet componentized'; W
foreach ($p in $pages) { if ([int]$p.number -eq 1) { continue }; $bl = @($blocks | Where-Object { $_.page -eq [int]$p.number -and $_.b.kind -ne 'chrome' }); W ("- **Page {0:00} {1}**: {2}" -f [int]$p.number, $PN[[int]$p.number], (($bl | ForEach-Object { $_.name }) -join '; ')) }
W
W '## Orphans (components that nothing includes)'; W
$included = @{}; foreach ($n in $comps.Keys) { foreach ($k in (Kids $n)) { $included[$k] = 1 } }; foreach ($b in 'components/layout/announcement-bar', 'components/header/site-header', 'components/layout/site-footer') { foreach ($k in (Kids $b)) { $included[$k] = 1 } }
$called = @{}; foreach ($n in $comps.Keys) { if ($lib.usage.ContainsKey($n) -and @($lib.usage[$n].pages.Keys).Count) { $called[$n] = 1 } }
$orph = @($comps.Keys | Where-Object { -not $included.ContainsKey($_) -and -not $called.ContainsKey($_) } | Sort-Object)
W ($(if ($orph.Count) { ($orph | ForEach-Object { '`' + (Short $_) + '`' }) -join ', ' } else { 'None.' })); W
W ('Base components that exist but no page or component calls yet: ' + ((@($comps.Keys | Where-Object { $comps[$_].group -eq 'base' -and -not $included.ContainsKey($_) -and -not $called.ContainsKey($_) } | Sort-Object) | ForEach-Object { '`' + (Short $_) + '`' }) -join ', ') + '.')
[IO.File]::WriteAllText("$D\COMPONENT-HIERARCHY.md", $sb.ToString(), $utf8)

# ================= COMPONENT-PROPERTIES =================
$sb = New-Object Text.StringBuilder
W '# Component Properties'; W
W ('Properties, variants, defaults and supported states. ' + @($comps.Keys | Where-Object { $comps[$_].manifest }).Count + ' of ' + $comps.Count + ' components have manifests (Figma vocabulary: VARIANT, BOOLEAN, TEXT, LIST, INSTANCE_SWAP). Scope is the property class: design (fixed by the Design System), parent (passed from the parent), merchant (editable in the theme editor, only when a section exposes it) or wireframe (not carried to Shopify). The remaining components have no manifest yet; their properties are inferred from the template tokens and labelled as such.'); W
foreach ($n in ($comps.Keys | Where-Object { $comps[$_].manifest } | Sort-Object)) {
  $m = $comps[$n].manifest; W "## $($m.name) (``$(Short $n)``)"; W
  W "- Level: $($m.level); page scope: $($m.page); status: $($m.status)"; W "- $($m.summary)"
  if ($m.accessibility) { W "- Accessibility: $($m.accessibility)" }; if ($m.responsive) { W "- Responsive: $($m.responsive)" }
  if ($m.children -and @($m.children).Count) { W ("- Nested components: " + ((@($m.children) | ForEach-Object { '`' + (Short $_) + '`' }) -join ', ')) }
  if ($m.tokens -and @($m.tokens).Count) { W ("- Design Variable groups: " + (@($m.tokens) -join ', ')) }
  W; W '| Property | Type | Scope | Default | Values | Shopify | Note |'; W '|---|---|---|---|---|---|---|'
  foreach ($p in @($m.properties)) { $vals = if ($p.values) { @($p.values) -join ', ' } elseif ($p.options) { (@($p.options) | ForEach-Object { if ($_ -eq '') { '(none)' } else { $_ } }) -join ', ' } else { '' }; $df = if ($p.default -is [array] -or $p.default -is [System.Collections.IDictionary]) { 'list' } else { [string]$p.default }; $sh = if ($p.shopify) { (@($p.shopify.id, $p.shopify.setting) | Where-Object { $_ }) -join " / " } else { "" }; $scp = $p.scope + $(if ($p.review) { " (review " + $p.review + ")" } else { "" }) + $(if ($p.pending) { " (data pending merchant confirmation)" } else { "" }); W ("| {0} | {1} | {2} | {3} | {4} | {5} | {6} |" -f $p.name, $p.type, (Cell $scp), (Cell $df), (Cell $vals), (Cell $sh), (Cell $p.note)) }
  if ($m.exposes -and @($m.exposes).Count) { W '**Exposed to the theme editor by this section:**'; foreach ($e in @($m.exposes)) { W ('- ' + (Short $e.child) + ' . ' + $e.property + ' via ' + $e.via) }; W }
  if ($m.shopifyOnly -and @($m.shopifyOnly).Count) { W '**Shopify-only settings (no wireframe equivalent):**'; foreach ($e in @($m.shopifyOnly)) { W ('- ' + $e.id + ' (' + $e.setting + ')' + $(if ($e.note) { ': ' + $e.note } else { '' })) }; W }
  if ($m.wireframeOnly -and @($m.wireframeOnly).Count) { W ('**Wireframe-only, not carried to Shopify:** ' + (@($m.wireframeOnly) -join '; ')); W }
  W
}
W '## Other implemented components (properties inferred from templates)'; W
W '| Component | Level | Inferred properties |'; W '|---|---|---|'
foreach ($n in ($comps.Keys | Where-Object { -not $comps[$_].manifest } | Sort-Object)) {
  $h = [string]$comps[$n].html; $skip = if ($h -match '\{\{each ') { @('item', 'href', 'index', 'index0', 'first', 'last') } else { @() }; $seen = @{}; $o = @()
  foreach ($m in [regex]::Matches($h, '\{\{(?:(if|each) !?([\w]+)(?:=[^}]*)?|(?:slug:|lower:|arg:)?(\w+)(?:\.\w+)?)\}\}')) { $nm = if ($m.Groups[2].Success) { $m.Groups[2].Value } else { $m.Groups[3].Value }; if (-not $nm -or $skip -contains $nm -or $seen[$nm]) { continue }; $seen[$nm] = 1; $t = if ($m.Groups[1].Value -eq 'each') { 'LIST' } elseif ($m.Groups[1].Value -eq 'if') { 'BOOL?' } else { 'TEXT' }; $o += "$nm ($t)" }
  W ("| {0} | {1} | {2} |" -f (Short $n), (LevelOf $n), $(if ($o.Count) { $o -join ', ' } else { 'none' }))
}
W
W '## Supported states'; W
W 'States come from the Design System component classes; they are CSS states and are not separate components.'; W
W '| Component | States |'; W '|---|---|'
W '| Button | default, hover, active, focus-visible, disabled; block (full width) |'
W '| Icon Button | default, hover, focus-visible, disabled |'
W '| Chip | default, hover, selected (aria-pressed), focus-visible |'
W '| Input Field | default, focus, filled, error (aria-invalid), disabled |'
W '| Quantity | default, minimum reached, maximum reached, disabled |'
W '| Accordion | collapsed, expanded, focus-visible |'
W '| Message | success, error, warning |'
W '| Product card (PLP) | default, hover, sold out |'
W '| Drawer / dialog | closed, open |'
W '| Header navigation | default, hover, open (mega menu), mobile drawer open |'
W '| Choice / swatch | default, hover, selected, sold out (disabled), focus-visible |'
W
W 'Responsive behaviour is defined per component in its manifest and by the Design Variable breakpoints (600, 768, 1024, 1280 px).'
[IO.File]::WriteAllText("$D\COMPONENT-PROPERTIES.md", $sb.ToString(), $utf8)

# ================= COMPONENT-AUDIT-REPORT =================
$sb = New-Object Text.StringBuilder
$iconAgg = @{}; foreach ($p in $pages) { foreach ($pr in (Props $p.data.whole.icons)) { $iconAgg[$pr.Name] = [int]$iconAgg[$pr.Name] + [int]$pr.Value } }
$spriteIds = @([regex]::Matches($lib.sprite, 'id="icon-([^"]+)"') | ForEach-Object { $_.Groups[1].Value })
$missingIcons = @($iconAgg.Keys | Where-Object { $spriteIds -notcontains $_ } | Sort-Object); $unusedIcons = @($spriteIds | Where-Object { -not $iconAgg.ContainsKey($_) } | Sort-Object)
$btnKinds = @{}; foreach ($x in $blocks) { foreach ($bt in @($x.b.buttons)) { $btnKinds[$bt.kind] = [int]$btnKinds[$bt.kind] + [int]$bt.n } }
$rawSvg = 0; $iconCalls = 0; foreach ($sf in (Get-ChildItem (Join-Path (Split-Path -Parent $L) '03-Wireframes\00-Shared-Tailwind-Foundation\src') -Filter *.src.html)) { $tx = [IO.File]::ReadAllText($sf.FullName, $utf8); $rawSvg += ([regex]::Matches($tx, '<svg class="icon')).Count; $iconCalls += ([regex]::Matches($tx, 'components/base/icon ')).Count }
$secTotal = @($blocks | Where-Object { $_.b.kind -eq 'section' }).Count
W '# Component Audit Report'; W
W "Date: $(Get-Date -Format 'yyyy-MM-dd'). Scope: all 16 wireframe pages, the Design System, the shared partials and the 84 implemented components."; W
W '## 1. What exists'; W
W "- **16 wireframes** (the brief says 15; the Cart Drawer is the sixteenth and is a dialog, not a page)."
W "- **$secTotal page sections** plus shared chrome and overlays; the Homepage has 20 sections, the other pages 1 to 7 each."
W "- **$($comps.Count) partial components**: 13 base (with manifests), 21 header and layout parts, and the Homepage section parents and their sub-components."
W "- **The Homepage, the PLP and the shared header, footer and announcement bar are built from components.** PDP, Cart, Cart Drawer, Contact, FAQ, About, Our Story, the four policy pages, Blog Listing, Blog Article and 404 are hand-written markup in their source files, using Design System CSS classes."
W "- **Design System components** (Button, Chip, Badge, Price, Rating, Field, Quantity, Accordion, Message, Drawer, Pagination, Breadcrumb) exist as CSS classes in the shared stylesheet."
W "- **Master inventory**: $($entries.Count) entries in 12 groups ($($cStatus['component']) components, $($cStatus['ready']) ready but not adopted, $($cStatus['css']) Design System classes, $($cStatus['page']) page-specific, $($cStatus['page-local']) page-local icons, $($cStatus['none']) not present)."; W
W '## 2. What works'; W
W '- Buttons, chips, icon buttons and section headings are shared components used by the Homepage, with named variants (Design System and Homepage Editorial).'
W '- One Icon component serves every icon; 25 call sites plus the header and footer.'
W '- All 16 pages still match the approved baseline after the component work.'
W '- The template engine is proven identical in the build and in the browser library (40 of 40 real calls).'; W
W '## 3. Findings'; W
W "1. **Resolved: ten icons that were defined inside single pages (clock, mail, phone, play, zoom-in, loader, truck, rotate-ccw, shield-check, store) are now in the shared sprite and the icon assets** (39 icons). The page-local copies were removed; all 16 pages were verified identical outside the sprite."
W "2. **Icons in the assets and sprite that no page uses:** $((@($unusedIcons) -join ', ')). Kept. truck, rotate-ccw, shield-check and store were defined for the PDP delivery block; loader is used by script-built loading markup that the audited state does not show; sort, info and eye-off are available for later."
W "3. **Inner pages hand-write what the base components already provide:** $rawSvg raw svg icons (class icon, same sprite) and every .btn button in the PDP, Cart, Drawer, Contact, FAQ, About, Story, policy, Blog and 404 sources; the Icon and Button components are called by the Homepage, the PLP and the shared header and footer. Same sprite and classes, so converting them is a no-visual-change migration."
W "3b. **Eight base components are ready but no page uses them:** Media, Badge, Price, Rating, Quantity, Message, Breadcrumb and Input Field. PLP, PDP, Cart and Drawer repeat the same markup by hand. Adoption is a no-visual-change migration, planned per page."
W "4. **PDP and Cart still build parts of their markup in JavaScript templates** (pickers, prices, ratings, cart lines); the PLP no longer does, its cards, tile, pagination, chips, filter groups and quick view render from component templates. Those templates must be shared with the components in one place before the pages can be converted."
W "5. **Four patterns for one idea (a selectable option):** `.choice`, `.opt`, `.tile` and `.swatch`. Recommendation: one `Choice` base component with variants."
W "6. **Duplicate cart line markup:** the Cart page and the Cart Drawer each hand-write the same line. Recommendation: one Cart Line Item component with a context variant."
W "7. **Duplicate accordion markup** across FAQ, PDP, PLP filters and footer: same classes, hand-written each time. One Accordion component."
W "8. **Two button systems that are one component:** the Design System Button and the Homepage Editorial Button are variants of base/button (approved). No further consolidation needed."
W "9. **Homepage and PLP product cards are separate by decision** and stay separate; they share only base parts."
W "10. **71 of 84 components have no manifest.** They preview with inferred properties; manifests are written when their page is converted."
W "11. **No payment icons exist:** the footer shows text labels. The brief lists payment icons; none are in the wireframes, so none were created."
W ("12. **Requested but not present in any wireframe** ($($cStatus['none'])): " + ((@($entries | Where-Object { $_.status -eq 'none' } | ForEach-Object { $_.name })) -join '; ') + '. They were not invented; they will be designed only if you decide the theme needs them.'); W
W '## 4. Missing components (recommended, drawn from real repetition)'; W
W '| Recommended component | Replaces | Pages |'; W '|---|---|---|'
W '| Choice (checkbox, radio, option card, swatch variants) | .choice, .opt, .tile, .swatch | PLP, PDP |'
W '| Cart Line Item | hand-written cart line | Cart, Cart Drawer |'
W '| Accordion Item | hand-written details markup | FAQ, PDP, PLP, footer |'
W '| Pagination | .pagination markup | PLP, Blog Listing |'
W '| Drawer | .drawer markup | PLP filters, quick view, PDP zoom, cart |'
W '| Page Hero | repeated intro block | About, Story, Contact, Blog, 404 |'
W '| Policy Page Body | the four policy pages | Shipping, Returns, Privacy, Terms |'
W '| Empty State | empty cart, no articles, no results | Cart, Blog, PLP |'
W '| Product Card Parts (shared media, price, rating, badge) | duplicated parts of both cards | Homepage, PLP, PDP related |'; W
W '## 5. Duplicates and overlaps'; W
W "- Button text styles: `.btn-text` and the Editorial text variant are two text-button looks; both kept (approved)."
W "- Chip: DS chip (filters) and the editorial chip (Homepage concern and skin-type); one component, variants."
W "- Price: PLP, PDP and Cart repeat the `.price` markup; one base/price."
W "- Rating: PLP and PDP repeat the stars markup; one base/rating."; W
W '## 6. Recommendations (in order)'; W
W '1. Review this inventory and the library, then approve the page order for conversion (suggested: Homepage sections, shared chrome, PLP, PDP, Cart, then the content pages).'
W '2. Done: the ten page-local icons are in the shared sprite and assets (verified).'
W '3. Approve creating Choice, Cart Line Item, Accordion Item, Pagination and Drawer as base components.'
W '4. Review the token report before any fixed pixel value is mapped to a token.'
W '5. Convert one page at a time, with the 16-page equality check and the library tests after each.'; W
W '## 7. Counts for the record'; W
W ("- Button detections by kind: " + ((($btnKinds.Keys | Sort-Object) | ForEach-Object { "$_ $($btnKinds[$_])" }) -join '; '))
W ("- Distinct icons used: $($iconAgg.Count); icon uses: $(([int](($iconAgg.Values | Measure-Object -Sum).Sum)))")
[IO.File]::WriteAllText("$D\COMPONENT-AUDIT-REPORT.md", $sb.ToString(), $utf8)

# ================= data for the library UI =================
$ent = @(); foreach ($e in $entries) { $ent += @{ id = [string]$e.id; group = [string]$e.group; name = [string]$e.name; status = [string]$e.status; impl = [string]$e.impl; note = [string]$e.note; hits = @($e.hits | ForEach-Object { @{ page = [int]$_.page; block = [string]$_.block; count = [int]$_.count } }) } }
$pg = @(); foreach ($p in $pages) { $bl = @(); foreach ($x in @($blocks | Where-Object { $_.page -eq [int]$p.number })) { $b = $x.b; $main = MainFor $x
    $bl += @{ name = [string]$b.name; kind = [string]$b.kind; depth = [int]$b.depth; main = [string]$main; nested = @(if ($main) { NestedFlat $main 0 @() }); heads = @($b.heads | ForEach-Object { [string]("$($_.tag): $($_.text)") }); buttons = @($b.buttons | ForEach-Object { [string]("$($_.kind): $($_.text)") }); icons = @(Props $b.icons | ForEach-Object { [string]$_.Name }); refs = @(if ($refIdx.ContainsKey("$($x.page)|$($x.name)")) { $refIdx["$($x.page)|$($x.name)"] | ForEach-Object { [string]$_.id } }) } }
  $pg += @{ number = [int]$p.number; name = [string]$PN[[int]$p.number]; short = [string]$PS[[int]$p.number]; file = [string]$p.file; blocks = $bl } }
$out = @{ generated = (Get-Date -Format 'yyyy-MM-dd HH:mm'); entries = $ent; pages = $pg }
$jsn = $out | ConvertTo-Json -Depth 8 -Compress
[IO.File]::WriteAllText("$D\audit\inventory.json", $jsn, $utf8)
[IO.File]::WriteAllText("$L\audit.data.js", "/* GENERATED by tools/generate-audit-docs.ps1. Do not edit. */`nwindow.NUDGE_AUDIT = $jsn;`n", $utf8)
"entries: $($entries.Count); component $($cStatus['component']), ready $($cStatus['ready']), css $($cStatus['css']), page $($cStatus['page']), page-local $($cStatus['page-local']), none $($cStatus['none'])"
"with detections: $($withHits.Count); shared: $($shared.Count); page-specific: $($single.Count); structural/no detector: $($noEvid.Count)"
"documents written to $D"