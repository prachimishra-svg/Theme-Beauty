# Generates Liquid snippets from library components into 07-Component-Library/shopify/staging/snippets (NEVER into 06-Shopify-Theme).
# Usage: .\tools\generate-liquid-staging.ps1 [-Components base]   (a folder group such as base, or a list of component ids)
param([string[]]$Components = @('base'))
$ErrorActionPreference = 'Stop'
$LIBDIR = Split-Path -Parent $PSScriptRoot; $utf8 = New-Object Text.UTF8Encoding($false)
. "$PSScriptRoot\liquid-kit.ps1"
Add-Type -AssemblyName System.Web.Extensions
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer; $ser.MaxJsonLength = [int]::MaxValue; $ser.RecursionLimit = 200
& "$LIBDIR\build-library.ps1" | Out-Null
$ld = [IO.File]::ReadAllText("$LIBDIR\library.data.js", $utf8); $lib = $ser.DeserializeObject($ld.Substring($ld.IndexOf('window.NUDGE_LIB = ') + 19).TrimEnd().TrimEnd(';'))
# the library JSON uses dictionaries; the kit reads properties with dot syntax, so convert to objects
$comps = @{}; foreach ($k in $lib.components.Keys) { $c = $lib.components[$k]; $comps[$k] = [pscustomobject]@{ html = $c.html; manifest = ($ser.Serialize($c.manifest) | ConvertFrom-Json); group = $c.group } }
$targets = @(); foreach ($t in $Components) { if ($t -like 'components/*') { $targets += $t } else { $targets += @($comps.Keys | Where-Object { $comps[$_].group -eq $t } | Sort-Object) } }
$out = Join-Path $LIBDIR 'shopify\staging\snippets'; New-Item -ItemType Directory -Force $out | Out-Null
$ok = 0; $bad = @()
foreach ($n in $targets) { try { $s = LK-Snippet $n $comps; [IO.File]::WriteAllText((Join-Path $out ((LK-SnippetName $n) + '.liquid')), $s, $utf8); $ok++ } catch { $bad += "$n : $($_.Exception.Message)" } }
"snippets written to shopify/staging/snippets: $ok of $($targets.Count)"; $bad | ForEach-Object { "NOT CONVERTED $_" }
if ($bad.Count) { exit 1 }
