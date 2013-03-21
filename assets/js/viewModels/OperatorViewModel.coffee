class OperatorViewModel
	constructor: (operator) ->
		_.extend @, operator

		@resettingPassword = ko.observable false

		@newpassword = ko.observable ""
		@confirmpassword = ko.observable ""

		@notami = ko.computed =>
			return @login isnt cpanel.whois and not @resettingPassword()

		@hasSessions = ko.computed =>
			return not @resettingPassword()


	resetPassword: (data, e) =>
		@resettingPassword true

	remove: (data, e) ->
		if @notami
			p = cpanel.rest.delete ["operator", @id]
			$(e.target).button "loading"
			p.done ->
				cpanel.loadOperators ->
					$(e.target).button "reset"

	resetSessions: =>
		alert "feature is under development"

	confirmResetPassword: (d, e) =>
		if @newpassword() isnt @confirmpassword()
			alert "Пароли не совпадают!"
			return
		$(e.target).button "loading"
		p = cpanel.rest.put ["index", @login],
			new_password: @newpassword()
		p.done (data) =>
			$(e.target).button "reset"
			@resettingPassword false
			if data and data.error
				alert data.error

	cancelResetPassword: =>
		@resettingPassword false


module.exports = OperatorViewModel
