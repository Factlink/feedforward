window.ReactGroupMembershipEdit = React.createClass
  displayName: 'ReactGroupMembershipEdit'
  mixins: [
    UpdateOnSignInOrOutMixin,
    React.BackboneMixin('user'),
    React.BackboneMixin('groups')
  ]

  render: ->
    return _span([], 'Please sign in.') unless currentSession.signedIn()

    _div [],
      _h1 [],
        'All groups'
      _table [],
        _tbody [],
          @props.groups.map (group) =>
            ReactEditGroup
              user_groups: @props.user.groups()
              group: group
              key: group.cid

ReactEditGroup = React.createClass
  displayName: 'ReactEditGroup'
  mixins: [
    React.BackboneMixin('group')
  ]

  getInitialState: ->
    editing: false
    groupname: ''

  _toggleEdit: ->
    if !@state.editing
      @setState
        editing: true
        groupname: @props.group.get 'groupname'
    else
      @setState editing: false

  _destroyGroup: ->
    @props.group.destroy
      success: =>
        Factlink.notificationCenter.success 'Successfully deleted group!'

        if @props.user_groups.get @props.group
          @props.user_groups.remove @props.group

      error: =>
        Factlink.notificationCenter.error 'Error deleting group'

  _saveGroup: ->
    @props.group.save groupname: @state.groupname,
      success: =>
        Factlink.notificationCenter.success 'Successfully updated group!'
        @setState editing: false
      error: =>
        Factlink.notificationCenter.error 'Error updating group'

  render: ->
    _tr [],
      _td [],
        if @state.editing
          [
            _input [
              value: @state.groupname
              onChange: (e) => @setState groupname: e.target.value
            ]
            _a [
              onClick: @_saveGroup
            ],
              'Save'
          ]
        else
          @props.group.get 'groupname'
      _td [],
        _a [
          onClick: @_toggleEdit
        ],
          if @state.editing
            'Cancel'
          else
            'Edit'
      _td [],
        ' - '
      _td [],
        _a [
          onClick: @_destroyGroup
        ],
          'Destroy'

window.ReactAdminGroupEdit = React.createClass
  displayName: 'ReactAdminGroupEdit'
  mixins: [React.BackboneMixin('user'), React.BackboneMixin('groups')]

  getInitialState: ->
    group: new Group

  _submit: ->
    group = @state.group
    @props.groups.add group
    group.save members: [ @props.user.get('username') ],
      success: (o)=>
        Factlink.notificationCenter.success "Group #{o.get('groupname')} created."
        currentSession.user().fetch()
      error: (o)=>
        Factlink.notificationCenter.error  "Group #{o.get('groupname')} could not be created!"

    @setState @getInitialState()

  render: ->
    _div [],
      ReactSubmittableForm {
          onSubmit: @_submit
          model: @state.group
          label: '(admin!) Add Group'
        },
          ReactInput
            model: @state.group
            label: 'Group name'
            attribute: 'groupname'

