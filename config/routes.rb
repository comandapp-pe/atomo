# typed: strict
Rails.application.routes.draw do
  namespace :admin do
    resources :sessions
  end
  namespace :admin do
    resources :products
  end
  resources :orders
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'root#index'

  namespace :admin do
    resource :session
    resources :products
  end

  resources :products
  resources :orders
  resources :checkout_links, only: [:create]
end
