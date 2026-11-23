# READ-ONLY audit: opens every wireframe page in headless Chrome and records every link and control (tag, text, href, id, context, data attributes).
# Output: interactive-website/documentation/data/link-inventory.json. Nothing in the wireframes is modified.
# Usage: .\tools\audit-links.ps1
$ErrorActionPreference = 'Stop'
$IW = Split-Path -Parent $PSScriptRoot; $PRJ = Split-Path -Parent $IW; $WF = Join-Path $PRJ '03-Wireframes'; $utf8 = New-Object Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'audit-links.js'), $utf8); $b64 = [Convert]::ToBase64String($utf8.GetBytes($js))
$pages = Get-ChildItem $WF -Directory | Where-Object { $_.Name -match '^\d\d-NUDGE' } | Sort-Object Name
$list = @(); $n = 0
foreach ($p in $pages) { $n++; $h = Get-ChildItem $p.FullName -Filter *.html | Where-Object { $_.Name -notmatch '\.bk\.' } | Select-Object -First 1
  $list += '{"number":' + $n + ',"folder":"' + $p.Name + '","file":"' + $h.Name + '","url":"file:///' + (($h.FullName -replace '\\', '/') -replace ' ', '%20') + '?state=multi"}' }
$wrap = @"
<!doctype html><meta charset="utf-8"><iframe id="f" style="width:1440px;height:900px;border:0"></iframe><textarea id="o">pending</textarea>
<script>
var PAGES=[$($list -join ',')],SRC=atob('$b64'),out=[],i=0,f=document.getElementById('f');
function next(){ if(i>=PAGES.length){document.getElementById('o').textContent='['+out.join(',')+']';return}
  var p=PAGES[i];f.onload=function(){setTimeout(function(){var r;try{r=f.contentWindow.eval(SRC)}catch(e){r=JSON.stringify({error:String(e)})}
    out.push('{"number":'+p.number+',"folder":"'+p.folder+'","file":"'+p.file+'","data":'+r+'}');i++;next()},2400)};f.src=p.url}
next();
</script>
"@
$tmp = Join-Path ([IO.Path]::GetTempPath()) 'nudge-iw-audit'; New-Item -ItemType Directory -Force $tmp | Out-Null
$pg = Join-Path $tmp 'wrap.html'; [IO.File]::WriteAllText($pg, $wrap, $utf8); $dump = Join-Path $tmp 'dump.html'
Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', '--window-size=1460,940', '--virtual-time-budget=240000', '--dump-dom', "`"file:///$(($pg -replace '\\','/') -replace ' ','%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
$raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump, $utf8), '<textarea id="o">([\s\S]*?)</textarea>').Groups[1].Value)
if ($raw -eq 'pending' -or -not $raw) { throw 'BROWSER PRODUCED NO RESULT: this is a failure, not a pass' }
New-Item -ItemType Directory -Force (Join-Path $IW 'documentation\data') | Out-Null
[IO.File]::WriteAllText((Join-Path $IW 'documentation\data\link-inventory.json'), $raw, $utf8)
"link inventory written: $([Math]::Round($raw.Length / 1KB)) KB"
