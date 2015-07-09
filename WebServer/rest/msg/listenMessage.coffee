module.exports = (index, kit) ->
	(req, res, next) ->
		{date,username} = req.body
		from = req.session.userinfo.username
		date = new Date(date)
		return next kit.util.makeError 400, "Invalid Date", "DATE_INVALID" if d.valueOf() isnt d.valueOf() # a trick to judge NaN, as NaN !== NaN
		kit.pool[from] ?= {}
		if (p=kit.pool[from][username])?
			if p.lastUpdate > date
				res.send err: "SYNC_FAILED"
			else
				p.subscriber.push res
		else
			kit.pool[from][username] =
				subscriber: [res]
