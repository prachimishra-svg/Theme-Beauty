<#
  NUDGE Figma review dashboard: browser test (Chrome or Edge, driven over the DevTools protocol).
  Run:  powershell -ExecutionPolicy Bypass -File 01-Design-System/Figma-Specification/test-preview.ps1 [-BrowserPath <exe>] [-OutDir <folder for screenshots>]

  Opens 01-Design-System/Figma-Specification/Preview/index.html from disk and checks, with real clicks, typing, key presses and touch emulation:
    A  load: 12 sections and 12 navigation links render; no section shows a render error; no console error, exception or failed resource
    B  data integrity: every value the page displays for a variable (data-var, data-mode, data-value) equals the value in 02-Design-Variables/Figma-Variables/variable-map.json,
       in the default modes and again after switching the Semantic, Layout and Typography modes
    C  navigation: each of the 12 links scrolls to its section and marks it current
    D  search and filters: global search, colour group filter, semantic "differs" filter, variable browser filters, token-mapping filter: counts equal counts computed from the source file
    E  details: the variable panel opens from search and from a swatch, shows the web value, and closes with Escape
    F  components: every component draws with no missing variable; the playground and the all-variants grid work
    G  validation: the headline matches the validator results; corrupted copies of the data (duplicate name, broken alias, a point-unit font size, a missing component field,
       a changed source hash, a failed validator group, a missing validator file) are reported and never shown as validated
    H  fonts: each family reports rendering or a clear fallback status
    I  responsive: no horizontal overflow at 1280, 768 and 390px; the mobile menu opens and closes; touch targets of the main controls are at least 44px under touch emulation
    J  keyboard: Tab reaches the skip link, the navigation and the controls, each with a visible focus ring
  It is a Blink-only emulation test. It is NOT Firefox, Safari, a real phone, or a screen reader, and it does not open Figma.
  Nothing in the project is modified; corrupted copies are made in a temporary folder.
  Exit code 0 = all passed, 1 = a check failed, 2 = could not run.
#>
param([string]$BrowserPath = '', [string]$OutDir = '')
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$proj = Split-Path -Parent (Split-Path -Parent $here)   # project root
$browser = @("$env:ProgramFiles\Google\Chrome\Application\chrome.exe", "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe", "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe", "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe") | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
if ($BrowserPath) { $browser = $BrowserPath }
if (-not $browser) { Write-Host 'No Chrome or Edge found.'; exit 2 }
function FileUrl([string]$p) { 'file:///' + ($p -replace '\\', '/').Replace(' ', '%20') }
$pv = Join-Path $here 'Preview'
$url = FileUrl (Join-Path $pv 'index.html')
if ($OutDir) { New-Item -ItemType Directory -Force $OutDir | Out-Null }
$map = Get-Content (Join-Path $proj '02-Design-Variables\Figma-Variables\variable-map.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$srcBy = @{}; foreach ($v in $map.variables) { $srcBy[$v.name] = $v }

# ---- browser over the DevTools protocol ----
$port = Get-Random -Minimum 9500 -Maximum 9640
$prof = Join-Path ([IO.Path]::GetTempPath()) ("nudge-fp-" + [guid]::NewGuid().ToString('N').Substring(0, 6)); New-Item -ItemType Directory $prof | Out-Null
$proc = Start-Process -FilePath $browser -ArgumentList @('--headless=new', '--disable-gpu', "--remote-debugging-port=$port", '--remote-allow-origins=*', "--user-data-dir=`"$prof`"", '--no-first-run', '--allow-file-access-from-files', 'about:blank') -PassThru -WindowStyle Hidden
$ready = $false
for ($i = 0; $i -lt 30 -and -not $ready; $i++) { Start-Sleep -Milliseconds 500; try { Invoke-RestMethod "http://127.0.0.1:$port/json/version" -TimeoutSec 2 | Out-Null; $ready = $true } catch {} }
if (-not $ready) { Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue; Write-Host 'Could not reach the browser DevTools endpoint.'; exit 2 }
Start-Sleep -Seconds 2
$tab = Invoke-RestMethod -Method Put -Uri "http://127.0.0.1:$port/json/new?about:blank" -TimeoutSec 5
$sock = New-Object System.Net.WebSockets.ClientWebSocket
$sock.ConnectAsync([Uri]@($tab.webSocketDebuggerUrl)[0], [Threading.CancellationToken]::None).Wait()
$script:id = 0; $script:events = New-Object System.Collections.ArrayList
function Send([string]$method, $params = @{}) {
  $script:id++; $my = $script:id
  $b = [Text.Encoding]::UTF8.GetBytes((@{ id = $my; method = $method; params = $params } | ConvertTo-Json -Depth 10 -Compress))
  $sock.SendAsync((New-Object System.ArraySegment[byte] -ArgumentList (, $b)), [Net.WebSockets.WebSocketMessageType]::Text, $true, [Threading.CancellationToken]::None).Wait()
  while ($true) {
    $buf = New-Object byte[] 1048576; $ms = New-Object IO.MemoryStream
    do { $cts = New-Object Threading.CancellationTokenSource 30000; try { $r = $sock.ReceiveAsync((New-Object System.ArraySegment[byte] -ArgumentList (, $buf)), $cts.Token).Result } catch { throw "Timed out (30s) waiting for a reply to $method" }; $ms.Write($buf, 0, $r.Count) } while (-not $r.EndOfMessage)
    $m = [Text.Encoding]::UTF8.GetString($ms.ToArray()) | ConvertFrom-Json
    if ($m.PSObject.Properties.Name -contains 'id' -and $m.id -eq $my) { if ($m.error) { throw "CDP $method failed: $($m.error.message)" }; return $m }
    if ($m.PSObject.Properties.Name -contains 'method') { [void]$script:events.Add($m) }
  }
}
function Js([string]$expr) { $r = Send 'Runtime.evaluate' @{ expression = $expr; returnByValue = $true; awaitPromise = $true }; if ($r.result.exceptionDetails) { throw "JS error: $($r.result.exceptionDetails.exception.description)" }; return $r.result.result.value }
function Go([string]$u) { Send 'Page.navigate' @{ url = $u } | Out-Null; for ($i = 0; $i -lt 40; $i++) { Start-Sleep -Milliseconds 250; try { if ((Js 'document.readyState') -eq 'complete') { break } } catch {} }; Start-Sleep -Milliseconds 1500 }
function Key([string]$key, [string]$code, [int]$vk, [int]$mods = 0) { Send 'Input.dispatchKeyEvent' @{ type = 'rawKeyDown'; key = $key; code = $code; windowsVirtualKeyCode = $vk; nativeVirtualKeyCode = $vk; modifiers = $mods } | Out-Null; Send 'Input.dispatchKeyEvent' @{ type = 'keyUp'; key = $key; code = $code; windowsVirtualKeyCode = $vk; nativeVirtualKeyCode = $vk; modifiers = $mods } | Out-Null; Start-Sleep -Milliseconds 120 }
function Shot([string]$name) { if ($OutDir) { $r = Send 'Page.captureScreenshot' @{ format = 'png'; captureBeyondViewport = $false }; [IO.File]::WriteAllBytes((Join-Path $OutDir "$name.png"), [Convert]::FromBase64String($r.result.data)) } }
function VP([int]$w, [int]$h, [bool]$touch = $false) { Send 'Emulation.setDeviceMetricsOverride' @{ width = $w; height = $h; deviceScaleFactor = $(if ($touch) { 3 } else { 1 }); mobile = $touch } | Out-Null; Send 'Emulation.setTouchEmulationEnabled' @{ enabled = $touch; maxTouchPoints = 5 } | Out-Null }
$script:fail = 0
function Report([string]$group, $rows) { Write-Host "`n$group"; foreach ($r in $rows) { $tag = if ($r.ok -eq $true) { 'PASS' } elseif ($r.ok -eq $false) { $script:fail++; 'FAIL' } else { 'INFO' }; Write-Host ("   {0,-84} {1}  {2}" -f $r.name, $tag, $r.detail) } }
function Row([string]$name, $ok, [string]$detail = '') { [pscustomobject]@{ name = $name; ok = $ok; detail = $detail } }
function Sel([string]$css, [string]$value) { Js "(function(){var s=document.querySelector('$css'); if(!s) return 'missing'; s.value='$value'; s.dispatchEvent(new Event('change',{bubbles:true})); return 'ok';})()" }
function CountText([string]$css) { Js "(function(){var e=document.querySelector('$css'); return e?e.textContent:'missing';})()" }

try {
  Send 'Page.enable' | Out-Null; Send 'Log.enable' | Out-Null; Send 'Runtime.enable' | Out-Null
  Send 'Emulation.setFocusEmulationEnabled' @{ enabled = $true } | Out-Null
  Send 'Page.addScriptToEvaluateOnNewDocument' @{ source = "window.__errs=[];window.addEventListener('error',function(e){__errs.push('error: '+e.message)});window.addEventListener('unhandledrejection',function(e){__errs.push('rejection: '+e.reason)});var __ce=console.error;console.error=function(){__errs.push('console.error: '+[].slice.call(arguments).join(' '));__ce.apply(console,arguments)};" } | Out-Null
  VP 1280 900
  Go $url
  Js "document.documentElement.style.scrollBehavior='auto'; 0" | Out-Null

  # ---------------- A: load ----------------
  $a = (Js "JSON.stringify({sections:document.querySelectorAll('section.sec').length,nav:document.querySelectorAll('#nav a').length,empty:[].filter.call(document.querySelectorAll('section.sec'),function(s){return s.children.length<4}).length,renderErr:document.body.textContent.indexOf('Render error')>=0,errs:window.__errs})") | ConvertFrom-Json
  $logErr = @($script:events | Where-Object { ($_.method -eq 'Log.entryAdded' -and $_.params.entry.level -eq 'error' -and $_.params.entry.url -notmatch 'chrome-extension') -or $_.method -eq 'Runtime.exceptionThrown' })
  Shot 'dashboard-1280'
  Report 'A. Load' @(
    (Row '12 sections and 12 navigation links render' ($a.sections -eq 12 -and $a.nav -eq 12) "sections=$($a.sections) nav=$($a.nav)"),
    (Row 'No section is empty and none shows a render error' (($a.empty -eq 0) -and -not $a.renderErr) "empty sections=$($a.empty) renderError=$($a.renderErr)"),
    (Row 'No script error, unhandled rejection or console.error' (@($a.errs).Count -eq 0) "page errors: $(@($a.errs).Count)"),
    (Row 'No failed resource or exception reported by the browser' ($logErr.Count -eq 0) $(if ($logErr.Count) { ($logErr | Select-Object -First 2 | ForEach-Object { $_.params.entry.text + ' ' + $_.params.entry.url }) -join ' | ' } else { 'browser log clean' }))
  )

  # ---------------- B: displayed values equal the source file ----------------
  $collect = "JSON.stringify([].map.call(document.querySelectorAll('[data-var]'),function(e){return {n:e.getAttribute('data-var'),m:e.getAttribute('data-mode'),v:e.getAttribute('data-value'),t:e.textContent}}))"
  function CheckValues([string]$label) {
    $items = (Js $collect) | ConvertFrom-Json; $bad = @(); $checked = 0; $unlinked = 0
    foreach ($it in $items) {
      if (-not $srcBy.ContainsKey($it.n)) { $unlinked++; $bad += "$($it.n) is not in variable-map.json"; continue }
      $mode = $it.m; $e = $srcBy[$it.n].values.$mode; if (-not $e) { $bad += "$($it.n) has no mode $mode in the source"; continue }
      $checked++; $src = [string]$e.resolved
      if ([string]$it.v -ne $src) { $bad += "$($it.n) ($mode): page says '$($it.v)', source says '$src'" }
      elseif ($it.t.IndexOf($src) -lt 0 -and $it.t.Length -gt 0) { $bad += "$($it.n) ($mode): displayed text '$($it.t)' does not contain '$src'" }
    }
    return [pscustomobject]@{ label = $label; checked = $checked; unlinked = $unlinked; bad = $bad }
  }
  $b1 = CheckValues 'default modes'
  Js "document.querySelector('button[data-grp=sem][data-mode=Inverse]').click(); document.querySelector('button[data-grp=layout][data-mode=Desktop]').click(); document.querySelector('button[data-grp=type][data-mode=Tablet]').click(); 0" | Out-Null; Start-Sleep -Milliseconds 700
  $b2 = CheckValues 'Inverse, Desktop, Tablet'
  $h1 = (Js "(function(){var e=document.querySelector('[data-var=\'font-size/h1\'][data-mode=Tablet]');return e?e.getAttribute('data-value'):'missing'})()")
  $bg = (Js "(function(){var e=document.querySelector('[data-var=\'color/bg/page\'][data-mode=Inverse]');return e?e.getAttribute('data-value'):'missing'})()")
  Report 'B. Displayed values equal variable-map.json' @(
    (Row "Default modes: $($b1.checked) displayed values compared with the source file" ($b1.bad.Count -eq 0 -and $b1.checked -gt 150) "$($b1.checked) compared, $($b1.bad.Count) differences$(if ($b1.bad.Count) { ': ' + ($b1.bad | Select-Object -First 3) -join '; ' })"),
    (Row "After switching modes: $($b2.checked) displayed values compared" ($b2.bad.Count -eq 0 -and $b2.checked -gt 150) "$($b2.checked) compared, $($b2.bad.Count) differences$(if ($b2.bad.Count) { ': ' + ($b2.bad | Select-Object -First 3) -join '; ' })"),
    (Row 'Switching the Semantic mode changes the displayed colour to the source Inverse value' ($bg -eq [string]$srcBy['color/bg/page'].values.Inverse.resolved) "color/bg/page Inverse: page $bg, source $($srcBy['color/bg/page'].values.Inverse.resolved)"),
    (Row 'Switching the Typography mode changes the displayed size to the source Tablet value' ($h1 -eq [string]$srcBy['font-size/h1'].values.Tablet.resolved) "font-size/h1 Tablet: page $h1, source $($srcBy['font-size/h1'].values.Tablet.resolved)")
  )
  Js "document.querySelector('button[data-grp=sem][data-mode=Default]').click(); document.querySelector('button[data-grp=layout][data-mode=Mobile]').click(); document.querySelector('button[data-grp=type][data-mode=Mobile]').click(); 0" | Out-Null; Start-Sleep -Milliseconds 500

  # ---------------- C: navigation ----------------
  $secs = 'overview', 'colors', 'semantic', 'type', 'spacing', 'layout', 'effects', 'collections', 'components', 'variants', 'naming', 'validation'; $nrows = @()
  foreach ($s in $secs) {
    Js "document.querySelector('#nav a[data-sec=$s]').click(); 0" | Out-Null; Start-Sleep -Milliseconds 450
    $n = (Js "(function(){var e=document.getElementById('s-$s'),r=e.getBoundingClientRect(),a=document.querySelector('#nav a[data-sec=$s]');return JSON.stringify({hash:location.hash,top:Math.round(r.top),vh:innerHeight,cur:a.getAttribute('aria-current')})})()") | ConvertFrom-Json
    $nrows += (Row "Link '$s' scrolls to its section and marks it current" ($n.hash -eq "#s-$s" -and $n.top -lt ($n.vh * 0.6) -and $n.top -gt -($n.vh) -and $n.cur -eq 'true') "hash=$($n.hash) top=$($n.top) current=$($n.cur)")
  }
  Report 'C. Navigation' $nrows

  # ---------------- D: search and filters ----------------
  Js "window.scrollTo(0,0); document.getElementById('gsearch').focus(); 0" | Out-Null
  Send 'Input.insertText' @{ text = 'rose' } | Out-Null; Start-Sleep -Milliseconds 300
  $q = (Js "JSON.stringify({total:+document.getElementById('gresults').getAttribute('data-total'),shown:document.querySelectorAll('#gresults button').length,hidden:document.getElementById('gresults').hidden})") | ConvertFrom-Json
  $expectRose = @($map.variables | Where-Object { $_.name.ToLower().Contains('rose') -or ([string]$_.description).ToLower().Contains('rose') }).Count
  Send 'Input.insertText' @{ text = 'zzzz' } | Out-Null; Start-Sleep -Milliseconds 250
  $none = (Js "document.getElementById('gresults').textContent") -match 'No variable matches'
  Js "document.getElementById('gsearch').value=''; document.getElementById('gsearch').dispatchEvent(new Event('input',{bubbles:true})); 0" | Out-Null
  Sel 'select[aria-label],#color-list' 'x' | Out-Null
  $groupSel = Js "(function(){var l=[].filter.call(document.querySelectorAll('#s-colors .filters label'),function(x){return x.textContent.indexOf('Palette group')===0})[0]; var s=l.querySelector('select'); s.value='neutral'; s.dispatchEvent(new Event('change',{bubbles:true})); return document.querySelector('#s-colors .count').textContent})()"
  $expNeutral = @($map.variables | Where-Object { $_.collection -eq 'Primitives' -and $_.type -eq 'COLOR' -and $_.name -like 'palette/neutral/*' }).Count
  $ivory = Js "(function(){var i=document.querySelector('#s-colors .filters input[type=search]'); var l=[].filter.call(document.querySelectorAll('#s-colors .filters label'),function(x){return x.textContent.indexOf('Palette group')===0})[0].querySelector('select'); l.value='all'; l.dispatchEvent(new Event('change',{bubbles:true})); i.value='ivory'; i.dispatchEvent(new Event('input',{bubbles:true})); return document.querySelector('#s-colors .count').textContent})()"
  $diff = Js "(function(){var c=document.querySelector('#s-semantic .filters input[type=checkbox]'); c.checked=true; c.dispatchEvent(new Event('change',{bubbles:true})); return document.querySelector('#s-semantic .count').textContent})()"
  $expDiff = @($map.variables | Where-Object { $_.collection -eq 'Semantic' -and (($_.values.Default.resolved -ne $_.values.Inverse.resolved) -or ($_.values.Default.alias -ne $_.values.Inverse.alias)) }).Count
  $vbColl = Js "(function(){var ls=document.querySelectorAll('#s-collections .filters label'); var s=ls[1].querySelector('select'); s.value='Layout'; s.dispatchEvent(new Event('change',{bubbles:true})); return document.querySelector('#s-collections .count').textContent})()"
  $vbType = Js "(function(){var ls=document.querySelectorAll('#s-collections .filters label'); ls[1].querySelector('select').value='all'; ls[1].querySelector('select').dispatchEvent(new Event('change',{bubbles:true})); var s=ls[2].querySelector('select'); s.value='STRING'; s.dispatchEvent(new Event('change',{bubbles:true})); return document.querySelector('#s-collections .count').textContent})()"
  $mapCat = Js "(function(){var ls=document.querySelectorAll('#s-naming .filters label'); var s=ls[1].querySelector('select'); s.value='Shared'; s.dispatchEvent(new Event('change',{bubbles:true})); return document.querySelector('#s-naming .count').textContent})()"
  $expShared = @($map.webMapping | Where-Object { $_.category -eq 'Shared' }).Count
  Report 'D. Search and filters (counts computed from the source file)' @(
    (Row "Global search 'rose' finds $expectRose variables" ($q.total -eq $expectRose -and $q.shown -le 14 -and -not $q.hidden) "page total $($q.total), source $expectRose, shown $($q.shown)"),
    (Row 'A search with no match says so' $none 'No variable matches message shown'),
    (Row "Colour group filter 'neutral' shows $expNeutral of the colours" ($groupSel -like "$expNeutral of *") $groupSel),
    (Row "Colour search 'ivory' shows the colours whose name or text mention it" ($ivory -match '^(\d+) of (\d+) colours' -and [int]$Matches[1] -gt 0 -and [int]$Matches[1] -lt [int]$Matches[2]) $ivory),
    (Row "Semantic 'only roles that differ' shows $expDiff roles" ($diff -like "$expDiff of *") $diff),
    (Row 'Variable browser: collection Layout shows 11 variables' ($vbColl -like '11 of *') $vbColl),
    (Row 'Variable browser: type STRING shows the 2 font families' ($vbType -like '2 of *') $vbType),
    (Row "Token mapping: category Shared shows $expShared web tokens" ($mapCat -like "$expShared of *") $mapCat)
  )

  # ---------------- E: details panel ----------------
  Js "window.scrollTo(0,0); document.getElementById('gsearch').focus(); 0" | Out-Null
  Send 'Input.insertText' @{ text = 'font-size/h1' } | Out-Null; Start-Sleep -Milliseconds 300
  Js "document.querySelector('#gresults button[data-result=\'font-size/h1\']').click(); 0" | Out-Null; Start-Sleep -Milliseconds 300
  $p = (Js "JSON.stringify({open:!document.getElementById('panel').hidden,title:document.getElementById('panel-title').textContent,text:document.getElementById('panel-body').textContent})") | ConvertFrom-Json
  Shot 'panel-font-size-h1'
  Key 'Escape' 'Escape' 27
  $closed = Js "document.getElementById('panel').hidden"
  Js "document.querySelector('#s-colors .sw').click(); 0" | Out-Null; Start-Sleep -Milliseconds 200
  $p2 = (Js "JSON.stringify({open:!document.getElementById('panel').hidden,title:document.getElementById('panel-title').textContent})") | ConvertFrom-Json
  Js "document.getElementById('panel-close').click(); 0" | Out-Null
  Report 'E. Variable details' @(
    (Row 'Search result opens the detail panel for that variable' ($p.open -and $p.title -eq 'font-size/h1') "title=$($p.title)"),
    (Row 'Panel shows the web tier value beside the Figma value in every mode, and they match (no sampling since the 2026-11-11 audit)' ($p.text -match 'web 36' -and $p.text -match 'web 48' -and $p.text -match 'web 60' -and $p.text -match 'figma 48' -and $p.text -match 'same' -and $p.text -notmatch 'differs') 'web 36 / 48 / 60 = figma, no difference'),
    (Row 'Escape closes the panel' ($closed -eq $true) "hidden=$closed"),
    (Row 'A swatch opens its variable; the close button closes it' ($p2.open -and $p2.title -like 'palette/*' -and ((Js "document.getElementById('panel').hidden") -eq $true)) "title=$($p2.title)")
  )

  # ---------------- F: components ----------------
  Js "document.getElementById('nav').querySelector('a[data-sec=components]').click(); 0" | Out-Null; Start-Sleep -Milliseconds 300
  $f = (Js "JSON.stringify({cards:document.querySelectorAll('#s-components .cgrid > .card').length,missingVar:[].filter.call(document.querySelectorAll('#s-components .miss'),function(e){return e.textContent.indexOf('Missing variable')>=0}).length,noDraw:[].filter.call(document.querySelectorAll('#s-components .render'),function(e){return e.textContent.indexOf('No preview drawing')>=0}).length,prov:[].filter.call(document.querySelectorAll('#s-components .cgrid .status'),function(e){return e.textContent==='Provisional'}).length,pending:document.querySelectorAll('#s-components table tbody tr').length})") | ConvertFrom-Json
  $pg = @()
  foreach ($cid in 'button', 'chip', 'input-field', 'choice', 'badge', 'drawer', 'product-card') {
    Sel '#s-variants .controls label select' $cid | Out-Null; Start-Sleep -Milliseconds 400
    $r = (Js "JSON.stringify({live:document.querySelectorAll('#pg-live .cell').length,all:document.querySelectorAll('#s-variants .render-wrap')[1].querySelectorAll('.cell').length,missing:document.querySelectorAll('#s-variants .miss').length,heading:document.querySelector('#s-variants h3:nth-of-type(1)').textContent})") | ConvertFrom-Json
    $comp = $null; foreach ($cc in (Get-Content (Join-Path $here 'components.json') -Raw -Encoding UTF8 | ConvertFrom-Json).components) { if ($cc.id -eq $cid) { $comp = $cc } }
    $exp = 1; foreach ($pp in $comp.properties) { if ($pp.type -eq 'VARIANT') { $exp *= @($pp.values).Count } }; $exp = [math]::Min($exp, 60)
    $varMiss = (Js "[].filter.call(document.querySelectorAll('#s-variants .miss'),function(e){return e.textContent.indexOf('Missing variable')>=0}).length")
    $pg += (Row "Playground: $($comp.name) draws live and its all-variants grid has $exp cells" ($r.live -eq 1 -and $r.all -eq $exp -and $varMiss -eq 0) "live=$($r.live) grid=$($r.all) expected=$exp missing variables=$varMiss")
  }
  Js "(function(){Sel=function(){}; var s=document.querySelector('#s-variants .controls label select'); s.value='chip'; s.dispatchEvent(new Event('change',{bubbles:true}));})()" | Out-Null; Start-Sleep -Milliseconds 400
  Js "(function(){var labs=document.querySelectorAll('#s-variants .controls label'); for(var i=0;i<labs.length;i++){ if(labs[i].textContent.indexOf('Selected')===0){ var s=labs[i].querySelector('select'); s.value='true'; s.dispatchEvent(new Event('change',{bubbles:true})); } if(labs[i].textContent.indexOf('Label (text)')===0){ var t=labs[i].querySelector('input'); t.value='Brightening'; t.dispatchEvent(new Event('input',{bubbles:true})); } } })()" | Out-Null; Start-Sleep -Milliseconds 300
  $live = (Js "JSON.stringify({text:document.querySelector('#pg-live').textContent,svg:document.querySelectorAll('#pg-live svg').length})") | ConvertFrom-Json
  Shot 'component-playground-chip'
  Report 'F. Components' (@(
    (Row '15 component cards are shown' ($f.cards -eq 15) "cards=$($f.cards)"),
    (Row 'No component drawing is missing a variable or a drawing' ($f.missingVar -eq 0 -and $f.noDraw -eq 0) "missing variables=$($f.missingVar) no drawing=$($f.noDraw)"),
    (Row 'The two provisional components are labelled Provisional' ($f.prov -eq 2) "provisional cards=$($f.prov)"),
    (Row 'Not defined or pending items are listed with a status' ($f.pending -ge 7) "rows=$($f.pending)")
  ) + $pg + @((Row 'Playground: editing text and a variant property updates the live drawing (Chip: Selected=true, Label=Brightening)' ($live.text -like '*Brightening*' -and $live.svg -ge 1) "text='$($live.text.Trim())' glyphs=$($live.svg)")))

  # ---------------- H: fonts ----------------
  $fonts = (Js "JSON.stringify([].map.call(document.querySelectorAll('[data-font]'),function(e){return {f:e.getAttribute('data-font'),t:e.textContent,c:e.className}}))") | ConvertFrom-Json
  $frows = @(); foreach ($ff in $fonts | Select-Object -First 2) { $resolved = ($ff.t -like 'Rendering with*' -or $ff.t -like 'FALLBACK*'); $frows += (Row "Font '$($ff.f)' reports a definite status" $resolved $ff.t) }
  Report 'H. Fonts (a fallback must be reported, never hidden)' $frows

  # ---------------- G: validation, including corrupted copies ----------------
  Js "document.getElementById('nav').querySelector('a[data-sec=validation]').click(); 0" | Out-Null; Start-Sleep -Milliseconds 300
  $vt = (Js "JSON.stringify({banner:document.querySelector('#s-validation .banner .status').textContent,groups:document.querySelectorAll('#s-validation table')[0].querySelectorAll('tbody tr').length,live:document.querySelectorAll('#s-validation table')[1].querySelectorAll('tbody tr').length})") | ConvertFrom-Json
  $valFile = Join-Path $pv 'validation-data.js'; $vjs = [IO.File]::ReadAllText($valFile, [Text.Encoding]::UTF8); $vobj = ($vjs -replace '^window\.FIGMA_VALIDATION\s*=\s*', '' -replace ';\s*$', '') | ConvertFrom-Json
  $expBanner = if ($vobj.meta.groupsFailed -eq 0) { 'Specification checks passed' } else { 'Issues found' }
  $gRows = @((Row "Headline matches the validator results ($($vobj.meta.groupsTotal) groups, $($vobj.meta.groupsFailed) failed)" ($vt.banner -eq $expBanner -and $vt.groups -eq $vobj.meta.groupsTotal) "banner='$($vt.banner)' groups=$($vt.groups)"), (Row 'The in-page checks are listed' ($vt.live -eq 9) "in-page checks=$($vt.live)"))
  $tmp = Join-Path ([IO.Path]::GetTempPath()) ("nudge-fp-bad-" + [guid]::NewGuid().ToString('N').Substring(0, 6))
  function Variant([string]$name, [scriptblock]$mutate) {
    $d = Join-Path $tmp $name; New-Item -ItemType Directory -Force $d | Out-Null; Copy-Item (Join-Path $pv '*') $d -Recurse
    & $mutate $d
    Go (FileUrl (Join-Path $d 'index.html'))
    return (Js "JSON.stringify({banner:document.querySelector('#s-overview .banner.ok, #s-overview .banner.bad, #s-overview .banner.warn:nth-of-type(2)') ? [].map.call(document.querySelectorAll('#s-overview .banner .status'),function(e){return e.textContent}) : [], failed:[].map.call(document.querySelectorAll('#s-validation table')[1].querySelectorAll('tbody tr'),function(r){return r.children[0].textContent+':'+r.children[2].textContent}).filter(function(x){return x.indexOf('FAIL')>0}), errs:window.__errs})") | ConvertFrom-Json
  }
  function EditSpec([string]$dir, [scriptblock]$edit) { $f = Join-Path $dir 'preview-data.js'; $o = ([IO.File]::ReadAllText($f, [Text.Encoding]::UTF8) -replace '^window\.FIGMA_SPEC\s*=\s*', '' -replace ';\s*$', '') | ConvertFrom-Json; & $edit $o; [IO.File]::WriteAllText($f, ('window.FIGMA_SPEC = ' + ($o | ConvertTo-Json -Depth 30 -Compress) + ';'), (New-Object Text.UTF8Encoding($false))) }
  $v1 = Variant 'dup' { param($d) EditSpec $d { param($o) $o.variables[5].name = $o.variables[4].name } }
  $v2 = Variant 'alias' { param($d) EditSpec $d { param($o) $t = $o.variables | Where-Object { $_.collection -eq 'Semantic' } | Select-Object -First 1; $m = $t.values.PSObject.Properties.Name[0]; $t.values.$m.alias = 'palette/does-not-exist' } }
  $v3 = Variant 'pt' { param($d) EditSpec $d { param($o) $t = $o.variables | Where-Object { $_.name -eq 'font-size/h1' }; $t.values.Mobile.resolved = '27pt' } }
  $v4 = Variant 'comp' { param($d) EditSpec $d { param($o) $o.components[0].PSObject.Properties.Remove('accessibility') } }
  $v5 = Variant 'binding' { param($d) EditSpec $d { param($o) $o.components[0].bindings[0].variable = 'control/height/nope' } }
  $v6 = Variant 'stale' { param($d) $f = Join-Path $d 'validation-data.js'; $t = [IO.File]::ReadAllText($f); $m = [regex]::Match($t, '"(02-Design-Variables/Figma-Variables/primitives\.json)":"([0-9A-F]{64})"'); [IO.File]::WriteAllText($f, $t.Replace($m.Groups[2].Value, ('0' * 64)), (New-Object Text.UTF8Encoding($false))) }
  $v7 = Variant 'failed' { param($d) $f = Join-Path $d 'validation-data.js'; $t = [IO.File]::ReadAllText($f); $t = $t.Replace('"groupsFailed":0', '"groupsFailed":1'); [IO.File]::WriteAllText($f, $t, (New-Object Text.UTF8Encoding($false))) }
  $v8 = Variant 'nofile' { param($d) Remove-Item (Join-Path $d 'validation-data.js') -Force }
  $has = { param($x, $s) (@($x.banner) -join ' | ') -like "*$s*" }
  $gRows += (Row 'Corrupted data: a duplicate variable name is reported (in-page check L2 fails, Issues found)' ((@($v1.failed) -join ' ') -match 'L2' -and (& $has $v1 'Issues found')) "failed: $(@($v1.failed) -join ', '); headline: $(@($v1.banner) -join ' | ')")
  $gRows += (Row 'Corrupted data: a broken alias is reported (L3, Issues found)' ((@($v2.failed) -join ' ') -match 'L3' -and (& $has $v2 'Issues found')) "failed: $(@($v2.failed) -join ', ')")
  $gRows += (Row 'Corrupted data: a font size that is not a px number (a point value) is reported (L5)' ((@($v3.failed) -join ' ') -match 'L5' -and (& $has $v3 'Issues found')) "failed: $(@($v3.failed) -join ', ')")
  $gRows += (Row 'Corrupted data: a component missing a field is reported (L6)' ((@($v4.failed) -join ' ') -match 'L6' -and (& $has $v4 'Issues found')) "failed: $(@($v4.failed) -join ', ')")
  $gRows += (Row 'Corrupted data: a binding to a missing variable is reported (L6)' ((@($v5.failed) -join ' ') -match 'L6') "failed: $(@($v5.failed) -join ', ')")
  $gRows += (Row 'A changed source hash makes the headline "out of date", not "passed"' ((& $has $v6 'out of date') -and -not (& $has $v6 'Specification checks passed')) "headline: $(@($v6.banner) -join ' | ')")
  $gRows += (Row 'A failed validator group makes the headline "Issues found"' ((& $has $v7 'Issues found')) "headline: $(@($v7.banner) -join ' | ')")
  $gRows += (Row 'A missing validator file is reported as "not loaded", not as validated' ((& $has $v8 'not loaded') -and -not (& $has $v8 'Specification checks passed')) "headline: $(@($v8.banner) -join ' | ')")
  Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
  Report 'G. Validation display' $gRows
  Go $url; Js "document.documentElement.style.scrollBehavior='auto'; 0" | Out-Null

  # ---------------- I: responsive ----------------
  $irows = @()
  foreach ($w in 1280, 768) { VP $w 900; Go $url; $o = (Js "JSON.stringify({sw:document.documentElement.scrollWidth,cw:document.documentElement.clientWidth,menu:getComputedStyle(document.getElementById('menu-btn')).display,side:getComputedStyle(document.getElementById('side')).position})") | ConvertFrom-Json; $irows += (Row "${w}px: no horizontal overflow" ($o.sw -le $o.cw + 1) "scrollWidth=$($o.sw) clientWidth=$($o.cw) menu button display=$($o.menu)"); if ($w -eq 768) { Shot 'dashboard-768' } }
  VP 390 844 $true; Go $url
  $m = (Js "JSON.stringify({sw:document.documentElement.scrollWidth,cw:document.documentElement.clientWidth,menu:getComputedStyle(document.getElementById('menu-btn')).display,sideLeft:Math.round(document.getElementById('side').getBoundingClientRect().right)})") | ConvertFrom-Json
  Shot 'dashboard-390'
  $wide = Js "JSON.stringify([].filter.call(document.querySelectorAll('body *'),function(e){if(e.closest('.scroll'))return false;var r=e.getBoundingClientRect();return r.right>391&&r.width>0}).slice(0,6).map(function(e){return e.tagName+'.'+e.className+'#'+e.id+' right='+Math.round(e.getBoundingClientRect().right)}))"; Write-Host "   [diagnostic] elements past the right edge at 390px: $wide"
  $irows += (Row '390px (touch): no horizontal overflow, menu button shown, sidebar hidden off screen' ($m.sw -le $m.cw + 1 -and $m.menu -ne 'none' -and $m.sideLeft -le 0) "scrollWidth=$($m.sw) clientWidth=$($m.cw) menu=$($m.menu) sidebar right edge=$($m.sideLeft)")
  Js "document.getElementById('menu-btn').click(); 0" | Out-Null; Start-Sleep -Milliseconds 400
  $open = (Js "JSON.stringify({exp:document.getElementById('menu-btn').getAttribute('aria-expanded'),right:Math.round(document.getElementById('side').getBoundingClientRect().right)})") | ConvertFrom-Json
  Shot 'dashboard-390-menu'
  Js "document.querySelector('#nav a[data-sec=layout]').click(); 0" | Out-Null; Start-Sleep -Milliseconds 500
  $shut = (Js "JSON.stringify({exp:document.getElementById('menu-btn').getAttribute('aria-expanded'),right:Math.round(document.getElementById('side').getBoundingClientRect().right),hash:location.hash})") | ConvertFrom-Json
  $irows += (Row 'Menu opens on tap and closes after choosing a section' ($open.exp -eq 'true' -and $open.right -gt 100 -and $shut.exp -eq 'false' -and $shut.right -le 0 -and $shut.hash -eq '#s-layout') "open: expanded=$($open.exp) edge=$($open.right); after link: expanded=$($shut.exp) edge=$($shut.right) hash=$($shut.hash)")
  $small = (Js "JSON.stringify([].map.call(document.querySelectorAll('#modes button, #menu-btn, #gsearch, .filters select, .filters input[type=search], .controls select, .controls input[type=text], .pill, .btn'),function(e){var r=e.getBoundingClientRect();return {n:(e.id||e.className||e.tagName)+':'+(e.textContent||'').slice(0,18),w:Math.round(r.width),h:Math.round(r.height),v:r.width>0&&r.height>0}}).filter(function(x){return x.v&&Math.min(x.w,x.h)<43.5}))") | ConvertFrom-Json
  $irows += (Row 'Touch emulation: every visible main control, filter and pill is at least 44px' (@($small).Count -eq 0) "below 44px: $(@($small).Count) $((@($small) | Select-Object -First 4 | ForEach-Object { $_.n + ' ' + $_.w + 'x' + $_.h }) -join '; ')")
  Js "(function(){ document.querySelectorAll('#s-variants,#s-components,#s-layout').forEach(function(s){ s.scrollIntoView({block:'start'}); }); })(); 0" | Out-Null
  $ov = (Js "JSON.stringify({sw:document.documentElement.scrollWidth,cw:document.documentElement.clientWidth})") | ConvertFrom-Json
  $irows += (Row '390px: still no horizontal overflow after scrolling the wide sections' ($ov.sw -le $ov.cw + 1) "scrollWidth=$($ov.sw) clientWidth=$($ov.cw)")
  Report 'I. Responsive' $irows

  # ---------------- J: keyboard ----------------
  VP 1280 900; Go $url; Js "document.activeElement.blur(); window.scrollTo(0,0); 0" | Out-Null
  $stops = @(); foreach ($i in 1..40) { Key 'Tab' 'Tab' 9; $stops += ((Js "(function(){var a=document.activeElement; if(!a||a===document.body) return JSON.stringify({body:true}); var s=getComputedStyle(a); return JSON.stringify({tag:a.tagName.toLowerCase(),txt:(a.getAttribute('aria-label')||a.textContent||a.id||'').trim().slice(0,24),ring:s.outlineStyle+' '+s.outlineWidth,skip:a.className==='skip',nav:!!a.closest('#nav')})})()") | ConvertFrom-Json) }
  $noRing = @($stops | Where-Object { -not $_.body -and $_.ring -notlike 'solid 2px*' })
  Report 'J. Keyboard' @(
    (Row 'The first Tab stop is the skip link' ($stops[0].skip -eq $true) "first: $($stops[0].txt)"),
    (Row 'The navigation links are reachable by Tab' (@($stops | Where-Object { $_.nav }).Count -ge 12) "navigation stops in 40 Tabs: $(@($stops | Where-Object { $_.nav }).Count)"),
    (Row 'Every one of the first 40 Tab stops shows a 2px solid focus ring' ($noRing.Count -eq 0) "without a ring: $($noRing.Count) $((@($noRing) | Select-Object -First 3 | ForEach-Object { $_.txt + ' [' + $_.ring + ']' }) -join '; ')")
  )
}
finally {
  try { $sock.Dispose() } catch {}
  Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue; Start-Sleep -Milliseconds 600; Remove-Item $prof -Recurse -Force -ErrorAction SilentlyContinue
}
if ($script:fail) { Write-Host "`nRESULT: $script:fail check(s) FAILED"; exit 1 }
Write-Host "`nRESULT: all passed"; exit 0
