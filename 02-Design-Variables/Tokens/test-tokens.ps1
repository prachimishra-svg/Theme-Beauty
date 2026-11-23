<#
  NUDGE Design Variables: browser test (headless Chrome or Edge)

  Run after build-tokens.ps1:
    powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Tokens/test-tokens.ps1

  1. TOKENS x TIERS: loads Styles/variables.css at 320, 599, 600, 1023, 1024 and 1440px and checks that EVERY
     token's computed value equals the value defined in the JSON for that tier (so the 600px and 1024px
     boundaries are tested on both sides). Fluid tokens compare their clamp() expression.
  1b. DARK-SURFACE SCOPE: .surface-inverse re-maps the focus ring, link, secondary button, control border, text.
  2. DASHBOARD: loads Preview/index.html at 390, 768 and 1440px: its own validation reports 0 failures and 0
     mismatches; no overflow; one h1; no duplicate ids; keyboard-focusable scroll regions; the tier simulator works.
  3. CONSOLE output of the dashboard.
  3b. TOUCH TARGETS: every interactive element of the Design System showcase measures 44 x 44px (its box, or an
     invisible ::after hit area), apart from a recorded list of exceptions.
  4. DESIGN SYSTEM showcase opened directly from disk: no console output.
  6. STATIC: no double-encoded characters in any text file, balanced CSS braces, valid JSON.
  5. PROPAGATION: in a temporary copy of the project, one primitive is changed in the JSON, the builder is re-run,
     and the Design System must change with NO second edit (its files stay byte-identical) while the original
     project is untouched. Skip with -SkipPropagation.

  7. STRUCTURAL SCAN (deterministic; each failure names the file and what to do). Checks exactly:
     7a  a fixed list of required project files exists (token JSON, builder and tests, generated files, both pages,
         their CSS and JS, the docs). Files not on the list are optional and never required.
     7b  every local file linked from the two HTML pages (link, script, img) and every url() in any stylesheet exists.
     7c  every relative link in the Markdown files resolves to a file.
     7d  generated output is complete: variables.css, the matrix and the token reference carry the GENERATED marker;
         the dashboard's token list and the custom properties in variables.css are the same set; every var(--x) in
         variables.css is declared; every declared token appears in token-reference.md.
     7e  generated files equal a fresh build: build-tokens.ps1 runs on a temporary copy and its four generated files
         must be byte-identical to the committed ones (a stale file means the generator was not re-run).
     7f  page structure in a browser at 320, 390 and 1280px on both pages: unique ids; aria-labelledby, -describedby
         and -controls targets exist; #anchors and sprite icons resolve; buttons and links have names; form controls
         have labels; no skipped heading levels; one h1; lang and title; every dialog has a name; every
         data-drawer-open points at a dialog; Load more has a real link and a target list; no horizontal overflow.
     It does not modify anything, does not check optional files, and does not judge visual design.
  8. TYPOGRAPHY UNITS (convention: static font sizes are px; fluid sizes are clamp() of rem and vw, the documented rem
     exception; points are never allowed). 8a no `pt` unit in any token file (reported per file and token name), stylesheet,
     script, page or SVG; 8b every static font-size token is Npx and every fluid one is a valid rem clamp() with min <= max
     and max/min <= 2.5; 8c the theme stylesheets (foundation, base, components) take every font-size from a token; 8d the
     generated font-size properties are px (static) or rem and vw only (fluid). build-tokens.ps1 enforces the same rule at the source.
  Exit code 0 = all passed, 1 = a check failed, 2 = no browser found / test could not run.
  Nothing in the project is modified; temporary files go to a temp folder.#>
param([switch]$SkipPropagation, [string]$BrowserPath = '')   # -BrowserPath: use a specific Chrome/Edge
$ErrorActionPreference = 'Stop'
$dv = Split-Path -Parent $PSScriptRoot
$inv = [Globalization.CultureInfo]::InvariantCulture
$browser = @(
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe", "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe", "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
if ($BrowserPath) { $browser = $BrowserPath }
if (-not $browser) { Write-Host 'No Chrome or Edge found; cannot run the browser test.'; exit 2 }

$html = [IO.File]::ReadAllText((Join-Path $dv 'Preview\index.html'))
$mm = [regex]::Match($html, '(?s)<script id="token-data" type="application/json">(.*?)</script>')
if (-not $mm.Success) { Write-Host 'Token data block missing from Preview/index.html. Run build-tokens.ps1 first.'; exit 2 }
$data = $mm.Groups[1].Value | ConvertFrom-Json
$expected = @($data.tokens | ForEach-Object { [ordered]@{ n = $_.n; v = @($_.v) } }) | ConvertTo-Json -Depth 4 -Compress

$tmp = Join-Path ([IO.Path]::GetTempPath()) ("nudge-test-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force $tmp | Out-Null
function FileUrl([string]$p) { 'file:///' + ($p -replace '\\', '/').Replace(' ', '%20') }
$cssUrl = FileUrl (Join-Path $dv 'Styles\variables.css')
$dashUrl = FileUrl (Join-Path $dv 'Preview\index.html')
$proj = Split-Path -Parent $dv
$dsIndex = Join-Path $proj '01-Design-System\index.html'
if (-not (Test-Path $dsIndex)) { Write-Host '01-Design-System/index.html not found; cannot run the Design System tests.'; exit 2 }
$dsUrl = FileUrl $dsIndex
[IO.File]::WriteAllText("$tmp\vp.html", "<!doctype html><meta charset=utf-8><link rel=stylesheet href=`"$cssUrl`"><body><div class=surface-inverse id=scope><span id=scopeinner>x</span></div></body>")

$harness = @"
<!doctype html><meta charset=utf-8><pre id=out>running</pre><div id=f></div><script>
const T = $expected;
const tokenWidths = [[320,0],[599,0],[600,1],[1023,1],[1024,2],[1440,2]];
const dashWidths = [390,768,1440];
const res = { tokens: [], dash: [], scope: null, touch: [] };
const wait = ms => new Promise(r => setTimeout(r, ms));
(async () => {
  for (const [w, ti] of tokenWidths) {
    const fr = document.createElement('iframe'); fr.style.cssText = 'width:'+w+'px;height:200px;border:0'; fr.src = 'vp.html';
    document.getElementById('f').appendChild(fr); await new Promise(r => fr.onload = r); await wait(200);
    const d = fr.contentDocument, cs = fr.contentWindow.getComputedStyle(d.documentElement);
    const probe = d.createElement('div'); d.body.appendChild(probe); const bad = [];
    for (const t of T) {
      probe.style.setProperty('--probe', t.v[ti]);
      const want = getComputedStyle(probe).getPropertyValue('--probe').trim();
      const got = cs.getPropertyValue('--' + t.n).trim();
      if (got === '' || got !== want) bad.push('--' + t.n + ' got "' + got + '" want "' + want + '"');
    }
    res.tokens.push({ w, tier: ['mobile','tablet','desktop'][ti], inner: fr.contentWindow.innerWidth, checked: T.length, bad: bad.length, first: bad.slice(0, 3) });
    fr.remove();
  }
  { // dark-surface scope: every re-mapped token AND everything aliasing it must change inside .surface-inverse
    const fr = document.createElement('iframe'); fr.style.cssText = 'width:1440px;height:200px;border:0'; fr.src = 'vp.html';
    document.getElementById('f').appendChild(fr); await new Promise(r => fr.onload = r); await wait(200);
    const d = fr.contentDocument, W = fr.contentWindow, inner = d.getElementById('scopeinner'), outer = d.body;
    const probeIn = d.createElement('div'); inner.appendChild(probeIn);
    const probeOut = d.createElement('div'); outer.appendChild(probeOut);
    const val = (el, prop) => W.getComputedStyle(el).getPropertyValue(prop).trim();
    const eq = (prop, expr) => { probeIn.style.setProperty('--p', expr); probeOut.style.setProperty('--p', expr); return val(inner, prop) === val(probeIn, '--p'); };
    const checks = {
      'focus ring (composite) uses the inverse ring': eq('--focus-ring', 'var(--focus-ring-width) solid var(--color-focus-ring-inverse)'),
      'link uses the inverse link': eq('--color-link', 'var(--color-link-inverse)'),
      'secondary button border follows inverse text': eq('--color-button-secondary-border', 'var(--color-text-inverse)'),
      'control border follows inverse border': eq('--color-control-border', 'var(--color-border-inverse)'),
      'text-primary is inverse': eq('--color-text-primary', 'var(--color-text-inverse)'),
      'light surface is unaffected': val(outer, '--focus-ring') !== val(inner, '--focus-ring') && val(outer, '--color-link') === val(outer, '--color-brand-primary')
    };
    res.scope = checks; fr.remove();
  }
  for (const w of [390, 1280]) {   // touch-target audit of the Design System showcase
    const fr = document.createElement('iframe'); fr.style.cssText = 'width:'+w+'px;height:900px;border:0'; fr.src = '$dsUrl';
    document.getElementById('f').appendChild(fr); await new Promise(r => fr.onload = r); await wait(1200);
    const W = fr.contentWindow, d = fr.contentDocument; const off = [], exc = {}; let measured = 0;
    const add = k => { exc[k] = (exc[k] || 0) + 1; };
    const hit = el => { const r = el.getBoundingClientRect(); let wd = r.width, ht = r.height; for (const ps of ['::after', '::before']) { const s = W.getComputedStyle(el, ps); if (s.position === 'absolute' && s.content !== 'none') { wd = Math.max(wd, parseFloat(s.width) || 0); ht = Math.max(ht, parseFloat(s.height) || 0); } } return [wd, ht]; };
    d.querySelectorAll('a[href], button, input:not([type=hidden]), select, textarea, summary, [role=button]').forEach(el => {
      const cs = W.getComputedStyle(el);
      if (el.disabled || el.getAttribute('aria-disabled') === 'true') { add('disabled control'); return; }
      if (el.classList.contains('skip-link')) { add('skip link (off-screen until focused)'); return; }
      if (el.closest('.visually-hidden')) return;
      let t = el; if ((el.type === 'checkbox' || el.type === 'radio') && el.closest('label')) t = el.closest('label');
      const r = t.getBoundingClientRect(); if (!r.width && !r.height) return;
      if (el.tagName === 'A' && cs.display === 'inline' && /\S/.test((el.parentElement.textContent || '').replace(el.textContent, ''))) { add('inline link inside a sentence (WCAG 2.5.8 exception)'); return; }
      measured++; const h = hit(t); if (h[0] < 43.5 || h[1] < 43.5) off.push(el.tagName + '.' + (el.className || '') + ' ' + Math.round(h[0]) + 'x' + Math.round(h[1]));
    });
    res.touch.push({ w, measured, exceptions: exc, offenders: [...new Set(off)].slice(0, 12), offenderCount: off.length });
    fr.remove();
  }
  for (const w of dashWidths) {
    const fr = document.createElement('iframe'); fr.style.cssText = 'width:'+w+'px;height:900px;border:0'; fr.src = '$dashUrl';
    document.getElementById('f').appendChild(fr); await new Promise(r => fr.onload = r); await wait(1500);
    const W = fr.contentWindow, d = fr.contentDocument, de = d.documentElement, v = W.__nudgeValidation || {};
    const ids = {}; d.querySelectorAll('[id]').forEach(e => ids[e.id] = (ids[e.id] || 0) + 1);
    const noFocus = []; d.querySelectorAll('*').forEach(e => { const s = W.getComputedStyle(e); if ((s.overflowX==='auto'||s.overflowX==='scroll') && e.scrollWidth > e.clientWidth + 1 && !e.hasAttribute('tabindex') && !e.querySelector('a,button,input,select,textarea')) noFocus.push(e.className); });
    const sim = d.getElementById('sim'); const col = () => W.getComputedStyle(sim).getPropertyValue('--grid-columns-products').trim();
    const sims = [];
    for (const i of [0,1,2]) { d.querySelector('[data-tier="'+i+'"]').click(); sims.push(col()); }
    d.querySelector('[data-tier="live"]').click();
    res.dash.push({ w, checks: v.total, fails: v.fails, mismatches: v.mismatches, overflow: de.scrollWidth > de.clientWidth + 1, h1: d.querySelectorAll('h1').length, dupIds: Object.keys(ids).filter(k => ids[k] > 1).length, scrollNoFocus: noFocus.length, sim: sims.join('/'), renderedTokens: d.querySelectorAll('#render-tokens tr').length });
    fr.remove();
  }
  document.getElementById('out').textContent = JSON.stringify(res);
})();
</script>
"@
[IO.File]::WriteAllText("$tmp\harness.html", $harness)
$out = "$tmp\out.html"; $err = "$tmp\err.txt"
Start-Process -FilePath $browser -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', '--enable-logging=stderr', '--v=0', '--virtual-time-budget=60000', '--dump-dom', (FileUrl "$tmp\harness.html")) -RedirectStandardOutput $out -RedirectStandardError $err -Wait -NoNewWindow
$m2 = [regex]::Match([IO.File]::ReadAllText($out), '(?s)<pre id="out">(.*?)</pre>')
if (-not $m2.Success -or $m2.Groups[1].Value -eq 'running') { Write-Host 'The browser did not produce a result (test could not run).'; exit 2 }
$r = [Net.WebUtility]::HtmlDecode($m2.Groups[1].Value) | ConvertFrom-Json
$console = @(Select-String -Path $err -Pattern ':CONSOLE' -ErrorAction SilentlyContinue | Where-Object { $_.Line -notmatch 'source: chrome-extension://' })   # ignore the browser's own extensions

$fail = 0
Write-Host "Browser: $(Split-Path $browser -Leaf)"
Write-Host "`n1. Tokens x tiers (computed CSS vs JSON)"
foreach ($t in $r.tokens) {
  $ok = ($t.bad -eq 0)
  Write-Host ("   {0,5}px  {1,-8} {2} tokens, {3} mismatches  {4}" -f $t.w, $t.tier, $t.checked, $t.bad, $(if ($ok) { 'PASS' } else { 'FAIL ' + ($t.first -join ' | ') }))
  if (-not $ok) { $fail++ }
}
Write-Host "`n1b. Dark-surface scope (.surface-inverse)"
foreach ($k in $r.scope.PSObject.Properties) {
  Write-Host ("   {0,-52} {1}" -f $k.Name, $(if ($k.Value) { 'PASS' } else { 'FAIL' }))
  if (-not $k.Value) { $fail++ }
}
Write-Host "`n2. Dashboard"
foreach ($d in $r.dash) {
  $probs = @()
  if ($d.fails -ne 0) { $probs += "$($d.fails) validation failures" }
  if ($d.mismatches -ne 0) { $probs += "$($d.mismatches) JSON/CSS mismatches" }
  if ($d.overflow) { $probs += 'horizontal overflow' }
  if ($d.h1 -ne 1) { $probs += "h1 count $($d.h1)" }
  if ($d.dupIds -ne 0) { $probs += "$($d.dupIds) duplicate ids" }
  if ($d.scrollNoFocus -ne 0) { $probs += "$($d.scrollNoFocus) scroll regions not keyboard focusable" }
  if ($d.sim -ne '2/3/4') { $probs += "simulator gave $($d.sim) product columns, expected 2/3/4" }
  Write-Host ("   {0,5}px  {1} checks, {2} tokens listed, simulator cols {3}  {4}" -f $d.w, $d.checks, $d.renderedTokens, $d.sim, $(if ($probs.Count) { 'FAIL: ' + ($probs -join '; ') } else { 'PASS' }))
  if ($probs.Count) { $fail++ }
}
Write-Host ("`n3. Browser console output: {0} line(s) {1}" -f $console.Count, $(if ($console.Count) { 'FAIL' } else { 'PASS' }))
if ($console.Count) { $fail++; $console | Select-Object -First 5 | ForEach-Object { Write-Host "   $($_.Line)" } }
# 3b. touch targets
Write-Host "`n3b. Touch targets, Design System showcase (44 x 44px: box or hit area)"
foreach ($t in $r.touch) {
  $ok = ($t.offenderCount -eq 0)
  $ex = (($t.exceptions.PSObject.Properties | ForEach-Object { "$($_.Value) x $($_.Name)" }) -join '; ')
  Write-Host ("   {0,5}px  {1} measured, {2} below 44px  {3}" -f $t.w, $t.measured, $t.offenderCount, $(if ($ok) { 'PASS' } else { 'FAIL: ' + ($t.offenders -join ' | ') }))
  if ($ok -and $t.w -eq 390) { Write-Host "          exceptions (documented): $ex" }
  if (-not $ok) { $fail++ }
}
# 4. The Design System showcase opened directly from disk (read-only): must not log console errors/warnings
if ($dsIndex) {
  $dsErr = "$tmp\ds-err.txt"
  Start-Process -FilePath $browser -ArgumentList @('--headless=new', '--disable-gpu', '--enable-logging=stderr', '--v=0', '--virtual-time-budget=10000', '--dump-dom', (FileUrl $dsIndex)) -RedirectStandardOutput "$tmp\ds-out.html" -RedirectStandardError $dsErr -Wait -NoNewWindow
  $dsConsole = @(Select-String -Path $dsErr -Pattern ':CONSOLE' -ErrorAction SilentlyContinue | Where-Object { $_.Line -notmatch 'source: chrome-extension://' })
  Write-Host ("`n4. Design System showcase opened directly (plain file://): {0} console line(s) {1}" -f $dsConsole.Count, $(if ($dsConsole.Count) { 'FAIL' } else { 'PASS' }))
  if ($dsConsole.Count) { $fail++; $dsConsole | Select-Object -First 3 | ForEach-Object { Write-Host "   $($_.Line)" } }
} else { Write-Host "`n4. Design System showcase not found; skipped." }
# 5. Propagation: a JSON edit reaches the Design System with no second edit
if (-not $SkipPropagation) {
  Write-Host "`n5. Propagation: one edit in Design Variables must reach the Design System with no second edit"
  $pp = Join-Path $tmp 'proj'; New-Item -ItemType Directory -Force $pp | Out-Null
  Copy-Item (Join-Path $proj '01-Design-System') (Join-Path $pp '01-Design-System') -Recurse
  Copy-Item $dv (Join-Path $pp '02-Design-Variables') -Recurse
  Copy-Item (Join-Path $proj '05-Assets') (Join-Path $pp '05-Assets') -Recurse
  $hashDs = { param($root) Get-ChildItem (Join-Path $root '01-Design-System') -Recurse -File | ForEach-Object { (Get-FileHash $_.FullName).Hash + ' ' + $_.FullName.Substring($root.Length) } | Sort-Object }
  $before = & $hashDs $pp
  $pj = Join-Path $pp '02-Design-Variables\Tokens\primitives.json'
  $txt = [IO.File]::ReadAllText($pj)
  # The brand value is read from the JSON, so a palette change does not break this test
  $brand = ([IO.File]::ReadAllText($pj) | ConvertFrom-Json).palette.rose.'700'.'$value'
  if ($brand -notmatch '^#[0-9A-Fa-f]{6}$' -or $txt -notmatch [regex]::Escape($brand)) { Write-Host '   FAIL: expected a brand colour (palette.rose.700) in primitives.json'; $fail++ }
  else {
    [IO.File]::WriteAllText($pj, $txt.Replace($brand, '#123456'), (New-Object Text.UTF8Encoding($false)))
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $pp '02-Design-Variables\Tokens\build-tokens.ps1') | Out-Null; $bx = $LASTEXITCODE
    $after = & $hashDs $pp
    $dsSame = (-not (Compare-Object $before $after))
    $copyUrl = FileUrl (Join-Path $pp '01-Design-System\index.html')
    $h2 = "<!doctype html><meta charset=utf-8><pre id=out>run</pre><div id=f></div><script>(async()=>{const o={};for(const [k,u] of [['copy','$copyUrl'],['orig','$dsUrl']]){const fr=document.createElement('iframe');fr.style.cssText='width:1280px;height:900px;border:0';fr.src=u;document.getElementById('f').appendChild(fr);await new Promise(r=>fr.onload=r);await new Promise(r=>setTimeout(r,800));const d=fr.contentDocument,W=fr.contentWindow;o[k]={btn:W.getComputedStyle(d.querySelector('.btn--primary')).backgroundColor,rose:W.getComputedStyle(d.documentElement).getPropertyValue('--palette-rose-700').trim()};fr.remove();}document.getElementById('out').textContent=JSON.stringify(o);})();</script>"
    [IO.File]::WriteAllText("$tmp\prop.html", $h2)
    Start-Process -FilePath $browser -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', '--virtual-time-budget=30000', '--dump-dom', (FileUrl "$tmp\prop.html")) -RedirectStandardOutput "$tmp\prop-out.html" -RedirectStandardError "$tmp\prop-err.txt" -Wait -NoNewWindow
    $pm = [regex]::Match([IO.File]::ReadAllText("$tmp\prop-out.html"), '(?s)<pre id="out">(.*?)</pre>')
    if (-not $pm.Success -or $pm.Groups[1].Value -eq 'run') { Write-Host '   FAIL: the browser did not produce a result'; $fail++ }
    else {
      $pr = [Net.WebUtility]::HtmlDecode($pm.Groups[1].Value) | ConvertFrom-Json
      $checks = [ordered]@{
        'builder re-ran cleanly on the edited copy'                       = ($bx -eq 0)
        'Design System files byte-identical after the edit (no 2nd edit)' = $dsSame
        'Design System primary button changed to the new colour'          = ($pr.copy.btn -eq 'rgb(18, 52, 86)')
        'token value reached the Design System'                           = ($pr.copy.rose -eq '#123456')
        "original project untouched (still $brand)"                      = ($pr.orig.rose -eq $brand)
      }
      foreach ($k in $checks.Keys) { Write-Host ("   {0,-62} {1}" -f $k, $(if ($checks[$k]) { 'PASS' } else { 'FAIL' })); if (-not $checks[$k]) { $fail++ } }
    }
  }
}
# 6. Static integrity of every project text file (no browser needed)
Write-Host "`n6. Static checks (encoding, CSS syntax, JSON)"
$textFiles = Get-ChildItem $proj -Recurse -File -Include *.css, *.js, *.html, *.md, *.json, *.ps1, *.svg | Where-Object { $_.FullName -notmatch '\\(node_modules|\.git)\\' }
$mojibake = @(); $braces = @(); $badJson = @()
foreach ($tf in $textFiles) {
  $tx = [IO.File]::ReadAllText($tf.FullName, [Text.Encoding]::UTF8)
  if ([regex]::IsMatch($tx, '\u00E2\u20AC|\u00C3[\u0080-\u00BF]|\u00C2[\u00A0-\u00BF]|\uFFFD')) { $mojibake += $tf.FullName.Substring($proj.Length + 1) }
  if ($tf.Extension -eq '.css') { $o = ([regex]::Matches($tx, '\{')).Count; $c = ([regex]::Matches($tx, '\}')).Count; if ($o -ne $c) { $braces += "$($tf.Name) ($o open, $c close)" } }
  if ($tf.Extension -eq '.json') { try { $null = $tx | ConvertFrom-Json } catch { $badJson += $tf.Name } }
}
$staticRows = [ordered]@{
  "Encoding: no double-encoded or replacement characters in $($textFiles.Count) files" = $(if ($mojibake.Count) { "FAIL: $($mojibake -join ', ')" } else { 'PASS' })
  'CSS: braces balanced in every stylesheet'                                           = $(if ($braces.Count) { "FAIL: $($braces -join ', ')" } else { 'PASS' })
  'JSON: every .json file parses'                                                      = $(if ($badJson.Count) { "FAIL: $($badJson -join ', ')" } else { 'PASS' })
}
foreach ($k in $staticRows.Keys) { Write-Host ("   {0,-72} {1}" -f $k, $staticRows[$k]); if ($staticRows[$k] -ne 'PASS') { $fail++ } }
# 7. Structural scan (deterministic; every failure names the file and says what to do). See the header of this file for the exact list.
Write-Host "`n7. Structural scan (project files, references, generated output, page structure)"
$scanRows = @()
function ScanRow([string]$name, [string[]]$problems) { $script:scanRows += [pscustomobject]@{ name = $name; problems = @($problems) } }
function Rel([string]$p) { $p.Substring($proj.Length + 1).Replace('\', '/') }

# 7a. Required files: a fixed list. Anything not on the list is optional and is never required here.
$required = @(
  'README.md', '01-Design-System/Documentation/AUDIT-REPORT.md',
  '02-Design-Variables/README.md', '02-Design-Variables/responsive-token-matrix.md', '02-Design-Variables/Styles/variables.css',
  '02-Design-Variables/Documentation/usage-guide.md', '02-Design-Variables/Documentation/token-reference.md',
  '02-Design-Variables/Preview/index.html', '02-Design-Variables/Preview/preview.css', '02-Design-Variables/Preview/preview.js',
  '02-Design-Variables/Tokens/primitives.json', '02-Design-Variables/Tokens/semantic.json', '02-Design-Variables/Tokens/typography.json', '02-Design-Variables/Tokens/spacing.json',
  '02-Design-Variables/Tokens/layout.json', '02-Design-Variables/Tokens/breakpoints.json', '02-Design-Variables/Tokens/components.json', '02-Design-Variables/Tokens/effects.json',
  '02-Design-Variables/Tokens/build-tokens.ps1', '02-Design-Variables/Tokens/test-tokens.ps1', '02-Design-Variables/Tokens/test-emulation.ps1',
  '01-Design-System/index.html', '05-Assets/Icons/sprite.svg',
  '01-Design-System/Styles/foundation.css', '01-Design-System/Styles/base.css', '01-Design-System/Styles/components.css', '01-Design-System/Styles/preview.css',
  '01-Design-System/Scripts/preview.js', '01-Design-System/Scripts/drawer.js', '01-Design-System/Scripts/load-more.js', '01-Design-System/Scripts/chip-row.js',
  '01-Design-System/Documentation/README.md', '01-Design-System/Documentation/tokens.md', '01-Design-System/Documentation/typography.md', '01-Design-System/Documentation/foundations.md',
  '01-Design-System/Documentation/components.md', '01-Design-System/Documentation/accessibility.md', '01-Design-System/Documentation/manual-testing.md'
)
ScanRow "7a. All $($required.Count) required project files exist" @($required | Where-Object { -not (Test-Path (Join-Path $proj $_)) } | ForEach-Object { "MISSING $_ : restore it, or if it was removed on purpose, remove it from the required list in test-tokens.ps1 (section 7a)" })

# 7b. Every local file an HTML page links (link href, script src, img src) and every url() in a stylesheet resolves to a file.
$refProblems = @()
$pages = @((Join-Path $proj '01-Design-System\index.html'), (Join-Path $dv 'Preview\index.html'))
foreach ($pg in $pages) {
  $tx = [IO.File]::ReadAllText($pg, [Text.Encoding]::UTF8)
  foreach ($m in [regex]::Matches($tx, '(?is)<(?:link|script|img|source)\b[^>]*?\b(?:href|src)\s*=\s*"([^"]+)"')) {
    $u = $m.Groups[1].Value
    if ($u -match '^(#|https?:|//|data:|mailto:|tel:|javascript:)') { continue }
    $t = Join-Path (Split-Path $pg -Parent) (($u -replace '[?#].*$', '') -replace '/', '\')
    if (-not (Test-Path $t)) { $refProblems += "$(Rel $pg) references '$u', which does not exist: create the file or fix the path" }
  }
}
foreach ($cf in (Get-ChildItem $proj -Recurse -File -Filter *.css)) {
  $tx = [IO.File]::ReadAllText($cf.FullName, [Text.Encoding]::UTF8)
  foreach ($m in [regex]::Matches($tx, 'url\(\s*["'']?([^)"'']+)["'']?\s*\)')) {
    $u = $m.Groups[1].Value.Trim()
    if ($u -match '^(#|https?:|//|data:|var\()') { continue }
    $t = Join-Path $cf.DirectoryName (($u -replace '[?#].*$', '') -replace '/', '\')
    if (-not (Test-Path $t)) { $refProblems += "$(Rel $cf.FullName) uses url('$u'), which does not exist: fix the path (a font or image moved?)" }
  }
}
ScanRow '7b. Every local file linked from the pages and stylesheets exists' $refProblems

# 7c. Relative links in the Markdown files resolve.
$mdProblems = @()
foreach ($md in (Get-ChildItem $proj -Recurse -File -Filter *.md)) {
  $tx = [IO.File]::ReadAllText($md.FullName, [Text.Encoding]::UTF8)
  foreach ($m in [regex]::Matches(($tx -replace '(?s)```.*?```', ''), '\]\(([^)\s]+)\)')) {
    $u = $m.Groups[1].Value
    if ($u -match '^(#|https?:|mailto:|tel:)') { continue }
    $t = Join-Path $md.DirectoryName (($u -replace '#.*$', '') -replace '/', '\')
    if (-not (Test-Path $t)) { $mdProblems += "$(Rel $md.FullName) links to '$u', which does not exist: fix the link or restore the file" }
  }
}
ScanRow '7c. Every relative link in the Markdown files resolves' $mdProblems

# 7d. Generated output: marker lines present, the dashboard's token list and variables.css name the same tokens, nothing referenced is undeclared.
$genProblems = @()
foreach ($g in '02-Design-Variables/Styles/variables.css', '02-Design-Variables/responsive-token-matrix.md', '02-Design-Variables/Documentation/token-reference.md') {
  $gp = Join-Path $proj $g
  if ((Test-Path $gp) -and ([IO.File]::ReadAllText($gp, [Text.Encoding]::UTF8) -notmatch 'GENERATED')) { $genProblems += "$g has no GENERATED marker: it was edited by hand or is not generator output. Run build-tokens.ps1 (never edit it by hand)" }
}
$varsPath = Join-Path $dv 'Styles\variables.css'
if (Test-Path $varsPath) {
  $vtx = [IO.File]::ReadAllText($varsPath, [Text.Encoding]::UTF8)
  $declared = @{}; foreach ($m in [regex]::Matches($vtx, '(?m)^\s*--([a-z0-9-]+)\s*:')) { $declared[$m.Groups[1].Value] = 1 }
  $dataNames = @{}; foreach ($t in $data.tokens) { $dataNames[$t.n] = 1 }
  $noCss = @($dataNames.Keys | Where-Object { -not $declared.ContainsKey($_) } | Sort-Object)
  $noData = @($declared.Keys | Where-Object { -not $dataNames.ContainsKey($_) } | Sort-Object)
  if ($noCss.Count) { $genProblems += "$($noCss.Count) token(s) in the dashboard data are not declared in variables.css (first: --$($noCss[0])). Run build-tokens.ps1" }
  if ($noData.Count) { $genProblems += "$($noData.Count) custom propert(ies) in variables.css are missing from the dashboard data (first: --$($noData[0])). Run build-tokens.ps1" }
  $undeclared = @(); foreach ($m in [regex]::Matches($vtx, 'var\(\s*--([a-z0-9-]+)')) { if (-not $declared.ContainsKey($m.Groups[1].Value)) { $undeclared += $m.Groups[1].Value } }
  if ($undeclared.Count) { $genProblems += "variables.css uses var(--$($undeclared[0])) but never declares it: fix the alias in the JSON and run build-tokens.ps1" }
  $refDoc = Join-Path $dv 'Documentation\token-reference.md'
  if (Test-Path $refDoc) { $rt = [IO.File]::ReadAllText($refDoc, [Text.Encoding]::UTF8); $notInRef = @($declared.Keys | Where-Object { $rt.IndexOf("--$_") -lt 0 } | Sort-Object); if ($notInRef.Count) { $genProblems += "$($notInRef.Count) declared token(s) are missing from token-reference.md (first: --$($notInRef[0])). Run build-tokens.ps1" } }
}
ScanRow '7d. Generated output is complete and self-consistent (markers, token sets, references)' $genProblems

# 7e. Freshness: re-run the generator on a temporary copy and compare the generated files with the committed ones.
$freshProblems = @()
$fp = Join-Path $tmp 'fresh'; New-Item -ItemType Directory -Force $fp | Out-Null
Copy-Item (Join-Path $proj '01-Design-System') (Join-Path $fp '01-Design-System') -Recurse
Copy-Item $dv (Join-Path $fp '02-Design-Variables') -Recurse
Copy-Item (Join-Path $proj '05-Assets') (Join-Path $fp '05-Assets') -Recurse
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $fp '02-Design-Variables\Tokens\build-tokens.ps1') | Out-Null; $fx = $LASTEXITCODE
if ($fx -ne 0) { $freshProblems += "build-tokens.ps1 exited $fx on a clean copy: run it directly to see the error" }
else {
  foreach ($g in '02-Design-Variables\Styles\variables.css', '02-Design-Variables\responsive-token-matrix.md', '02-Design-Variables\Documentation\token-reference.md', '02-Design-Variables\Preview\index.html') {
    if ((Get-FileHash (Join-Path $fp $g)).Hash -ne (Get-FileHash (Join-Path $proj $g)).Hash) { $freshProblems += "$($g.Replace('\', '/')) is stale: it differs from what build-tokens.ps1 generates from the JSON. Run build-tokens.ps1 and commit the result" }
  }
}
ScanRow '7e. Generated files equal a fresh build from the JSON (not stale)' $freshProblems

# 7f. Page structure in a browser, at 320, 390 and 1280px, on the showcase and the dashboard.
$scanJs = @'
<script>
var PAGES=[['Design System showcase','%DS%'],['Token dashboard','%DV%']], W=[320,390,1280], out=[], box=document.getElementById('b');
function wait(ms){return new Promise(function(r){setTimeout(r,ms)})}
(async function(){
 for (var p of PAGES) for (var w of W){
  var f=document.createElement('iframe'); f.style.cssText='width:'+w+'px;height:900px;border:0'; f.src=p[1]; box.appendChild(f);
  await new Promise(function(r){f.onload=r}); await wait(900);
  var d=f.contentDocument, r={page:p[0],w:w,problems:[]}, ids={};
  function add(s){ r.problems.push(s) }
  d.querySelectorAll('[id]').forEach(function(e){ids[e.id]=(ids[e.id]||0)+1}); Object.keys(ids).forEach(function(k){ if(ids[k]>1) add('duplicate id "'+k+'": ids must be unique') });
  ['aria-labelledby','aria-describedby','aria-controls'].forEach(function(a){ d.querySelectorAll('['+a+']').forEach(function(e){ e.getAttribute(a).split(/\s+/).forEach(function(id){ if(id && !d.getElementById(id)) add(a+' points to #'+id+', which does not exist') }) }) });
  d.querySelectorAll('a[href^="#"]').forEach(function(a){ var h=a.getAttribute('href'); if(h.length>1 && !d.getElementById(h.slice(1))) add('link to '+h+' has no target') });
  d.querySelectorAll('use').forEach(function(u){ var h=u.getAttribute('href')||''; if(h.charAt(0)==='#' && !d.getElementById(h.slice(1))) add('icon '+h+' is not in the sprite') });
  function nm(e){ return (e.getAttribute('aria-label')||'').trim() || (e.getAttribute('aria-labelledby')?'x':'') || (e.textContent||'').trim() }
  d.querySelectorAll('button,a[href]').forEach(function(e){ if(!nm(e)) add('<'+e.tagName.toLowerCase()+' class="'+e.className+'"> has no accessible name') });
  d.querySelectorAll('input:not([type=hidden]),select,textarea').forEach(function(e){ var has=e.getAttribute('aria-label')||e.getAttribute('aria-labelledby')||(e.id&&d.querySelector('label[for="'+e.id+'"]'))||e.closest('label'); if(!has) add('form control '+e.tagName.toLowerCase()+(e.id?'#'+e.id:'')+' has no label') });
  var h=[].slice.call(d.querySelectorAll('h1,h2,h3,h4,h5,h6')), prev=0, h1=0;
  h.forEach(function(e){ var l=+e.tagName[1]; if(l===1) h1++; if(prev && l>prev+1) add('heading jumps from h'+prev+' to h'+l+' at "'+e.textContent.trim().slice(0,30)+'"'); prev=l });
  if(h1!==1) add('page has '+h1+' h1 elements, expected 1');
  if(!d.documentElement.lang) add('<html> has no lang'); if(!d.title) add('page has no <title>');
  d.querySelectorAll('dialog').forEach(function(e){ if(!(e.getAttribute('aria-label')||e.getAttribute('aria-labelledby'))) add('dialog #'+e.id+' has no accessible name') });
  d.querySelectorAll('[data-drawer-open]').forEach(function(e){ var t=d.getElementById(e.getAttribute('data-drawer-open')); if(!t||t.tagName!=='DIALOG') add('data-drawer-open="'+e.getAttribute('data-drawer-open')+'" does not point to a <dialog>'); });
  d.querySelectorAll('[data-load-more]').forEach(function(e){ var t=d.getElementById(e.getAttribute('data-load-more-target')); if(!t) add('data-load-more-target="'+e.getAttribute('data-load-more-target')+'" does not exist'); if(!e.querySelector('a[data-load-more-button][href]')) add('Load more needs a real <a href> so it works without JavaScript'); });
  d.querySelectorAll('.product-card').forEach(function(c){ var b=c.querySelector('.product-card__badges'), wl=c.querySelector('.product-card__wishlist'); if(b&&wl){ var x=b.getBoundingClientRect(), y=wl.getBoundingClientRect(); if(x.right>y.left+0.5 && x.left<y.right && x.bottom>y.top && x.top<y.bottom) add('product card badge overlaps the wishlist button ('+Math.round(x.width)+'px badge in a '+Math.round(c.getBoundingClientRect().width)+'px card): reserve room for the 44px button'); } });
  r.overflow = d.documentElement.scrollWidth > d.documentElement.clientWidth + 1; if(r.overflow) add('horizontal overflow: the page is '+d.documentElement.scrollWidth+'px wide but only '+d.documentElement.clientWidth+'px is visible in a '+w+'px window');
  r.n=r.problems.length; r.problems=r.problems.slice(0,5); out.push(r); f.remove();
 }
 var pre=document.createElement('pre'); pre.id='result'; pre.textContent=JSON.stringify(out); document.body.appendChild(pre);
})();
</script>
'@
$scanJs = $scanJs.Replace('%DS%', (FileUrl (Join-Path $proj '01-Design-System\index.html'))).Replace('%DV%', $dashUrl)
[IO.File]::WriteAllText("$tmp\structure.html", "<!doctype html><meta charset=`"utf-8`"><body style=`"margin:0`"><div id=`"b`"></div>$scanJs", (New-Object Text.UTF8Encoding($false)))
Start-Process -FilePath $browser -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', '--virtual-time-budget=60000', '--dump-dom', (FileUrl "$tmp\structure.html")) -RedirectStandardOutput "$tmp\structure-out.html" -RedirectStandardError "$tmp\structure-err.txt" -Wait -NoNewWindow
$sm = [regex]::Match([IO.File]::ReadAllText("$tmp\structure-out.html", [Text.Encoding]::UTF8), '(?s)<pre id="result">(.*?)</pre>')
if (-not $sm.Success) { ScanRow '7f. Page structure in a browser (320, 390, 1280px)' @('the browser produced no result: run the test again, or open 01-Design-System/index.html and check the console') }
else {
  $sres = [Net.WebUtility]::HtmlDecode($sm.Groups[1].Value) | ConvertFrom-Json
  $pp = @(); foreach ($r in $sres) { foreach ($pr in @($r.problems)) { $pp += "$($r.page) at $($r.w)px: $pr" } }
  ScanRow "7f. Page structure in a browser: $(@($sres).Count) page and width combinations (ids, ARIA and anchor references, icons, names, labels, headings, lang, title, dialogs, Load more, overflow)" $pp
}
foreach ($sr in $scanRows) {
  $ok = ($sr.problems.Count -eq 0)
  Write-Host ("   {0,-100} {1}" -f $sr.name, $(if ($ok) { 'PASS' } else { 'FAIL' }))
  if (-not $ok) { $fail++; $sr.problems | Select-Object -First 8 | ForEach-Object { Write-Host "        - $_" } }
}
# 8. Typography units. Convention: static font sizes are px; fluid sizes are clamp(Arem, Brem + Cvw, Drem) (the documented rem exception);
# points (pt) are never allowed. Deterministic; each failure names the file and, for tokens, the token.
Write-Host "`n8. Typography units (no points; static sizes in px; fluid sizes in clamp() of rem and vw)"
$tyRows = @()
function TyRow([string]$name, [string[]]$problems) { $script:tyRows += [pscustomobject]@{ name = $name; problems = @($problems) } }
function TyRel([string]$p) { $p.Substring($proj.Length + 1).Replace('\', '/') }
$ptRx = '(?<![\w.#-])-?\d*\.?\d+\s?pt\b'

# 8a. No point unit anywhere. Token files are checked per token (file and token name); other files per line. Markdown and PowerShell are
# excluded because they may state the rule (and the history of this project quotes 'pt').
$ptProblems = @()
function WalkTokens($node, [string[]]$path, [string]$file) {
  foreach ($p in $node.PSObject.Properties) {
    if ($p.Name.StartsWith('$')) { continue }
    $c = $p.Value; if ($c -isnot [pscustomobject]) { continue }
    $np = $path + $p.Name
    if ($c.PSObject.Properties.Name -contains '$value') {
      $v = $c.'$value'; $vals = if ($v -is [pscustomobject]) { @($v.PSObject.Properties | ForEach-Object { [string]$_.Value }) } else { @([string]$v) }
      foreach ($x in $vals) { if ($x -match $ptRx) { $script:ptProblems += "$file token '$($np -join '.')' (--$($np -join '-')) uses points: '$x'. Convert at 1pt = 1.3333px and write px (static) or a rem clamp() (fluid), then run build-tokens.ps1" } }
    } else { WalkTokens $c $np $file }
  }
}
foreach ($jf in (Get-ChildItem (Join-Path $dv 'Tokens') -Filter *.json)) { WalkTokens (Get-Content $jf.FullName -Raw -Encoding UTF8 | ConvertFrom-Json) @() (TyRel $jf.FullName) }
foreach ($f in (Get-ChildItem $proj -Recurse -File -Include *.css, *.js, *.html, *.svg | Where-Object { $_.FullName -notmatch '\\(node_modules|\.git)\\' })) {
  $lines = [IO.File]::ReadAllLines($f.FullName, [Text.Encoding]::UTF8)
  for ($i = 0; $i -lt $lines.Count; $i++) {
    foreach ($m in [regex]::Matches($lines[$i], $ptRx)) { $ptProblems += "$(TyRel $f.FullName) line $($i + 1): '$($m.Value)' is a point unit. Use px, or fix the source token in typography.json and run build-tokens.ps1" }
  }
}
TyRow '8a. No point (pt) unit in any token file, stylesheet, script, page or SVG' $ptProblems

# 8b. Canonical font-size tokens: static = Npx; fluid = clamp(Arem, Brem + Cvw, Drem) with min <= max and max/min <= 2.5; aliases allowed.
$sizeProblems = @(); $nStatic = 0; $nFluid = 0
$tj = Get-Content (Join-Path $dv 'Tokens\typography.json') -Raw -Encoding UTF8 | ConvertFrom-Json
foreach ($p in $tj.font.size.PSObject.Properties) {
  if ($p.Name.StartsWith('$')) { continue }
  $raw = $p.Value.'$value'; $where = "Tokens/typography.json token 'font.size.$($p.Name)' (--font-size-$($p.Name))"
  if ($raw -isnot [string]) {
    # Tier token { mobile, tablet, desktop }: every tier is a static px size
    $nStatic++
    foreach ($tp in $raw.PSObject.Properties) { if ([string]$tp.Value -notmatch '^\d+(\.\d+)?px$') { $sizeProblems += "$where tier '$($tp.Name)' is '$($tp.Value)': a font size must be written in px (for example 16px)" } }
    continue
  }
  $val = [string]$raw
  if ($val -match '^\{[^{}]+\}$') { continue }
  if ($val -like 'clamp(*') {
    $nFluid++
    $m = [regex]::Match($val, '^clamp\(\s*(\d*\.?\d+)rem\s*,\s*(\d*\.?\d+)rem\s*\+\s*(\d*\.?\d+)vw\s*,\s*(\d*\.?\d+)rem\s*\)$')
    if (-not $m.Success) { $sizeProblems += "$where is '$val': a fluid size must be clamp(Arem, Brem + Cvw, Drem)"; continue }
    $mn = [double]::Parse($m.Groups[1].Value, $inv); $mx = [double]::Parse($m.Groups[4].Value, $inv)
    if ($mn -gt $mx) { $sizeProblems += "$where has its minimum ($mn rem) above its maximum ($mx rem)" }
    elseif ($mx / $mn -gt 2.5) { $sizeProblems += "$where has max/min $([math]::Round($mx / $mn, 2)), above 2.5, which text zoom can defeat" }
    continue
  }
  $nStatic++
  if ($val -notmatch '^\d+(\.\d+)?px$') { $sizeProblems += "$where is '$val': a static font size must be written in px (for example 16px)" }
}
TyRow "8b. $nStatic static font-size tokens are px; $nFluid fluid tokens are valid rem clamp() (max/min <= 2.5)" $sizeProblems

# 8c. In the theme stylesheets every font-size comes from a token (var()), or inherits.
$litProblems = @()
foreach ($css in 'foundation', 'base', 'components') {
  $fp = Join-Path $proj "01-Design-System\Styles\$css.css"
  if (-not (Test-Path $fp)) { continue }
  $tx = [regex]::Replace([IO.File]::ReadAllText($fp, [Text.Encoding]::UTF8), '(?s)/\*.*?\*/', '')
  foreach ($m in [regex]::Matches($tx, '(?<![\w-])font-size\s*:\s*([^;}]+)')) {
    $v = $m.Groups[1].Value.Trim()
    if ($v -notmatch '^(var\(|inherit$|initial$|unset$)') { $litProblems += "01-Design-System/Styles/$css.css has font-size: $v. Use a --font-size-* or --type-*-font-size token (add the token in typography.json first if none fits)" }
  }
}
TyRow '8c. Theme CSS (foundation, base, components) takes every font-size from a token' $litProblems

# 8d. Generated variables.css: static font-size properties are px; fluid ones use only rem and vw.
$genProblems = @()
$vp = Join-Path $dv 'Styles\variables.css'
if (Test-Path $vp) {
  $vt = [regex]::Replace([IO.File]::ReadAllText($vp, [Text.Encoding]::UTF8), '(?s)/\*.*?\*/', '')
  foreach ($m in [regex]::Matches($vt, '(?m)^\s*(--font-size-[a-z0-9-]+)\s*:\s*([^;]+);')) {
    $nm = $m.Groups[1].Value; $v = $m.Groups[2].Value.Trim()
    if ($v -like 'var(*') { continue }
    if ($v -like 'clamp(*') { foreach ($u in [regex]::Matches($v, '(?<![\w.#-])-?\d*\.?\d+([a-z%]+)\b')) { if ($u.Groups[1].Value -notin 'rem', 'vw') { $genProblems += "variables.css $nm uses unit '$($u.Groups[1].Value)' inside clamp(). Fix the token in typography.json and run build-tokens.ps1" } } }
    elseif ($v -notmatch '^\d+(\.\d+)?px$') { $genProblems += "variables.css $nm is '$v': a static font size must be px. Fix the token in typography.json and run build-tokens.ps1" }
  }
}
TyRow '8d. Generated font-size properties: static in px, fluid in rem and vw only' $genProblems

# 8e. Scale: every generated font size is a whole, even px value (all tiers), and every px line height is on the 4px grid.
$evenProblems = @(); $nEven = 0
if (Test-Path $vp) {
  foreach ($m in [regex]::Matches($vt, '(?m)^\s*(--(font-size|line-height)-[a-z0-9-]+)\s*:\s*([^;]+);')) {
    $nm = $m.Groups[1].Value; $v = $m.Groups[3].Value.Trim()
    if ($v -notmatch '^(\d+(\.\d+)?)px$') { continue }
    $n = [double]::Parse($Matches[1], $inv); $nEven++
    if ($m.Groups[2].Value -eq 'font-size' -and ($n -ne [math]::Floor($n) -or ($n % 2) -ne 0)) { $evenProblems += "variables.css $nm is ${v}: font sizes must be whole, even px. Fix typography.json and run build-tokens.ps1" }
    if ($m.Groups[2].Value -eq 'line-height' -and ($n % 4) -ne 0) { $evenProblems += "variables.css $nm is ${v}: a px line height must sit on the 4px grid" }
  }
}
TyRow "8e. $nEven generated px font sizes and line heights: font sizes whole and even, px line heights on the 4px grid" $evenProblems

# 8f. Spacing scale: every space-* token (and the tiers of space-section) is on the 4px grid.
$gridProblems = @(); $nGrid = 0
$sj = Get-Content (Join-Path $dv 'Tokens\spacing.json') -Raw -Encoding UTF8 | ConvertFrom-Json
foreach ($p in $sj.space.PSObject.Properties) {
  if ($p.Name.StartsWith('$')) { continue }
  $raw = $p.Value.'$value'; $vals = if ($raw -is [string]) { @($raw) } else { @($raw.PSObject.Properties | ForEach-Object { [string]$_.Value }) }
  foreach ($v in $vals) {
    if ($v -match '^\{space\.(\w+)\}$') { $v = [string]$sj.space.($Matches[1]).'$value' }
    if ($v -match '^0$') { $nGrid++; continue }
    if ($v -notmatch '^(\d*\.?\d+)(px|rem)$') { $gridProblems += "spacing.json space.$($p.Name) is '$v': spacing must be a px or rem value on the 4px grid (no fluid clamp)"; continue }
    $px = [double]::Parse($Matches[1], $inv) * $(if ($Matches[2] -eq 'rem') { 16 } else { 1 }); $nGrid++
    if (($px % 4) -ne 0) { $gridProblems += "spacing.json space.$($p.Name) is $v ($px px): not on the 4px grid" }
  }
}
TyRow "8f. $nGrid spacing values (all tiers) are on the 4px grid" $gridProblems
foreach ($tr in $tyRows) {
  $ok = ($tr.problems.Count -eq 0)
  Write-Host ("   {0,-100} {1}" -f $tr.name, $(if ($ok) { 'PASS' } else { 'FAIL' }))
  if (-not $ok) { $fail++; $tr.problems | Select-Object -First 8 | ForEach-Object { Write-Host "        - $_" } }
}
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
if ($fail) { Write-Host "`nRESULT: $fail group(s) FAILED"; exit 1 }
Write-Host "`nRESULT: all passed"; exit 0
