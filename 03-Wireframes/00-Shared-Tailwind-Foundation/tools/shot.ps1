# Usage: plp-shot.ps1 -Name tag -Query "state=applied" -Widths 1440,390 -Height 3000
param([string]$File, [string]$Name = "p", [string]$Query = "", [int[]]$Widths = @(1440, 390), [int]$Height = 0)
$sp = Join-Path ([IO.Path]::GetTempPath()) "nudge-tools"; New-Item -ItemType Directory -Force $sp | Out-Null
$f = (Resolve-Path $File).Path
$u = "file:///" + ($f -replace '\\', '/' -replace ' ', '%20') + "?embed=1&ann=0"
if ($Query) { $u += "&" + $Query }
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
foreach ($w in $Widths) {
  $h = $Height; if (-not $h) { $h = @{1920 = 1080; 1440 = 900; 1280 = 800; 1024 = 768; 768 = 1024; 390 = 844; 375 = 667; 360 = 780; 320 = 568 }[$w]; if (-not $h) { $h = 900 } }
  $out = Join-Path $sp "$Name-$w.png"
  if ($w -lt 600) {
    $fr = Join-Path $sp "pframe-$w.html"
    [IO.File]::WriteAllText($fr, "<!doctype html><html><body style=`"margin:0;background:#fff`"><iframe src=`"$u`" style=`"width:${w}px;height:${h}px;border:0;display:block`"></iframe></body></html>")
    $target = "file:///" + ($fr -replace '\\', '/'); $ww = 600
  } else { $target = $u; $ww = $w }
  & $chrome --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files --window-size="$ww,$h" --virtual-time-budget=9000 --screenshot="$out" $target 2>$null | Out-Null
  if ($w -lt 600) {
    Add-Type -AssemblyName System.Drawing
    $img = [System.Drawing.Image]::FromFile($out); $bmp = New-Object System.Drawing.Bitmap $w, $h
    $g = [System.Drawing.Graphics]::FromImage($bmp); $g.DrawImage($img, (New-Object System.Drawing.Rectangle 0, 0, $w, $h), (New-Object System.Drawing.Rectangle 0, 0, $w, $h), [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose(); $img.Dispose(); $bmp.Save($out); $bmp.Dispose()
  }
  $out
}
