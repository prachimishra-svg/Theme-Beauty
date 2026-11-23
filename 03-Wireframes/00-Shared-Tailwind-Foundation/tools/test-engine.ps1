# Unit test for the wireframe component engine in build.ps1 (Component/Expand/Args2/Slug/Unesc), using a throw-away component folder.
$root = Split-Path -Parent $PSScriptRoot
$ast = [System.Management.Automation.Language.Parser]::ParseFile((Join-Path $root 'build.ps1'), [ref]$null, [ref]$null)
$want = 'P', 'Slug', 'Unesc', 'Args2', 'Component', 'Expand', 'Links', 'Header', 'CompRel', 'ManifestFor', 'Truthy', 'PathGet', 'TplTokens', 'TplRender'
$ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $want -contains $n.Name }, $true) | ForEach-Object { . ([scriptblock]::Create($_.Extent.Text)) }
$utf8 = New-Object Text.UTF8Encoding($false); $foundation = 'test'; $pages = @{}; $script:manCache = @{}
$tmp = Join-Path ([IO.Path]::GetTempPath()) ('engine-test-' + [guid]::NewGuid().ToString('N')); $root = $tmp
New-Item -ItemType Directory -Force "$tmp\partials\components\t" | Out-Null
function W($n, $t) { [IO.File]::WriteAllText("$tmp\partials\components\t\$n.html", $t, $utf8) }
W 'echo' '<p data-x="{{a}}">{{a}}</p><ul>{{each l}}<li><a href="{{href}}">{{item}}</a></li>{{/each}}</ul>{{if on}}[on]{{/if}}[{{slug:a}}][{{lower:a}}]'
W 'outer' '<div>@@PARTIAL components/t/echo a="{{x}}" l="{{y}}"@@</div>'
$fail = 0
function Check($name, $got, $want) { if ($got -ceq $want) { "pass  $name" } else { $script:fail++; "FAIL  $name`n   got : $got`n   want: $want" } }
Check 'plain' (Expand '@@PARTIAL components/t/echo a=Hello l="x::#1|y::#2" on=1@@') '<p data-x="Hello">Hello</p><ul><li><a href="#1">x</a></li><li><a href="#2">y</a></li></ul>[on][hello][hello]'
Check 'conditional off' (Expand '@@PARTIAL components/t/echo a=Hi l="x" on=0@@') '<p data-x="Hi">Hi</p><ul><li><a href="">x</a></li></ul>[hi][hi]'
Check 'escaped quote, at, pipe' (Expand '@@PARTIAL components/t/echo a="Say &quot;hi&quot; &#64; 5 &#124; 6" l="a &#124; b::#p&#124;q|c" on=0@@') '<p data-x="Say "hi" @ 5 | 6">Say "hi" @ 5 | 6</p><ul><li><a href="#p|q">a | b</a></li><li><a href="">c</a></li></ul>[say-hi-5-6][say "hi" @ 5 | 6]'
Check 'nested' (Expand '@@PARTIAL components/t/outer x=Z y="p|q"@@') '<div><p data-x="Z">Z</p><ul><li><a href="">p</a></li><li><a href="">q</a></li></ul>[z][z]</div>'
$thrown = $false; try { Expand '@@PARTIAL components/t/echo l=x@@' | Out-Null } catch { $thrown = $true }
Check 'missing argument fails' $thrown $true
# ---- engine v2 features ----
New-Item -ItemType Directory -Force "$tmp\partials\components\t\box" | Out-Null
W 'nest' '{{if a}}[{{if b}}B{{/if}}{{if c=x}}C{{/if}}]{{/if}}<{{each l}}{{item}}{{if first}}!{{/if}}{{/each}}>'
Check 'nested if, if x=value, loop flags' (Expand '@@PARTIAL components/t/nest a=1 b=1 c=x l="p|q"@@') '[BC]<p!q>'
Check 'nested if with inner off' (Expand '@@PARTIAL components/t/nest a=1 b=0 c=y l="z"@@') '[]<z!>'
Check 'outer if off hides the inner block' (Expand '@@PARTIAL components/t/nest a=0 b=1 c=x l="z"@@') '<z!>'
[IO.File]::WriteAllText("$tmp\partials\components\t\box\box.html", '<div class="{{variant.class}}{{if wide}} w-full{{/if}}">{{label}}{{each items}}<i>{{index}}:{{item.title}}/{{item.sub}}</i>{{/each}}</div>', $utf8)
$man = '{"id":"box","properties":[{"name":"variant","type":"VARIANT","values":["a","b"],"default":"a","classes":{"a":"cls-a","b":"cls-b"}},{"name":"label","type":"TEXT","default":"Hello"},{"name":"wide","type":"BOOLEAN","default":false},{"name":"items","type":"LIST","default":[{"title":"one","sub":"x"},{"title":"two","sub":"y"}]}]}'
[IO.File]::WriteAllText("$tmp\partials\components\t\box\box.json", $man, $utf8)
Check 'folder component, manifest defaults, object list' (Expand '@@PARTIAL components/t/box@@') '<div class="cls-a">Hello<i>1:one/x</i><i>2:two/y</i></div>'
Check 'named variant and boolean override' (Expand '@@PARTIAL components/t/box variant=b wide=1 label=Hi@@') '<div class="cls-b w-full">Hi<i>1:one/x</i><i>2:two/y</i></div>'
$thrown2 = $false; try { Expand '@@PARTIAL components/t/box variant=zzz@@' | Out-Null } catch { $thrown2 = $true }
[IO.File]::WriteAllText("$tmp\partials\components\t\tab.html", '<b class="{{v.class}}">{{v.ico}}</b>', $utf8)
[IO.File]::WriteAllText("$tmp\partials\components\t\tab.json", '{"properties":[{"name":"v","type":"VARIANT","default":"p","classes":{"p":"c-p","q":"c-q"},"tables":{"ico":{"p":"i-p","q":"i-q"}}}]}', $utf8)
Check 'named table beside class' (Expand '@@PARTIAL components/t/tab v=q@@') '<b class="c-q">i-q</b>'
Check 'unknown variant fails the build' $thrown2 $true
W 'argpass' '<i data-v="{{v}}">{{v}}</i>'
W 'argcall' '@@PARTIAL components/t/argpass v="{{arg:x}}"@@'
Check 'arg: keeps quotes, at and bar through a nested call' (Expand '@@PARTIAL components/t/argcall x="a &quot;b&quot; &#64; c &#124; d"@@') '<i data-v="a "b" @ c | d">a "b" @ c | d</i>'
W 'argplain' '@@PARTIAL components/t/argpass v="{{x}}"@@'
$thrown3 = $false; try { $r3 = Expand '@@PARTIAL components/t/argplain x="p &quot;q&quot; r"@@'; if ($r3 -ne '<i data-v="p "q" r">p "q" r</i>') { $thrown3 = $true } } catch { $thrown3 = $true }
Check 'without arg: a quoted value is mangled (why arg: exists)' $thrown3 $true
W 'negate' '[{{if !a}}no-a{{/if}}][{{if a}}a{{/if}}][{{if !b=x}}not-x{{/if}}]'
Check 'negated condition' (Expand '@@PARTIAL components/t/negate a=0 b=y@@') '[no-a][][not-x]'
Check 'negated condition, other branch' (Expand '@@PARTIAL components/t/negate a=1 b=x@@') '[][a][]'
Remove-Item -Recurse -Force $tmp
if ($fail) { "$fail FAILED"; exit 1 } else { 'engine tests: all passed' }