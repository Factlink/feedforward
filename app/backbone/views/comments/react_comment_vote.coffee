window.ReactCommentVote = React.createBackboneClass
  displayName: 'ReactCommentVote'

  _on_up_vote: ->
    if @model().get('current_user_opinion') == 'believes'
      @model().saveCurrentUserOpinion 'no_vote'
    else
      @model().saveCurrentUserOpinion 'believes'
      @props.fact_opinionators.setInterested true

  render: ->
    _div ['comment-votes'],
      _a [
        'comment-vote-up'
        'comment-vote-active' if @model().get('current_user_opinion') == 'believes'
        'spec-comment-vote-up'
        href: "javascript:",
        onClick: => @refs.signinPopoverUp.submit(=> @_on_up_vote())
      ],
        _i ['icon-up-open']
        ReactSigninPopover
          ref: 'signinPopoverUp'

      _span ['comment-vote-amount spec-comment-vote-amount'],
        format_as_short_number(@model().relevance())
