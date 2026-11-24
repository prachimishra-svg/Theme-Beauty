# Rewrites slides.js from the pictures in this folder. Add your pictures here, then double-click update-slides.cmd.
#   hero-1.jpg, hero-2.jpg, hero-3.jpg ...   wide pictures, in the order they should appear (.jpg .png .webp .avif). About 2880 x 1250 or 16:9, the person or product in the RIGHT half, the left 45 percent calm for the headline. Under about 400 KB each.
#   hero-1-mobile.jpg                        OPTIONAL upright (portrait) picture for phones held upright, about 900 x 1600, the product or face in the middle. Any slide can have one (hero-2-mobile.jpg ...).
#   hero-1-1100.jpg                          made automatically: a 1100 px wide copy so tablets and phones download less. Do not add it yourself.
#   focus.json                               OPTIONAL focus point per picture and screen size, so the right part stays in view when the picture is cropped:
#                                            { "hero-1.jpg": { "pos": "66% 30%", "posTablet": "92% 50%", "posMobile": "80% 50%", "posPortrait": "50% 46%" } }
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Add-Type -AssemblyName System.Drawing
$files = Get-ChildItem $here -File | Where-Object { $_.Name -match '^hero-\d+\.(jpe?g|png|webp|avif)$' } | Sort-Object { [regex]::Replace($_.Name, '\d+', { param($m) $m.Value.PadLeft(8, '0') }) }
$focus = $null; $fp = Join-Path $here 'focus.json'; if (Test-Path -LiteralPath $fp) { $focus = [IO.File]::ReadAllText($fp) | ConvertFrom-Json }
$jpg = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
function Get-Width([string]$p) { $im = [Drawing.Image]::FromFile($p); try { return $im.Width } finally { $im.Dispose() } }
function New-Small([string]$p, [string]$dest, [int]$w) {
  $im = [Drawing.Image]::FromFile($p)
  try {
    $h = [int][Math]::Round($im.Height * $w / $im.Width); $bmp = New-Object Drawing.Bitmap $w, $h; $g = [Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = 'HighQualityBicubic'; $g.SmoothingMode = 'HighQuality'; $g.PixelOffsetMode = 'HighQuality'; $g.DrawImage($im, 0, 0, $w, $h); $g.Dispose()
    $ep = New-Object Drawing.Imaging.EncoderParameters(1); $ep.Param[0] = New-Object Drawing.Imaging.EncoderParameter([Drawing.Imaging.Encoder]::Quality, [long]82); $bmp.Save($dest, $jpg, $ep); $bmp.Dispose()
  } finally { $im.Dispose() }
}
# the hero blends the text area into the picture: the band of colour at the top edge of the visible crop is measured here (left and right, because the pictures are lighter on one side) and written as "toneP" (upright phone picture) and "toneW" (wide picture)
function Get-Tone([string]$p, [double]$start) {
  $im = [Drawing.Bitmap]::FromFile($p)
  try {
    $y0 = [int][Math]::Min($im.Height - 4, [Math]::Max(0, [Math]::Round($start * $im.Height))); $hh = [Math]::Max(3, [int]($im.Height * 0.012)); $out = @()
    foreach ($rng in @(@(0.04, 0.30), @(0.70, 0.96))) {
      $x0 = [int]($rng[0] * $im.Width); $x1 = [int]($rng[1] * $im.Width); $r = 0; $g = 0; $b = 0; $n = 0
      for ($y = $y0; $y -lt [Math]::Min($im.Height, $y0 + $hh); $y += 2) { for ($x = $x0; $x -lt $x1; $x += 6) { $c = $im.GetPixel($x, $y); $r += $c.R; $g += $c.G; $b += $c.B; $n++ } }
      $out += ('#{0:x2}{1:x2}{2:x2}' -f [int]($r / $n), [int]($g / $n), [int]($b / $n))
    }
    return $out
  } finally { $im.Dispose() }
}$items = @(); $i = 0
foreach ($f in $files) {
  $i++; $base = [IO.Path]::GetFileNameWithoutExtension($f.Name); $w = Get-Width $f.FullName; $row = @('"src": "' + $f.Name + '"')
  if ($w -gt 1400 -and $f.Extension -match '^\.jpe?g$') {
    $small = Join-Path $here ($base + '-1100.jpg'); if (-not (Test-Path -LiteralPath $small) -or (Get-Item -LiteralPath $small).LastWriteTime -lt $f.LastWriteTime) { New-Small $f.FullName $small 1100 }
    $row += '"srcset": "' + $base + '-1100.jpg 1100w, ' + $f.Name + ' ' + $w + 'w"'
  }
  $mob = Get-ChildItem $here -File | Where-Object { $_.Name -match ('^' + [regex]::Escape($base) + '-mobile\.(jpe?g|png|webp|avif)$') } | Select-Object -First 1
  if ($mob) { $row += '"mobile": "' + $mob.Name + '"' }
  $fo0 = $null; if ($focus -and $focus.PSObject.Properties[$f.Name]) { $fo0 = $focus.($f.Name) }
  $ty = 0.0; if ($fo0 -and $fo0.PSObject.Properties['posPortrait']) { $pp = ([string]$fo0.posPortrait).Split(' '); if ($pp.Count -ge 2) { $ty = [double]$pp[1].TrimEnd('%') / 100.0 * (1 - 0.58) + 0.07 } }   # about where the fade into the text area ends: the upright crop shows about 58 percent of the picture's height; the band is taken a little below its top edge
  if ($mob) { $tp = Get-Tone $mob.FullName $ty; $row += '"toneP": ["' + $tp[0] + '", "' + $tp[1] + '"]' }
  $tw = Get-Tone $f.FullName 0.0; $row += '"toneW": ["' + $tw[0] + '", "' + $tw[1] + '"]'
  if ($focus -and $focus.PSObject.Properties[$f.Name]) { $fo = $focus.($f.Name); foreach ($k in 'pos', 'posTablet', 'posMobile', 'posPortrait', 'zoomPortrait', 'originPortrait', 'zoomWide', 'originWide', 'productTop') { if ($fo.PSObject.Properties[$k]) { $row += '"' + $k + '": "' + $fo.$k + '"' } } }
  $row += '"alt": "NUDGE campaign image ' + $i + ' of ' + $files.Count + '"'
  $items += '    { ' + ($row -join ', ') + ' }'
}
$thumb = Get-ChildItem $here -File | Where-Object { $_.Name -match '^thumb-product\.(jpe?g|png|webp|avif)$' } | Select-Object -First 1; $prod = if ($thumb) { "  ""product"": """ + $thumb.Name + """,`n" } else { '' }
$js = "/* Written by update-slides.ps1. Do not edit by hand: add or remove pictures in this folder and run update-slides.cmd again. (thumb-product.jpg is the small product picture in the Featured card, not a slide; hero-N-mobile and hero-N-1100 files are the phone and small-screen versions of slide N.) */`nwindow.NUDGE_HERO_SLIDES = {`n  ""base"": ""../assets/images/hero/"",`n  ""interval"": 4000,`n" + $prod + "  ""slides"": [`n" + ($items -join ",`n") + "`n  ]`n};`n"
[IO.File]::WriteAllText((Join-Path $here 'slides.js'), $js, (New-Object Text.UTF8Encoding($false)))
"slides.js written with $($files.Count) picture(s): " + (($files | ForEach-Object { $_.Name }) -join ', ')