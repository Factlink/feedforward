window.ReactFeedSelection = React.createClass
  displayName: 'ReactFeedSelection'
  mixins: [
    UpdateOnSignInOrOutMixin,
    React.BackboneMixin('groups', 'add remove reset sort change')
  ]

  getInitialState: ->
    feedGroupId: 0
    show_create_challenge: false
    createGroup: null

  _toggle_create_challenge: ->
    @setState show_create_challenge: !@state.show_create_challenge

  _currentFeed: ->
    if @state.feedGroupId == 0
      @_globalActivities ?= new DiscussionsFeedActivities
    else
      @_globalActivities ?= {}
      @_globalActivities[@state.feedGroupId] ?= new GroupActivities [], group_id: @state.feedGroupId

  _createGroup: (id = null) ->
    if id?
      new Group @props.groups.get(id).attributes
    else
      new Group members: [ currentSession.user().get('username') ]

  _destroyGroup: ->
    user_group = @props.groups.get(@state.feedGroupId)
    allGroups = new AllGroups(user_group.clone())
    group = allGroups.get(user_group.id)
    group.destroy
      success: =>
        Factlink.notificationCenter.success 'Successfully deleted group'
        @setState feedGroupId: 0
        @props.groups.remove user_group
      error: => Factlink.notificationCenter.error 'Error deleting Group'

  _saveGroup: (group) ->
    isNew = group.isNew()

    allGroups = new AllGroups()
    allGroups.create group,
      success: =>
        if isNew
          Factlink.notificationCenter.success 'Group created!'
        else
          Factlink.notificationCenter.success 'Group updated!'

        @setState
          createGroup: null,
          feedGroupId: group.id
        @props.groups.add group, merge: true

      error: =>
        if isNew
          Factlink.notificationCenter.error 'Error creating Group'
        else
          Factlink.notificationCenter.error 'Error updating Group'

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
        group.get 'groupname'

  render: ->
    _div [],
      _div ['feed-selection-row'],
        ReactToggleButton
          name: 'FeedChoice'
          value:'global'
          checked: @state.feedGroupId == 0
          onChange: => @setState
            feedGroupId: 0,
            show_create_challenge: false,
            createGroup: null
          'Public'

        @_groupButtons()...

      if currentSession.signedIn() && @state.createGroup
          ReactCreateGroup
            key: @state.createGroup.cid
            group: @state.createGroup
            onSave: (group) => @_saveGroup(group)
            onCancel: => @setState createGroup: null

      (if currentSession.signedIn()
        [
          _div ['feed-selection-row'],
            _button ['button-success', onClick: @_toggle_create_challenge],
              (if !@state.show_create_challenge then "Create challenge" else "Cancel")

            _div ['feed-group-controls'],
              _a [
                onClick: => @setState createGroup: @_createGroup()
              ],
                'New group'

              if @state.feedGroupId != 0 && currentSession.user().get('admin')
                [
                  _span [],
                    ' - '
                  _a [
                    onClick: => @setState createGroup: @_createGroup @state.feedGroupId
                  ],
                    'Edit group'
                  _span [],
                    ' - '
                  _a [
                    onClick: @_destroyGroup
                  ],
                    'Destroy group'
                ]

          if @state.show_create_challenge
            ReactCreateChallenge
              groups: @props.groups
              groupId: @state.feedGroupId
              key: 'create_challenge_' + @state.feedGroupId
        ]
      else [])...

      ReactFeedActivitiesAutoLoading
        model: @_currentFeed()
        key: 'feed_' + @state.feedGroupId
