# Pixel comparison of a rendered theme page against the approved wireframe Homepage, using the wireframe's pixel-diff tool.
# The wireframe carries visible review notes (".note" sentences, e.g. "Native JavaScript only ..." in the finder and "Reviews are typed by the merchant ..." in Testimonials)
# that are design commentary and are not shipped in the theme; they would shift every section below them. This wrapper hides them in a TEMPORARY copy of the wireframe
# The empty Custom Liquid slot (#s18) is hidden too: the theme renders nothing to shoppers there.
# (created next to the original so its relative links work, deleted afterwards). The currency is pinned to USD because the wireframe's currency.js converts prices at run time.
# Usage: .\tools\theme-pixel-diff.ps1 -Rendered <rendered theme html (-LocalAssets)> -Widths 1440,390 -Height 7100
param([Parameter(Mandatory = $true)][string]$Rendered, [int[]]$Widths = @(1440, 390), [int]$Height = 5000, [string]$Out = '')
$T = Split-Path -Parent $PSScriptRoot; $P = Split-Path -Parent $T; $utf8 = New-Object Text.UTF8Encoding($false)
$wfTools = Join-Path $P '03-Wireframes\00-Shared-Tailwind-Foundation\tools'
$home1 = Get-ChildItem (Join-Path $P '03-Wireframes') -Recurse -Filter Homepage.html | Where-Object { $_.FullName -match '\\\d\d-NUDGE' } | Select-Object -First 1
$tmp = Join-Path $home1.DirectoryName '_compare-nonotes.tmp.html'
try {
  $h = [IO.File]::ReadAllText($home1.FullName, $utf8).Replace('</head>', '<style>.note{display:none!important}#s18{display:none!important}</style></head>')
  [IO.File]::WriteAllText($tmp, $h, $utf8)
  & (Join-Path $wfTools 'pixel-diff.ps1') -A $tmp -B (Resolve-Path $Rendered).Path -Query 'cur=USD' -Widths $Widths -Height $Height -Out $Out
} finally { if (Test-Path $tmp) { Remove-Item $tmp -Force } }