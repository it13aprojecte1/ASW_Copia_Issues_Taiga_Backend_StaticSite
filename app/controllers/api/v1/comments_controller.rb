  # app/controllers/api/v1/comments_controller.rb
  module Api
    module V1
      class CommentsController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :set_issue, only: [:index, :create]

        # GET /api/v1/issues/:issue_id/comments
        def index
          @comments = @issue.comments.includes(:user).order(created_at: :desc)
          render json: @comments.as_json(except: [:user_id], include: { user: { except: [:api_key, :password] } })
        end

        # POST /api/v1/issues/:issue_id/comments
        def create
          @comment = @issue.comments.new(comment_params)
          @comment.user_id = 3

          if @comment.save
            render json: @comment, status: :created
          else
            render json: { errors: @comment.errors}, status: :unprocessable_entity
          end
        end

        private

        def set_issue
          @issue = Issue.find(params[:issue_id])
        rescue ActiveRecord::RecordNotFound
          render json: {errors: "Issue not found" }, status: :not_found
        end

        def comment_params
          params.require(:comment).permit(:content)
        end
      end
    end
  end