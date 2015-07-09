React = require 'react'
mui   = require 'material-ui'
ThemeManager = new mui.Styles.ThemeManager()

LoginDialog = React.createClass
	render: ->
		<mui.Dialog
			title="Log in"
			actions={[
				{text: 'Cancel'},
				{text: 'Submit', onTouchTap: @onLoginSubmit}
			]}
			actionFoucus="submit"
			ref="loginDialog"
			modal>
		</mui.Dialog>

SignupDialog = React.createClass
	getInitialState: ->
		username: ''
		password: ''
		repassword: ''

	onSubmit: ->
		$.ajax
			method: "POST"
			url: "/user"
			data:
				username: @state.username
				password: @state.password
			header:
				'Content-Type': 'Application/json'
			success: (a,b,c) ->
				console.log a
				console.log b
				console.log c
			error: (a,b,c) ->
				alert "fuck"



	onUsernameChange: (e) ->
		@setState username: e.target.value

	onPasswordChange: (e) ->
		@setState password: e.target.value

	onRepasswordChange: (e) ->
		@setState repassword: e.target.value

	# Method
	show: ->
		@refs.dialog.show()

	render: ->
		<mui.Dialog
			title="Sign Up"
			actions={[
				{text: 'Cancel'},
				{text: 'Submit', onTouchTap: @onSubmit}
			]}
			actionFoucus="submit"
			ref="dialog"
			modal>

			<mui.TextField
				floatingLabelText="username"
				onChange={@onUsernameChange}
				hintText="cannot less than 4 letters"
				errorText={if @state.username.length < 4 then "username too short"}
				/>

			<mui.TextField
				floatingLabelText="password"
				onChange={@onPasswordChange}
				errorText={if not @state.password.length then "password cannot be empty"}
				>
				<input type="password" />
			</mui.TextField>

			<mui.TextField
				floatingLabelText="reinput password"
				onChange={@onRepasswordChange}
				errorText={if @state.repassword isnt @state.password then "password not match"}
				>
				<input type="password" />
			</mui.TextField>

		</mui.Dialog>

module.exports = React.createClass
	childContextTypes:
		muiTheme: React.PropTypes.object
	getChildContext: ->
		muiTheme: ThemeManager.getCurrentTheme()
	onLoginClick: ->
		@refs.loginDialog.show()
	onSignupClick: ->
		@refs.signupDialog.show()
	onLoginSubmit: (cb) ->
		@refs.loginDialog.dismiss()
	onSignupSubmit: (cb) ->
		@refs.signupDialog.dismiss()
	render: ->
		<div>
			<mui.RaisedButton label="Log in" secondary onTouchTap={@onLoginClick}/>
			<mui.RaisedButton label="Sign up" primary onTouchTap={@onSignupClick}/>
			<LoginDialog ref="loginDialog"/>
			<SignupDialog ref="signupDialog"/>
		</div>
		
