# == Route Map
#
#             Prefix Verb   URI Pattern                             Controller#Action
#          passwords POST   /passwords(.:format)                    clearance/passwords#create
#       new_password GET    /passwords/new(.:format)                clearance/passwords#new
#            session POST   /session(.:format)                      clearance/sessions#create
#      user_password POST   /users/:user_id/password(.:format)      clearance/passwords#create
# edit_user_password GET    /users/:user_id/password/edit(.:format) clearance/passwords#edit
#                    PATCH  /users/:user_id/password(.:format)      clearance/passwords#update
#                    PUT    /users/:user_id/password(.:format)      clearance/passwords#update
#              users POST   /users(.:format)                        clearance/users#create
#            sign_in GET    /sign_in(.:format)                      clearance/sessions#new
#           sign_out DELETE /sign_out(.:format)                     clearance/sessions#destroy
#            sign_up GET    /sign_up(.:format)                      users#new
#               root GET    /                                       dashboards#show
#

Rails.application.routes.draw do
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"
  root 'dashboards#show'

end
