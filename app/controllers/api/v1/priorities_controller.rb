module Api
  module V1
    class PrioritiesController < ApplicationController
      # Omitir verificación CSRF para API
      skip_before_action :verify_authenticity_token

      # GET /api/v1/priorities
      def index
        @priorities = Priority.all
        render json: @priorities
      end
    end
  end
end