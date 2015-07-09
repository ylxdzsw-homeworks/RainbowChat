module.exports = (index, kit) ->
	(req, res, next) ->
		return next kit.util.makeError 400, "request not contain username, while it is required", "USERNAME_REQUIRED" if not req.params.id
		if req.params.id is "me"
			if (id = req.session.userinfo?._id)?
				req.body.id = id
				do next
			else
				next kit.util.makeError 403, "use 'me' for username whthout logged in", "LOGIN_REQUIRED"
		else
			req.body.id = id
			do next