Shoppe::Engine.routes.draw do
  resources :subscription_plans do
    resources :subscribers
  end
end
