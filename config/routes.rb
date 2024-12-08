Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get 'users/new'
  get 'users/edit'
  get 'home/index'
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
  resources :users, only: [:index, :show, :new, :edit]

  # Root path (uncomment if needed)
  root "home#index"
end
