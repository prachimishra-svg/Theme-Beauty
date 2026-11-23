# Runs one QA suite (tools/suite-<name>.js, with tools/qa-lib.js prepended) in headless Chrome and writes documentation/data/<name>.json plus <name>.console.txt (every console message Chrome printed).
# A run that returns nothing is a FAILURE. Usage: .\tools\run-suite.ps1 -Suite compare [-Only a,b] [-Budget 900000]
param([Parameter(Mandatory)][string]$Suite, [string[]]$Only = @(), [int]$Budget = 900000, [string]$Tag = '', [string]$Wireframes = '', [string]$SingleRoot = '')
$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'build-bundle.ps1') | Out-Null  # always test the current bundle
$IW = Split-Path -Parent $PSScriptRoot; $PRJ = Split-Path -Parent $IW; $WF = if ($Wireframes) { $Wireframes } else { Join-Path $PRJ '03-Wireframes' }; $utf8 = New-Object Text.UTF8Encoding($false)
$lib = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'qa-lib.js'), $utf8); $js = [IO.File]::ReadAllText((Join-Path $PSScriptRoot "suite-$Suite.js"), $utf8)
if (($lib + $js) -match '</script') { throw 'suite must not contain a closing script tag' }
$pg = [ordered]@{ home = '01-NUDGE-Beauty-Homepage-Wireframe/Homepage.html'; collection = '02-NUDGE-Beauty-PLP-Wireframe/PLP.html'; product = '03-NUDGE-Beauty-PDP-Wireframe/PDP.html'; cart = '04-NUDGE-Beauty-Cart-Wireframe/Cart_Page.html'
  drawer = '05-NUDGE-Beauty-Cart-Drawer-Wireframe/Cart_Drawer_Wireframe_v1.html'; contact = '06-NUDGE-Beauty-Contact-Wireframe/Contact_Page_Wireframe_v1.html'; faq = '07-NUDGE-Beauty-FAQ-Wireframe/FAQ_Page_Wireframe_v1.html'
  about = '08-NUDGE-Beauty-About-Wireframe/About_Page_Wireframe_v1.html'; story = '09-NUDGE-Beauty-Story-Wireframe/Story_Page_Wireframe_v1.html'; shipping = '10-NUDGE-Beauty-Shipping-Policy-Wireframe/Shipping_Policy_Wireframe_v1.html'
  returns = '11-NUDGE-Beauty-Returns-Policy-Wireframe/Returns_Policy_Wireframe_v1.html'; privacy = '12-NUDGE-Beauty-Privacy-Policy-Wireframe/Privacy_Policy_Wireframe_v1.html'; terms = '13-NUDGE-Beauty-Terms-Wireframe/Terms_Conditions_Wireframe_v1.html'
  blog = '14-NUDGE-Beauty-Blog-Listing-Wireframe/Blog_Listing_Wireframe_v1.html'; article = '15-NUDGE-Beauty-Blog-Article-Wireframe/Blog_Article_Wireframe_v1.html'; notfound = '16-NUDGE-Beauty-404-Wireframe/404_Page_Wireframe_v1.html' }
$pgjs = '{' + (($pg.Keys | ForEach-Object { $p = $pg[$_].Split('/'); '"' + $_ + '":["' + $p[0] + '","' + $p[1] + '"]' }) -join ',') + '}'
if ($SingleRoot) { $WF = $SingleRoot; $single = @{ home = 'home'; collection = 'collection'; product = 'product'; cart = 'cart'; drawer = 'cart-drawer'; contact = 'contact'; faq = 'faq'; about = 'about'; story = 'our-story'; shipping = 'shipping-policy'; returns = 'returns-policy'; privacy = 'privacy-policy'; terms = 'terms'; blog = 'blog'; article = 'article'; notfound = '404' }; $pgjs = '{' + (($pg.Keys | ForEach-Object { '"' + $_ + '":["pages","' + $single[$_] + '.html"]' }) -join ',') + '}' }
$base = 'file:///' + (($WF -replace '\\', '/') -replace ' ', '%20') + '/'
$wrap = "<!doctype html><meta charset=`"utf-8`"><iframe id=`"f`" style=`"width:1440px;height:900px;border:0`"></iframe><textarea id=`"o`">pending</textarea>`n<script>var BASE='$base',PG=$pgjs,ONLY=$(ConvertTo-Json -Compress @($Only));</script>`n<script>`n$lib`n$js`n</script>"
$tmp = Join-Path ([IO.Path]::GetTempPath()) "nudge-iw-$Suite"; New-Item -ItemType Directory -Force $tmp | Out-Null
$page = Join-Path $tmp 'wrap.html'; [IO.File]::WriteAllText($page, $wrap, $utf8); $dump = Join-Path $tmp 'dump.html'
Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', '--window-size=2000,1180', '--enable-logging=stderr', '--v=0', "--virtual-time-budget=$Budget", '--dump-dom', "`"file:///$(($page -replace '\\','/') -replace ' ','%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
$raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump, $utf8), '<textarea id="o">([\s\S]*?)</textarea>').Groups[1].Value)
if ($raw -eq 'pending' -or -not $raw) { throw 'BROWSER PRODUCED NO RESULT (still pending): this is a failure, not a pass' }
$name = if ($Tag) { "$Suite-$Tag" } else { $Suite }
$out = Join-Path $IW 'documentation\data'; New-Item -ItemType Directory -Force $out | Out-Null
[IO.File]::WriteAllText((Join-Path $out "$name.json"), $raw, $utf8)
$con = @(Get-Content "$dump.err" -ErrorAction SilentlyContinue | Where-Object { $_ -match 'CONSOLE' }); [IO.File]::WriteAllLines((Join-Path $out "$name.console.txt"), [string[]]$con, $utf8)
$res = $raw | ConvertFrom-Json; $by = $res | Group-Object s | ForEach-Object { "$($_.Name)=$($_.Count)" }
"suite $Suite : $($res.Count) records ($($by -join ', ')); console lines: $($con.Count)"
$res | Where-Object { $_.s -eq 'fail' } | Select-Object -First 25 | ForEach-Object { "FAIL [$($_.g)] $($_.n) :: $($_.d)" }
