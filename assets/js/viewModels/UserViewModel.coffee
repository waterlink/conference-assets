class window.UserViewModel
    constructor: (user) ->
        _.extend @, user

        @fullName = ko.computed =>
            "#{@surname or ''} #{@name or ''} #{@patronymic or ''}"

        @status = ko.observable @status

        @locStatus = ko.computed => statuses[@status()]

        @mailto = ko.computed => "mailto:#{@email}"

        @nextStatus = ko.computed => 
            statuses[statusGraph.next[@status()]]

        @prevStatus = ko.computed =>
            statuses[statusGraph.prev[@status()]]

    details: -> cpanel.userDetails @id

    goNextStatus: ->
        nextAction = statusGraph.next[@status()]
        if nextAction
            p = cpanel.userStatus @id, nextAction
            $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "loading"
            onError = => $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "error"
            p.done (e) =>
                return onError() if e and e.error
                user = new User
                p = user.getById @id
                p.done (user) =>
                    return onError() if not user or user.error
                    @status user.status
                    $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "reset"
                p.error onError
            p.error onError

    goPrevStatus: ->
        prevAction = statusGraph.prev[@status()]
        if prevAction
            p = cpanel.userStatus @id, prevAction
            $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "loading"
            onError = => $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "error"
            p.done (e) =>
                return onError() if e and e.error
                user = new User
                p = user.getById @id
                p.done (user) =>
                    return onError() if not user or user.error
                    @status user.status
                    $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "reset"
                p.error onError
            p.error onError

module.exports = window.UserViewModel
