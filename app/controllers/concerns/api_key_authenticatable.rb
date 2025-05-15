module ApiKeyAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_with_api_key
  end

  private

  def authenticate_with_api_key
    # Intentar obtener la API key de diferentes fuentes
    api_key = request.headers['X-API-Key'] || # Header estándar
             request.headers['HTTP_X_API_KEY'] || # Header en formato CGI
             params[:api_key] || # Parámetro de consulta
             request.headers['Authorization']&.gsub('Bearer ', '') # Header de autorización

    # Para depuración
    Rails.logger.info("Headers: #{request.headers.to_h.select { |k, _| k.start_with?('HTTP_') }}")
    Rails.logger.info("API Key encontrada: #{api_key.present? ? 'Sí' : 'No'}")

    if api_key.blank?
      render json: { error: 'API key is missing' }, status: :unauthorized
      return
    end

    @current_user = User.find_by(api_key: api_key)

    if @current_user.nil?
      render json: { error: 'Invalid API key' }, status: :unauthorized
      return
    end
  end

  def current_user
    @current_user
  end

  # Método para verificar que el usuario actual es el propietario del recurso
  def authorize_user_resource(user_id)
    unless @current_user.id == user_id.to_i
      render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
      return false
    end
    true
  end
end
