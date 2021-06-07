Rails.application.routes.draw do
  resources :orders
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  resources :products
  resources :orders
end
