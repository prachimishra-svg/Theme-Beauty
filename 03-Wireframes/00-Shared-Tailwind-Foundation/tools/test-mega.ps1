# Interaction test for the mega menu (nav.js + partials/header.html) on real page files, at several widths.
# Usage: .\tools\test-mega.ps1 [-Pages plp,pdp,...] [-Widths 1440,1024,768,390,320]
# Desktop (>=1024): hover opens a full-width panel, one at a time, Escape/leave closes, links visible, no overflow.
# Below 1024: menu button opens the drawer, link rows are accordion buttons (one open at a time), touch targets >= 44, hit-tests, Close works.
param([string]$File = '', [string[]]$Pages = @('homepage','plp','pdp','cart-page','cart-drawer','contact','faq','about','story','shipping','returns','privacy','terms','blog','article','notfound'),
      [int[]]$Widths = @(1920, 1440, 1280, 1024, 768, 430, 390, 320))
$root = (Resolve-Path "$PSScriptRoot\..\..").Path
$map = @{ homepage='01-NUDGE-Beauty-Homepage-Wireframe\Homepage.html'; plp='02-NUDGE-Beauty-PLP-Wireframe\PLP.html'; pdp='03-NUDGE-Beauty-PDP-Wireframe\PDP.html'; 'cart-page'='04-NUDGE-Beauty-Cart-Wireframe\Cart_Page.html'; 'cart-drawer'='05-NUDGE-Beauty-Cart-Drawer-Wireframe\Cart_Drawer_Wireframe_v1.html'; contact='06-NUDGE-Beauty-Contact-Wireframe\Contact_Page_Wireframe_v1.html'; faq='07-NUDGE-Beauty-FAQ-Wireframe\FAQ_Page_Wireframe_v1.html'; about='08-NUDGE-Beauty-About-Wireframe\About_Page_Wireframe_v1.html'; story='09-NUDGE-Beauty-Story-Wireframe\Story_Page_Wireframe_v1.html'; shipping='10-NUDGE-Beauty-Shipping-Policy-Wireframe\Shipping_Policy_Wireframe_v1.html'; returns='11-NUDGE-Beauty-Returns-Policy-Wireframe\Returns_Policy_Wireframe_v1.html'; privacy='12-NUDGE-Beauty-Privacy-Policy-Wireframe\Privacy_Policy_Wireframe_v1.html'; terms='13-NUDGE-Beauty-Terms-Wireframe\Terms_Conditions_Wireframe_v1.html'; blog='14-NUDGE-Beauty-Blog-Listing-Wireframe\Blog_Listing_Wireframe_v1.html'; article='15-NUDGE-Beauty-Blog-Article-Wireframe\Blog_Article_Wireframe_v1.html'; notfound='16-NUDGE-Beauty-404-Wireframe\404_Page_Wireframe_v1.html' }
if ($File) { $Pages = @('file'); $map['file'] = (Resolve-Path $File).Path }
$sp = Join-Path ([IO.Path]::GetTempPath()) "nudge-tools"; New-Item -ItemType Directory -Force $sp | Out-Null
$js = @'
(function(){
 var r=[],w=document.getElementById("f").contentWindow,d=w.document,W=w.innerWidth,cw=d.documentElement.clientWidth;
 function ck(n,ok,det){r.push((ok?"":"FAIL ")+n+(ok?"":": "+det))}
 function vis(e){var b=e.getBoundingClientRect();return b.width>0&&b.height>0&&w.getComputedStyle(e).visibility!=="hidden"}
 function ev(el,t,o){el.dispatchEvent(new w.PointerEvent(t,Object.assign({bubbles:true,pointerType:"mouse"},o||{})))}
 [].forEach.call(d.querySelectorAll("dialog[open]"),function(x){try{x.close()}catch(e){x.removeAttribute("open")}}); /* the cart-drawer host page opens its modal on load; close it so the header is reachable */
 var items=[].slice.call(d.querySelectorAll("[data-mega]"));
 ck("4 items",items.length===4,items.length);
 var desk=W>=1024;
 function openCount(){return items.filter(function(i){return i.hasAttribute("data-open")}).length}
 function after(ms,f){setTimeout(f,ms)}
 function fin(){document.getElementById("o").textContent=JSON.stringify(r)}
 ck("panels hidden at start",items.every(function(i){return !vis(i.querySelector("[data-mega-panel]"))}),"visible");
 if(desk){
  ev(items[0],"pointerenter");
  after(200,function(){
   var p=items[0].querySelector("[data-mega-panel]"),b=p.getBoundingClientRect(),a=items[0].querySelector("[data-mega-link]");
   ck("hover opens",vis(p),"not visible");
   var cwNow=d.documentElement.clientWidth;ck("full width",Math.abs(b.left)<1&&Math.abs(b.width-cwNow)<2,b.left+"/"+b.width+" vs "+cwNow);
   ck("aria-expanded",a.getAttribute("aria-expanded")==="true","x");
   ck("header mega-open",d.getElementById("site-header").classList.contains("mega-open"),"x");
   ck("panel fits viewport",b.bottom<=w.innerHeight+1,b.bottom+" vs "+w.innerHeight);
   var ls=[].slice.call(p.querySelectorAll("a")).filter(vis);
   ck("links visible",ls.length>=12,ls.length);
   var cards=[].slice.call(p.querySelectorAll(".ph,.ph-b")).filter(vis);
   ck("2 image placeholders",cards.length===2,cards.length);
   ck("placeholder labels fit",cards.every(function(c){var s=c.querySelector("span");return s.scrollWidth<=c.clientWidth}),"clipped");
   ck("no h-overflow",d.documentElement.scrollWidth<=cw,d.documentElement.scrollWidth+" vs "+cw);
   var l0=ls[0].getBoundingClientRect(),hit=d.elementFromPoint(l0.left+l0.width/2,l0.top+l0.height/2);
   ck("link hit-test",hit&&(hit===ls[0]||ls[0].contains(hit)),hit&&hit.tagName);
   var gap=b.left,txt=p.querySelector("p").getBoundingClientRect().left,hdrL=items[0].getBoundingClientRect().left;
   ck("panel content aligns with nav",Math.abs(txt-hdrL)<2,txt+" vs "+hdrL);
   ev(items[1],"pointerenter");ev(items[0],"pointerleave");
   after(200,function(){
    ck("one at a time",openCount()===1&&items[1].hasAttribute("data-open"),openCount());
    d.dispatchEvent(new w.KeyboardEvent("keydown",{key:"Escape",bubbles:true}));
    ck("Escape closes",openCount()===0,openCount());
    ck("header restored",!d.getElementById("site-header").classList.contains("mega-open"),"x");
    ev(items[2],"pointerenter");
    after(200,function(){ck("reopen",openCount()===1,openCount());ev(items[2],"pointerleave");after(400,function(){ck("leave closes",openCount()===0,openCount());fin()})});
   });
  });
 }else{
  var st=d.createElement("style");st.textContent="*{transition:none!important;animation:none!important}";d.head.appendChild(st);var mb=d.getElementById("menu-btn");mb.click();
  var nav=d.getElementById("nav");
  after(1200,function(){
   ck("drawer opens",vis(nav)&&d.body.classList.contains("nav-open"),"x");ck("drawer in place",Math.abs(nav.getBoundingClientRect().left)<1,"left="+nav.getBoundingClientRect().left+" tr="+w.getComputedStyle(nav).transform);
   var a0=items[0].querySelector("[data-mega-link]");
   ck("row is a button",a0.getAttribute("role")==="button","role="+a0.getAttribute("role"));
   ck("row touch target",a0.getBoundingClientRect().height>=44,a0.getBoundingClientRect().height);
   a0.click();
   var p=items[0].querySelector("[data-mega-panel]");
   ck("tap opens accordion",vis(p)&&a0.getAttribute("aria-expanded")==="true","x");
   items[1].querySelector("[data-mega-link]").click();
   ck("one at a time",openCount()===1&&items[1].hasAttribute("data-open")&&!vis(p),openCount());
   var p1=items[1].querySelector("[data-mega-panel]"),ls=[].slice.call(p1.querySelectorAll("a")).filter(vis);
   ck("links visible",ls.length>=12,ls.length);
   ck("links >=44 tall",ls.every(function(l){return l.getBoundingClientRect().height>=43.5}),ls.map(function(l){return Math.round(l.getBoundingClientRect().height)}).join(","));
   ck("cards hidden",[].slice.call(p1.querySelectorAll(".ph,.ph-b")).every(function(c){return !vis(c)}),"x");
   ck("nav no h-overflow",nav.scrollWidth<=nav.clientWidth,nav.scrollWidth+" vs "+nav.clientWidth);
   nav.scrollTop=0;
   var l0=ls[0],bb=l0.getBoundingClientRect();nav.scrollTop=Math.max(0,nav.scrollTop+bb.top-200);bb=l0.getBoundingClientRect();
   var hit=d.elementFromPoint(bb.left+bb.width/2,bb.top+bb.height/2);
   ck("link hit-test (not under scrim)",hit&&(hit===l0||l0.contains(hit)),hit?(hit.id||hit.tagName):("null at "+Math.round(bb.left+bb.width/2)+","+Math.round(bb.top+bb.height/2)+" ih="+w.innerHeight+" st="+nav.scrollTop+" sh="+nav.scrollHeight));
   a0.click();ck("toggle back",items[0].hasAttribute("data-open")&&!items[1].hasAttribute("data-open"),"x");
   d.getElementById("nav-close").click();
   after(400,function(){ck("Close closes drawer",!d.body.classList.contains("nav-open"),"x");ck("page no h-overflow",d.documentElement.scrollWidth<=cw,d.documentElement.scrollWidth+" vs "+cw);fin()});
  });
 }
})();
'@
$total = 0; $bad = 0
foreach ($pg in $Pages) {
  foreach ($w in $Widths) {
    $f = if ($File) { $map[$pg] } else { Join-Path $root $map[$pg] }
    $u = "file:///" + ($f -replace '\\','/' -replace ' ','%20') + $(if ($File) { '' } else { '?embed=1&ann=0' })
    $page = "<!doctype html><html><body style=`"margin:0`"><iframe id=f src=`"$u`" style=`"width:${w}px;height:900px;border:0`"></iframe><pre id=o>pending</pre><script>setTimeout(function(){$js},7000)</script></body></html>"
    $fr = Join-Path $sp "mega-frame.html"; [IO.File]::WriteAllText($fr, $page)
    $dump = Join-Path $sp "mega-dump.html"
    Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList @("--headless=new","--disable-gpu","--allow-file-access-from-files","--window-size=$($w+20),940","--virtual-time-budget=20000","--dump-dom","`"file:///$(($fr -replace '\\','/') -replace ' ','%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
    $raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump), '<pre id="o">([\s\S]*?)</pre>').Groups[1].Value)
    $total++
    if ($raw -eq 'pending' -or -not $raw) { $bad++; "{0,-11} {1,5}px: no result" -f $pg, $w; continue }
    $r = [string[]](ConvertFrom-Json $raw)
    $f2 = @($r | Where-Object { $_ -like 'FAIL*' }); if ($r.Count -lt 5) { $f2 += "FAIL only $($r.Count) checks ran" }
    if ($f2.Count) { $bad++; "{0,-11} {1,5}px: {2}/{3}" -f $pg, $w, ($r.Count - $f2.Count), $r.Count; $f2 | ForEach-Object { "      $_" } }
    else { "{0,-11} {1,5}px: {2}/{2} pass" -f $pg, $w, $r.Count }
  }
}
"{0} of {1} page/width runs clean" -f ($total - $bad), $total
