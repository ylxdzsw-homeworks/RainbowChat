module.exports = (index, kit) ->
	(req, res, next) ->
		{date,username} = req.query
		from = req.session.userinfo.username
		console.log date
		date = new Date(date)
		console.log date
		return next kit.util.makeError 400, "Invalid Date", "DATE_INVALID" if date.valueOf() isnt date.valueOf() # a trick to judge NaN, as NaN !== NaN
		kit.pool[from] ?= {}
		if (p=kit.pool[from][username])?
			if p.lastUpdate > date
				res.send err: "SYNC_FAILED"
			else
				p.subscriber.push res
		else
			kit.pool[from][username] =
				subscriber: [res]
