# config/routes.rb
Rails.application.routes.draw do
  # Routes for Like resource
  resources :likes, only: [:index, :show, :create, :update, :destroy], param: :path_id

  # Routes for Follow request resource
  resources :follow_requests, only: [:index, :show, :create, :update, :destroy], param: :path_id

  # Routes for Comment resource
  resources :comments, only: [:index, :show, :create, :update, :destroy], param: :path_id

  # Routes for Photo resource
  resources :photos, only: [:index, :show, :create, :update, :destroy], param: :path_id

  # Devise user routes
  devise_for :users

  # Routes for Users controller
  resources :users, only: [:show, :edit, :update]

  # Custom route for follow requests
  post 'insert_follow_request', to: 'follow_requests#create'

  # Root path
  root "home#index"
end
