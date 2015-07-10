React = require 'react'
mui   = require 'material-ui'
ThemeManager = new mui.Styles.ThemeManager()

LoginDialog = React.createClass
	getInitialState: ->
		username: ''
		password: ''

	onSubmit: ->
		$.ajax
			method: "POST"
			url: "/auth"
			data:
				username: @state.username
				password: @state.password
			success: (res) =>
				@props.onLoginSuccess res
				@dismiss()
			error: (res) =>
				switch res.status
					when 400
						@props.onLoginError "invalid input"
					when 403
						@props.onLoginError "password incorrect!"
					when 404
						@props.onLoginError "user not exist!"
					when 500
						@props.onLoginError "Server error, refreshing might help"
					else
						@props.onLoginError "Unknown bug"

	onUsernameChange: (e) ->
		@setState username: e.target.value

	onPasswordChange: (e) ->
		@setState password: e.target.value

	# Method
	show: ->
		@refs.dialog.show()

	dismiss: ->
		@refs.dialog.dismiss()

	render: ->
		<mui.Dialog
			title="Log in"
			actions={[
				{text: 'Cancel'},
				{text: 'Submit', onTouchTap: @onSubmit}
			]}
			actionFoucus="submit"
			ref="dialog"
			modal>

			<div><mui.TextField
				floatingLabelText="username"
				onChange={@onUsernameChange}
				errorText={if not @state.username.length then "username cannot leave empty"}
				/></div>

			<div><mui.TextField
				floatingLabelText="password"
				onChange={@onPasswordChange}
				errorText={if not @state.password.length then "password cannot leave empty"}
				>
				<input type="password" />
			</mui.TextField></div>

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
			success: (a,b,c) ->
				console.log a
				console.log b
				console.log c
			error: (a,b,c) ->
				alert "failed"



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

			<div><mui.TextField
				floatingLabelText="username"
				onChange={@onUsernameChange}
				hintText="cannot less than 4 letters"
				errorText={if @state.username.length < 4 then "username too short"}
				/></div>

			<div><mui.TextField
				floatingLabelText="password"
				onChange={@onPasswordChange}
				errorText={if not @state.password.length then "password cannot be empty"}
				>
				<input type="password" />
			</mui.TextField></div>

			<div><mui.TextField
				floatingLabelText="reinput password"
				onChange={@onRepasswordChange}
				errorText={if @state.repassword isnt @state.password then "password not match"}
				>
				<input type="password" />
			</mui.TextField></div>

		</mui.Dialog>

module.exports = React.createClass
	getInitialState: ->
		snack:
			message: ''
			action: ''
			onClick: => @refs.snack.dismiss()
	onLoginClick: ->
		@refs.loginDialog.show()
	onSignupClick: ->
		@refs.signupDialog.show()
	onLoginSuccess: (username) ->
		@setState snack: {message:"Welcome, #{username}",action:'OK',onClick:@refs.snack.dismiss}
		@refs.snack.show()
		@props.onLogin username
	onLoginError: (info) ->
		@setState snack: {message:info,action:'Gotcha',onClick:@refs.snack.dismiss}
		@refs.snack.show()
	render: ->
		<div>
			<mui.RaisedButton label="Log in" secondary onTouchTap={@onLoginClick}/>
			<mui.RaisedButton label="Sign up" primary onTouchTap={@onSignupClick}/>
			<LoginDialog ref="loginDialog"
				onLoginSuccess={@onLoginSuccess}
				onLoginError={@onLoginError}
				/>
			<SignupDialog ref="signupDialog"/>
			<mui.Snackbar ref="snack"
				message={@state.snack.message}
				action={@state.snack.action}
				onActionTouchTap={@state.snack.onClick}
				/>
		</div>
		
