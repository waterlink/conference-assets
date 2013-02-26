_ = require "lodash"


describe "hello", ->
	beforeEach ->
		@addMatchers
			toBeFunction: ->
				_.isFunction @actual
	it "should bga", ->
		# somefunc = -> console.log "bga"
		somefunc = "bgatest"
		expect(somefunc).toBeFunction()


# old_expect = null



# console.log expect

# expect = (obj) -> 
# 	result = old_expect obj
# 	result.isFunction = ->
# 		_.isFunction result
# 	result

# module.exports = expect
