window.ReactFeedSelection = React.createClass
  displayName: 'ReactFeedSelection'
  mixins: [UpdateOnSignInOrOutMixin]

  getInitialState: ->
    feedGroupId: 'global'
    show_create_challenge: false

  _toggle_create_challenge: ->
    @setState show_create_challenge: !@state.show_create_challenge

  _currentFeed: ->
    if @state.feedGroupId == 'global'
      @_globalActivities ?= new DiscussionsFeedActivities
    else
      @_globalActivities ?= {}
      @_globalActivities[@state.feedGroupId] ?= new GroupActivities [], group_id: @state.feedGroupId

  _groupButtons: ->
    return [] unless currentSession.signedIn()

    currentSession.user().get('groups').map (group) =>
      ReactToggleButton
        name:'FeedChoice'
        value:group.id
        checked: @state.feedGroupId == group.id
        onChange: => @setState feedGroupId: group.id, show_create_challenge: false
        group.groupname

  render: ->
    _div [],
      _div ['feed-selection-row'],
        ReactToggleButton
          name: 'FeedChoice'
          value:'global'
          checked: @state.feedGroupId == 'global'
          onChange: => @setState feedGroupId: 'global', show_create_challenge: false
          'Public'

        @_groupButtons()...

      (if currentSession.signedIn()
        [
          _div ['feed-selection-row'],
            _button ['button-success', onClick: @_toggle_create_challenge],
              (if !@state.show_create_challenge then "Create challenge" else "Cancel")

          if @state.show_create_challenge
            ReactCreateChallenge
              groupId: @state.feedGroupId
              key: 'create_challenge_' + @state.feedGroupId
        ]
      else [])...

      ReactFeedActivitiesAutoLoading
        model: @_currentFeed()
        key: 'feed_' + @state.feedGroupId
