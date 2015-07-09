React = require 'react'
mui = require 'material-ui'
_ = require 'lodash'
RainbowChatAppBar          = require './components/RainbowChatAppBar.cjsx'
RainbowChatWelcome         = require './components/RainbowChatWelcome.cjsx'
RainbowChatInputPanel      = require './components/RainbowChatInputPanel.cjsx'
RainbowChatChatPanel       = require './components/RainbowChatChatPanel.cjsx'
RainbowChatSidePanel       = require './components/RainbowChatSidePanel.cjsx'
RainbowChatStartChatDialog = require './components/RainbowChatStartChatDialog.cjsx'

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
		chatters: {}
		snack:
			message: ''
			action: ''
			onClick: => @refs.snack.dismiss()
	toggleSidePanel: ->
		@refs.sidepanel.toggle()

	onLogin: (username) ->
		@setState {username}
	showStartChat: ->
		@refs.startchatdialog.show()
	startChat: (username) ->
		# 这里需要验证是否已经与该用户开始聊天
		x = @state.chatters
		x[username] = {}
		@setState chatters: x
	selectChatter: (username) ->
		@setState currentChatter: username
		x = @state.chatters[username]
		if not x.message?
			$.ajax
				method: 'GET'
				url: "/msg"
				data: {username}
				success: (data) =>
					x.message = data
					x.lastUpdate = _.max data, (x) -> new Date x.date
					@setState chatters: @state.chatters
				error: (res) =>
					if res.status isnt 404
						@setState snack: {message:"unhandled bug",action:"OH SHIT!",onClick:@refs.snack.dismiss}
	
	startListen: ->
		listen = ->
			for own k,v of @state.chatters
				$.ajax
					method: 'GET'
					url: "/msg/latest"
					data:
						date: v.lastUpdate ? new Date()
						username: k
					# TODO HERE

	render: ->
		<div>
			<RainbowChatAppBar
				onLeftIconClick={@toggleSidePanel}
				onRightIconClick={@showStartChat}
				/>
			<RainbowChatWelcome
				onLogin={@onLogin}
				/>
			<RainbowChatStartChatDialog ref="startchatdialog"
				onSubmit={@startChat}
				/>
			<RainbowChatInputPanel />
			<RainbowChatChatPanel ref='chatpanel'
				message={@state.chatters[@state.currentChatter]?.message ? []}
				/>
			<mui.LeftNav header={<h2>Rainbow Chat</h2>}
				menuItems={for own k,v of @state.chatters
					text: k
					onTouchTap: @selectChatter
				}
				docked={false}
				ref="sidepanel"
				/>
			<ul>
				{for own k,v of @state.chatters
					<li onClick={=>@selectChatter k} key={k}>{k}</li>}
			</ul>
			<mui.Snackbar ref="snack"
				message={@state.snack.message}
				action={@state.snack.action}
				onActionTouchTap={@state.snack.onClick}
				/>
		</div>

React.render <App />, document.getElementById 'app'