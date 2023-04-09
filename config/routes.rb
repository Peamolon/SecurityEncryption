Rails.application.routes.draw do
  devise_for :users
  resources :encryptions, only: [:create, :new, :index, :show]
  resources :decrypts, only: [:create, :new, :index, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root"encryptions#new"
  # Defines the root path route ("/")
  # root "articles#index"
end
