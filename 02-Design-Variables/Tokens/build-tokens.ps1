<#
  NUDGE Design Variables builder

  SOURCE OF TRUTH:  02-Design-Variables/Tokens/*.json   (edit these)
  GENERATED:        02-Design-Variables/Styles/variables.css
                    02-Design-Variables/responsive-token-matrix.md
                    02-Design-Variables/Documentation/token-reference.md
                    token data block inside 02-Design-Variables/Preview/index.html
  Never hand-edit generated files; re-run:
    powershell -ExecutionPolicy Bypass -File 02-Design-Variables/Tokens/build-tokens.ps1

  JSON format (DTCG-style):
    leaf             { "$value": "...", "$description": "..." }
    tier leaf        "$value": { "mobile": "...", "tablet": "...", "desktop": "..." }   (media-query tiers)
    fluid leaf       "$value": "clamp(Xrem, Yrem + Zvw, Wrem)"                           (continuous; validated)
    alias            "{palette.rose.700}"  ->  var(--palette-rose-700)   (inside any string)
  CSS name = path segments joined by "-" ( color.bg.page -> --color-bg-page ).

  This is the ONLY token source. The Design System (01-Design-System/) consumes the generated CSS.

  Checks and exit codes:
    1  invalid JSON, unresolved alias, duplicate CSS name, alias cycle, tier leaf without "mobile",
       malformed or unreadable fluid clamp()
    4  01-Design-System/ not found (use -AllowMissingDesignSystem to skip the check deliberately)
    5  the Design System re-declares a canonical token, uses an unresolved or deprecated custom property,
       or its compatibility aliases do not point at canonical tokens
  The Design System is only READ, never modified.#>
param([switch]$AllowMissingDesignSystem)   # only for running without the Design System beside this folder
$ErrorActionPreference = 'Stop'
$inv  = [Globalization.CultureInfo]::InvariantCulture
$utf8 = New-Object System.Text.UTF8Encoding($false)
$dv   = Split-Path -Parent $PSScriptRoot                  # 02-Design-Variables/
$proj = Split-Path -Parent $dv                            # project root
$tokDir = Join-Path $dv 'Tokens'
$cssDir = Join-Path $dv 'Styles'
$docDir = Join-Path $dv 'Documentation'
New-Item -ItemType Directory -Force $cssDir, $docDir | Out-Null

$files = @(
  @{ json='primitives';  title='Primitive tokens';  note='Raw palette values. Never consumed directly by components.' },
  @{ json='semantic';    title='Semantic color tokens'; note='What a color is FOR. Components use these.' },
  @{ json='typography';  title='Typography tokens'; note='Families, weights, responsive sizes, line heights, letter spacing, composite type roles.' },
  @{ json='spacing';     title='Spacing tokens';    note='Static 4px scale + responsive section and stack spacing.' },
  @{ json='layout';      title='Layout tokens';     note='Containers, gutters, grid columns, header/drawer, aspect ratios.' },
  @{ json='breakpoints'; title='Breakpoint tokens'; note='Tier boundaries (reference values; literals are written into the media queries).' },
  @{ json='components';  title='Component tokens';  note='Buttons, inputs, choices, swatches, badges, ratings, cards, product cards, product images.' },
  @{ json='effects';     title='Effect tokens';     note='Radius, borders, shadows, opacity, motion, z-index.' }
)

# ---------- 1. Load ----------------------------------------------------------
$script:tokens = New-Object System.Collections.ArrayList
function Walk($node, [string[]]$path, $file) {
  foreach ($p in $node.PSObject.Properties) {
    if ($p.Name.StartsWith('$')) { continue }
    $child = $p.Value
    $np = $path + $p.Name
    if ($child.PSObject.Properties.Name -contains '$value') {
      $raw = $child.'$value'
      $resp = $false
      if ($raw -isnot [string]) {
        $names = $raw.PSObject.Properties.Name
        if ($names -notcontains 'mobile') { throw "Responsive token '$($np -join '.')' in $($file.json).json needs a 'mobile' value." }
        $m = [string]$raw.mobile
        $t = if ($names -contains 'tablet')  { [string]$raw.tablet }  else { $m }
        $d = if ($names -contains 'desktop') { [string]$raw.desktop } else { $t }
        $raw = [ordered]@{ mobile = $m; tablet = $t; desktop = $d }
        $resp = $true
      }
      $fluid = ($raw -is [string]) -and ($raw -match '^clamp\(')
      $desc = if ($child.PSObject.Properties.Name -contains '$description') { [string]$child.'$description' } else { '' }
      [void]$script:tokens.Add([pscustomobject]@{ File=$file; Path=($np -join '.'); Name=($np -join '-'); Raw=$raw; Responsive=$resp; Fluid=$fluid; Desc=$desc })
    } else { Walk $child $np $file }
  }
}
foreach ($f in $files) {
  $j = Get-Content (Join-Path $tokDir "$($f.json).json") -Raw | ConvertFrom-Json
  Walk $j @() $f
}

# ---------- 2. Validate names ------------------------------------------------
$script:byName = @{}
foreach ($t in $script:tokens) {
  if ($script:byName.ContainsKey($t.Name)) { throw "Duplicate CSS name --$($t.Name) ($($script:byName[$t.Name].File.json) and $($t.File.json))" }
  $script:byName[$t.Name] = $t
}
$aliasRx = '\{([A-Za-z0-9._-]+)\}'
function Resolve([string]$s, [string]$ctx) {
  [regex]::Replace($s, $aliasRx, [Text.RegularExpressions.MatchEvaluator]{
    param($m)
    $n = $m.Groups[1].Value.Replace('.', '-')
    if (-not $script:byName.ContainsKey($n)) { throw "Unresolved alias {$($m.Groups[1].Value)} in $ctx" }
    "var(--$n)"
  })
}

# Fluid tokens: clamp(Xrem, Yrem + Zvw, Wrem). Parsed, validated, and measured here so the behavior is documented.
$fluidRx = 'clamp\(\s*([\d.]+)rem\s*,\s*([\d.]+)rem\s*\+\s*([\d.]+)vw\s*,\s*([\d.]+)rem\s*\)'
function FluidParts([string]$expr) {
  $mm = [regex]::Match($expr, $fluidRx)
  if (-not $mm.Success) { return $null }
  [pscustomobject]@{
    Min = [double]::Parse($mm.Groups[1].Value, $inv) * 16; A = [double]::Parse($mm.Groups[2].Value, $inv) * 16
    B = [double]::Parse($mm.Groups[3].Value, $inv); Max = [double]::Parse($mm.Groups[4].Value, $inv) * 16
  }
}
function FluidPx([string]$expr, [double]$w) { $f = FluidParts $expr; [math]::Round([math]::Min([math]::Max($f.Min, $f.A + $f.B * $w / 100), $f.Max), 1) }
foreach ($t in $script:tokens) {
  if (-not $t.Fluid) { continue }
  $f = FluidParts $t.Raw
  if (-not $f) { throw "Fluid token --$($t.Name) must be written clamp(Xrem, Yrem + Zvw, Wrem); got: $($t.Raw)" }
  if ($f.Min -ge $f.Max) { throw "Fluid token --$($t.Name): minimum ($($f.Min)px) must be below maximum ($($f.Max)px)" }
  if ($f.B -le 0) { throw "Fluid token --$($t.Name): the vw coefficient must be positive" }
  if ($t.Name -like 'font-size-*' -and $f.Min -lt 16) { throw "Fluid font size --$($t.Name) falls below 16px at its minimum ($($f.Min)px)" }
}

# Font-size units. Rule: no point (pt) unit in any token (1pt = 1.3333px, so convert), static font sizes are px, fluid sizes
# are the clamp() above (their rem bounds are the documented exception: they follow the browser's default font size).
foreach ($t in $script:tokens) {
  $vals = if ($t.Responsive) { @($t.Raw.mobile, $t.Raw.tablet, $t.Raw.desktop) } else { @([string]$t.Raw) }
  foreach ($v in $vals) {
    if ($v -match '(?<![\w.#-])-?\d*\.?\d+\s?pt\b') { throw "Token --$($t.Name) (path $($t.Path)) in Tokens/$($t.File.json).json uses points: '$v'. Points are not allowed; convert at 1pt = 1.3333px and write px (or rem inside a fluid clamp())." }
  }
  if ($t.Name -like 'font-size-*' -and -not $t.Fluid -and -not $t.Responsive -and ([string]$t.Raw) -notmatch '^\{') {
    if (([string]$t.Raw) -notmatch '^\d+(\.\d+)?px$') { throw "Font-size token --$($t.Name) (path $($t.Path)) in Tokens/$($t.File.json).json is '$($t.Raw)'. A static font size must be written in px (for example 16px); only fluid sizes use clamp(Xrem, Yrem + Zvw, Wrem)." }
  }
}
# Scale rules. Font sizes: whole, even px on every tier (no 13px, no 17.5px). Spacing (space-*): on the 4px grid.
foreach ($t in $script:tokens) {
  $vals = if ($t.Responsive) { @($t.Raw.mobile, $t.Raw.tablet, $t.Raw.desktop) } else { @([string]$t.Raw) }
  foreach ($v in $vals) {
    if ($v -match '^\{') { continue }
    if ($t.Name -like 'font-size-*' -and $v -match '^(\d+(\.\d+)?)px$') {
      $n = [double]::Parse($Matches[1], $inv)
      if ($n -ne [math]::Floor($n) -or ($n % 2) -ne 0) { throw "Font-size token --$($t.Name) in Tokens/$($t.File.json).json is $v. Font sizes must be whole, even px values (for example 12px, 14px, 16px, 18px, 20px, 24px)." }
    }
    if ($t.Name -like 'space-*' -and $v -match '^(\d+(\.\d+)?)(px|rem)$') {
      $px = [double]::Parse($Matches[1], $inv) * $(if ($Matches[3] -eq 'rem') { 16 } else { 1 })
      if (($px % 4) -ne 0) { throw "Spacing token --$($t.Name) in Tokens/$($t.File.json).json is $v ($px px). Spacing must sit on the 4px grid." }
    }
  }
}
# Alias graph: cycle detection (a cycle would make the CSS invalid and recurse forever below)
function AliasTargets($t) {
  $vals = if ($t.Responsive) { @($t.Raw.mobile, $t.Raw.tablet, $t.Raw.desktop) } else { @($t.Raw) }
  $set = @{}
  foreach ($v in $vals) { foreach ($mm in [regex]::Matches($v, $aliasRx)) { $set[$mm.Groups[1].Value.Replace('.', '-')] = 1 } }
  @($set.Keys)
}
$script:state = @{}
function Visit([string]$n, [string[]]$trail) {
  if ($script:state[$n] -eq 2) { return }
  if ($script:state[$n] -eq 1) { throw "Alias cycle: $(($trail + $n) -join ' -> ')" }
  $script:state[$n] = 1
  foreach ($x in (AliasTargets $script:byName[$n])) { if ($script:byName.ContainsKey($x)) { Visit $x ($trail + $n) } }
  $script:state[$n] = 2
}
foreach ($n in @($script:byName.Keys)) { Visit $n @() }

# ---------- 3. Emit CSS ------------------------------------------------------
$bp = @{
  tablet  = [string]$script:byName['breakpoint-tablet'].Raw
  desktop = [string]$script:byName['breakpoint-desktop'].Raw
}
$nl = "`n"
$banner = "/* GENERATED by 02-Design-Variables/Tokens/build-tokens.ps1 from Tokens/*.json. DO NOT EDIT BY HAND. */$nl"
function Block($list, $tier) {
  $sb = New-Object Text.StringBuilder
  $last = ''
  foreach ($t in $list) {
    $top = $t.Path.Split('.')[0]
    if ($tier -eq 'mobile' -and $top -ne $last) { [void]$sb.Append("$nl  /* $top */$nl"); $last = $top }
    $v = if ($t.Responsive) { $t.Raw[$tier] } else { $t.Raw }
    [void]$sb.Append("  --$($t.Name): $(Resolve $v "--$($t.Name)");$nl")
  }
  $sb.ToString()
}
$all = New-Object Text.StringBuilder
[void]$all.Append($banner)
[void]$all.Append("/* NUDGE design variables: one file, mobile-first.$nl   Tiers: base (mobile) | min-width $($bp.tablet) (tablet) | min-width $($bp.desktop) (desktop). */$nl")
foreach ($f in $files) {
  $mine = @($script:tokens | Where-Object { $_.File.json -eq $f.json })
  $sb = New-Object Text.StringBuilder
  [void]$sb.Append($banner)
  [void]$sb.Append("/* $($f.title): $($f.note) */${nl}:root {")
  [void]$sb.Append((Block $mine 'mobile'))
  [void]$sb.Append("}$nl")
  foreach ($tier in 'tablet','desktop') {
    $prev = if ($tier -eq 'tablet') { 'mobile' } else { 'tablet' }
    $ch = @($mine | Where-Object { $_.Responsive -and ((Resolve $_.Raw[$tier] $_.Name) -ne (Resolve $_.Raw[$prev] $_.Name)) })
    if ($ch.Count) {
      [void]$sb.Append("$nl@media (min-width: $($bp[$tier])) {$nl  :root {$nl")
      foreach ($t in $ch) { [void]$sb.Append("    --$($t.Name): $(Resolve $t.Raw[$tier] $t.Name);$nl") }
      [void]$sb.Append("  }$nl}$nl")
    }
  }
  # aggregate into the single output file (strip the per-section banner)
  [void]$all.Append($nl + $sb.ToString().Substring($banner.Length))
}
# ---- Scopes (semantic.json "$scopes"), e.g. .surface-inverse -----------------------------
# A custom-property alias resolves where it is DECLARED, so re-mapping --color-focus-ring inside a scope does
# NOT update --focus-ring (declared at :root as var(--color-focus-ring)). To make scopes correct, every token
# that transitively aliases an overridden token is re-declared inside the scope automatically.
$script:scopeDocs = @()
$semJson = Get-Content (Join-Path $tokDir 'semantic.json') -Raw | ConvertFrom-Json
$scopeProp = $semJson.PSObject.Properties | Where-Object { $_.Name -eq '$scopes' }
if ($scopeProp) {
  foreach ($sc in $scopeProp.Value.PSObject.Properties) {
    $sel = $sc.Name; $explicit = @{}; $lines = New-Object System.Collections.ArrayList
    foreach ($d in $sc.Value.PSObject.Properties) {
      if ($d.Name.StartsWith('--')) {
        $tn = $d.Name.Substring(2)
        if (-not $script:byName.ContainsKey($tn)) { throw "Scope $sel overrides unknown token $($d.Name)" }
        $explicit[$tn] = 1
      }
      [void]$lines.Add("  $($d.Name): $(Resolve ([string]$d.Value) "scope $sel $($d.Name)");")
    }
    $set = @{}; foreach ($k in $explicit.Keys) { $set[$k] = 1 }
    $auto = New-Object System.Collections.ArrayList
    do {
      $changed = $false
      foreach ($t in $script:tokens) {
        if ($set.ContainsKey($t.Name)) { continue }
        if (@(AliasTargets $t | Where-Object { $set.ContainsKey($_) }).Count) {
          if ($t.Responsive) { throw "Scope ${sel}: responsive token --$($t.Name) depends on an overridden token and cannot be pinned to one tier" }
          $set[$t.Name] = 1; [void]$auto.Add($t); $changed = $true
        }
      }
    } while ($changed)
    [void]$all.Append("$nl/* Scope $sel : re-maps semantic tokens for a surface. The tokens listed after the comment are re-declared`n   because they alias an overridden token (aliases resolve where they are declared). Generated; do not edit. */$nl$sel {$nl")
    foreach ($l in $lines) { [void]$all.Append("$l$nl") }
    [void]$all.Append("  /* dependents */$nl")
    foreach ($t in $auto) { [void]$all.Append("  --$($t.Name): $(Resolve ([string]$t.Raw) "scope $sel --$($t.Name)");$nl") }
    [void]$all.Append("}$nl")
    $script:scopeDocs += [pscustomobject]@{ Selector = $sel; Overrides = @($lines | ForEach-Object { $_.Trim() }); Dependents = @($auto | ForEach-Object { "--$($_.Name)" }) }
  }
}
[IO.File]::WriteAllText((Join-Path $cssDir 'variables.css'), $all.ToString(), $utf8)

# ---------- 4. Docs: matrix + reference -------------------------------------
function Px([string]$lit) {
  if ($lit -match '^(-?[\d.]+)rem$') { $px = [double]::Parse($Matches[1], $inv) * 16; return ('{0}px' -f ([math]::Round($px, 2)).ToString($inv)) }
  if ($lit -match '^(-?[\d.]+)px$') { return $lit }
  ''
}
function Lit([string]$s) {
  if ($s -match '^\{([A-Za-z0-9._-]+)\}$') {
    $t = $script:byName[$Matches[1].Replace('.', '-')]
    $r = if ($t.Responsive) { $t.Raw['mobile'] } else { $t.Raw }
    return (Lit $r)
  }
  $s
}
function Code([string]$s) { [string][char]96 + $s + [char]96 }
function Esc([string]$s) { $s.Replace('|', '\|') }
function Disp([string]$raw) {
  $lit = Lit $raw
  $px = Px $lit
  if ($raw -match '^\{([A-Za-z0-9._-]+)\}$') {
    $a = Code $Matches[1]
    if ($px) { return "$a ($px)" } else { return "$a ($lit)" }
  }
  if ($px -and $raw -like '*rem') { return "$raw ($px)" }
  Code $raw
}
$m = New-Object Text.StringBuilder
[void]$m.Append("<!-- GENERATED by Tokens/build-tokens.ps1 from Tokens/*.json. DO NOT EDIT BY HAND. -->$nl")
[void]$m.Append("# Responsive token matrix$nl$nl")
[void]$m.Append("Responsive behavior in this system uses **three deliberate mechanisms**; everything else is static.$nl$nl| Mechanism | Used for | Why |$nl|---|---|---|$nl| **Fluid** (``clamp()``) | The 9 scaled type sizes; section spacing | Continuous growth between phone and wide desktop, no media-query overrides, proportions preserved. Spacing is fluid only for section rhythm; type below 16px is never fluid; body, label and input text are fixed |$nl| **Tier** (3 media-query steps) | Gutter, grid gap, product columns, header height, drawer width, card padding | Only values that must change together with a layout change at a breakpoint; each has a stated reason |$nl| **Static** | Colors, the spacing scale, radii, shadows, touch target, body and input text, most component sizes | Nothing gained by changing them per viewport |$nl$nl")
[void]$m.Append("## Tier tokens$nl$nl")
[void]$m.Append("Every token whose value changes by tier. Mobile-first: the **mobile** value is the base; tablet and desktop override it with ``min-width`` media queries.$nl$nl")
$tabletPx = Px $bp.tablet
$desktopPx = Px $bp.desktop
$mobileMax = ([double]($tabletPx -replace 'px','') - 1).ToString($inv)
$tabletMax = ([double]($desktopPx -replace 'px','') - 1).ToString($inv)
$tq = Code ("@media (min-width: " + $bp.tablet + ")")
$dq = Code ("@media (min-width: " + $bp.desktop + ")")
[void]$m.Append("| Tier | Applies | Media query |$nl|---|---|---|$nl")
[void]$m.Append("| Mobile | 0 - ${mobileMax}px (base) | none |$nl")
[void]$m.Append("| Tablet | $tabletPx - ${tabletMax}px | $tq |$nl")
[void]$m.Append("| Desktop | $desktopPx and up | $dq |$nl$nl")
[void]$m.Append("Alias values show the token they point to and the resolved size. 1rem = 16px. Cells marked with the same value across tiers are explicit by design (so the intent is documented), but only genuine changes are emitted as overrides in the CSS.$nl$nl")
$resp = @($script:tokens | Where-Object { $_.Responsive })
$fluidTokens = @($script:tokens | Where-Object { $_.Fluid })
$static = @($script:tokens | Where-Object { -not $_.Responsive -and -not $_.Fluid })
[void]$m.Append("**$($resp.Count) tier tokens**, **$($fluidTokens.Count) fluid tokens** and **$($static.Count) static tokens** (see [Documentation/token-reference.md](Documentation/token-reference.md)).$nl")
foreach ($f in $files) {
  $mine = @($resp | Where-Object { $_.File.json -eq $f.json })
  if (-not $mine.Count) { continue }
  [void]$m.Append("$nl## $($f.title) ($($f.json).json)$nl$nl| Token | Mobile (base) | Tablet | Desktop | Notes |$nl|---|---|---|---|---|$nl")
  foreach ($t in $mine) {
    $chg = if ($t.Raw.mobile -eq $t.Raw.tablet -and $t.Raw.tablet -eq $t.Raw.desktop) { ' (no change)' } else { '' }
    [void]$m.Append("| ``--$($t.Name)`` | $(Esc (Disp $t.Raw.mobile)) | $(Esc (Disp $t.Raw.tablet)) | $(Esc (Disp $t.Raw.desktop)) | $(Esc $t.Desc)$chg |$nl")
  }
}
$fw = 360, 600, 768, 1024, 1280, 1440, 1920
[void]$m.Append("$nl## Fluid tokens (``clamp()``)$nl$nl")
[void]$m.Append("Each value grows linearly with the viewport between two widths and is held at its minimum below and its maximum above. Pixel sizes are computed from the actual expression at 1rem = 16px.$nl$nl")
[void]$m.Append("| Token | Min | Max | Fluid between | " + (($fw | ForEach-Object { "$($_)px" }) -join " | ") + " | Notes |$nl|---|---|---|---|" + (($fw | ForEach-Object { "---" }) -join "|") + "|---|$nl")
foreach ($t in $fluidTokens) {
  $f = FluidParts $t.Raw
  $w0 = [math]::Round(($f.Min - $f.A) * 100 / $f.B); $w1 = [math]::Round(($f.Max - $f.A) * 100 / $f.B)
  $cells = ($fw | ForEach-Object { "$(FluidPx $t.Raw $_)" }) -join " | "
  [void]$m.Append("| ``--$($t.Name)`` | $($f.Min)px | $($f.Max)px | ${w0}px to ${w1}px | $cells | $(Esc $t.Desc) |$nl")
}
[void]$m.Append("$nl## Behavior that changes by tier (not expressible as a token)$nl$nl")
[void]$m.Append("These are documented rules, implemented by components/templates in later phases, using the tokens above.$nl$nl")
[void]$m.Append("| Topic | Mobile | Tablet | Desktop |$nl|---|---|---|---|$nl")
[void]$m.Append("| Navigation | Icon buttons + drawer menu | Icon buttons + drawer menu | Inline links |$nl")
[void]$m.Append("| Primary button width | Full width (``.btn--block-mobile``) | Natural width | Natural width |$nl")
[void]$m.Append("| Forms | Single column | Two columns where fields pair naturally | Two columns, ``--container-narrow`` cap |$nl")
[void]$m.Append("| Product gallery | Swipeable carousel, full-bleed | Carousel + thumbnails | Thumbnails + large image, split with details |$nl")
[void]$m.Append("| Filters | Drawer | Drawer | Sidebar |$nl")
[void]$m.Append("| Filter drawer presentation | Full-width sheet (`--layout-drawer-width: 100%`) | 26rem side panel | 26rem side panel (a sidebar is a later page-layout decision) |$nl")
[void]$m.Append("| Collection paging | **Load more** (provisional: nothing verified against Shopify) | Numbered pagination | Numbered pagination |$nl")
[void]$m.Append("| Breadcrumb | One line: parent and current page (current truncates) | Full trail, wraps | Full trail, wraps |$nl")
[void]$m.Append("| Filter chip row (choices) | One horizontally scrolling line | Wraps | Wraps (applied filters wrap at every size) |$nl")
[void]$m.Append("| Product card quick-add | Always visible | Always visible | Always visible; hover adds image zoom only |$nl")
[void]$m.Append("| Touch targets | >= 44px | >= 44px | >= 44px (the small button and chip keep a 40px visual and a 44px hit area) |$nl")
[void]$m.Append("| Body text | 16px | 16px | 16px (never smaller) |$nl")
[IO.File]::WriteAllText((Join-Path $dv 'responsive-token-matrix.md'), $m.ToString(), $utf8)

$r = New-Object Text.StringBuilder
[void]$r.Append("<!-- GENERATED by Tokens/build-tokens.ps1 from Tokens/*.json. DO NOT EDIT BY HAND. -->$nl# Token reference$nl$nl")
[void]$r.Append("$($script:tokens.Count) tokens. CSS name = ``--`` + path joined by ``-``. **R** = tier token (values per tier in [../responsive-token-matrix.md](../responsive-token-matrix.md); the value shown is the mobile base). **F** = fluid (``clamp()``; pixel sizes in the same file).$nl")
foreach ($f in $files) {
  $mine = @($script:tokens | Where-Object { $_.File.json -eq $f.json })
  [void]$r.Append("$nl## $($f.title) ``Tokens/$($f.json).json``$nl$nl| Token | Value | | Description |$nl|---|---|---|---|$nl")
  foreach ($t in $mine) {
    $v = if ($t.Responsive) { $t.Raw.mobile } else { $t.Raw }
    $flag = if ($t.Responsive) { 'R' } elseif ($t.Fluid) { 'F' } else { '' }
    [void]$r.Append("| ``--$($t.Name)`` | $(Esc (Code $v)) | $flag | $(Esc $t.Desc) |$nl")
  }
}
foreach ($sd in $script:scopeDocs) {
  $deps = ($sd.Dependents | ForEach-Object { Code $_ }) -join ', '
  $head = "$nl## Scope " + (Code $sd.Selector) + ' (from ' + (Code 'semantic.json') + ' ' + (Code '$scopes') + ")$nl$nl"
  [void]$r.Append($head)
  [void]$r.Append("Apply the class to any element to re-map the semantic tokens below for everything inside it. Tokens that alias an overridden token are re-declared automatically (listed under Re-declared), because custom-property aliases resolve where they are declared. Form controls get a transparent background, light text and a light border; test them on the real surface.$nl$nl**Overrides**$nl$nl")
  foreach ($o in $sd.Overrides) { [void]$r.Append('- ' + (Code ($o.TrimEnd(';'))) + $nl) }
  [void]$r.Append("$nl**Re-declared (generated):** $deps$nl")
}
[IO.File]::WriteAllText((Join-Path $docDir 'token-reference.md'), $r.ToString(), $utf8)

# ---------- 4b. Design System consumption check (read-only) ------------------
# Design Variables is the only token source. The Design System must LINK the generated CSS, not define tokens.
$dsRoot = Join-Path $proj '01-Design-System'
$dsProblems = New-Object System.Collections.ArrayList
$dsRefs = @{}; $dsFound = Test-Path $dsRoot; $dsAliasUse = 0; $dsCanonUsed = 0
if ($dsFound) {
  $cssFiles = @(Get-ChildItem (Join-Path $dsRoot 'Styles') -Filter *.css -ErrorAction SilentlyContinue)
  $jsFiles = @(Get-ChildItem (Join-Path $dsRoot 'Scripts') -Filter *.js -ErrorAction SilentlyContinue)
  $htmlFiles = @(Get-Item (Join-Path $dsRoot 'index.html') -ErrorAction SilentlyContinue)
  $codeFiles = @($cssFiles) + @($jsFiles) + @($htmlFiles)
  $declRx = '(?<![\w-])--([a-z0-9-]+)\s*:'
  $aliasDecl = @{}
  foreach ($cf in ($cssFiles | Where-Object { $_.Name -eq 'foundation.css' })) {
    foreach ($mm in [regex]::Matches([IO.File]::ReadAllText($cf.FullName), '(?m)^\s*--([a-z0-9-]+)\s*:\s*([^;]+);')) { $aliasDecl[$mm.Groups[1].Value] = $mm.Groups[2].Value.Trim() }
  }
  foreach ($a in $aliasDecl.Keys) {
    if ($script:byName.ContainsKey($a)) { [void]$dsProblems.Add("foundation.css re-declares canonical token --$a (compatibility aliases must use deprecated names only)") }
    elseif ($aliasDecl[$a] -notmatch '^var\(--([a-z0-9-]+)\)$' -or -not $script:byName.ContainsKey($Matches[1])) { [void]$dsProblems.Add("foundation.css alias --$a must be exactly var(--<canonical token>); got: $($aliasDecl[$a])") }
  }
  $hooks = @{}
  foreach ($cf in $codeFiles) {
    if ($cf.Name -eq 'foundation.css') { continue }
    $txt = [IO.File]::ReadAllText($cf.FullName)
    foreach ($mm in [regex]::Matches($txt, $declRx)) {
      $nme = $mm.Groups[1].Value
      if ($script:byName.ContainsKey($nme)) { [void]$dsProblems.Add("$($cf.Name) re-declares canonical token --$nme (edit 02-Design-Variables/Tokens instead)") }
      elseif ($aliasDecl.ContainsKey($nme)) { [void]$dsProblems.Add("$($cf.Name) re-declares deprecated alias --$nme") }
      else { $hooks[$nme] = 1 }
    }
  }
  foreach ($cf in $codeFiles) {
    if ($cf.Name -eq 'foundation.css') { continue }
    $txt = [IO.File]::ReadAllText($cf.FullName)
    foreach ($mm in [regex]::Matches($txt, 'var\(\s*--([a-z0-9-]+)\s*(,)?')) {
      $nme = $mm.Groups[1].Value; $hasFallback = $mm.Groups[2].Success
      if ($script:byName.ContainsKey($nme)) { $dsRefs[$nme] = 1 + [int]$dsRefs[$nme] }
      elseif ($aliasDecl.ContainsKey($nme)) { $dsAliasUse++; [void]$dsProblems.Add("$($cf.Name) still uses deprecated alias --$nme (use --$($aliasDecl[$nme] -replace '^var\(--|\)$',''))") }
      elseif (-not $hooks.ContainsKey($nme) -and -not $hasFallback) { [void]$dsProblems.Add("$($cf.Name) uses var(--$nme) which is not a token, alias or local hook, and has no fallback") }
    }
  }
  $dsCanonUsed = $dsRefs.Count
}

# ---------- 4c. Dashboard data (inlined so the preview works from file://) ---
$previewHtml = Join-Path $dv 'Preview\index.html'
# Static usage: aliases by other tokens, literal var(--x) uses in the dashboard source, and in the Design System.
# (References built at runtime, e.g. var(--type-' + role + '), are NOT visible to this scan.)
$aliasRefs = @{}
foreach ($t in $script:tokens) { foreach ($x in (AliasTargets $t)) { $aliasRefs[$x] = 1 + [int]$aliasRefs[$x] } }
# generated scopes (e.g. .surface-inverse) also reference tokens
foreach ($sd in $script:scopeDocs) { foreach ($o in $sd.Overrides) { foreach ($mm in [regex]::Matches($o, 'var\(--([a-z0-9-]+)\)')) { $aliasRefs[$mm.Groups[1].Value] = 1 + [int]$aliasRefs[$mm.Groups[1].Value] } } }
$pvText = ''
foreach ($pf in 'Preview\preview.css', 'Preview\preview.js') { $pp = Join-Path $dv $pf; if (Test-Path $pp) { $pvText += [IO.File]::ReadAllText($pp) + "`n" } }
if (Test-Path $previewHtml) { $pvText += [regex]::Replace([IO.File]::ReadAllText($previewHtml), '(?s)<!-- TOKEN-DATA:START -->.*?<!-- TOKEN-DATA:END -->', '') }
$pvRefs = @{}
foreach ($mm in [regex]::Matches($pvText, 'var\(--([a-z0-9-]+)[,)]')) { $pvRefs[$mm.Groups[1].Value] = 1 + [int]$pvRefs[$mm.Groups[1].Value] }
$data = [ordered]@{
  files = @($files | ForEach-Object { [ordered]@{ id = $_.json; title = $_.title } })
  tokens = @($script:tokens | ForEach-Object {
    $t = $_
    $tiers = if ($t.Responsive) { @($t.Raw.mobile, $t.Raw.tablet, $t.Raw.desktop) } else { @($t.Raw, $t.Raw, $t.Raw) }
    $fp = if ($t.Fluid) { @((FluidPx $t.Raw 360), (FluidPx $t.Raw 768), (FluidPx $t.Raw 1280)) } else { @() }
    [ordered]@{
      n = $t.Name; f = $t.File.json; p = $t.Path; d = $t.Desc; r = [bool]$t.Responsive; fl = [bool]$t.Fluid; fp = @($fp)
      ar = [int]$aliasRefs[$t.Name]; ur = [int]$pvRefs[$t.Name]; dr = [int]$dsRefs[$t.Name]
      raw = @($tiers)
      v = @($tiers | ForEach-Object { Resolve $_ "--$($t.Name)" })
    }
  })
}
$dataJson = ($data | ConvertTo-Json -Depth 6 -Compress)
if (Test-Path $previewHtml) {
  $h = [IO.File]::ReadAllText($previewHtml)
  $block = "<!-- TOKEN-DATA:START -->${nl}<script id=`"token-data`" type=`"application/json`">$dataJson</script>${nl}<!-- TOKEN-DATA:END -->"
  $h = [regex]::Replace($h, '(?s)<!-- TOKEN-DATA:START -->.*?<!-- TOKEN-DATA:END -->', { param($mm) $block })
  [IO.File]::WriteAllText($previewHtml, $h, $utf8)
} else { Write-Host 'Preview/index.html not found; dashboard data not injected.' }

# ---------- 5. Report ---------------------------------------------------------
$unref = @($script:tokens | Where-Object { -not $aliasRefs[$_.Name] -and -not $pvRefs[$_.Name] -and -not $dsRefs[$_.Name] })
Write-Host "Built $($script:tokens.Count) tokens ($($resp.Count) tier, $($fluidTokens.Count) fluid, $($static.Count) static) -> Styles/variables.css, responsive-token-matrix.md, Documentation/token-reference.md, dashboard data"
$code = 0
if ($dsFound) {
  Write-Host "Design System consumption: $dsCanonUsed canonical tokens used by 01-Design-System/ code; $(@($aliasDecl.Keys).Count) deprecated compatibility aliases defined, $dsAliasUse used by DS code; $($dsProblems.Count) problems."
  if ($dsProblems.Count) { $dsProblems | Select-Object -First 25 | ForEach-Object { Write-Host "  $_" }; if ($dsProblems.Count -gt 25) { Write-Host "  ... and $($dsProblems.Count - 25) more" }; $code = 5 }
} elseif ($AllowMissingDesignSystem) { Write-Host 'WARNING: 01-Design-System/ not found; the consumption check was SKIPPED (-AllowMissingDesignSystem).' }
else { Write-Host 'FAIL: 01-Design-System/ not found, so the Design System consumption check cannot run. Pass -AllowMissingDesignSystem to skip it deliberately.'; $code = 4 }
Write-Host "Static usage: $($unref.Count) of $($script:tokens.Count) tokens have no alias, dashboard or Design System reference (scale/API tokens and runtime-built references are expected; informational only)."
exit $code