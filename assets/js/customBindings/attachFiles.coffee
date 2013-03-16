ko.bindingHandlers.attachFiles =
    init: (element, valueAccessor, allBindingsAccessor) ->
        files = valueAccessor()

        $(element).fileupload
            drop:   (e, data) -> files.push f for f in data.files
            change: (e, data) -> files data.files

