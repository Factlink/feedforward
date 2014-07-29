window.ReactFeedSelection = React.createClass
  displayName: 'ReactFeedSelection'
  mixins: [
    UpdateOnSignInOrOutMixin,
    React.BackboneMixin('groups')
  ]

  getInitialState: ->
    feedGroupId: 'global'
    show_create_challenge: false
    createGroup: null

  _toggle_create_challenge: ->
    @setState show_create_challenge: !@state.show_create_challenge

  _currentFeed: ->
    if @state.feedGroupId == 'global'
      @_globalActivities ?= new DiscussionsFeedActivities
    else
      @_globalActivities ?= {}
      @_globalActivities[@state.feedGroupId] ?= new GroupActivities [], group_id: @state.feedGroupId

  _createGroup: ({id: null}) ->
    if id?
      # maybe use clone? or just the Group with the collection set
      # the associated just should'nt update when editing
      group = new Group @props.groups.get(id).attributes
    else
      group = new Group()
    group

  _saveGroup: (group) ->
    group.save {}
      success: =>
        Factlink.notificationCenter.success 'Group created!'
        # maybe always merge: true? because after saving isNew is always false?
        @props.groups.add group, merge: group.isNew
        @setState createGroup: null
      error => Factlink.notificationCenter.error 'Error creating Group'

  _groupButtons: ->
    return [] unless currentSession.signedIn()

    @props.groups.map (group) =>
      ReactToggleButton
        name:'FeedChoice'
        value:group.id
        checked: @state.feedGroupId == group.id
        onChange: => @setState
          feedGroupId: group.id,
          show_create_challenge: false,
          createGroup: null
        group.groupname

  render: ->
    _div [],
      _div ['feed-selection-row'],
        ReactToggleButton
          name: 'FeedChoice'
          value:'global'
          checked: @state.feedGroupId == 'global'
          # extract method?
          onChange: => @setState
            feedGroupId: 'global',
            show_create_challenge: false,
            createGroup: null
          'Public'

        @_groupButtons()...

        # authorization?
        _button [
          'button-success',
          onClick: => @setState createGroup: @_createGroup()
        ],
          'New'

        # only when not public?
        _button [
          'button-success',
          onClick: => @setState createGroup: @_createGroup @state.feedGroupId
        ],
          'Edit current group'

        # only when not public?
        # confirmation?
        _button [
          'button-success',
          onClick: => @props.groups.get(@state.feedGroupId).destroy()
        ],
          'Destroy current group'

      # authorization?
      if @state.createGroup
        ReactCreateGroup:
          group: @state.createGroup
          onSave: (group) => @_saveGroup(group)
          onCancel: => @setState createGroup: null

      (if currentSession.signedIn()
        [
          _div ['feed-selection-row'],
            _button ['button-success', onClick: @_toggle_create_challenge],
              (if !@state.show_create_challenge then "Create challenge" else "Cancel")

          if @state.show_create_challenge
            ReactCreateChallenge
              groupId: @state.feedGroupId unless @state.feedGroupId == 'global'
              key: 'create_challenge_' + @state.feedGroupId
        ]
      else [])...

      ReactFeedActivitiesAutoLoading
        model: @_currentFeed()
        key: 'feed_' + @state.feedGroupId
