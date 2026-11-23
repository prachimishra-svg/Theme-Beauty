# Renders two wireframe files in headless Chrome at each width and reports how much of the picture differs.
# Acceptance gate for a Tailwind conversion: at most 2% of pixels differing by more than the threshold, and the same page height (within 2 px).
# Usage: pixel-diff.ps1 -A <approved file> -B <tailwind file> [-QueryA "..."] [-QueryB "..."] [-Widths 1440,390] [-Height 5000] [-Out <png prefix>]
param([Parameter(Mandatory = $true)][string]$A, [Parameter(Mandatory = $true)][string]$B, [string]$Query = "", [int[]]$Widths = @(1440, 390), [int]$Height = 5000, [int]$Threshold = 60, [string]$Out = "")
$ErrorActionPreference = 'Continue'
Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition @'
using System; using System.Drawing; using System.Drawing.Imaging; using System.Collections.Generic;
public static class PxDiff {
  public static string Compare(string a, string b, int thr, string outPath, int band) {
    using (var A = new Bitmap(a)) using (var B = new Bitmap(b)) {
      int w = Math.Min(A.Width, B.Width), h = Math.Min(A.Height, B.Height);
      var ra = A.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
      var rb = B.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
      byte[] pa = new byte[ra.Stride * h], pb = new byte[rb.Stride * h];
      System.Runtime.InteropServices.Marshal.Copy(ra.Scan0, pa, 0, pa.Length); System.Runtime.InteropServices.Marshal.Copy(rb.Scan0, pb, 0, pb.Length);
      A.UnlockBits(ra); B.UnlockBits(rb);
      long diff = 0; int bands = (h + band - 1) / band; long[] bd = new long[bands];
      byte[] po = outPath.Length > 0 ? new byte[pb.Length] : null;
      for (int y = 0; y < h; y++) for (int x = 0; x < w; x++) {
        int i = y * ra.Stride + x * 4;
        int d = Math.Abs(pa[i] - pb[i]) + Math.Abs(pa[i + 1] - pb[i + 1]) + Math.Abs(pa[i + 2] - pb[i + 2]);
        bool bad = d > thr; if (bad) { diff++; bd[y / band]++; }
        if (po != null) { if (bad) { po[i] = 0; po[i + 1] = 0; po[i + 2] = 230; } else { po[i] = (byte)(255 - (255 - pb[i]) / 4); po[i + 1] = (byte)(255 - (255 - pb[i + 1]) / 4); po[i + 2] = (byte)(255 - (255 - pb[i + 2]) / 4); } po[i + 3] = 255; }
      }
      if (po != null) { using (var O = new Bitmap(w, h, PixelFormat.Format32bppArgb)) { var ro = O.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb); System.Runtime.InteropServices.Marshal.Copy(po, 0, ro.Scan0, po.Length); O.UnlockBits(ro); O.Save(outPath, ImageFormat.Png); } }
      var worst = new List<string>(); var idx = new List<int>(); for (int k = 0; k < bands; k++) idx.Add(k);
      idx.Sort((p, q) => bd[q].CompareTo(bd[p]));
      for (int k = 0; k < Math.Min(5, idx.Count); k++) { double pc = 100.0 * bd[idx[k]] / ((double)w * band); if (pc > 0.5) worst.Add("y" + (idx[k] * band) + "-" + (idx[k] * band + band) + ":" + pc.ToString("0.0") + "%"); }
      return string.Format("{0:0.00}|{1}|{2}|{3}|{4}", 100.0 * diff / ((double)w * h), A.Height, B.Height, w, string.Join(" ", worst));
    }
  }
}
'@ -ReferencedAssemblies System.Drawing
$sp = Join-Path ([IO.Path]::GetTempPath()) ("pxd" + [guid]::NewGuid().ToString('N')); New-Item -ItemType Directory $sp | Out-Null
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
function Shot([string]$file, [int]$w, [string]$png) {
  $f = (Resolve-Path $file).Path
  $u = "file:///" + ($f -replace '\\', '/' -replace ' ', '%20') + "?embed=1&ann=0" + $(if ($Query) { "&$Query" } else { "" })
  if ($w -lt 600) {
    $fr = Join-Path $sp "fr-$w-$([guid]::NewGuid().ToString('N')).html"
    [IO.File]::WriteAllText($fr, "<!doctype html><html><body style=`"margin:0;background:#fff`"><iframe src=`"$u`" style=`"width:${w}px;height:${Height}px;border:0;display:block`"></iframe></body></html>")
    $target = "file:///" + ($fr -replace '\\', '/'); $ww = 600
  } else { $target = $u; $ww = $w }
  & $chrome --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files --window-size="$ww,$Height" --virtual-time-budget=14000 --screenshot="$png" $target 2>$null | Out-Null
  if ($w -lt 600) {
    $img = [System.Drawing.Image]::FromFile($png); $bmp = New-Object System.Drawing.Bitmap $w, $Height
    $g = [System.Drawing.Graphics]::FromImage($bmp); $g.DrawImage($img, (New-Object System.Drawing.Rectangle 0, 0, $w, $Height), (New-Object System.Drawing.Rectangle 0, 0, $w, $Height), [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose(); $img.Dispose(); $bmp.Save($png + ".c.png"); $bmp.Dispose(); Move-Item ($png + ".c.png") $png -Force
  }
}
foreach ($w in $Widths) {
  $pa = Join-Path $sp "a-$w.png"; $pb = Join-Path $sp "b-$w.png"
  Shot $A $w $pa; Shot $B $w $pb
  $outPng = if ($Out) { "$Out-$w.png" } else { "" }
  $r = [PxDiff]::Compare($pa, $pb, $Threshold, $outPng, 100) -split '\|'
  "{0,5}px: {1}% of pixels differ by more than {2}; image height approved {3} vs tailwind {4}; worst bands: {5}" -f $w, $r[0], $Threshold, $r[1], $r[2], $(if ($r[4]) { $r[4] } else { 'none above 0.5%' })
}
Remove-Item $sp -Recurse -Force
