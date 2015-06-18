Rails.application.routes.draw do
  namespace :api do
    # Resource routes
    resources :jurisdictions, except: [ :new, :edit ] do
      resources :proposed_laws, only: [ :index, :create ]
    end
    # Paginated routes
    match "/jurisdictions/page/:page(.:format)", to: "jurisdictions#index", via: :get,
      constraints: { page: /[0-9]+/ }
    resources :proposed_laws, only: [ :index, :show, :update, :destroy ] do
      member do
        get '/files', to: "proposed_laws/files#index"
        get '/files/*tree', to: "proposed_laws/files#index"
        get '/file/*tree', to: "proposed_laws/files#show"
        post '/file/*tree', to: "proposed_laws/files#create"
        put '/file/*tree', to: "proposed_laws/files#update"
        get '/nodes', to: "proposed_laws/nodes#index"
        get '/nodes/*tree', to: "proposed_laws/nodes#index"
        get '/node', to: "proposed_laws/nodes#show"
        get '/node/*tree', to: "proposed_laws/nodes#show"
        post '/node/*tree', to: "proposed_laws/nodes#create"
        patch '/node/*tree', to: "proposed_laws/nodes#update"
      end
    end
    match "/proposed_laws/page/:page(.:format)",
      to: "proposed_laws#index", via: :get, constraints: { page: /[0-9]+/ }
    match "/jurisdictions/:jurisdiction_id/proposed_laws/page/:page(.:format)",
      to: "proposed_laws#index", via: :get, constraints: { jurisdiction_id: /[0-9]+/,
        page: /[0-9]+/ }
  end
  get "/user_session(.:format)", to: "user_session#show"
  delete "/user_session(.:format)", to: "user_session#destroy"
  post '/auth/:provider/callback', to: "user_session#create"
  root 'application#index'
  get '*path' => 'application#index', format: "html"
end
