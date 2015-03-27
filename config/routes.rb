Rails.application.routes.draw do
  namespace :api do
    # Resource routes
    resources :codes, except: [ :new, :edit ] do
      resources :proposed_laws, only: [ :index, :create ]
    end
    # Paginated routes
    match "/codes/page/:page(.:format)", to: "codes#index", via: :get,
      constraints: { page: /[0-9]+/ }
    resources :proposed_laws, only: [ :index, :show, :update, :destroy ]
    match "/proposed_laws/page/:page(.:format)",
      to: "proposed_laws#index", via: :get, constraints: { page: /[0-9]+/ }
    match "/codes/:code_id/proposed_laws/page/:page(.:format)",
      to: "proposed_laws#index", via: :get, constraints: { code_id: /[0-9]+/,
        page: /[0-9]+/ }
  end
  get "/user_session(.:format)", to: "user_session#show"
  delete "/user_session(.:format)", to: "user_session#destroy"
  post '/auth/:provider/callback', to: "user_session#create"
  root 'application#index'
  get '*path' => 'application#index'
end
