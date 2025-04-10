Rails.application.routes.draw do
  get "settings/index"
  get "comments/create"
devise_for :users

 #equivalente a get '/issues', to: 'issues#index'
#get '/issues/new', to: 'issues#new'
#post '/issues', to: 'issues#create'

# Rutas dedicadas para filtros con mayor prioridad
post '/issues/add_filter', to: 'issues#add_filter', as: 'add_filter_issues'
post '/issues/remove_filter', to: 'issues#remove_filter', as: 'remove_filter_issues'
post '/issues/clear_filters', to: 'issues#clear_filters', as: 'clear_filters_issues'
post '/issues/toggle_filters', to: 'issues#toggle_filters', as: 'toggle_filters_issues'

# Un solo bloque de resources :issues con todas las rutas anidadas
resources :issues do
  resources :comments, only: :create
  
  collection do
    get 'bulk_new'
    post 'bulk_create'
  end
end

resources :users

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
