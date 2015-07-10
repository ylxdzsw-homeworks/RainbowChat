React = require 'react'
mui   = require 'material-ui'
ThemeManager = new mui.Styles.ThemeManager()

module.exports = React.createClass
	childContextTypes:
		muiTheme: React.PropTypes.object
	getChildContext: ->
		muiTheme: ThemeManager.getCurrentTheme()
	getInitialState: ->
		userinput: ''
	onUserInput: (e) ->
		@setState userinput: e.target.value
	onSend: ->
		$.ajax
			method: 'POST'
			url: '/msg'
			data:
				to: @props.currentChatter
				type: 'chat'
				content: @state.userinput
			success: (a,b,c) ->
				console.log a
			error: (a,b,c) ->
				alert "failed"
	render: ->
		<div>
			<mui.TextField
				onChange={@onUserInput}
				multiLine
				/>
			<mui.FlatButton 
				label="Send"
				secondary
				onClick={@onSend}
				/>
		</div>