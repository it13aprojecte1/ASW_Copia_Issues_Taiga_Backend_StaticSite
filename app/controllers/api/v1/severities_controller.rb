module Api
  module V1
    class SeveritiesController < ApplicationController
      # Omitir verificación CSRF para API
      skip_before_action :verify_authenticity_token
      before_action :set_severity, only: [:update]

      # GET /api/v1/severities
      def index
        @severities = Severity.all
        render json: @severities
      end

      # POST /api/v1/severities
      def create
        @severity = Severity.new(severity_params)
        if @severity.save
          render json: @severity, status: :created
        else
          render json: { errors: @severity.errors }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/severities/:id
      def update
        if @severity.update(severity_params)
          render json: @severity
        else
          render json: { errors: @severity.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_severity
        @severity = Severity.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Severity not found" }, status: :not_found
      end

      def severity_params
        params.require(:severity).permit(:name, :description)
      end
    end
  end
end