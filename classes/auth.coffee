class Auth
    constructor: (@rest) ->

    login: (callbacks) ->
        p = @rest.get "index"
        p.error callbacks.fail
        p.done (data) =>
            if data and data.whois
                @whois = data.whois
                @group = data.group
                callbacks.ok()
            else
                callbacks.fail()

module.exports = Auth
