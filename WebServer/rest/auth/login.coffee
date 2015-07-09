module.exports = (index, kit) ->
	(req, res, next) ->
		{username,password} = req.body
		return next kit.util.makeError 400, "lack enough infomation to login", "LACKOF_INFO" if not username? or not password?

		kit.db.get('user').findOne {username:username}, (err,doc) ->
			return next kit.util.makeError 500, "query failed", "DATABASE_FAULT" if err?
			if not doc?
				next kit.util.makeError 404, "try login a nonexist user", "USER_NOTFOUND"
			else if password is doc.password
				req.session.userinfo = doc
				res.send doc.username
			else
				next kit.util.makeError 403, "login with incorrect password", "PASSWORD_INCORRECT"