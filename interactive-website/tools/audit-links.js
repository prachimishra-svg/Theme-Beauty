(function(){
 function t(e){return (e.textContent||'').replace(/\s+/g,' ').trim()}
 function ctx(e){
  var s=e.closest('[data-section]'); if(s)return s.getAttribute('data-section');
  if(e.closest('#annbar'))return 'Announcement bar'; if(e.closest('#site-header'))return 'Header'; if(e.closest('footer'))return 'Footer';
  var d=e.closest('dialog'); if(d)return 'Dialog '+(d.id||''); var m=e.closest('main'); return m?'Main':'Other'}
 var sel='a[href],button,[role=button],summary,input:not([type=hidden]),select,textarea,[data-quick],[data-drawer-open],[data-set],[data-mega-link]';
 var out=[],seen=[];
 [].forEach.call(document.querySelectorAll(sel),function(e){
  if(e.closest('.rv,#wp,.ann'))return;
  var data=[];for(var i=0;i<e.attributes.length;i++){var n=e.attributes[i].name;if(n.indexOf('data-')===0)data.push(n)}
  var vis=true;try{var cs=getComputedStyle(e);vis=cs.display!=='none'&&cs.visibility!=='hidden'}catch(x){}
  out.push({tag:e.tagName.toLowerCase(),text:(t(e)||e.getAttribute('aria-label')||e.getAttribute('placeholder')||e.getAttribute('name')||'').slice(0,70),href:e.getAttribute('href')||'',id:e.id||'',aria:(e.getAttribute('aria-label')||'').slice(0,60),type:e.getAttribute('type')||'',cls:[].slice.call(e.classList).slice(0,3).join(' '),ctx:ctx(e),data:data.join(','),vis:vis})
 });
 return JSON.stringify({title:document.title,n:out.length,items:out});
})()
