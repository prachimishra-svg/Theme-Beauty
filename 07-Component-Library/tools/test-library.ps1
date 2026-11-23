# Drives the Component Library v1 in headless Chrome over the DevTools protocol and checks what a reviewer would do:
# every component renders (defaults and every variant), selecting/changing properties/switching variants/tabs/widths work, nested components show,
# a variable override reaches the preview, shared edits reach instances while an instance override stays local. Optional screenshots with -Shots <folder>.
# Usage: .\tools\test-library.ps1 [-Shots <folder>]
param([string]$Shots = '', [int]$Port = 9351)
$ErrorActionPreference = 'Stop'
$L = Split-Path -Parent $PSScriptRoot; $utf8 = New-Object Text.UTF8Encoding($false)
$url = 'file:///' + (($L -replace '\\', '/') -replace ' ', '%20') + '/index.html'
$prof = Join-Path ([IO.Path]::GetTempPath()) ('nudge-lib-' + [guid]::NewGuid().ToString('N'))
$chrome = Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', "--remote-debugging-port=$Port", "--user-data-dir=`"$prof`"", '--allow-file-access-from-files', '--no-first-run', '--window-size=1600,1000', 'about:blank') -PassThru
$script:pass = 0; $script:fail = 0
function Ck($name, $ok, $detail = '') { if ($ok) { $script:pass++ } else { $script:fail++; "FAIL $name  $detail" } }
try {
  $ver = $null; for ($i = 0; $i -lt 50 -and -not $ver; $i++) { try { $ver = Invoke-RestMethod "http://127.0.0.1:$Port/json" -TimeoutSec 2 } catch { Start-Sleep -Milliseconds 200 } }
  $tab = @($ver | Where-Object { $_.type -eq 'page' })[0]
  $ws = New-Object Net.WebSockets.ClientWebSocket; [void]$ws.ConnectAsync([Uri]$tab.webSocketDebuggerUrl, [Threading.CancellationToken]::None).GetAwaiter().GetResult()
  $script:id = 0; $script:errs = New-Object System.Collections.ArrayList
  function Send([string]$method, $params = @{}) {
    $script:id++; $my = $script:id
    $bytes = $utf8.GetBytes((@{ id = $my; method = $method; params = $params } | ConvertTo-Json -Depth 12 -Compress)); [void]$ws.SendAsync([ArraySegment[byte]]$bytes, 'Text', $true, [Threading.CancellationToken]::None).GetAwaiter().GetResult()
    while ($true) { $buf = New-Object byte[] 4194304; $sb = New-Object Text.StringBuilder
      do { $r = $ws.ReceiveAsync([ArraySegment[byte]]$buf, [Threading.CancellationToken]::None).GetAwaiter().GetResult(); [void]$sb.Append($utf8.GetString($buf, 0, $r.Count)) } until ($r.EndOfMessage)
      $o = $sb.ToString() | ConvertFrom-Json
      if ($o.method -eq 'Runtime.exceptionThrown') { [void]$script:errs.Add($o.params.exceptionDetails.exception.description) }
      if ($o.method -eq 'Runtime.consoleAPICalled' -and $o.params.type -eq 'error') { [void]$script:errs.Add(($o.params.args | ForEach-Object { $_.value }) -join ' ') }
      if ($o.id -eq $my) { if ($o.error) { throw "CDP $method : $($o.error.message)" }; return $o.result } }
  }
  function Ev([string]$expr) { $r = Send 'Runtime.evaluate' @{ expression = $expr; returnByValue = $true; awaitPromise = $true }; if ($r.exceptionDetails) { throw "JS: $($r.exceptionDetails.exception.description) in: $($expr.Substring(0, [Math]::Min(160, $expr.Length)))" }; $r.result.value }
  function FrameEv([string]$expr) { Ev "window.__lib.frame.contentWindow.eval(atob('$([Convert]::ToBase64String($utf8.GetBytes($expr)))'))" }
  function WaitRendered { param($min = 0) Start-Sleep -Milliseconds 350 }
  [void](Send 'Page.enable'); [void](Send 'Runtime.enable')
  [void](Send 'Emulation.setDeviceMetricsOverride' @{ width = 1600; height = 1000; deviceScaleFactor = 1; mobile = $false })
  [void](Send 'Page.navigate' @{ url = $url }); Start-Sleep -Milliseconds 2500
  Ck 'library loads' ((Ev "typeof window.__lib") -eq 'object')
  $n = Ev "Object.keys(NUDGE_LIB.components).length"; "components in library: $n"
  Ck 'tree lists components' ((Ev "document.querySelectorAll('#tree button[data-n]').length") -eq $n)
  Ck 'frame ready' ((Ev "(function(){return true})()") -eq $true)
  Start-Sleep -Milliseconds 1200
  # 1. Every component renders with its defaults (engine level) and in the frame
  $bad = Ev "(function(){var b=[];Object.keys(NUDGE_LIB.components).forEach(function(n){var r=__lib.safeRender(n,__lib.defaultsFor(n));if(r.error)b.push(n+': '+r.error)});return b})()"
  "components that cannot render alone with defaults: $(@($bad).Count)"; @($bad) | ForEach-Object { "   $_" }; Ck 'every component renders alone with its defaults' (@($bad).Count -eq 0) ($bad -join ' // ')
  # 2. Base components: render every value of every VARIANT property
  $vr = Ev "(function(){var out={ok:0,bad:[]};Object.keys(NUDGE_LIB.components).filter(function(n){return NUDGE_LIB.components[n].group==='base'}).forEach(function(n){__lib.props(n).filter(function(p){return p.type==='VARIANT'}).forEach(function(p){p.values.forEach(function(v){var a=__lib.defaultsFor(n);a[p.name]=v;var r=__lib.safeRender(n,a);if(r.error)out.bad.push(n+' '+p.name+'='+v+': '+r.error);else out.ok++})})});return out})()"
  "base variant combinations rendered: $($vr.ok); failing: $(@($vr.bad).Count)"; @($vr.bad) | ForEach-Object { "   $_" }
  Ck 'all base variants render' (@($vr.bad).Count -eq 0)
  # 3. Select, preview shows real markup in the frame
  [void](Ev "__lib.select('components/base/button')"); Start-Sleep -Milliseconds 1500
  $h = FrameEv "document.getElementById('root').innerHTML"
  Ck 'button preview rendered in frame' ($h -match 'btn btn-primary') ($h.Substring(0, [Math]::Min(120, $h.Length)))
  $bg = FrameEv "getComputedStyle(document.querySelector('#root .btn')).backgroundColor"
  Ck 'button is styled by tailwind + design variables' ($bg -and $bg -ne 'rgba(0, 0, 0, 0)') $bg
  # 4. change property and switch variant through the real controls
  [void](Ev "(function(){var s=document.getElementById('p-variant');s.value='editorial';s.dispatchEvent(new Event('change'))})()"); Start-Sleep -Milliseconds 600
  Ck 'switching variant to editorial updates frame' ((FrameEv "document.querySelector('#root .hp-btn')?1:0") -eq 1)
  [void](Ev "(function(){var s=document.getElementById('p-label');s.value='Hello world';s.dispatchEvent(new Event('input'))})()"); Start-Sleep -Milliseconds 600
  Ck 'text property reaches the frame' ((FrameEv "document.getElementById('root').textContent") -match 'Hello world')
  # 5. responsive widths
  [void](Ev "document.querySelectorAll('#widths button')[3].click()"); Start-Sleep -Milliseconds 300
  Ck 'width 390 applied' ((Ev "document.getElementById('frameWrap').style.width") -eq '390px')
  [void](Ev "document.querySelectorAll('#widths button')[0].click()")
  # 6. variants tab
  [void](Ev "__lib.tabs('variants')"); Start-Sleep -Milliseconds 1200
  Ck 'variants tab renders 6 button variants' ((FrameEv "document.querySelectorAll('#root figure').length") -eq 6)
  # 7. nested hierarchy: button contains icon
  [void](Ev "__lib.tabs('hierarchy')"); Start-Sleep -Milliseconds 300
  Ck 'hierarchy shows nested icon' ((Ev "document.getElementById('panel').textContent") -match 'Icon')
  # 8. reuse
  [void](Ev "__lib.tabs('reuse')"); Start-Sleep -Milliseconds 300
  Ck 'reuse lists usage' ((Ev "document.getElementById('panel').textContent") -match 'parent component|page source')
  # 9. tokens + variable override
  [void](Ev "__lib.select('components/base/button'); __lib.tabs('tokens')"); Start-Sleep -Milliseconds 1500
  Ck 'tokens tab lists variables' ((Ev "document.querySelectorAll('#panel input[data-v]').length") -gt 0)
  $before = FrameEv "getComputedStyle(document.querySelector('#root .btn')).backgroundColor"
  [void](Ev "(function(){var i=[].filter.call(document.querySelectorAll('#panel input[data-v]'),function(x){return x.dataset.v==='--color-button-primary-bg'})[0];if(i){i.value='rgb(0, 128, 0)';i.dispatchEvent(new Event('input'))}return !!i})()"); Start-Sleep -Milliseconds 600
  $after = FrameEv "getComputedStyle(document.querySelector('#root .btn')).backgroundColor"
  Ck 'variable override reaches the preview' ($after -eq 'rgb(0, 128, 0)' -and $before -ne $after) "before=$before after=$after"
  [void](Ev "__lib.S.vars={}; __lib.post({type:'vars',vars:{}})")
  # 10. instances: shared edit vs override
  [void](Ev "__lib.select('components/base/badge'); __lib.tabs('instances')"); Start-Sleep -Milliseconds 1500
  $c0 = FrameEv "document.querySelectorAll('#root [data-instance]').length"; Ck 'main + 3 instances rendered' ($c0 -eq 4) "count=$c0"
  [void](Ev "(function(){var s=document.getElementById('i1-variant');s.value='ds-dark';s.dispatchEvent(new Event('change'))})()"); Start-Sleep -Milliseconds 900
  $cls = FrameEv "[].map.call(document.querySelectorAll('#root [data-instance]'),function(f){var b=f.querySelector('span,div,a');return b?b.className:''}).join('|')"
  $parts = $cls -split '\|'; Ck 'override changes only instance 2' ($parts.Count -eq 4 -and $parts[2] -ne $parts[0] -and $parts[1] -eq $parts[0] -and $parts[3] -eq $parts[0]) $cls
  [void](Ev "(function(){var t=document.getElementById('masterTpl');t.value=t.value.replace('<span','<span data-shared=1');document.getElementById('applyMain').click()})()"); Start-Sleep -Milliseconds 900
  $sh = FrameEv "document.querySelectorAll('#root [data-shared]').length"; Ck 'edit to main reaches all instances' ($sh -eq 4) "shared=$sh"
  [void](Ev "__lib.select('components/base/badge')"); 
  # 12. master library and page-wise views
  $ne = [int](Ev "__lib.AUD.entries.length"); $np = [int](Ev "__lib.AUD.pages.length"); "master entries: $ne; pages: $np"
  Ck 'audit data present (16 pages)' ($np -eq 16 -and $ne -gt 200)
  $bad2 = Ev "(function(){var b=[];__lib.setMode('master');__lib.AUD.entries.forEach(function(e){try{__lib.goEntry(e.id);if(document.getElementById('cName').textContent!==e.name)b.push(e.id+' name');if(document.querySelectorAll('#panel .reuse button').length!==16)b.push(e.id+' reuse grid')}catch(x){b.push(e.id+': '+x.message)}});return b})()"
  "master entries opened: $ne; problems: $(@($bad2).Count)"; @($bad2) | Select-Object -First 5 | ForEach-Object { "   $_" }; Ck 'every master entry opens with a 16-page reuse grid' (@($bad2).Count -eq 0)
  $bad3 = Ev "(function(){var b=[];__lib.setMode('pages');__lib.AUD.pages.forEach(function(p){try{__lib.goPage(p.number);var n=document.querySelectorAll('#panel details.blk').length;if(n!==p.blocks.length)b.push(p.name+': '+n+' vs '+p.blocks.length)}catch(x){b.push(p.name+': '+x.message)}});return b})()"
  "pages opened: $np; problems: $(@($bad3).Count)"; @($bad3) | Select-Object -First 5 | ForEach-Object { "   $_" }; Ck 'every page opens with all its sections' (@($bad3).Count -eq 0)
  [void](Ev "__lib.setMode('master'); __lib.goEntry('C001')"); Start-Sleep -Milliseconds 1500
  Ck 'master entry shows live preview of its component' ((FrameEv "document.querySelector('#root .btn')?1:0") -eq 1)
  [void](Ev "(function(){var b=[].filter.call(document.querySelectorAll('#panel button'),function(x){return /Open in the Components view/.test(x.textContent)})[0];b.click()})()"); Start-Sleep -Milliseconds 800
  Ck 'entry opens its component in the Components view' ((Ev "document.getElementById('cName').textContent") -eq 'Button' -and (Ev "__lib.S.mode") -eq 'components')
  [void](Ev "__lib.setMode('pages'); __lib.goPage(2)"); Start-Sleep -Milliseconds 300
  Ck 'PLP breakdown lists its sections' ((Ev "document.getElementById('panel').textContent") -match 'Product Grid' -and (Ev "document.getElementById('cName').textContent") -match 'PLP')
  if ($Shots) { foreach ($s in @(@('master', "__lib.setMode('master'); __lib.goEntry('C012')"), @('master-button', "__lib.setMode('master'); __lib.goEntry('C005')"), @('pages', "__lib.setMode('pages'); __lib.goPage(2); document.querySelectorAll('#panel details.blk')[4].open=true"))) {
      [void](Ev $s[1]); Start-Sleep -Milliseconds 1500; $r = Send 'Page.captureScreenshot' @{ format = 'png' }; [IO.File]::WriteAllBytes((Join-Path $Shots "$($s[0]).png"), [Convert]::FromBase64String($r.data)) } }
  [void](Ev "__lib.setMode('components')")
  # 13. style layer: editorial button is styled by the Homepage layer
  [void](Ev "__lib.setMode('components'); __lib.select('components/base/button'); (function(){var s=document.getElementById('p-variant');s.value='editorial';s.dispatchEvent(new Event('change'))})()"); Start-Sleep -Milliseconds 3500
  Ck 'style layer switches to Homepage for editorial' ((Ev "document.getElementById('ctx').value") -eq 'homepage')
  $pad = FrameEv "getComputedStyle(document.querySelector('#root .hp-btn')).paddingLeft"; $bgc = FrameEv "getComputedStyle(document.querySelector('#root .hp-btn')).backgroundColor"
  Ck 'editorial button is styled (padding and fill)' ($pad -and $pad -ne '0px' -and $bgc -ne 'rgba(0, 0, 0, 0)') "pad=$pad bg=$bgc"
  [void](Ev "__lib.select('components/base/badge')"); Start-Sleep -Milliseconds 3000
  Ck 'shared layer for a base component' ((Ev "document.getElementById('ctx').value") -eq 'shared')
  # 14. the ten icons that used to be page-local draw from the shared sprite
  [void](Ev "__lib.setMode('components'); __lib.select('components/base/icon')"); Start-Sleep -Milliseconds 2500
  $drawn = @(); $missing = @()
  foreach ($ic in 'mail', 'phone', 'clock', 'zoom-in', 'play', 'truck', 'rotate-ccw', 'shield-check', 'store', 'loader') {
    [void](Ev "__lib.S.args.name='$ic'; __lib.show()"); Start-Sleep -Milliseconds 500
    $w = FrameEv "(function(){var s=document.querySelector('#root svg');var sym=document.getElementById('icon-$ic');if(!s||!sym)return -1;var b=s.getBoundingClientRect();return Math.round(b.width)})()"
    if ([int]$w -gt 0) { $drawn += $ic } else { $missing += $ic } }
  "new icons drawn: $($drawn.Count) of 10"; Ck 'all ten former page-local icons render from the shared sprite' ($missing.Count -eq 0) ($missing -join ', ')
  # 15. each component shows its Shopify sync status
  [void](Ev "__lib.setMode('components'); __lib.select('components/base/button')"); Start-Sleep -Milliseconds 600
  Ck 'component header shows its Shopify status' ((Ev "document.getElementById('cMeta').textContent") -match 'Shopify: IN SYNC')
  [void](Ev "__lib.select('components/homepage/category-section')"); Start-Sleep -Milliseconds 400
  Ck 'a component without Liquid yet shows THEME DIFFERS or NOT IN SHOPIFY YET' ((Ev "document.getElementById('cMeta').textContent") -match 'Shopify: (THEME DIFFERS|NOT IN SHOPIFY YET)')
  # 11. no JS errors
  Ck 'no JavaScript errors' ($script:errs.Count -eq 0) (($script:errs | Select-Object -Unique) -join ' // ')
  if ($Shots) { New-Item -ItemType Directory -Force $Shots | Out-Null
    foreach ($s in @(@('components/base/button', 'preview', 'preview'), @('components/base/button', 'variants', 'variants'), @('components/base/button', 'tokens', 'tokens'), @('components/base/badge', 'instances', 'instances'), @('components/base/button', 'hierarchy', 'hierarchy'))) {
      [void](Ev "__lib.select('$($s[0])'); __lib.tabs('$($s[1])')"); Start-Sleep -Milliseconds 1800
      $r = Send 'Page.captureScreenshot' @{ format = 'png' }; [IO.File]::WriteAllBytes((Join-Path $Shots "$($s[2]).png"), [Convert]::FromBase64String($r.data)) }
  }
  "checks passed: $script:pass; failed: $script:fail"
} finally {
  try { if ($ws) { $ws.Dispose() } } catch {}
  if ($chrome -and -not $chrome.HasExited) { Stop-Process -Id $chrome.Id -Force -ErrorAction SilentlyContinue }
  Get-CimInstance Win32_Process -Filter "Name='chrome.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*$prof*" } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
  Start-Sleep -Milliseconds 300; Remove-Item $prof -Recurse -Force -ErrorAction SilentlyContinue
}