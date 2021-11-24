Rails.application.routes.draw do
  resources :admins
  resources :sellers
  resources :customers
  resources :accounts
  resources :roles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
