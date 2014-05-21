window.ReactAddToGroupCheckbox = React.createClass
  displayName: "ReactAddToGroupCheckbox"
  mixins: [
    React.BackboneMixin('group')
    React.BackboneMixin('users_groups')
  ]

  _addToGroup: ->
    group = @props.users_groups.create @props.group.attributes,
      error: =>
       @props.users_groups.remove group
       Factlink.notificationCenter.error 'User could not be added to group, please try again.'

  _removeFromGroup: ->
    @props.users_groups.get(@props.group).destroy
      error: =>
        @props.users_groups.add @props.group.attributes
        Factlink.notificationCenter.error 'User could not be removed from group, please try again.'

  render: ->
    in_group = @props.users_groups.some((group) => group.id == @props.group.id)
    _label [],
      if in_group
        if currentSession.user().get 'admin'
          _input [type: "checkbox", checked: true, onChange: @_removeFromGroup]
        else
          _input [type: "checkbox", checked: true, disabled: true]
      else
        _input [type: "checkbox", checked: false, onChange: @_addToGroup]
      @props.group.get('groupname')
