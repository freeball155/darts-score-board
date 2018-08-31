Rails.application.routes.draw do
  resources :stats do
    collection do
      get 'heatmap'
    end
  end
  
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
