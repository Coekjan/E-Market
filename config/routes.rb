Rails.application.routes.draw do
  resources :commodities
  resources :shops
  resources :categories
  resources :admins
  resources :sellers
  resources :customers
  resources :accounts
  resources :roles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
