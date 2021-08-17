Rails.application.routes.draw do
  root 'public#home'
  get '/home', to: 'user#index'
  devise_for :users
  resources :posts, only: %i[new create]
end
