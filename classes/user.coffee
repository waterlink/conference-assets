class User
	
	constructor: (@name = "", @surname = "", @patronymic = "", @_deprecated_participant = "", @status = "new") ->
		@backend = new Restfull
		@academicDegree = ""
		@academicTitle = ""
		@jobPosition = ""
		@jobPlace = ""
		@city = ""
		@country = ""
		@postalAddress = ""
		@email = ""
		@phone = ""
		@participantType = ""
		@lectureTitle = ""
		@sectionNumber = ""
		@monographyParticipant = false
		@stayDemand = false

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

	setMonographyParticipant: (@monographyParticipant = true, @monographyTitle = "") ->

	setStayDemand: (@stayDemand = true, @stayStart = "", @stayEnd = "") ->


module.exports = User
