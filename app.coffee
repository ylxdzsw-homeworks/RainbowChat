express = require 'express'
morgan = require 'morgan'
favicon = require 'serve-favicon'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'
mongoStore = require('connect-mongo') session
router = require './router'
fs = require 'fs'
util = require './util/index'

accessLogFile = fs.createWriteStream "#{__dirname}/log/access.log", flag: 'a'
errorLogFile = fs.createWriteStream "#{__dirname}/log/error.log", flag: 'a'

app = express()

app.use favicon "#{__dirname}/page/favicon.ico"
app.use morgan 'dev' if app.get('env') is 'development'
app.use morgan 'combined', stream: accessLogFile if app.get('env') is 'production'

app.use bodyParser.json()
app.use bodyParser.urlencoded extended: no
app.use cookieParser()

app.use session
	secret: 'RainbowChat'
	store: new mongoStore db: 'RainbowChat'
	cookie: maxAge: 5*24*60*60*1000 # 5 Day
	proxy: on
	resave: on
	saveUninitialized: yes

app.set 'view engine', 'jade'
app.set 'views', "#{__dirname}/page"
if app.get('env') is 'development'
	app.set 'view cache', off
	app.set 'trust proxy', 1

app.use router

app.use "/page", express.static "#{__dirname}/page"

app.use (req, res, next) ->
	next util.makeError 404

app.use (err, req, res, next) ->
	errorLogFile.write "[#{new Date()}] - #{err.message}\n\t#{err.stack}\n", 'utf-8'
	next err

app.use (err, req, res, next) ->
	res.status err.status
		.send err.response ? err.info

module.exports = app