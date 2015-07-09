React = require 'react'
mui = require 'material-ui'
RainbowChatAppBar     = require './components/RainbowChatAppBar.cjsx'
RainbowChatWelcome    = require './components/RainbowChatWelcome.cjsx'
RainbowChatInputPanel = require './components/RainbowChatInputPanel.cjsx'
RainbowChatChatPanel  = require './components/RainbowChatChatPanel.cjsx'
RainbowChatSidePanel  = require './components/RainbowChatSidePanel.cjsx'

# This is required by material-ui
injectTapEventPlugin = require "react-tap-event-plugin"
do injectTapEventPlugin

# Required by React Develop Tools
window['React'] = React

ThemeManager = new mui.Styles.ThemeManager()

ThemeManager.setTheme ThemeManager.types.LIGHT

App = React.createClass
	childContextTypes:
		muiTheme: React.PropTypes.object
	getChildContext: ->
		muiTheme: ThemeManager.getCurrentTheme()
	getInitialState: ->
		chatters: ['fuck']
		snack:
			message: ''
			action: ''
			onClick: => @snackDismiss()
	toggleSidePanel: ->
		@refs.sidepanel.toggle()
	snackShow: (message,action,onClick) ->
		onClick ?= => @snackDismiss()
		@setState snack: {message,action,onClick}
		@refs.snack.show()
	snackDismiss: ->
		@refs.snack.dismiss()
	render: ->
		<div>
			<RainbowChatAppBar
				onLeftIconClick={@toggleSidePanel}
				/>
			<RainbowChatWelcome />
			<RainbowChatInputPanel />
			<RainbowChatChatPanel />
			<mui.LeftNav header={<h2>Rainbow Chat</h2>}
				menuItems={@state.chatters.map (x) ->
					text: x
				}
				docked={false}
				ref="sidepanel"
				/>
			<mui.Snackbar
				message={@state.snack.message}
				action={@state.snack.action}
				onActionTouchTap={@state.snack.onClick}
				ref="snack"
				/>
		</div>

React.render <App />, document.getElementById 'app'