module.exports = (index, kit) ->
	(req, res, next) ->
		{username,limit,date} = req.query
		return next kit.util.makeError 400, "query messages while not provide username", "USERNAME_REQUIRED" if not username?

		limit ?= 100
		limit = parseInt(limit)
		return next kit.util.makeError 400, "query limit not valid", "LIMIT_INVALID" if not limit > 0
		
		a = username
		b = req.session.userinfo.username

		query = {$or:[{from:a,to:b},{from:b,to:a}]}
		d = new Date(date)
		query.date = {$gt:d} if d.valueOf() is d.valueOf() # a trick to judge NaN, as NaN !== NaN

		kit.db.get('msg').find query, {limit,sort:{date:-1}}, (err,doc) ->
			if err?
				next kit.util.makeError 500, "query failed", "DATABASE_FAULT"
			else if not doc.length
				next kit.util.makeError 404, "messages not found", "MESSAGE_NOT_EXIST"
			else
				res.send doc # maybe should do .map (x) -> x.date = x.date.toJSON()