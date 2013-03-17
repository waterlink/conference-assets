global.UserViewModel = require "../assets/js/viewModels/UserViewModel"

class window.AdminViewModel
    constructor: ->
        @name = "Петя"
        @statuses = ko.observableArray [
            text: "new", checked: no
        ,
            text: "emailsent", checked: no
        ,
            text: "paid", checked: no
        ]
        @users = ko.observableArray []
        @search = ko.observable ""

    doSignOut: ->
        window.location.href = "registration.html"

    isFiltered: (text) ->
        allUnchecked = yes
        for status in @statuses()
            allUnchecked = no if status.checked
            return yes if status.text is text and status.checked
        allUnchecked

    readableStatus: (status) =>
        switch status
            when "new"
                "Новый"
            when "emailsent"
                "Ожидаем оплаты"
            when "paid"
                "Оплачен"

    doSearch: (data, event) =>
        if event.which is 13
            $("#search_query").blur()
            setTimeout( => 
                cpanel.loadUsers()
            , 30)
            event.preventDefault();
            false
        true


module.exports = window.AdminViewModel


