/* Cart model and renderers shared by the Cart Page and the Cart Drawer wireframes (sample data standing in for the Shopify cart).
   Markup uses Tailwind utilities and the shared components (partials/components.tw.css). In the theme each renderer is a Liquid snippet over the cart object.
   NudgeCart.ctx is "page" (lines in a row from 768 px) or "drawer" (compact stacked lines). Hook classes (cl, cl__err ...) carry no styles. */
window.NudgeCart=(function(){
 var FS=50,PH=["ph","ph-b","ph-c"];
 var CAT={
  tm:{name:"Tinted Moisturiser",variant:"Rose · 50 ml",price:32,cmp:0,stock:24,v:0},
  sr:{name:"Face Serum",variant:"30 ml",price:32,cmp:36,stock:3,v:1},
  cl:{name:"Face Cleanser",variant:"150 ml",price:18,cmp:0,stock:40,v:2},
  sp:{name:"Daily Sunscreen",variant:"50 ml",price:26,cmp:0,stock:12,v:0},
  ey:{name:"Eye Cream",variant:"15 ml",price:30,cmp:0,stock:20,v:1},
  bl:{name:"Body Lotion",variant:"200 ml",price:24,cmp:0,stock:30,v:2},
  hc:{name:"Hand Cream",variant:"50 ml",price:14,cmp:0,stock:30,v:0},
  mk:{name:"Setting Mist",variant:"100 ml",price:22,cmp:0,stock:18,v:1},
  lb:{name:"Lip Balm",variant:"Rose",price:12,cmp:0,stock:50,v:0},
  tc:{name:"Travel Cleanser",variant:"50 ml",price:9,cmp:0,stock:50,v:2}
 };
 var UP=["lb","tc"];
 var S={items:[],undo:null,undoT:null,notice:null};
 var API={ctx:"page"};
 function money(n){return "$"+n.toFixed(2)}
 function max(id){return Math.max(1,Math.min(10,CAT[id].stock))}
 function set(list){S.items=list.map(function(p){return{id:p[0],qty:p[1]}});S.undo=null;S.notice=null}
 function count(){return S.items.reduce(function(a,i){return a+i.qty},0)}
 function sub(){return S.items.reduce(function(a,i){return a+CAT[i.id].price*i.qty},0)}
 function save(){return S.items.reduce(function(a,i){var c=CAT[i.id];return a+(c.cmp?(c.cmp-c.price)*i.qty:0)},0)}
 function find(id){return S.items.filter(function(i){return i.id===id})[0]}
 function setQty(id,q){var it=find(id);if(!it)return;it.qty=Math.max(1,Math.min(max(id),q))}
 function remove(id){var ix=S.items.map(function(i){return i.id}).indexOf(id);if(ix<0)return;S.undo={item:S.items[ix],ix:ix};S.items.splice(ix,1)}
 function undo(){if(!S.undo)return;S.items.splice(S.undo.ix,0,S.undo.item);S.undo=null}
 function add(id){var it=find(id);if(it){setQty(id,it.qty+1)}else{S.items.push({id:id,qty:1})}S.undo=null}
 function left(){return Math.max(0,FS-sub())}
 var ICON=function(n,cls){return `<svg class="icon ${cls||""}" aria-hidden="true" focusable="false"><use href="#icon-${n}"></use></svg>`};
 function fsHtml(){var rem=left(),p=Math.min(100,Math.round(sub()/FS*100)),done=rem<=0;
  return `<div class="fs group flex flex-col gap-2" data-done="${done}"><p class="fs__t text-body-sm" role="status">${done?"<b class='font-semibold'>You have free shipping.</b>":"You are <b class='font-semibold'>"+money(rem)+"</b> away from free shipping."}</p><div class="fs__bar relative h-1 overflow-hidden bg-line" role="progressbar" aria-label="Progress to free shipping" aria-valuemin="0" aria-valuemax="${FS}" aria-valuenow="${Math.min(FS,Math.round(sub()))}" style="--p:${p}%"><span class="absolute inset-y-0 left-0 w-[var(--p)] bg-brand transition-[width] duration-slow group-data-[done=true]:bg-status-success"></span></div></div>`}
 function lineHtml(it){var c=CAT[it.id],m=max(it.id),lt=c.price*it.qty,low=c.stock<=5,pg=API.ctx==="page";
  var row=pg
   ?"grid grid-cols-[var(--space-20)_minmax(0,1fr)_auto] gap-x-4 gap-y-3 border-t border-line py-5 last:border-b [grid-template-areas:'thumb_info_price''thumb_qty_qty'] md:grid-cols-[var(--space-24)_minmax(0,1fr)_auto_var(--space-24)] md:items-start md:[grid-template-areas:'thumb_info_qty_price'] lg:gap-x-6"
   :"grid grid-cols-[var(--space-16)_minmax(0,1fr)_auto] gap-x-4 gap-y-3 border-t border-line py-4 first:border-t-0 first:pt-0 last:border-b [grid-template-areas:'thumb_info_price''thumb_qty_qty']";
  var nameSize=pg?"text-body-lg":"text-body";
  var qtyWrap=pg?"flex flex-wrap items-center gap-4 [grid-area:qty] md:flex-col md:items-start md:gap-1":"flex flex-wrap items-center gap-4 [grid-area:qty]";
  return `<li class="cl ${row}" data-id="${it.id}">`
  +`<div class="relative aspect-portrait self-start overflow-hidden [grid-area:thumb]" aria-hidden="true"><div class="ph ${PH[c.v%3].replace("ph ","")} absolute inset-0"></div></div>`
  +`<div class="flex min-w-0 flex-col gap-1 [grid-area:info]"><a class="cl__name -my-[calc((var(--touch-target-min)-var(--space-6))/2)] flex min-h-touch items-center font-heading ${nameSize} leading-snug text-inherit no-underline hover:underline" href="#pdp">${c.name}</a><p class="text-body-sm text-ink-secondary">${c.variant}</p>${low?`<p class="cl__stock text-caption text-status-warning">Only ${c.stock} left</p>`:""}${S.notice&&S.notice.id===it.id?`<p class="cl__err text-caption text-status-error" role="alert">${S.notice.text}</p>`:""}</div>`
  +`<div class="flex flex-col items-end gap-1 text-right [grid-area:price]"><span class="price"><span class="price-current" data-lt>${money(lt)}</span></span>${it.qty>1?`<span class="cl__each text-caption text-ink-secondary">${money(c.price)} each</span>`:""}${c.cmp?`<s class="price-compare">${money(c.cmp*it.qty)}</s><span class="text-caption text-brand">Save ${money((c.cmp-c.price)*it.qty)}</span>`:""}</div>`
  +`<div class="${qtyWrap}"><div class="qty" role="group" aria-label="Quantity for ${c.name}"><button class="qty-btn" type="button" data-minus aria-label="Decrease quantity"${it.qty<=1?" disabled":""}>${ICON("minus")}</button><input class="qty-input" type="text" inputmode="numeric" pattern="[0-9]*" value="${it.qty}" aria-label="Quantity" data-q><button class="qty-btn" type="button" data-plus aria-label="Increase quantity"${it.qty>=m?" disabled":""}>${ICON("plus")}</button></div><button class="min-h-touch px-2 text-body-sm text-ink-secondary underline underline-offset-[0.2em] hover:text-ink" type="button" data-rm aria-label="Remove ${c.name}">Remove</button></div></li>`}
 function linesHtml(){return `<ul class="m-0 list-none p-0">${S.items.map(lineHtml).join("")}</ul>`}
 function undoHtml(){if(!S.undo)return"";return `<p class="message message-success mb-4 items-center" role="status"><span>${CAT[S.undo.item.id].name} removed.</span><button class="link ml-auto min-h-touch" type="button" data-undo>Undo</button></p>`}
 function upHtml(title){var ids=UP.filter(function(i){return !find(i)});if(!ids.length)return"";
  return `<div class="flex flex-col gap-3"><h2 class="type-h5">${title}</h2><ul class="m-0 list-none p-0">${ids.map(function(id){var c=CAT[id];return `<li class="up__row grid grid-cols-[var(--space-14)_minmax(0,1fr)_auto] items-center gap-4 border-t border-line py-3"><div class="relative aspect-portrait overflow-hidden" aria-hidden="true"><div class="ph ${PH[c.v%3].replace("ph ","")} absolute inset-0"></div></div><div><span class="up__name block font-heading text-body-lg leading-snug">${c.name}</span><span class="text-body-sm text-ink-secondary">${c.variant} · ${money(c.price)}</span></div><button class="btn btn-secondary" type="button" data-add="${id}" aria-label="Add ${c.name} to cart">Add</button></li>`}).join("")}</ul></div>`}
 function bind(root,changed){
  root.addEventListener("click",function(e){var li=e.target.closest(".cl"),id=li&&li.getAttribute("data-id"),done=true,kn="edit";S.notice=null;
   if(e.target.closest("[data-minus]")){var it=find(id);setQty(id,it.qty-1)}
   else if(e.target.closest("[data-plus]")){var it2=find(id);setQty(id,it2.qty+1)}
   else if(e.target.closest("[data-rm]")){kn="remove";remove(id);clearTimeout(S.undoT);S.undoT=setTimeout(function(){S.undo=null;changed("expire")},8000)}
   else if(e.target.closest("[data-undo]")){undo();clearTimeout(S.undoT)}
   else if(e.target.closest("[data-add]")){add(e.target.closest("[data-add]").getAttribute("data-add"))}
   else done=false;
   if(done)changed(kn)});
  root.addEventListener("change",function(e){var q=e.target.closest("[data-q]");if(!q)return;var li=q.closest(".cl"),id=li.getAttribute("data-id"),v=parseInt(q.value,10);S.notice=null;v=isNaN(v)?1:v;if(v>max(id)){var st=CAT[id].stock;S.notice={id:id,text:st<10?"Only "+st+" available. Quantity set to "+st+".":"Limit of 10 per order. Quantity set to 10."}}setQty(id,v);changed("edit")});
 }
 API.FS=FS;API.CAT=CAT;API.S=S;API.money=money;API.set=set;API.count=count;API.sub=sub;API.save=save;API.left=left;API.fsHtml=fsHtml;API.linesHtml=linesHtml;API.undoHtml=undoHtml;API.upHtml=upHtml;API.bind=bind;API.find=find;API.remove=remove;API.undo=undo;API.add=add;API.setQty=setQty;
 return API;
})();
