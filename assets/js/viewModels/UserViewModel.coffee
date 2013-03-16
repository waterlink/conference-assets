class window.UserViewModel
    constructor: (user) ->
        _.extend @, user

        @fullName = ko.computed =>
            "#{@surname or ''} #{@name or ''} #{@patronymic or ''}"

        @job = ko.computed =>
            "#{@jobPosition or ''} в #{@jobTitle or ''}"

        @monography = ko.computed =>
            @monographyTitle or "-"

        @downloadLink = ko.computed =>
            "http://google.com?q=архивчик"


