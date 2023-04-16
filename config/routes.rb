Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :encryptions, only: [:create, :new, :index, :show]
  resources :decrypts, only: [:create, :new, :index, :show]
  root"encryptions#new"
  # Defines the root path route ("/")
  # root "articles#index"
end
