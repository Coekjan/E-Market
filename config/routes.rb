Rails.application.routes.draw do
  resources :complaints do
    get 'handle'
    post 'do_handle'
  end
  root :to => 'commodities#index'

  resources :sellers do
    resources :shops
  end

  resources :commodities do
    resources :sections do
      resources :comments do
        get 'reply'
        post 'do_reply'
      end
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
      get 'register'
      post 'do_register'
    end
    get 'top_up'
    post 'do_top_up'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
