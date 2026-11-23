# Proves that a change to the shared icon sprite did not change any page: for every built page, compared with a saved copy of the pages from before the change,
#   1. the markup outside the hidden sprite blocks is identical (whitespace-normalised),
#   2. every icon symbol that existed before (shared or page-local) still exists, with identical geometry,
#   3. no icon id is defined twice,
#   4. every <use href="#icon-x"> on the page resolves to a symbol.
# Usage: .\tools\verify-sprite-change.ps1 -Before <folder with the saved page .html files>
param([Parameter(Mandatory = $true)][string]$Before)
$ErrorActionPreference = 'Stop'
$L = Split-Path -Parent $PSScriptRoot; $W = Join-Path (Split-Path -Parent $L) '03-Wireframes'; $utf8 = New-Object Text.UTF8Encoding($false)
$blockRe = '<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false" style="position:absolute;width:0;height:0;overflow:hidden">[\s\S]*?</svg>'
function Norm([string]$t) { $t = $t -replace '\s+', ' '; $t = $t -replace '> <', '><'; $t = $t -replace ' >', '>'; $t }
function Symbols([string]$t) { $h = @{}; $dups = @(); foreach ($b in [regex]::Matches($t, $blockRe)) { foreach ($s in [regex]::Matches($b.Value, '<symbol id="(icon-[^"]+)"[^>]*>([\s\S]*?)</symbol>')) { $id = $s.Groups[1].Value; if ($h.ContainsKey($id)) { $dups += $id }; $h[$id] = (Norm $s.Groups[2].Value) } }; @{ map = $h; dups = $dups } }
$ok = 0; $bad = 0; $added = $null
Get-ChildItem $W -Recurse -Filter *.html | Where-Object { $_.FullName -match '\\\d\d-NUDGE' -and $_.Name -notmatch '\.bk\.' } | ForEach-Object {
  $bp = Join-Path $Before $_.Name; if (-not (Test-Path $bp)) { "no saved copy for $($_.Name)"; $script:bad++; return }
  $a = [IO.File]::ReadAllText($bp, $utf8); $b = [IO.File]::ReadAllText($_.FullName, $utf8); $probs = @()
  $ra = Norm ([regex]::Replace($a, $blockRe, '')); $rb = Norm ([regex]::Replace($b, $blockRe, ''))
  if ($ra -ne $rb) { $n = 0; while ($n -lt $ra.Length -and $n -lt $rb.Length -and $ra[$n] -eq $rb[$n]) { $n++ }; $probs += "markup outside the sprite differs at $n" }
  $sa = Symbols $a; $sb = Symbols $b
  foreach ($id in $sa.map.Keys) { if (-not $sb.map.ContainsKey($id)) { $probs += "symbol $id lost" } elseif ($sb.map[$id] -ne $sa.map[$id]) { $probs += "symbol $id geometry changed" } }
  if ($sb.dups.Count) { $probs += "duplicate ids after: " + (($sb.dups | Select-Object -Unique) -join ', ') }
  foreach ($u in [regex]::Matches($b, '<use href="#(icon-[^"]+)"')) { if (-not $sb.map.ContainsKey($u.Groups[1].Value)) { $probs += "unresolved use " + $u.Groups[1].Value } }
  $script:added = @($sb.map.Keys | Where-Object { -not $sa.map.ContainsKey($_) } | Sort-Object)
  if ($probs.Count) { $script:bad++; "{0}: {1}" -f $_.Name, (($probs | Select-Object -Unique) -join '; ') } else { $script:ok++ }
}
"pages unchanged outside the sprite and fully resolved: $ok; with problems: $bad"
"symbols added to every page: " + ($added.Count) + " (" + (($added | ForEach-Object { $_ -replace '^icon-', '' }) -join ', ') + ")"
