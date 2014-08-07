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
        [
          if @model().get('resolved')
            _strong [], 'RESOLVED'

          _span [dangerouslySetInnerHTML: {__html: @model().get('html_content')}]
        ]
      else
        _div ["loading-indicator-centered"],
          ReactLoadingIndicator()

      if @model().can_edit() || currentSession.user().get('admin')
        _div [],

          if @model().get 'resolved'
            _button [
                'button-success'
                onClick: @_reopen
              ],
              'Reopen challenge'
          else
            [
              _button [
                'button'
                onClick: => @setState editing: !@state.editing
              ],
                'Edit challenge'

              _button [
                'button-success'
                onClick: @_resolve
              ],
                'Resolve challenge'
            ]

          if @model().get('group_id')
            _button [
              'button-success'
              onClick: @_publish
            ],
              'Publish challenge'

          _button [
            'button-danger'
            onClick: @_delete
          ],
            'Delete challenge'

      if @state.editing
        ReactChallengeForm
          groups: currentSession.user().groups()
          groupId: @model().get('group_id')
          site_title: @model().get('site_title')
          displaystring: @model().get('displaystring')
          onSubmit: @_postChallenge
          ref: 'form'

  _delete: ->
    if confirm('Are you sure you want to delete this challenge?')
      @model().destroy
        success: =>
          Factlink.notificationCenter.success 'Challenge deleted!'
          Backbone.history.navigate '/feed', true
        error: =>
          Factlink.notificationCenter.error 'Could not remove challenge, please try again.'

  _postChallenge: (attributes) ->
    @model().save attributes,
      success: =>
        @refs.form.clear()
        @setState editing: false
        Factlink.notificationCenter.success 'Challenge edited!'
      error: ->
        Factlink.notificationCenter.error 'Could not update challenge, please try again.'

  _reopen: ->
    @model().save {resolved: false},
      success: =>
        Factlink.notificationCenter.success 'Challenge reopened!'
      error: ->
        Factlink.notificationCenter.error 'Could not reopen challenge, please try again.'

  _resolve: ->
    @model().save {resolved: true},
      success: =>
        Factlink.notificationCenter.success 'Challenge resolved!'
      error: ->
        Factlink.notificationCenter.error 'Could not resolve challenge, please try again.'

  _publish: ->
    if confirm('Do you want to make this challenge public?')
      @model().save {group_id: null},
        success: =>
          Factlink.notificationCenter.success 'Challenge published!'

          Backbone.history.navigate '/feed', true
        error: ->
          Factlink.notificationCenter.error 'Could not publish challenge, please try again.'

