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
            # тут мы еще вообще не понимаем? и кстати, где поле ? =)
            participantType       : ko.observable ""
            lectureTitle          : ko.observable ""
            sectionNumber         : ko.observable ""
            monographyParticipant : ko.observable no
            monographyTitle       : ko.observable ""
            monographyPages       : ko.observable 1
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
        @geoipWrapper = (v) -> 
            console.log "Определено (#{v})"
            return "Определено (#{v})"
        @geoip = new Geoip (detected) =>
            setTimeout =>
                # console.log detected
                detect = @detected()
                detect.country = @geoipWrapper(detected.country)
                detect.city = @geoipWrapper(detected.city)
                @detected detect
                @user.country @geoipWrapper(detected.country)
                @user.city @geoipWrapper(detected.city)
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
            unless @user.participantType()
                return "Очная"
            return @user.participantType()

        @mainCost = ko.computed =>
            return @searchData.costByParticipantType[@z_participantType()]

        @totalCost = ko.computed =>
            cost = @mainCost()
            if @user.monographyParticipant
                cost += @searchData.costByMonographyPage * @user.monographyPages()

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

            isRequired = no if key in ["monographyParticipant", "stayDemand"]

            # unless @hasValidation
            value?.extend required: isRequired

        @user.stayDemand.subscribe (value) =>
            ko.validation.validateObservable @user.stayStart
            ko.validation.validateObservable @user.stayEnd

        @user.monographyParticipant.subscribe (value) =>
            ko.validation.validateObservable @user.monographyTitle
            ko.validation.validateObservable @user.monographyPages

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

