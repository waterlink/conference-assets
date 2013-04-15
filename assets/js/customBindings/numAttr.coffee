ko.bindingHandlers.numAttr =
	init: (element, valueAccessor) ->
		$element = $ element
		for k, v of valueAccessor()
			key = k.replace /_/g, "-"
			element["#{key}"] = parseInt v()
			v.subscribe (value) => element["#{key}"] = parseInt value

module.exports = no
