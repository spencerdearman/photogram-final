# config/routes.rb
Rails.application.routes.draw do

   # Devise user routes
   devise_for :users

  # Routes for Users controller with ID constraint
  resources :users, only: [:index, :show, :edit, :update], constraints: { id: /\d+/ }

  # Routes for Like resource
  resources :likes, only: [:index, :show, :create, :update, :destroy], param: :path_id

  # Routes for Follow request resource
  resources :follow_requests, only: [:index, :show, :create, :update, :destroy], param: :path_id

  # Routes for Comment resource
  resources :comments, only: [:index, :show, :create, :update, :destroy], param: :path_id

  # Routes for Photo resource
  resources :photos, only: [:index, :show, :create, :update, :destroy], param: :path_id

  # Custom route for follow requests
  post 'insert_follow_request', to: 'follow_requests#create'

  # Root path
  root "home#index"
end
