# WCAG contrast check of the colour pairs the theme uses, computed from the Design Variables (02-Design-Variables/Styles/variables.css; var() chains are resolved).
# Solid colours only: text over gradients, photography and the translucent scrims cannot be computed this way and stay on the manual list (MANUAL-CHECKS.md).
# Thresholds: 4.5 for normal text, 3 for large text (24 px, or 18.66 px bold) and for UI components and graphics (WCAG 2.2 AA).
# Usage: .\tools\test-contrast.ps1
$P = Split-Path -Parent (Split-Path -Parent $PSScriptRoot); $utf8 = New-Object Text.UTF8Encoding($false)
$css = [IO.File]::ReadAllText("$P\02-Design-Variables\Styles\variables.css", $utf8)
$vars = @{}; foreach ($m in [regex]::Matches($css, '(--[\w-]+)\s*:\s*([^;]+);')) { if (-not $vars.ContainsKey($m.Groups[1].Value)) { $vars[$m.Groups[1].Value] = $m.Groups[2].Value.Trim() } }
function Resolve-Var([string]$v, [int]$d = 0) { if ($d -gt 12) { return $null }; $v = $v.Trim()
  $m = [regex]::Match($v, '^var\((--[\w-]+)(?:\s*,\s*(.+))?\)$'); if ($m.Success) { $n = $m.Groups[1].Value; if ($vars.ContainsKey($n)) { return Resolve-Var $vars[$n] ($d + 1) } elseif ($m.Groups[2].Success) { return Resolve-Var $m.Groups[2].Value ($d + 1) } else { return $null } }
  $v }
function To-Rgb([string]$c) { if (-not $c) { return $null }; $c = $c.Trim()
  if ($c -match '^#([0-9a-fA-F]{6})$') { $h = $Matches[1]; return @([Convert]::ToInt32($h.Substring(0,2),16), [Convert]::ToInt32($h.Substring(2,2),16), [Convert]::ToInt32($h.Substring(4,2),16)) }
  if ($c -match '^#([0-9a-fA-F]{3})$') { $h = $Matches[1]; return @([Convert]::ToInt32("$($h[0])$($h[0])",16), [Convert]::ToInt32("$($h[1])$($h[1])",16), [Convert]::ToInt32("$($h[2])$($h[2])",16)) }
  if ($c -match '^rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)') { return @([int]$Matches[1], [int]$Matches[2], [int]$Matches[3]) }
  $null }
function Lum($rgb) { $r = foreach ($x in $rgb) { $s = $x / 255.0; if ($s -le 0.03928) { $s / 12.92 } else { [Math]::Pow(($s + 0.055) / 1.055, 2.4) } }; 0.2126 * $r[0] + 0.7152 * $r[1] + 0.0722 * $r[2] }
function Ratio($a, $b) { $la = Lum $a; $lb = Lum $b; $hi = [Math]::Max($la, $lb); $lo = [Math]::Min($la, $lb); ($hi + 0.05) / ($lo + 0.05) }
# foreground token, background token, minimum, where it is used
$pairs = @(
  @('--color-text-primary', '--color-bg-page', 4.5, 'body text on the page'),
  @('--color-text-primary', '--color-bg-surface', 4.5, 'text on cards and the drawer'),
  @('--color-text-primary', '--color-bg-subtle', 4.5, 'text on subtle sections (finder, ritual, newsletter)'),
  @('--color-text-secondary', '--color-bg-page', 4.5, 'secondary text on the page'),
  @('--color-text-secondary', '--color-bg-surface', 4.5, 'secondary text on surfaces'),
  @('--color-text-secondary', '--color-bg-subtle', 4.5, 'secondary text on subtle sections'),
  @('--color-text-muted', '--color-bg-page', 4.5, 'muted text on the page (captions, placeholders)'),
  @('--color-text-muted', '--color-bg-surface', 4.5, 'muted text on surfaces'),
  @('--color-text-muted', '--color-bg-subtle', 4.5, 'muted text on subtle sections'),
  @('--color-brand-primary', '--color-bg-page', 4.5, 'brand-coloured links and labels on the page'),
  @('--color-brand-primary', '--color-bg-surface', 4.5, 'brand-coloured text on surfaces'),
  @('--color-brand-secondary', '--color-bg-page', 3, 'brand secondary (emphasised heading word, large text)'),
  @('--color-text-on-brand', '--color-brand-primary', 4.5, 'text on brand buttons, announcement bar and badges'),
  @('--color-text-inverse', '--color-bg-inverse', 4.5, 'text on dark sections (footer, video)'),
  @('--color-text-inverse-secondary', '--color-bg-inverse', 4.5, 'secondary text in the footer'),
  @('--color-status-error', '--color-bg-page', 4.5, 'error messages'),
  @('--color-status-success', '--color-bg-page', 4.5, 'success messages'),
  @('--color-status-warning', '--color-bg-surface', 4.5, '"Only 3 left" notice in the drawer'),
  @('--color-border-strong', '--color-bg-page', 3, 'input and button outlines (UI component contrast)'),
  @('--color-focus-ring', '--color-bg-page', 3, 'focus indicator on the page')
)
$fail = 0; $rows = @()
foreach ($p in $pairs) {
  $f = To-Rgb (Resolve-Var "var($($p[0]))"); $b = To-Rgb (Resolve-Var "var($($p[1]))")
  if (-not $f -or -not $b) { $rows += "skip   {0} on {1}: could not resolve to a solid colour" -f $p[0], $p[1]; continue }
  $r = Ratio $f $b; $ok = $r -ge $p[2]; if (-not $ok) { $fail++ }
  $rows += "{0} {1,5:0.00}:1 (min {2})  {3} on {4}  [{5}]" -f $(if ($ok) { 'pass  ' } else { 'FAIL  ' }), $r, $p[2], $p[0], $p[1], $p[3]
}
$rows; "{0} pairs checked, {1} below the WCAG 2.2 AA threshold" -f $pairs.Count, $fail