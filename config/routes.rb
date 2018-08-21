Rails.application.routes.draw do
  get 'checkout/show'
  get 'welcome/index'

  resources :plays do
    collection do
      get 'history'
    end
  end


  resources :players

  resources :games do
    collection do
      get 'sorting'
    end
  end

  root 'welcome#index'
end
