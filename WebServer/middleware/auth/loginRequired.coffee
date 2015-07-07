module.exports = (index, kit) ->
	(req, res, next) ->
		if not req.session?.role?
			next kit.util.makeError 403, "Login required", "LOGIN_REQUIRED"
		else
			do next