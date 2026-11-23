param([string]$File, [int[]]$Widths = @(1920, 1440, 1280, 768, 430, 390, 320), [string]$Extra = "")
$sp = Join-Path ([IO.Path]::GetTempPath()) "nudge-tools"; New-Item -ItemType Directory -Force $sp | Out-Null
$f = (Resolve-Path $File).Path
$u = "file:///" + ($f -replace '\\', '/' -replace ' ', '%20') + "?embed=1&ann=0&selftest=1" + $Extra
foreach ($w in $Widths) {
  $h = 900
  $page = "<!doctype html><html><body style=`"margin:0`"><iframe src=`"$u`" style=`"width:${w}px;height:${h}px;border:0`"></iframe><pre id=`"out`">pending</pre><script>addEventListener('message',function(e){if(e.data&&e.data.selftest)document.getElementById('out').textContent=JSON.stringify(e.data.selftest)})</script></body></html>"
  $fr = Join-Path $sp "twt-frame.html"; [IO.File]::WriteAllText($fr, $page)
  $dump = Join-Path $sp "twt-dump-$w.html"
  Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList @("--headless=new","--disable-gpu","--allow-file-access-from-files","--window-size=$([Math]::Max($w+20,600)),$h","--virtual-time-budget=14000","--dump-dom","`"file:///$(($fr -replace '\\', '/') -replace ' ', '%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
  $raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump), '<pre id="out">([\s\S]*?)</pre>').Groups[1].Value)
  if ($raw -eq 'pending') { "{0,5}px: no result" -f $w; continue }
  $j = $raw | ConvertFrom-Json; $c = @($j.checks.PSObject.Properties)
  $bad = @($c | Where-Object { -not $_.Value.pass })
  "{0,5}px: {1}/{2} checks pass" -f $w, ($c.Count - $bad.Count), $c.Count
  $bad | ForEach-Object { "   FAIL {0}: {1}" -f $_.Name, $_.Value.detail }
}