global.Restfull = require "../classes/restfull"

class window.UserViewModel
    constructor: (user) ->
        _.extend @, user

        @surname = ko.observable @surname
        @name = ko.observable @name
        @patronymic = ko.observable @patronymic

        @fullName = ko.computed
            read: => "#{@surname() or ''} #{@name() or ''} #{@patronymic() or ''}"
            write: (v) =>
                words = v.split(" ").filter (x) -> x
                @surname words[0] or @surname()
                @name words[1] or @name()
                @patronymic words[2] or @patronymic()

        @academicDegree = ko.observable @academicDegree
        @academicTitle = ko.observable @academicTitle
        @jobPosition = ko.observable @jobPosition
        @jobPlace = ko.observable @jobPlace
        @city = ko.observable @city
        @country = ko.observable @country
        @postalAddress = ko.observable @postalAddress
        @email = ko.observable @email
        @phone = ko.observable @phone
        @participantType = ko.observable @participantType
        @lectureTitle = ko.observable @lectureTitle
        @sectionNumber = ko.observable @sectionNumber
        @status = ko.observable @status
        @sent = ko.observable @sent

        @_stayStart = ko.observable if @stayStart then new Date @stayStart else ""
        @_stayEnd = ko.observable if @stayEnd then new Date @stayEnd else ""

        @extract = (d) -> [d.getMonth() + 1, d.getDate(), d.getFullYear()]

        @stayStart = ko.computed
            read: => if @_stayStart() then @extract(@_stayStart()).join '/'  else ""
            write: (v) => @_stayStart v

        @stayEnd = ko.computed
            read: => if @_stayEnd() then @extract(@_stayEnd()).join '/' else ""
            write: (v) => @_stayEnd v

        @stayPeriod = ko.computed => "#{@stayStart()} - #{@stayEnd()}"

        @z_thesisPay = ko.computed =>
            "#{searchData.thesisCost}#{searchData.costCurrency}"

        @z_organizationPay = ko.computed =>
            if @participantType() is "Очная" then "#{searchData.organizationCost}#{searchData.costCurrency}" else 0

        @z_monographyPay = ko.computed =>
            if @monographyParticipant and @monographyPay then "#{@monographyPay}#{searchData.costCurrency}" else 0


module.exports = window.UserViewModel
