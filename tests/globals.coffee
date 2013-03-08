global.Backend = require "../classes/backend"
global.Restfull = require "../classes/restfull"
global.User = require "../classes/user"
_ = require "lodash"

global.beforeEachTest = ->
	@addMatchers
		toBeFunction: ->
			_.isFunction @actual
		toBeJson: (obj) ->
			if obj
				JSON.stringify(@actual) is JSON.stringify(obj)
			else
				{}.toString.call(@actual) is "[object Object]"
		toBeArray: ->
			@actual.length isnt undefined
		toBeInstanceOf: (obj) ->
				@actual instanceof obj
