FactlinkUI::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  # User Authentication
  devise_for :users, :controllers => {  confirmations: "users/confirmations",
                                        sessions:      "users/sessions",
                                        passwords:      "users/passwords"
                                      }
  mount Ohnoes::Engine => '/ohnoes'

  # Web Front-end
  root :to => "home#index"

  scope '/api/beta' do
    get '/feed' => "api/feed#global", as: 'something_alse_than_feed_as_well'
    get '/feed/personal' => "api/feed#personal", as: 'something_else_than_feed'
    get '/feed/discussions' => "api/feed#discussions", as: "insert_nonsense_here"
    get '/annotations/search' => 'api/annotations#search' #TODO:evil URL, clashes with get-by-id.
    post '/annotations' => 'api/annotations#create'
    get '/annotations/:id' => 'api/annotations#show'
    put '/annotations/:id' => 'api/annotations#update'
    delete '/annotations/:id' => 'api/annotations#delete'
    post '/groups' => 'api/groups#create'
    get '/groups' => 'api/groups#index'
    put '/groups/:id' => 'api/groups#update'
    delete '/groups/:id' => 'api/groups#delete'
    put '/users/:username/groups/:group_id' => 'api/groups#add_member'
    delete '/users/:username/groups/:group_id' => 'api/groups#remove_member'
    get '/groups/:group_id/feed' => 'api/groups#feed'
    get '/users/:username/feed' => 'api/users#feed'
    get '/users/:username' => 'api/users#show'
    put '/users/:original_username' => 'api/users#update'
    put '/users/:username/password' => 'api/users#change_password'
    get '/session' => 'api/sessions#current'
    post '/users/:username/delete' => 'api/users#destroy'
    get '/search' => "api/search#all", as: 'something_else_than_search'
  end

  # Javascript Client calls
  # TODO: replace /site/ gets with scoped '/sites/', and make it a resource (even if it only has show)
  get   "/site" => "sites#facts_for_url"

  resources :facts, only: [] do
    resources :opinionators, only: [:index, :create, :destroy, :update]

    member do
      scope '/comments' do
        post "/" => 'comments#create'
        put "/:comment_id" => 'comments#update'
        get "/" => 'comments#index'
        delete "/:id" => 'comments#destroy'
        put "/:id/opinion" => 'comments#update_opinion'

        scope '/:comment_id' do
          scope '/sub_comments' do
            get '' => 'sub_comments#index'
            post '' => 'sub_comments#create'
            delete "/:sub_comment_id" => 'sub_comments#destroy'
          end
        end
      end
    end
  end

  get "/d/:id" => "frontend#show" #KL: edit discussion/annotation/factlink on site

  get "/in-your-browser" => "home#in_your_browser", as: 'in_your_browser'
  get "/on-your-site" => "home#on_your_site", as: 'on_your_site'
  get "/terms-of-service" => "home#terms_of_service", as: 'terms_of_service'
  get "/privacy" => "home#privacy", as: 'privacy'
  get "/about" => "home#about", as: 'about'
  get "/jobs" => "home#jobs", as: 'jobs'

  # Support old urls until Google search index is updated
  get '/p/about', to: redirect("/about")
  get '/p/team', to: redirect("/about")
  get '/p/contact', to: redirect("/about")
  get '/p/jobs', to: redirect("/jobs")
  get '/p/privacy', to: redirect("/privacy")
  get '/publisher', to: redirect("/on-your-site")
  get '/p/terms-of-service', to: redirect("/terms-of-service")
  get '/p/tos', to: redirect("/terms-of-service")
  get '/p/on-your-site', to: redirect("/on-your-site")

  authenticated :user do
    namespace :admin, path: 'a' do
      get 'info'
      get 'clean'
      get 'cause_error'
      resource :global_feature_toggles,
            controller: :global_feature_toggles,
            only: [:show, :update ]

      resources :users, only: [:show, :edit, :update, :index, :destroy]
    end
  end

  authenticated :user do
    get "/auth/:provider_name/callback" => "accounts/social_connections#callback", as: "social_auth"
    delete "/auth/:provider_name/deauthorize" => "accounts/social_connections#deauthorize"
  end

  get "/auth/:provider_name/callback" => "accounts/social_registrations#callback"
  post "/auth/new" => "accounts/social_registrations#create", as: 'social_accounts_new'
  get "/users/sign_in_or_up" => "accounts/factlink_accounts#new", as: 'factlink_accounts_new'
  post "/users/sign_in_or_up/in" => "accounts/factlink_accounts#create_session", as: 'factlink_accounts_create_session'
  post "/users/sign_in_or_up/up" => "accounts/factlink_accounts#create_account", as: 'factlink_accounts_create_account'
  get "/users/out" => "accounts/sign_out#destroy"

  get "/users/deleted" => "users#deleted"

  get '/feed' => "frontend#show", as: 'feed'
  get '/:unused/feed', to: redirect("/feed")

  get "/search" => "frontend#show", as: "search"

  scope "/user/:username" do
    get "/" => "frontend#user_profile", as: "user_profile"
    get "/edit" => "frontend#show", as: 'edit_user'
    get "/change-password" => "frontend#show", as: 'change_password'
    get "/notification-settings" => "frontend#show", as: 'user_notification_settings'

    resources :following, only: [:destroy, :update, :index], controller: 'user_following'
  end

  # Scope for user specific actions
  # I made this scope so we don't always have to know the current users username in de frontend
  scope "/u" do
    get "/unsubscribe/:token/:type" => 'mail_subscriptions#update', subscribe_action: 'unsubscribe', as: :unsubscribe
    get "/subscribe/:token/:type" => 'mail_subscriptions#update', subscribe_action: 'subscribe', as: :subscribe
  end
end
