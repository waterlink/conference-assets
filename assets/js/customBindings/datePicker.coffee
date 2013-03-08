ko.bindingHandlers.datepicker =
    init: (element, valueAccessor, allBindingsAccessor) ->
        options = allBindingsAccessor().datepickerOptions

        isValid = -> true

        if options?.start? and options?.end?
            isValid = (date) ->
                value = date.valueOf()
                value >= options.start.valueOf() and value <= options.end.valueOf()

            customization =
                onRender: (date) ->
                    if isValid date then "" else "disabled"

        $(element).datepicker customization

        ko.utils.registerEventHandler element, "changeDate", (event) ->
            value = valueAccessor()
            if isValid(event.date) and ko.isObservable value
                value event.date
                $(element).datepicker "hide"

        ko.utils.registerEventHandler element, "change", ->
            value = valueAccessor()
            date = new Date element.value
            if isValid(date) and ko.isObservable value
                value date

    update: (element, valueAccessor) ->
        widget = $(element).data "datepicker"
        if widget
            widget.date = ko.utils.unwrapObservable valueAccessor()
            return unless widget.date

            if _.isString widget.date
                widget.date = new Date widget.date

            widget.setValue widget.date
