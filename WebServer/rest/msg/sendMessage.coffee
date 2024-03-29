module.exports = (index, kit) ->
	(req, res, next) ->
		{to,type,content} = req.body
		return next kit.util.makeError 400, "try to send a message without enough infomation", "LACKOF_INFO" if not to? or not content?
		return next kit.util.makeError 400, "try to submit a message of unknown type", "UNKNOWN_TYPE" if type not in ['chat','code']
		now = new Date()
		from=req.session.userinfo.username
		kit.db.get('msg').insert {to,type,content,from,date:now}, (err, doc) ->
			return next kit.util.makeError 500 if err?
			kit.pool[to] ?= {}
			if kit.pool[to][from]?
				i.send {to,type,content,from,date:now} for i in kit.pool[to][from].subscriber
			kit.pool[to][from] =
				lastUpdate: now
				subscriber: []
			res.sendStatus 200