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

class Cpanel
	constructor: ->
		@rest = new Restfull
		@authenticated
			ok: => @showOperatorLogin()
			fail: => @redirectToLogin()
		$(document).ready () => @ready()
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
			else
				callbacks.fail()
	redirectToLogin: -> global.location = "login.html"
	showOperatorLogin: -> $('#operator_login_content').text "@#{@whois}"
	logoff: -> 
		p = @rest.delete "index"
		p.done () => @redirectToLogin()
	setup: ->
		me = @
		@filter = {}
		$('#operator_logoff').click () => @logoff()
		$('.status-filter').click -> me.statusFilterChanged $(@).attr("rel")
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
	loadUsers: ->
		p = @rest.get "user", @filter
		userView = $ "#user_view"
		realUsers = userView.find ".user-real"
		realUsers.remove()
		@users = {}
		p.done (users) => 
			# userView.append @userSetup user for user in users
			# musers = []
			@adminViewModel.users.removeAll()
			for user in users
				@users[user.id] = user 
				# musers.push new UserViewModel user
				@adminViewModel.users.push new UserViewModel user
			# global.AdminViewModel.users = ko.observableArray musers
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
		initialOffset = $("#user_page").offset()
		$("#user_page").addClass "cpanel-navigation-goaway-left"
		p = $("<div>").addClass "hidden-page"
		p.html "<i class=\"icon-tag\"></i> <span>Все<br/>учатники</span>"
		p.attr "rel", "#user_page"
		p.css top: "80px"
		p.click =>
			$("#user_page").css position: "fixed", left: initialOffset.left, top: initialOffset.top
			$("#user_page").removeClass "cpanel-navigation-goaway-left"
			if @active_page
				@active_page.addClass "cpanel-navigation-goaway-right"
				@active_page = undefined
			p.remove()
			setTimeout( ->
				$("#user_page").attr "style", ""
			, 2000)
		setTimeout( ->
			$("body").append p
		, 1400)
		setTimeout( =>
			user_card = $(".user-pages .container[user_id=\"#{id}\"]")
			user_card.css position: "fixed", left: initialOffset.left, top: initialOffset.top
			user_card.removeClass "cpanel-navigation-goaway-right"
			@active_page = user_card
			setTimeout( ->
				user_card.attr "style", ""
			, 2000)
		, 100)
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
