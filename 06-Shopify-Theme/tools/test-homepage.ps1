# Behaviour test of the Homepage sections on a rendered theme page (headless Chrome, synthetic events; real-input tests are in test-input.ps1).
# Usage: .\tools\test-homepage.ps1 -File <rendered.html (-LocalAssets)> [-Widths 1440,1024,768,390,320]
# Checks (each only where the control exists at that width): no horizontal overflow; announcement bar rotation; Featured collection tabs swap the product grid;
# Guided finder steps/chips/back/result; Shop the look pins are exclusive; Ritual scroller counter and buttons; footer accordion below 768 px.
param([Parameter(Mandatory = $true)][string]$File, [int[]]$Widths = @(1440, 1024, 768, 390, 320))
$utf8 = New-Object Text.UTF8Encoding($false); $f = (Resolve-Path $File).Path; $u = 'file:///' + (($f -replace '\\', '/') -replace ' ', '%20')
$tmp = Join-Path ([IO.Path]::GetTempPath()) 'nudge-hp'; New-Item -ItemType Directory -Force $tmp | Out-Null
$js = @'
(function(){
 var r=[],w=document.getElementById("f").contentWindow,d=w.document,W=w.innerWidth;
 function ck(n,ok,det){r.push((ok?"":"FAIL ")+n+(ok?"":": "+det))}
 function $(s){return d.querySelector(s)} function $$(s){return [].slice.call(d.querySelectorAll(s))}
 function vis(e){if(!e)return false;var b=e.getBoundingClientRect();return b.width>0&&b.height>0}
 var st=d.createElement("style");st.textContent="*{transition:none!important;animation:none!important;scroll-behavior:auto!important}";d.head.appendChild(st);
 function after(ms,f){setTimeout(f,ms)}
 ck("no horizontal overflow",d.documentElement.scrollWidth<=d.documentElement.clientWidth,d.documentElement.scrollWidth+" vs "+d.documentElement.clientWidth);
 /* announcement */
 var nx=$("#ann-next"),pv=$("#ann-prev"),msg=$("#ann-msg");
 if(nx&&msg&&getComputedStyle(nx).display!=="none"){var m0=msg.textContent;nx.click();var m1=msg.textContent;nx.click();pv.click();pv.click();ck("announcement rotates",m1!==m0&&msg.textContent===m0,m0+"|"+m1+"|"+msg.textContent)}
 /* tabs */
 var tabs=$$(".tabs [role=tab]"),grid=$("#prod-grid");
 if(tabs.length>1&&grid){var t0=grid.querySelector(".ptitle").textContent.trim();tabs[1].click();var t1=grid.querySelector(".ptitle").textContent.trim();ck("tab 2 swaps products",t1!==t0&&tabs[1].getAttribute("aria-selected")==="true"&&tabs[0].getAttribute("aria-selected")==="false",t0+" -> "+t1);tabs[0].click();ck("tab 1 restores products",grid.querySelector(".ptitle").textContent.trim()===t0&&grid.querySelectorAll(".card").length===4,grid.querySelector(".ptitle").textContent)}
 /* finder */
 var fs=$("#f-step");
 if(fs){var chips=function(){return $$("#f-chips .hp-chip")};
  ck("finder starts at step 1",/1/.test(fs.textContent)&&chips().length===5&&chips()[0].classList.contains("on"),fs.textContent+" chips="+chips().length);
  chips()[2].click();ck("finder chip select",chips()[2].classList.contains("on")&&!chips()[0].classList.contains("on"),"x");
  $("#f-next").click();ck("finder step 2",/2/.test(fs.textContent)&&chips().length===4&&$("#f-q").textContent!=="",fs.textContent+" chips="+chips().length);
  $("#f-next").click();ck("finder step 3",/3/.test(fs.textContent)&&chips().length===2,fs.textContent+" chips="+chips().length);
  $("#f-next").click();ck("finder result",!$("#f-res").hidden&&$("#f-chips").style.display==="none"&&$("#f-next").style.display==="none",fs.textContent);
  ck("finder result link",!!$("#f-res a")&&$("#f-res a").getAttribute("href")!=="","x");
  $("#f-back").click();ck("finder back from result",$("#f-res").hidden&&/3/.test(fs.textContent)&&chips().length===2,fs.textContent);
  ck("finder controls visible and sized",vis($("#f-next"))&&$("#f-back").getBoundingClientRect().height>=44,"x")}
 /* pins */
 var pins=$$(".pin");if(pins.length>1){pins[1].click();ck("look pins exclusive",pins[1].classList.contains("is-on")&&pins.filter(function(p){return p.classList.contains("is-on")}).length===1,"x");pins[2].click();ck("look pin switches",pins[2].classList.contains("is-on")&&!pins[1].classList.contains("is-on"),"x")}
 /* ritual */
 var rit=$("[data-ritual]");
 if(rit){var cnt=rit.querySelector(".rit__count"),bar=rit.querySelector(".rit__bar"),track=rit.querySelector(".rit__track"),n2=rit.querySelector(".rit__next"),p2=rit.querySelector(".rit__prev");
  if(vis(bar)){ck("ritual starts at 01",/^01 \//.test(cnt.textContent)&&p2.disabled&&!n2.disabled,cnt.textContent);n2.click();track.dispatchEvent(new w.Event("scroll"));after(100,function(){ck("ritual next moves",track.scrollLeft>0&&/^02 \//.test(cnt.textContent),track.scrollLeft+" "+cnt.textContent);p2.click();track.dispatchEvent(new w.Event("scroll"));after(100,function(){ck("ritual previous returns",track.scrollLeft<=2&&/^01 \//.test(cnt.textContent),track.scrollLeft+" "+cnt.textContent);foot()})})}else{ck("ritual grid at desktop (controls hidden)",!vis(bar)&&track.scrollWidth<=track.clientWidth+1,"x");foot()}}
 else foot();
 function foot(){
  var fb=$(".fcol > button");
  if(fb&&getComputedStyle(fb).pointerEvents!=="none"){var col=fb.parentNode;fb.click();ck("footer accordion opens",col.classList.contains("is-open")&&fb.getAttribute("aria-expanded")==="true"&&vis(col.querySelector("a")),"x");fb.click();ck("footer accordion closes",!col.classList.contains("is-open")&&fb.getAttribute("aria-expanded")==="false","x")}
  more();
 }
 function more(){
  /* before/after */
  var cmp=$(".cmp");if(cmp){var rg=cmp.querySelector(".cmp__range");rg.value=80;rg.dispatchEvent(new w.Event("input",{bubbles:true}));ck("compare slider moves",cmp.style.getPropertyValue("--pos")==="80%"&&/80% before/.test(rg.getAttribute("aria-valuetext")),cmp.style.getPropertyValue("--pos")+" "+rg.getAttribute("aria-valuetext"))}
  /* scroller */
  var sc=$("[data-scroller]");if(sc){var trk=sc.querySelector(".rec__track"),nx2=sc.querySelector(".rec__next"),pv2=sc.querySelector(".rec__prev");ck("scroller starts at the left",pv2.disabled,"x");if(trk.scrollWidth>trk.clientWidth+2){nx2.click();trk.dispatchEvent(new w.Event("scroll"));ck("scroller next moves",trk.scrollLeft>0&&!pv2.disabled,String(trk.scrollLeft))}}
  /* newsletter */
  var nf=$("#nl-form");if(nf){var em=$("#nl-email"),msg2=$("#nl-msg");em.value="not an email";var ev=new w.Event("submit",{cancelable:true,bubbles:true});nf.dispatchEvent(ev);ck("newsletter blocks an invalid email",ev.defaultPrevented&&em.getAttribute("aria-invalid")==="true"&&msg2.classList.contains("is-err")&&msg2.textContent.length>10,msg2.textContent);em.value="a@b.co";em.dispatchEvent(new w.Event("input",{bubbles:true}));ck("newsletter clears the error",em.getAttribute("aria-invalid")==="false"&&msg2.textContent==="","x");var ev2=new w.Event("submit",{cancelable:true,bubbles:true});nf.addEventListener("submit",function(x){x.preventDefault()},{once:true});nf.dispatchEvent(ev2);ck("newsletter lets a valid email through to Shopify",nf.getAttribute("method")==="post"&&nf.querySelector("input[name='contact[email]']")&&nf.querySelector("input[name='contact[tags]']").value==="newsletter","x")}
  /* video: tap loads the iframe */
  var pl=$(".vid__box .play");if(pl){pl.setAttribute("data-embed","about:blank");pl.setAttribute("data-title","t");pl.click();ck("video play loads an iframe",!!$(".vid__box iframe")&&pl.hidden,"x")}
  document.getElementById("o").textContent=JSON.stringify(r);
 }
})();
'@
$tot = 0; $bad = 0
foreach ($w in $Widths) {
  $page = "<!doctype html><html><body style=`"margin:0`"><iframe id=`"f`" src=`"$u`" style=`"width:${w}px;height:900px;border:0`"></iframe><pre id=`"o`">pending</pre><script>document.getElementById('f').onload=function(){setTimeout(function(){$($js.Replace('</', '<\/'))},2500)}</script></body></html>"
  $pg = Join-Path $tmp 'hp.html'; [IO.File]::WriteAllText($pg, $page, $utf8); $dump = Join-Path $tmp 'hp-dump.html'
  Start-Process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList @('--headless=new', '--disable-gpu', '--force-prefers-reduced-motion', '--allow-file-access-from-files', "--window-size=$($w + 20),940", '--virtual-time-budget=20000', '--dump-dom', "`"file:///$(($pg -replace '\\','/') -replace ' ','%20')`"") -RedirectStandardOutput $dump -RedirectStandardError "$dump.err" -Wait -NoNewWindow
  $raw = [System.Net.WebUtility]::HtmlDecode([regex]::Match([IO.File]::ReadAllText($dump, $utf8), '<pre id="o">([\s\S]*?)</pre>').Groups[1].Value)
  $tot++
  if ($raw -eq 'pending' -or -not $raw) { $bad++; "{0,5}px: no result" -f $w; continue }
  $r = [string[]](ConvertFrom-Json $raw); $fail = @($r | Where-Object { $_ -like 'FAIL*' })
  if ($fail.Count) { $bad++; "{0,5}px: {1}/{2}" -f $w, ($r.Count - $fail.Count), $r.Count; $fail | ForEach-Object { "      $_" } } else { "{0,5}px: {1}/{1} pass" -f $w, $r.Count }
}
"{0} of {1} widths clean" -f ($tot - $bad), $tot
