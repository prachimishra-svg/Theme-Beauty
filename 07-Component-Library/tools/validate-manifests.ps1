# Validates every component manifest (*.json next to a component template) against the manifest spec and against its own template.
# Errors: bad JSON, missing id/name/level/page, unknown property type, VARIANT default not in values, a classes/tables entry missing for a value, BOOLEAN default not boolean,
#         LIST default not a list, INSTANCE_SWAP default not in options, a template token that is not a property, an include of a component that does not exist,
#         icon options out of step with the sprite. Warnings: a property never used by the template.
#         Scope: every property needs scope design | parent | merchant | wireframe; a merchant property needs shopify.setting; level main needs exposes.
#         Also: an exposes entry must name a real child property that is not design or wireframe; a LIST must carry every field its template reads.
# Usage: .\tools\validate-manifests.ps1
$L = Split-Path -Parent $PSScriptRoot; $P = Split-Path -Parent $L; $utf8 = New-Object Text.UTF8Encoding($false)
$root = Join-Path $P '03-Wireframes\00-Shared-Tailwind-Foundation\partials\components'
$errs = New-Object System.Collections.Generic.List[string]; $warns = New-Object System.Collections.Generic.List[string]
$types = 'VARIANT', 'BOOLEAN', 'TEXT', 'LIST', 'INSTANCE_SWAP'
$sprite = @([regex]::Matches([IO.File]::ReadAllText("$P\05-Assets\Icons\sprite.svg", $utf8), 'id="icon-([a-z-]+)"') | ForEach-Object { $_.Groups[1].Value })
$have = @{}; Get-ChildItem $root -Recurse -File -Filter *.html | ForEach-Object { $rel = $_.FullName.Substring($root.Length + 1) -replace '\\', '/' -replace '\.html$', ''; $p = $rel -split '/'; $n = if ($p.Count -ge 2 -and $p[-1] -eq $p[-2]) { $p[0..($p.Count - 2)] -join '/' } else { $rel }; $have["components/$n"] = 1 }
function Loop-Region([string]$h, [string]$list) {
  # the text of the loop over $list, without the bodies of loops nested inside it (those read a different item)
  $m = [regex]::Match($h, '\{\{each ' + [regex]::Escape($list) + '\}\}'); if (-not $m.Success) { return '' }
  $pos = $m.Index + $m.Length; $depth = 1; $out = ''; $last = $pos; $rx = [regex]'\{\{each [^}]+\}\}|\{\{/each\}\}'
  while ($depth -gt 0) { $n = $rx.Match($h, $pos); if (-not $n.Success) { break }
    if ($depth -eq 1) { $out += $h.Substring($last, $n.Index - $last) }
    if ($n.Value -eq '{{/each}}') { $depth-- } else { $depth++ }
    $pos = $n.Index + $n.Length; if ($depth -eq 1) { $last = $pos } }
  $out
}
$script:pendingReview = 0; $all = @{}
$n = 0
foreach ($mf in (Get-ChildItem $root -Recurse -File -Filter *.json)) {
  $n++; $tag = $mf.FullName.Substring($root.Length + 1) -replace '\\', '/'
  try { $m = [IO.File]::ReadAllText($mf.FullName, $utf8) | ConvertFrom-Json } catch { $errs.Add("$tag : invalid JSON"); continue }
  $htmlPath = [IO.Path]::ChangeExtension($mf.FullName, '.html'); if (-not (Test-Path $htmlPath)) { $errs.Add("$tag : no template next to the manifest"); continue }
  $html = [IO.File]::ReadAllText($htmlPath, $utf8)
  foreach ($k in 'id', 'name', 'level', 'page', 'properties') { if ($null -eq $m.$k) { $errs.Add("$tag : missing '$k'") } }
  if ($m.level -and $m.level -notin 'base', 'sub', 'main') { $errs.Add("$tag : level must be base, sub or main") }
  if ($m.page -and $m.page -notin 'shared', 'homepage', 'plp', 'pdp', 'cart') { $errs.Add("$tag : page must be shared, homepage, plp, pdp or cart") }
  if ($m.id -and $m.id -ne [IO.Path]::GetFileNameWithoutExtension($mf.Name)) { $errs.Add("$tag : id '$($m.id)' does not match the file name") }
  $names = @{}
  foreach ($p in @($m.properties)) {
    if (-not $p.name) { $errs.Add("$tag : a property has no name"); continue }; $names[$p.name] = $p
    if ($p.type -notin $types) { $errs.Add("$tag : property '$($p.name)' has unknown type '$($p.type)'"); continue }
    if ($p.scope -notin 'design', 'parent', 'merchant', 'wireframe') { $errs.Add("$tag : property '$($p.name)' has no valid scope (design, parent, merchant or wireframe)") }
    if ($p.scope -eq 'merchant' -and -not $p.shopify.setting) { $errs.Add("$tag : merchant property '$($p.name)' needs shopify.setting") }
    if ($p.scope -ne 'merchant' -and $p.shopify.setting -and $p.shopify.setting -notin 'select', 'checkbox') { $errs.Add("$tag : property '$($p.name)' is not merchant editable but declares a setting type") }
    if ($p.review) { $script:pendingReview++ }
    switch ($p.type) {
      'VARIANT' {
        if (-not $p.values) { $errs.Add("$tag : VARIANT '$($p.name)' has no values") } else {
          if ($p.default -notin @($p.values)) { $errs.Add("$tag : VARIANT '$($p.name)' default '$($p.default)' is not one of its values") }
          $tbls = New-Object System.Collections.Generic.List[object]
          if ($p.classes) { $tbls.Add(@{ n = 'classes'; t = $p.classes }) }
          if ($p.tables) { foreach ($tp in $p.tables.PSObject.Properties) { $tbls.Add(@{ n = $tp.Name; t = $tp.Value }) } }
          foreach ($tb in $tbls) { foreach ($v in @($p.values)) { if ($null -eq $tb.t.PSObject.Properties[[string]$v]) { $errs.Add("$tag : VARIANT '$($p.name)' table '$($tb.n)' has no entry for '$v'") } } }
        } }
      'BOOLEAN' { if ($p.default -isnot [bool]) { $errs.Add("$tag : BOOLEAN '$($p.name)' default must be true or false") } }
      'LIST' { if ($null -eq $p.default) { $errs.Add("$tag : LIST '$($p.name)' needs a default list") } }
      'INSTANCE_SWAP' { if (-not $p.options) { $errs.Add("$tag : INSTANCE_SWAP '$($p.name)' has no options") } elseif ($p.name -eq 'name' -or $p.name -eq 'icon') { $o = @($p.options | Where-Object { $_ }); $diff = @(Compare-Object $o $sprite | ForEach-Object { $_.InputObject }); if ($diff.Count) { $errs.Add("$tag : icon options out of step with the sprite: $($diff -join ', ')") } } }
    }
  }
  # template tokens must be properties (or loop variables)
  $loopVars = 'item', 'href', 'index', 'index0', 'first', 'last'
  $used = @{}
  foreach ($t in [regex]::Matches($html, '\{\{(?:if |each )?!?(?:slug:|lower:|arg:)?([\w.]+)(?:=[^}]*)?\}\}')) { $root1 = ($t.Groups[1].Value -split '\.')[0]; $used[$root1] = 1; if ($root1 -notin $loopVars -and -not $names.ContainsKey($root1)) { $errs.Add("$tag : the template uses '{{$($t.Groups[1].Value)}}' but there is no such property") } }
  foreach ($k in $names.Keys) { if (-not $used.ContainsKey($k)) { $warns.Add("$tag : property '$k' is not used by the template (it may be used by nested components)") } }
  foreach ($lp in @($m.properties | Where-Object { $_.type -eq 'LIST' -and $_.itemFields })) {
    $fieldNames = @($lp.itemFields | ForEach-Object { if ($_ -is [string]) { $_ } else { $_.name } })
    $need = @([regex]::Matches((Loop-Region $html $lp.name), 'item\.(\w+)') | ForEach-Object { $_.Groups[1].Value })
    foreach ($f in ($need | Select-Object -Unique)) { if ($f -notin $fieldNames) { $errs.Add("$tag : the template reads item.$f in the loop over '$($lp.name)' but itemFields does not list it") } }
    foreach ($it in @($lp.default)) { if ($it -is [string]) { continue }; foreach ($f in $fieldNames) { if ($null -eq $it.PSObject.Properties[$f]) { $errs.Add("$tag : LIST '$($lp.name)' has a default item without field '$f'") } } }
  }  foreach ($inc in [regex]::Matches($html, '@@PARTIAL (components/[a-z0-9/-]+)')) { if (-not $have.ContainsKey($inc.Groups[1].Value)) { $errs.Add("$tag : includes '$($inc.Groups[1].Value)' which does not exist") } }
}
foreach ($k in $all.Keys) { $m = $all[$k]
  if ($m.level -eq 'main') {
    if ($null -eq $m.exposes) { $errs.Add("$k : a main component needs an 'exposes' list (it may be empty)") }
    foreach ($e in @($m.exposes)) {
      if (-not $all.ContainsKey($e.child)) { $errs.Add("$k : exposes unknown child '$($e.child)'"); continue }
      $cp = @($all[$e.child].properties | Where-Object { $_.name -eq $e.property })
      if (-not $cp.Count) { $errs.Add("$k : exposes '$($e.child)'.'$($e.property)' which does not exist") }
      elseif ($cp[0].scope -eq 'design' -or $cp[0].scope -eq 'wireframe') { $errs.Add("$k : exposes '$($e.child)'.'$($e.property)' but its scope is $($cp[0].scope), which can never be a merchant setting") }
      if (-not $e.via) { $errs.Add("$k : exposes '$($e.property)' without 'via'") }
    }
  }
}$errs | ForEach-Object { "ERROR   $_" }; $warns | ForEach-Object { "warning $_" }
"manifests checked: $n; errors: $($errs.Count); warnings: $($warns.Count); properties pending review: $($script:pendingReview)"
