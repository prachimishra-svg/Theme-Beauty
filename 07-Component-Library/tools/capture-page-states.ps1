# Rendered-equivalence tool for pages whose markup is built by scripts (static HTML comparison cannot see it).
# Captures, for every width and state in tools/states/<page>.states.json:
#   DOM        the canonical rendered DOM of <main> and every <dialog> after the page script ran (attributes sorted, class tokens sorted, whitespace collapsed, scripts and styles dropped)
#   SCREEN     a full-page screenshot per width for the screen states
# Modes:  -Baseline   write tools/baseline-dom/<page>/ (do this BEFORE changing the page)
#         (default)   capture into a temporary folder and compare with the baseline: DOM text must be identical, screenshots must differ by <= 0.5 % of pixels
# A browser failure, a missing state or a missing baseline is a FAILURE, never a pass.
# Usage: .\tools\capture-page-states.ps1 -Page plp [-Baseline] [-NoScreens]
param([Parameter(Mandatory = $true)][string]$Page, [switch]$Baseline, [switch]$NoScreens, [double]$MaxPixelPercent = 0.5)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition @'
using System; using System.Drawing; using System.Drawing.Imaging;
public static class PixDiff {
  public static string Compare(string a, string b, int thr) {
    using (var A = new Bitmap(a)) using (var B = new Bitmap(b)) {
      if (A.Width != B.Width || A.Height != B.Height) return "size|" + A.Width + "x" + A.Height + "|" + B.Width + "x" + B.Height;
      int w = A.Width, h = A.Height;
      var ra = A.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb); var rb = B.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
      byte[] pa = new byte[ra.Stride * h], pb = new byte[rb.Stride * h]; System.Runtime.InteropServices.Marshal.Copy(ra.Scan0, pa, 0, pa.Length); System.Runtime.InteropServices.Marshal.Copy(rb.Scan0, pb, 0, pb.Length); A.UnlockBits(ra); B.UnlockBits(rb);
      long diff = 0; for (int i = 0; i < pa.Length; i += 4) { int d = Math.Abs(pa[i] - pb[i]) + Math.Abs(pa[i + 1] - pb[i + 1]) + Math.Abs(pa[i + 2] - pb[i + 2]); if (d > thr) diff++; }
      return "ok|" + (100.0 * diff / ((double)w * h)).ToString("0.000");
    }
  }
}
'@ -ReferencedAssemblies System.Drawing
$LIBDIR = Split-Path -Parent $PSScriptRoot; $PRJ = Split-Path -Parent $LIBDIR; $utf8 = New-Object Text.UTF8Encoding($false)
$cfgPath = Join-Path $PSScriptRoot "states\$Page.states.json"; if (-not (Test-Path $cfgPath)) { throw "no states file for $Page" }
$cfg = [IO.File]::ReadAllText($cfgPath, $utf8) | ConvertFrom-Json
$pageFile = Join-Path (Join-Path $PRJ '03-Wireframes') ($cfg.page -replace '/', '\'); if (-not (Test-Path $pageFile)) { throw "page not found: $pageFile" }
$baseDir = Join-Path $PSScriptRoot "baseline-dom\$Page"
$outDir = if ($Baseline) { $baseDir } else { Join-Path ([IO.Path]::GetTempPath()) "nudge-states-$Page" }
if (-not $Baseline -and -not (Test-Path $baseDir)) { throw "no baseline for $Page; run with -Baseline on the unchanged page first" }
New-Item -ItemType Directory -Force "$outDir\dom", "$outDir\png" | Out-Null; Get-ChildItem "$outDir\dom", "$outDir\png" -File -ErrorAction SilentlyContinue | Remove-Item -Force
$pageUrl = 'file:///' + (($pageFile -replace '\\', '/') -replace ' ', '%20')
# ---- DOM capture (one wrapper page, one browser run) ----
$jobs = @(); foreach ($w in $cfg.widths) { foreach ($s in $cfg.states) { if ($s.minWidth -and $w -lt $s.minWidth) { continue }; if ($s.maxWidth -and $w -gt $s.maxWidth) { continue }; $jobs += [pscustomobject]@{ key = "$($s.key)@$w"; w = $w; query = $s.query; script = [string]$s.script } } }
$jobsJson = ($jobs | ConvertTo-Json -Depth 4 -Compress); if ($jobs.Count -eq 1) { $jobsJson = "[$jobsJson]" }
$wrap = @"
<!doctype html><meta charset="utf-8"><iframe id="f" style="border:0;height:900px"></iframe><textarea id="o">pending</textarea>
<script>
var JOBS=$($jobsJson.Replace('</', '<\/')),URL='$pageUrl',out=[],i=0,f=document.getElementById('f');
function esc(s){return s.replace(/\s+/g,' ')}
function canon(n){
 if(n.nodeType===3){var t=esc(n.nodeValue).trim();return t}
 if(n.nodeType!==1)return '';
 var tag=n.tagName.toLowerCase(); if(tag==='script'||tag==='style'||tag==='template')return '';
 var attrs=[];for(var k=0;k<n.attributes.length;k++){var a=n.attributes[k],v=a.value;if(a.name==='class')v=v.split(/\s+/).filter(Boolean).sort().join(' ');attrs.push(a.name+'="'+esc(v).trim()+'"')}
 attrs.sort();var kids=[];for(var c=n.firstChild;c;c=c.nextSibling){var s=canon(c);if(s)kids.push(s)}
 return '<'+tag+(attrs.length?' '+attrs.join(' '):'')+'>'+kids.join('')+'</'+tag+'>';
}
function next(){
 if(i>=JOBS.length){document.getElementById('o').textContent=out.join('\n');document.title='done';return}
 var j=JOBS[i];f.style.width=j.w+'px';f.onload=function(){setTimeout(function(){
   try{if(j.script)f.contentWindow.eval(j.script)}catch(e){out.push('@@@'+j.key+'|ERROR\n'+String(e));i++;next();return}
   setTimeout(function(){var d=f.contentDocument,parts=[];try{parts.push(canon(d.querySelector('main')));[].forEach.call(d.querySelectorAll('dialog'),function(x){parts.push(canon(x))});
    out.push('@@@'+j.key+'|'+d.documentElement.scrollHeight+'\n'+parts.join('\n'))}catch(e){out.push('@@@'+j.key+'|ERROR\n'+String(e))}i++;next()},700)},1900)};
 f.src=URL+j.query+'&r='+i;
}
next();
</script>
"@
$tmp = Join-Path ([IO.Path]::GetTempPath()) "nudge-cap-$Page"; New-Item -ItemType Directory -Force $tmp | Out-Null
$pg = Join-Path $tmp 'wrap.html'; [IO.File]::WriteAllText($pg, $wrap, $utf8); $dump = Join-Path $tmp 'dump.html'
$chrome = 'C:\Program Files\Google\Chrome\Application\chrome.exe'; $chromeArgs = @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', '--window-size=1500,1000', '--virtual-time-budget=900000', '--dump-dom', "`"file:///$(($pg -replace '\\','/') -replace ' ','%20')`"")
Start-Process -FilePath $chrome -ArgumentList $chromeArgs -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
$raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump, $utf8), '<textarea id="o">([\s\S]*?)</textarea>').Groups[1].Value)
if ($raw -eq 'pending' -or -not $raw) { throw 'BROWSER PRODUCED NO DOM CAPTURE: this is a failure, not a pass' }
$heights = @{}; $got = 0; $errs = @()
foreach ($rec in ($raw -split '(?m)^@@@' | Where-Object { $_ })) { $nl = $rec.IndexOf("`n"); $head = $rec.Substring(0, $nl); $body = $rec.Substring($nl + 1).TrimEnd(); $key = ($head -split '\|')[0].Trim(); $h = ($head -split '\|')[1].Trim()
  if ($h -eq 'ERROR') { $errs += "$key : $body"; continue }; $heights[$key] = [int]$h; $safe = $key -replace '[^\w@-]', '_'; [IO.File]::WriteAllText("$outDir\dom\$safe.txt", $body, $utf8); $got++ }
"DOM states captured: $got of $($jobs.Count) (widths: $($cfg.widths -join ', '))"; if ($errs.Count) { $errs | ForEach-Object { "CAPTURE ERROR $_" } }
# ---- screenshots ----
$shots = 0
if (-not $NoScreens) {
  foreach ($w in $cfg.widths) { foreach ($sc in $cfg.screens) { if ($sc.maxWidth -and $w -gt $sc.maxWidth) { continue }; if ($sc.minWidth -and $w -lt $sc.minWidth) { continue }
    $hk = ($cfg.states | Where-Object { $_.key -eq $sc.key } | Select-Object -First 1); $h = if ($heights.ContainsKey("default@$w")) { [Math]::Max(900, [Math]::Min(14000, $heights["default@$w"] + 80)) } else { 3000 }
    $png = "$outDir\png\$($sc.key)@$w.png"; $u = $pageUrl + $sc.query
    Start-Process -FilePath $chrome -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', "--window-size=$w,$h", '--hide-scrollbars', '--virtual-time-budget=6000', "--screenshot=`"$png`"", "`"$u`"") -Wait -NoNewWindow -RedirectStandardError "$tmp\shot.err" -RedirectStandardOutput "$tmp\shot.out"
    if (Test-Path $png) { $shots++ } else { $errs += "screenshot missing: $($sc.key)@$w" } } }
  "screenshots captured: $shots"
}
if ($Baseline) { "baseline written to $baseDir"; if ($errs.Count -or $got -ne $jobs.Count) { exit 1 }; exit 0 }
# ---- compare ----
$same = 0; $bad = @(); $missing = @()
foreach ($j in $jobs) { $safe = $j.key -replace '[^\w@-]', '_'; $a = "$baseDir\dom\$safe.txt"; $b = "$outDir\dom\$safe.txt"
  if (-not (Test-Path $a)) { $missing += "baseline missing: $($j.key)"; continue }; if (-not (Test-Path $b)) { $bad += "$($j.key): not captured"; continue }
  $ta = [IO.File]::ReadAllText($a, $utf8); $tb = [IO.File]::ReadAllText($b, $utf8)
  if ($ta -ceq $tb) { $same++ } else { $n = 0; while ($n -lt $ta.Length -and $n -lt $tb.Length -and $ta[$n] -ceq $tb[$n]) { $n++ }; $s = [Math]::Max(0, $n - 80); $bad += "$($j.key): first difference at $n`n      baseline: ...$($ta.Substring($s, [Math]::Min(220, $ta.Length - $s)))`n      current : ...$($tb.Substring($s, [Math]::Min(220, $tb.Length - $s)))" } }
"DOM states identical to baseline: $same of $($jobs.Count)"
$pxOk = 0; $pxBad = @()
if (-not $NoScreens) { foreach ($f in (Get-ChildItem "$baseDir\png" -File -Filter *.png)) { $b = "$outDir\png\$($f.Name)"; if (-not (Test-Path $b)) { $pxBad += "$($f.Name): not captured"; continue }
    $r = [PixDiff]::Compare($f.FullName, $b, 60).Split('|'); if ($r[0] -eq 'size') { $pxBad += "$($f.Name): size differs baseline $($r[1]) current $($r[2])" } elseif ([double]$r[1] -le $MaxPixelPercent) { $pxOk++ } else { $pxBad += "$($f.Name): $($r[1]) % of pixels differ" } }
  "screenshots within $MaxPixelPercent % of baseline: $pxOk of $((Get-ChildItem "$baseDir\png" -File -Filter *.png).Count)" }
$missing | ForEach-Object { "MISSING $_" }; $bad | ForEach-Object { "DIFFERENT $_" }; $pxBad | ForEach-Object { "PIXELS $_" }; $errs | ForEach-Object { "ERROR $_" }
if ($bad.Count -or $missing.Count -or $pxBad.Count -or $errs.Count -or $same -ne $jobs.Count) { 'rendered equivalence: FAILED'; exit 1 } else { 'rendered equivalence: PASS' }
