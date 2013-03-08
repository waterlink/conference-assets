class UserRegistrationViewModel
    constructor: ->
        @name = ko.observable ""
        @surname = ko.observable ""
        @patronymic = ko.observable ""
        @participant = ko.observable no

    doRegister: ->
        console.log "almost registered :)"
