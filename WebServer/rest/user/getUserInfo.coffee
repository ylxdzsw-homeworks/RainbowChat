module.exports = (index, kit) ->
	(req, res, next) ->
		kit.db.get('user').findOne {_id:req.params.id}, (err, doc) ->
			return next kit.util.makeError 500 if err?
			return next kit.util.makeError 404, "The user id queried is not exist", "USER_NOTEXIST" if not doc?
			return res.send username: doc._id, role: doc.role