React = require 'react'
mui   = require 'material-ui'
ThemeManager = new mui.Styles.ThemeManager()

leftIcon = (x) -> <mui.IconButton onClick={x}><i className="material-icons">menu</i></mui.IconButton>

module.exports = React.createClass
	render: ->
		<mui.AppBar title="RainbowChat"
			iconElementLeft={leftIcon(@props.onLeftIconClick)}
			/>
