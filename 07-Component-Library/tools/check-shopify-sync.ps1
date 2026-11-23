# Conversion check: is the Shopify (Liquid) side in step with the local component library?   Read-only with respect to 06-Shopify-Theme.
#
# Layer 0  integrity    the wireframe build must succeed (a failed build stops the check, it is never counted as a pass) and 06-Shopify-Theme must still match its fingerprint
# Layer 1  contract     hash of each component's contract (properties, scopes, variants, template) against shopify/sync-lock.json            -> STALE when the library changed after the last accepted sync
# Layer 2  output       the library component and the generated Liquid snippet are both rendered (library engine and LiquidJS) for every variant and compared  -> DIFFERS
# Layer 3  interface    the Liquid really reads the parameters the manifest declares, and sections declare the settings and block types the manifest names
# Layer 4  assets       Design Variables file, icon sprite, and the CSS classes the components use against the theme's CSS
# Statuses: IN SYNC | STALE | DIFFERS | DRIFT | EQUAL, LOCK PENDING | THEME DIFFERS | NOT IN SHOPIFY YET (+ PENDING DATA when it reads an unconfirmed metafield)
# Exit code 1 when the build fails, 06 changed, or any component is STALE, DIFFERS or DRIFT.
# Usage: .\tools\check-shopify-sync.ps1 [-Accept] [-SkipBuild] [-Strict]      -Accept records the lock for components whose outputs are equal
param([switch]$Accept, [switch]$SkipBuild, [switch]$Strict, [int]$Budget = 60000, [string]$BaselinePath = '', [string]$LockPath = '', [switch]$NoWrite)
$ErrorActionPreference = 'Stop'
$LIB = Split-Path -Parent $PSScriptRoot; $PRJ = Split-Path -Parent $LIB; $THEME = Join-Path $PRJ '06-Shopify-Theme'; $FOUND = Join-Path $PRJ '03-Wireframes\00-Shared-Tailwind-Foundation'
$utf8 = New-Object Text.UTF8Encoding($false); $problems = New-Object System.Collections.Generic.List[string]; $info = New-Object System.Collections.Generic.List[string]
. "$PSScriptRoot\liquid-kit.ps1"
Add-Type -AssemblyName System.Web.Extensions
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer; $ser.MaxJsonLength = [int]::MaxValue; $ser.RecursionLimit = 200
function Fail([string]$m) { $script:problems.Add($m) }

# ---------------- layer 0 ----------------
$buildOk = $null
if (-not $SkipBuild) {
  $prevEap = $ErrorActionPreference; $ErrorActionPreference = 'Continue'; $bo = & powershell -NoProfile -ExecutionPolicy Bypass -File "$FOUND\build.ps1" -All 2>&1; $buildCode = $LASTEXITCODE; $ErrorActionPreference = $prevEap
  if ($buildCode -ne 0) { Fail 'BUILD FAILED: the wireframe build did not succeed, so nothing below is trustworthy'; ($bo | Select-Object -First 4 | ForEach-Object { Fail ('  ' + $_.ToString()) }); $buildOk = $false } else { $buildOk = $true }
}
$bpath = if ($BaselinePath) { $BaselinePath } else { "$LIB\shopify\06-baseline.json" }; $base = ([IO.File]::ReadAllText($bpath, $utf8) | ConvertFrom-Json).files; $changed = @()
foreach ($pr in $base.PSObject.Properties) { $f = Join-Path $THEME $pr.Name; if (-not (Test-Path $f) -or (Get-FileHash $f -Algorithm SHA256).Hash -ne $pr.Value) { $changed += $pr.Name } }
$known = @{}; foreach ($pr in $base.PSObject.Properties) { $known[$pr.Name] = 1 }
$added = @(Get-ChildItem $THEME -Recurse -File | ForEach-Object { ($_.FullName.Substring($THEME.Length + 1) -replace '\\', '/') } | Where-Object { -not $known.ContainsKey($_) })
if ($changed.Count -or $added.Count) { Fail ("06-Shopify-Theme CHANGED: " + (($changed + $added) -join ', ')) }

# ---------------- library ----------------
& "$LIB\build-library.ps1" | Out-Null
$ld = [IO.File]::ReadAllText("$LIB\library.data.js", $utf8); $libData = $ser.DeserializeObject($ld.Substring($ld.IndexOf('window.NUDGE_LIB = ') + 19).TrimEnd().TrimEnd(';'))
$comps = @{}; foreach ($k in $libData.components.Keys) { $c = $libData.components[$k]; $comps[$k] = [pscustomobject]@{ html = $c.html; manifest = $(if ($c.manifest) { $ser.Serialize($c.manifest) | ConvertFrom-Json } else { $null }); group = $c.group } }
$names = @($comps.Keys | Sort-Object)

# ---------------- map ----------------
$themeSnip = @{}; Get-ChildItem "$THEME\snippets" -Filter *.liquid | ForEach-Object { $themeSnip[$_.BaseName] = $_.FullName }
$themeSec = @{}; Get-ChildItem "$THEME\sections" -Filter *.liquid | ForEach-Object { $themeSec[$_.BaseName] = $_.FullName }
$secMap = @{ 'hero-banner' = 'hero-banner'; 'usp-row' = 'usp-row'; 'category-section' = 'category-grid'; 'featured-collection' = 'featured-collection'; 'concern-section' = 'concern-routine'; 'finder-section' = 'guided-finder'; 'look-section' = 'shop-the-look'; 'ingredient-section' = 'ingredient-spotlight'; 'ritual-section' = 'ritual-steps'; 'video-section' = 'video-section'; 'compare-section' = 'before-after'; 'testimonials-section' = 'testimonials'; 'gallery-section' = 'customer-gallery'; 'logo-section' = 'logo-list'; 'promo-banner' = 'promo-banner'; 'custom-liquid-section' = 'custom-liquid'; 'newsletter-section' = 'newsletter'; 'site-header' = 'header'; 'announcement-bar' = 'announcement-bar'; 'site-footer' = 'footer' }
$snipExc = @{ 'components/base/button' = 'button-editorial'; 'components/base/chip' = 'chip-editorial'; 'components/homepage/product-card' = 'product-card-home'; 'components/header/search-button' = 'header-search'; 'components/header/account-button' = 'header-account'; 'components/header/market-selector' = 'header-localization' }
$stage = "$LIB\shopify\staging\snippets"
function Theme-Artifact([string]$n) {
  $leaf = ($n -split '/')[-1]; $g = ($n -replace '^components/', '' -split '/')[0]
  if ($secMap.ContainsKey($leaf) -and $themeSec.ContainsKey($secMap[$leaf])) { return @{ kind = 'section'; path = $themeSec[$secMap[$leaf]]; name = $secMap[$leaf] } }
  if ($snipExc.ContainsKey($n) -and $themeSnip.ContainsKey($snipExc[$n])) { return @{ kind = 'snippet'; path = $themeSnip[$snipExc[$n]]; name = $snipExc[$n] } }
  foreach ($c in @($leaf, "$g-$leaf")) { if ($themeSnip.ContainsKey($c)) { return @{ kind = 'snippet'; path = $themeSnip[$c]; name = $c } } }
  $null
}
$lockPath = if ($LockPath) { $LockPath } else { "$LIB\shopify\sync-lock.json" }; $lock = @{}; if (Test-Path $lockPath) { $lj = [IO.File]::ReadAllText($lockPath, $utf8) | ConvertFrom-Json; foreach ($pr in $lj.components.PSObject.Properties) { $lock[$pr.Name] = $pr.Value } }

# ---------------- layer 2: render both sides ----------------
$staged = @($names | Where-Object { Test-Path (Join-Path $stage ((LK-SnippetName $_) + '.liquid')) })
$cases = @()
foreach ($n in $staged) {
  $man = $comps[$n].manifest; if (-not $man) { continue }
  $props = @($man.properties); $listDefaults = @{}; foreach ($p in $props) { if ($p.type -eq 'LIST') { $listDefaults[$p.name] = $p.default } }
  function Mk([string]$id, $override) {
    $lib2 = @{}; $liq = @{}
    foreach ($ov in $override.Keys) { $p = ($props | Where-Object { $_.name -eq $ov })[0]; $v = $override[$ov]
      if ($p.type -eq 'BOOLEAN') { $lib2[$ov] = $(if ($v) { '1' } else { '0' }); $liq[(LK-ParamOf $p)] = [bool]$v } else { $lib2[$ov] = $v; $liq[(LK-ParamOf $p)] = $v } }
    foreach ($wp in $props) { if ($wp.scope -eq 'wireframe' -and $wp.type -in 'TEXT', 'BOOLEAN') { $lib2[$wp.name] = $(if ($wp.type -eq 'BOOLEAN') { '0' } else { '' }) } }   # wireframe-only properties never reach Shopify, so both sides are compared without them
    foreach ($ln in $listDefaults.Keys) { if (-not $lib2.ContainsKey($ln)) { $p = ($props | Where-Object { $_.name -eq $ln })[0]; $lib2[$ln] = $listDefaults[$ln]; $liq[(LK-ParamOf $p)] = @($listDefaults[$ln] | ForEach-Object { $o = [ordered]@{}; foreach ($q in $_.PSObject.Properties) { $o[(LK-Snake $q.Name)] = $q.Value }; $o }) } }
    @{ id = "$n :: $id"; comp = $n; snippet = (LK-SnippetName $n); lib = $lib2; liquid = $liq }
  }
  $cases += Mk 'defaults' @{}
  foreach ($p in $props) {
    if ($p.type -eq 'VARIANT' -and $p.scope -ne 'wireframe') { foreach ($v in @($p.values)) { if ($v -ne $p.default) { $cases += Mk "$($p.name)=$v" @{ $p.name = [string]$v } } } }
    if ($p.type -eq 'BOOLEAN') { $cases += Mk "$($p.name) toggled" @{ $p.name = (-not [bool]$p.default) } }
    if ($p.type -eq 'INSTANCE_SWAP') { foreach ($o in @($p.options | Where-Object { $_ } | Select-Object -First 3)) { $cases += Mk "$($p.name)=$o" @{ $p.name = [string]$o } } }
  }
  $txt = @{}; foreach ($p in $props) { if ($p.type -eq 'TEXT' -and $p.scope -ne 'wireframe') { $txt[$p.name] = 'Sample &amp; text "quoted"' } }; if ($txt.Count) { $cases += Mk 'all text set' $txt }
}
$snippets = @{}; foreach ($f in Get-ChildItem $stage -Filter *.liquid) { $snippets["snippets/$($f.Name)"] = [IO.File]::ReadAllText($f.FullName, $utf8) }
$l2 = @{}
if ($cases.Count) {
  $vend = 'file:///' + (($THEME -replace '\\', '/') -replace ' ', '%20') + '/tools/vendor/liquid.browser.min.js'; $libu = 'file:///' + (($LIB -replace '\\', '/') -replace ' ', '%20')
  $bundle = (@{ cases = $cases; snippets = $snippets } | ConvertTo-Json -Depth 12 -Compress).Replace('</', '<\/').Replace([string][char]0x2028, '\u2028').Replace([string][char]0x2029, '\u2029')
  $harness = @"
<!doctype html><html><head><meta charset="utf-8"></head><body><textarea id="out">pending</textarea>
<script src="$vend"></script><script src="$libu/library.data.js"></script><script src="$libu/engine.js"></script>
<script>
var B=$bundle,F=B.snippets;
var fs={sep:'/',resolve:function(r,f,e){return r.replace(/\/$/,'')+'/'+f+(/\.[a-z]+$/.test(f)?'':e)},exists:function(p){return Promise.resolve(p in F)},existsSync:function(p){return p in F},readFile:function(p){return p in F?Promise.resolve(F[p]):Promise.reject(new Error('ENOENT '+p))},readFileSync:function(p){if(p in F)return F[p];throw new Error('ENOENT '+p)},contains:function(){return true},dirname:function(p){return p.replace(/\/[^\/]*$/,'')},fallback:function(){return undefined}};
var liq=new window.liquidjs.Liquid({fs:fs,root:[''],partials:['snippets'],extname:'.liquid',strictFilters:false,strictVariables:false,jsTruthy:false,ownPropertyOnly:false,greedy:true});
var eng=new NudgeEngine(window.NUDGE_LIB.components,window.NUDGE_LIB),res=[];
(async function(){for(var i=0;i<B.cases.length;i++){var c=B.cases[i],r={id:c.id};
 try{r.lib=eng.render(c.comp,c.lib)}catch(e){r.libErr=String(e.message)}
 try{var keys=Object.keys(c.liquid);var t="{% render '"+c.snippet+"'"+keys.map(function(k){return ', '+k+': '+k}).join('')+" %}";r.liq=await liq.parseAndRender(t,c.liquid)}catch(e){r.liqErr=String(e.message)}
 res.push(r)}
 document.getElementById('out').textContent=JSON.stringify(res)})();
</script></body></html>
"@
  $tmp = Join-Path ([IO.Path]::GetTempPath()) 'nudge-sync'; New-Item -ItemType Directory -Force $tmp | Out-Null
  $pg = Join-Path $tmp 'sync.html'; [IO.File]::WriteAllText($pg, $harness, $utf8); $dump = Join-Path $tmp 'sync-dump.html'
  Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', "--virtual-time-budget=$Budget", '--dump-dom', "`"file:///$(($pg -replace '\\','/') -replace ' ','%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
  $raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump, $utf8), '<textarea id="out">([\s\S]*?)</textarea>').Groups[1].Value)
  if ($raw -eq 'pending' -or -not $raw) { Fail 'LAYER 2 DID NOT RUN: the browser produced no result (this is a failure, not a pass)' } else {
    function Norm([string]$t) { $t = $t -replace '\s+', ' '; $t = $t -replace '> <', '><'; $t = $t -replace ' "', '"'; $t = $t -replace '" >', '">'; $t = $t -replace ' >', '>'; $t = [regex]::Replace($t, ' class="([^"]*)"', { param($m) ' class="' + ((($m.Groups[1].Value -split '\s+') | Where-Object { $_ } | Sort-Object) -join ' ') + '"' }); $t.Trim() }
    foreach ($r in @($ser.DeserializeObject($raw))) { $cn = ($r['id'] -split ' :: ')[0]; if (-not $l2.ContainsKey($cn)) { $l2[$cn] = @{ total = 0; bad = New-Object System.Collections.Generic.List[string] } }; $l2[$cn].total++
      if ($r.ContainsKey('libErr')) { $l2[$cn].bad.Add("$($r['id']): library error $($r['libErr'])") } elseif ($r.ContainsKey('liqErr')) { $l2[$cn].bad.Add("$($r['id']): Liquid error $($r['liqErr'])") } else {
        $a = Norm ([string]$r['lib']); $b = Norm ([string]$r['liq']); if ($a -ne $b) { $n = 0; while ($n -lt $a.Length -and $n -lt $b.Length -and $a[$n] -eq $b[$n]) { $n++ }; $s = [Math]::Max(0, $n - 40); $l2[$cn].bad.Add("$($r['id']): differs at $n  library ...$($a.Substring($s, [Math]::Min(90, $a.Length - $s)))  liquid ...$($b.Substring($s, [Math]::Min(90, $b.Length - $s)))") } } }
  }
}

# ---------------- layer 3: interface ----------------
$syntax = @('if', 'elsif', 'else', 'endif', 'unless', 'endunless', 'case', 'when', 'endcase', 'for', 'in', 'endfor', 'assign', 'capture', 'endcapture', 'render', 'include', 'comment', 'endcomment', 'liquid', 'true', 'false', 'nil', 'blank', 'empty', 'forloop', 'and', 'or', 'contains', 'limit', 'offset', 'with', 'as', 'schema', 'endschema', 'break', 'continue', 'echo', 'raw', 'endraw', 'doc', 'enddoc', 'param', 'stylesheet', 'javascript', 'style', 'endstyle', 'form', 'endform', 'layout', 'content_for', 'default', 'item')
$shopifyObjects = @('section', 'block', 'blocks', 'settings', 'product', 'collection', 'shop', 'request', 'routes', 'cart', 'customer', 'localization', 'images', 'linklists', 'all_products', 'pages', 'blogs', 'articles', 'template', 'scope', 'section_id', 'sections', 'current', 'links', 'handle', 'url', 'index', 'first', 'last', 'size')
function Liquid-Reads([string]$src) {
  $s = [regex]::Replace($src, '(?s)\{%-?\s*(comment|doc|schema|raw)\s*-?%\}.*?\{%-?\s*end\1\s*-?%\}', '')
  $s = [regex]::Replace($s, '\{%-\s*if\s+\w+\s*==\s*nil\s*-%\}\{%-\s*assign\s+\w+\s*=\s*[^%]*-%\}\{%-\s*endif\s*-%\}', '')   # the generated default prelude is not a read
  $s = [regex]::Replace($s, '\{%-\s*assign\s+\w+\s*=\s*(''''|false)\s*-%\}', '')                                                  # nor is a forced-empty wireframe property
  $reads = @{}; $assigned = @{}
  foreach ($t in [regex]::Matches($s, '(?s)\{\{-?(.*?)-?\}\}|\{%-?(.*?)-?%\}')) {
    $b = if ($t.Groups[1].Success) { $t.Groups[1].Value } else { $t.Groups[2].Value }
    foreach ($a in [regex]::Matches($b, '(?:assign|capture)\s+([a-z_][a-z0-9_]*)')) { $assigned[$a.Groups[1].Value] = 1 }
    foreach ($a in [regex]::Matches($b, 'for\s+([a-z_][a-z0-9_]*)\s+in')) { $assigned[$a.Groups[1].Value] = 1 }
    $b = [regex]::Replace($b, "'[^']*'|`"[^`"]*`"", ''); $b = [regex]::Replace($b, '\|\s*[a-z_]+(\s*:[^|]*)?', ''); if ($b -match '^\s*render\b') { $b = [regex]::Replace($b, '[a-z_][a-z0-9_]*\s*:', '') }
    foreach ($id in [regex]::Matches($b, '(?<![\.\w])([a-z_][a-z0-9_]*)')) { $reads[$id.Groups[1].Value] = 1 }
  }
  foreach ($k in @($reads.Keys)) { if ($syntax -contains $k -or $assigned.ContainsKey($k)) { $reads.Remove($k) } }
  @($reads.Keys | Sort-Object)
}
function Expected-Params($man) { @(@($man.properties) | Where-Object { $_.scope -in 'parent', 'merchant', 'design' -and $_.scope -ne 'wireframe' } | Where-Object { $_.scope -ne 'design' } | ForEach-Object { LK-ParamOf $_ }) }
$l3 = @{}
foreach ($n in $names) {
  $man = $comps[$n].manifest; if (-not $man) { continue }; $sn = Join-Path $stage ((LK-SnippetName $n) + '.liquid'); $ta = Theme-Artifact $n; $notes = @()
  if (Test-Path $sn) { $reads = Liquid-Reads ([IO.File]::ReadAllText($sn, $utf8)); $exp = @(Expected-Params $man); $listOnly = @(@($man.properties) | Where-Object { $_.scope -eq 'design' } | ForEach-Object { LK-ParamOf $_ })
    $missing = @($exp | Where-Object { $reads -notcontains $_ }); $wfp = @(@($man.properties) | Where-Object { $_.scope -eq 'wireframe' } | ForEach-Object { LK-ParamOf $_ }); $extra = @($reads | Where-Object { $exp -notcontains $_ -and $listOnly -notcontains $_ -and $wfp -notcontains $_ -and $shopifyObjects -notcontains $_ })
    if ($missing.Count) { $notes += "staging snippet does not read: $($missing -join ', ')" }; if ($extra.Count) { $notes += "staging snippet reads unknown: $($extra -join ', ')" }
    $dz = @(@($man.properties) | Where-Object { $_.scope -eq 'design' } | ForEach-Object { LK-ParamOf $_ } | Where-Object { $reads -contains $_ }); if ($dz.Count) { $notes += "design-fixed property read as a parameter: $($dz -join ', ')" } }
  elseif ($ta) {
    $src = [IO.File]::ReadAllText($ta.path, $utf8)
    if ($ta.kind -eq 'section') {
      $m = [regex]::Match($src, '(?s)\{%-?\s*schema\s*-?%\}(.*?)\{%-?\s*endschema\s*-?%\}'); if ($m.Success) { try { $sc = $m.Groups[1].Value | ConvertFrom-Json } catch { $sc = $null; $notes += 'section schema is not valid JSON' } } else { $sc = $null; $notes += 'section has no schema' }
      if ($sc) { $ids = @($sc.settings | ForEach-Object { $_.id }); $bt = @($sc.blocks | ForEach-Object { $_.type }); $bids = @($sc.blocks | ForEach-Object { $_.settings } | ForEach-Object { $_.id })
        foreach ($p in @($man.properties | Where-Object { $_.scope -eq 'merchant' })) { $want = if ($p.shopify.id) { [string]$p.shopify.id } else { [string]$p.shopify.param }
          if ($p.type -eq 'LIST') { if ($p.shopify.blockType -and ($bt -notcontains $p.shopify.blockType)) { $notes += "section has no block type '$($p.shopify.blockType)' for $($p.name)" } }
          elseif (($ids -notcontains $want) -and ($bids -notcontains $want)) { $notes += "section schema has no setting '$want' for $($p.name)" } }
        foreach ($so in @($man.shopifyOnly)) { if ($so.id -and ($ids -notcontains $so.id) -and ($bids -notcontains $so.id)) { $notes += "Shopify-only setting '$($so.id)' is not in the section schema" } } }
    } else { $reads = Liquid-Reads $src; $exp = @(Expected-Params $man); $missing = @($exp | Where-Object { $reads -notcontains $_ }); if ($missing.Count) { $notes += "existing snippet '$($ta.name)' does not read: $($missing -join ', ')" } }
  }
  $l3[$n] = $notes
}

# ---------------- layer 4: shared assets ----------------
$assetNotes = @()
$va = [IO.File]::ReadAllLines("$PRJ\02-Design-Variables\Styles\variables.css", $utf8); $vb = [IO.File]::ReadAllLines("$THEME\assets\variables.css", $utf8) | Where-Object { $_ -notmatch '^/\* GENERATED by 06-Shopify-Theme' }
if ((@(Compare-Object $va $vb)).Count) { $assetNotes += 'FAIL Design Variables: the theme copy of variables.css differs from 02-Design-Variables (beyond its generated header line)' } else { $info.Add('Design Variables: theme copy identical (apart from its generated header line)') }
$spriteLib = @([regex]::Matches([IO.File]::ReadAllText("$PRJ\05-Assets\Icons\sprite.svg", $utf8), 'id="icon-([a-z-]+)"') | ForEach-Object { $_.Groups[1].Value }); $spriteTheme = @([regex]::Matches([IO.File]::ReadAllText("$THEME\snippets\icon-sprite.liquid", $utf8), 'id="icon-([a-z-]+)"') | ForEach-Object { $_.Groups[1].Value })
$sprMissing = @($spriteLib | Where-Object { $spriteTheme -notcontains $_ }); if ($sprMissing.Count) { $assetNotes += "Icon sprite: the theme has $($spriteTheme.Count) icons, the library $($spriteLib.Count); missing in the theme: $($sprMissing -join ', ') (added at the first sync, with approval)" } else { $info.Add("Icon sprite: theme and library both have $($spriteLib.Count) icons") }
$css = ''; foreach ($cf in 'theme-shopify.css', 'theme.css') { $pp = "$THEME\assets\$cf"; if (Test-Path $pp) { $css += [IO.File]::ReadAllText($pp, $utf8) } }
$clsLib = @{}; foreach ($n in $names) { $man = $comps[$n].manifest; $txt = [string]$comps[$n].html
  foreach ($m in [regex]::Matches($txt, 'class="([^"{]*)"')) { foreach ($t in ($m.Groups[1].Value -split '\s+')) { if ($t) { $clsLib[$t] = 1 } } }
  foreach ($p in @($man.properties)) { foreach ($tb in @($p.classes) + @($p.tables.PSObject.Properties | ForEach-Object { $_.Value })) { if ($tb) { foreach ($v in $tb.PSObject.Properties) { foreach ($t in ([string]$v.Value -split '\s+')) { if ($t) { $clsLib[$t] = 1 } } } } } } }
$clsMissing = @($clsLib.Keys | Where-Object { $e = [regex]::Replace($_, '([^a-zA-Z0-9_-])', '\$1'); -not $css.Contains('.' + $e) } | Sort-Object)
if ($clsMissing.Count) { $assetNotes += "CSS coverage: $($clsMissing.Count) of $($clsLib.Count) classes used by components are not in the theme's extracted CSS (informational: the theme's interim CSS is extracted from the Homepage only and is regenerated by the Tailwind build; first: $(($clsMissing | Select-Object -First 8) -join ' '))" } else { $info.Add("CSS coverage: all $($clsLib.Count) classes are in the theme CSS") }

# ---------------- status per component ----------------
function Pending([string]$n, $seen) { if ($seen -contains $n -or -not $comps[$n].manifest) { return $false }; foreach ($p in @($comps[$n].manifest.properties)) { if ($p.pending) { return $true } }; foreach ($c in @($comps[$n].manifest.children)) { if ($c -and $comps.ContainsKey($c) -and (Pending $c ($seen + $n))) { return $true } }; $false }
$status = [ordered]@{}; $newLock = @{}; foreach ($k in $lock.Keys) { $newLock[$k] = $lock[$k] }
foreach ($n in $names) {
  $man = $comps[$n].manifest; $notes = @(); $st = ''; $ta = Theme-Artifact $n; $sn = Join-Path $stage ((LK-SnippetName $n) + '.liquid'); $src = ''
  if (-not $man) { $status[$n] = @{ status = 'NOT MAPPED'; notes = @('no manifest'); source = ''; theme = '' }; continue }
  $contract = LK-Hash (LK-Contract $comps[$n]); $lk = $lock[$n]
  if (Test-Path $sn) {
    $src = 'staging'; $liqHash = LK-Hash ([IO.File]::ReadAllText($sn, $utf8)); $r2 = $l2[$n]
    $clean = ($r2 -and -not $r2.bad.Count -and -not $l3[$n].Count)
    if (-not $r2) { $st = 'DIFFERS'; $notes += 'layer 2 produced no result for this component' } elseif ($r2.bad.Count) { $st = 'DIFFERS'; $notes += "$($r2.bad.Count) of $($r2.total) renders differ: " + (($r2.bad | Select-Object -First 2 | ForEach-Object { $_ }) -join ' | ') }
    elseif ($l3[$n].Count) { $st = 'DIFFERS'; $notes += $l3[$n] }
    elseif ($Accept) { $newLock[$n] = [pscustomobject]@{ contract = $contract; liquid = $liqHash; accepted = (Get-Date -Format 'yyyy-MM-dd HH:mm'); renders = $r2.total }; $st = 'IN SYNC'; $notes += "$($r2.total) renders equal; lock recorded" }
    elseif ($lk -and $lk.contract -ne $contract) { $st = 'STALE'; $notes += 'the library component changed after the last accepted sync; regenerate the snippet and accept' }
    elseif ($lk -and $lk.liquid -ne $liqHash) { $st = 'DRIFT'; $notes += 'the Liquid file changed without a library change' }
    elseif ($lk) { $st = 'IN SYNC'; $notes += "$($r2.total) renders equal" }
    else { $st = 'EQUAL, LOCK PENDING'; $notes += "$($r2.total) renders equal; run with -Accept to record the sync" }    if ($ta) { $notes += "an existing theme artifact '$($ta.name)' would be replaced when this is promoted" }
  } elseif ($ta) { $src = 'theme'; $st = if ($l3[$n].Count) { 'THEME DIFFERS' } else { 'THEME DIFFERS' }; $notes += $l3[$n]; if (-not $l3[$n].Count) { $notes += 'existing theme artifact found; no generated Liquid to compare yet' }
    if ($lk -and $lk.contract -ne $contract) { $st = 'STALE'; $notes += 'the library component changed after the last accepted sync' } }
  else { $st = 'NOT IN SHOPIFY YET'; $notes += 'no Liquid snippet or section for this component yet' }
  if (Pending $n @()) { $notes += 'PENDING DATA: reads a metafield awaiting merchant confirmation' }
  $status[$n] = @{ status = $st; notes = $notes; source = $src; theme = $(if ($ta) { $ta.name } else { '' }); contract = $contract; pending = (Pending $n @()) }
}
if ($Accept) { $o = [ordered]@{ note = 'Last accepted sync per component: contract hash of the library component and hash of its Liquid. Written by check-shopify-sync.ps1 -Accept.'; components = [ordered]@{} }; foreach ($k in ($newLock.Keys | Sort-Object)) { $o.components[$k] = $newLock[$k] }; [IO.File]::WriteAllText($lockPath, ($o | ConvertTo-Json -Depth 6), $utf8) }
foreach ($n in $names) { $s = $status[$n].status; if ($s -in 'STALE', 'DIFFERS', 'DRIFT') { Fail "$s : $n : $(($status[$n].notes | Select-Object -First 1))" } elseif ($Strict -and $s -in 'THEME DIFFERS', 'NOT IN SHOPIFY YET', 'EQUAL, LOCK PENDING') { Fail "$s (strict): $n" } }
foreach ($a in $assetNotes) { if ($a -like 'FAIL*') { Fail $a } }

# ---------------- report ----------------
$counts = @{}; foreach ($n in $names) { $s = $status[$n].status; $counts[$s] = 1 + [int]$counts[$s] }
$sb = New-Object Text.StringBuilder; function W([string]$s = '') { [void]$sb.AppendLine($s) }
W '# Shopify Sync Report'; W; W "Generated $(Get-Date -Format 'yyyy-MM-dd HH:mm') by tools/check-shopify-sync.ps1. Read-only with respect to 06-Shopify-Theme."; W
W '## Result'; W; W ('- ' + $(if ($problems.Count) { "**FAILED** with $($problems.Count) problem(s)" } else { '**No blocking problems**' })); foreach ($pm in $problems) { W "  - $pm" }
W ('- Build: ' + $(if ($SkipBuild) { 'skipped (-SkipBuild)' } elseif ($buildOk) { 'wireframe build succeeded' } else { '**FAILED**' })); W ('- 06-Shopify-Theme: ' + $(if ($changed.Count -or $added.Count) { '**CHANGED**' } else { "unchanged ($(@($base.PSObject.Properties).Count) files match the fingerprint)" }))
W ('- Status counts: ' + ((($counts.Keys | Sort-Object) | ForEach-Object { "$_ $($counts[$_])" }) -join '; ')); W
W '## Shared assets (layer 4)'; W; foreach ($i in $info) { W "- $i" }; foreach ($a in $assetNotes) { W "- $a" }; W
W '## Components'; W; W '| Component | Level | Status | Source | Existing theme artifact | Notes |'; W '|---|---|---|---|---|---|'
foreach ($n in $names) { $sx = $status[$n]; W ('| {0} | {1} | {2} | {3} | {4} | {5} |' -f ($n -replace '^components/', ''), $(if ($comps[$n].manifest) { $comps[$n].manifest.level } else { '' }), $sx.status, $sx.source, $sx.theme, ((($sx.notes | Select-Object -First 3) -join ' / ') -replace '\|', '/' -replace '[\r\n]+', ' ')) }
if (-not $NoWrite) { [IO.File]::WriteAllText("$LIB\docs\SHOPIFY-SYNC-REPORT.md", $sb.ToString(), $utf8) }
$sj = @{}; foreach ($n in $names) { $sj[$n] = @{ status = $status[$n].status; source = $status[$n].source; theme = $status[$n].theme; pending = [bool]$status[$n].pending; note = (($status[$n].notes | Select-Object -First 2) -join ' / ') } }
if (-not $NoWrite) { [IO.File]::WriteAllText("$LIB\sync-status.data.js", "/* GENERATED by tools/check-shopify-sync.ps1. Do not edit. */`nwindow.NUDGE_SYNC = " + ($sj | ConvertTo-Json -Depth 4 -Compress) + ";`n", $utf8) }

"components: $($names.Count); layer 2 renders compared: $(($l2.Values | ForEach-Object { $_.total } | Measure-Object -Sum).Sum) across $($l2.Count) components"
"status: " + ((($counts.Keys | Sort-Object) | ForEach-Object { "$_ $($counts[$_])" }) -join '; ')
foreach ($a in $assetNotes) { "asset: $a" }
if ($problems.Count) { "FAILED:"; $problems | ForEach-Object { "  $_" }; exit 1 } else { 'sync check: no blocking problems' }
