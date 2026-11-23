# Makes the hero photo from the reference composite (reference/hero-reference.png: a 1926 x 816 screenshot of the first fold with the announcement bar, header, headline, buttons and featured card baked in).
# 1) the announcement bar is cropped off; 2) every baked-in UI element is removed by diffusion inpainting from the surrounding pixels (plus fine grain so the fill matches the photo); 3) the photo is saved as images-hero-photo/hero-campaign.jpg;
# 4) the serum bottle in the featured card is cropped to images-hero-photo/hero-product.jpg. The model, flowers and background are the reference photo's own pixels, unchanged.
# NOTE: this works from a screenshot. A clean original photograph (no UI on it) would be sharper; if you have it, save it as images-hero-photo/hero-campaign.jpg and skip this script.
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition @"
using System; using System.Drawing; using System.Drawing.Imaging; using System.Collections.Generic;
public static class Inpaint {
  public static Bitmap Run(string path, int cropTop, int[][] rects, int iters, double grain, int seed, double[] dome) {
    Bitmap src = new Bitmap(path); int W = src.Width, H = src.Height - cropTop;
    Bitmap bmp = new Bitmap(W, H, PixelFormat.Format24bppRgb); using (Graphics g = Graphics.FromImage(bmp)) g.DrawImage(src, new Rectangle(0, 0, W, H), new Rectangle(0, cropTop, W, H), GraphicsUnit.Pixel); src.Dispose();
    BitmapData d = bmp.LockBits(new Rectangle(0, 0, W, H), ImageLockMode.ReadWrite, PixelFormat.Format24bppRgb); int stride = d.Stride; byte[] px = new byte[stride * H]; System.Runtime.InteropServices.Marshal.Copy(d.Scan0, px, 0, px.Length);
    Random rnd = new Random(seed);
    foreach (int[] r in rects) {
      int x0 = Math.Max(1, r[0]), y0 = Math.Max(1, r[1] - cropTop), x1 = Math.Min(W - 2, r[2]), y1 = Math.Min(H - 2, r[3] - cropTop); int w = x1 - x0 + 1, h = y1 - y0 + 1; if (w < 1 || h < 1) continue;
      bool flat = r.Length > 4 && r[4] == 1;
      double[][] v = new double[3][]; for (int c = 0; c < 3; c++) v[c] = new double[w * h];
      for (int y = 0; y < h; y++) for (int x = 0; x < w; x++) { double tx = (double)x / Math.Max(1, w - 1), ty = (double)y / Math.Max(1, h - 1);
        for (int c = 0; c < 3; c++) { double L = px[(y0 + y) * stride + (x0 - 1) * 3 + c], R = px[(y0 + y) * stride + (x1 + 1) * 3 + c], T = px[(y0 - 1) * stride + (x0 + x) * 3 + c], B = px[(y1 + 1) * stride + (x0 + x) * 3 + c]; v[c][y * w + x] = ((L * (1 - tx) + R * tx) + (T * (1 - ty) + B * ty)) / 2.0; } }
      if (flat) { for (int y = 0; y < h; y++) for (int x = 0; x < w; x++) for (int c = 0; c < 3; c++) { double n = (rnd.NextDouble() + rnd.NextDouble() + rnd.NextDouble() - 1.5) * grain; int val = (int)Math.Round(px[(y0 - 1) * stride + (x0 + x) * 3 + c] + n); px[(y0 + y) * stride + (x0 + x) * 3 + c] = (byte)Math.Max(0, Math.Min(255, val)); } continue; }
      double om = 1.85;
      for (int it = 0; it < iters; it++) for (int c = 0; c < 3; c++) { double[] a = v[c];
        for (int y = 0; y < h; y++) for (int x = 0; x < w; x++) {
          double l = x > 0 ? a[y * w + x - 1] : px[(y0 + y) * stride + (x0 - 1) * 3 + c], rr = x < w - 1 ? a[y * w + x + 1] : px[(y0 + y) * stride + (x1 + 1) * 3 + c],
                 t = y > 0 ? a[(y - 1) * w + x] : px[(y0 - 1) * stride + (x0 + x) * 3 + c], b = y < h - 1 ? a[(y + 1) * w + x] : px[(y1 + 1) * stride + (x0 + x) * 3 + c];
          double nv = (l + rr + t + b) / 4.0; a[y * w + x] += om * (nv - a[y * w + x]); } }
      for (int y = 0; y < h; y++) for (int x = 0; x < w; x++) for (int c = 0; c < 3; c++) { double n = (rnd.NextDouble() + rnd.NextDouble() + rnd.NextDouble() - 1.5) * grain; int val = (int)Math.Round(v[c][y * w + x] + n); px[(y0 + y) * stride + (x0 + x) * 3 + c] = (byte)Math.Max(0, Math.Min(255, val)); }
    }
    if (dome != null) { /* the search pill hides the crown of the hair in the reference: let the visible hair dissolve softly into the background over len rows instead of ending on a straight line */
      int fx0 = (int)dome[0], fx1 = (int)dome[2], fy0 = (int)dome[1] - cropTop, len = (int)dome[3];
      for (int y = fy0; y < fy0 + len && y < H; y++) { double t = (double)(y - fy0) / len; double al = t * t * (3.0 - 2.0 * t);
        for (int x = fx0; x <= fx1; x++) { double edge = Math.Min(1.0, Math.Min((x - fx0), (fx1 - x)) / 24.0); double a2 = al + (1.0 - al) * (1.0 - edge) * 0.0; for (int c = 0; c < 3; c++) { double bg = px[(fy0 - 1) * stride + x * 3 + c], o = px[y * stride + x * 3 + c]; px[y * stride + x * 3 + c] = (byte)Math.Max(0, Math.Min(255, Math.Round(bg * (1 - a2) + o * a2))); } } } }
    System.Runtime.InteropServices.Marshal.Copy(px, 0, d.Scan0, px.Length); bmp.UnlockBits(d); return bmp;
  }
}
"@ -ReferencedAssemblies System.Drawing
$ref = Join-Path $here 'reference\hero-reference.png'; $out = Join-Path $here 'images-hero-photo'; New-Item -ItemType Directory -Force $out | Out-Null
# baked-in UI to remove (source pixels, a few pixels of padding): header row, headline block, paragraph, buttons, featured card
$rects = @( ,@(128, 62, 515, 122) ; ,@(528, 52, 732, 128) ; ,@(876, 66, 1060, 116) ; ,@(1203, 52, 1512, 133, 1) ; ,@(1522, 62, 1796, 116) ; ,@(130, 252, 792, 548) ; ,@(130, 548, 652, 622) ; ,@(130, 648, 604, 726) ; ,@(1463, 593, 1845, 724) )
$bmp = [Inpaint]::Run($ref, 46, [int[][]]$rects, 900, 1.6, 7, [double[]]@(1180, 133, 1560, 46))
$enc = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }; $ep = New-Object Drawing.Imaging.EncoderParameters 1; $ep.Param[0] = New-Object Drawing.Imaging.EncoderParameter ([Drawing.Imaging.Encoder]::Quality, [long]93)
$bmp.Save((Join-Path $out 'hero-campaign.jpg'), $enc, $ep); "hero-campaign.jpg $($bmp.Width) x $($bmp.Height)"; $bmp.Dispose()
# serum bottle from the featured card (4:5 crop, upscaled 3x)
$src = New-Object Drawing.Bitmap $ref; $crop = New-Object Drawing.Bitmap 210, 262; $g = [Drawing.Graphics]::FromImage($crop); $g.InterpolationMode = 'HighQualityBicubic'; $g.DrawImage($src, (New-Object Drawing.Rectangle 0, 0, 210, 262), (New-Object Drawing.Rectangle 1489, 613, 70, 88), 'Pixel'); $g.Dispose()
$crop.Save((Join-Path $out 'hero-product.jpg'), $enc, $ep); $crop.Dispose(); $src.Dispose(); 'hero-product.jpg 210 x 262'