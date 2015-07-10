React = require 'react'
mui   = require 'material-ui'
ThemeManager = new mui.Styles.ThemeManager()

module.exports = React.createClass
	getInitialState: ->
		username: ''

	onSubmit: ->
		@refs.dialog.dismiss()
		@props.onSubmit @state.username

	onUsernameChange: (e) ->
		@setState username: e.target.value

	show: ->
		@refs.dialog.show()

	dismiss: ->
		@refs.dialog.dismiss()

	render: ->
		<mui.Dialog ref="dialog"
			title="Chat With"
			actions={[
				{text: 'Cancel'},
				{text: 'Submit', onTouchTap: @onSubmit}
			]}
			actionFoucus="submit"
			modal>

			<mui.TextField
				floatingLabelText="username"
				onChange={@onUsernameChange}
				errorText={if not @state.username.length then "username cannot leave empty"}
				/>

		</mui.Dialog>
