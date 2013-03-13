require "./globals"

rest = new Restfull

# for i in [1..10]
# 	console.log i
# 	user = new User "User_#{i}"
# 	p = user.create()
# 	# k = i - 1;
# 	r = (k) ->
# 		p.done (data) -> console.log "#{k} added"
# 		p.error -> console.log "error", arguments
# 	r i

# p = rest.delete ["user"]
# p.done (data) -> console.log data
# p.error -> console.log "error", arguments


p = rest.get ["operator"]
p.done (data) -> console.log data
p.error -> console.log "error", arguments

p = rest.delete ["operator"]
p.done (data) ->
	console.log data
	p = rest.post ["index"],
		login: "root"
		password: "123Vjq123"
	p.done (data) ->
		console.log data
		p = rest.post ["index", "root"],
			password: "123Vjq123"
		p.done (data) ->
			console.log data
			p = rest.get ["user"], 
				limit: 10
				skip: 0
			p.done (data) -> console.log data
			p.error -> console.log "no users?", arguments
		p.error -> console.log "error?", arguments
	p.error -> console.log "error", arguments
p.error -> console.log "error", arguments
