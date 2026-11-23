# Runs a wireframe page's own in-page self-test (?selftest=1) at several widths in headless Chrome and reports every check that fails.
# With -CompareWithBaseline the pre-componentisation page (03-Wireframes/00-Shared-Tailwind-Foundation/tools/baseline/<file>) is run the same way and only checks that FAIL NOW BUT PASSED BEFORE are
# counted as regressions (a check that already failed in the original, for example because headless Chrome lacks a font, is reported but is not a regression).
# A browser failure or a missing result is a FAILURE, never a pass.
# Usage: .\tools\run-page-selftest.ps1 -Page 02-NUDGE-Beauty-PLP-Wireframe/PLP.html [-Widths 1920,1440,...] [-CompareWithBaseline]
param([Parameter(Mandatory = $true)][string]$Page, [int[]]$Widths = @(1920, 1440, 1280, 1024, 768, 600, 390, 375, 320), [switch]$CompareWithBaseline)
$ErrorActionPreference = 'Stop'
$LIBDIR = Split-Path -Parent $PSScriptRoot; $PRJ = Split-Path -Parent $LIBDIR; $WF = Join-Path $PRJ '03-Wireframes'; $utf8 = New-Object Text.UTF8Encoding($false)
$pageFile = Join-Path $WF ($Page -replace '/', '\'); if (-not (Test-Path $pageFile)) { throw "page not found: $pageFile" }
function Run-One([string]$file) {
  $url = 'file:///' + (($file -replace '\\', '/') -replace ' ', '%20')
  $wrap = @"
<!doctype html><meta charset="utf-8"><iframe id="f" style="border:0;height:900px"></iframe><textarea id="o">pending</textarea>
<script>
var W=[$($Widths -join ',')],i=0,out=[],f=document.getElementById('f');
function next(){ if(i>=W.length){document.getElementById('o').textContent=JSON.stringify(out);return}
 f.style.width=W[i]+'px'; f.onload=function(){ var tries=0; (function wait(){ var d=f.contentDocument,pre=d&&d.getElementById('selftest-result');
   if(pre){out.push({w:W[i],r:JSON.parse(pre.textContent)});i++;next();return}
   if(++tries>40){out.push({w:W[i],r:null});i++;next();return} setTimeout(wait,500) })() };
 f.src='${url}?embed=1&ann=0&selftest=1&r='+i; }
next();
</script>
"@
  $tmp = Join-Path ([IO.Path]::GetTempPath()) 'nudge-selftest'; New-Item -ItemType Directory -Force $tmp | Out-Null
  $pg = Join-Path $tmp ('wrap-' + [guid]::NewGuid().ToString('N') + '.html'); [IO.File]::WriteAllText($pg, $wrap, $utf8); $dump = "$pg.dump"
  Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', '--window-size=1500,1000', '--virtual-time-budget=600000', '--dump-dom', "`"file:///$(($pg -replace '\\','/') -replace ' ','%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
  $raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump, $utf8), '<textarea id="o">([\s\S]*?)</textarea>').Groups[1].Value)
  if ($raw -eq 'pending' -or -not $raw) { throw 'BROWSER PRODUCED NO SELF-TEST RESULT: this is a failure, not a pass' }
  $res = @{}; foreach ($e in ($raw | ConvertFrom-Json)) { if (-not $e.r) { $res["$($e.w)|(no result)"] = 'the self-test did not finish'; continue }; foreach ($c in $e.r.checks.PSObject.Properties) { $res["$($e.w)|$($c.Name)"] = $(if ($c.Value.pass) { '' } else { [string]$c.Value.detail }) } }
  $res
}
$now = Run-One $pageFile
$before = $null
if ($CompareWithBaseline) {
  $base = Join-Path (Join-Path $WF '00-Shared-Tailwind-Foundation\tools\baseline') ([IO.Path]::GetFileName($pageFile)); if (-not (Test-Path $base)) { throw "no baseline HTML for $Page" }
  $copy = Join-Path (Split-Path -Parent $pageFile) ([IO.Path]::GetFileNameWithoutExtension($pageFile) + '.bk.selftest.html')
  try { Copy-Item $base $copy -Force; $before = Run-One $copy } finally { if (Test-Path $copy) { Remove-Item $copy -Force } }
}
$total = $now.Count; $failNow = @($now.GetEnumerator() | Where-Object { $_.Value -ne '' }); $regress = @()
foreach ($f in $failNow) { if ($before -and ($before[$f.Key] -eq '')) { $regress += $f } elseif (-not $before) { $regress += $f } }
"self-test checks run: $total across $($Widths.Count) widths ($($Widths -join ', '))"
"checks failing now: $($failNow.Count)" + $(if ($before) { "; failing in the original page: $(@($before.GetEnumerator() | Where-Object { $_.Value -ne '' }).Count)" } else { '' })
foreach ($f in ($failNow | Sort-Object Key)) { $tag = if ($before -and $before[$f.Key] -ne '') { 'also fails in the original' } else { 'REGRESSION' }; "  [$tag] $($f.Key): $($f.Value)" }
if ($regress.Count) { "self-test: $($regress.Count) REGRESSION(S)"; exit 1 } else { 'self-test: no regressions' }
