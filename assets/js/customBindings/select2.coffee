ko.bindingHandlers.select2 =
    init: (element, valueAccessor) ->
        $(element).select2 valueAccessor()

        ko.utils.domNodeDisposal.addDisposeCallback element, ->
            $(element).select2 'destroy'

    update: (element) ->
        $(element).trigger 'change'
