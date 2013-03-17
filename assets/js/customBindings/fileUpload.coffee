ko.bindingHandlers.fileUpload =
    init: (element, valueAccessor, allBindingsAccessor, viewModel) ->
        args = valueAccessor()
        [files, options] = [args.files, args.options]
        $element = $ element
        [max, initialized] = [options.maxNumberOfFiles, no]

        initialize = ->
            $element.fileupload _.extend options,
                maxNumberOfFiles: (if max? then max - files().length + !!initialized else undefined)
                added: (e, data) -> 
                    for f in data.files
                        f.loaded = ko.observable "0%"
                        files.push f
                process: [
                    action: "load"
                ]
                progress: (e, data) =>
                    for f in data.files
                        f.loaded parseInt(data.loaded * 100 / data.total, 10) + "%"
            initialized = yes

        initialize()

        viewModel.validate = (files) ->
            initialize()
            $element.fileupload "validate", files
