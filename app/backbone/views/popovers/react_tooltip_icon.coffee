window.ReactTooltipIcon = React.createClass
  displayName: 'ReactTooltipIcon'

  getInitialState: ->
    hovered: false

  render: ->
    _i [ 'icon-info-sign'
        onMouseEnter: => @setState hovered: true
        onMouseLeave: => @setState hovered: false
      ],
      if @state.hovered
        ReactPopover
          className: 'white-popover'
          attachment: @props.attachment || 'bottom'
        ,
          @props.children