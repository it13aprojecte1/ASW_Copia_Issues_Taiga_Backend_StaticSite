class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :check_user_auth

  def hello
    render html: "<h1>It works WASLAB04!</h1>".html_safe
  end

  private

  def check_user_auth
    # Si el usuario está en la página de login pero ya está autenticado, redirigir a la página principal
    if params[:controller] == 'devise/sessions' && params[:action] == 'new' && user_signed_in?
      redirect_to root_path
    end
  end
end
