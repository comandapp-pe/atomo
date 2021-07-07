# typed: strict
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'root#index'

  namespace :admin do
    resources :products
    resources :orders
    resource :session, only: [:new, :create, :destroy]
  end

  resources :products
  resources :orders
  resources :checkout_links, only: [:create]
end
