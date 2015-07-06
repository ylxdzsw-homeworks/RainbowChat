module.exports = (index, kit) ->
	(req, res, next) ->
		data = []
		query = (cb) ->
			if req.body.id # find user by it's ID
				kit.db.get 'user'
					.findById id, (err, doc) ->
						if err
							next kit.util.makeError 500, err.message ? 'error at findUser'
						if not doc.length
							next kit.util.makeError 404
						data = doc
						do cb
			else
				throw new Error 'todo'
		send = () ->
			if req.body.field # specified field that returns
				if data.every((x) -> x[req.body.field]?)
					res.json if data.length is 1
							data[0][req.body.field]
						else
							temp = {}
							data.forEach (x) ->
								temp[x._id] = x[req.body.field]
							data
				else
					next kit.util.makeError 404
			else
				res.json data
		query -> send()