React = require 'react'
mui   = require 'material-ui'
ThemeManager = new mui.Styles.ThemeManager()

standardActions = [
  { text: 'Cancel' },
  { text: 'Submit', onTouchTap: @onSubmit, ref: 'submit' }
]

module.exports = React.createClass
	childContextTypes:
		muiTheme: React.PropTypes.object
	getChildContext: ->
		muiTheme: ThemeManager.getCurrentTheme()
	render: ->
		<div>
			<mui.RaisedButton label="Log in" secondary onTouchTap={@props.onLogin}/>
			<mui.RaisedButton label="Sign up" primary onTouchTap={@props.onSignup}/>
		</div>
		<mui.Dialog
			title="Log in"
			actions={standardActions}
			actionFoucus="submit"
			modal="true">
		</mui.Dialog>
