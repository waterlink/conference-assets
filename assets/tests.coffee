User = require "./user"
Backend = require "./backend"
_ = require "lodash"

# why the hell "User class suite", we describe just "User" entity
describe "User", ->

	beforeEach ->
		@addMatchers
			toBeFunction: ->
				_.isFunction @actual

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

	it "should be possible to create new user", ->
		user = new User 'Alex', 'Fedorov', 'Konstantinovich', false
		expect(user.create()).toBeTruthy()


describe "Backend", ->

	beforeEach ->
		@addMatchers
			toBeFunction: ->
				_.isFunction @actual
			toBeJson: (obj) ->
				if obj
					JSON.stringify(@actual) is JSON.stringify(obj)
				else
					{}.toString.call(@actual) is "[object Object]"

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
			state: "new"
		expect(backend.lastRequest).toBeJson
			method: "post"
			url: "#{ backend.prefix }/user"
			data: 
				name: "Alex"
				surname: "Fedorov"
				patronymic: "Konstantinovich"
				participant: false
				state: "new"
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
			state: "new"
		backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Viktorovich"
			participant: false
			state: "emailsent"
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
			state: "new"
		backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Viktorovich"
			participant: false
			state: "emailsent"
		obj = backend.get "user"
		expect(obj.length).toBe(2)

	it "should modify when put with id", ->
		backend = new Backend
		backend.mockDB.user = []
		backend.mockDB.user.push
			id: 331
			name: "Alex"
			surname: "Fedorov"
			patronymic: "Konstantinovich"
			participant: false
			state: "new"
		backend.mockDB.user.push
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Viktorovich"
			participant: false
			state: "emailsent"
		res = backend.put ["user", "332"],
			name: "Maxim"
			surname: "Baz"
			patronymic: "Viktorovich"
			participant: false
			state: "paid"
		expect(res).toBeTruthy()
		obj = backend.get ["user", "332"]
		expect(obj).toBeJson
			id: 332
			name: "Maxim"
			surname: "Baz"
			patronymic: "Viktorovich"
			participant: false
			state: "paid"

	it "should return false when put without id", ->
		backend = new Backend
		backend.mockDB.user = []
		res = backend.put "user", ["hello", "world"]
		expect(res).toBeFalsy()

	# it "should "
