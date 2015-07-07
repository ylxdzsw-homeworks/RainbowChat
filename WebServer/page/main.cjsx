React = require 'react'
mui = require 'material-ui'
RainbowChatAppBar = require './components/RainbowChatAppBar.cjsx'

# This is required by material-ui
injectTapEventPlugin = require "react-tap-event-plugin"
do injectTapEventPlugin

# Required by React Develop Tools
window['React'] = React

ThemeManager = new mui.Styles.ThemeManager()

ThemeManager.setTheme ThemeManager.types.DARK

React.render <RainbowChatAppBar />, document.body
