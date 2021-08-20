Rails.application.routes.draw do
  root 'public#home'
  get '/home', to: 'user#index'
  get '/profile/:username', to: 'user#profile', as: :profile
  get '/post/like/:post_id', to: 'likes#like_post', as: :like_post
  devise_for :users
  resources :posts, only: %i[new create]
end
