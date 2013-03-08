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


