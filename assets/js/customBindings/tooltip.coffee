ko.bindingHandlers.tooltip =
	init: (element, valueAccessor) ->
		$element = $ element
		$element.attr "data-toggle", "tooltip"
		for k, v of valueAccessor()
			key = k.replace /_/g, "-"
			$element.attr "data-#{key}", v
		$element.tooltip()

module.exports = no
