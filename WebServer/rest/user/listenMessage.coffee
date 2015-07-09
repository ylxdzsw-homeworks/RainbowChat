module.exports = (index, kit) ->
	(req, res, next) ->
		{date}     = req.body
		{username} = req.session.userinfo
		date = new Date(date)
		return next kit.util.makeError 400, "Invalid Date", "DATE_INVALID" if d.valueOf() isnt d.valueOf() # a trick to judge NaN, as NaN !== NaN

		if (p=kit.pool[username])?
			if p.lastUpdate > date
				res.send err: "SYNC_FAILED"
			else
				p.subscriber.push res
		else
			kit.pool[username] =
				subscriber: [res]
