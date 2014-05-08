twitter_conf =
    ActiveSupport::HashWithIndifferentAccess.new({
      id: ENV['TWITTER_ID'],
      secret: ENV['TWITTER_SECRET'],
    })

facebook_conf =
    ActiveSupport::HashWithIndifferentAccess.new({
      id: ENV['FACEBOOK_ID'],
      secret: ENV['FACEBOOK_SECRET'],
    })

FactlinkUI::Application.config.facebook_app_id = facebook_conf['id']

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, twitter_conf['id'], twitter_conf['secret']
  provider :facebook,
    facebook_conf['id'],
    facebook_conf['secret'],
    scope: 'email',
    display: 'popup'
end

OmniAuth.config.on_failure = Accounts::SocialConnectionsController.action(:oauth_failure)

FactlinkUI::Application.config.social_services = %w[facebook twitter]
