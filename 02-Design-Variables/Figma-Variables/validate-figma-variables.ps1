<#
  NUDGE Figma specification: validator. WRITES validation-report.md (its only output) and exits 0 (all passed) or 1.
  Run:  powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Figma-Variables/validate-figma-variables.ps1

  Checks (each failure names the file and the variable/component):
   1  JSON syntax of every Figma-specific JSON file
   2  Schema: required fields, types, collection and mode membership, value syntax per type, scopes valid for the type, names
   3  Duplicate and conflicting names (global, case-insensitive; a name cannot be both a variable and a group)
   4  Aliases: resolve, same type, no cycles, allowed layering, no cross-collection alias into a multi-mode collection
   5  Unsupported mappings: CSS expressions (clamp, calc, min, %, rem, px strings, var()) inside values
   6  Typography units: font sizes are px FLOAT in the Typography collection; no pt in any Figma-specific JSON, JS, HTML or CSS file; hierarchy and growth by tier
   7  Consistency with the web tokens (read-only): every variable and text style with a web token is compared per mode
   8  Coverage: every web token is classified; no colour token is unmapped
   9  Components: every variable and text style they name exists; property types; variant counts
  10  Generated files are fresh (rebuilt in a temporary copy and compared)
  11  Preview data matches the specification; the preview contains no hardcoded palette values
  12  Separation: the web system is byte-identical to the baseline manifest; the Figma tools never write into the web folders
  Optional files are never required beyond the fixed list in section 0.
#>
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$proj = Split-Path -Parent (Split-Path -Parent $here)   # project root
$fds = Join-Path $proj '01-Design-System/Figma-Specification'
. (Join-Path $here 'figma-tools.ps1')
$results = New-Object System.Collections.ArrayList
$script:trapped = @()
trap { $script:trapped += "$($_.Exception.Message) (validator line $($_.InvocationInfo.ScriptLineNumber))"; continue }
function Rec([string]$id, [string]$name, [string[]]$problems, [string]$detail = '') { [void]$results.Add([pscustomobject]@{ id = $id; name = $name; problems = @($problems | Where-Object { $_ }); detail = $detail }) }
function Rel([string]$p) { $p.Substring($proj.Length + 1).Replace('\', '/') }

# ---- 0. required files (fixed list) ----
$req = @('02-Design-Variables/Figma-Variables/collections.source.json', '02-Design-Variables/Figma-Variables/primitives.json', '02-Design-Variables/Figma-Variables/spacing.json', '02-Design-Variables/Figma-Variables/typography.json', '02-Design-Variables/Figma-Variables/semantic.json', '02-Design-Variables/Figma-Variables/layout.json', '02-Design-Variables/Figma-Variables/component-variables.json', '02-Design-Variables/Figma-Variables/variable-map.json', '02-Design-Variables/Figma-Variables/figma-tools.ps1', '02-Design-Variables/Figma-Variables/build-figma-variables.ps1', '02-Design-Variables/Figma-Variables/README.md', '02-Design-Variables/Figma-Variables/collections.md', '02-Design-Variables/Figma-Variables/mapping-report.md', '02-Design-Variables/Figma-Variables/web-baseline.manifest.json', '01-Design-System/Figma-Specification/components.json', '01-Design-System/Figma-Specification/README.md', '01-Design-System/Figma-Specification/components.md', '01-Design-System/Figma-Specification/component-properties.md', '01-Design-System/Figma-Specification/typography-styles.md', '01-Design-System/Figma-Specification/Preview/index.html', '01-Design-System/Figma-Specification/Preview/preview-data.js')
Rec '0' "All $($req.Count) required Figma-specific files exist" @($req | Where-Object { -not (Test-Path (Join-Path $proj $_)) } | ForEach-Object { "MISSING $_ : create it (run the build scripts) or remove it from the fixed list in validate-figma-variables.ps1" })

# ---- 1. JSON syntax ----
$jsonProblems = @(); $jsonCount = 0
foreach ($f in (Get-ChildItem $here, $fds -Filter *.json -Recurse)) { $jsonCount++; try { $null = Get-Content $f.FullName -Raw -Encoding UTF8 | ConvertFrom-Json } catch { $jsonProblems += "$(Rel $f.FullName) is not valid JSON: $($_.Exception.Message)" } }
Rec '1' "JSON syntax: $jsonCount files parse" $jsonProblems

$spec = Load-FigmaSpec $here
$map = Read-Json (Join-Path $here 'variable-map.json')
$typeScopes = @{ COLOR = @('ALL_SCOPES', 'ALL_FILLS', 'FRAME_FILL', 'SHAPE_FILL', 'TEXT_FILL', 'STROKE_COLOR', 'EFFECT_COLOR'); FLOAT = @('ALL_SCOPES', 'CORNER_RADIUS', 'WIDTH_HEIGHT', 'GAP', 'STROKE_FLOAT', 'EFFECT_FLOAT', 'OPACITY', 'FONT_WEIGHT', 'FONT_SIZE', 'LINE_HEIGHT', 'LETTER_SPACING', 'PARAGRAPH_SPACING', 'PARAGRAPH_INDENT'); STRING = @('ALL_SCOPES', 'TEXT_CONTENT', 'FONT_FAMILY', 'FONT_STYLE'); BOOLEAN = @('ALL_SCOPES') }
$collByName = @{}; foreach ($c in $spec.collections) { $collByName[$c.name] = $c }

# ---- 2. schema ----
$sp = @()
foreach ($v in $spec.variables) {
  $w = "$($v.sourceFile) variable '$($v.name)'"
  foreach ($f in 'name', 'collection', 'type', 'layer', 'description', 'scopes', 'values', 'webRelation') { if (-not ($v.PSObject.Properties.Name -contains $f)) { $sp += "$w is missing field '$f'" } }
  if ($v.type -notin 'COLOR', 'FLOAT', 'STRING', 'BOOLEAN') { $sp += "$w has unsupported type '$($v.type)' (Figma variables are COLOR, FLOAT, STRING, BOOLEAN)"; continue }
  if ($v.name -notmatch '^[a-z0-9]+([-/][a-z0-9]+)*$') { $sp += "$w has a name that is not lower-case kebab segments joined by '/'" }
  if (-not $collByName.ContainsKey($v.collection)) { $sp += "$w uses unknown collection '$($v.collection)'"; continue }
  $modes = @($collByName[$v.collection].modes); $have = @($v.values.PSObject.Properties.Name)
  if ((Compare-Object $modes $have)) { $sp += "$w has modes [$($have -join ', ')] but collection $($v.collection) has [$($modes -join ', ')]" }
  foreach ($s in $v.scopes) { if ($s -notin $typeScopes[$v.type]) { $sp += "$w has scope '$s' which does not apply to type $($v.type)" } }
  if ($v.layer -notin 'primitive', 'semantic', 'layout', 'component') { $sp += "$w has layer '$($v.layer)'" }
  if ($v.webRelation -notin 'shared', 'mapped', 'figma-only') { $sp += "$w has webRelation '$($v.webRelation)'" }
  if ($v.webRelation -ne 'figma-only' -and -not $v.webToken) { $sp += "$w has webRelation '$($v.webRelation)' but no webToken" }
  foreach ($m in $have) {
    $val = $v.values.$m; $isAlias = [bool](Get-AliasName ([string]$val))
    if ($isAlias) { continue }
    switch ($v.type) {
      'COLOR' { if ([string]$val -notmatch '^#[0-9A-F]{6}([0-9A-F]{2})?$') { $sp += "$w ($m) colour '$val' must be #RRGGBB or #RRGGBBAA (upper case) or an alias" } }
      'FLOAT' { if ($val -isnot [double] -and $val -isnot [int] -and $val -isnot [long] -and $val -isnot [decimal]) { $sp += "$w ($m) FLOAT value '$val' is not a plain number" } }
      'STRING' { if ($val -isnot [string]) { $sp += "$w ($m) STRING value is not text" } }
    }
  }
}
Rec '2' "Schema: $($spec.variables.Count) variables in $($spec.collections.Count) collections (fields, types, modes, value syntax, scopes, names)" $sp

# ---- 3. duplicates and conflicts ----
$dp = @(); $seen = @{}; $names = @($spec.variables | ForEach-Object { $_.name })
foreach ($v in $spec.variables) { $k = $v.name.ToLower(); if ($seen.ContainsKey($k)) { $dp += "Duplicate variable name '$($v.name)' ($($seen[$k]) and $($v.sourceFile)); names must be unique across collections here" } else { $seen[$k] = $v.sourceFile } }
foreach ($n in $names) { foreach ($o in $names) { if ($o -ne $n -and $o.StartsWith($n + '/')) { $dp += "Name conflict: '$n' is a variable and also a group prefix of '$o'" } } }
$dupFile = @($spec.textStyles | Group-Object name | Where-Object { $_.Count -gt 1 }); foreach ($g in $dupFile) { $dp += "Duplicate text style '$($g.Name)'" }
Rec '3' 'No duplicate or conflicting variable or style names' $dp

# ---- 4. aliases ----
$ap = @(); $aliasCount = 0
foreach ($v in $spec.variables) {
  foreach ($m in @($v.values.PSObject.Properties.Name)) {
    $a = Get-AliasName ([string]$v.values.$m); if (-not $a) { continue }; $aliasCount++
    $w = "$($v.sourceFile) variable '$($v.name)' ($m)"
    if (-not $spec.byName.ContainsKey($a)) { $ap += "$w points to {$a}, which does not exist"; continue }
    $t = $spec.byName[$a]
    if ($t.type -ne $v.type) { $ap += "$w is $($v.type) but {$a} is $($t.type)" }
    if ($v.collection -eq 'Primitives') { $ap += "$w : a primitive must not alias anything" }
    if ($v.collection -eq 'Semantic' -and $t.collection -notin 'Primitives', 'Semantic') { $ap += "$w : semantic variables may alias Primitives or Semantic only (found $($t.collection))" }
    if ($v.collection -in 'Layout', 'Typography' -and $t.collection -ne 'Primitives') { $ap += "$w : $($v.collection) variables may alias Primitives only" }
    if ($v.collection -eq 'Components' -and $t.collection -notin 'Primitives', 'Components') { $ap += "$w : component variables may alias Primitives or Components only" }
    try { $null = Resolve-Figma $spec $v $m } catch { $ap += "$w : $($_.Exception.Message)" }
  }
}
Rec '4' "Aliases: $aliasCount resolve, match types, respect layering and have no cycles" $ap

# ---- 5. unsupported mappings ----
$up = @()
foreach ($v in $spec.variables) { foreach ($m in @($v.values.PSObject.Properties.Name)) { $val = [string]$v.values.$m; if ($val -match 'clamp\(|calc\(|min\(|max\(|var\(|\d\s?(rem|em|vw|vh|px|%)\b') { $up += "$($v.sourceFile) variable '$($v.name)' ($m) holds a CSS expression or unit string '$val': a Figma value is a plain number, colour or text; convert it (px as a number) or document it as unmapped" } } }
$typesUsed = @($spec.variables | Group-Object type | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ', '
Rec '5' "No unsupported value forms (types used: $typesUsed)" $up

# ---- 6. typography units and hierarchy ----
$tp = @(); $ptFiles = 0; $ptHits = 0
foreach ($f in (Get-ChildItem $here, $fds -Recurse -File -Include *.json, *.js, *.html, *.css)) {
  $ptFiles++
  $lines = [IO.File]::ReadAllLines($f.FullName, [Text.Encoding]::UTF8)
  for ($i = 0; $i -lt $lines.Count; $i++) { foreach ($m in [regex]::Matches($lines[$i], '(?<![\w.#-])-?\d*\.?\d+\s?pt\b')) { $ptHits++; $tp += "$(Rel $f.FullName) line $($i + 1): '$($m.Value)' is a point unit. Font sizes are px" } }
}
$fsVars = @($spec.variables | Where-Object { $_.name -like 'font-size/*' })
foreach ($v in $fsVars) {
  if ($v.collection -ne 'Typography') { $tp += "typography.json variable '$($v.name)' must be in the Typography collection" }
  if ($v.type -ne 'FLOAT') { $tp += "typography.json variable '$($v.name)' must be FLOAT (px)" }
  foreach ($m in @($v.values.PSObject.Properties.Name)) { $val = $v.values.$m; if ($val -isnot [double] -and $val -isnot [int] -and $val -isnot [long] -and $val -isnot [decimal]) { $tp += "typography.json variable '$($v.name)' ($m) is '$val': a font size must be a plain px number, not an alias or a unit string" } elseif ($val -lt 12) { $tp += "typography.json variable '$($v.name)' ($m) is $val px, below 12" } }
  if ($v.scopes -notcontains 'FONT_SIZE') { $tp += "typography.json variable '$($v.name)' should have the FONT_SIZE scope" }
}
function Num($x) { $d = 0.0; if ([double]::TryParse([string]$x, [Globalization.NumberStyles]::Float, $script:inv, [ref]$d)) { $d } else { [double]::NaN } }
function Sz($n, $m) { Num ($spec.byName["font-size/$n"].values.$m) }
foreach ($m in 'Mobile', 'Tablet', 'Desktop') {
  $order = 'display', 'h1', 'h2', 'h3', 'h4', 'h5'
  for ($i = 1; $i -lt $order.Count; $i++) { if (-not ((Sz $order[$i - 1] $m) -gt (Sz $order[$i] $m))) { $tp += "Hierarchy broken in $m : font-size/$($order[$i - 1]) ($((Sz $order[$i - 1] $m))) is not larger than font-size/$($order[$i]) ($((Sz $order[$i] $m)))" } }
  if ((Sz 'body' $m) -lt 16) { $tp += "font-size/body is below 16px in $m" }
  if ((Sz 'input' $m) -lt 16) { $tp += "font-size/input is below 16px in $m (iOS zooms on focus)" }
  if (-not ((Sz 'h4' $m) -gt (Sz 'body-lg' $m) -and (Sz 'body-lg' $m) -gt (Sz 'h5' $m))) { $tp += "Hierarchy broken in $m : expected h4 > body-lg > h5" }
}
foreach ($v in $fsVars) { $a = Num $v.values.Mobile; $b = Num $v.values.Tablet; $c = Num $v.values.Desktop; if ($a -gt $b -or $b -gt $c) { $tp += "typography.json variable '$($v.name)' shrinks as the tier grows ($a, $b, $c)" } }
foreach ($ts in $spec.textStyles) { foreach ($k in 'fontFamily', 'fontWeight', 'fontSize') { $a = Get-AliasName ([string]$ts.$k); if (-not $a -or -not $spec.byName.ContainsKey($a)) { $tp += "typography.json text style '$($ts.name)' $k '$($ts.$k)' is not a valid variable alias" } } }
Rec '6' "Typography units: $($fsVars.Count) font sizes are px FLOAT in Typography; no pt in $ptFiles Figma-specific files ($ptHits matches); hierarchy holds in all 3 modes; sizes never shrink with the tier" $tp

# ---- 7. consistency with the web tokens ----
$webDir = Join-Path $proj '02-Design-Variables\Tokens'
$webList = Get-WebTokens $webDir; $webByCss = @{}; $webByPath = @{}; foreach ($w in $webList) { $webByCss[$w.css] = $w; $webByPath[$w.path] = $w }
$scope = Get-WebScope $webDir
$cp = @(); $exact = 0; $tol = 0; $notes = @(); $cmp = 0
$tierOf = @{ Mobile = 'mobile'; Tablet = 'tablet'; Desktop = 'desktop'; Value = 'mobile'; Default = 'mobile'; Inverse = 'mobile' }
foreach ($v in $spec.variables) {
  if ($v.webRelation -eq 'figma-only') { continue }
  if (-not $webByCss.ContainsKey($v.webToken)) { $cp += "$($v.sourceFile) variable '$($v.name)' names web token '$($v.webToken)', which does not exist in Design Variables"; continue }
  $wt = $webByCss[$v.webToken]
  foreach ($m in @($v.values.PSObject.Properties.Name)) {
    $cmp++
    try { $fv = Resolve-Figma $spec $v $m } catch { $cp += "$($v.sourceFile) variable '$($v.name)' ($m) cannot be resolved: $($_.Exception.Message)"; continue }
    $ov = if ($m -eq 'Inverse') { $scope } else { $null }
    $width = if ($script:RefWidths.ContainsKey($m)) { $script:RefWidths[$m] } else { 0 }
    $wv = Resolve-Web $webByPath $wt.path $tierOf[$m] $ov $width
    $w = "$($v.sourceFile) variable '$($v.name)' ($m) vs web $($v.webToken)"
    switch ($v.type) {
      'COLOR' { if ([string]$fv -eq [string]$wv) { $exact++ } else { $cp += "$w : Figma $fv, web $wv" } }
      'STRING' { $first = ([string]$wv -split ',')[0].Trim().Trim('"'); if ($first -eq [string]$fv) { $exact++ } else { $cp += "$w : Figma '$fv', web first family '$first'" } }
      'FLOAT' {
        if ($wv -isnot [double] -and $wv -isnot [int] -and $wv -isnot [long] -and $wv -isnot [decimal]) { $notes += "$($v.name) ($m): web value is '$wv' (not a number); Figma holds $fv. Documented as reference-only or mapped differently"; if ($v.webRelation -ne 'mapped') { $cp += "$w : web value '$wv' is not numeric but the relation is '$($v.webRelation)'" } }
        elseif ([math]::Abs([double]$fv - [double]$wv) -lt 0.0001) { $exact++ }
        elseif ($v.webRelation -eq 'mapped' -and [math]::Abs([double]$fv - [double]$wv) -le 0.5001) { $tol++ }
        else { $cp += "$w : Figma $fv, web $wv (difference $([math]::Round([math]::Abs([double]$fv - [double]$wv), 3)), allowed only up to 0.5 for 'mapped' sampled values)" }
      }
    }
  }
}
# text styles vs web composite roles
$styleCmp = 0
foreach ($ts in $spec.textStyles) {
  $role = $ts.webRole; $base = "type.$role"
  try { $fam = Resolve-Figma $spec $spec.byName[(Get-AliasName $ts.fontFamily)] 'Value' } catch { $cp += "typography.json text style '$($ts.name)' family alias cannot be resolved: $($_.Exception.Message)"; continue }
  $webFamPath = Get-AliasName ([string]$webByPath["$base.font-family"].raw); $webFam = ([string](Resolve-Web $webByPath $webFamPath 'mobile' $null 0) -split ',')[0].Trim().Trim('"')
  $wWeight = Resolve-Web $webByPath "$base.font-weight" 'mobile' $null 0
  $wLh = [double](Resolve-Web $webByPath "$base.line-height" 'mobile' $null 0) * 100
  $wLs = [double](([string](Resolve-Web $webByPath "$base.letter-spacing" 'mobile' $null 0)) -replace 'em', '') * 100
  $wCaseRaw = if ($webByPath.ContainsKey("$base.text-transform")) { [string]$webByPath["$base.text-transform"].raw } else { 'none' }
  $wCase = if ($wCaseRaw -eq 'uppercase') { 'UPPER' } else { 'ORIGINAL' }
  $w = "typography.json text style '$($ts.name)' (web role $role)"; $styleCmp++
  if ($fam -ne $webFam) { $cp += "$w : family '$fam' vs web '$webFam'" }
  if ([double](Resolve-Figma $spec $spec.byName[(Get-AliasName $ts.fontWeight)] 'Value') -ne [double]$wWeight) { $cp += "$w : weight differs from web ($wWeight)" }
  if ([math]::Abs([double]$ts.lineHeightPercent - $wLh) -gt 0.01) { $cp += "$w : line height $($ts.lineHeightPercent)% vs web $wLh%" }
  if ([math]::Abs([double]$ts.letterSpacingPercent - $wLs) -gt 0.01) { $cp += "$w : letter spacing $($ts.letterSpacingPercent)% vs web $wLs%" }
  if ($ts.textCase -ne $wCase) { $cp += "$w : case $($ts.textCase) vs web $wCase" }
  $sizeVar = (Get-AliasName $ts.fontSize) -replace '^font-size/', ''
  if ($sizeVar -ne $role) { $cp += "$w : binds font-size/$sizeVar but the web role size token is font-size-$role" }
}
$webRoles = @($webList | Where-Object { $_.path -match '^type\.[^.]+\.font-size$' } | ForEach-Object { ($_.path -split '\.')[1] })
$styleRoles = @($spec.textStyles | ForEach-Object { $_.webRole })
$missingRoles = @($webRoles | Where-Object { $_ -notin $styleRoles }); foreach ($r in $missingRoles) { $cp += "Web type role '$r' has no Figma text style" }
Rec '7' "Consistent with the web tokens: $cmp variable-mode values compared ($exact exact, $tol sampled within 0.5px, $($notes.Count) documented non-numeric), $styleCmp text styles compared across family, weight, line height, letter spacing and case" $cp ($notes -join "`n")

# ---- 8. coverage ----
$mr = [IO.File]::ReadAllText((Join-Path $here 'mapping-report.md'), [Text.Encoding]::UTF8)
$covP = @(); $rowsInReport = ([regex]::Matches($mr, '(?m)^\| `--[a-z0-9-]+` \|')).Count
if ($rowsInReport -ne $webList.Count) { $covP += "mapping-report.md classifies $rowsInReport tokens but the web system has $($webList.Count): run build-figma-variables.ps1" }
if ($mr -cmatch 'UNMAPPED \(unexpected\)') { $covP += 'mapping-report.md contains an UNMAPPED colour token: add it to the Figma source specifications' }
$mappedCss = @{}; foreach ($v in $spec.variables) { if ($v.webToken) { $mappedCss[$v.webToken] = 1 } }
foreach ($w in $webList) { if ($w.css -match '^--(palette|color)-' -and -not $mappedCss.ContainsKey($w.css)) { $covP += "Web colour token $($w.css) has no Figma variable" } }
Rec '8' "Coverage: all $($webList.Count) web tokens classified; every palette and colour token has a Figma variable" $covP

# ---- 9. components ----
$comp = Read-Json (Join-Path $fds 'components.json'); $cpr = @(); $vcounts = @()
$styleNames = @($spec.textStyles | ForEach-Object { $_.name })
$cnames = @{}
foreach ($c in $comp.components) {
  $w = "components.json component '$($c.name)'"
  if ($cnames.ContainsKey($c.name)) { $cpr += "$w is defined twice" }; $cnames[$c.name] = 1
  foreach ($f in 'id', 'name', 'webComponent', 'summary', 'properties', 'layout', 'bindings', 'responsive', 'accessibility', 'handoff') { if (-not ($c.PSObject.Properties.Name -contains $f)) { $cpr += "$w is missing '$f'" } }
  $pn = @{}; $vc = 1
  foreach ($p in $c.properties) {
    if ($p.type -notin 'VARIANT', 'BOOLEAN', 'TEXT', 'INSTANCE_SWAP') { $cpr += "$w property '$($p.name)' has unsupported type '$($p.type)'" }
    if ($pn.ContainsKey($p.name)) { $cpr += "$w property '$($p.name)' is duplicated" }; $pn[$p.name] = 1
    if ($p.type -eq 'VARIANT') { if (@($p.values).Count -lt 2) { $cpr += "$w variant property '$($p.name)' needs at least 2 values" }; if (@($p.values) -notcontains $p.default) { $cpr += "$w property '$($p.name)' default '$($p.default)' is not one of its values" }; $vc *= @($p.values).Count }
    if ($p.type -eq 'BOOLEAN' -and $p.default -notin 'true', 'false') { $cpr += "$w boolean '$($p.name)' default must be true or false" }
  }
  $vcounts += [pscustomobject]@{ name = $c.name; variants = $vc }
  if ($vc -gt 60) { $cpr += "$w has $vc variants: too many to maintain; split the component or turn an axis into a boolean" }
  foreach ($b in $c.bindings) { if (-not $spec.byName.ContainsKey($b.variable)) { $cpr += "$w binds '$($b.variable)' ($($b.element) $($b.property)), which is not a variable in Figma Variables" } }
  foreach ($s in @($c.stateStyles)) { if (-not $s) { continue }; foreach ($k in 'fill', 'stroke', 'strokeWidth', 'text') { if ($s.$k -and -not $spec.byName.ContainsKey([string]$s.$k)) { $cpr += "$w state style $($s.state) $k '$($s.$k)' is not a variable" } } }
  if ($c.PSObject.Properties.Name -contains 'textStyle') { foreach ($tn in ([regex]::Matches([string]$c.textStyle, '[A-Z][A-Za-z]+/[A-Za-z0-9 ]+?(?= \(|,|$)') | ForEach-Object { $_.Value.Trim() })) { if ($tn -notin $styleNames) { $cpr += "$w uses text style '$tn', which is not defined in typography.json" } } }
  foreach ($m in [regex]::Matches(($c | ConvertTo-Json -Depth 12), '\{([a-z0-9/-]+)\}')) { $n = $m.Groups[1].Value; if ($n -match '/' -and -not $spec.byName.ContainsKey($n)) { $cpr += "$w mentions {$n} in its layout notes, which is not a variable" } }
}
Rec '9' "Components: $($comp.components.Count) components, every named variable and text style exists; variant counts $((($vcounts | ForEach-Object { "$($_.name) $($_.variants)" }) -join ', '))" $cpr

# ---- 10. freshness ----
$fp = @(); $tmp = Join-Path ([IO.Path]::GetTempPath()) ("figma-validate-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force $tmp | Out-Null
New-Item -ItemType Directory -Force (Join-Path $tmp '02-Design-Variables') | Out-Null
New-Item -ItemType Directory -Force (Join-Path $tmp '01-Design-System') | Out-Null
Copy-Item $here (Join-Path $tmp '02-Design-Variables/Figma-Variables') -Recurse
New-Item -ItemType Directory -Force (Join-Path $tmp '02-Design-Variables') | Out-Null
Copy-Item $webDir (Join-Path $tmp '02-Design-Variables\Tokens') -Recurse
Copy-Item $fds (Join-Path $tmp '01-Design-System/Figma-Specification') -Recurse
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $tmp '02-Design-Variables\Figma-Variables\build-figma-variables.ps1') | Out-Null; $bx = $LASTEXITCODE
if ($bx -ne 0) { $fp += "build-figma-variables.ps1 exited $bx on a clean copy" }
$docBuild = Join-Path $fds 'build-figma-docs.ps1'
if (Test-Path $docBuild) { & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $tmp '01-Design-System\Figma-Specification\build-figma-docs.ps1') | Out-Null; if ($LASTEXITCODE -ne 0) { $fp += "build-figma-docs.ps1 exited $LASTEXITCODE on a clean copy" } }
$gen = @('02-Design-Variables/Figma-Variables/variable-map.json', '02-Design-Variables/Figma-Variables/collections.md', '02-Design-Variables/Figma-Variables/mapping-report.md', '02-Design-Variables/Figma-Variables/apply-variables.figma.js', '01-Design-System/Figma-Specification/components.md', '01-Design-System/Figma-Specification/component-properties.md', '01-Design-System/Figma-Specification/typography-styles.md', '01-Design-System/Figma-Specification/Preview/preview-data.js')
foreach ($g in $gen) { $a = Join-Path $proj $g; $b = Join-Path $tmp $g; if (-not (Test-Path $a)) { $fp += "$g is missing: run the build scripts"; continue }; if ((Get-FileHash $a).Hash -ne (Get-FileHash $b).Hash) { $fp += "$g is stale: it differs from a fresh build of the sources. Run build-figma-variables.ps1 and build-figma-docs.ps1" } }
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
Rec '10' "Generated files equal a fresh build ($($gen.Count) files)" $fp

# ---- 11. preview data ----
$pv = @(); $pd = Join-Path $fds 'Preview\preview-data.js'
if (Test-Path $pd) {
  $txt = [IO.File]::ReadAllText($pd, [Text.Encoding]::UTF8); $m = [regex]::Match($txt, '(?s)window\.FIGMA_SPEC\s*=\s*(\{.*\});?\s*$')
  if (-not $m.Success) { $pv += 'Preview/preview-data.js does not define window.FIGMA_SPEC' } else {
    $d = $m.Groups[1].Value | ConvertFrom-Json
    if ($d.meta.variableMapSha256 -ne (Get-FileHash (Join-Path $here 'variable-map.json')).Hash) { $pv += 'preview-data.js was built from a different variable-map.json: run build-figma-docs.ps1' }
    if ($d.meta.componentsSha256 -ne (Get-FileHash (Join-Path $fds 'components.json')).Hash) { $pv += 'preview-data.js was built from a different components.json: run build-figma-docs.ps1' }
    foreach ($kv in $d.meta.sourceHashes.PSObject.Properties) { $sfp = Join-Path $proj ($kv.Name -replace '/', '\'); if (-not (Test-Path $sfp)) { $pv += "preview-data.js lists $($kv.Name), which does not exist" } elseif ((Get-FileHash $sfp).Hash -ne $kv.Value) { $pv += "preview-data.js was built from an older $($kv.Name): run build-figma-variables.ps1 and build-figma-docs.ps1" } }
    if (@($d.webMapping).Count -ne $webList.Count) { $pv += "preview-data.js holds $(@($d.webMapping).Count) web mapping rows, the web system has $($webList.Count)" }
    if (@($d.components).Count -ne @($comp.components).Count) { $pv += "preview-data.js holds $(@($d.components).Count) components, components.json has $(@($comp.components).Count)" }
    if (@($d.variables).Count -ne $spec.variables.Count) { $pv += "preview-data.js holds $(@($d.variables).Count) variables, the specification has $($spec.variables.Count)" }
  }
  $palette = @($spec.variables | Where-Object { $_.type -eq 'COLOR' } | ForEach-Object { $_.values.PSObject.Properties | ForEach-Object { [string]$_.Value } } | Where-Object { $_ -match '^#' } | ForEach-Object { $_.ToUpper().Substring(0, 7) } | Sort-Object -Unique)
  foreach ($f in 'preview.js', 'renderers.js', 'preview.css', 'index.html', 'preview-data.js') { if ($f -eq 'preview-data.js') { continue }; $pf = Join-Path $fds "Preview\$f"; if (-not (Test-Path $pf)) { $pv += "Preview/$f is missing"; continue }; $ptxt = [IO.File]::ReadAllText($pf, [Text.Encoding]::UTF8).ToUpper(); foreach ($hx in $palette) { if ($ptxt.Contains($hx)) { $pv += "Preview/$f contains the palette value $hx. The preview must read colours from preview-data.js, not repeat them" } } }
}
Rec '11' 'Preview data matches the specification and the preview repeats no palette value' $pv
# ---- 12. separation ----
$sepP = @(); $base = Read-Json (Join-Path $here 'web-baseline.manifest.json'); $baseMap = @{}; foreach ($b in $base) { $baseMap[$b.path] = $b }
$nowFiles = Get-ChildItem (Join-Path $proj '01-Design-System'), (Join-Path $proj '02-Design-Variables'), (Join-Path $proj '05-Assets') -Recurse -File | Where-Object { $_.FullName -notmatch '\\Figma-(Specification|Variables)\\' }   # the web system = Design System, Design Variables and Assets, without the Figma specification folders
$changed = 0; $nowMap = @{}
foreach ($f in $nowFiles) { $rp = Rel $f.FullName; $nowMap[$rp] = 1; if (-not $baseMap.ContainsKey($rp)) { $sepP += "Web system has a file that is not in the baseline: $rp"; continue }; if ((Get-FileHash $f.FullName -Algorithm SHA256).Hash -ne $baseMap[$rp].sha256) { $changed++; $sepP += "Web system file changed since the baseline: $rp" } }
foreach ($k in $baseMap.Keys) { if (-not $nowMap.ContainsKey($k)) { $sepP += "Web system file missing since the baseline: $k" } }
foreach ($f in (Get-ChildItem $here, $fds -Recurse -File -Include *.ps1)) { $ls = [IO.File]::ReadAllLines($f.FullName); for ($i = 0; $i -lt $ls.Count; $i++) { if ($ls[$i] -match '(WriteAllText|WriteAllBytes|Set-Content|Out-File|Remove-Item|Copy-Item|Move-Item|Add-Content)' -and $ls[$i] -match '01-Design-System(?![/\\]Figma-Specification)|02-Design-Variables(?![/\\]Figma-Variables)|05-Assets' -and $ls[$i] -notmatch 'tmp|temp') { $sepP += "$(Rel $f.FullName) line $($i + 1) may write into a web folder: $($ls[$i].Trim())" } } }
Rec '12' "Separation: all $($baseMap.Count) web-system files are byte-identical to the baseline manifest (first taken before the Figma folders were created, re-recorded after the project reorganisation and the NUDGE rebrand); the Figma tools do not write into the web folders" $sepP

Rec 'E' 'No unexpected errors while validating (a malformed source file can cause these; fix them first)' $script:trapped
# ---- machine-readable results for the dashboard (computed from the SOURCE files, independent of the preview's own data) ----
$perColl = [ordered]@{}; foreach ($c0 in $spec.collections) { $perColl[$c0.name] = @($spec.variables | Where-Object { $_.collection -eq $c0.name }).Count }
$types0 = [ordered]@{}; foreach ($g0 in ($spec.variables | Group-Object type | Sort-Object Name)) { $types0[$g0.Name] = $g0.Count }
$srcH = [ordered]@{}
foreach ($sf in 'collections.source.json', 'primitives.json', 'spacing.json', 'typography.json', 'semantic.json', 'layout.json', 'component-variables.json') { $srcH["02-Design-Variables/Figma-Variables/$sf"] = (Get-FileHash (Join-Path $here $sf)).Hash }
$srcH['01-Design-System/Figma-Specification/components.json'] = (Get-FileHash (Join-Path $fds 'components.json')).Hash
$vdata = [ordered]@{
  meta = [ordered]@{ note = 'GENERATED by validate-figma-variables.ps1. DO NOT EDIT BY HAND. Results of validating the SPECIFICATION files in VS Code; nothing was validated inside Figma.'; variableMapSha256 = (Get-FileHash (Join-Path $here 'variable-map.json')).Hash; componentsSha256 = (Get-FileHash (Join-Path $fds 'components.json')).Hash; previewDataSha256 = $(if (Test-Path $pd) { (Get-FileHash $pd).Hash } else { '' }); sourceHashes = $srcH
    counts = [ordered]@{ collections = @($spec.collections).Count; variables = @($spec.variables).Count; variablesByCollection = $perColl; variablesByType = $types0; textStyles = @($spec.textStyles).Count; gridStyles = @($spec.gridStyles).Count; effectStyles = @($spec.effectStyles).Count; components = @($comp.components).Count; variants = (($vcounts | Measure-Object variants -Sum).Sum); variantsByComponent = @($vcounts | ForEach-Object { [ordered]@{ name = $_.name; variants = $_.variants } }); webTokens = @($webList).Count }
    groupsTotal = @($results).Count; groupsFailed = @($results | Where-Object { $_.problems.Count -gt 0 }).Count }
  groups = @($results | ForEach-Object { [ordered]@{ id = $_.id; name = $_.name; status = $(if ($_.problems.Count) { 'FAIL' } else { 'PASS' }); problems = @($_.problems | Select-Object -First 25); problemCount = $_.problems.Count; detail = $_.detail } })
}
[IO.File]::WriteAllText((Join-Path $fds 'Preview\validation-data.js'), ('window.FIGMA_VALIDATION = ' + ($vdata | ConvertTo-Json -Depth 12 -Compress) + ';' + "`n"), (New-Object Text.UTF8Encoding($false)))
# ---- report ----
$fail = @($results | Where-Object { $_.problems.Count -gt 0 }).Count
$sb = New-Object Text.StringBuilder
[void]$sb.Append("<!-- GENERATED by validate-figma-variables.ps1 (its only output). DO NOT EDIT BY HAND. -->`n# Validation report`n`n")
[void]$sb.Append("Result: **$(if ($fail) { "$fail of $($results.Count) groups FAILED" } else { "all $($results.Count) groups passed" })**. Run: ``powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Figma-Variables/validate-figma-variables.ps1``. This validates the **specification files** in VS Code; nothing was validated inside Figma because nothing was created in Figma.`n`n")
[void]$sb.Append("| # | Check | Result |`n|---|---|---|`n")
foreach ($r in $results) { [void]$sb.Append("| $($r.id) | $($r.name) | $(if ($r.problems.Count) { 'FAIL' } else { 'PASS' }) |`n") }
foreach ($r in $results) { if ($r.problems.Count) { [void]$sb.Append("`n### Check $($r.id) failures`n`n"); foreach ($p in ($r.problems | Select-Object -First 40)) { [void]$sb.Append("- $p`n") } } }
$nn = @($results | Where-Object { $_.id -eq '7' })[0].detail
if ($nn) { [void]$sb.Append("`n## Documented non-numeric web values (not failures)`n`n"); foreach ($l in ($nn -split "`n")) { [void]$sb.Append("- $l`n") } }
[IO.File]::WriteAllText((Join-Path $here 'validation-report.md'), $sb.ToString(), (New-Object Text.UTF8Encoding($false)))
foreach ($r in $results) { Write-Host ("{0,-3} {1,-4} {2}" -f $r.id, $(if ($r.problems.Count) { 'FAIL' } else { 'PASS' }), $r.name); if ($r.problems.Count) { $r.problems | Select-Object -First 8 | ForEach-Object { Write-Host "       - $_" } } }
if ($fail) { Write-Host "`nRESULT: $fail group(s) FAILED"; exit 1 }
Write-Host "`nRESULT: all passed"; exit 0
