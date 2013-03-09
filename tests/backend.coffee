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
		backend.authenticatedAs = 'admin'
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
		backend.authenticatedAs = 'admin'
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
		backend.authenticatedAs = 'admin'
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
		backend.authenticatedAs = 'admin'
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
		backend.authenticatedAs = 'admin'
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
		backend.authenticatedAs = 'admin'
		backend.mockDB.user = []
		res = backend.put "user", ["hello", "world"]
		expect(res).toBeFalsy()

	it "should return false when post with id", ->
		backend = new Backend
		backend.authenticatedAs = 'admin'
		expect(backend.post ["user", "123"]).toBeFalsy()

	it "should create new entry when post without id", ->
		backend = new Backend
		backend.authenticatedAs = 'admin'
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
		backend.authenticatedAs = 'admin'
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
		backend.authenticatedAs = 'admin'
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

	it "should return access denied error when guest trying to access not user collection", ->
		backend = new Backend
		backend.mockDB.operator = []
		backend.mockDB.operator.push
			id: 1
			login: 'admin'
			password: 'admin'
			isAdmin: true
		backend.mockDB.operator.push
			id: 2
			login: 'operator'
			password: 'operator'
			isAdmin: false
		expect(backend.authenticatedAs).toBe('guest')
		expect( ->
			res = backend.get "operator"
		).toThrow "Access denied"

	# seems to be wrong rule
	xit "should not return acccess denied error when guest trying to access index collection", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.index.push
			id: 1
			bga: 'test'
		res = backend.get "index"
		expect(res.length).toBe(1)
		expect(res[0]).toBeJson 
			id: 1
			bga: 'test'

	it "should be allowed for [guest] to [post with id] to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.index.push
			id: 1
			bga: 'test'
		# expect( ->
		# 	backend.get "index"
		# ).toThrow "Access denied"
		# expect( ->
		# 	backend.get ["index", "1"]
		# ).toThrow "Access denied"

		# expect( ->
		# 	backend.put "index"
		# ).toThrow "Access denied"
		# expect( ->
		# 	backend.put ["index", "1"]
		# ).toThrow "Access denied"

		# expect( ->
		# 	backend.post "index"
		# ).toThrow "Access denied"
		
		res = backend.post ["index", "operator"], 
			password: "operator"

		# expect( ->
		# 	backend.delete "index"
		# ).toThrow "Access denied"
		# expect( ->
		# 	backend.delete ["index", "1"]
		# ).toThrow "Access denied"

	it "should be disallowed for [guest] to [get] to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.index.push
			id: 1
			bga: 'test'
		expect( ->
			backend.get "index"
		).toThrow "Access denied"
		expect( ->
			backend.get ["index", "1"]
		).toThrow "Access denied"

	it "should be disallowed for [guest] to [put] to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.index.push
			id: 1
			bga: 'test'
		expect( ->
			backend.put "index"
		).toThrow "Access denied"
		expect( ->
			backend.put ["index", "1"]
		).toThrow "Access denied"

	it "should be disallowed for [guest] to [delete] to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.index.push
			id: 1
			bga: 'test'
		expect( ->
			backend.delete "index"
		).toThrow "Access denied"
		expect( ->
			backend.delete ["index", "1"]
		).toThrow "Access denied"

	it "should be disallowed for [guest] to [post without id] to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.index.push
			id: 1
			bga: 'test'
		expect( ->
			backend.post "index"
		).toThrow "Access denied"

	it "should be allowed for [guest] to [post without id] to user", ->
		backend = new Backend
		backend.mockDB.user = []
		backend.post "user",
			name: "Alex"
		expect(backend.mockDB.user.length).toBe 1
		expect(backend.mockDB.user[0]).toBeJson
			name: "Alex"
			id: 1

	it "should be disallowed for [guest] to [post with id] to user", ->
		backend = new Backend
		backend.mockDB.user = []
		expect( ->
			backend.post ["user", "332"],
				name: "Alex"
		).toThrow "Access denied"


	# <block>
	# it should be allowed for [operator] to [post with id, get, put without id, delete] to index

	it "should be allowed for [operator] to [post with id] to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.authenticatedAs = "operator"
		backend.post ["index", "operator"],
			password: "operator"

	it "should be allowed for [operator] to [get] to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.authenticatedAs = "operator"
		backend.get "index"
		backend.get ["index", "operator"]

	it "should be allowed for [operator] to [put without id] to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.authenticatedAs = "operator"
		backend.put "index",
			hello: "world"

	it "should be allowed for [operator] to [delete] to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.authenticatedAs = "operator"
		backend.delete "index"
		backend.authenticatedAs = "operator"
		backend.delete ["index", "557"]

	it "should be disallowed for [operator] to [post without id] to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.authenticatedAs = "operator"
		expect( ->
			backend.post "index"
		).toThrow "Access denied"

	it "should be disallowed for [operator] to [put with id] to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.authenticatedAs = "operator"
		expect( ->
			backend.put ["index", "557"]
		).toThrow "Access denied"

	# </block>

	# <block>
	# it should change authenticatedAs when post to index/#{operator.login}

	it "should change authenticatedAs when post to index/{operator.login}", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.operator = []
		backend.mockDB.operator.push
			login: "waterlink"
			password: "helloworld"
			isAdmin: true
		backend.mockDB.operator.push
			login: "fedorov"
			password: "password"
			isAdmin: false
		expect(backend.authenticatedAs).toBe "guest"
		backend.post ["index", "fedorov"],
			password: "password"
		expect(backend.authenticatedAs).toBe "operator"
		backend.post ["index", "waterlink"],
			password: "helloworld"
		expect(backend.authenticatedAs).toBe "admin"

	it "should be disallowed to authenticate as non-existant operator", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.operator = []
		backend.mockDB.operator.push
			login: "waterlink"
			password: "helloworld"
			isAdmin: true
		backend.mockDB.operator.push
			login: "fedorov"
			password: "password"
			isAdmin: false
		expect( ->
			backend.post ["index", "bgatest"],
				password: "bgatest"
		).toThrow "Access denied"
		expect(backend.authenticatedAs).toBe "guest"

	it "should be disallowed to authenticated with wrong password", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.operator = []
		backend.mockDB.operator.push
			login: "waterlink"
			password: "helloworld"
			isAdmin: true
		backend.mockDB.operator.push
			login: "fedorov"
			password: "password"
			isAdmin: false
		expect( ->
			backend.post ["index", "waterlink"],
				password: "bgatest"
		).toThrow "Access denied"
		expect( ->
			backend.post ["index", "fedorov"],
				password: "bgatest"
		).toThrow "Access denied"
		expect(backend.authenticatedAs).toBe "guest"

	# </block>

	it "should return group of current operator: one of [operator, admin] when get index", ->
		# will return json: {whois: "{operator.login}", group: "{list of [guest, operator, admin]}"}
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.operator = []
		backend.mockDB.operator.push
			login: "waterlink"
			password: "helloworld"
			isAdmin: true
		backend.mockDB.operator.push
			login: "fedorov"
			password: "password"
			isAdmin: false
		backend.post ["index", "fedorov"],
			password: "password"
		expect(backend.get "index").toBeJson
			whois: "fedorov"
			group: ["operator"]
		backend.post ["index", "waterlink"],
			password: "helloworld"
		expect(backend.get "index").toBeJson
			whois: "waterlink"
			group: ["operator", "admin"]

	it "should change password when put without id to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.operator = []
		backend.mockDB.operator.push
			login: "waterlink"
			password: "helloworld"
			isAdmin: true
		backend.mockDB.operator.push
			login: "fedorov"
			password: "password"
			isAdmin: false
		backend.post ["index", "fedorov"],
			password: "password"
		backend.put "index",
			old_password: "password"
			new_password: "bgatest"
		expect(backend.mockDB.operator[1]).toBeJson
			login: "fedorov"
			password: "bgatest"
			isAdmin: false
		@authenticatedAs = "guest"
		expect( ->
			backend.post ["index", "fedorov"],
				password: "password"
		).toThrow "Access denied"
		backend.post ["index", "fedorov"],
			password: "bgatest"
		expect(backend.authenticatedAs).toBe "operator"
		expect(backend.get "index").toBeJson
			whois: "fedorov"
			group: ["operator"]

	it "should logoff when delete index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.operator = []
		backend.mockDB.operator.push
			login: "waterlink"
			password: "helloworld"
			isAdmin: true
		backend.mockDB.operator.push
			login: "fedorov"
			password: "password"
			isAdmin: false
		backend.post ["index", "fedorov"],
			password: "password"
		backend.delete "index"
		expect(backend.authenticatedAs).toBe "guest"

	it "should be allowed for [admin] to [*all methods*] to *", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.user = []
		backend.mockDB.operator = []
		backend.mockDB.operator.push
			login: "waterlink"
			password: "helloworld"
			isAdmin: true
		backend.mockDB.operator.push
			login: "fedorov"
			password: "password"
			isAdmin: false
		backend.post ["index", "waterlink"],
			password: "helloworld"
		# get group
		backend.get "user"
		backend.get ["user", "331"]
		backend.get "operator"
		backend.get ["operator", "331"]
		# post group
		backend.post "user"
		backend.post ["user", "331"]
		backend.post "operator"
		backend.post ["operator", "331"]
		# put group
		backend.put "user"
		backend.put ["user", "331"]
		backend.put "operator"
		backend.put ["operator", "331"]
		# delete group
		backend.delete "user"
		backend.delete ["user", "331"]
		backend.delete "operator"
		backend.delete ["operator", "331"]

	it "should reset password to new when put with id = operator.login to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.operator = []
		backend.mockDB.operator.push
			login: "waterlink"
			password: "helloworld"
			isAdmin: true
		backend.mockDB.operator.push
			login: "fedorov"
			password: "password"
			isAdmin: false
		backend.post ["index", "waterlink"],
			password: "helloworld"
		backend.put ["index", "fedorov"],
			new_password: "bgatest"
		expect( ->
			backend.post ["index", "fedorov"],
				password: "password"
		).toThrow "Access denied"
		backend.post ["index", "fedorov"],
			password: "bgatest"
		expect(backend.whois).toBe "fedorov"

	it "should register new operator when post without id to index", ->
		backend = new Backend
		backend.mockDB.index = []
		backend.mockDB.operator = []
		backend.mockDB.operator.push
			login: "waterlink"
			password: "helloworld"
			isAdmin: true
		backend.mockDB.operator.push
			login: "fedorov"
			password: "password"
			isAdmin: false
		backend.post ["index", "waterlink"],
			password: "helloworld"
		backend.post "index",
			login: "alex"
			password: "bgatest"
		expect(backend.mockDB.operator.length).toBe 3
		expect(backend.mockDB.operator[2]).toBeJson
			login: "alex"
			password: "bgatest"
			isAdmin: false
		backend.post ["index", "alex"],
			password: "bgatest"
		expect(backend.whois).toBe "alex"
		expect(backend.authenticatedAs).toBe "operator"
		backend.delete "index"
		expect(backend.whois).toBeUndefined
		expect(backend.authenticatedAs).toBe "guest"


