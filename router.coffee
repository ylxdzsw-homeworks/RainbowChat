module.exports = router = require('express').Router()
rest = require "./rest/index.js"
midl = require "./middleware/index.js"
conf = require "./config/index.js"

# User
#router.get '/user/:id', rest.user.getUserInfo

# Page
router.get '/', (req, res) ->
	res.render 'main.jade'