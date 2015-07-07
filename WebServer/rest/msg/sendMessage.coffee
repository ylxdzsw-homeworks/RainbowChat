module.exports = (index, kit) ->
	(req, res, next) ->
		{to,type,content} = req.body
		return next kit.util.makeError 400, "try to send a message without enough infomation", "LACKOF_INFO" if not to? or not content?

		switch type
			when 'chat'
				# ...
			
		