# Token-gap report: every fixed pixel value ([Npx]) inside the component templates, with where it is used and a recommended mapping to the existing Design Variables.
# READ-ONLY: this tool reports. It never edits a component and nothing is changed until the report is reviewed and approved.
# Usage: .\tools\token-report.ps1     writes docs/TOKEN-REPORT.md and docs/token-report.csv
$L = Split-Path -Parent $PSScriptRoot; $P = Split-Path -Parent $L; $utf8 = New-Object Text.UTF8Encoding($false)
$css = [IO.File]::ReadAllText("$P\02-Design-Variables\Styles\variables.css", $utf8)
function Px([string]$v) { $v = $v.Trim(); if ($v -match '^([\d.]+)rem$') { return [double]$Matches[1] * 16 } elseif ($v -match '^([\d.]+)px$') { return [double]$Matches[1] } else { return $null } }
$tok = [ordered]@{ space = @{}; type = @{}; icon = @{}; radius = @{}; border = @{}; control = @{} }
$vals = @{}
foreach ($m in [regex]::Matches($css, '(?m)^\s*(--[\w-]+)\s*:\s*([^;]+);')) {
  $n = $m.Groups[1].Value; $v = Px $m.Groups[2].Value; if ($null -eq $v) { continue }
  $vals[$n] = @($vals[$n]) + $v
  $fam = if ($n -match '^--space-\d+$') { 'space' } elseif ($n -match '^--font-size-') { 'type' } elseif ($n -match '^--icon-size-') { 'icon' } elseif ($n -match '^--radius-(sm|md|lg)$') { 'radius' } elseif ($n -match '^--border-width-') { 'border' } elseif ($n -match '^--(touch-target-min|control-height-\w+|icon-button-count-size)$') { 'control' } else { $null }
  if ($fam -and -not $tok[$fam].ContainsKey($n)) { $tok[$fam][$n] = $v }
}
# a token is "constant" only if it has the same value in every responsive tier; tiered tokens (for example h3: 24, 28, 32 px) are never identical to a fixed literal
$const = @{}; foreach ($n in $vals.Keys) { $const[$n] = (@($vals[$n] | Select-Object -Unique).Count -eq 1) }
$tiered = @($vals.Keys | Where-Object { -not $const[$_] -and $_ -match '^--font-size-' } | Sort-Object)
function Family([string]$util) {
  switch -Regex ($util) {
    '^text$' { 'type' } '^(size|w|h|min-w|min-h|max-w|max-h)$' { 'size' } '^-?(p|px|py|pt|pb|pl|pr|m|mx|my|mt|mb|ml|mr|gap|gap-x|gap-y|space-x|space-y)$' { 'space' }
    '^-?(top|bottom|left|right|inset|inset-x|inset-y)$' { 'offset' } '^rounded' { 'radius' } '^border' { 'border' } '^-?translate' { 'motion offset' } default { 'other' } }
}
function Candidates([string]$fam, [double]$v) {
  $all = @()
  $sets = switch ($fam) { 'type' { @('type') } 'size' { @('icon', 'control', 'space') } 'space' { @('space') } 'offset' { @('space') } 'radius' { @('radius') } 'border' { @('border') } default { @() } }
  foreach ($s in $sets) { foreach ($k in $tok[$s].Keys) { $all += [pscustomobject]@{ Token = $k; Px = $tok[$s][$k]; Const = $const[$k] } } }
  $all
}
$rows = @()
$compRoot = Join-Path $P '03-Wireframes\00-Shared-Tailwind-Foundation\partials\components'
foreach ($f in (Get-ChildItem $compRoot -Recurse -File -Filter *.html)) {
  $name = $f.FullName.Substring($compRoot.Length + 1) -replace '\\', '/' -replace '\.html$', ''; $t = [IO.File]::ReadAllText($f.FullName, $utf8)
  foreach ($m in [regex]::Matches($t, '(?<![\w-])(?<util>-?[a-z]+(?:-[a-z]+)*)-\[(?<v>\d+(?:\.\d+)?)px\]')) {
    $rows += [pscustomobject]@{ Component = $name; Util = $m.Groups['util'].Value; Px = [double]$m.Groups['v'].Value; Raw = $m.Value }
  }
}
$total = $rows.Count
$groups = $rows | Group-Object { "$($_.Util)|$($_.Px)" } | Sort-Object { - $_.Count }, Name
$out = @(); $csv = @('utility,px,count,family,recommendation,identical_token,nearest_token,delta_px,components')
$sum = @{ 'Safe to map (identical token exists)' = 0; 'Needs your decision (no identical token)' = 0; 'Sub-grid detail (3 px or less)' = 0; 'Not a design-token value (breakpoint or layout)' = 0 }
foreach ($g in $groups) {
  $u, $pxs = $g.Name -split '\|'; $px = [double]$pxs; $fam = Family $u
  $c = @(Candidates $fam $px); $exact = @($c | Where-Object { $_.Px -eq $px -and $_.Const })
  $tieredHit = @($c | Where-Object { $_.Px -eq $px -and -not $_.Const })
  $near = $c | Sort-Object { [Math]::Abs($_.Px - $px) } | Select-Object -First 1
  $rec = if ($u -in 'max', 'min' -or ($u -match 'max-w|min-w|w$' -and $px -gt 200)) { 'Not a design-token value (breakpoint or layout)' } elseif ($exact.Count) { 'Safe to map (identical token exists)' } elseif ($px -le 3) { 'Sub-grid detail (3 px or less)' } elseif ($tieredHit.Count) { 'Needs your decision (no identical token)' } else { 'Needs your decision (no identical token)' }
  $sum[$rec] += $g.Count
  $comps = ($g.Group | ForEach-Object { $_.Component } | Select-Object -Unique)
  $exTok = if ($exact.Count) { ($exact | ForEach-Object { $_.Token }) -join ' or ' } else { '' }
  $nTok = if ($tieredHit.Count -and -not $exTok) { (($tieredHit | ForEach-Object { $_.Token }) -join ' or ') + ' (same on phones only; changes at wider breakpoints)' } elseif ($near) { $near.Token } else { '' }; $delta = if ($tieredHit.Count -and -not $exTok) { 0 } elseif ($near) { $near.Px - $px } else { '' }
  $out += "| ``$u-[$($px)px]`` | $($g.Count) | $fam | $rec | $(if ($exTok) { $exTok } else { '-' }) | $(if (-not $exTok -and $nTok) { "$nTok ($(if ($delta -gt 0) { '+' })$delta px)" } else { '-' }) | $(($comps | Select-Object -First 3) -join ', ')$(if ($comps.Count -gt 3) { " (+$($comps.Count - 3) more)" }) |"
  $csv += ('"{0}",{1},{2},{3},"{4}","{5}","{6}",{7},"{8}"' -f $u, $px, $g.Count, $fam, $rec, $exTok, $nTok, $delta, ($comps -join '; '))
}
$md = @"
# Token-gap report: fixed pixel values inside components

Generated by ``tools/token-report.ps1`` from the component templates. **Report only: no value has been changed.** Nothing will change until you review and approve a mapping.

**$total fixed pixel values** in $(@($rows | Select-Object -ExpandProperty Component -Unique).Count) component files, $($groups.Count) distinct (utility, value) pairs. Colours are not in this report: components use token colour utilities only (0 hex values).

## Summary by recommendation
| Recommendation | Occurrences |
|---|---|
$(($sum.Keys | ForEach-Object { "| $_ | $($sum[$_]) |" }) -join "`n")

How to read the recommendations:
- **Safe to map**: an existing token has exactly the same pixel value, so switching to the token changes nothing visually.
- **Needs your decision**: no token has this value. Options: keep the literal (documented exception), move the design to the nearest token (a visible change of the stated number of pixels), or add a new token (a new design value, which only you can approve).
- **Sub-grid detail (3 px or less)**: hairlines, outline offsets and optical nudges that sit off the 4 px grid by design. Recommended: document them as intentional exceptions rather than creating tokens.
- **Not a design-token value**: a breakpoint or a layout width that is not a spacing or type token.

## Token families used for the comparison (from ``variables.css``, base tier)
- Spacing (4 px grid): $((($tok.space.Keys | ForEach-Object { "$($_ -replace '--space-','')=$($tok.space[$_])" }) -join ', ')) px
- Type: $((($tok.type.Values | Sort-Object -Unique) -join ', ')) px (responsive tiers raise the larger sizes)
- Icon sizes: $((($tok.icon.Keys | ForEach-Object { "$($_ -replace '--icon-size-','')=$($tok.icon[$_])" }) -join ', ')) px; radius: $((($tok.radius.Keys | ForEach-Object { "$($_ -replace '--radius-','')=$($tok.radius[$_])" }) -join ', ')) px; borders: 1 and 2 px; touch target 44 px; control heights 40, 48, 56 px

## Detail (most used first)
| Value | Uses | Kind | Recommendation | Identical token | Nearest token | Where (first three components) |
|---|---|---|---|---|---|---|
$($out -join "`n")

## Notes
- ``text-[Npx]`` is a font size; ``size/w/h-[Npx]`` is an icon, dot or box size; ``p/m/gap/top/left-[Npx]`` is spacing or an optical offset.
- The same values also appear inside the page sources of the PLP, PDP and Cart wireframes (not yet components); they are reported when those pages are decomposed.
- Re-run the tool after any change: it always reflects the current templates.
"@
New-Item -ItemType Directory -Force "$L\docs" | Out-Null
[IO.File]::WriteAllText("$L\docs\TOKEN-REPORT.md", $md, $utf8); [IO.File]::WriteAllText("$L\docs\token-report.csv", ($csv -join "`n"), $utf8)
"fixed pixel values: $total in $($groups.Count) distinct pairs"; $sum.Keys | ForEach-Object { "  {0}: {1}" -f $_, $sum[$_] }