module Api
  module V1
    class PrioritiesController < ApplicationController
      # Omitir verificación CSRF para API
      skip_before_action :verify_authenticity_token
      before_action :set_priority, only: [:update, :destroy]

      # GET /api/v1/priorities
      def index
        @priorities = Priority.all
        render json: @priorities
      end

      # POST /api/v1/priorities
      def create
        @priority = Priority.new(priority_params)
        if @priority.save
          render json: @priority, status: :created
        else
          render json: { errors: @priority.errors }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/priorities/:id
      def update
        if @priority.update(priority_params)
          render json: @priority
        else
          render json: { errors: @priority.errors }, status: :unprocessable_entity
        end
      end
          # DELETE /api/v1/priorities/:id
      def destroy
        if @priority.destroy
          render json: { message: "Priority deleted successfully" }, status: :ok
        else
          render json: { errors: @priority.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_priority
        @priority = Priority.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Priority not found" }, status: :not_found
      end

      def priority_params
        params.require(:priority).permit(:name, :color, :position)
      end
    end
  end
end