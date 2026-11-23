<#
  NUDGE: browser-emulation tests (Chrome or Edge, driven over the DevTools protocol)

  Run:  powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Tokens/test-emulation.ps1 [-OutDir <folder for screenshots>]

  Covers what a plain headless load cannot:
    M  MOBILE + TOUCH: a real 390 x 844 phone viewport (device pixel ratio 3, viewport meta honored,
       pointer: coarse, hover: none). No horizontal overflow; hover-only effects do not apply; every
       interactive element still measures 44 x 44px (box or hit area).
    R  REDUCED MOTION: with prefers-reduced-motion: reduce, transitions collapse to ~0.
    F  FORCED COLORS (Windows high-contrast emulation): focus ring visible; checked checkbox/radio marks,
       the current page, selected chips and swatches and badges stay distinguishable without their colors.
    C  CHIP ROW (phone): real Tab and a real touch swipe scroll the row; a chip is cut off at the edge.
    D  DRAWER (phone sheet at 390px, side panel at 1280px), with REAL key, wheel and mouse events: Enter opens a
       modal dialog, focus moves in, Tab and Shift+Tab wrap, focus on the page behind is refused, the page does not
       scroll behind it, the body scrolls on its own, Escape / close button / action / scrim each close it and focus
       returns to the opener; the accessibility tree exposes a dialog named "Filters".
    L  LOAD MORE (phone): real taps; loading, success, failure and retry states, focus, status text, address bar.
       The loader is the showcase's stub: the default fetch loader and Shopify URLs are not exercised.
    P  PROGRESSIVE ENHANCEMENT of product-card focus: with the :has() branch disabled, the title link
       must still show a focus ring.

  This is emulation inside Blink. It is NOT Firefox, Safari, a real phone, or a screen reader.
  Exit code 0 = all passed, 1 = a check failed, 2 = could not run. Nothing in the project is modified.
#>
param([string]$OutDir = '', [string]$BrowserPath = '')
$ErrorActionPreference = 'Stop'
$dv = Split-Path -Parent $PSScriptRoot
$proj = Split-Path -Parent $dv
$browser = @("$env:ProgramFiles\Google\Chrome\Application\chrome.exe", "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe", "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe", "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe") | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
if ($BrowserPath) { $browser = $BrowserPath }
if (-not $browser) { Write-Host 'No Chrome or Edge found.'; exit 2 }
function FileUrl([string]$p) { 'file:///' + ($p -replace '\\', '/').Replace(' ', '%20') }
$dsUrl = FileUrl (Join-Path $proj '01-Design-System\index.html')
$dashUrl = FileUrl (Join-Path $dv 'Preview\index.html')
if ($OutDir) { New-Item -ItemType Directory -Force $OutDir | Out-Null }

# ---- start the browser and connect ----
$port = Get-Random -Minimum 9340 -Maximum 9480
$prof = Join-Path ([IO.Path]::GetTempPath()) ("nudge-emu-" + [guid]::NewGuid().ToString('N').Substring(0, 6)); New-Item -ItemType Directory $prof | Out-Null
$proc = Start-Process -FilePath $browser -ArgumentList @('--headless=new', '--disable-gpu', "--remote-debugging-port=$port", '--remote-allow-origins=*', "--user-data-dir=`"$prof`"", '--no-first-run', '--allow-file-access-from-files', 'about:blank') -PassThru -WindowStyle Hidden
$ws = $null
for ($i = 0; $i -lt 30 -and -not $ws; $i++) { Start-Sleep -Milliseconds 500; try { Invoke-RestMethod "http://127.0.0.1:$port/json/version" -TimeoutSec 2 | Out-Null; $ws = 'ready' } catch {} }
if (-not $ws) { Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue; Write-Host 'Could not reach the browser DevTools endpoint.'; exit 2 }
Start-Sleep -Seconds 2   # let the browser finish its own startup tabs, then drive a fresh tab of our own
$tab = Invoke-RestMethod -Method Put -Uri "http://127.0.0.1:$port/json/new?about:blank" -TimeoutSec 5
$ws = @($tab.webSocketDebuggerUrl)[0]
$sock = New-Object System.Net.WebSockets.ClientWebSocket
$sock.ConnectAsync([Uri]$ws, [Threading.CancellationToken]::None).Wait()
$script:id = 0
function Send([string]$method, $params = @{}) {
  $script:id++; $myId = $script:id; if ($env:NUDGE_TRACE) { Write-Host "   > $method" }
  $json = @{ id = $myId; method = $method; params = $params } | ConvertTo-Json -Depth 10 -Compress
  $b = [Text.Encoding]::UTF8.GetBytes($json)
  $sock.SendAsync((New-Object System.ArraySegment[byte] -ArgumentList (, $b)), [Net.WebSockets.WebSocketMessageType]::Text, $true, [Threading.CancellationToken]::None).Wait()
  while ($true) {
    $buf = New-Object byte[] 1048576; $ms = New-Object IO.MemoryStream
    do { $cts = New-Object Threading.CancellationTokenSource 30000; try { $r = $sock.ReceiveAsync((New-Object System.ArraySegment[byte] -ArgumentList (, $buf)), $cts.Token).Result } catch { throw "Timed out (30s) waiting for a reply to $method" }; $ms.Write($buf, 0, $r.Count) } while (-not $r.EndOfMessage)
    $m = [Text.Encoding]::UTF8.GetString($ms.ToArray()) | ConvertFrom-Json
    if ($m.id -eq $myId) { if ($m.error) { throw "CDP $method failed: $($m.error.message)" }; return $m }
  }
}
function Js([string]$expr) { $r = Send 'Runtime.evaluate' @{ expression = $expr; returnByValue = $true; awaitPromise = $true }; if ($r.result.exceptionDetails) { throw "JS error: $($r.result.exceptionDetails.exception.description)" }; return $r.result.result.value }
function Go([string]$url) { $nav = Send 'Page.navigate' @{ url = $url }; if ($env:NUDGE_TRACE) { Write-Host "   navigate -> $url ; response: $($nav.result | ConvertTo-Json -Compress -Depth 3)" }; for ($i = 0; $i -lt 40; $i++) { Start-Sleep -Milliseconds 250; if ((Js 'document.readyState') -eq 'complete') { break } }; Start-Sleep -Milliseconds 900; if ($env:NUDGE_TRACE) { Write-Host "   now at: $(Js 'location.href')" } }
function Shot([string]$name) { if ($OutDir) { $r = Send 'Page.captureScreenshot' @{ format = 'png'; captureBeyondViewport = $false }; [IO.File]::WriteAllBytes((Join-Path $OutDir "$name.png"), [Convert]::FromBase64String($r.result.data)) } }
$fail = 0
function Report([string]$group, $rows) { Write-Host "`n$group"; foreach ($r in $rows) { $tag = if ($r.ok -eq $true) { 'PASS' } elseif ($r.ok -eq $false) { $script:fail++; 'FAIL' } else { 'INFO' }; Write-Host ("   {0,-66} {1}  {2}" -f $r.name, $tag, $r.detail) } }

$touchAudit = @'
(function(){ var off=[],n=0; function hit(el){var r=el.getBoundingClientRect(),w=r.width,h=r.height;['::after','::before'].forEach(function(ps){var s=getComputedStyle(el,ps);if(s.position==='absolute'&&s.content!=='none'){w=Math.max(w,parseFloat(s.width)||0);h=Math.max(h,parseFloat(s.height)||0);}});return [w,h];}
 document.querySelectorAll('a[href], button, input:not([type=hidden]), select, textarea, summary, [role=button]').forEach(function(el){var cs=getComputedStyle(el);
  if(el.disabled||el.getAttribute('aria-disabled')==='true'||el.classList.contains('skip-link')||el.closest('.visually-hidden'))return;
  var t=el; if((el.type==='checkbox'||el.type==='radio')&&el.closest('label'))t=el.closest('label'); var r=t.getBoundingClientRect(); if(!r.width&&!r.height)return;
  if(el.tagName==='A'&&cs.display==='inline'&&/\S/.test((el.parentElement.textContent||'').replace(el.textContent,'')))return;
  n++; var h=hit(t); if(h[0]<43.5||h[1]<43.5) off.push(el.tagName+'.'+el.className+' '+Math.round(h[0])+'x'+Math.round(h[1]));});
 return JSON.stringify({n:n,off:off.slice(0,8)}); })()
'@

try {
  # ---------------- M: mobile + touch ----------------
  Send 'Page.enable' | Out-Null
  Send 'Emulation.setFocusEmulationEnabled' @{ enabled = $true } | Out-Null   # the page counts as focused, so :focus-visible applies
  Send 'Emulation.setDeviceMetricsOverride' @{ width = 390; height = 844; deviceScaleFactor = 3; mobile = $true } | Out-Null
  Send 'Emulation.setTouchEmulationEnabled' @{ enabled = $true; maxTouchPoints = 5 } | Out-Null
  $rows = @()
  foreach ($pg in @(@('Design System showcase', $dsUrl, 'ds'), @('Token dashboard', $dashUrl, 'dash'))) {
    Go $pg[1]
    $m = (Js "JSON.stringify({w:innerWidth,dpr:devicePixelRatio,sw:document.documentElement.scrollWidth,coarse:matchMedia('(pointer: coarse)').matches,hover:matchMedia('(hover: hover)').matches})") | ConvertFrom-Json
    $rows += [pscustomobject]@{ name = "$($pg[0]): layout viewport is 390px, DPR 3, coarse pointer, no hover"; ok = ($m.w -eq 390 -and $m.dpr -eq 3 -and $m.coarse -and -not $m.hover); detail = "innerWidth=$($m.w) dpr=$($m.dpr) coarse=$($m.coarse) hover=$($m.hover)" }
    $rows += [pscustomobject]@{ name = "$($pg[0]): no horizontal overflow"; ok = ($m.sw -le 390); detail = "scrollWidth=$($m.sw)" }
    Shot "mobile-$($pg[2])"
  }
  Go $dsUrl
  $ta = (Js $touchAudit) | ConvertFrom-Json
  $rows += [pscustomobject]@{ name = 'Design System: every interactive element is 44 x 44px under touch emulation'; ok = ($ta.off.Count -eq 0); detail = "$($ta.n) measured; below 44px: $(if ($ta.off.Count) { $ta.off -join ' | ' } else { 'none' })" }
  $hv = (Js "(function(){var el=document.querySelector('.product-card .ratio > *'); return el ? getComputedStyle(el).transform : ('no element on ' + location.pathname.split('/').slice(-2).join('/') + ' title=' + document.title + ' cards=' + document.querySelectorAll('.product-card').length);})()")
  $rows += [pscustomobject]@{ name = 'Hover-only image zoom does not apply on a touch device'; ok = ($hv -eq 'none'); detail = "transform=$hv" }
  Report 'M. Mobile + touch emulation (390 x 844, DPR 3)' $rows
  Send 'Emulation.setTouchEmulationEnabled' @{ enabled = $false } | Out-Null
  Send 'Emulation.clearDeviceMetricsOverride' | Out-Null

  # ---------------- R: reduced motion ----------------
  Send 'Emulation.setEmulatedMedia' @{ features = @(@{ name = 'prefers-reduced-motion'; value = 'reduce' }) } | Out-Null
  Go $dsUrl
  $td = (Js "(function(){var b=document.querySelector('.btn'),c=document.querySelector('.accordion__summary .icon');return JSON.stringify({btn:getComputedStyle(b).transitionDuration,icon:getComputedStyle(c).transitionDuration,rm:matchMedia('(prefers-reduced-motion: reduce)').matches});})()") | ConvertFrom-Json
  $secs = { param($s) ($s -split ',')[0].Trim() -replace 's$', '' }
  Report 'R. Reduced motion' @(
    [pscustomobject]@{ name = 'prefers-reduced-motion: reduce is active'; ok = $td.rm; detail = '' },
    [pscustomobject]@{ name = 'Button transition collapses to ~0'; ok = ([double](& $secs $td.btn) -lt 0.001); detail = $td.btn },
    [pscustomobject]@{ name = 'Accordion icon transition collapses to ~0'; ok = ([double](& $secs $td.icon) -lt 0.001); detail = $td.icon })
  Send 'Emulation.setEmulatedMedia' @{ features = @(@{ name = 'prefers-reduced-motion'; value = 'no-preference' }) } | Out-Null

  # ---------------- F: forced colors ----------------
  Send 'Emulation.setEmulatedMedia' @{ features = @(@{ name = 'forced-colors'; value = 'active' }) } | Out-Null
  Go $dsUrl
  $fc = (Js @'
(function(){
 var o={}, q=function(s){return document.querySelector(s)}, cs=function(e,p){return getComputedStyle(e,p)};
 o.active=matchMedia('(forced-colors: active)').matches;
 var b=q('.btn--primary'); b.focus(); var f=cs(b); o.focus={style:f.outlineStyle,width:f.outlineWidth,color:f.outlineColor}; b.blur();
 var cb=q('.choice__input[type=checkbox]:checked'); o.check={box:cs(cb).backgroundColor,mark:cs(cb,'::before').backgroundColor,adjust:cs(cb,'::before').forcedColorAdjust};
 var rd=q('.choice__input[type=radio]:checked'); o.radio={box:cs(rd).backgroundColor,mark:cs(rd,'::before').backgroundColor};
 var cur=q('.pagination__link[aria-current=page]'), oth=q('.pagination__link:not([aria-current]):not([aria-disabled])'); o.page={cur:{bw:cs(cur).borderTopWidth,fw:cs(cur).fontWeight,td:cs(cur).textDecorationLine},oth:{bw:cs(oth).borderTopWidth,fw:cs(oth).fontWeight,td:cs(oth).textDecorationLine}}; var bc=q('.breadcrumb__item:last-child'); o.sep={mark:cs(bc,'::before').backgroundColor,page:cs(document.body).backgroundColor,rendered:bc.getClientRects().length>0};
 var cp=q('.chip[aria-pressed=true]:not(:has(.icon))'), cn=q('.chip[aria-pressed=false]'); o.chip={on:{bw:cs(cp).borderTopWidth,bg:cs(cp).backgroundColor,mark:cs(cp,'::before').content,markBg:cs(cp,'::before').backgroundColor},off:{bw:cn?cs(cn).borderTopWidth:'',bg:cn?cs(cn).backgroundColor:''}};
 var sw=q('.swatch__input:checked + .swatch__chip'), su=q('.swatch__input:not(:checked):not(:disabled) + .swatch__chip'); o.swatch={on:{ow:cs(sw).outlineWidth,os:cs(sw).outlineStyle,oc:cs(sw).outlineColor},off:{ow:cs(su).outlineWidth,os:cs(su).outlineStyle,oc:cs(su).outlineColor},bg:cs(sw).backgroundColor};
 var bd=q('.badge--brand'); o.badge={bg:cs(bd).backgroundColor,bw:cs(bd).borderTopWidth,color:cs(bd).color};
 var st=q('.rating__stars .icon.icon--filled'), se=q('.rating__stars .icon:not(.icon--filled)'); o.star={on:{fill:cs(st).fill,stroke:cs(st).stroke},off:{fill:cs(se).fill,stroke:cs(se).stroke}};
 return JSON.stringify(o); })()
'@) | ConvertFrom-Json
  Shot 'forced-colors-ds'
  $rows = @()
  $rows += [pscustomobject]@{ name = 'forced-colors: active is emulated'; ok = $fc.active; detail = '' }
  $rows += [pscustomobject]@{ name = 'Focus ring is still a visible outline'; ok = ($fc.focus.style -eq 'solid' -and [double]($fc.focus.width -replace 'px', '') -ge 2); detail = "$($fc.focus.width) $($fc.focus.style) $($fc.focus.color)" }
  $rows += [pscustomobject]@{ name = 'Checked checkbox: mark differs from its box'; ok = ($fc.check.mark -ne $fc.check.box); detail = "box=$($fc.check.box) mark=$($fc.check.mark)" }
  $rows += [pscustomobject]@{ name = 'Checked radio: dot differs from its box'; ok = ($fc.radio.mark -ne $fc.radio.box); detail = "box=$($fc.radio.box) dot=$($fc.radio.mark)" }
  $pgDiff = ($fc.page.cur.bw -ne $fc.page.oth.bw) -or ($fc.page.cur.fw -ne $fc.page.oth.fw) -or ($fc.page.cur.td -ne $fc.page.oth.td)
  $rows += [pscustomobject]@{ name = 'Current pagination page differs from other pages (border, weight or underline)'; ok = $pgDiff; detail = "current border=$($fc.page.cur.bw) weight=$($fc.page.cur.fw) decoration=$($fc.page.cur.td); other border=$($fc.page.oth.bw) weight=$($fc.page.oth.fw) decoration=$($fc.page.oth.td)" }
  $chipDiff = ($fc.chip.on.mark -ne 'none' -and $fc.chip.on.markBg -ne $fc.chip.on.bg) -or ($fc.chip.on.bw -ne $fc.chip.off.bw)
  $rows += [pscustomobject]@{ name = 'Selected chip is distinguishable (visible check mark or a thicker border)'; ok = $chipDiff; detail = "on: border=$($fc.chip.on.bw) mark bg=$($fc.chip.on.markBg) chip bg=$($fc.chip.on.bg); off: border=$($fc.chip.off.bw)" }
  $rows += [pscustomobject]@{ name = 'Breadcrumb separators are visible against the page'; ok = ($fc.sep.rendered -and ($fc.sep.mark -ne $fc.sep.page)); detail = "separator=$($fc.sep.mark) page=$($fc.sep.page)" }
  $rows += [pscustomobject]@{ name = 'Selected swatch ring is visible, unselected is not'; ok = ($fc.swatch.on.os -eq 'solid' -and [double]($fc.swatch.on.ow -replace 'px', '') -ge 2 -and ($fc.swatch.off.os -eq 'none' -or $fc.swatch.off.oc -eq 'rgba(0, 0, 0, 0)' -or $fc.swatch.off.oc -ne $fc.swatch.on.oc)); detail = "on: $($fc.swatch.on.ow) $($fc.swatch.on.os) $($fc.swatch.on.oc); off: $($fc.swatch.off.ow) $($fc.swatch.off.os) $($fc.swatch.off.oc)" }
  $rows += [pscustomobject]@{ name = 'Filled vs empty rating star remain distinguishable'; ok = ($fc.star.on.fill -ne $fc.star.off.fill); detail = "filled fill=$($fc.star.on.fill); empty fill=$($fc.star.off.fill)" }
  $rows += [pscustomobject]@{ name = 'Brand badge text stays legible (label is text)'; ok = $null; detail = "bg=$($fc.badge.bg) border=$($fc.badge.bw) text=$($fc.badge.color)" }
  Report 'F. Forced colors (Windows high-contrast emulation)' $rows
  Send 'Emulation.setEmulatedMedia' @{ features = @(@{ name = 'forced-colors'; value = 'none' }) } | Out-Null

  # ---------------- C / D / L: interaction tests with REAL input events (keys, wheel, touch) ----------------
  Send 'Emulation.setEmulatedMedia' @{ features = @() } | Out-Null
  function Key([string]$key, [string]$code, [int]$vk, [int]$mods = 0, [string]$text = '') {
    $d = @{ type = $(if ($text) { 'keyDown' } else { 'rawKeyDown' }); key = $key; code = $code; windowsVirtualKeyCode = $vk; nativeVirtualKeyCode = $vk; modifiers = $mods }
    if ($text) { $d.text = $text; $d.unmodifiedText = $text }
    Send 'Input.dispatchKeyEvent' $d | Out-Null
    Send 'Input.dispatchKeyEvent' @{ type = 'keyUp'; key = $key; code = $code; windowsVirtualKeyCode = $vk; nativeVirtualKeyCode = $vk; modifiers = $mods } | Out-Null
    Start-Sleep -Milliseconds 120
  }
  function Tab([bool]$shift = $false) { Key 'Tab' 'Tab' 9 $(if ($shift) { 8 } else { 0 }) }
  function Viewport([int]$w, [int]$h, [bool]$phone) {
    if ($phone) { Send 'Emulation.setDeviceMetricsOverride' @{ width = $w; height = $h; deviceScaleFactor = 3; mobile = $true } | Out-Null; Send 'Emulation.setTouchEmulationEnabled' @{ enabled = $true; maxTouchPoints = 5 } | Out-Null }
    else { Send 'Emulation.setDeviceMetricsOverride' @{ width = $w; height = $h; deviceScaleFactor = 1; mobile = $false } | Out-Null; Send 'Emulation.setTouchEmulationEnabled' @{ enabled = $false } | Out-Null }
  }
  function Center([string]$sel) {
    (Js ("(function(){var e=document.querySelector('" + $sel + "'); e.scrollIntoView({block:'center',behavior:'instant'}); var r=e.getBoundingClientRect(); return JSON.stringify({x:r.left+r.width/2,y:r.top+r.height/2,w:r.width,h:r.height});})()")) | ConvertFrom-Json
  }
  function TouchTap([double]$x, [double]$y) {
    Send 'Input.dispatchTouchEvent' @{ type = 'touchStart'; touchPoints = @(@{ x = $x; y = $y; id = 1 }) } | Out-Null
    Start-Sleep -Milliseconds 50
    Send 'Input.dispatchTouchEvent' @{ type = 'touchEnd'; touchPoints = @() } | Out-Null
  }
  function Tap([string]$sel) { $c = Center $sel; TouchTap $c.x $c.y; Start-Sleep -Milliseconds 120 }
  function TouchSwipe([double]$x, [double]$y, [double]$dx) {
    Send 'Input.dispatchTouchEvent' @{ type = 'touchStart'; touchPoints = @(@{ x = $x; y = $y; id = 1 }) } | Out-Null
    foreach ($i in 1..12) { Send 'Input.dispatchTouchEvent' @{ type = 'touchMove'; touchPoints = @(@{ x = ($x + $dx * $i / 12); y = $y; id = 1 }) } | Out-Null; Start-Sleep -Milliseconds 16 }
    Send 'Input.dispatchTouchEvent' @{ type = 'touchEnd'; touchPoints = @() } | Out-Null
    Start-Sleep -Milliseconds 600
  }
  function Wheel([double]$x, [double]$y, [double]$dy) { Send 'Input.dispatchMouseEvent' @{ type = 'mouseWheel'; x = $x; y = $y; deltaX = 0; deltaY = $dy } | Out-Null; Start-Sleep -Milliseconds 300 }

  # ---- C: chip row (decision 2): keyboard and touch ----
  Viewport 390 844 $true
  Go $dsUrl
  $c0 = (Js "(function(){var row=document.querySelector('.chip-row'),chips=[].slice.call(row.querySelectorAll('.chip:not(:disabled)')),rr=row.getBoundingClientRect();var cut=chips.filter(function(c){var b=c.getBoundingClientRect();return b.left<rr.right-1&&b.right>rr.right+1;}).length;return JSON.stringify({scrollable:row.scrollWidth>row.clientWidth+1,partial:cut,n:chips.length});})()") | ConvertFrom-Json
  # Touch first, on a fresh load: in this headless build, touch swipes stop scrolling once real key events have been sent to the same page load (measured), so the two are never mixed.
  $cc = Center '.chip-row'
  $swipeTries = 0
  do { $swipeTries++; Js "document.querySelector('.chip-row').scrollLeft = 0; 0" | Out-Null; TouchSwipe ([math]::Min($cc.x + 80, 360)) $cc.y -220; $ct = (Js "JSON.stringify({sl:Math.round(document.querySelector('.chip-row').scrollLeft),pageX:Math.round(scrollX)})") | ConvertFrom-Json } while ($ct.sl -eq 0 -and $swipeTries -lt 3)
  Js "document.querySelector('.chip-row').scrollLeft = 0; 0" | Out-Null
  Js "document.querySelector('.chip-row .chip').focus(); 0" | Out-Null
  $nChips = [int](Js "document.querySelectorAll('.chip-row .chip:not(:disabled)').length"); 1..($nChips - 1) | ForEach-Object { Tab }
  $ck = (Js "(function(){var row=document.querySelector('.chip-row'),a=document.activeElement,rr=row.getBoundingClientRect(),b=a.getBoundingClientRect();return JSON.stringify({inRow:row.contains(a),visible:b.left>=rr.left-1&&b.right<=rr.right+1,scrollLeft:Math.round(row.scrollLeft),name:a.textContent.trim().slice(0,20),ring:getComputedStyle(a).outlineStyle+' '+getComputedStyle(a).outlineWidth});})()") | ConvertFrom-Json
  $keyOk = ($ck.inRow -and $ck.visible -and $ck.scrollLeft -gt 0)
  Report 'C. Chip row on a 390px touch phone (real key and touch events)' @(
    [pscustomobject]@{ name = 'The row scrolls sideways and a chip is cut off at the edge (discoverable)'; ok = ($c0.scrollable -and $c0.partial -ge 1); detail = "scrollable=$($c0.scrollable) partly visible chips=$($c0.partial) of $($c0.n)" },
    [pscustomobject]@{ name = 'Tab to a clipped chip scrolls it fully into view (needs chip-row.js)'; ok = $keyOk; detail = "focused '$($ck.name)' scrollLeft=$($ck.scrollLeft) fully visible=$($ck.visible)" },
    [pscustomobject]@{ name = 'The focused chip shows a 2px solid ring'; ok = ($ck.ring -like 'solid 2px*'); detail = "'$($ck.name)' ring=$($ck.ring)" },
    [pscustomobject]@{ name = 'A touch swipe scrolls the chip row and not the page sideways'; ok = ($ct.sl -gt 0 -and $ct.pageX -eq 0); detail = "row scrollLeft=$($ct.sl) page scrollX=$($ct.pageX) after $swipeTries swipe attempt(s)" }
  )
  # ---- D: drawer (decision 5): real Tab, Shift+Tab, Escape, Enter, wheel, click ----
  $drawerState = @'
(function(){var d=document.getElementById('demo-filters'),a=document.activeElement,o=document.querySelector('[data-drawer-open]'),cl=d.querySelector('[data-drawer-close]').getBoundingClientRect(),ft=d.querySelector('.drawer__foot .btn').getBoundingClientRect(),bd=d.querySelector('.drawer__body'),dr=d.getBoundingClientRect(),cs=getComputedStyle(document.documentElement);
return JSON.stringify({open:d.open,modal:d.matches(':modal'),inside:d.contains(a),activeIsOpener:a===o,activeIsClose:a===d.querySelector('[data-drawer-close]'),activeIsLast:a===d.querySelector('.drawer__foot .btn'),
 title:(document.getElementById(d.getAttribute('aria-labelledby'))||{}).textContent,overflow:cs.overflow,lockedClass:document.documentElement.classList.contains('is-scroll-locked'),padR:document.documentElement.style.paddingRight,y:Math.round(scrollY),
 width:Math.round(dr.width),vw:innerWidth,closeIn:cl.top>=0&&cl.bottom<=innerHeight&&cl.left>=0&&cl.right<=innerWidth,closeSize:Math.round(Math.min(cl.width,cl.height)),footIn:ft.bottom<=innerHeight+0.5&&ft.top>=0,bodyScrollTop:Math.round(bd.scrollTop),bodyScrolls:bd.scrollHeight>bd.clientHeight+1,
 ring:a?getComputedStyle(a).outlineStyle+' '+getComputedStyle(a).outlineWidth:'',tag:a?a.tagName:''});})()
'@
  foreach ($cfg in @(@('D. Drawer as a phone sheet (390 x 844 touch emulation, real keys and wheel)', 390, 844, $true), @('D. Drawer as a side panel (1280 x 800, real keys, wheel and mouse)', 1280, 800, $false))) {
    $phone = $cfg[3]; Viewport $cfg[1] $cfg[2] $phone
    Go $dsUrl
    Js "document.querySelector('[data-drawer-open]').scrollIntoView({block:'center',behavior:'instant'}); document.querySelector('[data-drawer-open]').focus(); 0" | Out-Null
    $y0 = [int](Js 'Math.round(scrollY)')
    $rows = @()
    $pre = (Js $drawerState) | ConvertFrom-Json
    Key 'Enter' 'Enter' 13 0 "`r"; Start-Sleep -Milliseconds 300
    $s1 = (Js $drawerState) | ConvertFrom-Json
    $rows += [pscustomobject]@{ name = 'Enter on the Filters button opens a modal dialog'; ok = ($pre.open -eq $false -and $s1.open -and $s1.modal); detail = "open=$($s1.open) modal=$($s1.modal)" }
    $rows += [pscustomobject]@{ name = 'Focus moves into the drawer, onto the close button'; ok = ($s1.inside -and $s1.activeIsClose); detail = "inside=$($s1.inside) onClose=$($s1.activeIsClose)" }
    # accessibility tree: role and name
    Send 'Accessibility.enable' | Out-Null
    $ax = Send 'Accessibility.getFullAXTree'
    $dlg = @($ax.result.nodes | Where-Object { $_.role.value -eq 'dialog' -and -not $_.ignored })
    $axName = if ($dlg.Count) { $dlg[0].name.value } else { '' }
    $axModal = if ($dlg.Count) { (@($dlg[0].properties | Where-Object { $_.name -eq 'modal' }) | ForEach-Object { $_.value.value }) -join ',' } else { '' }
    $rows += [pscustomobject]@{ name = 'The accessibility tree exposes a dialog named "Filters"'; ok = ($axName -eq 'Filters' -and $s1.title -eq 'Filters'); detail = "role=dialog name='$axName' modal=$axModal labelledby text='$($s1.title)'" }
    $btnNames = (Js "JSON.stringify([...document.getElementById('demo-filters').querySelectorAll('button')].map(b=>b.getAttribute('aria-label')||b.textContent.trim()))") | ConvertFrom-Json
    $rows += [pscustomobject]@{ name = 'Close and action buttons have accessible names'; ok = (($btnNames | Where-Object { -not $_ }).Count -eq 0 -and $btnNames[0] -eq 'Close filters'); detail = ($btnNames -join ' | ') }
    $rows += [pscustomobject]@{ name = 'Shape: sheet fills the phone; panel is 416px (26rem)'; ok = $(if ($phone) { $s1.width -eq $s1.vw } else { $s1.width -eq 416 }); detail = "drawer $($s1.width)px in a $($s1.vw)px viewport" }
    $rows += [pscustomobject]@{ name = 'Close button is 44px and on screen; the primary action is on screen'; ok = ($s1.closeIn -and $s1.closeSize -ge 44 -and $s1.footIn); detail = "close $($s1.closeSize)px inside=$($s1.closeIn); action visible=$($s1.footIn)" }
    # the page behind cannot take focus
    $bg = (Js "document.querySelector('[data-drawer-open]').focus(); var d=document.getElementById('demo-filters'); JSON.stringify({inside:d.contains(document.activeElement)})") | ConvertFrom-Json
    $rows += [pscustomobject]@{ name = 'Focusing something on the page behind does not take focus out of the drawer'; ok = $bg.inside; detail = "focus stayed inside=$($bg.inside)" }
    Js "document.querySelector('#demo-filters [data-drawer-close]').focus(); 0" | Out-Null
    # Tab cycle: 14 focusable controls (close, 12 checkboxes, action)
    $n = [int](Js "document.getElementById('demo-filters').querySelectorAll('button, input').length")
    $stays = $true; $ringOk = $true
    1..$n | ForEach-Object { Tab; $t = (Js $drawerState) | ConvertFrom-Json; if (-not $t.inside) { $stays = $false }; if ($t.ring -notlike 'solid 2px*') { $ringOk = $false } }
    $back = (Js $drawerState) | ConvertFrom-Json
    $rows += [pscustomobject]@{ name = "Tab through all $n controls never leaves the drawer and returns to the first"; ok = ($stays -and $back.activeIsClose); detail = "stayed inside=$stays back on close=$($back.activeIsClose)" }
    $rows += [pscustomobject]@{ name = 'Every focused control shows a 2px solid focus ring'; ok = $ringOk; detail = "ring on all $n stops=$ringOk" }
    Js "document.querySelector('#demo-filters .drawer__foot .btn').focus(); 0" | Out-Null
    Tab; $w1 = (Js $drawerState) | ConvertFrom-Json
    Tab $true; $w2 = (Js $drawerState) | ConvertFrom-Json
    $rows += [pscustomobject]@{ name = 'Tab on the last control wraps to the first; Shift+Tab on the first wraps to the last'; ok = ($w1.activeIsClose -and $w2.activeIsLast); detail = "Tab -> close=$($w1.activeIsClose); Shift+Tab -> action=$($w2.activeIsLast)" }
    # scroll lock and independent scrolling
    $lk = $s1
    $wx = if ($phone) { 195 } else { 150 }; $wy = if ($phone) { 40 } else { 400 }
    Wheel $wx $wy 600
    $afterWheelOutside = (Js $drawerState) | ConvertFrom-Json
    $bx = if ($phone) { 195 } else { 1000 }; $by = if ($phone) { 400 } else { 400 }
    Wheel $bx $by 400
    $afterWheelBody = (Js $drawerState) | ConvertFrom-Json
    $rows += [pscustomobject]@{ name = 'Background scroll is locked while open (wheel over the scrim or header does not scroll the page)'; ok = ($lk.overflow -eq 'hidden' -and $lk.lockedClass -and $afterWheelOutside.y -eq $y0); detail = "html overflow=$($lk.overflow) page scrollY before=$y0 after wheel=$($afterWheelOutside.y)" }
    $rows += [pscustomobject]@{ name = 'The drawer body scrolls on its own and the page still does not move'; ok = ($afterWheelBody.bodyScrolls -and $afterWheelBody.bodyScrollTop -gt 0 -and $afterWheelBody.y -eq $y0); detail = "body scrollTop=$($afterWheelBody.bodyScrollTop) page scrollY=$($afterWheelBody.y)" }
    $rows += [pscustomobject]@{ name = 'Close button and action stay on screen while the body is scrolled'; ok = ($afterWheelBody.closeIn -and $afterWheelBody.footIn); detail = "close visible=$($afterWheelBody.closeIn) action visible=$($afterWheelBody.footIn)" }
    Shot ('drawer-open-' + $(if ($phone) { 'phone' } else { 'desktop' }))
    # Escape
    Key 'Escape' 'Escape' 27; Start-Sleep -Milliseconds 250
    $e = (Js $drawerState) | ConvertFrom-Json
    $rows += [pscustomobject]@{ name = 'Escape closes the drawer'; ok = (-not $e.open); detail = "open=$($e.open)" }
    $rows += [pscustomobject]@{ name = 'Focus returns to the Filters button after Escape'; ok = $e.activeIsOpener; detail = "on opener=$($e.activeIsOpener)" }
    $rows += [pscustomobject]@{ name = 'Scroll lock is released and the page position is unchanged'; ok = ($e.overflow -ne 'hidden' -and -not $e.lockedClass -and $e.padR -eq '' -and $e.y -eq $y0); detail = "overflow=$($e.overflow) class=$($e.lockedClass) paddingRight='$($e.padR)' scrollY=$($e.y) (was $y0)" }
    # close button, action, scrim: each closes and restores focus
    $paths = @(@('close button (Enter)', 'close'), @('action button (Enter)', 'action'))
    foreach ($pt in $paths) {
      Js "document.querySelector('[data-drawer-open]').focus(); 0" | Out-Null; Key 'Enter' 'Enter' 13 0 "`r"; Start-Sleep -Milliseconds 250
      if ($pt[1] -eq 'action') { Js "document.querySelector('#demo-filters .drawer__foot .btn').focus(); 0" | Out-Null }
      Key 'Enter' 'Enter' 13 0 "`r"; Start-Sleep -Milliseconds 250
      $x = (Js $drawerState) | ConvertFrom-Json
      $rows += [pscustomobject]@{ name = "Closing with the $($pt[0]) closes it and restores focus"; ok = ((-not $x.open) -and $x.activeIsOpener -and $x.overflow -ne 'hidden'); detail = "open=$($x.open) focus on opener=$($x.activeIsOpener)" }
    }
    if (-not $phone) {
      Js "document.querySelector('[data-drawer-open]').focus(); 0" | Out-Null; Key 'Enter' 'Enter' 13 0 "`r"; Start-Sleep -Milliseconds 250
      Send 'Input.dispatchMouseEvent' @{ type = 'mousePressed'; x = 150; y = 400; button = 'left'; clickCount = 1 } | Out-Null
      Send 'Input.dispatchMouseEvent' @{ type = 'mouseReleased'; x = 150; y = 400; button = 'left'; clickCount = 1 } | Out-Null
      Start-Sleep -Milliseconds 300
      $x = (Js $drawerState) | ConvertFrom-Json
      $rows += [pscustomobject]@{ name = 'Clicking the scrim beside the panel closes it and restores focus'; ok = ((-not $x.open) -and $x.activeIsOpener); detail = "open=$($x.open) focus on opener=$($x.activeIsOpener)" }
    }
    Shot ('drawer-' + $(if ($phone) { 'phone' } else { 'desktop' }))
    Report $cfg[0] $rows
  }

  # ---- L: Load more (decision 4) with real taps ----
  Viewport 390 844 $true
  Go $dsUrl
  $lmState = @'
(function(){var r=document.querySelector('[data-load-more]'),b=r.querySelector('[data-load-more-button]'),l=document.getElementById('demo-results'),e=r.querySelector('[data-load-more-error]'),a=document.activeElement,num=document.querySelector('.pagination-switch__numbered');
return JSON.stringify({items:l.children.length,status:r.querySelector('[data-load-more-status]').textContent.trim(),label:b.textContent.trim(),busyList:l.getAttribute('aria-busy'),disabled:b.getAttribute('aria-disabled'),hidden:b.hidden,href:b.getAttribute('href'),tag:b.tagName,
 errShown:getComputedStyle(e).display!=='none',focusText:a?a.textContent.trim().slice(0,30):'',focusOnBtn:a===b,search:location.search,lmShown:getComputedStyle(r).display!=='none',numShown:getComputedStyle(num).display!=='none',btnH:Math.round(b.getBoundingClientRect().height),btnW:Math.round(b.getBoundingClientRect().width)});})()
'@
  $L0 = (Js $lmState) | ConvertFrom-Json
  Tap '[data-load-more-button]'; Start-Sleep -Milliseconds 60
  $L1 = (Js $lmState) | ConvertFrom-Json
  Start-Sleep -Milliseconds 900
  $L2 = (Js $lmState) | ConvertFrom-Json
  Tap '[data-demo-fail]'; Tap '[data-load-more-button]'; Start-Sleep -Milliseconds 1000
  $L3 = (Js $lmState) | ConvertFrom-Json
  Tap '[data-load-more-button]'; Start-Sleep -Milliseconds 1000
  $L4 = (Js $lmState) | ConvertFrom-Json
  Tap '[data-load-more-button]'; Start-Sleep -Milliseconds 1000
  $L5 = (Js $lmState) | ConvertFrom-Json
  Shot 'loadmore-phone'
  Report 'L. Load more on a 390px touch phone (real taps; demo loader, not a server)' @(
    [pscustomobject]@{ name = 'Phone shows Load more and hides the numbered list; the button is a real link, 44px high'; ok = ($L0.lmShown -and -not $L0.numShown -and $L0.tag -eq 'A' -and $L0.href -eq '?page=2' -and $L0.btnH -ge 44); detail = "load more shown=$($L0.lmShown) numbered shown=$($L0.numShown) <$($L0.tag) href=$($L0.href)> height=$($L0.btnH)px" },
    [pscustomobject]@{ name = 'Initial state announces "Showing 4 of 16 products"'; ok = ($L0.items -eq 4 -and $L0.status -eq 'Showing 4 of 16 products'); detail = "$($L0.items) items; status='$($L0.status)'" },
    [pscustomobject]@{ name = 'While loading: list aria-busy, button aria-disabled and labelled Loading, focus kept on the button'; ok = ($L1.busyList -eq 'true' -and $L1.disabled -eq 'true' -and $L1.label -like 'Loading*' -and $L1.focusOnBtn); detail = "busy=$($L1.busyList) disabled=$($L1.disabled) label='$($L1.label)' focus on button=$($L1.focusOnBtn)" },
    [pscustomobject]@{ name = 'Success: items appended, status updated, state cleared, label restored'; ok = ($L2.items -eq 8 -and $L2.status -eq 'Showing 8 of 16 products' -and $null -eq $L2.busyList -and $null -eq $L2.disabled -and $L2.label -eq 'Load more products'); detail = "$($L2.items) items; status='$($L2.status)'; label='$($L2.label)'" },
    [pscustomobject]@{ name = 'Focus moves to the first new item (the user keeps their place)'; ok = ($L2.focusText -eq 'Demo product 5'); detail = "focus on '$($L2.focusText)'" },
    [pscustomobject]@{ name = 'Address bar and the next link advance together (?page=2, button now ?page=3)'; ok = ($L2.search -eq '?page=2' -and $L2.href -eq '?page=3'); detail = "location.search=$($L2.search) button href=$($L2.href)" },
    [pscustomobject]@{ name = 'Failure: alert shown, nothing appended, URL unchanged, button reads Try again and keeps focus'; ok = ($L3.errShown -and $L3.items -eq 8 -and $L3.search -eq '?page=2' -and $L3.label -eq 'Try again' -and $L3.focusOnBtn -and $L3.href -eq '?page=3'); detail = "error shown=$($L3.errShown) items=$($L3.items) url=$($L3.search) label='$($L3.label)' focus on button=$($L3.focusOnBtn)" },
    [pscustomobject]@{ name = 'Retry succeeds: error hidden, 12 items, focus on the first new item'; ok = ((-not $L4.errShown) -and $L4.items -eq 12 -and $L4.focusText -eq 'Demo product 9' -and $L4.label -eq 'Load more products'); detail = "error shown=$($L4.errShown) items=$($L4.items) focus on '$($L4.focusText)'" },
    [pscustomobject]@{ name = 'Last page: button removed, status says all 16 shown, focus stays on new content'; ok = ($L5.hidden -and $L5.items -eq 16 -and $L5.status -eq 'All 16 products shown' -and $L5.focusText -eq 'Demo product 13'); detail = "button hidden=$($L5.hidden) items=$($L5.items) status='$($L5.status)' focus on '$($L5.focusText)'" }
  )
  Viewport 1280 800 $false
  Go $dsUrl
  $L6 = (Js $lmState) | ConvertFrom-Json
  Report 'L2. Tablet and desktop keep numbered pagination' @(
    [pscustomobject]@{ name = 'At 1280px the numbered list shows and Load more is hidden'; ok = ($L6.numShown -and -not $L6.lmShown); detail = "numbered shown=$($L6.numShown) load more shown=$($L6.lmShown)" }
  )
  Send 'Emulation.setTouchEmulationEnabled' @{ enabled = $false } | Out-Null
  Send 'Emulation.clearDeviceMetricsOverride' | Out-Null
}
finally {
  try { $sock.Dispose() } catch {}
  Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue; Start-Sleep -Milliseconds 600; Remove-Item $prof -Recurse -Force -ErrorAction SilentlyContinue
}

# ---------------- P: progressive enhancement of product-card focus (no browser emulation of :has() exists) ----------------
$tmp = Join-Path ([IO.Path]::GetTempPath()) ("nudge-pe-" + [guid]::NewGuid().ToString('N').Substring(0, 6)); New-Item -ItemType Directory $tmp | Out-Null
$css = [IO.File]::ReadAllText((Join-Path $proj '01-Design-System\Styles\components.css'))
$noHas = [regex]::Replace($css, '@supports selector\(:has\(\*\)\)', '@supports (display: not-a-real-value)')   # this branch (the :has() overrides) now never applies, as in a browser without :has()
$page = @"
<!doctype html><meta charset=utf-8><link rel=stylesheet href="$(FileUrl (Join-Path $dv 'Styles\variables.css'))"><link rel=stylesheet href="$(FileUrl (Join-Path $proj '01-Design-System\Styles\foundation.css'))"><link rel=stylesheet href="$(FileUrl (Join-Path $proj '01-Design-System\Styles\base.css'))"><style>__CSS__</style>
<article class=product-card id=pc><div class=product-card__media><div class="ratio ratio--portrait"></div></div><div class=product-card__body><h3 class=product-card__title><a id=lnk href="#x">Product</a></h3></div></article>
<button class="chip" id=chip type=button aria-pressed=true>Hydration</button><button class="chip" id=chip2 type=button aria-pressed=true>Dry <svg class=icon></svg></button>
<pre id=out>run</pre><script>
function snap(){ const l=document.getElementById('lnk'), c=document.getElementById('pc'); l.focus(); const a=getComputedStyle(l), b=getComputedStyle(c); const r={link:a.outlineStyle+' '+a.outlineWidth, card:b.outlineStyle+' '+b.outlineWidth}; l.blur(); return r; }
function chipmark(){ return getComputedStyle(document.getElementById('chip'),'::before').content; }
document.getElementById('out').textContent=JSON.stringify({focus:snap(), chipMark:chipmark(), chip2Mark:getComputedStyle(document.getElementById('chip2'),'::before').content});
</script>
"@
$res = @{}
foreach ($v in @(@('with-has', $css), @('without-has', $noHas))) {
  $f = Join-Path $tmp "$($v[0]).html"; [IO.File]::WriteAllText($f, $page.Replace('__CSS__', ($v[1] -replace '</style', '')))
  $o = Join-Path $tmp "$($v[0]).out"
  Start-Process -FilePath $browser -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', '--virtual-time-budget=8000', '--dump-dom', (FileUrl $f)) -RedirectStandardOutput $o -RedirectStandardError "$tmp\e.txt" -Wait -NoNewWindow
  $m = [regex]::Match([IO.File]::ReadAllText($o), '(?s)<pre id="out">(.*?)</pre>')
  $res[$v[0]] = if ($m.Success) { [Net.WebUtility]::HtmlDecode($m.Groups[1].Value) | ConvertFrom-Json } else { $null }
}
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
$rowsP = @()
if ($res['with-has'] -and $res['without-has']) {
  $w = $res['with-has']; $n = $res['without-has']
  $rowsP += [pscustomobject]@{ name = 'With :has(): the whole card shows the ring, the link itself does not'; ok = ($w.focus.card -like 'solid 2px*' -and $w.focus.link -like 'none*'); detail = "card=$($w.focus.card) link=$($w.focus.link)" }
  $rowsP += [pscustomobject]@{ name = 'Without :has(): the title link still shows a focus ring'; ok = ($n.focus.link -like 'solid 2px*'); detail = "card=$($n.focus.card) link=$($n.focus.link)" }
  $rowsP += [pscustomobject]@{ name = 'Without :has(): a selected chip still shows its check mark'; ok = ($n.chipMark -ne 'none' -and $n.chipMark -ne 'normal'); detail = "content=$($n.chipMark)" }
  $rowsP += [pscustomobject]@{ name = 'With :has(): a removable chip (with an icon) hides the check mark'; ok = ($w.chip2Mark -eq 'none' -or $w.chip2Mark -eq 'normal'); detail = "content=$($w.chip2Mark)" }
} else { $rowsP += [pscustomobject]@{ name = 'fallback harness produced no result'; ok = $false; detail = '' } }
Report 'P. Progressive enhancement without :has() (CSS path with the :has() branch disabled)' $rowsP

if ($fail) { Write-Host "`nRESULT: $fail check(s) FAILED"; exit 1 }
Write-Host "`nRESULT: all passed"; exit 0
