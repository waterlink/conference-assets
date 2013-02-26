User = require "./user"
_ = require "lodash"

describe "User class suite", ->

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
