ko.bindingHandlers.checkboxGroup =
    init: (element, valueAccessor, allBindings, data, context) ->
        array = valueAccessor().array
        index = valueAccessor().index()

        $element = $(element)

        $element.on "click", ->
            array()[index].checked = not array()[index].checked
            array.valueHasMutated()

        ko.computed disposeWhenNodeIsRemoved: element, read: ->
            $element.toggleClass "active", array()[index].checked
