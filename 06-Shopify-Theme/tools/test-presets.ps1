# Theme Editor robustness: renders every section that has a preset (a) as a freshly added section with its preset blocks and default settings, and
# (b) emptied: no blocks and no settings filled in. Both must render without Liquid errors, missing translations or missing snippets, and (a) must not be blank.
# Uses a temporary templates/_presets.json (deleted afterwards). Usage: .\tools\test-presets.ps1
$T = Split-Path -Parent $PSScriptRoot; $utf8 = New-Object Text.UTF8Encoding($false)
$secs = Get-ChildItem "$T\sections" -Filter *.liquid
$fresh = [ordered]@{}; $empty = [ordered]@{}; $names = @()
foreach ($f in $secs) {
  $src = [IO.File]::ReadAllText($f.FullName, $utf8); $m = [regex]::Match($src, '\{%-?\s*schema\s*-?%\}([\s\S]*?)\{%-?\s*endschema\s*-?%\}'); if (-not $m.Success) { continue }
  $sc = $m.Groups[1].Value | ConvertFrom-Json; if (-not $sc.presets) { continue }
  $type = $f.BaseName; $names += $type; $pr = @($sc.presets)[0]
  $blocks = [ordered]@{}; $order = @(); $i = 0
  foreach ($b in @($pr.blocks)) { if (-not $b) { continue }; $i++; $id = "b$i"; $blocks[$id] = [ordered]@{ type = $b.type; settings = $(if ($b.settings) { $b.settings } else { [ordered]@{} }) }; $order += $id }
  $fresh[$type] = [ordered]@{ type = $type; settings = $(if ($pr.settings) { $pr.settings } else { [ordered]@{} }); blocks = $blocks; block_order = $order }
  $empty["e-$type"] = [ordered]@{ type = $type; settings = [ordered]@{}; blocks = [ordered]@{}; block_order = @() }
}
$res = @()
foreach ($mode in 'fresh', 'empty') {
  $set = if ($mode -eq 'fresh') { $fresh } else { $empty }
  $tpl = Join-Path $T 'templates\_presets.json'
  try {
    [IO.File]::WriteAllText($tpl, ([ordered]@{ sections = $set; order = @($set.Keys) } | ConvertTo-Json -Depth 12), $utf8)
    $r = & "$PSScriptRoot\render-theme.ps1" -Template '_presets' -Quiet
  } finally { if (Test-Path $tpl) { Remove-Item $tpl -Force } }
  $errs = @($r.Errors | Select-Object -Unique)
  $missing = @(); foreach ($k in $set.Keys) { if ($r.Html -notmatch ('id="shopify-section-' + [regex]::Escape($k) + '"')) { $missing += $k } }
  "{0,-6}: {1} sections rendered, {2} problem(s){3}" -f $mode, ($set.Count - $missing.Count), $errs.Count, $(if ($missing) { '; not rendered: ' + ($missing -join ', ') } else { '' })
  $errs | ForEach-Object { "         - $_" }
  $res += [pscustomobject]@{ Mode = $mode; Errors = $errs; Missing = $missing }
}
"sections tested: $($names -join ', ')"
$res