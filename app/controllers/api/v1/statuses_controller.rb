module Api
  module V1
    class StatusesController < ApplicationController
      # Omitir verificación CSRF para API
      skip_before_action :verify_authenticity_token
      before_action :set_status, only: [:update]

      # GET /api/v1/statuses
      def index
        @statuses = Status.all
        render json: @statuses
      end

      # POST /api/v1/statuses
      def create
        @status = Status.new(status_params)
        if @status.save
          render json: @status, status: :created
        else
          render json: { errors: @status.errors }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/statuses/:id
      def update
        if @status.update(status_params)
          render json: @status
        else
          render json: { errors: @status.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_status
        @status = Status.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Status not found" }, status: :not_found
      end

      def status_params
        params.require(:status).permit(:name, :color, :is_closed, :position)
      end
    end
  end
end