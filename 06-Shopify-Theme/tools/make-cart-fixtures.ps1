# Builds tools/cart-fixtures.json: Shopify-shaped cart objects (and the add-on products) for the cart drawer tests. Fixture only.
$T = Split-Path -Parent $PSScriptRoot; $utf8 = New-Object Text.UTF8Encoding($false)
$CAT = [ordered]@{
  tm = @{ id = 11; name = 'Tinted Moisturiser'; variant = ('Rose ' + [char]0xB7 + ' 50 ml'); price = 3200; cmp = 0; stock = 24 }
  sr = @{ id = 12; name = 'Face Serum'; variant = '30 ml'; price = 3200; cmp = 3600; stock = 3 }
  cl = @{ id = 13; name = 'Face Cleanser'; variant = '150 ml'; price = 1800; cmp = 0; stock = 40 }
  sp = @{ id = 14; name = 'Daily Sunscreen'; variant = '50 ml'; price = 2600; cmp = 0; stock = 12 }
  ey = @{ id = 15; name = 'Eye Cream'; variant = '15 ml'; price = 3000; cmp = 0; stock = 20 }
  bl = @{ id = 16; name = 'Body Lotion'; variant = '200 ml'; price = 2400; cmp = 0; stock = 30 }
  lb = @{ id = 21; name = 'Lip Balm'; variant = 'Rose'; price = 1200; cmp = 0; stock = 50 }
}
function Line($k, $q) { $c = $CAT[$k]; $orig = if ($c.cmp) { $c.cmp } else { $c.price }
  [ordered]@{ key = "$($c.id):key$k"; id = $c.id; variant_id = $c.id; product_id = 1000 + $c.id; quantity = $q; title = $c.name; product_title = $c.name; url = '#pdp'; image = $null
    product = [ordered]@{ title = $c.name }; variant = [ordered]@{ title = $c.variant; inventory_quantity = $c.stock; inventory_management = 'shopify'; inventory_policy = 'deny' }
    price = $c.price; final_price = $c.price; original_price = $orig; line_price = $c.price * $q; final_line_price = $c.price * $q; original_line_price = $orig * $q; properties = @{} } }
function Cart($pairs) { $items = @(); foreach ($p in $pairs) { $items += , (Line $p[0] $p[1]) }; $n = 0; $sub = 0; foreach ($i in $items) { $n += $i.quantity; $sub += $i.final_line_price }
  [ordered]@{ item_count = $n; items = $items; total_price = $sub; items_subtotal_price = $sub; currency = [ordered]@{ iso_code = 'USD' } } }
$states = [ordered]@{
  multi = Cart @(@('tm', 1), @('sr', 1), @('cl', 1))
  'multi-plus-sr' = Cart @(@('tm', 1), @('sr', 2), @('cl', 1))
  'multi-minus-after-plus' = Cart @(@('tm', 1), @('sr', 1), @('cl', 1))
  'multi-no-tm' = Cart @(@('sr', 1), @('cl', 1))
  'multi-plus-lb' = Cart @(@('tm', 1), @('sr', 1), @('cl', 1), @('lb', 1))
  one = Cart @(, @('tm', 1))
  free = Cart @(@('sr', 1), @('cl', 1))
  long = Cart @(@('tm', 1), @('sr', 1), @('cl', 1), @('sp', 1), @('ey', 1), @('bl', 1))
  empty = Cart @()
}
$vars = @{}; foreach ($k in 'lb') { }
$addons = [ordered]@{ 'add-ons' = [ordered]@{ handle = 'add-ons'; title = 'Add-ons'; url = '#'; products = @(
  [ordered]@{ id = 1021; title = 'Lip Balm'; handle = 'lip-balm'; url = '#'; price = 1200; featured_image = $null; selected_or_first_available_variant = [ordered]@{ id = 21; title = 'Rose'; price = 1200 } },
  [ordered]@{ id = 1022; title = 'Travel Cleanser'; handle = 'travel-cleanser'; url = '#'; price = 900; featured_image = $null; selected_or_first_available_variant = [ordered]@{ id = 22; title = '50 ml'; price = 900 } } ) } }
$out = [ordered]@{ carts = $states; collections = $addons }
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'cart-fixtures.json'), ($out | ConvertTo-Json -Depth 14), $utf8)
"cart-fixtures.json: states = $($states.Keys -join ', ')"