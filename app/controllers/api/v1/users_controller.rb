module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :assigned_issues, :watched_issues, :comments, :issues]
      before_action :authenticate_user!

      def show
        render json: {
          id: @user.id,
          email: @user.email,
          name: @user.name,
          username: @user.username || @user.email.split('@').first,
          bio: @user.bio,
          avatar_url: @user.avatar.attached? ? rails_blob_url(@user.avatar) : nil,
          created_at: @user.created_at,
          updated_at: @user.updated_at,
          stats: {
            issues_count: @user.issues.count,
            assigned_issues_count: @user.assigned_issues.count,
            watched_issues_count: @user.watched_issues.count,
            comments_count: @user.comments.count
          }
        }
      end

      def assigned_issues
        # Get all assigned issues that are not closed
        open_status_ids = Status.where.not(name: ['Closed', 'Resolved']).pluck(:id)
        @issues = @user.assigned_issues
                      .where(status_id: open_status_ids)
                      .includes(:status, :priority, :severity, :issue_type)
                      .order(updated_at: :desc)

        render json: @issues.map { |issue|
          {
            id: issue.id,
            subject: issue.subject,
            content: issue.content,
            status: {
              id: issue.status.id,
              name: issue.status.name
            },
            priority: {
              id: issue.priority.id,
              name: issue.priority.name,
              color: issue.priority.color
            },
            severity: {
              id: issue.severity.id,
              name: issue.severity.name,
              color: issue.severity.color
            },
            issue_type: {
              id: issue.issue_type.id,
              name: issue.issue_type.name,
              color: issue.issue_type.color
            },
            created_at: issue.created_at,
            updated_at: issue.updated_at,
            creator: {
              id: issue.user.id,
              email: issue.user.email
            }
          }
        }
      end

      def watched_issues
        @issues = @user.watched_issues
                      .includes(:status, :priority, :severity, :issue_type, :user, :assignee)
                      .order(updated_at: :desc)

        render json: @issues.map { |issue|
          {
            id: issue.id,
            subject: issue.subject,
            content: issue.content,
            status: {
              id: issue.status.id,
              name: issue.status.name
            },
            priority: {
              id: issue.priority.id,
              name: issue.priority.name,
              color: issue.priority.color
            },
            severity: {
              id: issue.severity.id,
              name: issue.severity.name,
              color: issue.severity.color
            },
            issue_type: {
              id: issue.issue_type.id,
              name: issue.issue_type.name,
              color: issue.issue_type.color
            },
            created_at: issue.created_at,
            updated_at: issue.updated_at,
            creator: {
              id: issue.user.id,
              email: issue.user.email
            },
            assignee: issue.assignee ? {
              id: issue.assignee.id,
              email: issue.assignee.email
            } : nil
          }
        }
      end

      def comments
        @comments = @user.comments
                        .includes(:issue)
                        .order(created_at: :desc)

        render json: @comments.map { |comment|
          {
            id: comment.id,
            content: comment.content,
            created_at: comment.created_at,
            updated_at: comment.updated_at,
            issue: {
              id: comment.issue.id,
              subject: comment.issue.subject,
              status: {
                id: comment.issue.status.id,
                name: comment.issue.status.name
              }
            }
          }
        }
      end

      def issues
        @issues = @user.issues
                      .includes(:status, :priority, :severity, :issue_type, :assignee)
                      .order(updated_at: :desc)

        render json: @issues.map { |issue|
          {
            id: issue.id,
            subject: issue.subject,
            content: issue.content,
            status: {
              id: issue.status.id,
              name: issue.status.name
            },
            priority: {
              id: issue.priority.id,
              name: issue.priority.name,
              color: issue.priority.color
            },
            severity: {
              id: issue.severity.id,
              name: issue.severity.name,
              color: issue.severity.color
            },
            issue_type: {
              id: issue.issue_type.id,
              name: issue.issue_type.name,
              color: issue.issue_type.color
            },
            created_at: issue.created_at,
            updated_at: issue.updated_at,
            assignee: issue.assignee ? {
              id: issue.assignee.id,
              email: issue.assignee.email
            } : nil,
            comments_count: issue.comments.count,
            watchers_count: issue.watchers.count
          }
        }
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
      end
    end
  end
end