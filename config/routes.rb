Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :students, except: [:edit, :new] do
        get "courses" => "enrollments#index"
      end
      resources :schools, except: [:index, :edit, :new] do
        resources :courses, except: [:edit, :new] do
        end
      end
      post "enroll/:course_id" => "enrollments#create", as: :enroll_course
      delete "unenroll/:enrollment_id" => "enrollments#destroy", as: :unenroll_course
    end
  end

  post '/auth/login', to: 'authentication#login', as: :auth
  post '/auth/logout', to: 'authentication#logout', as: :logout
  get '/*a', to: 'application#not_found'
end