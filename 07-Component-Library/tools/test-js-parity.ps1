# Parity test: the PowerShell engine (build.ps1) and the JavaScript engine (07-Component-Library/engine.js) must produce IDENTICAL output for every real component call.
# Calls are collected from the page sources and shared partials, plus EVERY component rendered with its manifest defaults and the shared header, footer and announcement bar as pages call them; both engines render each unique call and the outputs are compared exactly.
# Usage: .\tools\test-js-parity.ps1
$L = Split-Path -Parent $PSScriptRoot; $P = Split-Path -Parent $L; $utf8 = New-Object Text.UTF8Encoding($false)
$F = Join-Path $P '03-Wireframes\00-Shared-Tailwind-Foundation'
& "$L\build-library.ps1" | Out-Null
Add-Type -AssemblyName System.Web.Extensions
# --- PowerShell side: reuse the real engine functions from build.ps1 ---
$root = $F; $foundation = 'x'; $wf = Split-Path -Parent $F
$ast = [System.Management.Automation.Language.Parser]::ParseFile("$F\build.ps1", [ref]$null, [ref]$null)
$want = 'P', 'Slug', 'Unesc', 'Args2', 'Component', 'Expand', 'Links', 'CompRel', 'ManifestFor', 'Truthy', 'PathGet', 'TplTokens', 'TplRender'
$ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $want -contains $n.Name }, $true) | ForEach-Object { . ([scriptblock]::Create($_.Extent.Text)) }
$script:manCache = @{}
$pages = [ordered]@{}; $bpText = [IO.File]::ReadAllText("$F\build.ps1", $utf8); $pm = [regex]::Match($bpText, '\$pages = \[ordered\]@\{([\s\S]*?)\n\}').Groups[1].Value
foreach ($m in [regex]::Matches($pm, "'([a-z-]+)'\s*=\s*'([^']+)'")) { $pages[$m.Groups[1].Value] = $m.Groups[2].Value }
# --- collect unique calls ---
$sources = @(Get-ChildItem "$F\src" -File) + @(Get-ChildItem "$F\partials" -File -Filter *.html)
$calls = @{}
foreach ($s in $sources) {
  $t = [IO.File]::ReadAllText($s.FullName, $utf8); if ($s.Name -eq 'footer.html') { $t = Links $t }
  foreach ($m in [regex]::Matches($t, '@@PARTIAL (components/[a-z0-9/-]+)([^@]*)@@')) { $c = $m.Value; if ($c -notmatch '\{\{|@@NAV|@@HDR|@@CART') { $calls[$c] = 1 } }
}
# every component rendered with its manifest defaults (a call with no arguments), and the shared parts as the pages call them (annbar, header, footer)
$compRoot = Join-Path $F 'partials\components'
foreach ($cf in (Get-ChildItem $compRoot -Recurse -File -Filter *.html)) { $rel = $cf.FullName.Substring($compRoot.Length + 1) -replace '\\', '/' -replace '\.html$', ''; $pp = $rel -split '/'; $nm = if ($pp.Count -ge 2 -and $pp[-1] -eq $pp[-2]) { $pp[0..($pp.Count - 2)] -join '/' } else { $rel }; $calls["@@PARTIAL components/$nm@@"] = 1 }
foreach ($s in (Get-ChildItem "$F\src" -File)) { $t3 = [IO.File]::ReadAllText($s.FullName, $utf8); foreach ($m in [regex]::Matches($t3, '@@PARTIAL (annbar|header|footer)\b[^@]*@@')) { $calls[$m.Value] = 1 } }
$list = [string[]]@($calls.Keys | Sort-Object)
$psOut = @{}; $psFail = @()
foreach ($c in $list) { try { $psOut[$c] = Expand $c } catch { $psFail += "$c => $($_.Exception.Message)" } }
# --- JavaScript side ---
$page = "<!doctype html><html><head><meta charset=`"utf-8`"></head><body><pre id=`"o`">pending</pre><script src=`"file:///$((($L -replace '\\','/') -replace ' ','%20'))/library.data.js`"></script><script src=`"file:///$((($L -replace '\\','/') -replace ' ','%20'))/engine.js`"></script><script>var CALLS=$((New-Object System.Web.Script.Serialization.JavaScriptSerializer).Serialize([string[]]$list).Replace('</','<\/'));var e=new NudgeEngine(window.NUDGE_LIB.components,window.NUDGE_LIB),r={},f=[];CALLS.forEach(function(c){try{r[c]=e.expand(c)}catch(x){f.push(c+' => '+x.message)}});document.getElementById('o').textContent=JSON.stringify({r:r,f:f});</script></body></html>"
Add-Type -AssemblyName System.Web.Extensions
$tmp = Join-Path ([IO.Path]::GetTempPath()) 'nudge-parity'; New-Item -ItemType Directory -Force $tmp | Out-Null
$pg = Join-Path $tmp 'parity.html'; [IO.File]::WriteAllText($pg, $page, $utf8); $dump = Join-Path $tmp 'parity-dump.html'
Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', '--virtual-time-budget=20000', '--dump-dom', "`"file:///$(($pg -replace '\\','/') -replace ' ','%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
$raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump, $utf8), '<pre id="o">([\s\S]*?)</pre>').Groups[1].Value)
if ($raw -eq 'pending' -or -not $raw) { throw 'the JavaScript engine produced no result' }
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer; $ser.MaxJsonLength = [int]::MaxValue; $js = $ser.DeserializeObject($raw)
$same = 0; $diff = @()
foreach ($c in $list) { if ($psOut.ContainsKey($c) -and $js['r'].ContainsKey($c)) { if ($psOut[$c] -ceq [string]$js['r'][$c]) { $same++ } else { $diff += $c } } }
"unique component calls: $($list.Count); identical output in both engines: $same"
if ($psFail.Count) { "PowerShell failures: " + ($psFail -join '; ') }
if ($js['f'].Count) { "JavaScript failures: " + ($js['f'] -join '; ') }
foreach ($d in ($diff | Select-Object -First 5)) { $a = $psOut[$d]; $b = [string]$js['r'][$d]; $n = 0; while ($n -lt $a.Length -and $n -lt $b.Length -and $a[$n] -eq $b[$n]) { $n++ }; "DIFF $d at $n`n  ps: $($a.Substring([Math]::Max(0,$n-30),[Math]::Min(80,$a.Length-[Math]::Max(0,$n-30))))`n  js: $($b.Substring([Math]::Max(0,$n-30),[Math]::Min(80,$b.Length-[Math]::Max(0,$n-30))))" }
if ($same -eq $list.Count -and -not $psFail.Count -and -not $js['f'].Count) { 'parity: PASS' } else { 'parity: FAIL' }