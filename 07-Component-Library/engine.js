/* NUDGE Beauty component engine (browser copy).
   The same template language as the PowerShell build (03-Wireframes/00-Shared-Tailwind-Foundation/build.ps1). tools/test-js-parity.ps1 renders every real component call in
   both engines and requires identical output, so what the library shows is what the wireframes get.

   Language:  {{x}} {{slug:x}} {{lower:x}} {{arg:x}} {{x.field}} {{x.class}}   value, slug, lower case, argument-safe (escapes quote, at and bar, for passing into @@PARTIAL arguments), object field, named variant classes
              {{if x}} ... {{/if}}   {{if x=value}} ... {{/if}}   {{if !x}} ... {{/if}}   truthy test / equals test / negated test; blocks nest
              {{each list}} ... {{/each}}  with {{item}} {{item.field}} {{href}} {{index}} {{index0}} and {{if first}} {{if last}}
              @@PARTIAL components/group/name key=value key="a value"@@   nested component (arguments may use the escapes &quot; &#64; &#124;)
   Manifest (components/.../name.json): properties[] with name, type (VARIANT | BOOLEAN | TEXT | LIST | INSTANCE_SWAP), default, values, classes (VARIANT: value -> classes). */
(function (global) {
  'use strict';
  function unesc(s) { return String(s).split('&quot;').join('"').split('&#64;').join('@').split('&#124;').join('|'); }
  function slug(s) { return String(s).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, ''); }
  function truthy(v) {
    if (v === null || v === undefined) return false;
    if (typeof v === 'boolean') return v;
    if (typeof v === 'string') return !(v === '' || v === '0' || v === 'false');
    if (Array.isArray(v)) return v.length > 0;
    return true;
  }
  function pathGet(scope, path) {
    var parts = path.split('.'), cur = scope[parts[0]];
    for (var i = 1; i < parts.length; i++) { if (cur === null || cur === undefined) return null; cur = cur[parts[i]]; }
    return cur === undefined ? null : cur;
  }
  function parseArgs(s) {
    var o = {}, re = /(\w+)=("([^"]*)"|(\S+))/g, m;
    while ((m = re.exec(s)) !== null) o[m[1]] = m[3] !== undefined ? m[3] : m[4];
    return o;
  }

  function Engine(components, extra) { this.components = components || {}; extra = extra || {}; this.builtins = extra.builtins || {}; this.pages = extra.pages || {}; }

  Engine.prototype.manifestOf = function (name) { var c = this.components[name]; return c ? (c.manifest || null) : null; };

  Engine.prototype.scopeFor = function (name, args) {
    var man = this.manifestOf(name), scope = {}, k;
    for (k in args) if (Object.prototype.hasOwnProperty.call(args, k)) scope[k] = args[k];
    if (man && man.properties) man.properties.forEach(function (p) {
      if (!(p.name in scope) && p.default !== undefined && p.default !== null) {
        var d = p.default; if (typeof d === 'boolean') d = d ? '1' : '0'; scope[p.name] = d;
      }
    });
    return scope;
  };

  Engine.prototype.tokens = function (text, scope, man, cn) {
    return text.replace(/\{\{(slug:|lower:|arg:)?([\w.]+)\}\}/g, function (all, mode, path) {
      var m = /^(\w+)\.(\w+)$/.exec(path);
      if (m && man) {
        var prop = (man.properties || []).filter(function (p) { return p.name === m[1]; })[0];
        if (prop) {
          var val = String(scope[m[1]]), tbl = m[2] === 'class' ? prop.classes : (prop.tables ? prop.tables[m[2]] : null);
          if (!tbl) throw new Error('component ' + cn + " - '" + m[1] + "' has no '" + m[2] + "' table");
          if (!Object.prototype.hasOwnProperty.call(tbl, val)) throw new Error('component ' + cn + " - '" + m[1] + "' has no '" + m[2] + "' entry for '" + val + "'");
          return String(tbl[val]);
        }
      }
      var v = pathGet(scope, path);
      if (v === null) throw new Error('component ' + cn + " - missing argument '" + path + "'");
      v = unesc(String(v));
      return mode === 'slug:' ? slug(v) : mode === 'lower:' ? v.toLowerCase() : mode === 'arg:' ? v.split('"').join('&quot;').split('@').join('&#64;').split('|').join('&#124;') : v;
    });
  };

  Engine.prototype.tpl = function (t, scope, man, cn) {
    var self = this, out = '', pos = 0, rx = /\{\{(if|each) ([^}]+)\}\}|\{\{\/(if|each)\}\}/g;
    while (pos < t.length) {
      rx.lastIndex = pos; var m = rx.exec(t);
      if (!m) { out += self.tokens(t.slice(pos), scope, man, cn); break; }
      if (m[3]) throw new Error('component ' + cn + ' - unmatched {{/' + m[3] + '}}');
      out += self.tokens(t.slice(pos, m.index), scope, man, cn);
      var depth = 1, scan = m.index + m[0].length, end = -1, endLen = 0, n;
      while (depth > 0) {
        rx.lastIndex = scan; n = rx.exec(t);
        if (!n) throw new Error('component ' + cn + ' - unclosed {{' + m[1] + '}}');
        if (n[3]) { depth--; if (depth === 0) { end = n.index; endLen = n[0].length; } } else depth++;
        scan = n.index + n[0].length;
      }
      var inner = t.slice(m.index + m[0].length, end), arg = m[2].trim();
      if (m[1] === 'if') {
        var neg = false, a2 = arg.trim(); if (a2.charAt(0) === '!') { neg = true; a2 = a2.slice(1).trim(); } var eq = /^([\w.]+)=(.+)$/.exec(a2), ok = eq ? String(pathGet(scope, eq[1]) === null ? '' : pathGet(scope, eq[1])) === eq[2].trim() : truthy(pathGet(scope, a2)); if (neg) ok = !ok;
        if (ok) out += self.tpl(inner, scope, man, cn);
      } else {
        var list = pathGet(scope, arg);
        if (list === null) throw new Error('component ' + cn + " - missing list argument '" + arg + "'");
        var items = typeof list === 'string' ? list.split('|') : list.slice();
        items.forEach(function (it, idx) {
          var child = {}, k; for (k in scope) if (Object.prototype.hasOwnProperty.call(scope, k)) child[k] = scope[k];
          if (typeof it === 'string') { var pr = it.split('::'); child.item = unesc(pr[0]); child.href = pr.length > 1 ? unesc(pr.slice(1).join('::')) : ''; }
          else { child.item = it; child.href = ''; }
          child.index = String(idx + 1); child.index0 = String(idx); child.first = idx === 0; child.last = idx === items.length - 1;
          out += self.tpl(inner, child, man, cn);
        });
      }
      pos = end + endLen;
    }
    return out;
  };

  /* render one component to HTML (nested @@PARTIAL calls are expanded too) */
  Engine.prototype.render = function (name, args) {
    var c = this.components[name]; if (!c) throw new Error('unknown partial ' + name);
    var scope = this.scopeFor(name, args || {}), html = c.html.replace(/[\r\n]+$/, '');
    var self = this, pages = this.pages, out = this.tpl(html, scope, c.manifest || null, name);
    out = out.replace(/@@LINK:([a-z-]+)@@/g, function (a, k) { if (!(k in pages)) throw new Error('unknown link target ' + k); return '../' + pages[k]; });
    return this.expand(out);
  };

  /* the shared parts annbar, header (arguments CART, NAV, EXTRA) and footer are components; page sources call them by these short names */
  Engine.prototype.builtin = function (name, args) {
    if (name === 'annbar') return this.render('components/layout/announcement-bar', {});
    if (name === 'footer') return this.render('components/layout/site-footer', {});
    if (name === 'header') return this.render('components/header/site-header', { cart: args.CART || 'link', nav: args.NAV === 'skin' ? 'skin' : 'none', extra: args.EXTRA || '' });
    throw new Error('unknown partial ' + name);
  };
  /* expand every @@PARTIAL ...@@ in a piece of text */
  Engine.prototype.expand = function (text) {
    var self = this;
    return text.replace(/@@PARTIAL ([a-z0-9\/-]+)([^@]*)@@/g, function (all, name, argstr) { return name.indexOf('components/') === 0 ? self.render(name, parseArgs(argstr)) : self.builtin(name, parseArgs(argstr)); });
  };

  Engine.parseArgs = parseArgs; Engine.unesc = unesc; Engine.slug = slug;
  global.NudgeEngine = Engine;
})(typeof window !== 'undefined' ? window : this);
