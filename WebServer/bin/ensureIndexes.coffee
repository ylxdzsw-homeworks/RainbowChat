db = require('monk')("localhost/RainbowChat")
db.get('user').index 'username', {unique:true}, (err) ->
	if err?
		console.log err