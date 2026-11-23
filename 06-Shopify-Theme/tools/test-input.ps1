# Real-input and accessibility-tree test through the Chrome DevTools Protocol (headless Chrome driven over a WebSocket from PowerShell).
# Unlike the other tests it sends TRUSTED input: Input.dispatchMouseEvent (hover, click), Input.dispatchTouchEvent (tap), Input.dispatchKeyEvent (Tab, Shift+Tab, Enter, Space, Escape, arrows),
# and it reads Accessibility.getFullAXTree. It is real browser input, but NOT a physical device and NOT a screen reader (NVDA, JAWS, VoiceOver need a person).
# Usage: .\tools\test-input.ps1 -File <rendered page with the cart drawer (render with -LocalAssets, cart_type drawer, -CartState multi)> [-Port 9333]
param([Parameter(Mandatory = $true)][string]$File, [int]$Port = 9333)
$ErrorActionPreference = 'Stop'
$utf8 = New-Object Text.UTF8Encoding($false)
$url = 'file:///' + (((Resolve-Path $File).Path -replace '\\', '/') -replace ' ', '%20')
$prof = Join-Path ([IO.Path]::GetTempPath()) ('nudge-cdp-' + [guid]::NewGuid().ToString('N'))
$chrome = Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', "--remote-debugging-port=$Port", "--user-data-dir=`"$prof`"", '--allow-file-access-from-files', '--no-first-run', 'about:blank') -PassThru
try {
  $ver = $null; for ($i = 0; $i -lt 50 -and -not $ver; $i++) { try { $ver = Invoke-RestMethod "http://127.0.0.1:$Port/json" -TimeoutSec 2 } catch { Start-Sleep -Milliseconds 200 } }
  $tab = @($ver | Where-Object { $_.type -eq 'page' })[0]; if (-not $tab) { throw 'no page target' }
  $ws = New-Object Net.WebSockets.ClientWebSocket; [void]$ws.ConnectAsync([Uri]$tab.webSocketDebuggerUrl, [Threading.CancellationToken]::None).GetAwaiter().GetResult()
  $script:id = 0
  function Send([string]$method, $params = @{}) {
    $script:id++; $my = $script:id
    $msg = (@{ id = $my; method = $method; params = $params } | ConvertTo-Json -Depth 12 -Compress)
    $bytes = $utf8.GetBytes($msg); [void]$ws.SendAsync([ArraySegment[byte]]$bytes, 'Text', $true, [Threading.CancellationToken]::None).GetAwaiter().GetResult()
    while ($true) {
      $buf = New-Object byte[] 262144; $sb = New-Object Text.StringBuilder
      do { $r = $ws.ReceiveAsync([ArraySegment[byte]]$buf, [Threading.CancellationToken]::None).GetAwaiter().GetResult(); [void]$sb.Append($utf8.GetString($buf, 0, $r.Count)) } until ($r.EndOfMessage)
      $o = $sb.ToString() | ConvertFrom-Json
      if ($o.id -eq $my) { if ($o.error) { throw "CDP $method : $($o.error.message)" }; return $o.result }
    }
  }
  function Ev([string]$expr) { $r = Send 'Runtime.evaluate' @{ expression = $expr; returnByValue = $true; awaitPromise = $true }; if ($r.exceptionDetails) { throw "JS: $($r.exceptionDetails.text) $($r.exceptionDetails.exception.description)" }; $r.result.value }
  function Wait([int]$ms) { Start-Sleep -Milliseconds $ms }
  function Center([string]$sel) { $v = Ev "(function(){var e=document.querySelector('$sel');if(!e)return null;e.scrollIntoView({block:'center'});var b=e.getBoundingClientRect();return [b.left+b.width/2,b.top+b.height/2,b.width,b.height]})()"; if (-not $v) { throw "no element $sel" }; $v }
  function MouseTo([double]$x, [double]$y) { [void](Send 'Input.dispatchMouseEvent' @{ type = 'mouseMoved'; x = $x; y = $y }) }
  function MouseClick([double]$x, [double]$y) { MouseTo $x $y; [void](Send 'Input.dispatchMouseEvent' @{ type = 'mousePressed'; x = $x; y = $y; button = 'left'; clickCount = 1 }); [void](Send 'Input.dispatchMouseEvent' @{ type = 'mouseReleased'; x = $x; y = $y; button = 'left'; clickCount = 1 }) }
  function Tap([double]$x, [double]$y) { [void](Send 'Input.dispatchTouchEvent' @{ type = 'touchStart'; touchPoints = @(@{ x = $x; y = $y }) }); [void](Send 'Input.dispatchTouchEvent' @{ type = 'touchEnd'; touchPoints = @() }) }
  $keys = @{ Tab = @(9, 'Tab'); Escape = @(27, 'Escape'); Enter = @(13, 'Enter'); ArrowDown = @(40, 'ArrowDown'); Space = @(32, 'Space') }
  function Key([string]$k, [switch]$Shift) { $m = if ($Shift) { 8 } else { 0 }; $c = $keys[$k]; $kk = if ($k -eq 'Space') { ' ' } else { $k }
    [void](Send 'Input.dispatchKeyEvent' @{ type = 'rawKeyDown'; key = $kk; code = $c[1]; windowsVirtualKeyCode = $c[0]; modifiers = $m })
    if ($k -eq 'Enter') { [void](Send 'Input.dispatchKeyEvent' @{ type = 'char'; text = "`r"; key = 'Enter'; code = 'Enter'; windowsVirtualKeyCode = 13 }) }
    if ($k -eq 'Space') { [void](Send 'Input.dispatchKeyEvent' @{ type = 'char'; text = ' '; key = ' '; code = 'Space'; windowsVirtualKeyCode = 32 }) }
    [void](Send 'Input.dispatchKeyEvent' @{ type = 'keyUp'; key = $kk; code = $c[1]; windowsVirtualKeyCode = $c[0]; modifiers = $m }); Wait 60 }
  $res = New-Object System.Collections.Generic.List[string]
  function Chk([string]$name, [bool]$ok, $detail = '') { $res.Add($(if ($ok) { "pass  $name" } else { "FAIL  $name : $detail" })) }
  function Setup([int]$w, [int]$h, [bool]$touch) {
    [void](Send 'Emulation.setDeviceMetricsOverride' @{ width = $w; height = $h; deviceScaleFactor = 1; mobile = $touch })
    [void](Send 'Emulation.setTouchEmulationEnabled' @{ enabled = $touch })
    [void](Send 'Page.navigate' @{ url = $url }); Wait 1800
    [void](Ev "(function(){var s=document.createElement('style');s.textContent='*{transition:none!important;animation:none!important;scroll-behavior:auto!important}';document.head.appendChild(s)})()")
  }
  [void](Send 'Page.enable'); [void](Send 'Runtime.enable'); [void](Send 'Accessibility.enable')

  # ================= DESKTOP 1440, mouse and keyboard =================
  Setup 1440 900 $false
  $skin = Center '[data-mega=skin] [data-mega-link]'
  MouseTo 5 5; Wait 100; MouseTo $skin[0] $skin[1]; Wait 400
  Chk 'desktop: mouse hover on Skin opens its panel (real pointer events)' ([bool](Ev "!!document.querySelector('[data-mega=skin][data-open]')")) 'not open'
  $pw = Ev "(function(){var p=document.querySelector('#mega-skin').getBoundingClientRect();return [p.left,p.top,p.width,p.height]})()"
  Chk 'desktop: the panel spans the full width below the header' ([Math]::Abs($pw[0]) -lt 1 -and $pw[2] -ge 1400 -and $pw[3] -gt 200) ($pw -join ',')
  MouseTo ($pw[0] + 300) ($pw[1] + 100); Wait 300
  Chk 'desktop: moving the mouse into the panel keeps it open' ([bool](Ev "!!document.querySelector('[data-mega=skin][data-open]')")) 'closed'
  $makeup = Center '[data-mega=makeup] [data-mega-link]'; MouseTo $makeup[0] $makeup[1]; Wait 450
  Chk 'desktop: hovering Makeup switches panels (one open at a time)' ([bool](Ev "!document.querySelector('[data-mega=skin][data-open]') && !!document.querySelector('[data-mega=makeup][data-open]')")) 'both or none open'
  MouseTo 700 800; Wait 500
  Chk 'desktop: moving the mouse away closes the panel' ([bool](Ev "!document.querySelector('[data-open]')")) 'still open'
  # keyboard
  [void](Send 'Page.navigate' @{ url = $url }); Wait 1500
  Key 'Tab'
  Chk 'keyboard: first Tab lands on the skip link' ([bool](Ev "document.activeElement && /Skip to content/.test(document.activeElement.textContent)")) (Ev 'document.activeElement && document.activeElement.outerHTML.slice(0,80)')
  $vis = Ev "(function(){var a=document.activeElement,b=a.getBoundingClientRect();return b.width>1&&b.height>1&&getComputedStyle(a).clip!=='rect(0px, 0px, 0px, 0px)'})()"
  Chk 'keyboard: the skip link becomes visible when focused' ([bool]$vis) 'still hidden'
  Key 'Enter'; Wait 200
  Chk 'keyboard: Enter on the skip link moves to #main' ([bool](Ev "location.hash==='#main'")) (Ev 'location.hash')
  [void](Send 'Page.navigate' @{ url = $url }); Wait 1500
  $order = @(); for ($i = 0; $i -lt 20; $i++) { Key 'Tab'; $order += (Ev "(function(){var a=document.activeElement;return (a.getAttribute('aria-label')||a.textContent||a.tagName).trim().slice(0,22)})()") }
  Chk 'keyboard: Tab reaches Skin, Makeup, Hair, Body in order' (($order -join '|') -match 'Skin.*Makeup.*Hair.*Body') ($order[0..10] -join '|')
  # open with the keyboard
  [void](Send 'Page.navigate' @{ url = $url }); Wait 1500
  [void](Ev "document.querySelector('[data-mega=skin] [data-mega-link]').focus()"); Wait 150
  Chk 'keyboard: focusing Skin does not force its panel open (Tab moves on to Makeup)' ([bool](Ev "!document.querySelector('[data-mega=skin][data-open]')")) 'opened by focus'
  Key 'ArrowDown'
  Chk 'keyboard: ArrowDown opens the panel and moves focus into it' ([bool](Ev "document.querySelector('#mega-skin').contains(document.activeElement)")) (Ev 'document.activeElement.outerHTML.slice(0,80)')
  $ol = Ev "(function(){var s=getComputedStyle(document.activeElement);return s.outlineStyle+' '+s.outlineWidth+' '+s.boxShadow})()"
  Chk 'keyboard: the focused link shows a focus indicator' ($ol -notmatch '^none 0px none$') $ol
  Key 'Escape'; Wait 150
  Start-Sleep -Milliseconds 300
  Chk 'keyboard: Escape closes the panel, returns focus to Skin and it stays closed' ([bool](Ev "!document.querySelector('[data-open]') && document.activeElement.matches('[data-mega=skin] [data-mega-link]')")) (Ev 'document.activeElement.outerHTML.slice(0,80)')
  [void](Ev "document.querySelector('[data-mega=hair] [data-mega-link]').focus()"); Wait 100
  Key 'Space'; Wait 150
  Chk 'keyboard: Space on Hair opens its panel and moves focus into it (Space opens)' ([bool](Ev "!!document.querySelector('[data-mega=hair][data-open]') && document.querySelector('#mega-hair').contains(document.activeElement)")) (Ev 'document.activeElement.outerHTML.slice(0,70)')
  Key 'Escape'; Wait 250
  Chk 'keyboard: Escape after Space closes it and focus returns to Hair' ([bool](Ev "!document.querySelector('[data-open]') && document.activeElement.matches('[data-mega=hair] [data-mega-link]')")) (Ev 'document.activeElement.outerHTML.slice(0,70)')
  # country selector
  $mb = Center '#market-btn'; MouseClick $mb[0] $mb[1]; Wait 150
  Chk 'desktop: clicking the country pill opens the list and focuses an option' ([bool](Ev "!document.getElementById('market-menu').hidden && document.getElementById('market-menu').contains(document.activeElement)")) 'not open'
  Key 'ArrowDown'; Key 'Escape'
  Chk 'desktop: Escape closes the country list and returns focus to the pill' ([bool](Ev "document.getElementById('market-menu').hidden && document.activeElement.id==='market-btn'")) (Ev 'document.activeElement.outerHTML.slice(0,60)')
  # cart drawer: real click, real focus trap, real Escape
  $cb = Center '#site-header [data-drawer-open=cart-drawer]'; MouseClick $cb[0] $cb[1]; Wait 250
  Chk 'cart drawer: a real click opens the modal dialog' ([bool](Ev "document.getElementById('cart-drawer').open")) 'closed'
  Chk 'cart drawer: focus moves into the drawer' ([bool](Ev "document.getElementById('cart-drawer').contains(document.activeElement)")) (Ev 'document.activeElement.outerHTML.slice(0,60)')
  $out = $false; for ($i = 0; $i -lt 40; $i++) { Key 'Tab'; if (-not (Ev "document.getElementById('cart-drawer').contains(document.activeElement)")) { $out = $true; break } }
  Chk 'cart drawer: 40 Tab presses never leave the drawer (focus trap)' (-not $out) 'focus escaped'
  $outBack = $false; for ($i = 0; $i -lt 40; $i++) { Key 'Tab' -Shift; if (-not (Ev "document.getElementById('cart-drawer').contains(document.activeElement)")) { $outBack = $true; break } }
  Chk 'cart drawer: 40 Shift+Tab presses never leave the drawer' (-not $outBack) 'focus escaped'
  Key 'Escape'; Wait 250
  Chk 'cart drawer: a real Escape closes it' ([bool](Ev "!document.getElementById('cart-drawer').open")) 'still open'
  Chk 'cart drawer: focus returns to the cart button after Escape (real close event)' ([bool](Ev "document.activeElement.matches('[data-drawer-open=cart-drawer]')")) (Ev 'document.activeElement.outerHTML.slice(0,70)')
  Chk 'cart drawer: page scroll is unlocked after closing' ([bool](Ev "!document.documentElement.classList.contains('is-scroll-locked')")) 'locked'

  # ================= MOBILE 390, touch =================
  Setup 390 844 $true
  $mbtn = Center '#menu-btn'
  Chk 'mobile: the menu button is at least 44 x 44' ($mbtn[2] -ge 44 -and $mbtn[3] -ge 44) "$($mbtn[2]) x $($mbtn[3])"
  Tap $mbtn[0] $mbtn[1]; Wait 300
  Chk 'mobile: tapping the hamburger opens the drawer and sets aria-expanded' ([bool](Ev "document.body.classList.contains('nav-open') && document.getElementById('menu-btn').getAttribute('aria-expanded')==='true'")) 'not open'
  Chk 'mobile: focus moves to the Close button' ([bool](Ev "document.activeElement.id==='nav-close'")) (Ev 'document.activeElement.outerHTML.slice(0,60)')
  $row = Center '[data-mega=skin] [data-mega-link]'
  Chk 'mobile: accordion rows are at least 44 px tall' ($row[3] -ge 44) "$($row[3])"
  Tap $row[0] $row[1]; Wait 250
  Chk 'mobile: tapping Skin expands its section' ([bool](Ev "document.querySelector('[data-mega=skin][data-open]') && document.querySelector('[data-mega=skin] [data-mega-link]').getAttribute('aria-expanded')==='true'")) 'not expanded'
  $hit = Ev "(function(){var l=document.querySelector('#mega-skin a');l.scrollIntoView({block:'center'});var b=l.getBoundingClientRect(),e=document.elementFromPoint(b.left+b.width/2,b.top+b.height/2);return l===e||l.contains(e)})()"
  Chk 'mobile: a link inside the open section is not covered by the scrim' ([bool]$hit) 'covered'
  $row = Center '[data-mega=makeup] [data-mega-link]'; Tap $row[0] $row[1]; Wait 250
  Chk 'mobile: tapping Makeup closes Skin and opens Makeup' ([bool](Ev "!document.querySelector('[data-mega=skin][data-open]') && !!document.querySelector('[data-mega=makeup][data-open]')")) 'wrong state'
  Key 'Escape'; Wait 250
  Chk 'mobile: Escape closes the drawer and returns focus to the hamburger' ([bool](Ev "!document.body.classList.contains('nav-open') && document.activeElement.id==='menu-btn'")) (Ev 'document.activeElement.outerHTML.slice(0,60)')
  Tap $mbtn[0] $mbtn[1]; Wait 300
  $cl = Center '#nav-close'; Tap $cl[0] $cl[1]; Wait 250
  Chk 'mobile: tapping Close shuts the drawer' ([bool](Ev "!document.body.classList.contains('nav-open')")) 'still open'
  $cbm = Center '#site-header [data-drawer-open=cart-drawer]'; Tap $cbm[0] $cbm[1]; Wait 300
  Chk 'mobile: tapping the cart opens the full-width drawer' ([bool](Ev "(function(){var d=document.getElementById('cart-drawer');return d.open && d.getBoundingClientRect().width>=380})()")) (Ev "document.getElementById('cart-drawer').getBoundingClientRect().width")
  $plus = Center '#cart-drawer [data-plus]'
  Chk 'mobile: quantity buttons are at least 44 x 44' ($plus[2] -ge 44 -and $plus[3] -ge 44) "$($plus[2]) x $($plus[3])"
  Key 'Escape'; Wait 250

  # ================= accessibility tree (desktop) =================
  Setup 1440 900 $false
  $ax = (Send 'Accessibility.getFullAXTree').nodes
  $roles = @($ax | Where-Object { -not $_.ignored } | ForEach-Object { $_.role.value })
  foreach ($lm in 'banner', 'navigation', 'main', 'contentinfo') { Chk "AX tree: landmark '$lm' present" ($roles -contains $lm) 'missing' }
  $h = @($ax | Where-Object { -not $_.ignored -and $_.role.value -eq 'heading' })
  $h1 = @($h | Where-Object { ($_.properties | Where-Object { $_.name -eq 'level' }).value.value -eq 1 })
  Chk 'AX tree: exactly one level-1 heading' ($h1.Count -eq 1) "found $($h1.Count)"
  $unnamed = @($ax | Where-Object { -not $_.ignored -and ($_.role.value -in 'button', 'link', 'textbox', 'combobox', 'slider', 'checkbox') -and -not ($_.name.value) } | ForEach-Object { "$($_.role.value)#$($_.nodeId)" })
  Chk 'AX tree: every button, link, field and slider has an accessible name' ($unnamed.Count -eq 0) ($unnamed -join ', ')
  $lists = @($ax | Where-Object { -not $_.ignored -and $_.role.value -eq 'list' }).Count; $li = @($ax | Where-Object { -not $_.ignored -and $_.role.value -eq 'listitem' }).Count
  $domLists = [int](Ev "[].filter.call(document.querySelectorAll('ul,ol'),function(e){var b=e.getBoundingClientRect(),cs=getComputedStyle(e);return b.width>0&&b.height>0&&cs.visibility!=='hidden'&&!e.hasAttribute('hidden')&&e.getAttribute('role')===null}).length")
  Chk 'AX tree: every visible ul/ol is exposed as a list (no role override)' ($lists -eq $domLists -and $li -ge $lists) "AX lists=$lists, visible DOM lists=$domLists, items=$li"
  $dupe = Ev "(function(){var m={},d=[];[].forEach.call(document.querySelectorAll('[id]'),function(e){if(m[e.id])d.push(e.id);m[e.id]=1});return d.join(',')})()"
  Chk 'DOM: no duplicate ids' ([string]::IsNullOrEmpty($dupe)) $dupe
  $footTab = Ev "[].filter.call(document.querySelectorAll('.fcol > button'),function(b){return b.tabIndex>=0}).length"
  Chk 'footer: desktop column headings are not focusable controls' ($footTab -eq 0) "$footTab focusable"
  $badTab = Ev "[].filter.call(document.querySelectorAll('[tabindex]'),function(e){return parseInt(e.getAttribute('tabindex'),10)>0}).length"
  Chk 'DOM: no positive tabindex' ($badTab -eq 0) "$badTab"
  $small = Ev "(function(){var bad=[];[].forEach.call(document.querySelectorAll('#site-header a, #site-header button, main a, main button, footer a, footer button'),function(e){var b=e.getBoundingClientRect(),cs=getComputedStyle(e);if(b.width>0&&b.height>0&&cs.visibility!=='hidden'&&!e.closest('[hidden]')&&(b.height<24||b.width<24)&&!e.matches('.sr-only')&&cs.pointerEvents!=='none'&&cs.display!=='inline')bad.push((e.getAttribute('aria-label')||e.textContent).trim().slice(0,20)+' '+Math.round(b.width)+'x'+Math.round(b.height))});return bad.join(' | ')})()"
  Chk 'targets: no interactive control smaller than 24 x 24 px (WCAG 2.2 minimum)' ([string]::IsNullOrEmpty($small)) $small
} finally {
  try { if ($ws) { $ws.Dispose() } } catch {}
  if ($chrome -and -not $chrome.HasExited) { Stop-Process -Id $chrome.Id -Force -ErrorAction SilentlyContinue }
  Get-CimInstance Win32_Process -Filter "Name='chrome.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*$prof*" } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
  Start-Sleep -Milliseconds 300; Remove-Item $prof -Recurse -Force -ErrorAction SilentlyContinue
}
$res
$f = @($res | Where-Object { $_ -like 'FAIL*' }).Count
"{0} checks, {1} passed, {2} failed" -f $res.Count, ($res.Count - $f), $f
