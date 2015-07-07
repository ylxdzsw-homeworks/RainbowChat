module.exports = Index = {}
require 'fs'
	.readdirSync __dirname
	.filter (x) -> x isnt 'index.js'
	.map (x) -> x.match(/(.*)\.js$/)[1]
	.map (x) ->
		Index[x] = require("#{__dirname}/#{x}.js")(Index)