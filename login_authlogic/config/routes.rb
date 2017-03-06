Rails.application.routes.draw do

  get 'dashboards/index'

  resource :users, only: :create
  get "signup" => "users#new"

  resource :user_session, only: :create
  get "login" => "user_sessions#new"
  delete "logout" => "user_sessions#destroy"

  root 'dashboards#index'

end
