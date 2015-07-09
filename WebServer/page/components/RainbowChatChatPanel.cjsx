React = require 'react'
mui   = require 'material-ui'
ThemeManager = new mui.Styles.ThemeManager()

module.exports = React.createClass
	onRetrive: ->
		$.ajax
			method: 'GET'
			url: "/msg"
			data:
				username: 'fuck'
			success: (a,b,c) ->
				console.log a
				console.log b
				console.log c
			error: ->
				alert 'fuck'
	render: ->
		<div>
			<mui.Menu
				menuItems={@props.message.map (x) ->
					text: x.from
					data: x.content
				}
				/>
			<mui.FlatButton 
				label="Retrive"
				secondary
				onClick={@onRetrive}
				/>
		</div>