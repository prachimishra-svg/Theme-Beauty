# Assembles a Tailwind wireframe from src/<name>.src.html and the shared partials, and writes it into its numbered page folder.
# Usage: build.ps1 -Page cart-page      build one page
#        build.ps1 -All                 build every page, in storefront order
# Each page folder holds exactly one file, the Tailwind version; there are no separate normal-CSS copies.
# Placeholders in a source file:
#   @@PARTIAL head@@                          standard <link>/<script> head block plus the shared Tailwind base (partials/base.tw.css)
#   @@PARTIAL sprite@@ | annbar | footer | review-css
#   @@PARTIAL header CART=link|page|drawer NAV=skin|none EXTRA="classes"@@
#   @@PARTIAL width-preview@@                   the in-page Width preview overlay (needs a #t-wp button in the review bar)
#   @@PARTIAL components/<group>/<name> key=value key="a value"@@
#                                               a nested component: partials/components/<group>/<name>.html. Components may include other components.
#                                               Tokens inside a component file: {{arg}} {{slug:arg}} {{lower:arg}}, {{if arg}}..{{/if}} (arg present and not 0),
#                                               {{each arg}}..{{item}} {{slug:item}}..{{/each}} (arg is a list separated by |). A missing argument is a build error.
#                                               Inside arguments and list items write &quot; for a double quote, &#64; for @ and &#124; for | (decoded when used).
#                                               The component catalogue is COMPONENT-INVENTORY.md.
#   @@LINK:<page>@@                             relative link to another page's file (page keys are the names in the list below)
param([string]$Page, [switch]$All)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$wf = Split-Path -Parent $root
$foundation = Split-Path -Leaf $root
$utf8 = [Text.Encoding]::UTF8
# Storefront order: shopping flow first (01 to 05), then support and policy pages, then the journal, then system pages.
$pages = [ordered]@{
  'homepage'    = '01-NUDGE-Beauty-Homepage-Wireframe\Homepage.html'
  'plp'         = '02-NUDGE-Beauty-PLP-Wireframe\PLP.html'
  'pdp'         = '03-NUDGE-Beauty-PDP-Wireframe\PDP.html'
  'cart-page'   = '04-NUDGE-Beauty-Cart-Wireframe\Cart_Page.html'
  'cart-drawer' = '05-NUDGE-Beauty-Cart-Drawer-Wireframe\Cart_Drawer_Wireframe_v1.html'
  'contact'     = '06-NUDGE-Beauty-Contact-Wireframe\Contact_Page_Wireframe_v1.html'
  'faq'         = '07-NUDGE-Beauty-FAQ-Wireframe\FAQ_Page_Wireframe_v1.html'
  'about'       = '08-NUDGE-Beauty-About-Wireframe\About_Page_Wireframe_v1.html'
  'story'       = '09-NUDGE-Beauty-Story-Wireframe\Story_Page_Wireframe_v1.html'
  'shipping'    = '10-NUDGE-Beauty-Shipping-Policy-Wireframe\Shipping_Policy_Wireframe_v1.html'
  'returns'     = '11-NUDGE-Beauty-Returns-Policy-Wireframe\Returns_Policy_Wireframe_v1.html'
  'privacy'     = '12-NUDGE-Beauty-Privacy-Policy-Wireframe\Privacy_Policy_Wireframe_v1.html'
  'terms'       = '13-NUDGE-Beauty-Terms-Wireframe\Terms_Conditions_Wireframe_v1.html'
  'blog'        = '14-NUDGE-Beauty-Blog-Listing-Wireframe\Blog_Listing_Wireframe_v1.html'
  'article'     = '15-NUDGE-Beauty-Blog-Article-Wireframe\Blog_Article_Wireframe_v1.html'
  'notfound'    = '16-NUDGE-Beauty-404-Wireframe\404_Page_Wireframe_v1.html'
}
if (-not $All -and -not $Page) { throw "give -Page <name> or -All; pages: $($pages.Keys -join ', ')" }
if ($Page -and -not $pages.Contains($Page)) { throw "unknown page '$Page'; use: $($pages.Keys -join ', ')" }
function P([string]$rel) { [IO.File]::ReadAllText((Join-Path $root $rel), $utf8) }
function Header([hashtable]$a) {
  $h = P 'partials\header.html'
  $c = if ($a.ContainsKey('CART')) { $a['CART'] } else { 'link' }
  $h = $h.Replace('@@CART@@', "@@PARTIAL components/header/cart-button $c=1@@")
  $h = $h.Replace('@@NAV_SKIN_FLAG@@', $(if ($a['NAV'] -eq 'skin') { '1' } else { '0' }))
  $h.Replace('@@HDR_EXTRA@@', $(if ($a.ContainsKey('EXTRA')) { $a['EXTRA'] } else { '' }))
}
function Args2([string]$s) {
  $h = @{}
  foreach ($m in [regex]::Matches($s, '(\w+)=("([^"]*)"|(\S+))')) { $h[$m.Groups[1].Value] = $(if ($m.Groups[3].Success) { $m.Groups[3].Value } else { $m.Groups[4].Value }) }
  $h
}
function Links([string]$t) {
  [regex]::Replace($t, '@@LINK:([a-z-]+)@@', { param($m) $k = $m.Groups[1].Value; if (-not $pages.Contains($k)) { throw "unknown link target $k" }; '../' + ($pages[$k] -replace '\\','/') })
}function Unesc([string]$s) { $s.Replace('&quot;', '"').Replace('&#64;', '@').Replace('&#124;', '|') }
function Slug([string]$s) { ($s.ToLower() -replace '[^a-z0-9]+', '-').Trim('-') }
# ---- component engine v2 (same language as 07-Component-Library/engine.js; the two are parity-tested) ----
# Component files may be flat (components/<group>/<name>.html) or a folder (components/<group>/<name>/<name>.html); a sibling <name>.json is the manifest.
# Manifest properties give defaults for missing arguments and, for VARIANT properties, a "classes" table read with {{prop.class}}.
# Template language: {{x}} {{slug:x}} {{lower:x}} {{x.field}} {{x.class}} | {{if x}} {{if x=value}} ... {{/if}} (nesting allowed) | {{each list}} ... {{/each}} with {{item}} {{item.field}} {{href}} {{index}} {{index0}}
function CompRel([string]$name) {
  $flat = 'partials\' + ($name -replace '/', '\') + '.html'
  if (Test-Path (Join-Path $root $flat)) { return $flat }
  $leaf = ($name -split '/')[-1]; $folder = 'partials\' + ($name -replace '/', '\') + '\' + $leaf + '.html'
  if (Test-Path (Join-Path $root $folder)) { return $folder }
  $null
}
$script:manCache = @{}
function ManifestFor([string]$rel) {
  $mp = Join-Path $root ($rel -replace '\.html$', '.json')
  if ($script:manCache.ContainsKey($mp)) { return $script:manCache[$mp] }
  $m = $null; if (Test-Path $mp) { $m = [IO.File]::ReadAllText($mp, $utf8) | ConvertFrom-Json }
  $script:manCache[$mp] = $m; $m
}
function Truthy($v) { if ($null -eq $v) { return $false }; if ($v -is [bool]) { return $v }; if ($v -is [string]) { return ($v -ne '' -and $v -ne '0' -and $v -ne 'false') }; if ($v -is [array] -or $v -is [System.Collections.IList]) { return (@($v).Count -gt 0) }; $true }
function PathGet($scope, [string]$path) {
  $parts = $path -split '\.'; $cur = $scope[$parts[0]]
  for ($i = 1; $i -lt $parts.Count; $i++) { if ($null -eq $cur) { return $null }; if ($cur -is [hashtable]) { $cur = $cur[$parts[$i]] } else { $pr = $cur.PSObject.Properties[$parts[$i]]; $cur = if ($pr) { $pr.Value } else { $null } } }
  $cur
}
function TplTokens([string]$text, $scope, $man, [string]$cn) {
  [regex]::Replace($text, '\{\{(slug:|lower:|arg:)?([\w.]+)\}\}', {
    param($m)
    $path = $m.Groups[2].Value; $mode = $m.Groups[1].Value
    if ($path -match '^(\w+)\.(\w+)$' -and $man) {
      $pn = $Matches[1]; $tn = $Matches[2]; $prop = @($man.properties | Where-Object { $_.name -eq $pn })[0]
      if ($prop) {
        $val = [string]$scope[$pn]
        $tbl = if ($tn -eq 'class') { $prop.classes } elseif ($prop.tables) { $prop.tables.PSObject.Properties[$tn].Value } else { $null }
        if (-not $tbl) { throw "component ${cn} - '$pn' has no '$tn' table" }
        $cl = $tbl.PSObject.Properties[$val]; if (-not $cl) { throw "component ${cn} - '$pn' has no '$tn' entry for '$val'" }
        return [string]$cl.Value
      }
    }
    $v = PathGet $scope $path
    if ($null -eq $v) { throw "component ${cn} - missing argument '$path'" }
    $v = Unesc ([string]$v)
    switch ($mode) { 'slug:' { Slug $v } 'lower:' { $v.ToLower() } 'arg:' { $v.Replace('"', '&quot;').Replace('@', '&#64;').Replace('|', '&#124;') } default { $v } }
  })
}
function TplRender([string]$t, $scope, $man, [string]$cn) {
  $sb = New-Object Text.StringBuilder; $pos = 0; $rx = [regex]'\{\{(if|each) ([^}]+)\}\}|\{\{/(if|each)\}\}'
  while ($pos -lt $t.Length) {
    $m = $rx.Match($t, $pos)
    if (-not $m.Success) { [void]$sb.Append((TplTokens $t.Substring($pos) $scope $man $cn)); break }
    if ($m.Groups[3].Success) { throw "component ${cn} - unmatched {{/$($m.Groups[3].Value)}}" }
    [void]$sb.Append((TplTokens $t.Substring($pos, $m.Index - $pos) $scope $man $cn))
    $depth = 1; $scan = $m.Index + $m.Length; $end = -1; $endLen = 0
    while ($depth -gt 0) {
      $n = $rx.Match($t, $scan); if (-not $n.Success) { throw "component ${cn} - unclosed {{$($m.Groups[1].Value)}}" }
      if ($n.Groups[3].Success) { $depth--; if ($depth -eq 0) { $end = $n.Index; $endLen = $n.Length } } else { $depth++ }
      $scan = $n.Index + $n.Length
    }
    $inner = $t.Substring($m.Index + $m.Length, $end - ($m.Index + $m.Length)); $arg = $m.Groups[2].Value.Trim()
    if ($m.Groups[1].Value -eq 'if') {
      $ok = if ($arg -match '^([\w.]+)=(.+)$') { ([string](PathGet $scope $Matches[1])) -eq $Matches[2].Trim() } else { Truthy (PathGet $scope $arg) }
      if ($ok) { [void]$sb.Append((TplRender $inner $scope $man $cn)) }
    } else {
      $list = PathGet $scope $arg; if ($null -eq $list) { throw "component ${cn} - missing list argument '$arg'" }
      $items = if ($list -is [string]) { @($list -split '\|') } else { @($list) }
      $i = 0
      foreach ($it in $items) {
        $i++; $child = @{}; foreach ($k in $scope.Keys) { $child[$k] = $scope[$k] }
        if ($it -is [string]) { $pair = $it -split '::', 2; $child['item'] = (Unesc $pair[0]); $child['href'] = $(if ($pair.Count -gt 1) { Unesc $pair[1] } else { '' }) } else { $child['item'] = $it; $child['href'] = '' }
        $child['index'] = [string]$i; $child['index0'] = [string]($i - 1); $child['first'] = ($i -eq 1); $child['last'] = ($i -eq $items.Count)
        [void]$sb.Append((TplRender $inner $child $man $cn))
      }
    }
    $pos = $end + $endLen
  }
  $sb.ToString()
}
function Component([string]$name, [hashtable]$a) {
  $rel = CompRel $name
  if (-not $rel) { throw "unknown partial $name" }
  $man = ManifestFor $rel
  $scope = @{}; foreach ($k in $a.Keys) { $scope[$k] = $a[$k] }
  if ($man) { foreach ($p in @($man.properties)) { if (-not $scope.ContainsKey($p.name) -and $null -ne $p.default) { $d = $p.default; if ($d -is [bool]) { $d = $(if ($d) { '1' } else { '0' }) }; $scope[$p.name] = $d } } }
  $t = (P $rel).TrimEnd("`r", "`n")
  TplRender $t $scope $man $name
}
function Expand([string]$t) {
  [regex]::Replace($t, '@@PARTIAL ([a-z0-9/-]+)([^@]*)@@', {
    param($m)
    $n = $m.Groups[1].Value; $pa = Args2 $m.Groups[2].Value
    switch ($n) {
      'head' { "<link rel=`"stylesheet`" href=`"../../02-Design-Variables/Styles/variables.css`">`n<link rel=`"stylesheet`" href=`"../../01-Design-System/Styles/foundation.css`"><!-- self-hosted fonts only -->`n<script src=`"../$foundation/tailwindcss-play-3.4.17.js`"></script>`n<script src=`"../$foundation/tailwind.config.js`"></script>`n<script src=`"../$foundation/currency.js`" defer></script>`n<script src=`"../$foundation/nav.js`" defer></script>`n<style type=`"text/tailwindcss`">`n" + (P 'partials\base.tw.css') + "`n" + (P 'partials\components.tw.css') + "`n</style>" }
      'sprite' { P 'partials\sprite.html' }
      'annbar' { Expand (P 'partials\annbar.html') }
      'footer' { Expand (Links (P 'partials\footer.html')) }
      'review-css' { P 'partials\review.css' }
      'width-preview' { P 'partials\width-preview.html' }
      'header' { Expand (Header $pa) }
      default { Expand (Component $n $pa) }
    }
  })
}
function Build([string]$name) {
  $srcFile = Join-Path $root ("src\$name.src.html")
  $t = [IO.File]::ReadAllText($srcFile, $utf8)
  $t = $t.Replace('@@FOUNDATION@@', $foundation)
  $t = Expand $t
  $t = [regex]::Replace($t, '@@LINK:([a-z-]+)@@', { param($m) $k = $m.Groups[1].Value; if (-not $pages.Contains($k)) { throw "unknown link target $k" }; '../' + ($pages[$k] -replace '\\','/') })
  if ([regex]::IsMatch($t, '@@[A-Z_]+@@')) { throw "unresolved placeholders remain in $name" }
  $out = Join-Path $wf $pages[$name]
  New-Item -ItemType Directory -Force (Split-Path -Parent $out) | Out-Null
  [IO.File]::WriteAllText($out, $t, (New-Object Text.UTF8Encoding($false)))
  "wrote $($pages[$name]) ($([IO.File]::ReadAllBytes($out).Length) bytes)"
}
if ($All) { foreach ($k in $pages.Keys) { Build $k } } else { Build $Page }
