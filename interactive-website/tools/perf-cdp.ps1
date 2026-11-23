# Measured performance via the Chrome DevTools Protocol (no Lighthouse is installed here, so nothing is claimed from Lighthouse).
# For each page, mode (original = interactive layer OFF, interactive = ON) and profile (desktop 1440x900 unthrottled; mobile 390x844 with 4x CPU slowdown) it records:
#   FCP, LCP, CLS, TBT (sum of long-task time over 50 ms between FCP and load + 2 s), INP-style interaction latency of a real click, DOM nodes, script and stylesheet counts, request count and bytes (from disk, as the pages load from file://).
# Network is local, so load times exclude real network latency: compare modes against each other, not against Lighthouse field scores.
# Usage: .\tools\perf-cdp.ps1 [-Pages home,collection,...] [-Out perf.json]
param([string[]]$Pages = @('home', 'collection', 'product', 'cart', 'blog', 'article'), [string]$Out = 'perf.json', [int]$Runs = 1)
$ErrorActionPreference = 'Stop'
$IW = Split-Path -Parent $PSScriptRoot; $PRJ = Split-Path -Parent $IW; $WF = Join-Path $PRJ '03-Wireframes'; $utf8 = New-Object Text.UTF8Encoding($false)
$files = @{ home = '01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html'; collection = '02-NUDGE-Beauty-PLP-Wireframe/PLP.html?c=skin'; product = '03-NUDGE-Beauty-PDP-Wireframe/PDP.html?p=face-serum'; cart = '04-NUDGE-Beauty-Cart-Wireframe/Cart_Page.html'; blog = '14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html'; article = '15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html?a=what-is-niacinamide' }
$obs = @'
(function(){var P=window.__perf={fcp:0,lcp:0,cls:0,long:[],ev:[]};
try{new PerformanceObserver(function(l){l.getEntries().forEach(function(e){if(e.name==='first-contentful-paint')P.fcp=e.startTime})}).observe({type:'paint',buffered:true})}catch(e){}
try{new PerformanceObserver(function(l){l.getEntries().forEach(function(e){P.lcp=e.startTime})}).observe({type:'largest-contentful-paint',buffered:true})}catch(e){}
try{new PerformanceObserver(function(l){l.getEntries().forEach(function(e){if(!e.hadRecentInput){P.cls+=e.value;(P.sh=P.sh||[]).push([+e.value.toFixed(3),Math.round(e.startTime),(e.sources||[]).slice(0,3).map(function(s){return s.node?(s.node.nodeName+'#'+(s.node.id||'')+'.'+String(s.node.className&&s.node.className.baseVal!==undefined?'':s.node.className||'').slice(0,50)):'?'})])}})}).observe({type:'layout-shift',buffered:true})}catch(e){}
try{new PerformanceObserver(function(l){l.getEntries().forEach(function(e){P.long.push([e.startTime,e.duration])})}).observe({type:'longtask',buffered:true})}catch(e){}
try{new PerformanceObserver(function(l){l.getEntries().forEach(function(e){P.ev.push([e.name,e.duration])})}).observe({type:'event',durationThreshold:16,buffered:true})}catch(e){}})();
'@
function Open-Cdp($port, $w, $h, $mobile, $cpu) {
  $prof = Join-Path ([IO.Path]::GetTempPath()) ("nudge-perf-" + [guid]::NewGuid().ToString('N').Substring(0, 8)); New-Item -ItemType Directory -Force $prof | Out-Null
  $cargs = @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', "--remote-debugging-port=$port", "--user-data-dir=`"$prof`"", "--window-size=$w,$h", 'about:blank')
  $proc = Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList $cargs -PassThru -RedirectStandardError (Join-Path $prof 'err.txt')
  $list = $null; for ($i = 0; $i -lt 40; $i++) { Start-Sleep -Milliseconds 250; try { $list = Invoke-RestMethod "http://127.0.0.1:$port/json/list" -TimeoutSec 2; if (@($list | Where-Object { $_.type -eq 'page' }).Count) { break } } catch { } }
  $pg = @($list | Where-Object { $_.type -eq 'page' })[0]; if (-not $pg) { try { $proc.Kill() } catch { }; throw ('no page target; targets=' + (@($list | ForEach-Object { $_.type }) -join ',') + ' exited=' + $proc.HasExited + ' err=' + ((Get-Content (Join-Path $prof 'err.txt') -ErrorAction SilentlyContinue | Select-Object -First 3) -join ' | ')) }
  $ws = New-Object System.Net.WebSockets.ClientWebSocket; $ws.ConnectAsync([Uri]$pg.webSocketDebuggerUrl, [Threading.CancellationToken]::None).Wait()
  [pscustomobject]@{ ws = $ws; proc = $proc; prof = $prof; id = 0; events = (New-Object Collections.ArrayList) }
}
function Send($c, $method, $params) {
  $c.id++; $id = $c.id; $msg = @{ id = $id; method = $method; params = $(if ($params) { $params } else { @{} }) } | ConvertTo-Json -Depth 8 -Compress
  $bytes = [Text.Encoding]::UTF8.GetBytes($msg); $c.ws.SendAsync([ArraySegment[byte]]$bytes, 'Text', $true, [Threading.CancellationToken]::None).Wait()
  $buf = New-Object byte[] 1048576
  while ($true) {
    $sb = New-Object Text.StringBuilder
    do { $seg = [ArraySegment[byte]]$buf; $rt = $c.ws.ReceiveAsync($seg, [Threading.CancellationToken]::None); if (-not $rt.Wait(20000)) { throw "CDP timeout waiting for $method" }; $r = $rt.Result; [void]$sb.Append([Text.Encoding]::UTF8.GetString($buf, 0, $r.Count)) } until ($r.EndOfMessage)
    $o = $sb.ToString() | ConvertFrom-Json
    if ($o.id -eq $id) { if ($o.error) { throw "CDP $method : $($o.error.message)" }; return $o.result } else { [void]$c.events.Add($o) }
  }
}
function Drain($c, $ms) { $end = (Get-Date).AddMilliseconds($ms); $buf = New-Object byte[] 1048576; while ((Get-Date) -lt $end) { $t = $c.ws.ReceiveAsync([ArraySegment[byte]]$buf, [Threading.CancellationToken]::None); if (-not $t.Wait(200)) { break } } }
function Close-Cdp($c) { try { [void]$c.ws.CloseAsync('NormalClosure', '', [Threading.CancellationToken]::None).Wait(1000) } catch { }; try { if (-not $c.proc.HasExited) { $c.proc.Kill() } } catch { }; Start-Sleep -Milliseconds 300; try { Remove-Item $c.prof -Recurse -Force -ErrorAction SilentlyContinue } catch { } }
$rows = @(); $port = 9600
foreach ($pg in $Pages) { foreach ($mode in 'original', 'interactive') { foreach ($prof in 'desktop', 'mobile') {
  for ($run = 1; $run -le $Runs; $run++) {
    $port++; if ($port -gt 9990) { $port = 9601 }
    $w = if ($prof -eq 'desktop') { 1440 } else { 390 }; $h = if ($prof -eq 'desktop') { 900 } else { 844 }
    $c = Open-Cdp $port $w $h ($prof -eq 'mobile') 0
    try {
      Send $c 'Page.enable' $null | Out-Null; Send $c 'Runtime.enable' $null | Out-Null; Send $c 'Network.enable' $null | Out-Null
      Send $c 'Emulation.setDeviceMetricsOverride' @{ width = $w; height = $h; deviceScaleFactor = $(if ($prof -eq 'mobile') { 2 } else { 1 }); mobile = ($prof -eq 'mobile') } | Out-Null
      if ($prof -eq 'mobile') { Send $c 'Emulation.setCPUThrottlingRate' @{ rate = 4 } | Out-Null }
      Send $c 'Page.addScriptToEvaluateOnNewDocument' @{ source = $obs } | Out-Null
      $rel = $files[$pg]; $sep = if ($rel -match '\?') { '&' } else { '?' }
      $u = 'file:///' + (($WF -replace '\\', '/') -replace ' ', '%20') + '/' + $rel + $(if ($mode -eq 'interactive') { $sep + 'ix=1' } else { '' })
      $t0 = Get-Date; Send $c 'Page.navigate' @{ url = $u } | Out-Null
      Start-Sleep -Milliseconds 2500; for ($w8 = 0; $w8 -lt 40; $w8++) { $st = (Send $c 'Runtime.evaluate' @{ expression = '(document.readyState==="complete"&&window.__perf&&window.__perf.fcp>0&&(!/ix=1/.test(location.search)||document.documentElement.getAttribute("data-ix")))?"y":"n"'; returnByValue = $true }).result.value; if ($st -eq 'y') { break }; Start-Sleep -Milliseconds 1000 }; Start-Sleep -Milliseconds 2500
      $js = '(function(){var P=window.__perf,n=performance.getEntriesByType("navigation")[0],res=performance.getEntriesByType("resource").map(function(r){return r.name}),fc=P.fcp,tbt=0;P.long.forEach(function(l){if(l[0]>=fc)tbt+=Math.max(0,l[1]-50)});return JSON.stringify({fcp:Math.round(P.fcp),lcp:Math.round(P.lcp),cls:+P.cls.toFixed(4),tbt:Math.round(tbt),dcl:Math.round(n.domContentLoadedEventEnd),load:Math.round(n.loadEventEnd),nodes:document.getElementsByTagName("*").length,scripts:document.scripts.length,styles:document.querySelectorAll("style,link[rel=stylesheet]").length,imgs:document.images.length,sh:(P.sh||[]).slice(0,6),ix:document.documentElement.getAttribute("data-ix")||"",res:res})})()'
      $m = (Send $c 'Runtime.evaluate' @{ expression = $js; returnByValue = $true }).result.value | ConvertFrom-Json
      # INP-style: real mouse click on the header search link (or Add to bag on the PDP)
      $sel = if ($pg -eq 'product') { '#atc' } else { '#site-header a[href=\"#search\"]' }
      $rect = (Send $c 'Runtime.evaluate' @{ expression = "(function(){var e=[].slice.call(document.querySelectorAll('$($sel -replace '\\"','"')')).filter(function(x){var r=x.getBoundingClientRect();return r.width>0&&r.height>0})[0];if(!e)return '';var r=e.getBoundingClientRect();return JSON.stringify([r.left+r.width/2,r.top+r.height/2])})()"; returnByValue = $true }).result.value
      $inp = $null
      if ($rect) { $xy = $rect | ConvertFrom-Json
        Send $c 'Input.dispatchMouseEvent' @{ type = 'mousePressed'; x = $xy[0]; y = $xy[1]; button = 'left'; clickCount = 1 } | Out-Null; Send $c 'Input.dispatchMouseEvent' @{ type = 'mouseReleased'; x = $xy[0]; y = $xy[1]; button = 'left'; clickCount = 1 } | Out-Null
        Start-Sleep -Milliseconds 1200; $e = (Send $c 'Runtime.evaluate' @{ expression = 'JSON.stringify(window.__perf.ev.map(function(x){return x[1]}))'; returnByValue = $true }).result.value | ConvertFrom-Json; if ($e) { $inp = [int](($e | Measure-Object -Maximum).Maximum) } else { $inp = 0 } }
      $bytes = 0; $reqs = 0; $byType = @{}; $reqUrls = @($c.events | Where-Object { $_.method -eq 'Network.requestWillBeSent' } | ForEach-Object { $_.params.request.url } | Select-Object -Unique); foreach ($r in $reqUrls) { $reqs++; if ($r -match '^file:///') { $lp = [Uri]::UnescapeDataString((($r -replace '^file:///', '') -replace '\?.*$', '')); if (Test-Path $lp) { $len = (Get-Item $lp).Length; $bytes += $len; $ext = [IO.Path]::GetExtension($lp).ToLower(); $byType[$ext] = [int]$byType[$ext] + $len } } }
      $docLen = (Get-Item ([Uri]::UnescapeDataString((($u -replace '^file:///', '') -replace '\?.*$', '')))).Length
      $rows += [pscustomobject]@{ page = $pg; mode = $mode; profile = $prof; run = $run; fcp = $m.fcp; lcp = $m.lcp; cls = $m.cls; tbt = $m.tbt; inp = $inp; dcl = $m.dcl; load = $m.load; nodes = $m.nodes; scripts = $m.scripts; styles = $m.styles; images = $m.imgs; requests = $reqs; htmlBytes = $docLen; subBytes = $bytes; jsBytes = [int]$byType['.js']; cssBytes = [int]$byType['.css']; fontBytes = [int]$byType['.woff2'] + [int]$byType['.woff']; layer = $m.ix; shifts = ($m.sh | ConvertTo-Json -Compress -Depth 4) }
      "{0,-10} {1,-11} {2,-7} FCP {3,5} LCP {4,5} CLS {5} TBT {6,4} INP {7,4} nodes {8} req {9} KB {10}" -f $pg, $mode, $prof, $m.fcp, $m.lcp, $m.cls, $m.tbt, $inp, $m.nodes, $reqs, [Math]::Round($bytes / 1KB)
    } catch { "ERROR $pg $mode $prof : $_" } finally { Close-Cdp $c }
  } } } }
$dir = Join-Path $IW 'documentation\data'; New-Item -ItemType Directory -Force $dir | Out-Null
[IO.File]::WriteAllText((Join-Path $dir $Out), ($rows | ConvertTo-Json -Depth 4), $utf8); "rows: $($rows.Count) -> documentation/data/$Out"
