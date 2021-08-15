Rails.application.routes.draw do
  root 'public#home'
  get '/home', to: 'user#index'
  get '/profile/:username', to: 'user#profile', as: :profile
  post '/user/follow', to: 'user#follow_user', as: :follow_user
  post '/user/unfollow', to: 'user#unfollow_user', as: :unfollow_user
  get '/search-user', to: 'user#search', as: :search
  get '/story', to: 'posts#add_story'
  delete '/story/:id/delete', to: 'posts#remove_story'
  devise_for :users
  resources :posts do
    get 'like', to: 'likes#like_post', as: :like, on: :member
    resources :comments, only: %i[create destroy edit update]
  end
  get '*path', to: 'public#render_404'
end
