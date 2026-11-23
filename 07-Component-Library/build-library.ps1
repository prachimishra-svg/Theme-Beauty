# Builds the local component library data from the single implementation root (03-Wireframes/00-Shared-Tailwind-Foundation/partials/components).
# Nothing is copied by hand: this script packs every component's template and manifest, and derives from the real sources where each component is used,
# its real call-site examples, its nested children, the Design System class definitions, the shared sprite and the base CSS the previews need, into library.data.js.
# Re-run after any component change.   Usage: .\build-library.ps1
$L = $PSScriptRoot; $P = Split-Path -Parent $L; $utf8 = New-Object Text.UTF8Encoding($false)
Add-Type -AssemblyName System.Web.Extensions
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer; $ser.MaxJsonLength = [int]::MaxValue; $ser.RecursionLimit = 200
$foundation = Join-Path $P '03-Wireframes\00-Shared-Tailwind-Foundation'
$compRoot = Join-Path $foundation 'partials\components'
$components = @{}
foreach ($cf in (Get-ChildItem $compRoot -Recurse -File -Filter *.html | Sort-Object FullName)) {
  $rel = $cf.FullName.Substring($compRoot.Length + 1) -replace '\\', '/' -replace '\.html$', ''
  $parts = $rel -split '/'; $name = if ($parts.Count -ge 2 -and $parts[-1] -eq $parts[-2]) { ($parts[0..($parts.Count - 2)] -join '/') } else { $rel }
  $mp = [IO.Path]::ChangeExtension($cf.FullName, '.json')
  $man = if (Test-Path $mp) { $ser.DeserializeObject([IO.File]::ReadAllText($mp, $utf8)) } else { $null }
  $html = [string][IO.File]::ReadAllText($cf.FullName, $utf8)
  $kids = @([regex]::Matches($html, '@@PARTIAL ((?:components/)?[a-z0-9/{}.-]+)') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique)
  $components["components/$name"] = @{ path = [string]("partials/components/$rel.html"); group = [string]$parts[0]; html = $html; manifest = $man; includes = [string[]]$kids }
}
# built-in shared partials that components may include (announcement bar, header, footer) and the page map used by @@LINK:page@@
$partials = @{}   # annbar, header and footer are components now (announcement-bar, site-header, site-footer)
$bp = [IO.File]::ReadAllText((Join-Path $foundation 'build.ps1'), $utf8); $pm = [regex]::Match($bp, '\$pages = \[ordered\]@\{([\s\S]*?)\n\}').Groups[1].Value
$pages = @{}; foreach ($m in [regex]::Matches($pm, "'([a-z-]+)'\s*=\s*'([^']+)'")) { $pages[$m.Groups[1].Value] = [string]($m.Groups[2].Value -replace '\\', '/') }
# usage: which page sources and parent components call each component, and real call examples (concrete arguments only)
$usage = @{}
function Note([string]$compName, [string]$where, [string]$kind, [string]$call) {
  if (-not $usage.ContainsKey($compName)) { $usage[$compName] = @{ pages = @{}; parents = @{}; examples = New-Object System.Collections.ArrayList } }
  $u = $usage[$compName]; $bucket = if ($kind -eq 'page') { $u.pages } else { $u.parents }; $bucket[$where] = 1 + [int]$bucket[$where]
  if ($call -notmatch '\{\{' -and $u.examples.Count -lt 4 -and -not (@($u.examples | Where-Object { $_.call -eq $call }).Count)) { [void]$u.examples.Add(@{ where = $where; call = $call }) }
}
foreach ($sf in (Get-ChildItem (Join-Path $foundation 'src') -File)) { $t = [IO.File]::ReadAllText($sf.FullName, $utf8); $pg = $sf.BaseName -replace '\.src$', ''
  foreach ($m in [regex]::Matches($t, '@@PARTIAL (components/[a-z0-9/-]+)([^@]*)@@')) { Note $m.Groups[1].Value $pg 'page' $m.Value } }
$chromeMap = @{ annbar = 'components/layout/announcement-bar'; header = 'components/header/site-header'; footer = 'components/layout/site-footer' }
foreach ($sf2 in (Get-ChildItem (Join-Path $foundation 'src') -File)) { $t2 = [IO.File]::ReadAllText($sf2.FullName, $utf8); $pg2 = $sf2.BaseName -replace '\.src$', ''; foreach ($m in [regex]::Matches($t2, '@@PARTIAL (annbar|header|footer)\b[^@]*@@')) { Note $chromeMap[$m.Groups[1].Value] $pg2 'page' $m.Value } }
foreach ($cn in $components.Keys) { foreach ($m in [regex]::Matches($components[$cn].html, '@@PARTIAL (components/[a-z0-9/-]+)([^@]*)@@')) { Note $m.Groups[1].Value $cn 'parent' $m.Value } }
# Design System classes: the @apply content of each simple component class (so the Tokens tab can look inside .btn, .chip ...)
$cssComp = [IO.File]::ReadAllText((Join-Path $foundation 'partials\components.tw.css'), $utf8); $cssBase = [IO.File]::ReadAllText((Join-Path $foundation 'partials\base.tw.css'), $utf8)
$ds = @{}; foreach ($m in [regex]::Matches($cssComp + "`n" + $cssBase, '(?m)^\s*\.([a-z][\w-]*)\s*\{\s*@apply ([^;}]*)')) { if (-not $ds.ContainsKey($m.Groups[1].Value)) { $ds[$m.Groups[1].Value] = [string]$m.Groups[2].Value.Trim() } }
# plain copy for the serializer (PowerShell wrappers around hashtables confuse it)
$usageOut = @{}
foreach ($k in @($usage.Keys)) { $u = $usage[$k]
  $pg = @{}; foreach ($x in @($u.pages.Keys)) { $pg[[string]$x] = [int]$u.pages[$x] }
  $pa = @{}; foreach ($x in @($u.parents.Keys)) { $pa[[string]$x] = [int]$u.parents[$x] }
  $ex = New-Object 'System.Collections.Generic.List[object]'; foreach ($e in $u.examples) { $ex.Add(@{ where = [string]$e.where; call = [string]$e.call }) }
  $usageOut[[string]$k] = @{ pages = $pg; parents = $pa; examples = $ex.ToArray() } }$hpSrc = [IO.File]::ReadAllText((Join-Path $foundation 'src\homepage.src.html')); $hpCss = [regex]::Match($hpSrc, '<style type="text/tailwindcss">([\s\S]*?)</style>').Groups[1].Value
$data = @{ builtins = $partials; pages = $pages; usage = $usageOut; dsClasses = $ds; css = @{ base = [string]$cssBase; components = [string]$cssComp; pages = @{ homepage = [string]$hpCss } }; sprite = [string][IO.File]::ReadAllText((Join-Path $foundation 'partials\sprite.html'), $utf8); generated = [string](Get-Date -Format 'yyyy-MM-dd HH:mm'); components = $components }
[IO.File]::WriteAllText("$L\library.data.js", "/* GENERATED by build-library.ps1. Do not edit. */`nwindow.NUDGE_LIB = " + $ser.Serialize($data) + ";`n", $utf8)
"library.data.js: $($components.Count) components, $(@($components.Values | Where-Object { $_.manifest }).Count) with a manifest, $($usage.Count) used somewhere, $($ds.Count) Design System classes; $([Math]::Round((Get-Item "$L\library.data.js").Length / 1KB)) KB"
