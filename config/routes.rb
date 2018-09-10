Rails.application.routes.draw do

  root to: "home#show"

  namespace :api do
    namespace :v2 do
      namespace :splus do

        get  '/register',  to: 'users#new'
        post '/register',  to: 'users#create'

        get    '/login',   to: 'sessions#new'
        post   '/login',   to: 'sessions#create'

        get '/log_out', to: 'sessions#destroy', as: 'logout'

        match 'auth/:provider/callback', to: 'users#create', via: [:get, :post]
        get 'auth/failure', to: redirect('/')
        #request.env['omniauth.origin'] ¿Cómo hacer este redirect?

        resources :users
        resources :password_resets, only: [:new, :create]

      end
    end
  end

end
