Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  root 'static_pages#home'

  # StaticPagesController
  # get 'static_pages/help'
  get '/help', to: 'static_pages#help'
  # get 'static_pages/about'
  get '/about', to: 'static_pages#about'
  # get 'static_pages/contact'
  get '/contact', to: 'static_pages#contact'

  # UsersController
  # resources is a built-in routing method that automatically sets up a standardized group of
  #  routes for a specific data object(a "resource") based on RESTful architecture.
  # GET,        /users,             index,    Displaying a list of all users
  # GET,        /users/new,         new,      Displaying the HTML form to create a new user
  # POST,       /users,             create,   Saving a new user to the database
  # GET,        /users/:id,         show,     Displaying a specific user profile (e.g., /users/1)
  # GET,        /users/:id/edit     edit,     Displaying the HTML form to edit a user's details
  # PATCH/PUT,  /users/:id,         update,   Saving changes made to a specific user
  # DELETE,     /users/:id,         destroy,  Deleting a specific user
  resources :users do
    member do
      get :following, :followers
    end
  end
  get '/signup', to: 'users#new'

  # SessionsController
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # AccountActivationsController
  resources :account_activations, only: [:edit]

  # Password Resets Controller
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :microposts, only: [:create, :destroy]
  get '/microposts', to: 'static_pages#home'

  resources :relationships,       only: [:create, :destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # root_path -> '/'
  # root_url  -> 'https://www.example.com/'

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
