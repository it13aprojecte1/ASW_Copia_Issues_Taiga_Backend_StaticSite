module Api
  module V1
    class IssueTypesController < ApplicationController
      # Omitir verificación CSRF para API
      skip_before_action :verify_authenticity_token

      # GET /api/v1/issue_types
      def index
        @issue_types = IssueType.all
        render json: @issue_types
      end
    end
  end
end