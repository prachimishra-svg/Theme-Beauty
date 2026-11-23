# Helpers for writing component manifests consistently (dot-source this file).
#   P  builds one property;  Write-Component writes <dir>/<id>.html and <id>.json (folder component) from a template string and a manifest.
# Every property carries scope (design | parent | merchant | wireframe) and a shopify block (param, optional id, setting, valueMap).
$script:utf8 = New-Object Text.UTF8Encoding($false)
function Snake([string]$s) { ([regex]::Replace($s, '(?<=[a-z0-9])([A-Z])', '_$1')).ToLower() }
function P {
  param([string]$name, [string]$type, $default = $null, [string]$scope = 'parent', [string]$setting = '', [string]$note = '', [string]$id = '',
    $values = $null, $tables = $null, $options = $null, $itemFields = $null, [string]$data = '', [switch]$pending, [string]$review = '', $valueMap = $null, [string]$blockType = '', [int]$maxBlocks = 0)
  $o = [ordered]@{ name = $name; type = $type }
  if ($type -eq 'BOOLEAN') { $o['default'] = [bool]$default } elseif ($null -ne $default) { $o['default'] = $default }
  if ($null -ne $values) { $o['values'] = @($values) }
  if ($null -ne $tables) { $tb = [ordered]@{}; foreach ($key in $tables.Keys) { if ($key -eq 'class') { $o['classes'] = $tables[$key] } else { $tb[$key] = $tables[$key] } }; if ($tb.Count) { $o['tables'] = $tb } }
  if ($null -ne $options) { $o['options'] = @($options) }
  if ($null -ne $itemFields) { $o['itemFields'] = @($itemFields) }
  $o['scope'] = $scope
  $sh = [ordered]@{ param = (Snake $name) }; if ($id) { $sh['id'] = $id }; if ($setting) { $sh['setting'] = $setting }; if ($valueMap) { $sh['valueMap'] = $valueMap }; if ($blockType) { $sh['blockType'] = $blockType }; if ($maxBlocks) { $sh['maxBlocks'] = $maxBlocks }
  $o['shopify'] = $sh
  if ($data) { $o['data'] = $data }; if ($pending) { $o['pending'] = $true }; if ($review) { $o['review'] = $review }
  if ($note) { $o['note'] = $note }
  $o
}
function Write-Component {
  param([string]$root, [string]$id, [string]$template, [hashtable]$manifest, [string]$group)
  $dir = Join-Path $root "components\$group\$id"; New-Item -ItemType Directory -Force $dir | Out-Null
  [IO.File]::WriteAllText("$dir\$id.html", $template, $script:utf8)
  $flat = Join-Path $root "components\$group\$id.html"; if (Test-Path $flat) { Remove-Item $flat }
  [IO.File]::WriteAllText("$dir\$id.json", ($manifest | ConvertTo-Json -Depth 20), $script:utf8)
}
function NewManifest {
  param([string]$id, [string]$name, [string]$level, [string]$summary, $properties, $children = @(), $exposes = $null, $wireframeOnly = $null, $shopifyOnly = $null, [string]$accessibility = '', [string]$responsive = '', $tokens = @(), [string]$status = 'classified', [string]$page = 'homepage')
  $m = [ordered]@{ id = $id; name = $name; level = $level; page = $page; status = $status; summary = $summary; properties = @($properties); children = @($children) }
  if ($level -eq 'main') { $m['exposes'] = @($exposes) }
  if ($wireframeOnly) { $m['wireframeOnly'] = @($wireframeOnly) }
  if ($shopifyOnly) { $m['shopifyOnly'] = @($shopifyOnly) }
  if ($accessibility) { $m['accessibility'] = $accessibility }; if ($responsive) { $m['responsive'] = $responsive }; $m['tokens'] = @($tokens)
  $m
}
function Ex([string]$child, [string]$property, [string]$via) { [ordered]@{ child = $child; property = $property; via = $via } }
