
global.$ = require "jquery"
global.XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest

global.domain = "http://conference.lan"

class Restfull extends Backend
	# List the URIs and perhaps other details of the collection's members.
	# filters by data
	# skip and limit keys are reserved
	getWithoutId: (entity, data) ->
		$.ajax
			url: "#{domain}#{@prefix}/#{entity}"
			type: "get"
			data: data
			dataType: "json"


	# Retrieve a representation of the addressed member of the collection, expressed in an appropriate Internet media type.
	getWithId: (entity, id, data) ->
		$.ajax
			url: "#{domain}#{@prefix}/#{entity}/#{id}"
			type: "get"
			data: data
			dataType: "json"

	# Replace the entire collection with another collection.
	putWithoutId: (entity, data) ->
		# we are not gonna to replace the entire collection, it is hazardous
		# but only for the sake of auth
		$.ajax
			url: "#{domain}#{@prefix}/#{entity}"
			type: "put"
			data: JSON.stringify data
			dataType: "json"

	# Replace the addressed member of the collection, or if it doesn't exist, create it.
	putWithId: (entity, id, data) ->
		$.ajax
			url: "#{domain}#{@prefix}/#{entity}/#{id}"
			type: "put"
			data: JSON.stringify data
			dataType: "json"

	# Create a new entry in the collection. The new entry's URI is assigned automatically and is usually returned by the operation.
	postWithoutId: (entity, data) ->
		$.ajax
			url: "#{domain}#{@prefix}/#{entity}"
			type: "post"
			data: JSON.stringify data
			dataType: "json"

	# Not generally used. Treat the addressed member as a collection in its own right and create a new entry in it.
	postWithId: (entity, id, data) ->
		# we are not going to make nested collections
		# but only for sake of auth
		$.ajax
			url: "#{domain}#{@prefix}/#{entity}/#{id}"
			type: "post"
			data: JSON.stringify data
			dataType: "json"

	# Delete the entire collection.
	deleteWithoutId: (entity, data) ->
		$.ajax
			url: "#{domain}#{@prefix}/#{entity}"
			type: "delete"
			data: JSON.stringify data
			dataType: "json"

	# Delete the addressed member of the collection.
	deleteWithId: (entity, id, data) ->
		$.ajax
			url: "#{domain}#{@prefix}/#{entity}/#{id}"
			type: "delete"
			data: JSON.stringify data
			dataType: "json"

	get: (url = "", data = {}) ->
		@_saveLastRequest "get", url, data
		[entity, id] = @_urlPartify url
		@_withId id, entity, data, @getWithId, @getWithoutId

	put: (url = "", data = {}) ->
		@_saveLastRequest "put", url, data
		[entity, id] = @_urlPartify url
		@_withId id, entity, data, @putWithId, @putWithoutId

	post: (url = "", data = {}) ->
		@_saveLastRequest "post", url, data
		[entity, id] = @_urlPartify url
		@_withId id, entity, data, @postWithId, @postWithoutId

	delete: (url = "", data = {}) ->
		@_saveLastRequest "delete", url, data
		[entity, id] = @_urlPartify url
		@_withId id, entity, data, @deleteWithId, @deleteWithoutId


module.exports = Restfull	

