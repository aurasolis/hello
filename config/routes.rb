Rails.application.routes.draw do

  get 'login', to: redirect('auth/:provider'), as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  get 'auth/failure', to: redirect('/')
  get 'home', to: 'home#show'
  get 'me', to: 'me#show', as: 'me'
  root to: "home#show"

end
