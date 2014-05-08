ReactCollapsedText = React.createClass
  displayName: 'ReactCollapsedText'

  getInitialState: ->
    expanded: false

  render: ->
    return _span [], @props.text if @props.text.length <= @props.size

    if @state.expanded
      _span [],
        @props.text
        ' '
        _a [
          onClick: => @setState expanded: false
        ],
          '(less)'
    else
      _span [],
        @props.text.substring 0, @props.size
        '\u2026 '
        _a [
          onClick: => @setState expanded: true
        ],
          '(more)'

window.ReactTopAnnotation = React.createBackboneClass
  displayName: 'ReactTopAnnotation'

  render: ->
    _div ['top-annotation'],
      if @model().get('html_content')
        _span [dangerouslySetInnerHTML: {__html: @model().get('html_content')}]
      else
        _div ["loading-indicator-centered"],
          ReactLoadingIndicator()
