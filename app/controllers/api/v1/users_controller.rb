module Api
  module V1
    class UsersController < BaseController
      # Ya no es necesario omitir verificación CSRF, se maneja en BaseController
      # Omitir comprobación de autenticación del ApplicationController si existe
      include Rails.application.routes.url_helpers
      skip_before_action :check_user_auth, raise: false
      before_action :set_user, only: [:show, :assigned_issues, :watched_issues, :comments, :issues, :profile_pic_edit, :bio_edit]
      # Añadir verificación de autorización para editar bio y foto de perfil
      before_action -> { authorize_user_resource(params[:id]) }, only: [:profile_pic_edit, :bio_edit]

      def index
        @users = User.all
        render json: @users.map { |user|
          {
            id: user.id,
            email: user.email,
            name: user.name,
            username: user.username || user.email.split('@').first,
            bio: user.bio,
            avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil,
            created_at: user.created_at,
            updated_at: user.updated_at
          }
        }
      end

      def show
        render json: {
          id: @user.id,
          email: @user.email,
          name: @user.name,
          username: @user.username || @user.email.split('@').first,
          bio: @user.bio,
          avatar_url: @user.avatar.attached? ? @user.avatar.url : nil,
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
        return unless validate_order_params if params[:order_by].present? || params[:order_direction].present?

        # Get all assigned issues that are not closed
        open_status_ids = Status.where.not(name: ['Closed', 'Resolved']).pluck(:id)
        @issues = @user.assigned_issues
                      .where(status_id: open_status_ids)
                      .includes(:status, :priority, :severity, :issue_type, :user, :assignee)

        # Aplicar ordenación personalizada si se especifican ambos parámetros, sino ordenar por fecha de actualización
        @issues = if params[:order_by].present? && params[:order_direction].present?
                   apply_order(@issues)
                 else
                   @issues.order(updated_at: :desc)
                 end

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
        return unless validate_order_params if params[:order_by].present? || params[:order_direction].present?

        @issues = @user.watched_issues
                      .includes(:status, :priority, :severity, :issue_type, :user, :assignee)

        # Aplicar ordenación personalizada si se especifican ambos parámetros, sino ordenar por fecha de actualización
        @issues = if params[:order_by].present? && params[:order_direction].present?
                   apply_order(@issues)
                 else
                   @issues.order(updated_at: :desc)
                 end

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
        return unless validate_order_params if params[:order_by].present? || params[:order_direction].present?

        @issues = @user.issues
                      .includes(:status, :priority, :severity, :issue_type, :assignee)

        # Aplicar ordenación personalizada si se especifican ambos parámetros, sino ordenar por fecha de actualización
        @issues = if params[:order_by].present? && params[:order_direction].present?
                   apply_order(@issues)
                 else
                   @issues.order(updated_at: :desc)
                 end

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

      # PUT /api/v1/users/:id/profile_pic_edit
      def profile_pic_edit
        # Imprimir todos los parámetros para depuración
        Rails.logger.info("Params: #{params.inspect}")

        # La autorización ya se verifica en el before_action
        # Verificar que se ha proporcionado una imagen
        if params[:avatar].present?
          begin
            # Eliminar el avatar anterior si existe
            @user.avatar.purge if @user.avatar.attached?

            # Adjuntar el nuevo avatar
            @user.avatar.attach(params[:avatar])

            # Esperar a que se complete la adjunción
            sleep(0.5) unless Rails.env.test?

            # Generar URL para el avatar
            avatar_url = nil
            if @user.avatar.attached?
              begin
                avatar_url = url_for(@user.avatar)
              rescue => url_error
                Rails.logger.error("Error generating avatar URL: #{url_error.message}")
                avatar_url = "Error generating URL"
              end
            end

            render json: {
              message: "Avatar updated successfully",
              avatar_url: avatar_url
            }, status: :ok
          rescue => e
            Rails.logger.error("Error updating avatar: #{e.message}")
            render json: { error: "Error updating avatar: #{e.message}" }, status: :unprocessable_entity
          end
        else
          render json: { error: "No avatar provided" }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/users/:id/bio_edit
      def bio_edit
        # Imprimir todos los parámetros para depuración
        Rails.logger.info("Bio edit params: #{params.inspect}")

        # La autorización ya se verifica en el before_action
        # Verificar que se ha proporcionado una bio
        if params[:bio].present?
          begin
            Rails.logger.info("Updating bio to: #{params[:bio]}")

            if @user.update(bio: params[:bio])
              render json: {
                message: "Bio updated successfully",
                bio: @user.bio
              }, status: :ok
            else
              Rails.logger.error("Bio update failed with errors: #{@user.errors.full_messages}")
              render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
            end
          rescue => e
            Rails.logger.error("Error updating bio: #{e.message}")
            render json: { error: "Error updating bio: #{e.message}" }, status: :unprocessable_entity
          end
        else
          Rails.logger.warn("No bio provided in params: #{params.keys}")
          render json: { error: "No bio provided" }, status: :unprocessable_entity
        end
      end

      private

      def validate_order_params
        if params[:order_by].present? ^ params[:order_direction].present?
          render json: { error: "Para ordenar los issues, debes especificar tanto 'order_by' como 'order_direction'" }, status: :bad_request
          return false
        end
        true
      end

      def apply_order(issues)
        order_by = params[:order_by].to_s.downcase
        direction = (params[:order_direction]&.downcase == 'desc') ? 'desc' : 'asc'

        case order_by
        when 'type'
          issues.joins(:issue_type).order("issue_types.name #{direction}")
        when 'severity'
          issues.joins(:severity).order("severities.name #{direction}")
        when 'priority'
          issues.joins(:priority).order("priorities.name #{direction}")
        when 'status'
          issues.joins(:status).order("statuses.name #{direction}")
        when 'modified'
          issues.order(updated_at: direction)
        when 'assign_to'
          issues.joins(:assignee).order("users.username #{direction}")
        when 'issue'
          issues.order(id: direction)
        else
          issues.order(updated_at: :desc)
        end
      end

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :not_found
      end
    end
  end
end