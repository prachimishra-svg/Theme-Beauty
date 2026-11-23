# Compares every built page with the stored baseline (tools/baseline, the pages as they were before componentisation).
# Whitespace between tags and inside attributes is ignored; anything else is a difference. Exit text: "equivalent: N, different: M".
# Usage: .\tools\check-equivalence.ps1 [-Build]   (-Build runs build.ps1 -All first)
param([switch]$Build)
$root = Split-Path -Parent $PSScriptRoot; $wf = Split-Path -Parent $root
if ($Build) { $bo = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root 'build.ps1') -All 2>&1; if ($LASTEXITCODE -ne 0) { $bo | Select-Object -First 6 | ForEach-Object { $_.ToString() }; throw 'build failed: the pages below were NOT rebuilt, so no comparison is valid' } }
function Norm([string]$t) {
  $t = $t -replace '\s+', ' '; $t = $t -replace '> <', '><'; $t = $t -replace ' "', '"'; $t = $t -replace '" >', '">'; $t = $t -replace ' >', '>'
  $t = $t -replace ' xlink:href="[^"]*"', ''                                                          # legacy xlink:href next to href is redundant (href wins)
  $t = [regex]::Replace($t, '<use ([^>]*?)\s*/>', '<use $1></use>')                       # <use/> and <use></use> are the same element
  [regex]::Replace($t, ' class="([^"]*)"', { param($m) ' class="' + ((($m.Groups[1].Value -split '\s+') | Where-Object { $_ } | Sort-Object) -join ' ') + '"' })  # class token order is not significant
}
# Pages whose markup is built by scripts are compared by RENDERED equivalence (07-Component-Library/tools/capture-page-states.ps1, states in tools/states) instead of by static HTML.
$statesDir = Join-Path (Split-Path -Parent $wf) '07-Component-Library\tools\states'; $domPages = @{}
if (Test-Path $statesDir) { Get-ChildItem $statesDir -Filter *.states.json | ForEach-Object { $cfg = [IO.File]::ReadAllText($_.FullName) | ConvertFrom-Json; $domPages[[IO.Path]::GetFileName($cfg.page)] = $_.Name -replace '\.states\.json', '' } }
$same = 0; $bad = 0
Get-ChildItem $wf -Recurse -Filter *.html | Where-Object { $_.FullName -match '\\\d\d-NUDGE' -and $_.Name -notmatch '\.bk\.' } | ForEach-Object {
  if ($domPages.ContainsKey($_.Name)) { return }   # compared by rendered equivalence below
  $a = Norm ([IO.File]::ReadAllText((Join-Path $PSScriptRoot "baseline\$($_.Name)"))); $b = Norm ([IO.File]::ReadAllText($_.FullName))
  if ($a -eq $b) { $same++ } else {
    $bad++; $n = 0; while ($n -lt $a.Length -and $n -lt $b.Length -and $a[$n] -eq $b[$n]) { $n++ }
    $s = [Math]::Max(0, $n - 70)
    "{0}: first difference at {1}`n  baseline: ...{2}`n  built   : ...{3}" -f $_.Name, $n, $a.Substring($s, [Math]::Min(180, $a.Length - $s)), $b.Substring($s, [Math]::Min(180, $b.Length - $s))
  }
}
foreach ($dp in $domPages.GetEnumerator()) {
  $ep0 = $ErrorActionPreference; $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path (Split-Path -Parent $wf) '07-Component-Library\tools\capture-page-states.ps1') -Page $dp.Value 2>&1; $code = $LASTEXITCODE; $ErrorActionPreference = $ep0
  if ($code -eq 0) { $same++; ('{0}: rendered equivalence PASS ({1})' -f $dp.Key, (($o | Select-Object -Last 4 | Where-Object { $_ -match 'identical|within' }) -join '; ')) } else { $bad++; ('{0}: rendered equivalence FAILED' -f $dp.Key); $o | Select-Object -First 12 | ForEach-Object { '  ' + $_.ToString() } }
}
"equivalent: $same, different: $bad"