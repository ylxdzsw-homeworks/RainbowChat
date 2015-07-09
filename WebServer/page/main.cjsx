React = require 'react'
mui = require 'material-ui'
RainbowChatAppBar     = require './components/RainbowChatAppBar.cjsx'
RainbowChatWelcome    = require './components/RainbowChatWelcome.cjsx'
RainbowChatInputPanel = require './components/RainbowChatInputPanel.cjsx'

# This is required by material-ui
injectTapEventPlugin = require "react-tap-event-plugin"
do injectTapEventPlugin

# Required by React Develop Tools
window['React'] = React

ThemeManager = new mui.Styles.ThemeManager()

ThemeManager.setTheme ThemeManager.types.DARK

React.render <RainbowChatAppBar />, document.getElementById 'appbar'

React.render <RainbowChatWelcome />, document.getElementById 'welcome'

React.render <RainbowChatInputPanel />, document.getElementById 'input-panel'
