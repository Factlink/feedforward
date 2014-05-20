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

  renderField: (key, label, place_holder) ->
    _div [],
      _strong [], label
      ReactTextArea
        ref: key
        placeholder: place_holder
        defaultValue: JSON.parse(@props.defaultValue)[key] if @props.defaultValue
        storageKey: "add_anecdote_to_fact_#{key}_#{string_hash(@props.site_url)}" if @props.site_url
        onSubmit: => @refs.signinPopover.submit(=> @_submit())

  render: ->
    _div ['add-anecdote'],
      _p [], 'Do you have an experience to share that might be of value to this challenge? Write your story!'
      @renderField('introduction', 'Challenge', 'Describe your own challenge, include context and stakeholders')
      @renderField('insight', 'Exploration of options', 'Describe exploration of options with stakeholders')
      @renderField('resources', 'Aha!!-Moment', 'Describe your a-ha moment! What got you in action modus?')
      @renderField('actions', 'Actions', 'Describe the actions you and others took')
      @renderField('effect', 'Impact and evaluation', 'Evaluate the outcomes for the different stakeholders: how did your actions work out, for whom?')
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
