kit =
	db: require('monk')("localhost/international")
	util: require('../util/index')
	config: require('../config/index')

module.exports = Index = {}

(fs = require 'fs')
	.readdirSync __dirname
	.filter (x) -> x isnt 'index.js'
	.forEach (x) ->
		Index[x] = {}
		fs.readdirSync "#{__dirname}/#{x}"
			.map (x) -> x.match(/(.*)\.js$/)[1]
			.forEach (y) ->
				Index[x][y] = require("#{__dirname}/#{x}/#{y}.js")(Index,kit)