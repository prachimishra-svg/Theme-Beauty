# Shared functions for the Figma specification tools (dot-sourced by build-figma-variables.ps1 and validate-figma-variables.ps1).
# Reads the WEB tokens read-only to compare values. Never writes to 01-Design-System/ or 02-Design-Variables/.
$script:inv = [Globalization.CultureInfo]::InvariantCulture
$script:SourceFiles = @('primitives.json', 'spacing.json', 'typography.json', 'semantic.json', 'layout.json', 'component-variables.json')
$script:RefWidths = @{ Mobile = 360; Tablet = 768; Desktop = 1280 }

function Read-Json([string]$p) { Get-Content $p -Raw -Encoding UTF8 | ConvertFrom-Json }
function Get-AliasName($v) { if ($v -is [string] -and $v -match '^\{([^{}]+)\}$') { $Matches[1] } else { $null } }

function Load-FigmaSpec([string]$figmaDir) {
  $cdef = Read-Json (Join-Path $figmaDir 'collections.source.json')
  $vars = New-Object System.Collections.ArrayList
  $extra = [ordered]@{ textStyles = @(); gridStyles = @(); effectStyles = @() }
  foreach ($f in $script:SourceFiles) {
    $j = Read-Json (Join-Path $figmaDir $f)
    foreach ($v in $j.variables) { $v | Add-Member -NotePropertyName sourceFile -NotePropertyValue $f -Force; [void]$vars.Add($v) }
    if ($j.PSObject.Properties.Name -contains 'textStyles') { $extra.textStyles = @($j.textStyles) }
    if ($j.PSObject.Properties.Name -contains 'gridStyles') { $extra.gridStyles = @($j.gridStyles) }
    if ($j.PSObject.Properties.Name -contains 'effectStyles') { $extra.effectStyles = @($j.effectStyles) }
  }
  $by = @{}; foreach ($v in $vars) { if (-not $by.ContainsKey($v.name)) { $by[$v.name] = $v } }
  [pscustomobject]@{ collections = @($cdef.collections); modeDecisions = @($cdef.modeDecisions); variables = $vars; byName = $by; textStyles = $extra.textStyles; gridStyles = $extra.gridStyles; effectStyles = $extra.effectStyles }
}

function ValuesOf($var) { $o = [ordered]@{}; foreach ($p in $var.values.PSObject.Properties) { $o[$p.Name] = $p.Value }; $o }

# Resolve a Figma variable to a literal in a mode. An alias resolves in the SAME mode when the target's collection has that mode,
# otherwise in the target collection's only mode (Figma behaviour for a single-mode collection).
function Resolve-Figma($spec, $var, [string]$mode, [int]$depth = 0) {
  if ($depth -gt 12) { throw "Alias chain too deep (cycle?) at $($var.name)" }
  $vals = ValuesOf $var
  if (-not $vals.Contains($mode)) { throw "Variable $($var.name) has no value for mode '$mode'" }
  $raw = $vals[$mode]
  $a = Get-AliasName $raw
  if (-not $a) { return $raw }
  if (-not $spec.byName.ContainsKey($a)) { throw "Unresolved alias {$a} in $($var.name) ($mode)" }
  $t = $spec.byName[$a]
  $tc = $spec.collections | Where-Object { $_.name -eq $t.collection }
  $tmode = if (@($tc.modes) -contains $mode) { $mode } elseif (@($tc.modes).Count -eq 1) { $tc.modes[0] } else { throw "Alias {$a} from $($var.name) points into multi-mode collection $($t.collection) without a matching mode '$mode'" }
  Resolve-Figma $spec $t $tmode ($depth + 1)
}

# ------------------------- web tokens (read-only) -------------------------
function Get-WebTokens([string]$webTokenDir) {
  $list = New-Object System.Collections.ArrayList
  function W($node, [string[]]$path, [string]$file) {
    foreach ($p in $node.PSObject.Properties) {
      if ($p.Name.StartsWith('$')) { continue }
      $c = $p.Value; if ($c -isnot [pscustomobject]) { continue }
      $np = $path + $p.Name
      if ($c.PSObject.Properties.Name -contains '$value') { [void]$list.Add([pscustomobject]@{ css = '--' + ($np -join '-'); path = ($np -join '.'); file = $file; raw = $c.'$value'; desc = [string]$c.'$description' }) }
      else { W $c $np $file }
    }
  }
  foreach ($f in 'primitives', 'semantic', 'typography', 'spacing', 'layout', 'breakpoints', 'components', 'effects') { W (Read-Json (Join-Path $webTokenDir "$f.json")) @() $f }
  $list
}
function Get-WebScope([string]$webTokenDir) {
  $s = (Read-Json (Join-Path $webTokenDir 'semantic.json')).'$scopes'.'.surface-inverse'
  $o = @{}; foreach ($p in $s.PSObject.Properties) { if ($p.Name.StartsWith('--')) { $o[$p.Name] = [string]$p.Value } }; $o
}
function To-Num([string]$s) { [double]::Parse($s, $script:inv) }
function Clamp-Sample([string]$expr, [double]$w) {
  $m = [regex]::Match($expr, '^clamp\(\s*([\d.]+)rem\s*,\s*([\d.]+)rem\s*\+\s*([\d.]+)vw\s*,\s*([\d.]+)rem\s*\)$')
  if (-not $m.Success) { return $null }
  $mn = (To-Num $m.Groups[1].Value) * 16; $a = (To-Num $m.Groups[2].Value) * 16; $b = To-Num $m.Groups[3].Value; $mx = (To-Num $m.Groups[4].Value) * 16
  [math]::Min([math]::Max($mn, $a + $b * $w / 100), $mx)
}
function Hex2([double]$v) { ([int][math]::Floor($v + 0.5)).ToString('X2') }
# Resolve a web token (by dotted path) to a literal: a number in px, an upper-case hex colour, or a string. $tier picks mobile/tablet/desktop; $overrides re-maps css names (the .surface-inverse scope).
function Resolve-Web($map, [string]$path, [string]$tier, $overrides, [double]$width, [int]$depth = 0) {
  if ($depth -gt 14) { return $null }
  if (-not $map.ContainsKey($path)) { return $null }
  $t = $map[$path]
  if ($overrides -and $overrides.ContainsKey($t.css)) {
    $o = [string]$overrides[$t.css]
    if ($o -eq 'transparent') { return '#00000000' }
    $oa = Get-AliasName $o
    if ($oa) { return (Resolve-Web $map $oa $tier $null $width ($depth + 1)) }
  }
  $raw = $t.raw
  if ($raw -is [pscustomobject]) { $raw = [string]$raw.$tier }
  $s = [string]$raw
  $a = Get-AliasName $s
  if ($a) { return Resolve-Web $map $a $tier $overrides $width ($depth + 1) }
  # rgb(<shadow.color> / <opacity>) composite
  $m = [regex]::Match($s, '^rgb\(\{([^}]+)\}\s*/\s*\{([^}]+)\}\)$')
  if ($m.Success) { $rgb = [string](Resolve-Web $map $m.Groups[1].Value $tier $null $width ($depth + 1)); $al = [double](Resolve-Web $map $m.Groups[2].Value $tier $null $width ($depth + 1)); $p = $rgb -split '\s+'; return '#' + (Hex2 (To-Num $p[0])) + (Hex2 (To-Num $p[1])) + (Hex2 (To-Num $p[2])) + (Hex2 ($al * 255)) }
  $m = [regex]::Match($s, '^rgb\(\s*(\d+)\s+(\d+)\s+(\d+)\s*/\s*([\d.]+)\s*\)$')
  if ($m.Success) { return '#' + (Hex2 (To-Num $m.Groups[1].Value)) + (Hex2 (To-Num $m.Groups[2].Value)) + (Hex2 (To-Num $m.Groups[3].Value)) + (Hex2 ((To-Num $m.Groups[4].Value) * 255)) }
  if ($s -match '^#[0-9A-Fa-f]{6}$') { return $s.ToUpper() }
  if ($s -match '^(-?[\d.]+)rem$') { return (To-Num $Matches[1]) * 16 }
  if ($s -match '^(-?[\d.]+)px$') { return To-Num $Matches[1] }
  if ($s -match '^-?[\d.]+$') { return To-Num $s }
  if ($s -like 'clamp(*') { $v = Clamp-Sample $s $width; if ($null -ne $v) { return $v } }
  return $s
}
