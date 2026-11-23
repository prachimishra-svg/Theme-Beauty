# Visual comparison of the cart drawer: the theme (rendered with a 3-line cart) against the approved Cart Drawer wireframe (state multi, USD).
# Both drawers are opened in headless Chrome over the DevTools protocol (the theme's with a real click on the header cart button), the dialog's own rectangle is
# captured as a PNG from each, and the two PNGs are compared pixel by pixel (same method and threshold as the wireframe pixel-diff tool).
# Usage: .\tools\test-drawer-visual.ps1 -Theme <rendered page with cart_type drawer and a cart> [-Widths 1440,390] [-Out <png prefix>]
param([Parameter(Mandatory = $true)][string]$Theme, [int[]]$Widths = @(1440, 390), [string]$Out = '', [int]$Port = 9344)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition @'
using System; using System.Drawing; using System.Drawing.Imaging;
public static class DrawerDiff {
  public static string Compare(string a, string b, int thr, string outPath) {
    using (var A = new Bitmap(a)) using (var B = new Bitmap(b)) {
      int w = Math.Min(A.Width, B.Width), h = Math.Min(A.Height, B.Height);
      var ra = A.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
      var rb = B.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
      byte[] pa = new byte[ra.Stride * h], pb = new byte[rb.Stride * h];
      System.Runtime.InteropServices.Marshal.Copy(ra.Scan0, pa, 0, pa.Length); System.Runtime.InteropServices.Marshal.Copy(rb.Scan0, pb, 0, pb.Length);
      A.UnlockBits(ra); B.UnlockBits(rb);
      long diff = 0; byte[] po = outPath.Length > 0 ? new byte[pb.Length] : null;
      for (int y = 0; y < h; y++) for (int x = 0; x < w; x++) {
        int i = y * ra.Stride + x * 4; int d = Math.Abs(pa[i] - pb[i]) + Math.Abs(pa[i + 1] - pb[i + 1]) + Math.Abs(pa[i + 2] - pb[i + 2]); bool bad = d > thr; if (bad) diff++;
        if (po != null) { if (bad) { po[i] = 0; po[i + 1] = 0; po[i + 2] = 230; } else { po[i] = (byte)(255 - (255 - pb[i]) / 4); po[i + 1] = (byte)(255 - (255 - pb[i + 1]) / 4); po[i + 2] = (byte)(255 - (255 - pb[i + 2]) / 4); } po[i + 3] = 255; }
      }
      if (po != null) { using (var O = new Bitmap(w, h, PixelFormat.Format32bppArgb)) { var ro = O.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb); System.Runtime.InteropServices.Marshal.Copy(po, 0, ro.Scan0, po.Length); O.UnlockBits(ro); O.Save(outPath, ImageFormat.Png); } }
      return string.Format("{0:0.00}|{1}x{2}|{3}x{4}", 100.0 * diff / ((double)w * h), A.Width, A.Height, B.Width, B.Height);
    }
  }
}
'@ -ReferencedAssemblies System.Drawing
$T = Split-Path -Parent $PSScriptRoot; $P = Split-Path -Parent $T; $utf8 = New-Object Text.UTF8Encoding($false)
function ToUrl($path, $q = '') { 'file:///' + (((Resolve-Path $path).Path -replace '\\', '/') -replace ' ', '%20') + $q }
$wfDrawer = (Get-ChildItem (Join-Path $P '03-Wireframes\05-NUDGE-Beauty-Cart-Drawer-Wireframe') -Filter *.html | Select-Object -First 1).FullName
$prof = Join-Path ([IO.Path]::GetTempPath()) ('nudge-cdp-' + [guid]::NewGuid().ToString('N'))
$chrome = Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', "--remote-debugging-port=$Port", "--user-data-dir=`"$prof`"", '--allow-file-access-from-files', '--no-first-run', 'about:blank') -PassThru
try {
  $ver = $null; for ($i = 0; $i -lt 50 -and -not $ver; $i++) { try { $ver = Invoke-RestMethod "http://127.0.0.1:$Port/json" -TimeoutSec 2 } catch { Start-Sleep -Milliseconds 200 } }
  $tab = @($ver | Where-Object { $_.type -eq 'page' })[0]
  $ws = New-Object Net.WebSockets.ClientWebSocket; [void]$ws.ConnectAsync([Uri]$tab.webSocketDebuggerUrl, [Threading.CancellationToken]::None).GetAwaiter().GetResult()
  $script:id = 0
  function Send([string]$method, $params = @{}) {
    $script:id++; $my = $script:id
    $bytes = $utf8.GetBytes((@{ id = $my; method = $method; params = $params } | ConvertTo-Json -Depth 12 -Compress)); [void]$ws.SendAsync([ArraySegment[byte]]$bytes, 'Text', $true, [Threading.CancellationToken]::None).GetAwaiter().GetResult()
    while ($true) { $buf = New-Object byte[] 1048576; $sb = New-Object Text.StringBuilder
      do { $r = $ws.ReceiveAsync([ArraySegment[byte]]$buf, [Threading.CancellationToken]::None).GetAwaiter().GetResult(); [void]$sb.Append($utf8.GetString($buf, 0, $r.Count)) } until ($r.EndOfMessage)
      $o = $sb.ToString() | ConvertFrom-Json; if ($o.id -eq $my) { if ($o.error) { throw "CDP $method : $($o.error.message)" }; return $o.result } }
  }
  function Ev([string]$expr) { $r = Send 'Runtime.evaluate' @{ expression = $expr; returnByValue = $true; awaitPromise = $true }; if ($r.exceptionDetails) { throw "JS: $($r.exceptionDetails.exception.description)" }; $r.result.value }
  function Shot([string]$file, $clip) { $r = Send 'Page.captureScreenshot' @{ format = 'png'; clip = @{ x = $clip[0]; y = $clip[1]; width = $clip[2]; height = $clip[3]; scale = 1 } }; [IO.File]::WriteAllBytes($file, [Convert]::FromBase64String($r.data)) }
  [void](Send 'Page.enable'); [void](Send 'Runtime.enable')
  $tmp = Join-Path ([IO.Path]::GetTempPath()) 'nudge-drawer-visual'; New-Item -ItemType Directory -Force $tmp | Out-Null
  $noAnim = "(function(){var s=document.createElement('style');s.textContent='*{transition:none!important;animation:none!important;scroll-behavior:auto!important}';document.head.appendChild(s)})()"
  $rectJs = "(function(){var d=document.getElementById('cart-drawer');var b=d.getBoundingClientRect();return [Math.round(b.left),Math.round(b.top),Math.round(b.width),Math.round(b.height)]})()"
  foreach ($w in $Widths) {
    [void](Send 'Emulation.setDeviceMetricsOverride' @{ width = $w; height = 900; deviceScaleFactor = 1; mobile = ($w -lt 600) })
    [void](Send 'Page.navigate' @{ url = (ToUrl $wfDrawer '?embed=1&ann=0&cur=USD&state=multi') }); Start-Sleep -Milliseconds 1800; [void](Ev $noAnim)
    if (-not (Ev "document.getElementById('cart-drawer').open")) { [void](Ev "window.NudgeCartDrawer.open()"); Start-Sleep -Milliseconds 300 }
    $rw = Ev $rectJs; $f1 = Join-Path $tmp "wf-$w.png"; Shot $f1 $rw
    [void](Send 'Page.navigate' @{ url = (ToUrl $Theme) }); Start-Sleep -Milliseconds 1800; [void](Ev $noAnim)
    [void](Ev "document.querySelector('#site-header [data-drawer-open=cart-drawer]').click()"); Start-Sleep -Milliseconds 400
    $rt = Ev $rectJs; $f2 = Join-Path $tmp "th-$w.png"; Shot $f2 $rt
    $png = if ($Out) { "$Out-$w.png" } else { '' }
    $res = [DrawerDiff]::Compare($f1, $f2, 60, $png).Split('|')
    "{0,5}px: drawer {1} differs {2}% of pixels (wireframe {3}, theme {4}; panel rect wireframe [{5}] theme [{6}])" -f $w, $(if ([double]$res[0] -le 2) { 'OK' } else { 'DIFFERS' }), $res[0], $res[1], $res[2], ($rw -join ','), ($rt -join ',')
  }
} finally {
  try { if ($ws) { $ws.Dispose() } } catch {}
  if ($chrome -and -not $chrome.HasExited) { Stop-Process -Id $chrome.Id -Force -ErrorAction SilentlyContinue }
  Get-CimInstance Win32_Process -Filter "Name='chrome.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*$prof*" } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
  Start-Sleep -Milliseconds 300; Remove-Item $prof -Recurse -Force -ErrorAction SilentlyContinue
}
