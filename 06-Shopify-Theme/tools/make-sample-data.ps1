# Builds tools/sample-data.json (the test fixtures for the local Liquid harness) from the approved wireframe Homepage, so the header and footer menus
# equal the wireframe's links by construction. Fixture only: it is never shipped; a real store supplies its own menus and markets.
$T = Split-Path -Parent $PSScriptRoot; $utf8 = New-Object Text.UTF8Encoding($false)
$base = Join-Path $T '..\03-Wireframes\00-Shared-Tailwind-Foundation\tools\baseline\Homepage.html'
$h = [IO.File]::ReadAllText((Resolve-Path $base), $utf8)
function Dec($s) { [System.Net.WebUtility]::HtmlDecode($s) }
function Link($t, $u, $kids) { [ordered]@{ title = (Dec $t); url = (Dec $u); current = $false; child_current = $false; active = $false; links = @($kids) } }
# main menu from the header's nav items
$hdr = [regex]::Match($h, '<header id="site-header"[\s\S]*?</header>').Value
$items = [regex]::Matches($hdr, '<div data-mega="([a-z]+)"[\s\S]*?(?=<div data-mega="|<div class="relative self-start" id="market">)')
$main = @()
foreach ($it in $items) {
  $v = $it.Value; $top = [regex]::Match($v, '<a href="([^"]*)"[^>]*data-mega-link[^>]*>([^<]*)<')
  $cols = @()
  foreach ($c in [regex]::Matches($v, '<div class="mb-2 lg:mb-0">\s*<p[^>]*>([^<]*)</p>\s*<ul[^>]*>([\s\S]*?)</ul>\s*</div>')) {
    $ls = @([regex]::Matches($c.Groups[2].Value, '<li><a href="([^"]*)"[^>]*>([^<]*)</a></li>') | ForEach-Object { Link $_.Groups[2].Value $_.Groups[1].Value @() })
    $cols += Link $c.Groups[1].Value '#' $ls
  }
  $main += Link $top.Groups[2].Value $top.Groups[1].Value $cols
}
# footer menus
$ft = [regex]::Match($h, '<footer[\s\S]*?</footer>').Value
$lists = [ordered]@{}; $lists['main-menu'] = [ordered]@{ handle = 'main-menu'; title = 'Main menu'; links = $main }
foreach ($c in [regex]::Matches($ft, '<div class="fcol[\s\S]*?</a></div>\s*</div>')) {
  $name = [regex]::Match($c.Value, '<span>([^<]*)</span>').Groups[1].Value
  $ls = @([regex]::Matches($c.Value, '<a href="([^"]*)" class="flex min-h-touch[^>]*>([^<]*)</a>') | ForEach-Object { Link $_.Groups[2].Value $_.Groups[1].Value @() })
  $hnd = 'footer-' + $name.ToLower(); $lists[$hnd] = [ordered]@{ handle = $hnd; title = $name; links = $ls }
}
$loc = [ordered]@{
  available_countries = @(
    [ordered]@{ iso_code = 'IN'; name = 'India'; currency = [ordered]@{ iso_code = 'INR'; symbol = [string][char]0x20B9 } },
    [ordered]@{ iso_code = 'US'; name = 'United States'; currency = [ordered]@{ iso_code = 'USD'; symbol = '$' } },
    [ordered]@{ iso_code = 'GB'; name = 'United Kingdom'; currency = [ordered]@{ iso_code = 'GBP'; symbol = [string][char]0xA3 } },
    [ordered]@{ iso_code = 'EU'; name = 'Eurozone'; currency = [ordered]@{ iso_code = 'EUR'; symbol = [string][char]0x20AC } } )
  country = [ordered]@{ iso_code = 'IN'; name = 'India'; currency = [ordered]@{ iso_code = 'INR'; symbol = [string][char]0x20B9 } }
  language = [ordered]@{ iso_code = 'en' } }
# sample products and collections (same cards as the wireframe Homepage product sets); fixture only
function Prod($title, $size, $price, $was, $hl, $rating, $count, $badge, $shades) {
  $tags = @(); if ($badge) { $tags += "badge:$badge" }
  $opts = @(); if ($shades) { $opts += [ordered]@{ name = 'Shade'; values = @('Rose', 'Berry', 'Peach') } }
  [ordered]@{ title = $title; handle = ($title.ToLower() -replace '[^a-z0-9]+', '-'); url = '#'; price = $price; compare_at_price = $was; tags = $tags; featured_image = $null
    options_with_values = $opts
    metafields = [ordered]@{ custom = [ordered]@{ size = [ordered]@{ value = $size }; highlight = [ordered]@{ value = $hl } }; reviews = [ordered]@{ rating = [ordered]@{ value = $rating }; rating_count = [ordered]@{ value = $count } } } }
}
$colls = [ordered]@{
  'best-sellers' = [ordered]@{ handle = 'best-sellers'; title = 'Best sellers'; url = '#'; products = @(
    (Prod 'Face Cleanser' '150 ml' 1800 0 'Best for: all skin types' 4.6 112 'Bestseller' $false), (Prod 'Face Serum' '30 ml' 3200 3800 'Best for: dullness' 4.7 141 '' $false),
    (Prod 'Moisturiser' '50 ml' 2800 0 'Best for: dry skin' 4.8 119 '' $false), (Prod 'Lip Colour' '3.5 g' 1600 0 'Satin finish, 6 shades' 4.5 64 'New' $true)) }
  'new-launches' = [ordered]@{ handle = 'new-launches'; title = 'New launches'; url = '#'; products = @(
    (Prod 'Sunscreen' '50 ml' 2600 0 'Daily protection' 4.6 88 '' $false), (Prod 'Eye Cream' '15 ml' 3000 0 'Light gel texture' 4.6 73 '' $false),
    (Prod 'Mascara' '8 ml' 1900 0 'Black or brown' 4.4 56 'New' $true), (Prod 'Hair Oil' '50 ml' 2200 0 'Lightweight finish' 4.5 47 '' $false)) }
}
foreach ($c in $colls.Values) { $c['products_count'] = $c.products.Count }
$prods = [ordered]@{}; foreach ($c in $colls.Values) { foreach ($p in $c.products) { $prods[$p.handle] = $p } }
$prods['foundation'] = Prod 'Foundation' '30 ml' 3000 0 '' 0 0 '' $false
$prods['blush'] = Prod 'Blush' '5 g' 2000 0 '' 0 0 '' $false
$lists['cart-empty'] = [ordered]@{ handle = 'cart-empty'; title = 'Cart empty links'; links = @((Link 'Best sellers' '#shop' @()), (Link 'Skin care' '#shop' @()), (Link 'Makeup' '#shop' @()), (Link 'Hair' '#shop' @()), (Link 'Body' '#shop' @())) }
$cf = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'cart-fixtures.json'), $utf8) | ConvertFrom-Json
$colls['add-ons'] = $cf.collections.'add-ons'
$data = [ordered]@{ linklists = $lists; localization = $loc; collections = $colls; products = $prods }
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'sample-data.json'), ($data | ConvertTo-Json -Depth 12), $utf8)
"sample-data.json: menus = $($lists.Keys -join ', '); main menu items = $($main.Count); columns = $(($main | ForEach-Object { $_.links.Count }) -join '/')"