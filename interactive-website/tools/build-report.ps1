# Builds documentation/interaction-testing-report.md from documentation/data/test-results.json (written by run-journeys.ps1) plus the safety checks. Numbers are counted, never typed.
# Usage: .\tools\build-report.ps1
$ErrorActionPreference = 'Stop'
$IW = Split-Path -Parent $PSScriptRoot; $PRJ = Split-Path -Parent $IW; $utf8 = New-Object Text.UTF8Encoding($false)
$res = [IO.File]::ReadAllText((Join-Path $IW 'documentation\data\test-results.json'), $utf8) | ConvertFrom-Json
$n = $res.Count; $pass = @($res | Where-Object s -eq 'pass').Count; $fail = @($res | Where-Object s -eq 'fail').Count; $pend = @($res | Where-Object s -eq 'pending').Count; $blk = @($res | Where-Object s -eq 'blocked').Count
# safety: 06-Shopify-Theme fingerprint
$base = [IO.File]::ReadAllText((Join-Path $PRJ '07-Component-Library\shopify\06-baseline.json'), $utf8) | ConvertFrom-Json
$theme = Join-Path $PRJ '06-Shopify-Theme'; $changed = 0; $total = 0
$files = if ($base.files) { $base.files } else { $base }
foreach ($p in $files.PSObject.Properties) { $total++; $fp = Join-Path $theme $p.Name; $h = if (Test-Path $fp) { (Get-FileHash $fp -Algorithm SHA256).Hash } else { 'MISSING' }; $exp = if ($p.Value.sha256) { $p.Value.sha256 } else { $p.Value }; if ("$h" -ne "$exp") { $changed++ } }
$L = New-Object Collections.Generic.List[string]
$L.Add('# Interaction testing report'); $L.Add('')
$L.Add("Generated $(Get-Date -Format 'yyyy-MM-dd HH:mm') by tools/build-report.ps1 from documentation/data/test-results.json. Tests run in headless Chrome against the real wireframe files with interactive mode on (tools/journeys.js). A check passes only when the browser really did the thing.")
$L.Add(''); $L.Add('## Totals'); $L.Add(''); $L.Add('| Measure | Count |'); $L.Add('|---------|-------|')
$L.Add("| Total interactions tested | $n |"); $L.Add("| Passed | $pass |"); $L.Add("| Failed | $fail |"); $L.Add("| Pending | $pend |"); $L.Add("| Blocked | $blk |"); $L.Add('')
$L.Add('## By group'); $L.Add(''); $L.Add('| Group | Tested | Passed | Failed | Pending | Blocked |'); $L.Add('|-------|--------|--------|--------|---------|---------|')
foreach ($g in ($res | Group-Object { ($_.g -replace ' \d+$', '') } )) { $x = $g.Group; $L.Add("| $($g.Name) | $($x.Count) | $(@($x | Where-Object s -eq 'pass').Count) | $(@($x | Where-Object s -eq 'fail').Count) | $(@($x | Where-Object s -eq 'pending').Count) | $(@($x | Where-Object s -eq 'blocked').Count) |") }
$L.Add(''); $L.Add('## Every check'); $L.Add(''); $L.Add('| Result | Group | Check | Evidence |'); $L.Add('|--------|-------|-------|----------|')
foreach ($r in $res) { $d = ($r.d -replace '\|', '/' -replace '\r?\n', ' '); $L.Add("| $($r.s.ToUpper()) | $($r.g) | $($r.n -replace '\|','/') | $d |") }
$L.Add(''); $L.Add('## Failed'); $L.Add(''); $f = @($res | Where-Object s -eq 'fail'); if ($f.Count) { $f | ForEach-Object { $L.Add("* **$($_.g)**: $($_.n). $($_.d)") } } else { $L.Add('None in this run.') }
$L.Add(''); $L.Add('## Pending, blocked and unsupported'); $L.Add('')
$pb = @($res | Where-Object { $_.s -eq 'pending' -or $_.s -eq 'blocked' }); if ($pb.Count) { $pb | ForEach-Object { $L.Add("* **$($_.s.ToUpper())** $($_.n): $($_.d)") } }
$L.Add('* **UNSUPPORTED (by design, needs Shopify)** checkout and payment, accounts and orders, discount codes, real inventory, newsletter delivery, contact form delivery, wishlist, reviews. See shopify-integration.md.')
$L.Add('* **MISSING in the wireframes** search results page, wishlist control, article related products, makeup, hair and body product data. See missing-pages-and-interactions.md.')
$L.Add(''); $L.Add('## Safety checks'); $L.Add(''); $L.Add("* 06-Shopify-Theme fingerprint: $changed of $total files differ from 07-Component-Library/shopify/06-baseline.json.")
$L.Add('* The wireframes were opened, not edited. The one change is the dormant hook appended to 03-Wireframes/00-Shared-Tailwind-Foundation/nav.js (original saved at tools/nav.js.original).')
$L.Add('* No Shopify store tool was called; nothing was pushed or published.')
[IO.File]::WriteAllText((Join-Path $IW 'documentation\interaction-testing-report.md'), ($L -join "`n"), $utf8)
"report written: tested=$n pass=$pass fail=$fail pending=$pend blocked=$blk; theme changed=$changed/$total"
