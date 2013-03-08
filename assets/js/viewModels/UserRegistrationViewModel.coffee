class window.UserRegistrationViewModel
    constructor: ->
        @user = @addValidation
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
            stayDemand            : ko.observable no
            stayStart             : ko.observable ""
            stayEnd               : ko.observable ""

        @errors = ko.validation.group(@user)

        @errorAlert = new Alert "#needFixErrors"

    doRegister: ->
        if @errors().length is 0
            console.log ko.mapping.toJS @user
        else
            @errorAlert.show()
            @errors.showAllMessages()

    addValidation: (user) ->
        @makeFieldsRequired user
        user.email.extend email: yes
        user

    makeFieldsRequired: (user) ->
        for key, value of user
            isRequired = yes

            if key in ["stayStart", "stayEnd"]
                isRequired = onlyIf: user.stayDemand

            if key is "monographyTitle"
                isRequired = onlyIf: user.monographyParticipant

            isRequired = no if key in ["monographyParticipant", "stayDemand"]

            value.extend required: isRequired

        user.stayDemand.subscribe (value) ->
            ko.validation.validateObservable user.stayStart
            ko.validation.validateObservable user.stayEnd

        user.monographyParticipant.subscribe (value) ->
            ko.validation.validateObservable user.monographyTitle

