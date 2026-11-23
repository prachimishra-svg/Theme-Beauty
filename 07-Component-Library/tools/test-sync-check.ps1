# Proves that check-shopify-sync.ps1 reports what it should. Each scenario makes a deliberate change, runs the check against a temporary lock, and requires the right status and exit code.
# Files that are touched are backed up and restored, and compared by hash at the end. 06-Shopify-Theme is never touched (the fingerprint scenario uses an altered COPY of the baseline).
# Usage: .\tools\test-sync-check.ps1
$ErrorActionPreference = 'Stop'
$LIBDIR = Split-Path -Parent $PSScriptRoot; $PRJ = Split-Path -Parent $LIBDIR; $FOUND = Join-Path $PRJ '03-Wireframes\00-Shared-Tailwind-Foundation'; $utf8 = New-Object Text.UTF8Encoding($false)
$tmp = Join-Path ([IO.Path]::GetTempPath()) 'nudge-sync-test'; New-Item -ItemType Directory -Force $tmp | Out-Null
$lock = Join-Path $tmp 'lock.json'; if (Test-Path $lock) { Remove-Item $lock }
$secH = "$FOUND\partials\components\base\section-heading\section-heading.html"; $secJ = "$FOUND\partials\components\base\section-heading\section-heading.json"
$badgeJ = "$FOUND\partials\components\base\badge\badge.json"; $stageSec = "$LIBDIR\shopify\staging\snippets\section-heading.liquid"; $stageBadge = "$LIBDIR\shopify\staging\snippets\badge.liquid"
$uspH = "$FOUND\partials\components\homepage\usp-item\usp-item.html"
$touched = @($secH, $secJ, $badgeJ, $stageSec, $stageBadge, $uspH); $orig = @{}; foreach ($f in $touched) { $orig[$f] = [IO.File]::ReadAllBytes($f) }
$pass = 0; $fail = 0
function Check([string]$name, [bool]$ok, [string]$detail = '') { if ($ok) { $script:pass++; "pass  $name" } else { $script:fail++; "FAIL  $name  $detail" } }
function Run([string[]]$extra) { $ep = $ErrorActionPreference; $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File "$LIBDIR\tools\check-shopify-sync.ps1" -NoWrite -LockPath $lock @extra 2>&1; $cd = $LASTEXITCODE; $ErrorActionPreference = $ep; @{ code = $cd; text = ($o | ForEach-Object { $_.ToString() }) -join "`n" } }
function Regen([string]$comp) { & powershell -NoProfile -ExecutionPolicy Bypass -File "$LIBDIR\tools\generate-liquid-staging.ps1" -Components $comp | Out-Null }
function StatusOf([string]$text, [string]$comp) { $m = [regex]::Match($text, [regex]::Escape($comp) + ' *:'); $null }
try {
  # 1. first run: equal outputs, lock pending; -Accept records it; then everything is in sync
  $r = Run @('-SkipBuild'); Check 'first run: outputs equal, lock pending, exit 0' ($r.code -eq 0 -and $r.text -match 'EQUAL, LOCK PENDING 13') $r.text.Substring(0, [Math]::Min(300, $r.text.Length))
  $r = Run @('-SkipBuild', '-Accept'); Check '-Accept records the lock: 13 in sync' ($r.code -eq 0 -and $r.text -match 'IN SYNC 13') $r.text.Substring(0, [Math]::Min(300, $r.text.Length))
  $r = Run @('-SkipBuild'); Check 'second run stays in sync' ($r.code -eq 0 -and $r.text -match 'IN SYNC 13')
  # 2. the library component changes, the Liquid does not: DIFFERS
  $t = [IO.File]::ReadAllText($secH, $utf8); [IO.File]::WriteAllText($secH, $t + '<!--changed-->', $utf8)
  $r = Run @('-SkipBuild'); Check 'library output changed, Liquid not regenerated: DIFFERS and exit 1' ($r.code -eq 1 -and $r.text -match 'DIFFERS : components/base/section-heading') $r.text.Substring(0, [Math]::Min(400, $r.text.Length))
  # 3. the Liquid is regenerated: outputs equal again, but the lock is older: STALE
  Regen 'components/base/section-heading'
  $r = Run @('-SkipBuild'); Check 'Liquid regenerated, lock older: STALE and exit 1' ($r.code -eq 1 -and $r.text -match 'STALE : components/base/section-heading') $r.text.Substring(0, [Math]::Min(400, $r.text.Length))
  $r = Run @('-SkipBuild', '-Accept'); Check 'accepting the new state clears STALE' ($r.code -eq 0 -and $r.text -match 'IN SYNC 13') $r.text.Substring(0, [Math]::Min(300, $r.text.Length))
  [IO.File]::WriteAllBytes($secH, $orig[$secH]); Regen 'components/base/section-heading'
  # 4. a contract-only change (a property's class) with identical output: STALE
  $m = [IO.File]::ReadAllText($badgeJ, $utf8) | ConvertFrom-Json; ($m.properties | Where-Object { $_.name -eq 'extra' }).scope = 'merchant'; [IO.File]::WriteAllText($badgeJ, ($m | ConvertTo-Json -Depth 20), $utf8)
  $r = Run @('-SkipBuild'); Check 'contract changed (property class), output identical: STALE' ($r.code -eq 1 -and $r.text -match 'STALE : components/base/badge') $r.text.Substring(0, [Math]::Min(400, $r.text.Length))
  [IO.File]::WriteAllBytes($badgeJ, $orig[$badgeJ])
  # 5. the Liquid is edited by hand with no visible output change: DRIFT
  $lq = [IO.File]::ReadAllText($stageBadge, $utf8); [IO.File]::WriteAllText($stageBadge, $lq + "`n{%- comment -%} hand edit {%- endcomment -%}", $utf8)
  $r = Run @('-SkipBuild'); Check 'Liquid edited by hand: DRIFT and exit 1' ($r.code -eq 1 -and $r.text -match 'DRIFT : components/base/badge') $r.text.Substring(0, [Math]::Min(400, $r.text.Length))
  [IO.File]::WriteAllBytes($stageBadge, $orig[$stageBadge])
  # 6. a broken wireframe build must fail the check loudly
  $u = [IO.File]::ReadAllText($uspH, $utf8); [IO.File]::WriteAllText($uspH, $u + '{{no_such_property}}', $utf8)
  $r = Run @(); Check 'broken build: BUILD FAILED reported and exit 1' ($r.code -eq 1 -and $r.text -match 'BUILD FAILED') $r.text.Substring(0, [Math]::Min(400, $r.text.Length))
  [IO.File]::WriteAllBytes($uspH, $orig[$uspH])
  # 7. the 06-Shopify-Theme fingerprint: an altered COPY of the baseline stands in for a changed theme
  $bj = [IO.File]::ReadAllText("$LIBDIR\shopify\06-baseline.json", $utf8) | ConvertFrom-Json; $first = @($bj.files.PSObject.Properties)[0]; $first.Value = ('0' * 64)
  $alt = Join-Path $tmp 'baseline-altered.json'; [IO.File]::WriteAllText($alt, ($bj | ConvertTo-Json -Depth 5), $utf8)
  $r = Run @('-SkipBuild', '-BaselinePath', $alt); Check 'theme fingerprint mismatch: CHANGED reported and exit 1' ($r.code -eq 1 -and $r.text -match '06-Shopify-Theme CHANGED') $r.text.Substring(0, [Math]::Min(400, $r.text.Length))
} finally {
  foreach ($f in $touched) { [IO.File]::WriteAllBytes($f, $orig[$f]) }
}
$same = 0; foreach ($f in $touched) { $a = (Get-FileHash $f -Algorithm SHA256).Hash; $sha = [Security.Cryptography.SHA256]::Create(); $b = (($sha.ComputeHash($orig[$f]) | ForEach-Object { $_.ToString('x2') }) -join '').ToUpper(); if ($a -eq $b) { $same++ } }
Check 'every touched file was restored byte for byte' ($same -eq $touched.Count) "$same of $($touched.Count)"
& powershell -NoProfile -ExecutionPolicy Bypass -File "$LIBDIR\tools\generate-liquid-staging.ps1" | Out-Null
if (Test-Path $lock) { Remove-Item $lock }
$r = Run @('-SkipBuild'); Check 'after restoring, the real state is clean again (fresh lock: outputs equal)' ($r.code -eq 0 -and $r.text -match 'EQUAL, LOCK PENDING 13') $r.text.Substring(0, [Math]::Min(300, $r.text.Length))
"sync check tests: $pass passed, $fail failed"; if ($fail) { exit 1 }
