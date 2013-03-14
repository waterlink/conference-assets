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
        @users = ko.observableArray [
            new UserViewModel name: "Иван", surname: "Петров", jobPosition: "Разработчик", jobTitle: "Microsoft", lectureTitle: "Как писать код", status: "new"
            new UserViewModel name: "Петр", surname: "Иванов", jobPosition: "Тестер", jobTitle: "Google", lectureTitle: "Как тестировать код", monographyTitle: "Как писать код", status: "emailsent"
            new UserViewModel name: "Джек", surname: "Воробей", jobPosition: "Пират", jobTitle: "Пираты карибского моря", lectureTitle: "Как научиться писать код", status: "paid"

        ]

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




