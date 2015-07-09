React = require 'react'
mui   = require 'material-ui'
ThemeManager = new mui.Styles.ThemeManager()

GoogleIcon = (iconName,onClick) -> <mui.IconButton onClick={onClick}><i className="material-icons trans-light">{iconName}</i></mui.IconButton>

module.exports = React.createClass
	render: ->
		<mui.AppBar title="RainbowChat"
			iconElementLeft={GoogleIcon('people',@props.onLeftIconClick)}
			iconElementRight={GoogleIcon('person_add',@props.onRightIconClick)}
			/>
