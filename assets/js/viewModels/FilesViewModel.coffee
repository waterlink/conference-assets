class window.FilesViewModel
    constructor:  ->
        @data = ko.observableArray()

    formatSize: (bytes) ->
        [KB, MB, GB] = [1024, 1024*1024, 1024*1024*1024]
        if typeof bytes isnt 'number'
            ""
        else if bytes >= GB
            "#{(bytes / GB).toFixed 2} GB"
        else if bytes >= MB
            "#{(bytes / MB).toFixed 2} MB"
        else if bytes >= KB
            "#{(bytes / KB).toFixed 2} KB"
        else
            "#{bytes} B"

    remove: (file) ->
        @data.remove file
        f.error = "" for f in @data()
        @validate @data()

    localize: (text) ->
        switch text
            when "Filetype not allowed"
                ko.validation.rules.fileUpload.fileTypeNotAllowed
            when "Maximum number of files exceeded"
                ko.validation.rules.fileUpload.numberOfFilesExceeded
            when "File is too small"
                ko.validation.rules.fileUpload.fileTooSmall
            when "File is too big"
                ko.validation.rules.fileUpload.fileTooBig

    validate: ->
        # ugly hack, filled by custom binder
