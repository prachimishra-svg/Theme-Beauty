# Builds Homepage-HiFi.html from the BUILT Homepage wireframe (03-Wireframes/01-.../Homepage.html) so the page uses the real component markup, tokens, fonts and icons.
# The wireframe, the Design System, the Variables and the Component Library are only READ. Everything hi-fi lives in this folder: hifi.css (styling layer), hifi.js (photo slots), images/ (the photographs).
# It also (1) swaps the wireframe's merchant-note copy for design copy, (2) writes images/manifest.js from the photos present in images/ and (3) writes images/SHOT-LIST.md.
# Run again after adding photographs or after the wireframe changes:  .\build-hifi.ps1   (or double-click update-images.cmd)
param([string]$Variant = '')   # '' = the standard page; 'hero-photo' = a separate copy that uses images-hero-photo/ (the photographic first fold)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path; $root = Split-Path -Parent (Split-Path -Parent $here); $utf8 = New-Object Text.UTF8Encoding($false)
# ---------------- photo slots: section -> ordered slots (the order of the .img elements in that section of the wireframe) ----------------
$slots = @(
 @{ sec = 'Hero Banner'; key = 'hero-campaign'; ratio = '16:9, 2880 x 1620 (a 2:3 crop, 1080 x 1620, is taken from the same file on phones)'; alt = 'NUDGE campaign: skin care ritual'; brief = 'Campaign image, model or still life in the RIGHT half of the frame, the left 45% calm for the headline. Soft natural light, rose and pearl tones.' },
 @{ sec = 'Hero Banner'; key = 'hero-product'; ratio = '4:5, 800 x 1000'; alt = 'Face Serum packshot'; brief = 'Face Serum packshot on a clean pearl background.' },
 @{ sec = 'Shop by Category'; key = 'category-skin'; ratio = '5:7 tall, 900 x 1300'; alt = 'Skin care'; brief = 'Tall editorial crop: skin care products or a skin close-up.' },
 @{ sec = 'Shop by Category'; key = 'category-makeup'; ratio = '4:5, 800 x 1000'; alt = 'Makeup'; brief = 'Face, eyes and lips: a styled makeup still life or a close-up.' },
 @{ sec = 'Shop by Category'; key = 'category-hair'; ratio = '4:5, 800 x 1000'; alt = 'Hair'; brief = 'Hair care: shampoo, conditioner and styling, or glossy hair.' },
 @{ sec = 'Shop by Category'; key = 'category-body'; ratio = 'wide, 1400 x 640'; alt = 'Body'; brief = 'Wide crop: body wash, lotion and body care on a soft surface.' },
 @{ sec = 'Featured Collection'; key = 'product-face-cleanser'; ratio = '4:5, 800 x 1000'; alt = 'Face Cleanser'; brief = 'Studio packshot, soft shadow, pearl background.' },
 @{ sec = 'Featured Collection'; key = 'product-face-serum'; ratio = '4:5, 800 x 1000'; alt = 'Face Serum'; brief = 'Studio packshot, soft shadow, pearl background.' },
 @{ sec = 'Featured Collection'; key = 'product-moisturiser'; ratio = '4:5, 800 x 1000'; alt = 'Moisturiser'; brief = 'Studio packshot, soft shadow, pearl background.' },
 @{ sec = 'Featured Collection'; key = 'product-lip-colour'; ratio = '4:5, 800 x 1000'; alt = 'Lip Colour'; brief = 'Studio packshot, soft shadow, pearl background.' },
 @{ sec = 'Shop by Concern'; key = 'concern-dryness'; ratio = '1:1, 400 x 400'; alt = 'Dryness'; brief = 'Round crop: skin or texture that reads as dryness care.' },
 @{ sec = 'Shop by Concern'; key = 'concern-dullness'; ratio = '1:1, 400 x 400'; alt = 'Dullness'; brief = 'Round crop: radiance and glow.' },
 @{ sec = 'Shop by Concern'; key = 'concern-breakouts'; ratio = '1:1, 400 x 400'; alt = 'Breakouts'; brief = 'Round crop: clear, calm skin or a cleansing texture.' },
 @{ sec = 'Shop by Concern'; key = 'concern-sensitivity'; ratio = '1:1, 400 x 400'; alt = 'Sensitivity'; brief = 'Round crop: soft, soothing texture.' },
 @{ sec = 'Shop by Concern'; key = 'concern-uneven-tone'; ratio = '1:1, 400 x 400'; alt = 'Uneven tone'; brief = 'Round crop: even, luminous skin.' },
 @{ sec = 'Shop by Concern'; key = 'concern-texture'; ratio = '1:1, 400 x 400'; alt = 'Texture'; brief = 'Round crop: smooth skin close-up.' },
 @{ sec = 'Shop the Look'; key = 'look-main'; ratio = '5:6, 1200 x 1440 (1:1, 1000 x 1000 below 768 px)'; alt = 'The look: foundation, blush and lip colour'; brief = 'Editorial look photo in natural light; leave room for three product pins (see the pin positions in the wireframe).' },
 @{ sec = 'Shop the Look'; key = 'look-foundation'; ratio = '1:1, 200 x 200'; alt = 'Foundation'; brief = 'Thumbnail: foundation packshot.' },
 @{ sec = 'Shop the Look'; key = 'look-blush'; ratio = '1:1, 200 x 200'; alt = 'Blush'; brief = 'Thumbnail: blush packshot.' },
 @{ sec = 'Shop the Look'; key = 'look-lip-colour'; ratio = '1:1, 200 x 200'; alt = 'Lip Colour'; brief = 'Thumbnail: lip colour packshot.' },
 @{ sec = 'Ingredient'; key = 'ingredient-1'; ratio = '1:1, 600 x 600'; alt = 'Hyaluronic acid texture'; brief = 'Macro texture for the first ingredient (hyaluronic acid): clear gel or droplets.' },
 @{ sec = 'Ingredient'; key = 'ingredient-2'; ratio = '1:1, 600 x 600'; alt = 'Niacinamide texture'; brief = 'Macro texture for the second ingredient (niacinamide): fine white powder or cream.' },
 @{ sec = 'Ingredient'; key = 'ingredient-3'; ratio = '1:1, 600 x 600'; alt = 'Squalane texture'; brief = 'Macro texture for the third ingredient (squalane): a drop of light oil.' },
 @{ sec = 'Ingredient'; key = 'ingredient-4'; ratio = '1:1, 600 x 600'; alt = 'Vitamin C texture'; brief = 'Macro texture for the fourth ingredient (vitamin C): citrus or a bright serum.' },
 @{ sec = 'How to Use'; key = 'routine-cleanse'; ratio = '4:5, 1200 x 1500'; alt = 'Step 1: cleanse'; brief = 'Cleanse: product being used.' },
 @{ sec = 'How to Use'; key = 'routine-treat'; ratio = '4:5, 1200 x 1500'; alt = 'Step 2: treat'; brief = 'Treat: serum being applied.' },
 @{ sec = 'How to Use'; key = 'routine-moisturise'; ratio = '4:5, 1200 x 1500'; alt = 'Step 3: moisturise'; brief = 'Moisturise: cream being applied.' },
 @{ sec = 'How to Use'; key = 'routine-protect'; ratio = '4:5, 1200 x 1500'; alt = 'Step 4: protect'; brief = 'Protect: sunscreen being applied.' },
 @{ sec = 'Video Section'; key = 'video-poster'; ratio = '16:9, 1280 x 720'; alt = 'Video: building a simple routine'; brief = 'Poster frame of the tutorial video (the play button is added by the page).' },
 @{ sec = 'Before'; key = 'before'; ratio = 'same size and crop as After, about 2400 x 1030'; alt = 'Before'; brief = 'Before photo (base layer).' },
 @{ sec = 'Before'; key = 'after'; ratio = 'same size and crop as Before'; alt = 'After'; brief = 'After photo (top layer). Only with real, unretouched, consented results.' },
 @{ sec = 'Customer Photo Gallery'; key = 'customer-1'; ratio = 'square mosaic, 800 px minimum (largest tile)'; alt = 'Customer photo'; brief = 'Customer photo, used with permission.' },
 @{ sec = 'Customer Photo Gallery'; key = 'customer-2'; ratio = 'square mosaic, 800 px minimum'; alt = 'Customer photo'; brief = 'Customer photo, used with permission.' },
 @{ sec = 'Customer Photo Gallery'; key = 'customer-3'; ratio = 'square mosaic, 800 px minimum'; alt = 'Customer photo'; brief = 'Customer photo, used with permission.' },
 @{ sec = 'Customer Photo Gallery'; key = 'customer-4'; ratio = 'square mosaic, 800 px minimum'; alt = 'Customer photo'; brief = 'Customer photo, used with permission.' },
 @{ sec = 'Customer Photo Gallery'; key = 'customer-5'; ratio = 'square mosaic, 800 px minimum'; alt = 'Customer photo'; brief = 'Customer photo, used with permission.' },
 @{ sec = 'Customer Photo Gallery'; key = 'customer-6'; ratio = 'wide mosaic tile, 800 px minimum'; alt = 'Customer photo'; brief = 'Customer photo, used with permission.' },
 @{ sec = 'Logo List'; key = 'logo-cert-1'; ratio = '2:1, 360 x 180, SVG'; alt = 'Certification logo'; brief = 'Certification logo (SVG). Only certifications the brand actually holds.' },
 @{ sec = 'Logo List'; key = 'logo-cert-2'; ratio = '2:1, 360 x 180, SVG'; alt = 'Certification logo'; brief = 'Certification logo (SVG).' },
 @{ sec = 'Logo List'; key = 'logo-cert-3'; ratio = '2:1, 360 x 180, SVG'; alt = 'Certification logo'; brief = 'Certification logo (SVG).' },
 @{ sec = 'Logo List'; key = 'logo-award-1'; ratio = '2:1, 360 x 180, SVG'; alt = 'Award logo'; brief = 'Award logo (SVG). Only awards actually won.' },
 @{ sec = 'Logo List'; key = 'logo-award-2'; ratio = '2:1, 360 x 180, SVG'; alt = 'Award logo'; brief = 'Award logo (SVG).' },
 @{ sec = 'Logo List'; key = 'logo-press-1'; ratio = '2:1, 360 x 180, SVG'; alt = 'Publication logo'; brief = 'Press logo (SVG). Only publications that featured the brand.' },
 @{ sec = 'Logo List'; key = 'logo-press-2'; ratio = '2:1, 360 x 180, SVG'; alt = 'Publication logo'; brief = 'Press logo (SVG).' },
 @{ sec = 'Logo List'; key = 'logo-press-3'; ratio = '2:1, 360 x 180, SVG'; alt = 'Publication logo'; brief = 'Press logo (SVG).' },
 @{ sec = 'Menu: Skin'; key = 'mega-skin-new'; ratio = '4:5, 600 x 750'; alt = 'New in skin'; brief = 'Menu card: new skin care arrivals.' },
 @{ sec = 'Menu: Skin'; key = 'mega-skin-routines'; ratio = '4:5, 600 x 750'; alt = 'Skin routines'; brief = 'Menu card: a skin routine laid out.' },
 @{ sec = 'Menu: Makeup'; key = 'mega-makeup-new'; ratio = '4:5, 600 x 750'; alt = 'New in makeup'; brief = 'Menu card: new makeup arrivals.' },
 @{ sec = 'Menu: Makeup'; key = 'mega-makeup-complexion'; ratio = '4:5, 600 x 750'; alt = 'Complexion edit'; brief = 'Menu card: complexion products.' },
 @{ sec = 'Menu: Hair'; key = 'mega-hair-new'; ratio = '4:5, 600 x 750'; alt = 'New in hair'; brief = 'Menu card: new hair care arrivals.' },
 @{ sec = 'Menu: Hair'; key = 'mega-hair-salon'; ratio = '4:5, 600 x 750'; alt = 'Salon at home'; brief = 'Menu card: salon-style hair care.' },
 @{ sec = 'Menu: Body'; key = 'mega-body-new'; ratio = '4:5, 600 x 750'; alt = 'New in body'; brief = 'Menu card: new body care arrivals.' },
 @{ sec = 'Menu: Body'; key = 'mega-body-gifts'; ratio = '4:5, 600 x 750'; alt = 'Gift sets'; brief = 'Menu card: gift sets.' },
 @{ sec = 'Promotional'; key = 'promo-campaign'; ratio = '10:7, 1200 x 840 (wider crop on desktop)'; alt = 'Gift set styled on a soft surface'; brief = 'Campaign image: gift set styled on a soft surface.' }
)
$imgName = if ($Variant) { "images-$Variant" } else { 'images' }; $imgDir = Join-Path $here $imgName; New-Item -ItemType Directory -Force $imgDir | Out-Null
$have = @{}; Get-ChildItem $imgDir -File | Where-Object { $_.Extension -match '^\.(jpe?g|png|webp|avif|svg)$' } | ForEach-Object { $have[[IO.Path]::GetFileNameWithoutExtension($_.Name)] = $_.Name }
$secMap = [ordered]@{}; foreach ($s in $slots) { if (-not $secMap.Contains($s.sec)) { $secMap[$s.sec] = @() }; $secMap[$s.sec] += $s.key }
$js = New-Object Text.StringBuilder; [void]$js.AppendLine('/* GENERATED by build-hifi.ps1. Do not edit by hand: add photographs to images/ named exactly as in SHOT-LIST.md, then run build-hifi.ps1 (or update-images.cmd). */')
[void]$js.AppendLine('window.NUDGE_HIFI = {'); [void]$js.AppendLine("  base: '$imgName/',"); [void]$js.AppendLine('  sections: {')
[void]$js.AppendLine(((($secMap.Keys | ForEach-Object { '    ' + (ConvertTo-Json $_ -Compress) + ': ' + (ConvertTo-Json @($secMap[$_]) -Compress) }) -join ",`n")))
[void]$js.AppendLine('  },'); [void]$js.AppendLine('  menus: {'); [void]$js.AppendLine((($secMap.Keys | Where-Object { $_ -like 'Menu:*' } | ForEach-Object { '    ' + (ConvertTo-Json ($_.Substring(6).ToLower()) -Compress) + ': ' + (ConvertTo-Json @($secMap[$_]) -Compress) }) -join ",`n")); [void]$js.AppendLine('  },'); [void]$js.AppendLine('  files: {'); [void]$js.AppendLine((($have.Keys | Sort-Object | ForEach-Object { '    ' + (ConvertTo-Json $_ -Compress) + ': ' + (ConvertTo-Json $have[$_] -Compress) }) -join ",`n")); [void]$js.AppendLine('  },')
[void]$js.AppendLine('  alt: {'); [void]$js.AppendLine((($slots | ForEach-Object { '    ' + (ConvertTo-Json $_.key -Compress) + ': ' + (ConvertTo-Json $_.alt -Compress) }) -join ",`n")); [void]$js.AppendLine('  }'); [void]$js.AppendLine('};')
[IO.File]::WriteAllText((Join-Path $imgDir 'manifest.js'), $js.ToString(), $utf8)
$md = New-Object Text.StringBuilder; [void]$md.AppendLine('# Photograph shot list: Homepage'); [void]$md.AppendLine('')
[void]$md.AppendLine("The page has $($slots.Count) photo slots. Save each photograph in this folder using the file name shown (**.jpg**, **.webp**, **.png** or **.avif**; logos **.svg**), then run ``build-hifi.ps1`` (or double-click ``update-images.cmd``) and reload the page. A slot with no file shows a calm tonal surface in the brand colours; nothing is drawn or faked.")
[void]$md.AppendLine(''); [void]$md.AppendLine('Direction: premium beauty and lifestyle photography, soft natural light, rose, pearl and plum tones, generous negative space, no text inside images. Use only photographs you have the right to use; customer photos and before/after results need permission.'); [void]$md.AppendLine('')
[void]$md.AppendLine('| Section | File name (without extension) | Ratio and size | Brief | Status |'); [void]$md.AppendLine('|---|---|---|---|---|')
foreach ($s in $slots) { $st = if ($have.ContainsKey($s.key)) { 'in place: ' + $have[$s.key] } else { 'needed' }; [void]$md.AppendLine("| $($s.sec) | ``$($s.key)`` | $($s.ratio) | $($s.brief) | $st |") }
$missing = @($slots | Where-Object { -not $have.ContainsKey($_.key) }).Count; [void]$md.AppendLine(''); [void]$md.AppendLine("Photos in place: $($slots.Count - $missing) of $($slots.Count).")
[IO.File]::WriteAllText((Join-Path $imgDir 'SHOT-LIST.md'), $md.ToString(), $utf8)
# ---------------- the page ----------------
$srcPath = Join-Path $root '03-Wireframes\01-NUDGE-Beauty-Homepage-Wireframe\Homepage.html'; $t = [IO.File]::ReadAllText($srcPath, $utf8)
# the page lives in 08-High-Fidelity-Design/01-Homepage (same depth as a wireframe folder, so ../../ paths to the design system, variables, assets and engine still resolve)
$t = $t.Replace('../00-Shared-Tailwind-Foundation/', '../../03-Wireframes/00-Shared-Tailwind-Foundation/')
$t = [regex]::Replace($t, 'href="\.\./(\d\d-NUDGE-[^"]+)"', 'href="../../03-Wireframes/$1"')
if ($t -match 'src="\.\./\d\d-NUDGE|href="\.\./\d\d-NUDGE') { throw 'a wireframe path was not rewritten' }
# ---- design copy for the notes the wireframe leaves to the merchant (each pattern must exist, so a wireframe change cannot silently skip one) ----
function Swap([string]$old, [string]$new) { if (-not $script:t.Contains($old)) { throw "copy pattern not found: $old" }; $script:t = $script:t.Replace($old, $new) }
Swap 'Only if certified or verifiable' 'Our promise, on every product'
Swap 'Define what clean means for the range' 'Thoughtfully made, clearly labelled'
foreach ($p in @(@('Ingredient name 1', 'Hyaluronic acid'), @('Ingredient name 2', 'Niacinamide'), @('Ingredient name 3', 'Squalane'), @('Ingredient name 4', 'Vitamin C'))) { Swap $p[0] $p[1] }
$lines = @('A water-binding ingredient that leaves skin soft and comfortable.', 'A skin tone and texture ingredient found across our serums.', 'A light, skin-like oil that helps lock in moisture.', 'A brightening ingredient used in our daytime formulas.')
$old = 'One line on what it is and why it is used. Merchant to provide; no claims without evidence.'; $n = 0
while ($t.Contains($old) -and $n -lt 4) { $i = $t.IndexOf($old); $t = $t.Substring(0, $i) + $lines[$n] + $t.Substring($i + $old.Length); $n++ }; if ($n -ne 4) { throw "expected 4 ingredient lines, replaced $n" }
Swap 'Source line: where the key ingredients come from (merchant to provide).' 'Every formula lists its full ingredients on the product page.'
Swap 'Reviews are typed by the merchant; no review platform. Star row is a layout placeholder.' 'Quotes shown are sample content for this design.'
Swap 'Customer name' 'NUDGE customer'
Swap 'Real offer details and dates go here.' 'Beautifully boxed sets, ready to give.'
foreach ($p in @(@('Item 1', 'Parabens'), @('Item 2', 'Sulphates'), @('Item 3', 'Mineral oil'), @('Item 4', 'Artificial dyes'))) { Swap $p[0] $p[1] }
Swap 'Native JavaScript only: the result links to a collection; no quiz app.' 'Your answers stay on this page.'
Swap '<body class="ann-on ' '<body class="'
Swap 'b.classList.toggle("ann-on",q.get("ann")!=="0");' 'b.classList.remove("ann-on");'
Swap 'Photos from customers, uploaded by the merchant.' 'Share your routine and see it here.'
Swap 'One line about the brand.' 'Skin care, makeup, hair and body, chosen to work together.'
Swap 'Optional closing tip, from the product labels.' 'Patch test new products and follow the directions on each label.'
# routine steps: the wireframe shows "from the label" three times per step; the design gives each step its own short direction (general usage, to be checked against the product labels by the merchant)
function SwapN([string]$pattern, [string[]]$values) { $script:k = 0; $n = [regex]::Matches($script:t, $pattern).Count; if ($n -ne $values.Count) { throw "expected $($values.Count) matches of $pattern, found $n" }; $script:t = [regex]::Replace($script:t, $pattern, { param($m) $v = $values[$script:k]; $script:k++; $v }) }
SwapN '(?<=data-c="smp">)from the label(?=</span>)' @('Massage onto damp skin', '1 minute', 'Press in, do not rub', '30 seconds', 'Warm between your palms first', '30 seconds', 'Reapply through the day', 'Every morning')
SwapN 'How to apply, from the [A-Za-z ]+ label\.' @('Massage onto damp skin, then rinse with lukewarm water.', 'Smooth a few drops over clean skin.', 'Apply evenly over the face and neck.', 'Finish with sunscreen as your last morning step.')$t = [regex]::Replace($t, '<title>[^<]*</title>', '<title>NUDGE Beauty | Homepage (high fidelity)</title>')
$t = $t.Replace('</head>', '<link rel="stylesheet" href="hifi.css">' + "`n" + $(if ($Variant -and (Test-Path (Join-Path $here "hifi-$Variant.css"))) { '<link rel="stylesheet" href="hifi-' + $Variant + '.css">' + "`n" } else { '' }) + '<meta name="description" content="NUDGE Beauty: skin care, makeup, hair and body. High-fidelity Homepage design.">' + "`n</head>")
$t = $t.Replace('</body>', ('<script src="' + $imgName + '/manifest.js"></script>') + "`n" + '<script src="hifi.js" defer></script>' + "`n</body>")
$t = [regex]::Replace($t, '<body class="', '<body data-hifi class="', 1)
$outName = if ($Variant) { "Homepage-HiFi-$Variant.html" } else { 'Homepage-HiFi.html' }
[IO.File]::WriteAllText((Join-Path $here $outName), $t, $utf8)
"wrote $outName ($([Math]::Round($t.Length / 1KB)) KB); photo slots $($slots.Count), photos in place $($slots.Count - $missing); images/manifest.js and images/SHOT-LIST.md updated"