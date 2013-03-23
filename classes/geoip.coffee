class Geoip
	constructor: (@handler, @url = "http://ru.smart-ip.net/geoip-json?lang=ru") ->
		$.ajax
			url: @url
			dataType: "jsonp"
			success: @callback
	callback: (data) =>
		console.log data
		@country = data.countryName
		@city = data.city
		@handler
			country: @country
			city: @city

module.exports = Geoip
