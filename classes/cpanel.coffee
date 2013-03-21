global.Restfull = require "../classes/restfull"
global.User = require "../classes/user"
global.AdminViewModel = require "../assets/js/viewModels/AdminViewModel"

global.statuses =
	"new": "Новый"
	"emailsent": "Письмо отослано"
	"paid": "Оплачено"

global.statusGraph =
	next:
		"new": "emailsent"
		"emailsent": "paid"
	prev:
		"emailsent": "new"
		"paid": "emailsent"

global.cpanelPageLimit = 10

class Cpanel
	constructor: ->
		@rest = new Restfull
		@authenticated
			ok: => @showOperatorLogin()
			fail: => @redirectToLogin()
	ready: ->
		@adminViewModel = new AdminViewModel
		ko.applyBindings @adminViewModel
		@setup()
		@loadUsers()
	authenticated: (callbacks) ->
		p = @rest.get "index"
		p.error callbacks.fail
		p.done (data) =>
			if data and data.whois
				@whois = data.whois
				@group = data.group
				callbacks.ok()
				$(document).ready () => @ready()
			else
				callbacks.fail()
	redirectToLogin: -> global.location = "login.html"
	showOperatorLogin: -> $('#operator_login_content').text "@#{@whois}"
	logoff: ->
		p = @rest.delete "index"
		p.done () => @redirectToLogin()
	setup: ->
		me = @
		@filter = {skip: 0, limit: global.cpanelPageLimit}
		@page = 0
		$('#operator_logoff').click () => @logoff()
		$('.status-filter').click -> me.statusFilterChanged $(@).attr("rel")
		$('.status-filter[rel="new"]').click()
	statusFilterChanged: (status) ->
		if @filter.status
			if @filter.status is status
				$(".status-filter[rel=\"#{status}\"]").removeClass "active"
				delete @filter.status
			else
				$(".status-filter[rel=\"#{@filter.status}\"]").removeClass "active"
				@filter.status = status
				$(".status-filter[rel=\"#{status}\"]").addClass "active"
		else
			@filter.status = status
			$(".status-filter[rel=\"#{status}\"]").addClass "active"
		@loadUsers()
	loadOperators: (cb) ->
		p = @rest.get "operator"
		p.done (operators) =>
			@adminViewModel.operators.removeAll()
			for operator in operators
				@adminViewModel.operators.push new OperatorViewModel operator
			if cb
				cb()
	loadUsers: ->
		search = @adminViewModel.search()
		if search
			if not search.match /^[0-9]+$/
				words = search.split(" ").filter (x) -> x
				words = _.map words, (x) -> x.toLowerCase()
				if words
					@filter.words = words
				else
					delete @filter.words
			else
				delete @filter.words
		else if @filter.words
			delete @filter.words
		console.log @filter.words
		if search.match /^[0-9]+$/
			user = new User
			p = user.getById search
			p.done (user) =>
				@users = {}
				@adminViewModel.users.removeAll()
				console.log user
				if user
					@users[user.id] = user
					@adminViewModel.users.push new UserViewModel user
					@adminViewModel.userCount 1
		else
			p = @rest.get "user", @filter
			p.done (users) =>
				@users = {}
				@adminViewModel.users.removeAll()
				@adminViewModel.userCount 0
				for user in users
					@users[user.id] = user
					@adminViewModel.users.push new UserViewModel user
					@adminViewModel.userCount @adminViewModel.userCount() + 1
	userSetup: (user, userMarkup) ->
		@users[user.id] = user
		unless userMarkup
			eventSetup = true
			userMarkup = $ ".repo-user"
			userMarkup = userMarkup.clone().removeClass "hide"
			userMarkup.removeClass "repo-user"
			userMarkup.attr "user_id", "#{user.id}"
		userId = userMarkup.find ".user-id"
		userId.text user.id
		userFIO = userMarkup.find ".user-fio"
		userFIO.text "#{user.surname} #{user.name} #{user.patronymic}"
		userEmail = userMarkup.find ".user-email"
		userEmail.text user.email
		userEmail.attr "href", "mailto:#{user.email}"
		userPhone = userMarkup.find ".user-phone"
		userPhone.text user.phone
		userStatus = userMarkup.find ".user-status"
		userStatus.text statuses[user.status]
		userMarkup.addClass "user-real"
		userActions = userMarkup.find ".user-actions"
		nextAction = statusGraph.next[user.status]
		prevAction = statusGraph.prev[user.status]
		nextActionMarkup = userActions.find ".user-action-nextstate"
		prevActionMarkup = userActions.find ".user-action-prevstate"
		if nextAction
			nextActionMarkup.parent().removeClass "hide"
		else
			nextActionMarkup.parent().addClass "hide"
		if prevAction
			prevActionMarkup.parent().removeClass "hide"
		else
			prevActionMarkup.parent().addClass "hide"
		nextActionMarkup.text statuses[nextAction] if nextAction
		prevActionMarkup.text statuses[prevAction] if prevAction
		detailsAction = userActions.find "user-action-details"
		detailsAction.unbind().click () => @userDetails user.id
		prevActionMarkup.unbind().click () => @userStatus user.id, prevAction
		nextActionMarkup.unbind().click () => @userStatus user.id, nextAction
		userMarkup

	userDetails: (id) ->
		@adminViewModel.backToUsersLeftIsHidden no
		@adminViewModel.initialOffset = $("#user_page").offset()
		$("#user_page").addClass "cpanel-navigation-goaway-left"

		setTimeout =>
			user_card = $(".user-pages .container[user_id=\"#{id}\"]")
			user_card.css position: "fixed", left: @adminViewModel.initialOffset.left, top: @adminViewModel.initialOffset.top
			user_card.removeClass "cpanel-navigation-goaway-right"
			@active_page = user_card
			$selects = user_card.find "select.for-select2"
			$selects.each -> 
				$e = $ @
				$e.select2 "val", $e.attr "data"
			setTimeout ->
				user_card.attr "style", ""
			, 500
		, 50
	userStatus: (id, status) ->
		userMarkup = $ ".user-real[user_id=\"#{id}\"]"
		user = new User
		user.fromData @users[id]
		p = user.update id, status
		# p.done () =>
		# 	p = user.getById id
		# 	p.done (user) =>
		# 		@userSetup user, userMarkup

module.exports = Cpanel
