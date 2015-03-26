Rails.application.routes.draw do
  namespace :api do
    resources :codes, except: [ :new, :edit ]
    match "/codes/page/:page(.:format)", to: "codes#index", via: :get,
      constraints: { page: /[0-9]+/ }
  end
  get "/user_session(.:format)", to: "user_session#show"
  delete "/user_session(.:format)", to: "user_session#destroy"
  post '/auth/:provider/callback', to: "user_session#create"
  root 'application#index'
  get '*path' => 'application#index'
end
