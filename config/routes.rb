Rails.application.routes.draw do
  root 'orders#index'

  resources :products, only: :index
  resources :orders, only: :index
end
