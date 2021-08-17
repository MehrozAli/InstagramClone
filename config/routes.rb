Rails.application.routes.draw do
  root 'public#home'
  get '/home', to: 'user#index'
  get '/profile/:username', to: 'user#profile', as: :profile
  devise_for :users
  resources :posts, only: %i[new create]
end
