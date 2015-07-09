module.exports = (index, kit) ->
	(req, res, next) ->
		return next kit.util.makeError 400, "request not contain username, while it is required", "USERNAME_REQUIRED" if not req.params.username
		if req.params.username is "me"
			if (username = req.session.userinfo?.username)?
				req.body.username = username
				do next
			else
				next kit.util.makeError 403, "use 'me' for username whthout logged in", "LOGIN_REQUIRED"
		else
			req.body.username = username
			do next