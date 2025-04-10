class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])

    Rails.logger.info "OmniAuth GitHub callback - User: #{@user.inspect}"

    if @user.persisted?
      # Store GitHub authentication info for automatic login
      session[:github_user] = @user.uid

      # Sign in the user and redirect to the root path explicitly
      sign_in @user

      # Set a flash message
      set_flash_message(:notice, :success, kind: "GitHub") if is_navigational_format?

      # Redirect to root path explicitly
      redirect_to root_path
    else
      session["devise.github_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_session_path
    end
  end

  def failure
    Rails.logger.error "OmniAuth Failure: #{failure_message}"
    redirect_to root_path, alert: "Error al iniciar sesión con GitHub: #{failure_message}"
  end
end