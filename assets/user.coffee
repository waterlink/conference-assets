class User
	
	constructor: (@name = "", @surname = "", @patronymic = "", @participant = "", @status = "new") ->
		@backend = new Restfull

	create: ->
		url = @backend.post "user",
			name: @name
			surname: @surname
			patronymic: @patronymic
			participant: @participant
			status: @status
		@id = parseInt(url[1])
		true

	getById: (id) ->
		@backend.get ["user", "#{ id }"]

	list: ->
		@backend.get "user"

	listFiltered: (skip = undefined, limit = undefined) ->
		data = {}
		data.participant = @participant if @participant isnt undefined
		data.status = @status if @status isnt undefined
		data.skip = skip
		data.limit = limit
		@backend.get "user", data

	update: (id, status) ->
		@backend.put ["user", String(id)],
			status: status

	setup: (@backend) ->


module.exports = User
