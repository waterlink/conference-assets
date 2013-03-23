global.UserViewModel = require "../assets/js/viewModels/UserViewModel"
global.OperatorViewModel = require "../assets/js/viewModels/OperatorViewModel"

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

        @isAdmin = ko.computed => "admin" in cpanel.group

        @operators = ko.observableArray []
        if @isAdmin()
            cpanel.loadOperators()

        @addingOperator = ko.observable false
        @operatorLogin = ko.observable ""
        @operatorPassword = ko.observable ""
        @operatorConfirmPassword = ko.observable ""

        @backToUsersLeftIsHidden = ko.observable yes
        @backToUsersRightIsHidden = ko.observable yes

        @activeUser = ko.observable no

        @searchData = global.searchData
        @anotherWrapper = (what) => "Другое (#{what})"
        @selectQuery = (searchData, anotherAllowed = yes) => (query) =>
            data = @searchData[searchData].filter (x) -> x.toLowerCase().match query.term.toLowerCase()
            data.push @anotherWrapper query.term if anotherAllowed
            query.callback 
                results: $.map data, (x) ->
                    obj =
                        id: x
                        text: x
        @selectOptions = (searchData, defaultValue = no) =>
            data = @searchData[searchData]
            if defaultValue
                unless defaultValue in data
                    data.push defaultValue
            data


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

    goOperatorPage: =>
        return if cpanel.operator_page

        $("#operators_li").addClass "active"
        @initialOffset = $("#user_page").offset()

        if cpanel.active_page
            cpanel.active_page.addClass "cpanel-navigation-goaway-right"
            cpanel.active_page = undefined
            $('.hidden-page').remove()
            $("#user_page").removeClass "cpanel-navigation-goaway-left"

        $("#user_page").addClass "cpanel-navigation-goaway-right"

        setTimeout =>
            operator_page = $ ".operator-page .container"
            operator_page.css position: "fixed", left: @initialOffset.left, top: @initialOffset.top
            operator_page.removeClass "cpanel-navigation-goaway-left"
            cpanel.operator_page = operator_page
            setTimeout ->
                operator_page.attr "style", ""
            , 500
            @backToUsersRightIsHidden no
            @backToUsersLeftIsHidden  yes
        , 50

    newOperator: =>
        @addingOperator true

    confirmAddOperator: (d, e) =>
        if @operatorPassword() isnt @operatorConfirmPassword()
            alert "Пароли не совпадают!"
            return
        $(e.target).button "loading"
        p = cpanel.rest.post "index",
            login: @operatorLogin()
            password: @operatorPassword()
        p.done (data) =>
            $(e.target).button "reset"
            @cancelAddOperator()
            if data and data.error
                alert data.error
            else
                cpanel.loadOperators()

    cancelAddOperator: =>
        @addingOperator false
        @operatorLogin ""
        @operatorPassword ""
        @operatorConfirmPassword ""

    doBackToUsersRight: =>
        $("#user_page").css position: "fixed", left: @initialOffset.left, top: @initialOffset.top
        $("#user_page").removeClass "cpanel-navigation-goaway-right"
        $("#user_page").removeClass "cpanel-navigation-goaway-left"

        cpanel.operator_page = $ ".operator-page .container"
        if cpanel.operator_page.length
            $("#operators_li").removeClass "active"
            cpanel.operator_page.addClass "cpanel-navigation-goaway-left"
            cpanel.operator_page = undefined

        setTimeout ->
            $("#user_page").attr "style", ""
        , 500

        @backToUsersRightIsHidden yes

    doBackToUsersLeft: =>
        $("#user_page").css position: "fixed", left: @initialOffset.left, top: @initialOffset.top
        $("#user_page").removeClass "cpanel-navigation-goaway-left"

        if cpanel.active_page
            cpanel.active_page.addClass "cpanel-navigation-goaway-right"
            cpanel.active_page = undefined

        setTimeout ->
            $("#user_page").attr "style", ""
        , 500

        @backToUsersLeftIsHidden yes

    isActive: (id) => @activeUser() is id

module.exports = window.AdminViewModel


