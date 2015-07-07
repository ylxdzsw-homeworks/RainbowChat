module.exports = (index, kit) ->
	(req, res, next) ->
		index.auth.loginRequired req, res, (err) ->
			return next err if err?
			if req.session.role isnt 'admin'
				next kit.util.makeError 403, "Admin required", "ADMIN_REQUIRED"
			else
				do next