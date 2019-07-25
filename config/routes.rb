Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :students, except: [:edit, :new]
      resources :schools, except: [:index, :edit, :new] do
        resources :courses, except: [:edit, :new]
      end
    end
  end

  post '/auth/login', to: 'authentication#login', as: :auth
  get '/*a', to: 'application#not_found'
end
