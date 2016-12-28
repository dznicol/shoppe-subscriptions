Shoppe::Engine.routes.draw do
  resources :subscription_plans do
    resources :subscribers
    collection do
      get 'sync'
      patch 'stripe_account'
    end
  end
end
