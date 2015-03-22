Rails.application.routes.draw do
  namespace :api do
    resources :codes, except: [ :new, :edit ]
    match "/codes/page/:page(.:format)", to: "codes#index", via: :get,
      constraints: { page: /[0-9]+/ }
  end
#  devise_for :users, ActiveAdmin::Devise.config
#  ActiveAdmin.routes(self)
  root 'application#index'
  get '*path' => 'application#index'
end
