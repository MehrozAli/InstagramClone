Rails.application.routes.draw do
  root 'public#home'
  get '/home', to: 'user#index'
  get '/profile/:username', to: 'user#profile', as: :profile
  post '/user/follow', to: 'user#follow_user', as: :follow_user
  devise_for :users
  resources :posts, only: %i[new create] do
    get 'like', to: 'likes#like_post', as: :like, on: :member
  end
end
