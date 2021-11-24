Rails.application.routes.draw do
  root :to => 'commodities#index'

  resources :commodities do
    resources :sections do
      resources :comments
    end
  end

  resources :sellers do
    resources :shops
  end

  resources :categories
  resources :admins
  resources :sellers
  resources :customers do
    resources :orders
    resources :records
  end
  resources :accounts
  resources :roles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
