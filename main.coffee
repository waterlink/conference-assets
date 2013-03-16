global.Backend = require "../classes/backend"
global.Restfull = require "../classes/restfull"
global.User = require "../classes/user"

class Main
	constructor: ->
		console.log "Application initialized"

	run: ->
		console.log "Application started"
		@check()

	check: ->
		console.log new Backend
		console.log new Restfull
		console.log new User

module.exports = new Main
