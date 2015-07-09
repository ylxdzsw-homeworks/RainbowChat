module.exports = (index, kit) ->
	(req, res, next) ->
		{to,type,content} = req.body
		return next kit.util.makeError 400, "try to send a message without enough infomation", "LACKOF_INFO" if not to? or not content?
		return next kit.util.makeError 400, "try to submit a message of unknown type", "UNKNOWN_TYPE" if type not in ['chat','code']
		now = new Date()
		kit.db.get('msg').insert {to,type,content,from:req.session.userinfo.username,date:now}, (err, doc) ->
			return next kit.util.makeError 500 if err?
			if kit.pool[to]?
				i.send {to,type,content,date} for i in kit.pool[to].subscriber
			kit.pool[to] =
				lastUpdate: now
				subscriber: []
			res.sendStatus 200