$(document).on 'account_success', (e) ->
  user = JSON.parse(e.originalEvent.detail)

  if user.id?
    if location.pathname == '/'
      location.href = '/feed'
  else
    location.href = '/'
