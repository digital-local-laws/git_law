Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  get "/user_session(.:format)", to: "user_session#show"
  # This line is required for developer Omniauth callback which uses POST, not GET
  post '/omniauth/:provider/callback', to: 'devise_token_auth/omniauth_callbacks#redirect_callbacks'
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'
    # Resource routes
    resources :jurisdictions, except: [ :new, :edit ] do
      resources :proposed_laws, only: [ :index, :create ]
    end
    # Paginated routes
    match "/jurisdictions/page/:page(.:format)", to: "jurisdictions#index", via: :get,
      constraints: { page: /[0-9]+/ }
    resources :adopted_laws, only: [ :show ]
    resources :proposed_laws, only: [ :index, :show, :update, :destroy ] do
      resource :adopted_law, only: [ :create ]
      member do
        get '/files', to: "proposed_laws/files#index"
        get '/files/*tree', to: "proposed_laws/files#index"
        get '/file/*tree', to: "proposed_laws/files#show"
        post '/file/*tree', to: "proposed_laws/files#create"
        put '/file/*tree', to: "proposed_laws/files#update"
        get '/nodes', to: "proposed_laws/nodes#index"
        get '/nodes/*tree_base', to: "proposed_laws/nodes#index"
        get '/node', to: "proposed_laws/nodes#show"
        get '/node/*tree_base', to: "proposed_laws/nodes#show"
        post '/node/*tree_base', to: "proposed_laws/nodes#create"
        patch '/node/*tree_base', to: "proposed_laws/nodes#update"
        delete 'node/*tree_base', to: "proposed_laws/nodes#destroy"
      end
    end
    match "/proposed_laws/page/:page(.:format)",
      to: "proposed_laws#index", via: :get, constraints: { page: /[0-9]+/ }
    match "/jurisdictions/:jurisdiction_id/proposed_laws/page/:page(.:format)",
      to: "proposed_laws#index", via: :get, constraints: { jurisdiction_id: /[0-9]+/,
        page: /[0-9]+/ }
  end
end
