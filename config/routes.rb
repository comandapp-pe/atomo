Rails.application.routes.draw do
  resources :orders
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/', to: 'welcome#index'
  post '/', to: 'welcome#create'


  resources :products
  resources :orders
end
