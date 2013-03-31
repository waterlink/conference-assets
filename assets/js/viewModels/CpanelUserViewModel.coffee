global.Restfull = require "../classes/restfull"
global.UserViewModel = require "../assets/js/viewModels/UserViewModel"

class window.CpanelUserViewModel extends window.UserViewModel
    constructor: (user) ->
        super user
        @default = user

        @_monographyParticipant = ko.observable @monographyParticipant
        @monographyParticipant = ko.computed
            read: => @_monographyParticipant() and @_monographyParticipant() isnt "0"
            write: (v) => @_monographyParticipant v
        @monographyTitle = ko.observable @monographyTitle or ""

        @_stayDemand = ko.observable @stayDemand
        @stayDemand = ko.computed
            read: => @_stayDemand() and @_stayDemand() isnt "0"
            write: (v) => @_stayDemand v

        @locStatus = ko.computed => 
            res = "#{statuses[@status()]}"
            if @status() is "new"
                res += " (к оплате: #{@thesisPay}"
                # console.log @monographyParticipant
                if @monographyParticipant()
                    res += " + #{@monographyPay}"
                res += " #{searchData.costCurrency})"
            res

        @mailto = ko.computed => "mailto:#{@email}"

        @nextStatus = ko.computed =>
            statuses[statusGraph.next[@status()]]

        @prevStatus = ko.computed =>
            statuses[statusGraph.prev[@status()]]

        @fullJob = ko.computed =>
            "#{@jobPosition} в #{@jobPlace} г. #{@city}, #{@country}"

        @z_monographyTitle = ko.computed =>
            @monographyTitle()
        @z_stayStart = ko.computed =>
            @stayStart() #.replace /T.*/, ""
        @z_stayEnd = ko.computed =>
            @stayEnd() #.replace /T.*/, ""

        @isMonographyParticipant = ko.computed =>
            @monographyParticipant() and @monographyParticipant() isnt "0"
        @isStayDemand = ko.computed =>
            @stayDemand and @stayDemand isnt "0"

        @z_participantType = ko.computed =>
            @participantType or ""

        @downloadLink = ko.computed => "/uploads/download/#{@id}"

        @isNew = ko.computed => @status() is "new"

    details: -> cpanel.userDetails @id

    goNextStatus: ->
        nextAction = statusGraph.next[@status()]
        if nextAction
            p = cpanel.userStatus @id, nextAction
            $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "loading"
            onError = => $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "error"
            p.done (e) =>
                return onError() if e and e.error
                user = new User
                p = user.getById @id
                p.done (user) =>
                    return onError() if not user or user.error
                    @status user.status
                    $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "reset"
                p.error onError
            p.error onError

    goPrevStatus: ->
        prevAction = statusGraph.prev[@status()]
        if prevAction
            p = cpanel.userStatus @id, prevAction
            $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "loading"
            onError = => $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "error"
            p.done (e) =>
                return onError() if e and e.error
                user = new User
                p = user.getById @id
                p.done (user) =>
                    return onError() if not user or user.error
                    @status user.status
                    $(".user-table-row[user_id=\"#{@id}\"] .user-actions .dropdown-toggle").button "reset"
                p.error onError
            p.error onError

    getData: ->
        res =
            name: @name()
            surname: @surname()
            patronymic: @patronymic()
            participant: @participant
            status: @status()
            academicDegree: @academicDegree()
            academicTitle: @academicTitle()
            jobPosition: @jobPosition()
            jobPlace: @jobPlace()
            city: @city()
            country: @country()
            postalAddress: @postalAddress()
            email: @email()
            phone: @phone()
            participantType: @participantType()
            lectureTitle: @lectureTitle()
            sectionNumber: @sectionNumber()
            monographyParticipant: @monographyParticipant()
            stayDemand: @stayDemand()
            uploadId: @uploadId
        if @monographyParticipant()
            res["monographyTitle"] = @monographyTitle()
        if @stayDemand()
            res["stayStart"] = @stayStart()
            res["stayEnd"] = @stayEnd()
        for k of res
            if res[k] is undefined or res[k] is "" or res[k] is null
                res[k] = @default[k]
        res

    doSave: (d, e) ->
        console.log @getData()
        $e = $ e.target
        $e.button "loading"
        rest = new Restfull
        p = rest.put ["user", "#{@id}"], @getData()
        p.done (e) =>
            if e and e.error
                alert e.error
            $e.button "reset"

module.exports = window.CpanelUserViewModel
