# Renders the theme (LiquidJS harness, default content) and compares chosen elements with the approved wireframe baseline
# (03-Wireframes/00-Shared-Tailwind-Foundation/tools/baseline/Homepage.html, the page as it was before componentisation).
# Usage: .\tools\compare-theme.ps1 [-Checks annbar,header,footer,s03,...] [-Template index] [-Show]
#
# Equal means equal after the normalisation below. EXPECTED DIFFERENCES, and why (nothing else is ignored):
#   attr="" vs a bare boolean attribute (a serialised DOM writes disabled=""), whitespace between tags / inside attributes, class-token order and duplicates, <use/> vs <use></use>, redundant xlink:href  (render-neutral)
#   <div class="ann"> review annotations, data-section / data-height review hooks                                  (wireframe-only chrome, not in the theme)
#   wireframe page links "#cart" "#account" "#search" "#top" vs Shopify routes /cart /account /search /          (real store URLs)
#   "Shop all" links "#collection-skin" etc. vs the menu item url "#collection"                                    (a Shopify menu link has one URL)
#   <ul hidden data-ann-source>, data-autoplay, data-interval on the announcement bar                              (message source list + settings for the script and Theme Editor)
#   role="search" on the desktop search link (axe: ARIA role not allowed on a link; removed in the theme, still present in the approved wireframe)
#   role="group" on the payment methods list (axe: aria-label needs a role on a div; added in the theme)
#   <span class="ph__focal"> focal-point guide inside the hero image (review aid, hidden unless guides are switched on)
#   named entities &middot; &times; &mdash; &ndash; &rsquo; &hellip; vs the same characters (identical when rendered)
#   data-c="smp|src" wireframe edit hooks (review chrome; in the theme the same text is a Theme Editor setting)
#   <template data-tab-grid> product grids of the inactive Featured Collection tabs (the wireframe builds them from a script array; the theme renders them from the tab's collection)
#   <ul hidden data-finder-source> question source list for the Guided finder script; the wireframe's .note review sentence under the finder
#   Shop the look: the "View" pill is a link to the product in the theme (a <span> in the wireframe)
#   the newsletter <form>: Shopify's form tag adds method/action/accept-charset and hidden inputs (form_type, utf8, contact[tags]); only class and id are compared (form_type)
#   Custom Liquid (s18): the wireframe shows a visible empty-slot box; the theme renders nothing to shoppers when empty (the box only appears in the Theme Editor)
#   data-ok / data-error on the newsletter message (the translated texts the script shows)
#   role="region" on the Testimonials and Logo list <ul> (axe: not allowed on a list and it removes the list items' semantics; the list keeps its aria-label and tab stop)
#   Cart drawer (run-time DOM of the wireframe, captured with tools/baseline/cart-drawer-runtime.html): data-id/data-variant/data-qty/data-max/data-stock/data-add values (line keys and variant ids instead of sample ids), data-cart-* / data-msg-* / data-checkout* attributes and the <template id="cd-*"> message templates (hooks for cart.js), the dialog's open attribute (open at capture time)
#   the cart drawer dialog also carries leading-normal, so it keeps the Design System's 1.5 line height even where the page body is looser (the Homepage)
#   cart drawer icons carry size-5: the theme's default icon size is the Homepage's 24 px, the approved drawer uses the Design System's 20 px
#   data-cart-count on the cart bubble                                                                              (hook for the cart script)
#   contents of #market-menu                                                                                        (built at run time by currency.js in the wireframe; real localization form in the theme)
param([string[]]$Checks = @('annbar', 'header', 'footer'), [string]$Template = 'index', [switch]$Show,
      [string]$SettingsJson = '{"social_instagram":"#","social_facebook":"#","social_youtube":"#"}', [string]$Baseline = '', [string]$CartState = '', [string]$StaticJson = '{}')
$T = Split-Path -Parent $PSScriptRoot; $P = Split-Path -Parent $T
$utf8 = New-Object Text.UTF8Encoding($false)
$baselineFile = if ($Baseline) { $Baseline } else { Join-Path $P '03-Wireframes\00-Shared-Tailwind-Foundation\tools\baseline\Homepage.html' }
$r = & "$PSScriptRoot\render-theme.ps1" -Template $Template -SettingsJson $SettingsJson -CartState $CartState -StaticJson $StaticJson -Quiet
$theme = $r.Html; $base = [IO.File]::ReadAllText($baselineFile, $utf8)
if ($r.Errors.Count) { "harness problems:"; $r.Errors | Select-Object -Unique | ForEach-Object { "  - $_" } }

function Get-Element([string]$html, [string]$openRegex) {
  $m = [regex]::Match($html, $openRegex); if (-not $m.Success) { return $null }
  $tag = [regex]::Match($m.Value, '^<(\w+)').Groups[1].Value; $i = $m.Index; $depth = 0
  foreach ($t in [regex]::Matches($html.Substring($i), "<(/?)$tag\b[^>]*>")) {
    if ($t.Groups[1].Value -eq '/') { $depth-- } else { $depth++ }
    if ($depth -eq 0) { return $html.Substring($i, $t.Index + $t.Length) }
  }
  $null
}
function Norm([string]$t, [bool]$isBase) {
  $t = [regex]::Replace($t, '<div class="ann[^"]*">[\s\S]*?</div>', '')
  $t = [regex]::Replace($t, ' data-(ok|error)="[^"]*"', '')
  $t = [regex]::Replace($t, ' data-c="[^"]*"', '')
  $t = [regex]::Replace($t, ' data-section="[^"]*"', ''); $t = $t -replace ' data-height="[^"]*"', ''
  $t = [regex]::Replace($t, '<ul hidden data-ann-source>[\s\S]*?</ul>', '')
  $t = [regex]::Replace($t, '<ul hidden data-finder-source[^>]*>[\s\S]*?</ul>', '')
  $t = [regex]::Replace($t, '<(div|p) class="note mt-2[^>]*>[\s\S]*?</\1>', '')
  $t = [regex]::Replace($t, '<input type="hidden"[^>]*>', '')
  $t = [regex]::Replace($t, '<form\b[^>]*>', { param($m) $id = [regex]::Match($m.Value, ' id="([^"]*)"').Groups[1].Value; $cl = [regex]::Match($m.Value, ' class="([^"]*)"').Groups[1].Value; '<form class="' + $cl + '" id="' + $id + '">' })
  $t = $t.Replace('<dialog class="drawer leading-normal"', '<dialog class="drawer"')
  $t = $t.Replace('class="icon size-5"', 'class="icon"')
  $t = [regex]::Replace($t, '<template id="cd-[\s\S]*?</template>', '')
  $t = [regex]::Replace($t, ' data-(id|variant|qty|max|stock|add|cart-count|cart-aria|msg-stock|msg-limit|msg-removed|checkout-url|lt)="[^"]*"', '')
  $t = $t -replace ' data-checkout', ''
  $t = [regex]::Replace($t, '(<dialog class="drawer" id="cart-drawer"[^>]*?) open=""', '$1')
  $t = [regex]::Replace($t, '<template data-tab-grid=[\s\S]*?</template>', '')
  $t = [regex]::Replace($t, '<span class="ph__focal[\s\S]*?</span></span>', '')
  foreach ($e in @(@('&middot;',[string][char]0xB7), @('&times;',[string][char]0xD7), @('&mdash;',[string][char]0x2014), @('&ndash;',[string][char]0x2013), @('&rsquo;',[string][char]0x2019), @('&hellip;',[string][char]0x2026))) { $t = $t.Replace($e[0], $e[1]) }
  $t = $t -replace ' data-autoplay="[^"]*"', '' -replace ' data-interval="[^"]*"', '' -replace ' data-cart-count', ''
  $t = [regex]::Replace($t, '(<div id="market-menu"[^>]*>)[\s\S]*?(</div></div>)', '$1$2')
  if ($isBase) {
    $t = $t.Replace(' role="search"', '')
    $t = $t.Replace(' role="region"', '')
    $t = [regex]::Replace($t, '<span class="(hp-btn hp-btn-o hp-btn-s)">View</span>', '<a class="$1" href="#">View</a>')
    $t = $t.Replace('href="#cart"', 'href="/cart"').Replace('href="#account"', 'href="/account"').Replace('href="#search"', 'href="/search"').Replace('href="#top" aria-label="Store home"', 'href="/" aria-label="Store home"').Replace('<a href="#top" class="mb-[14px]', '<a href="/" class="mb-[14px]')
  }
  $t = [regex]::Replace($t, 'href="#collection-(skin|makeup|hair|body)"', 'href="#collection"')
  $t = $t.Replace(' role="group" aria-label="Payment methods"', ' aria-label="Payment methods"')
  $t = $t -replace '\s+', ' '; $t = $t -replace '> <', '><'; $t = $t -replace ' "', '"'; $t = $t -replace '" >', '">'; $t = $t -replace ' >', '>'
  $t = [regex]::Replace($t, ' ([\w:-]+)=""(?=[\s>/])', ' $1')
  $t = $t -replace ' xlink:href="[^"]*"', ''
  $t = [regex]::Replace($t, '<use ([^>]*?)\s*/>', '<use $1></use>')
  [regex]::Replace($t, ' class="([^"]*)"', { param($m) ' class="' + ((($m.Groups[1].Value -split '\s+') | Where-Object { $_ } | Sort-Object -Unique) -join ' ') + '"' })
}
$open = @{
  drawer = '<dialog class="drawer[^"]*" id="cart-drawer"'; annbar = '<div id="annbar"'; header = '<header id="site-header"'; footer = '<footer class="bg-inverse'
}
$pass = 0; $fail = 0
foreach ($c in $Checks) {
  $rx = if ($open.ContainsKey($c)) { $open[$c] } else { '<section class="[^"]*" id="' + $c + '"' }
  $b = Get-Element $base $rx; $t = Get-Element $theme $rx
  if (-not $b) { "{0,-12} no baseline element for $rx" -f $c; $fail++; continue }
  if (-not $t) { "{0,-12} FAIL: not rendered by the theme" -f $c; $fail++; continue }
  $nb = Norm $b $true; $nt = Norm $t $false
  if ($nb -eq $nt) { "{0,-12} equal ({1} chars)" -f $c, $nb.Length; $pass++ }
  else {
    $fail++; $n = 0; while ($n -lt $nb.Length -and $n -lt $nt.Length -and $nb[$n] -eq $nt[$n]) { $n++ }
    $s = [Math]::Max(0, $n - 90)
    "{0,-12} DIFFERENT at {1}" -f $c, $n
    "   baseline: ..." + $nb.Substring($s, [Math]::Min(240, $nb.Length - $s))
    "   theme   : ..." + $nt.Substring($s, [Math]::Min(240, $nt.Length - $s))
  }
}
# every aria-controls / aria-labelledby / aria-describedby / for target must exist in the rendered page (axe cannot tell while panels are hidden)
$ids = @{}; foreach ($m in [regex]::Matches($theme, ' id="([^"]+)"')) { $ids[$m.Groups[1].Value] = 1 }
$missing = @(); foreach ($m in [regex]::Matches($theme, ' (aria-controls|aria-labelledby|aria-describedby)="([^"]+)"')) { foreach ($t in ($m.Groups[2].Value -split '\s+')) { if ($t -and -not $ids.ContainsKey($t)) { $missing += "$($m.Groups[1].Value)=$t" } } }
if ($missing.Count) { $fail++; "id references   FAIL: $(($missing | Select-Object -Unique) -join ', ')" } else { "id references   all aria-controls/labelledby/describedby targets exist"; }
"compare: {0} equal, {1} different" -f $pass, $fail
