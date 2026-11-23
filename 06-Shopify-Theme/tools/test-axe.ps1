# Accessibility scan with axe-core (vendored, tools/vendor/axe.min.js) on a rendered theme page, at several widths and UI states.
# Usage: .\tools\test-axe.ps1 -File <rendered.html> [-Widths 1440,390] [-States default,mega,drawer]
# States: cart = the cart drawer opened from the header; default = page as loaded; mega = desktop mega menu open (Skin); drawer = mobile menu drawer open (Skin accordion open).
# Reports every violation (rule, impact, nodes, first selectors). "incomplete" (needs manual review) results are counted separately.
# Limit: axe finds roughly a third of WCAG issues automatically; it is not a screen-reader test.
param([Parameter(Mandatory = $true)][string]$File, [switch]$Details, [int[]]$Widths = @(1440, 390), [string[]]$States = @('default', 'mega', 'drawer'), [string[]]$Tags = @('wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa', 'wcag22aa', 'best-practice'))
$ErrorActionPreference = 'Stop'
$T = Split-Path -Parent $PSScriptRoot; $utf8 = New-Object Text.UTF8Encoding($false)
$axe = [IO.File]::ReadAllText("$PSScriptRoot\vendor\axe.min.js", $utf8)
$axeLit = ($axe | ConvertTo-Json -Compress)   # a safe JS string literal
$tags = ($Tags | ConvertTo-Json -Compress)
$f = (Resolve-Path $File).Path; $tmp = Join-Path ([IO.Path]::GetTempPath()) 'nudge-axe'; New-Item -ItemType Directory -Force $tmp | Out-Null
$all = @()
foreach ($w in $Widths) {
  foreach ($st in $States) {
    if ($st -eq 'mega' -and $w -lt 1024) { continue }
    if ($st -eq 'drawer' -and $w -ge 1024) { continue }
    $u = 'file:///' + (($f -replace '\\', '/') -replace ' ', '%20')
    $js = @"
var AXE_SRC=$axeLit;
var fr=document.getElementById('f');
fr.onload=function(){ setTimeout(function(){
  var w=fr.contentWindow,d=w.document;
  var style=d.createElement('style');style.textContent='*{transition:none!important;animation:none!important}';d.head.appendChild(style);
  var st='$st';
  if(st==='mega'){var it=d.querySelector('[data-mega=skin]');w.eval('void 0');it.dispatchEvent(new w.PointerEvent('pointerenter',{bubbles:true,pointerType:'mouse'}));}
  if(st==='cart'){var cb=d.querySelector('[data-drawer-open=cart-drawer]');if(cb)cb.click();}
  if(st==='drawer'){d.getElementById('menu-btn').click();var a=d.querySelector('[data-mega=skin] [data-mega-link]');if(a)a.click();}
  setTimeout(function(){
    w.eval(AXE_SRC);
    w.axe.run(d,{runOnly:{type:'tag',values:$tags},resultTypes:['violations','incomplete']}).then(function(r){
      document.getElementById('o').textContent=JSON.stringify({v:r.violations.map(function(x){return {id:x.id,impact:x.impact,help:x.help,n:x.nodes.length,sel:x.nodes.slice(0,3).map(function(n){return n.target.join(' ')+' :: '+(n.failureSummary||'').split('\n').slice(0,2).join(' ')})}}),inc:r.incomplete.map(function(x){return {id:x.id,n:x.nodes.length,sel:x.nodes.slice(0,4).map(function(n){return n.target.join(' ')+' :: '+n.any.concat(n.all,n.none).map(function(c){return c.message}).join('; ').slice(0,200)})}})});
    }).catch(function(e){document.getElementById('o').textContent=JSON.stringify({err:String(e)})});
  },600);
},1500);};
"@
    $page = "<!doctype html><html><body style=`"margin:0`"><iframe id=`"f`" src=`"$u`" style=`"width:${w}px;height:900px;border:0`"></iframe><pre id=`"o`">pending</pre><script>$($js.Replace('</', '<\/'))</script></body></html>"
    $pg = Join-Path $tmp 'axe-frame.html'; [IO.File]::WriteAllText($pg, $page, $utf8); $dump = Join-Path $tmp 'axe-dump.html'
    Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', "--window-size=$($w + 20),940", '--virtual-time-budget=30000', '--dump-dom', "`"file:///$(($pg -replace '\\','/') -replace ' ','%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
    $raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump, $utf8), '<pre id="o">([\s\S]*?)</pre>').Groups[1].Value)
    if ($raw -eq 'pending' -or -not $raw) { "{0,5}px {1,-8}: no result" -f $w, $st; continue }
    $r = $raw | ConvertFrom-Json
    if ($r.err) { "{0,5}px {1,-8}: axe error {2}" -f $w, $st, $r.err; continue }
    $vn = @($r.v); $total = ($vn | Measure-Object -Property n -Sum).Sum
    "{0,5}px {1,-8}: {2} violation rule(s), {3} node(s); manual review: {4}" -f $w, $st, $vn.Count, [int]$total, ((@($r.inc) | ForEach-Object { $_.id + '(' + $_.n + ')' }) -join ', ')
    if ($Details) { foreach ($i in @($r.inc)) { '      (review) {0} x{1}' -f $i.id, $i.n; @($i.sel) | ForEach-Object { "          $_" } } }
    foreach ($v in $vn) { "      [{0}] {1} ({2} nodes): {3}" -f $v.impact, $v.id, $v.n, $v.help; $v.sel | ForEach-Object { "          $_" } }
    $all += [pscustomobject]@{ Width = $w; State = $st; Violations = $vn; Incomplete = @($r.inc) }
  }
}
$all
