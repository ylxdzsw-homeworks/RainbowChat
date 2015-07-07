module.exports = Index = {}

require 'fs'
	.readdirSync __dirname
	.filter (x) -> x isnt 'index.js'
	.map (x) -> x.match(/(.*)\..*$/)[1]
	.forEach (x) ->
		Index[x] = require("#{__dirname}/#{x}")