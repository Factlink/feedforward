window.ReactTopbarMenu = React.createClass
  displayName: 'ReactTopbarMenu'
  mixins: [UpdateOnSignInOrOutMixin]

  _adminItems: ->
    _span [],
      _li ['dropdown-menu-item'],
        _a [href: '/a/users'],
          'Users'
      _li ['dropdown-menu-item'],
        _a [href: '/a/clean'],
          'Clean actions'
      _li ['dropdown-menu-item'],
        _a [href: '/a/global_feature_toggles'],
          'Global features'
      _li ['dropdown-menu-item'],
        _a [href: '/a/info'],
          'Info'
      _li ['dropdown-menu-item'],
        _a [href: '/a/cause_error'],
          'Cause Error'

  render: ->
    username = currentSession.user().get('username')
    @transferPropsTo _li ['dropdown'],
      _a ['dropdown-toggle spec-topbar-menu-arrow', @props.linkClass, 'data-toggle': 'dropdown', href: 'javascript:'],
        _b ['caret']
      _ul ['dropdown-menu'],
        _li ['dropdown-menu-item'],
         _a [href: "/user/#{username}/edit", rel: 'backbone'],
           _i ['icon-cog']
           " Settings"
        _li ['dropdown-menu-item'],
         _a ['js-accounts-popup-link', href: "/users/out"],
           _i ['icon-off']
           " Sign out"

        if currentSession.user().get('admin')
          @_adminItems()

window.ReactTopbarSearch = React.createBackboneClass
  displayName: 'ReactTopbarSearch'

  _onSubmit: (e) ->
    e.preventDefault()
    url = '/search?s=' + encodeURIComponent @model().get('query')

    if location.pathname == '/'
      location.href = url
    else
      Backbone.history.navigate url, true

  _onChange: (e) ->
    @model().set query: e.target.value

  render: ->
    _div ['topbar-search'],
      _form [onSubmit: @_onSubmit],
        _input ['topbar-search-field', id: 'spec-search', placeholder: 'Search...',
                onChange: @_onChange, value: @model().get('query')]

window.ReactTopbar = React.createClass
  displayName: 'ReactTopbar'
  mixins: [UpdateOnSignInOrOutMixin]

  render: ->
    _div ['topbar'],
      if currentSession.signedIn()
        _div ['topbar-inner'],
          _ul ['topbar-menu'],
            _li ['topbar-menu-item'],
              _a ['topbar-menu-link', href: '/feed', rel: 'backbone'],
                'Feed'
            _li ['topbar-divider']
            _li ['topbar-menu-item'],
              _a ['topbar-menu-link', href: "/user/#{currentSession.user().get('username')}", rel: 'backbone'],
                _img ['topbar-profile-image image-30px', src: currentSession.user().avatar_url(30)]
                currentSession.user().get('name')
            _li ['topbar-divider']
            ReactTopbarMenu className: 'topbar-menu-item', linkClass: 'topbar-menu-link'

          _a ['topbar-logo', href: '/']

          ReactTopbarSearch model: Factlink.topbarSearchModel
      else
        _div ['topbar-inner'],
          _ul ['topbar-menu'],
            _li ['topbar-divider topbar-on-your-site']
            _li ['topbar-menu-item'],
              _div ['topbar-connect'],
                ReactSigninLinks()

          _a ['topbar-logo', href: '/']
