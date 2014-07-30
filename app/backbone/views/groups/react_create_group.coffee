window.ReactCreateGroup = React.createClass
  displayName: 'ReactCreateGroup'
  mixins: [
    React.BackboneMixin('group')
  ]

  render: ->
    _div ['challenges-create'],
      _strong [],
        'Title'
        ReactTooltipIcon {}, 'What is a good title?'
      _input [
        "challenge-name-input"
        defaultValue: @props.site_title
        value: @props.group.get 'groupname'
        onChange: (e) => @props.group.set 'groupname', e.target.value
      ]
      _button [
        "button-confirm",
        onClick: => @props.onSave(@props.group)
      ],
        "Save Group"
      _button [
        "button",
        onClick: => @props.onCancel()
      ],
        "Cancel"
