global.Restfull = require "../classes/restfull"

class window.PrintViewModel
    constructor: ->
        @rest = new Restfull
        @users = ko.observableArray()

        p = @rest.get "user"
        p.done (users) =>
            sortBy = (a, b) -> a.id > b.id
            @users.push new UserViewModel user for user in users.sort sortBy



