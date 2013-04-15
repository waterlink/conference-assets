require "../classes/restfull"
global.Geoip = require "../classes/geoip"

class window.RegistrationViewModel
    constructor: ->
        @start = new Date
        @end   = new Date
        @start.setDate @start.getDate() - 7
        @end.setDate   @end.getDate()   + 7

        @thesisPay = => return @mainCost()
        @monographyPay = => return @totalCost() - @mainCost()

        @conference = {}

        @conference.dates = ko.observable "1-4 октября 2013 г."
        @conference.fullTitle = ko.observable "ІV Международная научно-практическая конференция «РЕФЛЕКСИВНЫЕ ПРОЦЕССЫ И УПРАВЛЕНИЕ В ЭКОНОМИКЕ»"
        @conference.title = ko.computed => "#{@conference.fullTitle()} #{@conference.dates()}"
        @conference.registrationTitle = ko.computed => "Регистрация - #{@conference.title()}"
        @conference.shortTitleSource = ko.observable "РЕФЛЕКСИВНЫЕ ПРОЦЕССЫ И УПРАВЛЕНИЕ В ЭКОНОМИКЕ"
        @conference.shortTitle = ko.computed => "#{@conference.shortTitleSource()} #{@conference.dates()}"
        @conference.monographyMin = ko.observable 10
        @conference.monographyMax = ko.observable 15
        @conference.costByMonographyPage = ko.observable 25

        rest = new Restfull
        p = rest.get "settings"
        p.done (data) =>
            if data and data.error
                alert data.error
            else if data
                @conference.dates data.dates
                @conference.fullTitle data.fullTitle
                @conference.shortTitleSource data.shortTitleSource
                @conference.monographyMin data.monographyMin
                @conference.monographyMax data.monographyMax
                @conference.costByMonographyPage data.costByMonographyPage

        @monographyPages = ko.observable @conference.monographyMin()
        @user =
            name                  : ko.observable ""
            surname               : ko.observable ""
            patronymic            : ko.observable ""
            academicDegree        : ko.observable ""
            academicTitle         : ko.observable ""
            jobPosition           : ko.observable ""
            jobPlace              : ko.observable ""
            city                  : ko.observable ""
            country               : ko.observable "Украина"
            postalAddress         : ko.observable ""
            email                 : ko.observable ""
            phone                 : ko.observable ""
            participantType       : ko.observable ""
            lectureTitle          : ko.observable ""
            sectionNumber         : ko.observable ""
            monographyParticipant : ko.observable no
            monographyTitle       : ko.observable ""
            # monographyPages       : ko.observable @conference.monographyMin()
            monographyPages       : ko.computed => parseInt @monographyPages()
            stayDemand            : ko.observable no
            stayStart             : ko.observable new Date @start
            stayEnd               : ko.observable new Date @end
            thesisPay             : ko.observable 0
            monographyPay         : ko.observable 0

        @files = new FilesViewModel
        # @files = ko.observable false
        @searchData = window.searchData

        @errors = ko.validation.group @user
        @errorAlert = new Alert "#needFixErrors"

        @rest = new Restfull ""
        # p = @rest.get "uploads/id"
        # p.done (upload) => @files new FilesViewModel upload.id
        # p.error (err) =>
        #     console.log err
        #     alert err

        @anotherWrapper = (what) => "Другое (#{what})"

        @selectQuery = (searchData, anotherAllowed = yes) => (query) =>
            data = @searchData[searchData].filter (x) -> x.toLowerCase().match query.term.toLowerCase()
            data.push @anotherWrapper query.term if anotherAllowed
            query.callback 
                results: $.map data, (x) ->
                    obj =
                        id: x
                        text: x

        @detected = ko.observable {}
        @geoipWrapper = (v, t) -> 
            # console.log "Определено (#{v})"
            if t is "city"
                return "Город (#{v})"
            else
                return "Страна (#{v})"
        @geoip = new Geoip (detected) =>
            setTimeout =>
                # console.log detected
                detect = @detected()
                detect.country = @geoipWrapper(detected.country, "country")
                detect.city = @geoipWrapper(detected.city, "city")
                @detected detect
                @user.country @geoipWrapper(detected.country, "country")
                @user.city @geoipWrapper(detected.city, "city")
                $city = $ "#city"
                $city.select2 "val", "detected_city"
                $country = $ "#country"
                $country.select2 "val", "detected_country"
            , 1000

        @defaultInitSelection = (element, callback) =>
            $element = $ element
            val = $element.val()
            if val.match "detected_"
                detected = val.replace "detected_", ""
                data =
                    id: "detected"
                    text: @detected()[detected]
            else
                data =
                    id: val
                    text: val
            callback data

        @detectDiscarded = (key) => ko.computed =>
            # console.log "detectDiscarded: ", @user[key](), @detected()[key]
            return true if @user[key]()
            return true unless @detected()[key]
            return false

        @z_participantType = ko.computed =>
            # unless @user.participantType()
                # return "Очная"
            return @user.participantType()

        @mainCost = ko.computed =>
            return @searchData.costByParticipantType[@z_participantType()]

        @totalCost = ko.computed =>
            cost = @mainCost()
            if @user.monographyParticipant()
                cost += @conference.costByMonographyPage() * @user.monographyPages()

    doRegister: ->
        @addValidation() #unless @hasValidation

        if @errors().length is 0
            # console.log ko.mapping.toJS @user
            # return
            @user.thesisPay @thesisPay()
            @user.monographyPay @monographyPay()
            creating = new User
            creating.fromData ko.mapping.toJS @user
            creating.uploadId = @files.uploadId()
            unless @detectDiscarded("city")()
                creating.city = @detected().city
            unless @detectDiscarded("country")()
                creating.country = @detected().country
            creating.participantType = @z_participantType()
            console.log creating.getData()
            # return
            p = creating.create()
            button = $ ".form-signin .btn-primary"
            button.button "loading"
            p.done (data) ->
                if data
                    if data.error
                        # ::TODO::
                        # тут хотелось бы парсануть ошибку и вывести ее
                        # вроде должна возникать коллизия только по email
                        # если такой уже зареган
                        alert data.error
                        button.button "reset"
                        return
                button.button "reset"
                global.location = "success.html"
        else
            @errorAlert.show()
            @errors.showAllMessages()

    isAvailableDateToStay: (date) =>
        console.log date
        true

    addValidation: ->
        @makeFieldsRequired()
        @hasValidation = yes

    makeFieldsRequired: ->
        console.log "validation?"
        for key, value of @user when value.extend?
            isRequired = yes

            if key in ["stayStart", "stayEnd"]
                isRequired = onlyIf: @user.stayDemand

            if key in ["monographyTitle", "monographyPages"]
                isRequired = onlyIf: @user.monographyParticipant

            if key in ["city", "country"]
                isRequired = onlyIf: @detectDiscarded key

            isRequired = no if key in ["monographyParticipant", "stayDemand", "monographyPages"]

            # unless @hasValidation
            value?.extend required: isRequired

            # if key is "monographyPages"
                # value?.extend required: no

        @user.stayDemand.subscribe (value) =>
            ko.validation.validateObservable @user.stayStart
            ko.validation.validateObservable @user.stayEnd

        @user.monographyParticipant.subscribe (value) =>
            ko.validation.validateObservable @user.monographyTitle
            # ko.validation.validateObservable @user.monographyPages

        @detected.subscribe (value) =>
            # ko.validation.validateObservable @city
            # ko.validation.validateObservable @country
            @makeFieldsRequired()

        @user.city.subscribe (value) =>
            # ko.validation.validateObservable @city
            # ko.validation.validateObservable @country
            @makeFieldsRequired()

        @user.country.subscribe (value) =>
            # ko.validation.validateObservable @city
            # ko.validation.validateObservable @country
            @makeFieldsRequired()

