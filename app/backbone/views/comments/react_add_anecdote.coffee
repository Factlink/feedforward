window.ReactAddAnecdote = React.createClass
  displayName: 'ReactAddAnecdote'

  render: ->
    ReactAnecdoteForm
      onSubmit: (text) =>
        comment = new Comment
          markup_format: 'anecdote'
          created_by: currentSession.user().toJSON()
          content: $.trim(text)

        @props.comments.unshift(comment)
        comment.saveWithFactAndWithState {},
          success: =>
            @props.comments.fact.getOpinionators().setInterested true

window.ReactAnecdoteForm = React.createClass
  displayName: 'ReactAnecdoteForm'

  renderField: (key, label, place_holder, tooltip) ->
    _div [],
      _strong [],
        label
        ReactTooltipIcon {}, tooltip
      ReactTextArea
        ref: key
        placeholder: place_holder
        defaultValue: JSON.parse(@props.defaultValue)[key] if @props.defaultValue
        storageKey: "add_anecdote_to_fact_#{key}_#{string_hash(@props.site_url)}" if @props.site_url
        onSubmit: => @refs.signinPopover.submit(=> @_submit())

  render: ->
    _div ['add-anecdote'],
      _p [], 'Do you have an experience to share that might be of value to this challenge? Write your story!'
      @renderField(
        'introduction',
        'Challenge',
        'Describe your own challenge, include context and stakeholders'
        'How to describe a challenge? A challenge is a situation in which you experienced a difficulty, a dilemma. You were in need of new perspectives for new actions. Describe the context (e.g. stuck on a rock in the middle of a wild river, cold) but also human context, (with a group of friends), your challenging dilemma (e.g. how to get safe to the riverbank?). Be as short and precise as possible!'
      )
      @renderField(
        'insight',
        'Exploration of options',
        'Describe exploration of options with stakeholders',
        'Explore your options! What was around to support meeting your challenge? e.g one would swim, with a risk to drown, phone in a helicopter, with a risk to get hypothermia.'
      )
      @renderField(
        'actions',
        'Actions',
        'Describe the actions you and others took',
        'What are actions? Actions are things you or others did to move forward. Describe a ﬂow of actions of what happened, what did you do, what did other people do? e.g. swung the rope to the tree branch, doubled the rope, jumped. Almost drowned, others were cheering at me.'
      )
      @renderField(
        'effect',
        'Impact and evaluation',
        'Evaluate the outcomes for the different stakeholders: how did your actions work out, for whom?',
        'What is impact and evaluation? Give an overview of what was achieved and for whom. e.g. using and swinging the rope got me safe on the dry bank, but the rope broke and left the others on the rock. I phoned in helicopter, everyone got saved but one. In the end I think could have better ...'
      )
      _button ['button-confirm button-small add-anecdote-post-button'
        onClick: => @refs.signinPopover.submit(=> @_submit())
      ],
        'Post ' + Factlink.Global.t.anecdote
        ReactSigninPopover
          ref: 'signinPopover'

  _submit: ->
    @props.onSubmit? JSON.stringify
      introduction: @refs.introduction.getText()
      insight: @refs.insight.getText()
      resources: @refs.resources.getText()
      actions: @refs.actions.getText()
      effect: @refs.effect.getText()

    @refs.introduction.updateText ''
    @refs.insight.updateText ''
    @refs.resources.updateText ''
    @refs.actions.updateText ''
    @refs.effect.updateText ''
