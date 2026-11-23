# AUDIT (read-only): opens every wireframe page in headless Chrome (1440 px, after its scripts have rendered) and records, for each section in order:
# name, purpose note, headings, buttons (with kind), icons, inputs, media placeholders, card/tile patterns. Output: docs/audit/pages.json.
# A wrapper page loads each wireframe in an iframe, runs tools/audit-extract.js inside it and collects the JSON. Nothing in the wireframes is modified.
# Usage: .\tools\audit-extract.ps1
$ErrorActionPreference = 'Stop'
$L = Split-Path -Parent $PSScriptRoot; $W = Join-Path (Split-Path -Parent $L) '03-Wireframes'; $utf8 = New-Object Text.UTF8Encoding($false)
$js = Get-Content (Join-Path $PSScriptRoot 'audit-extract.js') -Raw
$b64 = [Convert]::ToBase64String($utf8.GetBytes($js))
$pages = Get-ChildItem $W -Directory | Where-Object { $_.Name -match '^\d\d-NUDGE' } | Sort-Object Name
$list = @(); $n = 0
foreach ($p in $pages) { $n++; $h = Get-ChildItem $p.FullName -Filter *.html | Select-Object -First 1
  $list += @{ number = $n; folder = $p.Name; file = $h.Name; url = ('file:///' + (($h.FullName -replace '\\', '/') -replace ' ', '%20') + '?state=multi') } }
$listJson = ($list | ForEach-Object { '{"number":' + $_.number + ',"folder":"' + $_.folder + '","file":"' + $_.file + '","url":"' + $_.url + '"}' }) -join ','
$wrap = @"
<!doctype html><meta charset="utf-8"><iframe id="f" style="width:1440px;height:900px;border:0"></iframe><textarea id="o">pending</textarea>
<script>
var PAGES=[$listJson],SRC=atob('$b64'),out=[],i=0,f=document.getElementById('f');
function next(){ if(i>=PAGES.length){document.getElementById('o').textContent='['+out.join(',')+']';document.title='done';return}
  var p=PAGES[i];f.onload=function(){setTimeout(function(){var r;try{r=f.contentWindow.eval(SRC)}catch(e){r=JSON.stringify({error:String(e)})}
    out.push('{"number":'+p.number+',"folder":"'+p.folder+'","file":"'+p.file+'","data":'+r+'}');i++;next()},2200)};f.src=p.url}
next();
</script>
"@
$tmp = Join-Path ([IO.Path]::GetTempPath()) 'nudge-audit'; New-Item -ItemType Directory -Force $tmp | Out-Null
$pg = Join-Path $tmp 'wrap.html'; [IO.File]::WriteAllText($pg, $wrap, $utf8); $dump = Join-Path $tmp 'dump.html'
Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', '--window-size=1460,940', '--virtual-time-budget=120000', '--dump-dom', "`"file:///$(($pg -replace '\\','/') -replace ' ','%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
$raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump, $utf8), '<textarea id="o">([\s\S]*?)</textarea>').Groups[1].Value)
if ($raw -eq 'pending' -or -not $raw) { throw 'no result from the browser' }
[IO.File]::WriteAllText((Join-Path $L 'docs\audit\pages.json'), $raw, $utf8)
$d = [regex]::Matches($raw, '"folder":"([^"]+)","file":"[^"]+","data":\{"title":"[^"]*","sections":\[')
"pages captured: $($d.Count) of $($pages.Count); JSON $([Math]::Round($raw.Length / 1KB)) KB"
