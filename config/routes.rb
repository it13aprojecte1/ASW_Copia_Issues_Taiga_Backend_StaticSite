Rails.application.routes.draw do
  get "settings/index"
  get "comments/create"

  # Configure Devise routes with OmniAuth but skip registrations
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, skip: [:registrations]

  # Redirect registration to sign-in and add specific routes for GitHub auth
  devise_scope :user do
    get '/users/sign_up', to: redirect('/users/sign_in')
    get '/users/auth/github/callback', to: 'users/omniauth_callbacks#github'
    get '/auth/github/callback', to: 'users/omniauth_callbacks#github'
  end

 #equivalente a get '/issues', to: 'issues#index'
#get '/issues/new', to: 'issues#new'
#post '/issues', to: 'issues#create'

resources :issues
resources :users

resources :issues do
  resources :comments, only: :create
  delete :attachment, action: :delete_attachment, on: :member
end

 namespace :settings do
    resources :statuses
    resources :priorities
    resources :issue_types
    resources :severities
  end

 # Ruta principal para la página de settings
  get 'settings', to: 'settings#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

   root "issues#index"  # Esto hace que la página inicial sea el index de Issues
end
