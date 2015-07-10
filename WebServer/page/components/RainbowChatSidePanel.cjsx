React = require 'react'
mui   = require 'material-ui'
ThemeManager = new mui.Styles.ThemeManager()

module.exports = React.createClass
	toggle: ->
		@refs.sidepanel.toggle()
	render: ->
		<mui.LeftNav header={<h2>Rainbow Chat</h2>}
			menuItems={@props.menuItems}
			docked={false}
			ref="sidepanel"
			/>
