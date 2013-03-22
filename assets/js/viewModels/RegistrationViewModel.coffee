require "../classes/restfull"

class window.RegistrationViewModel
    constructor: ->
        @start = new Date
        @end   = new Date
        @start.setDate @start.getDate() - 7
        @end.setDate   @end.getDate()   + 7

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
            stayDemand            : ko.observable no
            stayStart             : ko.observable new Date @start
            stayEnd               : ko.observable new Date @end

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

    doRegister: ->
        @addValidation() unless @hasValidation

        if @errors().length is 0
            console.log ko.mapping.toJS @user
            creating = new User
            creating.fromData ko.mapping.toJS @user
            creating.uploadId = @files.uploadId()
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
        for key, value of @user when value.extend?
            isRequired = yes

            if key in ["stayStart", "stayEnd"]
                isRequired = onlyIf: @user.stayDemand

            if key is "monographyTitle"
                isRequired = onlyIf: @user.monographyParticipant

            isRequired = no if key in ["monographyParticipant", "stayDemand"]

            value?.extend required: isRequired

        @user.stayDemand.subscribe (value) =>
            ko.validation.validateObservable @user.stayStart
            ko.validation.validateObservable @user.stayEnd

        @user.monographyParticipant.subscribe (value) =>
            ko.validation.validateObservable @user.monographyTitle
