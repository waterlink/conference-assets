onUpdate = (element, valueAccessor) ->
    value = valueAccessor()
    checkbox = "<i class='icon-ok'></i>"
    $(element).html if value() then checkbox else ""

ko.bindingHandlers.checkbox =
    init: onUpdate
    update: onUpdate
