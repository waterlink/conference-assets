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

	listFiltered: ->

	update: ->

	setup: (@backend) ->


module.exports = User
