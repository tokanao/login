Rails.application.routes.draw do

  get 'users/activate'

  root 'dashboards#index'
  # root :to => 'users#index'

  resources :user_sessions
  resources :users do
    member do
      get :activate
      # put :confirm
    end
  end

  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

end
