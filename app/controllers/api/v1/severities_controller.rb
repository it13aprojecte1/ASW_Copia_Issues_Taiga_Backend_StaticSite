module Api
  module V1
    class SeveritiesController < ApplicationController
      # Omitir verificación CSRF para API
      skip_before_action :verify_authenticity_token

      # GET /api/v1/severities
      def index
        @severities = Severity.all
        render json: @severities
      end
    end
  end
end