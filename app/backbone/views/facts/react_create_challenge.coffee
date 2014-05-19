window.ReactChallengeForm = React.createClass
  render: ->
    _div [],
      _input [
        "challenge-name-input"
        ref: 'challengeName'
        placeholder: 'Title'
        defaultValue: @props.site_title
      ]
      ReactCkeditorArea
        ref: 'challengeDescription'
        placeholder: 'Describe your challenge'
        defaultValue: @props.displaystring
        storageKey: "createChallengeDescription_#{@props.groupId}" unless @props.displaystring
      _label ['challenge-group-input-label'],
        'Group: '
        _select [ref: 'challengeGroupId', defaultValue: @props.groupId],
          _option [value: null], '(no group / public)'
          currentSession.user().get('groups').map (group) =>
            _option [value: group.id],
              group.groupname
      _button ["button-confirm", onClick: @_onClick],
        "Save challenge"

  _onClick: ->
    @props.onSubmit
      displaystring: @refs.challengeDescription.getHtml()
      site_title: @refs.challengeName.getDOMNode().value
      site_url: 'kennisland_challenge'
      group_id: @refs.challengeGroupId.state.value # they should implement a getValue

  clear: ->
    @refs.challengeDescription.updateHtml ''
    @refs.challengeName.getDOMNode().value = ''


window.ReactCreateChallenge = React.createClass
  _postChallenge: (attributes) ->
    fact = new Fact attributes

    fact.save {},
      success: =>
        @refs.form.clear()
        Factlink.notificationCenter.success 'Challenge created!'

        Backbone.history.navigate fact.fact_show_link().href, true
      error: ->
        Factlink.notificationCenter.error 'Could not create challenge, please try again.'

  render: ->
    _div ['challenges-create'],
      ReactChallengeForm groupId: @props.groupId, onSubmit: @_postChallenge, ref: 'form'
