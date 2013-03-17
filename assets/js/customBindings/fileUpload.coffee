ko.bindingHandlers.fileUpload =
    init: (element, valueAccessor, allBindingsAccessor, viewModel) ->
        args = valueAccessor()
        [files, options] = [args.files, args.options]
        $element = $ element
        [max, initialized] = [options.maxNumberOfFiles, no]

        initialize = ->
            $element.fileupload _.extend options,
                maxNumberOfFiles: (if max? then max - files().length + !!initialized else undefined)
                added: (e, data) -> files.push f for f in data.files
                # process: [
                #     action: "load"
                # ]
            initialized = yes

        initialize()

        viewModel.validate = (files) ->
            initialize()
            $element.fileupload "validate", files
