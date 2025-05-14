module Api
  module V1
    class IssueTypesController < ApplicationController
      # Omitir verificación CSRF para API
      skip_before_action :verify_authenticity_token
      before_action :set_issue_type, only: [:update, :destroy]

      # GET /api/v1/issue_types
      def index
        @issue_types = IssueType.all
        render json: @issue_types
      end

      # POST /api/v1/issue_types
      def create
        @issue_type = IssueType.new(issue_type_params)
        if @issue_type.save
          render json: @issue_type, status: :created
        else
          render json: { errors: @issue_type.errors }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/issue_types/:id
      def update
        if @issue_type.update(issue_type_params)
          render json: @issue_type
        else
          render json: { errors: @issue_type.errors }, status: :unprocessable_entity
        end
      end

    # DELETE /api/v1/issue_types/:id
      def destroy
        if @issue_type.destroy
          render json: { message: "Issue type deleted successfully" }, status: :ok
        else
          render json: { errors: @issue_type.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_issue_type
        @issue_type = IssueType.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Issue type not found" }, status: :not_found
        return
      end



      def issue_type_params
        params.require(:issue_type).permit(:name, :color, :position)
      end
    end
  end
end