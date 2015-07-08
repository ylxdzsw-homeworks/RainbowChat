module.exports = (index, kit) ->
	(req, res, next) ->
		req.session.destroy (err) -> # maybe only delete userinfo would be better
			if err?
				next kit.util.makeError 500, "destroy session failed"
			else
				res.sendStatus 200