ko.bindingHandlers.select2 =
    init: (element, valueAccessor) ->
        $(element).select2 valueAccessor()

        ko.utils.domNodeDisposal.addDisposeCallback element, ->
            $(element).select2 'destroy'

    update: (element) ->
        $(element).trigger 'change'

ko.bindingHandlers.select2Default =
	init: (element, valueAccessor) ->
		setTimeout ->
			console.log "setting default value: ", valueAccessor()
			$element = $ element
			$element.select2 "val", valueAccessor()
		, 50
