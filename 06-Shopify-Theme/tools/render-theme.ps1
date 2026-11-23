# Renders the theme locally with LiquidJS (tools/harness.js) in headless Chrome and writes the resulting HTML.
# Usage: .\tools\render-theme.ps1 -OutFile out.html [-Template index] [-DesignMode] [-SettingsJson '{"cart_type":"page"}'] [-Quiet]
# Returns an object { Html; Errors; Ms }. Errors are harness/Liquid problems (missing snippet, missing translation, missing asset, schema JSON errors, render errors).
param([string]$OutFile, [string]$Template = 'index', [switch]$DesignMode, [string]$SettingsJson = '{}', [switch]$Quiet, [switch]$LocalAssets, [string]$CartState = '', [string]$StaticJson = '{}')
$ErrorActionPreference = 'Stop'
$T = Split-Path -Parent $PSScriptRoot
Add-Type -AssemblyName System.Web.Extensions
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer; $ser.MaxJsonLength = [int]::MaxValue; $ser.RecursionLimit = 200
$utf8 = New-Object Text.UTF8Encoding($false)
$files = @{}
foreach ($d in 'layout', 'sections', 'snippets', 'templates', 'config', 'locales') {
  $dir = Join-Path $T $d; if (-not (Test-Path $dir)) { continue }
  Get-ChildItem $dir -Recurse -File | Where-Object { $_.Extension -in '.liquid', '.json' } | ForEach-Object {
    $rel = ($_.FullName.Substring($T.Length + 1) -replace '\\', '/'); $files[$rel] = [IO.File]::ReadAllText($_.FullName, $utf8)
  }
}
$assets = @(); if (Test-Path "$T\assets") { $assets = @(Get-ChildItem "$T\assets" -File | ForEach-Object { $_.Name }) }
$data = @{}; $sd = Join-Path $PSScriptRoot 'sample-data.json'; if (Test-Path $sd) { $data = $ser.DeserializeObject([IO.File]::ReadAllText($sd, $utf8)) }
if ($CartState) { $cf = $ser.DeserializeObject([IO.File]::ReadAllText((Join-Path $PSScriptRoot 'cart-fixtures.json'), $utf8)); if (-not $cf['carts'].ContainsKey($CartState)) { throw "unknown cart state $CartState" }; $data['cart'] = $cf['carts'][$CartState] }
$opts = @{ staticSections = $ser.DeserializeObject($StaticJson); template = $Template; designMode = [bool]$DesignMode; settingsOverride = $ser.DeserializeObject($SettingsJson) }
$bundle = $ser.Serialize(@{ files = $files; assets = $assets; data = $data; options = $opts }).Replace('</', '<\/').Replace([string][char]0x2028, '\u2028').Replace([string][char]0x2029, '\u2029')
$vend = 'file:///' + (($T -replace '\\', '/') -replace ' ', '%20') + '/tools'
$page = "<!doctype html><html><head><meta charset=`"utf-8`"><title>render</title></head><body><textarea id=`"out`"></textarea><script src=`"$vend/vendor/liquid.browser.min.js`"></script><script>window.BUNDLE=$bundle;</script><script src=`"$vend/harness.js`"></script></body></html>"
$tmp = Join-Path ([IO.Path]::GetTempPath()) 'nudge-liquid'; New-Item -ItemType Directory -Force $tmp | Out-Null
$pg = Join-Path $tmp 'render.html'; [IO.File]::WriteAllText($pg, $page, $utf8); $dump = Join-Path $tmp 'render-dump.html'
Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', '--window-size=1440,900', '--virtual-time-budget=20000', '--dump-dom', "`"file:///$(($pg -replace '\\','/') -replace ' ','%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
$raw = [IO.File]::ReadAllText($dump, $utf8)
$m = [regex]::Match($raw, '<textarea id="out">([\s\S]*?)</textarea>')
if (-not $m.Success -or -not $m.Groups[1].Value.Trim()) { throw "harness produced no output (see $dump and $dump.err)" }
$json = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value)
$res = $ser.DeserializeObject($json)
$outHtml = [string]$res['html']
if ($LocalAssets) { $au = 'file:///' + (("$T\assets" -replace '\\','/') -replace ' ','%20') + '/'; $outHtml = $outHtml.Replace('/assets/', $au) }
if ($OutFile) { [IO.File]::WriteAllText($OutFile, $outHtml, $utf8) }
$errs = @($res['errors'])
if (-not $Quiet) { "rendered {0} chars in {1} ms; {2} problem(s)" -f ([string]$res['html']).Length, $res['ms'], $errs.Count; $errs | Select-Object -Unique | ForEach-Object { "  - $_" } }
[pscustomobject]@{ Html = $outHtml; Errors = $errs; Ms = $res['ms'] }