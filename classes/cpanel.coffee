global.Restfull = require "../classes/restfull"
global.User = require "../classes/user"

class Cpanel
	constructor: ->
		@rest = new Restfull
		@authenticated
			ok: => @showOperatorLogin()
			fail: => @redirectToLogin()
		$(document).ready () =>
			console.log "bga test"
			$('#operator_logoff').click () =>
				console.log @
				@logoff()
	authenticated: (callbacks) ->
		p = @rest.get "index"
		p.error callbacks.fail
		p.done (data) =>
			if data and data.whois
				@whois = data.whois
				@group = data.group
				callbacks.ok()
			else
				callbacks.fail()
	redirectToLogin: -> global.location = "login.html"
	showOperatorLogin: -> $('#operator_login_content').text "@#{@whois}"
	logoff: -> 
		p = @rest.delete "index"
		p.done () => @redirectToLogin()

module.exports = Cpanel
