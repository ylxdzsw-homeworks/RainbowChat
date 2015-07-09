module.exports = (index, kit) ->
	(req, res, next) ->
		infos = (username = req.body.username)? and (password = req.body.password)?
		return next kit.util.makeError 400, "try to create a new user without enough infomation", "LACKOF_INFO" if not infos
		
		# TODO: do more validation here
		return next kit.util.makeError 400, "username too short", "USERNAME_TOOSHORT" if not username.length > 4
		
		kit.db.get('user').insert {username:username, password, role: 'user'}, (err, doc) ->
			console.log req.body
			if err?
				switch err.code
					when 11000
						return next kit.util.makeError 400, "try to add a user with existed user name", "USER_EXIST"
					else
						return next kit.util.makeError 500, "insert failed", "DATABASE_FAULT"
			res.sendStatus 200
				