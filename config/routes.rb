Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations"}

  resources :stats do
    collection do
      get 'heatmap'
      get 'topn'
      get 'players'
    end
  end

  get 'checkout/show'
  get 'welcome/index'

  resources :plays do
    collection do
      get 'history'
      post 'undo'
    end
  end

  resources :players

  resources :games do
    collection do
      get 'sorting'
    end
  end

  root 'welcome#index'

  resources :users
end
