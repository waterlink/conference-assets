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
        @page = ko.observable 0
        @userCount = ko.observable 0
        @users = ko.observableArray []
        @search = ko.observable ""

        @prevPageClass = ko.computed =>
            return "btn disabled" if @page() is 0
            return "btn"

        @nextPageClass = ko.computed =>
            return "btn disabled" if @userCount() < global.cpanelPageLimit
            return "btn"

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

    nextPage: =>
        if @userCount() is global.cpanelPageLimit
            cpanel.page++
            @page cpanel.page
            cpanel.filter.skip += global.cpanelPageLimit
            cpanel.loadUsers()

    prevPage: =>
        if @page() > 0
            cpanel.page--
            @page cpanel.page
            cpanel.filter.skip -= global.cpanelPageLimit
            cpanel.loadUsers()


module.exports = window.AdminViewModel


