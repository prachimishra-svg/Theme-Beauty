# Prints the position and size of elements in a wireframe, to compare an approved page with its Tailwind version.
# Usage: rect-probe.ps1 -File <html> -Sel @{ header = '.hdr'; h1 = 'h1' } [-Width 1440] [-Query "state=multi"]
# The window is Width + 18 px so the page sees exactly Width px (Chrome's frame takes 18). Widths below 482 run in a 500 px window (headless minimum); use the iframe-based pixel-diff tool for exact phone widths.
param([Parameter(Mandatory = $true)][string]$File, [Parameter(Mandatory = $true)][hashtable]$Sel, [int]$Width = 1440, [string]$Query = "")
$f = (Resolve-Path $File).Path
$dir = Split-Path -Parent $f
$tmp = Join-Path ([IO.Path]::GetTempPath()) "nudge-tools"; New-Item -ItemType Directory -Force $tmp | Out-Null
$items = @($Sel.GetEnumerator() | ForEach-Object { @{ n = $_.Key; s = $_.Value } })
$json = ConvertTo-Json -InputObject $items -Compress
$probe = "<script>var S=$json;" + @'
window.addEventListener("load",function(){setTimeout(function(){var o=[];S.forEach(function(p){var e=document.querySelector(p.s);if(!e){o.push(p.n+": missing");return}var r=e.getBoundingClientRect(),cs=getComputedStyle(e);o.push(p.n+": x"+Math.round(r.left)+" y"+Math.round(r.top+scrollY)+" w"+Math.round(r.width)+" h"+Math.round(r.height)+" | "+cs.fontSize+" "+cs.fontWeight+" "+cs.lineHeight+" "+cs.fontFamily.split(",")[0])});var pre=document.createElement("pre");pre.id="dbg";pre.textContent=o.join("\n");document.body.appendChild(pre)},2500)});
</script></body>
'@
$t = [IO.File]::ReadAllText($f, [Text.Encoding]::UTF8)
$base = '<base href="file:///' + (($dir -replace '\\', '/') -replace ' ', '%20') + '/">'
$copy = Join-Path $tmp ("probe-" + [guid]::NewGuid().ToString('N') + ".html")
[IO.File]::WriteAllText($copy, $t.Replace('<head>', '<head>' + $base).Replace('</body>', $probe))
$u = "file:///" + ($copy -replace '\\', '/') + "?embed=1&ann=0" + $(if ($Query) { "&$Query" } else { "" })
$out = Join-Path $tmp "probe.out"
Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList @("--headless=new", "--disable-gpu", "--hide-scrollbars", "--allow-file-access-from-files", "--window-size=$([Math]::Max($Width + 18,500)),1800", "--virtual-time-budget=9000", "--dump-dom", "`"$u`"") -RedirectStandardOutput $out -RedirectStandardError "$out.err" -Wait -NoNewWindow
[System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($out), '<pre id="dbg">([\s\S]*?)</pre>').Groups[1].Value)
Remove-Item $copy -Force
