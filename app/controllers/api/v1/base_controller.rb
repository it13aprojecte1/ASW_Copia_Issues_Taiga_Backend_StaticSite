module Api
  module V1
    class BaseController < ApplicationController
      include ApiKeyAuthenticatable

      # Desactivar protección CSRF para APIs
      skip_before_action :verify_authenticity_token, if: :json_request?

      private

      def json_request?
        request.format.json?
      end
    end
  end
end
