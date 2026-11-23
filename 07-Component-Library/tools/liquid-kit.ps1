# Library template  ->  Shopify Liquid.  Dot-source this file.
# Translates the component template language into Liquid, mechanically, so the result can be checked:
#   {{x}}  {{slug:x}}  {{lower:x}}  {{arg:x}}  {{x.class}}  {{x.table}}  {{if x}}  {{if x=v}}  {{each list}} ... {{/each}}  {{index}}  {{index0}}  {{if first}}  {{if last}}  @@PARTIAL ...@@
# Rules (see docs/SHOPIFY-COMPATIBILITY-PLAN.md):
#   * property names become snake_case parameters (the manifest's shopify.param when it is set); loop item fields become snake_case too
#   * values are written raw: the library treats text as already HTML-safe, so escaping happens where Shopify data enters (the section passes `| escape`)
#   * variant class tables become {% case %} blocks; defaults are applied at the top with `== nil` tests so that an explicit empty string still overrides a default
#   * BOOLEAN properties are real booleans in Liquid (the string '0' is truthy there); TEXT, VARIANT and LIST truthiness uses `!= blank`
#   * every nested component becomes {% render 'name', param: value %}; values built from several tokens go through {% capture %}
# Not supported yet (the transpiler stops with a clear message): string-pair lists using {{href}}.
$script:LK = @{}
function LK-Snake([string]$s) { ([regex]::Replace($s, '(?<=[a-z0-9])([A-Z])', '_$1')).ToLower() }
function LK-ParamOf($prop) { if ($prop.shopify -and $prop.shopify.param) { [string]$prop.shopify.param } else { LK-Snake ([string]$prop.name) } }
function LK-SnippetName([string]$comp) { $p = ($comp -replace '^components/', '') -split '/'; if ($p[0] -in 'base', 'common') { $p[-1] } else { ($p[0..($p.Count - 1)] -join '-') } }
function LK-Q([string]$s) { if ($s.Contains("'")) { '"' + $s + '"' } else { "'" + $s + "'" } }
function LK-Unesc([string]$s) { $s.Replace('&quot;', '"').Replace('&#64;', '@').Replace('&#124;', '|') }
function LK-Prop($man, [string]$name) { foreach ($p in @($man.properties)) { if ($p.name -eq $name) { return $p } }; $null }
function LK-Expr([string]$path, $man) {
  $parts = $path -split '\.'; $root = $parts[0]
  if ($root -ne 'item' -and (LK-Prop $man $root)) { $pp = LK-Prop $man $root; $e = LK-ParamOf $pp; if ($parts.Count -gt 1) { $e += '.' + (($parts[1..($parts.Count - 1)] | ForEach-Object { LK-Snake $_ }) -join '.') }; return $e }
  switch ($root) { 'item' { if ($parts.Count -eq 1) { return 'item' }; return 'item.' + (($parts[1..($parts.Count - 1)] | ForEach-Object { LK-Snake $_ }) -join '.') } 'index' { return 'forloop.index' } 'index0' { return 'forloop.index0' } 'first' { return 'forloop.first' } 'last' { return 'forloop.last' } 'href' { throw 'string-pair lists ({{href}}) are not supported by the transpiler yet' } }
  $p = LK-Prop $man $root; if (-not $p) { throw "token '$path' does not name a property of $($man.id)" }
  $e = LK-ParamOf $p; if ($parts.Count -gt 1) { $e += '.' + (($parts[1..($parts.Count - 1)] | ForEach-Object { LK-Snake $_ }) -join '.') }; $e
}
function LK-TableCase([string]$path, $man) {
  $m = [regex]::Match($path, '^(\w+)\.(\w+)$'); if (-not $m.Success) { return $null }
  $p = LK-Prop $man $m.Groups[1].Value; if (-not $p -or $p.type -ne 'VARIANT') { return $null }
  $tn = $m.Groups[2].Value; $tbl = if ($tn -eq 'class') { $p.classes } elseif ($p.tables) { $p.tables.$tn } else { $null }; if (-not $tbl) { return $null }
  $sb = New-Object Text.StringBuilder; [void]$sb.Append('{% case ' + (LK-ParamOf $p) + ' %}')
  foreach ($v in @($p.values)) { $pr = $tbl.PSObject.Properties[[string]$v]; [void]$sb.Append('{% when ' + (LK-Q ([string]$v)) + ' %}' + [string]$pr.Value) }
  [void]$sb.Append('{% endcase %}'); $sb.ToString()
}
function LK-Cond([string]$arg, $man) {
  $arg = $arg.Trim(); if ($arg.StartsWith('!')) { $inner = LK-Cond ($arg.Substring(1).Trim()) $man; if ($inner -match ' != blank$') { return ($inner -replace ' != blank$', ' == blank') }; if ($inner -match ' == (''[^'']*'')$') { return ($inner -replace ' == ', ' != ') }; return ('false == ' + $inner) }
  $m = [regex]::Match($arg, '^([\w.]+)=(.+)$')
  if ($m.Success) { return (LK-Expr $m.Groups[1].Value $man) + ' == ' + (LK-Q $m.Groups[2].Value.Trim()) }
  if ($arg -in 'first', 'last') { return 'forloop.' + $arg }
  $root = ($arg -split '\.')[0]; $p = LK-Prop $man $root
  if ($p -and $p.type -eq 'BOOLEAN' -and $arg -notmatch '\.') { return (LK-Expr $arg $man) }
  (LK-Expr $arg $man) + ' != blank'
}
function LK-Convert([string]$tpl, $man, $comps) {
  $rx = [regex]'\{\{(?<ctl>if|each) (?<arg>[^}]+)\}\}|\{\{/(?<end>if|each)\}\}|\{\{(?<mode>slug:|lower:|arg:)?(?<path>[\w.]+)\}\}|@@PARTIAL (?<pn>[a-z0-9/-]+)(?<pa>[^@]*)@@'
  $sb = New-Object Text.StringBuilder; $pos = 0; $cap = 0
  foreach ($m in $rx.Matches($tpl)) {
    [void]$sb.Append($tpl.Substring($pos, $m.Index - $pos)); $pos = $m.Index + $m.Length
    if ($m.Groups['ctl'].Success) {
      if ($m.Groups['ctl'].Value -eq 'if') { [void]$sb.Append('{% if ' + (LK-Cond $m.Groups['arg'].Value $man) + ' %}') } else { [void]$sb.Append('{% for item in ' + (LK-Expr $m.Groups['arg'].Value.Trim() $man) + ' %}') }
    } elseif ($m.Groups['end'].Success) { [void]$sb.Append($(if ($m.Groups['end'].Value -eq 'if') { '{% endif %}' } else { '{% endfor %}' }))
    } elseif ($m.Groups['path'].Success) {
      $path = $m.Groups['path'].Value; $mode = $m.Groups['mode'].Value; $case = LK-TableCase $path $man
      if ($case) { [void]$sb.Append($case) } else {
        $e = LK-Expr $path $man
        switch ($mode) { 'slug:' { [void]$sb.Append('{{ ' + $e + ' | handleize }}') } 'lower:' { [void]$sb.Append('{{ ' + $e + ' | downcase }}') } default { [void]$sb.Append('{{ ' + $e + ' }}') } }
      }
    } else {
      $cn = $m.Groups['pn'].Value; if ($cn -notlike 'components/*') { throw "built-in partial '$cn' is not a component (annbar, header and footer are components now)" }
      $child = $comps[$cn]; if (-not $child) { throw "unknown nested component $cn" }; $cm = $child.manifest
      $args = [regex]::Matches($m.Groups['pa'].Value, '(\w+)=("([^"]*)"|(\S+))'); $parts = @(); $pre = ''
      foreach ($a in $args) {
        $an = $a.Groups[1].Value; $av = if ($a.Groups[3].Success) { $a.Groups[3].Value } else { $a.Groups[4].Value }
        $cp = if ($cm) { LK-Prop $cm $an } else { $null }; $pn = if ($cp) { LK-ParamOf $cp } else { LK-Snake $an }
        $one = [regex]::Match($av, '^\{\{(?:arg:)?([\w.]+)\}\}$')
        if ($one.Success -and -not (LK-TableCase $one.Groups[1].Value $man)) { $val = LK-Expr $one.Groups[1].Value $man }
        elseif ($av -notmatch '\{\{') {
          $lit = LK-Unesc $av
          $val = if ($cp -and $cp.type -eq 'BOOLEAN') { $(if ($lit -in '1', 'true') { 'true' } else { 'false' }) } else { LK-Q $lit }
        } else { $cap++; $vn = "arg_$cap"; $inner = LK-Convert (LK-Unesc $av) $man $comps; $pre += '{% capture ' + $vn + ' %}' + $inner + '{% endcapture %}'; $val = $vn }
        $parts += "${pn}: $val"
      }
      [void]$sb.Append($pre + '{% render ' + (LK-Q (LK-SnippetName $cn)) + $(if ($parts.Count) { ', ' + ($parts -join ', ') } else { '' }) + ' %}')
    }
  }
  [void]$sb.Append($tpl.Substring($pos)); $sb.ToString()
}
function LK-Prelude($man) {
  $o = New-Object Text.StringBuilder
  foreach ($p in @($man.properties)) {
    $d = $p.default; $n = LK-ParamOf $p
    if ($p.scope -eq 'wireframe') { [void]$o.Append('{%- assign ' + $n + ' = ' + $(if ($p.type -eq 'BOOLEAN') { 'false' } else { "''" }) + ' -%}'); continue }
    if ($p.type -eq 'LIST') { continue }
    if ($p.type -eq 'BOOLEAN') { [void]$o.Append('{%- if ' + $n + ' == nil -%}{%- assign ' + $n + ' = ' + $(if ($d -eq $true) { 'true' } else { 'false' }) + ' -%}{%- endif -%}'); continue }
    if ($null -ne $d) { [void]$o.Append('{%- if ' + $n + ' == nil -%}{%- assign ' + $n + ' = ' + (LK-Q ([string]$d)) + ' -%}{%- endif -%}') }
  }
  $o.ToString()
}
function LK-Contract($comp) {
  # what a component promises: properties (names, types, defaults, values, tables, scopes, shopify bindings), children, exposes, and the whitespace-normalised template
  $man = $comp.manifest; $tpl = ([string]$comp.html) -replace '\s+', ' '
  $keep = @(); foreach ($p in @($man.properties)) { $keep += ('{0}|{1}|{2}|{3}|{4}|{5}|{6}|{7}|{8}' -f $p.name, $p.type, ($p.default | ConvertTo-Json -Compress -Depth 6), (@($p.values) -join ','), ($p.classes | ConvertTo-Json -Compress -Depth 6), ($p.tables | ConvertTo-Json -Compress -Depth 8), (@($p.options) -join ','), $p.scope, ($p.shopify | ConvertTo-Json -Compress -Depth 4)) }
  $ex = @(); foreach ($e in @($man.exposes)) { $ex += ('{0}.{1}>{2}' -f $e.child, $e.property, $e.via) }
  ($man.id, $man.level, ($keep -join ';'), (@($man.children) -join ','), ($ex -join ','), $tpl) -join "`n"
}
function LK-Hash([string]$s) { $sha = [Security.Cryptography.SHA256]::Create(); (($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($s)) | ForEach-Object { $_.ToString('x2') }) -join '').Substring(0, 16) }
function LK-Snippet([string]$compName, $comps) {
  $c = $comps[$compName]; $man = $c.manifest; if (-not $man) { throw "no manifest for $compName" }
  $tpl = ([string]$c.html).TrimEnd("`r", "`n"); $body = LK-Convert $tpl $man $comps
  $doc = New-Object Text.StringBuilder; [void]$doc.AppendLine('{%- comment -%}'); [void]$doc.AppendLine("  GENERATED from $compName by 07-Component-Library/tools/generate-liquid-staging.ps1 (contract $(LK-Hash (LK-Contract $c))).")
  [void]$doc.AppendLine('  Do not edit here: change the library component, then regenerate. Text values are written raw; escape where Shopify data enters (| escape in the section).'); [void]$doc.AppendLine('  Parameters (class: design = fixed, parent = passed in, merchant = set in a section, wireframe = not used):')
  foreach ($p in @($man.properties)) { if ($p.scope -eq 'wireframe') { continue }; [void]$doc.AppendLine('    ' + (LK-ParamOf $p) + ' (' + $p.type + ', ' + $p.scope + ')' + $(if ($p.type -eq 'LIST') { ' - required, pass an array' } else { '' })) }
  [void]$doc.AppendLine('{%- endcomment -%}'); $doc.ToString() + (LK-Prelude $man) + $body + "`n"
}
