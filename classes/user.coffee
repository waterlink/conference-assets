global.Restfull = require "../classes/restfull"

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

	fromData: (data) ->
		@id = data.id
		@name = data.name
		@surname = data.surname
		@patronymic = data.patronymic
		@participant = data.participant
		@academicDegree = data.academicDegree
		@academicTitle = data.academicTitle
		@jobPosition = data.jobPosition
		@jobPlace = data.jobPlace
		@city = data.city
		@country = data.country
		@postalAddress = data.postalAddress
		@email = data.email
		@phone = data.phone
		@participantType = data.participantType
		@lectureTitle = data.lectureTitle
		@sectionNumber = data.sectionNumber
		@monographyParticipant = data.monographyParticipant
		@stayDemand = data.stayDemand

	getData: ->
		res =
			name: @name
			surname: @surname
			patronymic: @patronymic
			participant: @participant
			status: @status
			academicDegree: @academicDegree
			academicTitle: @academicTitle
			jobPosition: @jobPosition
			jobPlace: @jobPlace
			city: @city
			country: @country
			postalAddress: @postalAddress
			email: @email
			phone: @phone
			participantType: @participantType
			lectureTitle: @lectureTitle
			sectionNumber: @sectionNumber
			monographyParticipant: @monographyParticipant
			stayDemand: @stayDemand

	create: -> @backend.post "user", @getData()

	getById: (id) -> @backend.get ["user", "#{ id }"]

	list: -> @backend.get "user"

	listFiltered: (skip = undefined, limit = undefined) ->
		data = {}
		data.participant = @participant if @participant isnt undefined
		data.status = @status if @status isnt undefined
		data.skip = skip
		data.limit = limit
		@backend.get "user", data

	update: (id, status) -> 
		console.log "updating user to status #{status}"
		@status = status
		@backend.put ["user", "#{id}"], @getData()

	setup: (@backend) ->

	setMonographyParticipant: (@monographyParticipant = true, @monographyTitle = "") ->

	setStayDemand: (@stayDemand = true, @stayStart = "", @stayEnd = "") ->


module.exports = User
