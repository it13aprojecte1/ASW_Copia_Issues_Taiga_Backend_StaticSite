Rails.application.routes.draw do
  # Rutas básicas
  get "settings/index"
  get "comments/create"

  # Configure Devise routes with OmniAuth and allow registrations
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Add specific routes for GitHub auth
  devise_scope :user do
    get '/users/auth/github/callback', to: 'users/omniauth_callbacks#github'
    get '/auth/github/callback', to: 'users/omniauth_callbacks#github'
  end

  # API REST - Definido antes que las rutas web para tener prioridad
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :issues do
        resources :comments, only: :create
        resources :attachments, only: [:index, :create, :destroy], controller: 'attachments'
        resources :comments, only: [:create,:index]
        delete :attachment, action: :delete_attachment, on: :member
        collection do
          post 'bulk_create'
        end
      end

      resources :users, only: [:index, :show] do
        member do
          get 'issues/assigned', to: 'users#assigned_issues'
          get 'issues/watched', to: 'users#watched_issues'
          get 'comments', to: 'users#comments'
          get 'issues', to: 'users#issues'
          put 'profile_pic_edit', to: 'users#profile_pic_edit'
          put 'bio_edit', to: 'users#bio_edit'
        end
      end
      resources :issue_types, only: [:index, :create, :update, :destroy]
      resources :priorities, only: [:index, :create, :update, :destroy]
      resources :severities, only: [:index, :create, :update, :destroy]
      resources :statuses, only: [:index, :create, :update, :destroy]
    end
  end

  # Rutas para la interfaz web
  scope :web, as: 'web' do
    # Rutas dedicadas para filtros con mayor prioridad
    post '/issues/add_filter', to: 'issues#add_filter', as: 'add_filter_issues'
    post '/issues/remove_filter', to: 'issues#remove_filter', as: 'remove_filter_issues'
    post '/issues/clear_filters', to: 'issues#clear_filters', as: 'clear_filters_issues'
    post '/issues/toggle_filters', to: 'issues#toggle_filters', as: 'toggle_filters_issues'
  end

  # Recursos principales para la web
  resources :issues do
    resources :comments, only: :create
    delete :attachment, action: :delete_attachment, on: :member
    collection do
      get 'bulk_new'
      post 'bulk_create'
    end
  end

  resources :users do
    member do
      get :profile
      patch :update_avatar
      patch :update_bio
    end
  end

  resources :users

  namespace :settings do
    resources :statuses do
      member do
        get :confirm_destroy
      end
    end
    resources :priorities do
      member do
        get :confirm_destroy
      end
    end
    resources :issue_types do
      member do
        get :confirm_destroy
      end
    end
    resources :severities do
      member do
        get :confirm_destroy
      end
    end
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