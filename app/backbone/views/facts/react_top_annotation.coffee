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
  mixins: [UpdateOnSignInOrOutMixin]

  getInitialState: ->
    editing: false

  render: ->
    _div ['top-annotation'],
      if @model().get('html_content')
        _span [dangerouslySetInnerHTML: {__html: @model().get('html_content')}]
      else
        _div ["loading-indicator-centered"],
          ReactLoadingIndicator()

      if @model().can_edit()
        _button [
          'button'
          onClick: => @setState editing: !@state.editing
        ],
          'Edit challenge'

      if @model().can_edit()
        _button [
          'button-success'
          onClick: @_publish
        ],
          'Publish challenge'

      if @state.editing
        ReactChallengeForm
          groupId: @model().get('group_id')
          site_title: @model().get('site_title')
          displaystring: @model().get('displaystring')
          onSubmit: @_postChallenge
          ref: 'form'

  _postChallenge: (attributes) ->
    @model().save attributes,
      success: =>
        @refs.form.clear()
        @setState editing: false
        Factlink.notificationCenter.success 'Challenge edited!'
      error: ->
        Factlink.notificationCenter.error 'Could not update challenge, please try again.'

  _publish: ->
    if confirm('Do you want to make this challenge public?')
      @model().save {group_id: null},
        success: =>
          Factlink.notificationCenter.success 'Challenge published!'

          Backbone.history.navigate '/feed', true
        error: ->
          Factlink.notificationCenter.error 'Could not publish challenge, please try again.'

