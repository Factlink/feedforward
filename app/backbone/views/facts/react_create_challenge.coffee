window.ReactChallengeForm = React.createClass
  render: ->
    _div [],
      _strong [],
        'Title'
        ReactTooltipIcon {}, 'What is a good title? A good title covers the topic of your challenge (what)? and your target group (for whom?). E.g. How to get my colleagues enthusiastic? Or shorter: Enthusing my colleagues.'
      _input [
        "challenge-name-input"
        ref: 'challengeName'
        defaultValue: @props.site_title
      ]
      _strong [],
        'Description'
        ReactTooltipIcon {attachment: 'top'}, 'How to describe a challenge? A challenge is a situation in which you experience a difficulty, a dilemma. You are in need of new perspectives for new actions. Describe the context (e.g. physical context like a school, but also human context, stakeholders, like colleagues), your challenging dilemma (e.g. my colleagues have no time) and your possible resources or ideas on how to go forward (e.g. maybe I could use..or do..). End with a question (e.g. how to go about?). Be as short and precise as possible!'
      ReactCkeditorArea
        ref: 'challengeDescription'
        defaultValue: @props.displaystring
        storageKey: "createChallengeDescription_#{@props.groupId}" unless @props.displaystring
      _label ['challenge-group-input-label'],
        'Group: '
        _select [ref: 'challengeGroupId', defaultValue: @props.groupId],
          _option [value: null], '(no group / public)'
          @props.groups.map (group) =>
            _option [value: group.id],
              group.get 'groupname'
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
      ReactChallengeForm
        groupId: @props.groupId,
        onSubmit: @_postChallenge, ref: 'form'
        groups: @props.groups
