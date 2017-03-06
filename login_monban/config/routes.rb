Rails.application.routes.draw do
  root 'dashboards#show'

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]

  get 'dashboards/show'
end
