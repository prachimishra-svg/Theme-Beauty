# Drives the header currency dropdown on a wireframe and checks the prices.
# Usage: test-currency.ps1 -File <html> [-Width 1440] [-Mobile]
# -Mobile opens the menu drawer first (the selector lives in the drawer below 1024 px). Widths below 482 run in a 500 px window (headless minimum).
# Checks: the dropdown opens with four markets; choosing India (INR) leaves no "$" and shows the rupee sign; GBP and EUR show their own symbols and nothing else;
# choosing United States (USD) restores every price string exactly; the pill label follows the choice; the menu closes after a choice.
param([Parameter(Mandatory = $true)][string]$File, [int]$Width = 1440, [switch]$Mobile)
$f = (Resolve-Path $File).Path
$dir = Split-Path -Parent $f
$tmp = Join-Path ([IO.Path]::GetTempPath()) "nudge-tools"; New-Item -ItemType Directory -Force $tmp | Out-Null
$mob = if ($Mobile) { 'true' } else { 'false' }
$probe = "<script>var MOB=$mob;" + @'
window.addEventListener("load",function(){setTimeout(async function(){
 var $=function(id){return document.getElementById(id)},w=function(ms){return new Promise(function(r){setTimeout(r,ms)})},out={};
 var SY={IN:"\u20b9",GB:"\u00a3",EU:"\u20ac",US:"$"};
 function prices(){var t=document.createTreeWalker(document.body,NodeFilter.SHOW_TEXT),n,a=[];while((n=t.nextNode())){var e=n.parentElement;if(!e||e.closest(".rv,.ann,script,style,#dbg,#market-menu"))continue;if(/[$\u20b9\u00a3\u20ac]\s?\d/.test(n.nodeValue))a.push(n.nodeValue.trim())}return a}
 function count(a,ch){return a.filter(function(s){return s.indexOf(ch)>-1}).length}
 try{
  if(MOB){document.body.classList.add("nav-open");await w(80)}
  NudgeMarket.set("USD");await w(80);var S0=prices(),btn=$("market-btn"),menu=$("market-menu");out.base=S0.length;
  btn.click();await w(40);out.opens=!menu.hidden&&btn.getAttribute("aria-expanded")==="true"&&menu.querySelectorAll("[data-market]").length===4;
  function pick(code){menu.hidden&&btn.click();menu.querySelector('[data-market="'+code+'"]').click()}
  pick("IN");await w(80);var S1=prices();out.inr={dollar:count(S1,"$"),rupee:count(S1,SY.IN),n:S1.length,label:$("market-label").textContent,closed:menu.hidden};
  pick("GB");await w(80);var S2=prices();out.gbp={other:count(S2,"$")+count(S2,SY.IN)+count(S2,SY.EU),own:count(S2,SY.GB),label:$("market-label").textContent};
  pick("EU");await w(80);var S3=prices();out.eur={other:count(S3,"$")+count(S3,SY.IN)+count(S3,SY.GB),own:count(S3,SY.EU),label:$("market-label").textContent};
  pick("US");await w(80);var S4=prices();out.usd={label:$("market-label").textContent,restored:JSON.stringify(S0)===JSON.stringify(S4)};
  out.sample=[S0[0]||"",S1[0]||"",S2[0]||"",S3[0]||""].join("  |  ");
 }catch(e){out.error=String(e)}
 var pre=document.createElement("pre");pre.id="dbg";pre.textContent=JSON.stringify(out);document.body.appendChild(pre);
},2500)});
</script></body>
'@
$t = [IO.File]::ReadAllText($f, [Text.Encoding]::UTF8)
$base = '<base href="file:///' + (($dir -replace '\\', '/') -replace ' ', '%20') + '/">'
$copy = Join-Path $tmp ("cur-" + [guid]::NewGuid().ToString('N') + ".html")
[IO.File]::WriteAllText($copy, $t.Replace('<head>', '<head>' + $base).Replace('</body>', $probe), (New-Object Text.UTF8Encoding($false)))
$u = "file:///" + ($copy -replace '\\', '/') + "?embed=1&ann=0&cur=USD"
$out = Join-Path $tmp "cur.out"
Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList @("--headless=new", "--disable-gpu", "--hide-scrollbars", "--allow-file-access-from-files", "--window-size=$([Math]::Max($Width + 18,500)),1400", "--virtual-time-budget=12000", "--dump-dom", "`"$u`"") -RedirectStandardOutput $out -RedirectStandardError "$out.err" -Wait -NoNewWindow
$m = [regex]::Match([IO.File]::ReadAllText($out, [Text.Encoding]::UTF8), '<pre id="dbg">([\s\S]*?)</pre>').Groups[1].Value
Remove-Item $copy -Force
[System.Net.WebUtility]::HtmlDecode($m)
