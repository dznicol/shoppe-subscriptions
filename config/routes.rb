Shoppe::Engine.routes.draw do
  resources :subscription_plans do
    resources :subscribers
    collection do
      get 'sync'
    end
  end
end
