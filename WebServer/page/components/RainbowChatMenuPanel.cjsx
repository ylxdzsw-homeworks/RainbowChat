React = require 'react'
mui   = require 'material-ui'
ThemeManager = new mui.Styles.ThemeManager()

module.exports = React.createClass
	childContextTypes:
		muiTheme: React.PropTypes.object
	getChildContext: ->
		muiTheme: ThemeManager.getCurrentTheme()
	render: ->
		<mui.AppBar title="RainbowChat"
			iconElementLeft={<i className="material-icons">menu</i>}
			onLeftIconButtonTouchTap={->console.log 'fuck'}/>
