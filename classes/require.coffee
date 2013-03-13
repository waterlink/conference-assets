window.global = window

global.modules = {}

global.require = (path) ->
	global.modules[path] = 
		exports: {}
		path: path
	p = $.ajax
		url: "#{path}.js"
		cache: false
		dataType: "text"
		context: global.modules[path]
		async: false
	p.done (data) ->
		module = global.modules[path]
		eval data
		console.log "evaled"
	p.error ->
		console.warn "problem loading '#{path}' module: ", arguments
	console.log "returning"
	global.modules[path].exports


