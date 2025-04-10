Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :github, ENV['GITHUB_APP_ID'], ENV['GITHUB_APP_SECRET'], scope: 'user:email'
end

# Configuración para prevenir ataques CSRF
OmniAuth.config.allowed_request_methods = [:post]
OmniAuth.config.silence_get_warning = true