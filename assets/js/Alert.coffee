class window.Alert
    constructor: (selector) ->
        @div = $ selector
        @div.on "click", @hide

    show: =>
        @div.slideDown(500).fadeTo 500, 1
        window.scrollTo 0, 0

    hide: =>
        @div.fadeTo(500, 0).slideUp 500
