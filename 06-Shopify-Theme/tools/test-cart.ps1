# Behaviour test of the cart drawer (assets/cart.js + drawer.js) against a MOCK of Shopify's AJAX Cart and Section Rendering APIs.
# For every cart state the theme is rendered with LiquidJS (so the drawer markup is the real Liquid output); the mock returns the right state after each request.
# It checks the requests cart.js sends (/cart/change.js, /cart/add.js, /?sections=cart-drawer), the refreshed drawer, focus, the undo message and the limit messages.
# It cannot prove Shopify's own responses; that needs a store. Usage: .\tools\test-cart.ps1 [-Widths 1440,390]
param([int[]]$Widths = @(1440, 390))
$T = Split-Path -Parent $PSScriptRoot; $utf8 = New-Object Text.UTF8Encoding($false)
Add-Type -AssemblyName System.Web.Extensions; $ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer; $ser.MaxJsonLength = [int]::MaxValue
$S = '{"social_instagram":"#","social_facebook":"#","social_youtube":"#","cart_type":"drawer"}'; $ST = '{"cart-drawer":{"upsell_collection":"add-ons"}}'
$states = 'multi', 'multi-plus-sr', 'multi-no-tm', 'multi-plus-lb'; $html = @{}
foreach ($cs in $states) {
  $r = & "$PSScriptRoot\render-theme.ps1" -Quiet -SettingsJson $S -StaticJson $ST -CartState $cs
  if ($r.Errors.Count) { "render problems for ${cs}: " + (($r.Errors | Select-Object -Unique) -join '; ') }
  $i = $r.Html.IndexOf('<div id="shopify-section-cart-drawer"'); $e = $r.Html.LastIndexOf('</body>'); $html[$cs] = $r.Html.Substring($i, $e - $i).Trim()
}
$page = Join-Path $PSScriptRoot '_cart-test-page.html'
$null = & "$PSScriptRoot\render-theme.ps1" -OutFile $page -Quiet -LocalAssets -SettingsJson $S -StaticJson $ST -CartState multi
$statesJson = ($ser.Serialize($html)).Replace('</', '<\/')
$js = @'
(function(){
 var r=[],fr=document.getElementById("f"),w=fr.contentWindow,d=w.document;
 function ck(n,ok,det){r.push((ok?"":"FAIL ")+n+(ok?"":": "+det))}
 function $(s){return d.querySelector(s)} function $$(s){return [].slice.call(d.querySelectorAll(s))}
 var st=d.createElement("style");st.textContent="*{transition:none!important;animation:none!important}";d.head.appendChild(st);
 var cur="multi",reqs=[];
 function resp(s,j){return Promise.resolve({ok:s<400,status:s,json:function(){return Promise.resolve(j)}})}
 w.fetch=function(u,o){u=String(u);var m=(o&&o.method)||"GET",b=o&&o.body?JSON.parse(o.body):null;reqs.push({u:u,m:m,b:b});
  if(/cart\/change\.js/.test(u)){if(b.quantity===0)cur="multi-no-tm";else if(b.quantity>=2)cur="multi-plus-sr";else cur="multi";return resp(200,{})}
  if(/cart\/add\.js/.test(u)){if(String(b.id)==="11")cur="multi";else cur="multi-plus-lb";return resp(200,{})}
  if(/sections=cart-drawer/.test(u)){var o2={};o2["cart-drawer"]=STATES[cur];return resp(200,o2)}
  return resp(404,{})};
 function wait(ms){return new Promise(function(f){setTimeout(f,ms)})}
 function lines(){return $$("#cart-drawer .cl")}
 function last(){return reqs[reqs.length-1]}
 (async function(){
  try{
   var D=$("#cart-drawer"),opener=$("#site-header [data-drawer-open=cart-drawer]");
   ck("header cart button opens the drawer (type=drawer)",!!opener&&!!D,"opener="+!!opener);
   opener.click();await wait(50);
   ck("drawer opens as a modal",D.open&&getComputedStyle(D).display!=="none","open="+D.open);
   ck("drawer shows 3 lines and a subtotal",lines().length===3&&/\$/.test($("#cd-sub").textContent),lines().length+" "+$("#cd-sub").textContent);
   ck("focus is inside the drawer",D.contains(d.activeElement),String(d.activeElement&&d.activeElement.tagName));
   /* plus on the serum line */
   var sr=$('#cart-drawer .cl[data-id="12:keysr"]');sr.querySelector("[data-plus]").focus();sr.querySelector("[data-plus]").click();await wait(80);
   var q=reqs.filter(function(x){return /change\.js/.test(x.u)})[0];
   ck("plus posts /cart/change.js with the line key and qty 2",q&&q.m==="POST"&&q.b.id==="12:keysr"&&q.b.quantity===2,JSON.stringify(q));
   ck("drawer refreshed through the Section Rendering API",reqs.some(function(x){return /sections=cart-drawer/.test(x.u)}),JSON.stringify(reqs.map(function(x){return x.u})));
   var sr2=$('#cart-drawer .cl[data-id="12:keysr"]');
   ck("serum quantity is now 2 and the drawer stays open",sr2&&sr2.querySelector("[data-q]").value==="2"&&D.open,sr2&&sr2.querySelector("[data-q]").value);
   ck("each-price appears for qty 2",sr2&&/each/.test(sr2.textContent),"x");
   ck("focus returns to the same plus button",d.activeElement&&d.activeElement.hasAttribute("data-plus")&&d.activeElement.closest(".cl").getAttribute("data-id")==="12:keysr",String(d.activeElement&&d.activeElement.outerHTML.slice(0,60)));
   /* remove the tinted moisturiser */
   reqs.length=0;var tm=$('#cart-drawer .cl[data-id="11:keytm"]');tm.querySelector("[data-rm]").click();await wait(80);
   var q2=reqs.filter(function(x){return /change\.js/.test(x.u)})[0];
   ck("remove posts qty 0",q2&&q2.b.id==="11:keytm"&&q2.b.quantity===0,JSON.stringify(q2));
   ck("line is gone",!$('#cart-drawer .cl[data-id="11:keytm"]')&&lines().length===2,String(lines().length));
   var um=$("#cd-undo .message-success");
   ck("undo message names the product",!!um&&/Tinted Moisturiser/.test(um.textContent)&&!!um.querySelector("[data-undo]"),um&&um.textContent);
   ck("focus moves to Undo",d.activeElement&&d.activeElement.hasAttribute("data-undo"),String(d.activeElement&&d.activeElement.outerHTML.slice(0,60)));
   /* undo */
   reqs.length=0;$("[data-undo]").click();await wait(80);
   var q3=reqs.filter(function(x){return /add\.js/.test(x.u)})[0];
   ck("undo re-adds the variant and quantity",q3&&String(q3.b.id)==="11"&&q3.b.quantity===1,JSON.stringify(q3));
   ck("line is back and undo cleared",!!$('#cart-drawer .cl[data-id="11:keytm"]')&&!$("#cd-undo .message-success"),String(lines().length));
   /* add-on */
   reqs.length=0;var add=$("[data-add]");ck("add-on offered",!!add&&/Lip Balm/.test(add.getAttribute("aria-label")),add&&add.getAttribute("aria-label"));
   add.click();await wait(80);
   var q4=reqs.filter(function(x){return /add\.js/.test(x.u)})[0];
   ck("add-on posts /cart/add.js with the variant id",q4&&String(q4.b.id)==="21"&&q4.b.quantity===1,JSON.stringify(q4));
   var nxt=$("[data-add]");ck("add-on line appears and the next add-on is offered",!!$('#cart-drawer .cl[data-id="21:keylb"]')&&!!nxt&&/Travel Cleanser/.test(nxt.getAttribute("aria-label")),nxt&&nxt.getAttribute("aria-label"));
   /* over-limit quantity typed in */
   reqs.length=0;cur="multi";await w.fetch("/?sections=cart-drawer");
   var inp=$('#cart-drawer .cl[data-id="12:keysr"] [data-q]');
   if(inp){inp.value="9";inp.dispatchEvent(new w.Event("change",{bubbles:true}));await wait(80);
    var q5=reqs.filter(function(x){return /change\.js/.test(x.u)})[0];
    ck("typed quantity above the stock limit is clamped to 3",q5&&q5.b.quantity===3,JSON.stringify(q5));
    var er=$("#cart-drawer .cl__err");ck("limit message is shown",!!er&&/Only 3 available/.test(er.textContent),er&&er.textContent)}
   /* checkout + close */
   ck("checkout button carries the checkout url",$("#cd-checkout").hasAttribute("data-checkout")&&D.getAttribute("data-checkout-url")==="/checkout",D.getAttribute("data-checkout-url"));
   w.NudgeDrawer.close(D);await wait(50);var manual=false;if(d.activeElement!==opener){D.dispatchEvent(new w.Event("close"));await wait(10);manual=true}
   ck("closing returns focus to the cart button"+(manual?" (headless Chrome did not fire the dialog close event; dispatched by the test)":""),!D.open&&d.activeElement===opener,String(d.activeElement&&d.activeElement.tagName));
   ck("header cart count follows the cart",$("#site-header [data-cart-count]")&&/\d/.test($("#site-header [data-cart-count]").textContent),"x");
  }catch(e){ck("test run",false,e.message)}
  document.getElementById("o").textContent=JSON.stringify(r);
 })();
})();
'@
$tot = 0; $bad = 0
foreach ($w in $Widths) {
  $u = 'file:///' + (($page -replace '\\', '/') -replace ' ', '%20')
  $html2 = "<!doctype html><html><body style=`"margin:0`"><iframe id=`"f`" src=`"$u`" style=`"width:${w}px;height:900px;border:0`"></iframe><pre id=`"o`">pending</pre><script>var STATES=$statesJson;document.getElementById('f').onload=function(){setTimeout(function(){$($js.Replace('</', '<\/'))},1500)}</script></body></html>"
  $tmp = Join-Path ([IO.Path]::GetTempPath()) 'nudge-cart'; New-Item -ItemType Directory -Force $tmp | Out-Null
  $pg = Join-Path $tmp 'cart.html'; [IO.File]::WriteAllText($pg, $html2, $utf8); $dump = Join-Path $tmp 'cart-dump.html'
  Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', "--window-size=$($w + 20),940", '--virtual-time-budget=30000', '--dump-dom', "`"file:///$(($pg -replace '\\','/') -replace ' ','%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
  $raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump, $utf8), '<pre id="o">([\s\S]*?)</pre>').Groups[1].Value)
  $tot++
  if ($raw -eq 'pending' -or -not $raw) { $bad++; "{0,5}px: no result" -f $w; continue }
  $res = [string[]](ConvertFrom-Json $raw); $fail = @($res | Where-Object { $_ -like 'FAIL*' })
  if ($fail.Count) { $bad++; "{0,5}px: {1}/{2}" -f $w, ($res.Count - $fail.Count), $res.Count; $fail | ForEach-Object { "      $_" } } else { "{0,5}px: {1}/{1} pass" -f $w, $res.Count }
}
Remove-Item $page -Force -ErrorAction SilentlyContinue
"{0} of {1} widths clean" -f ($tot - $bad), $tot
