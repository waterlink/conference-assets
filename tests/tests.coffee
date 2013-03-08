global.Backend = require "./backend"
global.Restfull = require "./restfull"
global.User = require "./user"
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

# why the hell "User class suite", we describe just "User" entity
describe "User", ->

	beforeEach -> beforeEachTest.apply(@)

	it "should exists", ->
		user = new User

	it "should have name, surname, patronymic, participant, status", ->
		user = new User
		expect(user.name).toBeDefined()
		expect(user.surname).toBeDefined()
		expect(user.patronymic).toBeDefined()
		expect(user.participant).toBeDefined()
		expect(user.status).toBeDefined()

	it "should have default status 'new'", ->
		user = new User
		expect(user.status).toBe "new"

	it "should be possible to pass attributes through constructor", ->
		user = new User 'Alex', 'Fedorov', 'Konstantinovich', false, "emailsent"
		expect(user.name).toBe "Alex"
		expect(user.surname).toBe "Fedorov"
		expect(user.patronymic).toBe "Konstantinovich"
		expect(user.participant).toBeFalsy()
		expect(user.status).toBe "emailsent"

	it "should have methods: create, getById, list, listFiltered, update", ->
		user = new User
		expect(user.create).toBeFunction()
		expect(user.getById).toBeFunction()
		expect(user.list).toBeFunction()
		expect(user.listFiltered).toBeFunction()
		expect(user.update).toBeFunction()

	it "should be possible to setup custom backend", ->
		user = new User
		user.setup new Backend
		expect(user.backend).toBeInstanceOf Backend

	it "should have restfull backend by default", ->
		user = new User
		expect(user.backend).toBeInstanceOf Backend
		expect(user.backend).toBeInstanceOf Restfull

	it "should be possible to create new user", ->
		user = new User 'Alex', 'Fedorov', 'Konstantinovich', false
		user.setup new Backend
		user.backend.delete "user"
		expect(user.create()).toBeTruthy()
		expect(user.backend.mockDB.user.length).toBe 1

	it "should store id when creating new user", ->
		user = new User 'Alex', 'Fedorov', 'Konstantinovich', false
		user.setup new Backend
		user.backend.delete "user"
		user.create()
		expect(user.id).toBeDefined()

	it "should be possible to get user by id", ->
		user = new User
		user.setup new Backend
		user.backend.delete "user"
		user.backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		user.backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
		res = user.getById 331
		expect(res).toBeJson
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"

	it "should be possible to get list of users in reverse chronological order", ->
		user = new User
		user.setup new Backend
		user.backend.delete "user"
		user.backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		user.backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
		res = user.list()
		expect(res.length).toBe 2
		expect(res[0].id).toBe 332
		expect(res[1].id).toBe 331

	it "should be possible to use skip/limit filters", ->
		user = new User
		user.setup new Backend
		user.backend.delete "user"
		user.backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		user.backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
		user.backend.mockDB.user.push
			id: 333
			name: "Ivan"
			surname: "Ivanov"
			patronymic: "Ivanovich"
			participant: false
			status: "emailsent"
		user.backend.mockDB.user.push
			id: 334
			name: "Vasya"
			surname: "Pupkin"
			patronymic: "Emailovich"
			participant: false
			status: "emailsent"
		user.backend.mockDB.user.push
			id: 335
			name: "Petya"
			surname: "Petrov"
			patronymic: "Petrovich"
			participant: false
			status: "emailsent"
		user.backend.mockDB.user.push
			id: 336
			name: "Ekaterina"
			surname: "Новгородская"
			patronymic: "Ивановна"
			participant: false
			status: "emailsent"
		user.status = undefined
		user.participant = undefined
		res = user.listFiltered 2, 3
		expect(res.length).toBe 3
		expect(res[0].id).toBe 335
		expect(res[1].id).toBe 334
		expect(res[2].id).toBe 333

	it "should be possible to use participant and status filters", ->
		user = new User
		user.setup new Backend
		user.backend.delete "user"
		user.backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		user.backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: true
			status: "new"
		user.backend.mockDB.user.push
			id: 333
			name: "Ivan"
			surname: "Ivanov"
			patronymic: "Ivanovich"
			participant: true
			status: "paid"
		user.backend.mockDB.user.push
			id: 334
			name: "Vasya"
			surname: "Pupkin"
			patronymic: "Emailovich"
			participant: true
			status: "paid"
		user.backend.mockDB.user.push
			id: 335
			name: "Petya"
			surname: "Petrov"
			patronymic: "Petrovich"
			participant: false
			status: "new"
		user.backend.mockDB.user.push
			id: 336
			name: "Ekaterina"
			surname: "Новгородская"
			patronymic: "Ивановна"
			participant: false
			status: "emailsent"
		user.status = "new"
		user.participant = false
		res = user.listFiltered()
		expect(res.length).toBe 2
		expect(res[0].id).toBe 335
		expect(res[1].id).toBe 331

	it "should be possible to update object", ->
		user = new User
		user.setup new Backend
		user.backend.delete "user"
		user.backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		user.backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
		user.update 331, "emailsent"
		res = user.getById 331
		expect(res.status).toBe "emailsent"

	it "should have academicDegree", ->
		user = new User
		expect(user.academicDegree).toBeDefined()

	it "should have academicTitle", ->
		user = new User
		expect(user.academicTitle).toBeDefined()

	it "should have jobPosition", ->
		user = new User
		expect(user.jobPosition).toBeDefined()

	it "should have jobPlace", ->
		user = new User
		expect(user.jobPlace).toBeDefined()

	it "should have city", ->
		user = new User
		expect(user.city).toBeDefined()

	it "should have country", ->
		user = new User
		expect(user.country).toBeDefined()

	it "should have postalAddress", ->
		user = new User
		expect(user.postalAddress).toBeDefined()

	it "should have email", ->
		user = new User
		expect(user.email).toBeDefined()

	it "should have phone", ->
		user = new User
		expect(user.phone).toBeDefined()

	it "should have participantType", ->
		user = new User
		expect(user.participantType).toBeDefined()

	it "should have lectureTitle", ->
		user = new User
		expect(user.lectureTitle).toBeDefined()

	it "should have sectionNumber", ->
		user = new User
		expect(user.sectionNumber).toBeDefined()

	it "should have monographyParticipant", ->
		user = new User
		expect(user.monographyParticipant).toBeDefined()

	it "should have setMonographyParticipant method", ->
		user = new User
		expect(user.setMonographyParticipant).toBeFunction()

	it "should have monographyTitle if monographyParticipant is true", ->
		user = new User
		expect(user.monographyTitle).toBeUndefined()
		user.setMonographyParticipant true
		expect(user.monographyTitle).toBeDefined()

	it "should have stayDemand", ->
		user = new User
		expect(user.stayDemand).toBeDefined()

	it "should have setStayDemand method", ->
		user = new User
		expect(user.setStayDemand).toBeFunction()

	it "should have stayStart and stayEnd if stayDemand is true", ->
		user = new User
		expect(user.stayStart).toBeUndefined()
		expect(user.stayEnd).toBeUndefined()
		user.setStayDemand true
		expect(user.stayStart).toBeDefined()
		expect(user.stayEnd).toBeDefined()


describe "Backend", ->

	beforeEach -> beforeEachTest.apply(@)

	it "should exists", ->
		backend = new Backend

	it "should have rest methods", ->
		backend = new Backend
		expect(backend.get).toBeFunction()
		expect(backend.put).toBeFunction()
		expect(backend.post).toBeFunction()
		expect(backend.delete).toBeFunction()

	it "should have attribute authenticatedAs", ->
		backend = new Backend
		expect(backend.authenticatedAs).toBeDefined()

	it "should have authenticatedAs = guest by default", ->
		backend = new Backend
		expect(backend.authenticatedAs).toBe "guest"

	it "should have default prefix /api", ->
		backend = new Backend
		expect(backend.prefix).toBe "/api"

	it "should save last request info: method, url, data", ->
		backend = new Backend
		backend.get ["user", "127"]
		expect(backend.lastRequest).toBeJson
			method: "get"
			url: "#{ backend.prefix }/user/127",
			data: {}
		backend.put ["user", "33"],
			name: "Illya"
		expect(backend.lastRequest).toBeJson
			method: "put"
			url: "#{ backend.prefix }/user/33"
			data:
				name: "Illya"
		backend.post "user",
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		expect(backend.lastRequest).toBeJson
			method: "post"
			url: "#{ backend.prefix }/user"
			data:
				name: "Alex"
				surname: "Fedorov"
				patronymic: "Konstantinovich"
				participant: false
				status: "new"
		backend.delete ["user", "37"]
		expect(backend.lastRequest).toBeJson
			method: "delete"
			url: "#{ backend.prefix }/user/37"
			data: {}

	it "should return object when get with id and with exactly that id", ->
		backend = new Backend
		backend.mockDB.user = []
		backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
		obj = backend.get ["user", "331"]
		expect(obj).toBeJson()
		expect(obj.id).toBe(331)

	it "should return list when get without id", ->
		backend = new Backend
		backend.mockDB.user = []
		backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
		obj = backend.get "user"
		expect(obj.length).toBe(2)
		expect(obj[0].id).toBe 332
		expect(obj[1].id).toBe 331

	it "shouldnt reverse inner data when get without id but only result", ->
		backend = new Backend
		backend.mockDB.user = []
		backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
		obj = backend.get "user"
		expect(obj.length).toBe(2)
		expect(obj[0].id).toBe 332
		expect(obj[1].id).toBe 331
		obj = backend.get "user"
		expect(obj.length).toBe(2)
		expect(obj[0].id).toBe 332
		expect(obj[1].id).toBe 331

	it "should modify when put with id", ->
		backend = new Backend
		backend.mockDB.user = []
		backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
		res = backend.put ["user", "332"],
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "paid"
		expect(res).toBeTruthy()
		obj = backend.get ["user", "332"]
		expect(obj).toBeJson
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "paid"

	it "should return false when put without id", ->
		backend = new Backend
		backend.mockDB.user = []
		res = backend.put "user", ["hello", "world"]
		expect(res).toBeFalsy()

	it "should return false when post with id", ->
		backend = new Backend
		expect(backend.post ["user", "123"]).toBeFalsy()

	it "should create new entry when post without id", ->
		backend = new Backend
		backend.mockDB.user = []
		res = backend.post "user",
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
		expect(res).toBeArray()
		expect(res.length).toBe 2
		found = backend.get res
		expect(found).toBeJson
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
			id: parseInt res[1]

	it "should wipe entire collection when delete without id", ->
		backend = new Backend
		backend.mockDB.user = []
		backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
		expect(backend.delete "user").toBeTruthy()
		expect(backend.mockDB.user.length).toBe 0

	it "should remove one object when delete with id", ->
		backend = new Backend
		backend.mockDB.user = []
		backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			status: "new"
		backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"
		expect(backend.delete ["user", "331"]).toBeTruthy()
		expect(backend.mockDB.user.length).toBe(1)
		expect(backend.mockDB.user[0]).toBeJson
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Vitalievich"
			participant: false
			status: "emailsent"


