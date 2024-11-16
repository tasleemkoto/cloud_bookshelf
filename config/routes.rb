Rails.application.routes.draw do

  devise_for :users
  root to: "/dashboard", to: "users#dashboard"

  resources :libraries do
   resources :books
  end

  resources :checkouts, only: [:index, :new, :create, :edit, :update] do
    patch :return, on: :member
  end

  resources :notifications, only: [:create]

  resources :wishlists, only: [:create, :index]

  resources :libraries, only: [] do
    resources :book, only: [] do
      resources :reviews, only: [:edit, :create, :destroy]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
