<#
  NUDGE icon builder  (single source of truth for the icon set)

  Generates, from the table below:
    05-Assets/Icons/<name>.svg      standalone icons (for img/CSS use or Liquid snippets)
    05-Assets/Icons/sprite.svg      <symbol> sprite
    index.html                   re-injects the sprite between the ICON-SPRITE markers

  ICON LIBRARY: Lucide (https://lucide.dev, ISC licence). Geometry is copied unmodified from lucide-static 0.469.0.
  Each row is  'project-name' = @('lucide-icon-name', '<inner svg markup>'). Only the listed icons ship, never the full library.
  Rules for every icon: 24x24 viewBox, 1.5 stroke (project standard; Lucide's default is 2), round caps/joins, no fill
  (a filled state is applied in CSS only, see .icon--filled). Add an icon by adding a row, then re-run:
    powershell -ExecutionPolicy Bypass -File 05-Assets/Icons/build-icons.ps1
#>
$proj = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)   # project root (this script lives in 05-Assets/Icons)
$utf8 = New-Object System.Text.UTF8Encoding($false)

$icons = [ordered]@{
  'search'        = @('search', '<circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/>')
  'account'       = @('user', '<path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>')
  'bag'           = @('shopping-bag', '<path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/>')
  'menu'          = @('menu', '<line x1="4" x2="20" y1="12" y2="12"/><line x1="4" x2="20" y1="6" y2="6"/><line x1="4" x2="20" y1="18" y2="18"/>')
  'close'         = @('x', '<path d="M18 6 6 18"/><path d="m6 6 12 12"/>')
  'plus'          = @('plus', '<path d="M5 12h14"/><path d="M12 5v14"/>')
  'minus'         = @('minus', '<path d="M5 12h14"/>')
  'chevron-down'  = @('chevron-down', '<path d="m6 9 6 6 6-6"/>')
  'chevron-up'    = @('chevron-up', '<path d="m18 15-6-6-6 6"/>')
  'chevron-left'  = @('chevron-left', '<path d="m15 18-6-6 6-6"/>')
  'chevron-right' = @('chevron-right', '<path d="m9 18 6-6-6-6"/>')
  'arrow-left'    = @('arrow-left', '<path d="m12 19-7-7 7-7"/><path d="M19 12H5"/>')
  'arrow-right'   = @('arrow-right', '<path d="M5 12h14"/><path d="m12 5 7 7-7 7"/>')
  'filter'        = @('sliders-horizontal', '<line x1="21" x2="14" y1="4" y2="4"/><line x1="10" x2="3" y1="4" y2="4"/><line x1="21" x2="12" y1="12" y2="12"/><line x1="8" x2="3" y1="12" y2="12"/><line x1="21" x2="16" y1="20" y2="20"/><line x1="12" x2="3" y1="20" y2="20"/><line x1="14" x2="14" y1="2" y2="6"/><line x1="8" x2="8" y1="10" y2="14"/><line x1="16" x2="16" y1="18" y2="22"/>')
  'sort'          = @('arrow-up-down', '<path d="m21 16-4 4-4-4"/><path d="M17 20V4"/><path d="m3 8 4-4 4 4"/><path d="M7 4v16"/>')
  'heart'         = @('heart', '<path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/>')
  'star'          = @('star', '<path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"/>')
  'location'      = @('map-pin', '<path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/><circle cx="12" cy="10" r="3"/>')
  'lock'          = @('lock', '<rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>')
  'check'         = @('check', '<path d="M20 6 9 17l-5-5"/>')
  'check-circle'  = @('circle-check', '<circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/>')
  'info'          = @('info', '<circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/>')
  'warning'       = @('triangle-alert', '<path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/>')
  'eye'           = @('eye', '<path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"/><circle cx="12" cy="12" r="3"/>')
  'eye-off'       = @('eye-off', '<path d="M10.733 5.076a10.744 10.744 0 0 1 11.205 6.575 1 1 0 0 1 0 .696 10.747 10.747 0 0 1-1.444 2.49"/><path d="M14.084 14.158a3 3 0 0 1-4.242-4.242"/><path d="M17.479 17.499a10.75 10.75 0 0 1-15.417-5.151 1 1 0 0 1 0-.696 10.75 10.75 0 0 1 4.446-5.143"/><path d="m2 2 20 20"/>')
  'share'         = @('share-2', '<circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" x2="15.42" y1="13.51" y2="17.49"/><line x1="15.41" x2="8.59" y1="6.51" y2="10.49"/>')
  'instagram'     = @('instagram', '<rect width="20" height="20" x="2" y="2" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" x2="17.51" y1="6.5" y2="6.5"/>')
  'facebook'      = @('facebook', '<path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/>')
  'youtube'       = @('youtube', '<path d="M2.5 17a24.12 24.12 0 0 1 0-10 2 2 0 0 1 1.4-1.4 49.56 49.56 0 0 1 16.2 0A2 2 0 0 1 21.5 7a24.12 24.12 0 0 1 0 10 2 2 0 0 1-1.4 1.4 49.55 49.55 0 0 1-16.2 0A2 2 0 0 1 2.5 17"/><path d="m10 15 5-3-5-3z"/>')
  'mail'          = @('mail', '<rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-10 6L2 7"/>')
  'phone'         = @('phone', '<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.13.96.36 1.9.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.91.34 1.85.57 2.81.7A2 2 0 0 1 22 16.92z"/>')
  'clock'         = @('clock', '<circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/>')
  'zoom-in'       = @('zoom-in', '<circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/><path d="M11 8v6"/><path d="M8 11h6"/>')
  'play'          = @('play', '<polygon points="6 3 20 12 6 21 6 3"/>')
  'truck'         = @('truck', '<path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2"/><path d="M15 18H9"/><path d="M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14"/><circle cx="17" cy="18" r="2"/><circle cx="7" cy="18" r="2"/>')
  'rotate-ccw'    = @('rotate-ccw', '<path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/>')
  'shield-check'  = @('shield-check', '<path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/><path d="m9 12 2 2 4-4"/>')
  'store'         = @('store', '<path d="m2 7 4.41-4.41A2 2 0 0 1 7.83 2h8.34a2 2 0 0 1 1.42.59L22 7"/><path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8"/><path d="M15 22v-4a2 2 0 0 0-2-2h-2a2 2 0 0 0-2 2v4"/><path d="M2 7h20"/>')
  'loader'        = @('loader-circle', '<path d="M21 12a9 9 0 1 1-6.219-8.56"/>')
}

$iconDir = $PSScriptRoot
New-Item -ItemType Directory -Force $iconDir | Out-Null
Get-ChildItem $iconDir -Filter *.svg | Remove-Item

$symbols = @()
foreach ($name in $icons.Keys) {
  $body = $icons[$name][1]
  $file = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false">' + $body + '</svg>'
  [IO.File]::WriteAllText((Join-Path $iconDir "$name.svg"), $file + "`n", $utf8)
  $symbols += "  <symbol id=`"icon-$name`" viewBox=`"0 0 24 24`">$body</symbol>"
}

$sprite = '<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false" style="position:absolute;width:0;height:0;overflow:hidden">' + "`n" + ($symbols -join "`n") + "`n</svg>"
[IO.File]::WriteAllText((Join-Path $iconDir 'sprite.svg'), $sprite + "`n", $utf8)

$index = Join-Path $proj '01-Design-System\index.html'
if (Test-Path $index) {
  $html = [IO.File]::ReadAllText($index)
  $pattern = '(?s)<!-- ICON-SPRITE:START -->.*?<!-- ICON-SPRITE:END -->'
  $replacement = "<!-- ICON-SPRITE:START -->`n$sprite`n<!-- ICON-SPRITE:END -->"
  $html = [regex]::Replace($html, $pattern, { param($m) $replacement })
  [IO.File]::WriteAllText($index, $html, $utf8)
}
Write-Host "Built $($icons.Count) icons."
