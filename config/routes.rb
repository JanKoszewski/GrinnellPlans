Gplans::Application.routes.draw do
  devise_for :users

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  namespace :admin do
    root :to => "admin/users#index"
    resources :users
  end

  resources :plans
  resources :users, only: [:new, :show, :update, :create, :edit]
  resources :subscriptions, only: [:new, :update, :create, :destroy]

  root :to => "plans#index"
end
