module.exports = router = require('express').Router()
rest = require "./rest/index.js"
midl = require "./middleware/index.js"
conf = require "./config/index.js"

# User
router.get    '/user/:username', midl.parser.parseUsername, rest.user.getUserInfo
router.post   '/user',           rest.user.createNewUser

# Auth
router.post   '/auth',           rest.auth.login
router.delete '/auth',           midl.auth.loginRequired,   rest.auth.logout

# Message
router.get    '/msg',            midl.auth.loginRequired,   rest.msg.queryMessage
#router.get    '/msg/latest',  midl.auth.loginRequired,  rest.msg.listenMessage
router.post   '/msg',            midl.auth.loginRequired,   rest.msg.sendMessage

# Page
router.get '/', (req, res) ->
	res.render 'main.jade'