Rails.application.routes.draw do
  root :to => 'commodities#index'

  resources :sellers do
    resources :shops
  end

  resources :commodities do
    resources :sections do
      resources :comments
    end
  end

  resources :categories
  resources :admins
  resources :customers do
    resources :orders do
      post 'purchase'
    end
    resources :records
  end
  resources :accounts do
    collection do
      get 'login'
      post 'do_login'
      get 'logout'
    end
  end
  resources :roles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
