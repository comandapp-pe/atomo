Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  default_url_options host: Rails.application.config.domain

  root to: 'root#index'

  resources :products
  resources :categories
  resources :orders do
    resources :videos, shallow: true
    resources :photos, shallow: true
    resources :fonts, shallow: true
    resources :ideas, shallow: true
    resources :phrases, shallow: true
    resources :locutions, shallow: true
  end

  resources :checkout_links, only: [:create]

  get '/admin', to: redirect('/admin/session/new'), as: 'admin_root'

  namespace :admin do
    resources :categories
    resources :products
    resources :orders
    resource :session, only: [:new, :create, :destroy]
  end
end
