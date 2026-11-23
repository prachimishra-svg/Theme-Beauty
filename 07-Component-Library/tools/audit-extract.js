(function(){
 var SEM='accordion accordion-item accordion-panel accordion-summary badge badge-brand badge-dark badge-outline breadcrumb breadcrumb-item breadcrumb-list btn btn-block btn-lg btn-primary btn-secondary btn-sm btn-text chip chip-row divider drawer drawer-body drawer-foot drawer-head field field-label icon icon-btn icon-btn-filled input link link-standalone mega-panel message message-error message-success message-warning pagination pagination-gap pagination-link ph ph-b ph-c price price-compare price-current price-lg price-sale price-unit qty qty-btn qty-input rating rating-stars select select-icon hp-btn hp-btn-o hp-btn-s hp-chip tile ratio choice choice-input opt opt-input opt-label opt-save opt-sub tile-img tile-input tile-name vendor product-card pc-action pc-alt pc-link pc-media pc-quick swatch swatch-chip swatch-input swatch-sm shead tt lnk lbl dim banner-bg'.split(' ');
 var DET={'input text':'input[type=text],input:not([type])','input email':'input[type=email]','input tel':'input[type=tel]','input password':'input[type=password]','input search':'input[type=search]','input number':'input[type=number]','checkbox':'input[type=checkbox]','radio':'input[type=radio]','select':'select','textarea':'textarea','toggle switch':'[role=switch]','range':'input[type=range]','label':'label,.field-label','field wrapper':'.field','validation message':'.message-error,[role=alert],[aria-invalid=true]','status / live region':'[role=status],[aria-live]','tabs':'[role=tablist]','accordion':'details,.accordion','tooltip':'[role=tooltip],[data-tooltip]','dialog':'dialog','drawer':'.drawer','progress':'progress,[role=progressbar]','skeleton':'[class*=skeleton]','table':'table','video or embed':'video,iframe','breadcrumb':'.breadcrumb,nav[aria-label*=readcrumb]','pagination':'.pagination,[aria-label*=agination]','badge':'.badge','chip':'.chip,.hp-chip','price':'.price','rating':'.rating','quantity':'.qty','message':'.message','swatch':'.swatch,.swatch-chip','choice (option card)':'.choice,.opt','plp product card':'.product-card','divider':'.divider,hr','form':'form','blockquote':'blockquote','figure':'figure','ordered list':'ol','image':'img','placeholder image':'.ph,.ph-b,.ph-c,[class*=ph-k-]','icon':'svg.icon','sticky element':'[class~=sticky]','scroller controls':'[class*=__nav]','payment label':'[aria-label=\"Payment methods\"] i'};
 function t(e){return (e.textContent||'').replace(/\s+/g,' ').trim()}
 function uniq(a,key){var s={},o=[];a.forEach(function(x){var k=key?key(x):x;if(s[k]){s[k].n++}else{x.n=1;s[k]=x;o.push(x)}});return o}
 function kindOf(b){var c=' '+(b.getAttribute('class')||'')+' ';
  if(/ hp-btn-o /.test(c))return 'button: editorial-outline'; if(/ hp-btn /.test(c))return 'button: editorial'; if(/ btn-primary /.test(c))return 'button: primary'; if(/ btn-secondary /.test(c))return 'button: secondary'; if(/ btn-text /.test(c))return 'button: text'; if(/ btn /.test(c))return 'button: ds';
  if(b.hasAttribute('data-plus')||b.hasAttribute('data-minus')||/ qty/.test(c))return 'quantity control';
  if(/ chip| pill| hp-chip/.test(c))return 'chip'; if(/swatch/.test(c))return 'swatch';
  if(b.hasAttribute('aria-expanded')&&b.closest('details,.accordion'))return 'accordion trigger';
  if(b.hasAttribute('aria-expanded'))return 'disclosure toggle';
  if(b.getAttribute('role')==='tab')return 'tab';
  if(!t(b)&&b.querySelector('use'))return 'icon button';
  return 'other control';}
 function labelFor(i){var l='';if(i.id){var lb=document.querySelector('label[for="'+i.id.replace(/"/g,'')+'"]');if(lb)l=t(lb)}if(!l){var p=i.closest('label');if(p)l=t(p)}return (l||i.getAttribute('aria-label')||i.getAttribute('placeholder')||i.getAttribute('name')||i.id||'').slice(0,50)}
 function feats(c){var o={};
  o.heads=uniq([].map.call(c.querySelectorAll('h1,h2,h3,h4,h5,h6,summary,legend'),function(h){return {tag:h.tagName.toLowerCase(),text:t(h).slice(0,90)}}).filter(function(x){return x.text}),function(x){return x.tag+x.text}).slice(0,40);
  o.buttons=uniq([].map.call(c.querySelectorAll('button,a.btn,a.hp-btn,[role=button],input[type=submit],[role=tab]'),function(b){return {kind:kindOf(b),text:(t(b)||b.getAttribute('aria-label')||b.getAttribute('title')||'').slice(0,60)}}),function(x){return x.kind+'|'+x.text}).slice(0,60);
  var ic={};[].forEach.call(c.querySelectorAll('use'),function(u){var h=(u.getAttribute('href')||u.getAttribute('xlink:href')||'').replace('#icon-','');ic[h]=(ic[h]||0)+1});o.icons=ic;
  o.inputs=uniq([].map.call(c.querySelectorAll('input,select,textarea'),function(i){return {tag:i.tagName.toLowerCase(),type:i.getAttribute('type')||'',label:labelFor(i)}}).filter(function(x){return x.type!=='hidden'}),function(x){return x.tag+x.type+x.label}).slice(0,30);
  o.media=uniq([].map.call(c.querySelectorAll('.lbl,.ph .in,.ph-b .in,.ph-c .in,img,video,iframe,[class~=ph],[class~=ph-b],[class~=ph-c]'),function(m){var tx=t(m)||m.getAttribute('alt')||'';return {type:/^(IMG|VIDEO|IFRAME)$/.test(m.tagName)?m.tagName.toLowerCase():'placeholder',text:tx.slice(0,70)}}).filter(function(x){return x.type!=='placeholder'||x.text}),function(x){return x.type+x.text}).slice(0,40);
  var cc={};[].forEach.call(c.querySelectorAll('[class]'),function(e){var cl=e.classList;for(var i=0;i<cl.length;i++){if(SEM.indexOf(cl[i])>=0)cc[cl[i]]=(cc[cl[i]]||0)+1}});o.classes=cc;
  var d={};Object.keys(DET).forEach(function(k){var n=0;try{n=c.querySelectorAll(DET[k]).length}catch(e){}if(n)d[k]=n});var bt=[].filter.call(c.querySelectorAll('a'),function(a){return /^Back to top$/.test(t(a))}).length;if(bt)d['back to top link']=bt;o.det=d;
  var rl={};[].forEach.call(c.querySelectorAll('[role]'),function(e){var r=e.getAttribute('role');rl[r]=(rl[r]||0)+1});o.roles=rl;
  o.links=c.querySelectorAll('a[href]').length;o.li=c.querySelectorAll('li').length;
  o.text=t(c).slice(0,300);return o;}
 function prep(el,dropNested){var c=el.cloneNode(true);[].forEach.call(c.querySelectorAll('.ann,#wp'),function(x){x.remove()});if(dropNested)[].forEach.call(c.querySelectorAll('[data-section]'),function(x){x.remove()});return c}
 function annOf(el){var a=el.querySelector(':scope > .ann');if(!a)return {};var b=a.querySelector('b'),em=a.querySelector('em'),x={stage:b?t(b):'',responsive:em?t(em):''};var c=a.cloneNode(true);var e2=c.querySelector('em');if(e2)e2.remove();var b2=c.querySelector('b');if(b2)b2.remove();x.note=t(c);return x}
 function depthOf(el){var d=0,p=el.parentElement;while(p){if(p.hasAttribute&&p.hasAttribute('data-section'))d++;p=p.parentElement}return d}
 var blocks=[],seen=[];
 function add(kind,el,name,dropNested){var b=feats(prep(el,dropNested));b.kind=kind;b.name=name;b.id=el.id||'';b.depth=depthOf(el);var a=annOf(el);b.stage=a.stage||'';b.note=a.note||'';b.responsive=a.responsive||'';b.tag=el.tagName.toLowerCase();blocks.push(b);seen.push(el)}
 var all=document.querySelectorAll('#annbar,#site-header,footer,[data-section],main aside,dialog');
 [].forEach.call(all,function(el){
  if(el.id==='wp')return;
  if(el.hasAttribute('data-section')){add('section',el,el.getAttribute('data-section'),true);return}
  var inSec=el.closest('[data-section]');
  if(el.id==='annbar'){if(!inSec)add('chrome',el,'Announcement bar',false);return}
  if(el.id==='site-header'){if(!inSec)add('chrome',el,'Header',false);return}
  if(el.tagName==='FOOTER'){if(!inSec)add('chrome',el,'Footer',false);return}
  if(el.tagName==='DIALOG'){add('overlay',el,(el.getAttribute('aria-label')||(el.querySelector('h1,h2,h3')?t(el.querySelector('h1,h2,h3')):'')||el.id),false);return}
  if(el.tagName==='ASIDE'){add('landmark',el,el.getAttribute('aria-label')||el.id||'aside',false);return}
 });
 /* leftover main content that belongs to no named block */
 var main=document.querySelector('main');
 if(main){var c=prep(main,false);[].forEach.call(c.querySelectorAll('[data-section],aside,dialog'),function(x){x.remove()});var f=feats(c);f.kind='content';f.name='Unnamed content in main';f.id='';f.depth=0;f.stage='';f.note='';f.responsive='';f.tag='main';
  if(f.buttons.length||f.inputs.length||f.heads.length||Object.keys(f.det).length)blocks.push(f)}
 var whole=feats(prep(document.body,false));
 return JSON.stringify({title:document.title,blocks:blocks,whole:{det:whole.det,icons:whole.icons,classes:whole.classes,roles:whole.roles,inputs:whole.inputs,buttons:whole.buttons}});
})()
