global.Restfull = require "../classes/restfull"
global.Auth = require "../classes/auth"

class window.PrintViewModel
    constructor: ->
        @rest = new Restfull
        @auth = new Auth @rest
        @auth.login
            ok: @loadData
            fail: @redirectToLogin

        @users = ko.observableArray()

    loadData: =>
        p = @rest.get "user"
        p.done (users) =>
            sortBy = (a, b) -> a.id > b.id
            @users.push new UserViewModel user for user in users.sort sortBy

    redirectToLogin: =>
        global.location = "login.html#print.html"



