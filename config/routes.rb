Rails.application.routes.draw do

  root to: "home#show"

  match 'auth/:provider/callback', to: 'api/v2/splus/users#create', via: [:get, :post]
  get 'auth/failure', to: redirect('/')
  #Rails.application.routes.recognize_path(request.referrer)[:controller]
  #request.env['omniauth.origin'] ¿Cómo hacer este redirect?

  namespace :api do
    namespace :v2 do
      namespace :splus do

        get  '/register',  to: 'users#new'
        post '/register',  to: 'users#create'

        get    '/login',   to: 'sessions#new'
        post   '/login',   to: 'sessions#create'

        get '/log_out', to: 'sessions#destroy', as: 'logout'

        resources :users
        resources :password_resets, only: [:new, :create]

      end
    end
  end

end
