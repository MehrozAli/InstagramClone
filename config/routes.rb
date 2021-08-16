Rails.application.routes.draw do
  root 'public#home'
  get '/home', to: 'user#index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
