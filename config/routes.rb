Rails.application.routes.draw do
  get 'profiles/index'
  get 'home/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'home#index'
  resources :messages, only: [:index, :create]
  resources :profiles, only: [:index]
end
