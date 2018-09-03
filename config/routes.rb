Rails.application.routes.draw do

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'

  get '/logout', to: 'sessions#destroy', as: 'logout'

  match 'auth/:provider/callback', to: 'users#create', via: [:get, :post]
  get 'auth/failure', to: redirect('/')

  root to: "home#show"

  resources :users
  resources :password_resets, only: [:new, :create]

end
