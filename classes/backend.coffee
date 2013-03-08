
isArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

auth = (restMethod) -> (method) -> ->
	[entity, id] = @_urlPartify arguments[0]
	data = arguments[1]
	if @authenticatedAs is 'guest'
		if entity not in ['user', 'index']
			throw new Error 'Access denied'

	strategy =
		get: =>
			if @authenticatedAs is 'guest'
				throw new Error 'Access denied'
			if entity in ["index"]
				if not id
					group = ["operator"]
					if @authenticatedAs isnt "operator"
						group.push @authenticatedAs
					if @whois
						res =
							whois: @whois
							group: group
		post: =>
			if @authenticatedAs is 'guest'
				if entity in ['user']
					throw new Error('Access denied') if id
				if entity in ['index']
					if not id
						throw new Error 'Access denied'
			if @authenticatedAs is "operator"
				if entity in ["index"]
					if not id
						throw new Error 'Access denied'
			if entity in ["index"]
				if id
					if @mockDB.operator
						found = @mockDB.operator.filter (obj) -> 
							obj.password is data.password and obj.login is id
						if found.length
							operator = found[0]
							@whois = operator.login
							@authenticatedAs = 'operator'
							@authenticatedAs = 'admin' if operator.isAdmin
						else throw new Error "Access denied"
				else
					if @authenticatedAs is "admin"
						if not @mockDB.operator
							@mockDB.operator = []
						data.isAdmin = false
						@mockDB.operator.push data
		put: =>
			if @authenticatedAs is 'guest'
				throw new Error 'Access denied'
			if @authenticatedAs is "operator"
				if entity in ["index"]
					if id
						throw new Error "Access denied"
					if @mockDB.operator
						found = @mockDB.operator.filter (obj) => 
							obj.password is data.old_password and obj.login is @whois
						if found.length
							operator = found[0]
							operator.password = data.new_password
						else throw new Error "Access denied"
			if @authenticatedAs is "admin"
				if entity in ["index"]
					if id
						if @mockDB.operator
							found = @mockDB.operator.filter (obj) => 
								obj.login is id
							if found.length
								operator = found[0]
								operator.password = data.new_password
		delete: =>
			if @authenticatedAs is 'guest'
				throw new Error 'Access denied'
			if entity in ["index"]
				@authenticatedAs = "guest"
				@whois = undefined

	result = strategy[restMethod]()
	if result
		return result

	method.apply @, arguments


class Backend
	
	constructor: (@prefix = "/api")->
		@authenticatedAs = 'guest'
		@mockDB = {}


	_saveLastRequest: (method, url, data) ->
		if isArray url
			url = url.join "/"
		@lastRequest =
			method: method
			url: "#{ @prefix }/#{ url }"
			data: data
		false

	_urlPartify: (url) ->
		if not isArray url
			url.split '/'
		else
			url

	_withId: (id, entity, data, withId, withoutId) ->
		if not id
			withoutId.apply @, [entity, data]
		else
			withId.apply @, [entity, id, data]
		

	# List the URIs and perhaps other details of the collection's members.
	# filters by data
	# skip and limit keys are reserved
	getWithoutId: (entity, data) ->
		# @mockDB[entity][..].reverse()
		skip = data.skip
		delete data.skip
		limit = data.limit
		delete data.limit
		skiplimitsum = skip + limit
		if not skiplimitsum
			skiplimitsum = undefined
		res = @mockDB[entity].filter (obj) ->
			flag = true
			for k, v of data
				if obj[k] isnt v
					flag = false
					break
			flag
		res[skip...skiplimitsum].reverse()

	# Retrieve a representation of the addressed member of the collection, expressed in an appropriate Internet media type.
	getWithId: (entity, id, data) ->
		if @mockDB[entity] 
			for obj in @mockDB[entity] when String(obj.id) == id
				return obj

	# Replace the entire collection with another collection.
	putWithoutId: (entity, data) ->
		# we are not gonna to replace the entire collection, it is hazardous
		false

	# Replace the addressed member of the collection, or if it doesn't exist, create it.
	putWithId: (entity, id, data) ->
		if @mockDB[entity]
			for obj in @mockDB[entity] when String(obj.id) == id
				for k, v of data
					obj[k] = v
				return true
			data.id = id
			@mockDB[entity].push data
			true

	# Create a new entry in the collection. The new entry's URI is assigned automatically and is usually returned by the operation.
	postWithoutId: (entity, data) ->
		if @mockDB[entity]
			maxid = 0
			for obj in @mockDB[entity]
				if maxid < obj.id
					maxid = obj.id
			maxid += 1
			data.id = maxid
			@mockDB[entity].push data
			[entity, "#{ maxid }"]

	# Not generally used. Treat the addressed member as a collection in its own right and create a new entry in it.
	postWithId: (entity, id, data) ->
		# we are not going to make nested collections
		false

	# Delete the entire collection.
	deleteWithoutId: (entity, data) ->
		@mockDB[entity] = []
		true

	# Delete the addressed member of the collection.
	deleteWithId: (entity, id, data) ->
		if @mockDB[entity]
			@mockDB[entity] = @mockDB[entity].filter (obj) ->
				String(obj.id) != id
			true

	get: auth('get') (url = "", data = {}) ->
		@_saveLastRequest "get", url, data
		[entity, id] = @_urlPartify url
		@_withId id, entity, data, @getWithId, @getWithoutId

	put: auth('put') (url = "", data = {}) ->
		@_saveLastRequest "put", url, data
		[entity, id] = @_urlPartify url
		@_withId id, entity, data, @putWithId, @putWithoutId

	post: auth('post') (url = "", data = {}) ->
		@_saveLastRequest "post", url, data
		[entity, id] = @_urlPartify url
		@_withId id, entity, data, @postWithId, @postWithoutId

	delete: auth('delete') (url = "", data = {}) ->
		@_saveLastRequest "delete", url, data
		[entity, id] = @_urlPartify url
		@_withId id, entity, data, @deleteWithId, @deleteWithoutId


module.exports = Backend
