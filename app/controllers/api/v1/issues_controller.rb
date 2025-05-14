module Api
  module V1
    class IssuesController < ApplicationController
      # Omitir verificación CSRF para API
      skip_before_action :verify_authenticity_token
      # Incluir todas las acciones que necesitan el callback set_issue
      before_action :set_issue, only: [:show, :update, :destroy, :attachments, :add_attachment, :delete_attachment]

      # GET /api/v1/issues
      def index
        @issues = Issue.all.includes(:issue_type, :severity, :priority, :status, :user, :assignee)

        # Validar parámetros de ordenación
        if params[:order_by].present? ^ params[:order_direction].present?
          return render json: { error: "Para ordenar los issues, debes especificar tanto 'order_by' como 'order_direction'" }, status: :bad_request
        end

        # Aplicar filtros usando scopes
        # Filtros por texto
        @issues = @issues.filtrar_por_titulo(params[:titulo]) if params[:titulo].present?
        @issues = @issues.filtrar_por_descripcion(params[:descripcion]) if params[:descripcion].present?

        # Filtros por ID
        @issues = @issues.por_tipo(params[:issue_type_id]) if params[:issue_type_id].present?
        @issues = @issues.por_severidad(params[:severity_id]) if params[:severity_id].present?
        @issues = @issues.por_prioridad(params[:priority_id]) if params[:priority_id].present?
        @issues = @issues.por_estado(params[:status_id]) if params[:status_id].present?
        @issues = @issues.por_creador(params[:user_id]) if params[:user_id].present?
        @issues = @issues.por_asignado(params[:assignee_id]) if params[:assignee_id].present?

        # Filtros por nombre
        @issues = @issues.por_tipo_nombre(params[:type]) if params[:type].present?
        @issues = @issues.por_severidad_nombre(params[:severity]) if params[:severity].present?
        @issues = @issues.por_prioridad_nombre(params[:priority]) if params[:priority].present?
        @issues = @issues.por_estado_nombre(params[:status]) if params[:status].present?

        # Aplicar ordenación personalizada si se especifican ambos parámetros, sino ordenar por fecha de actualización
        if params[:order_by].present? && params[:order_direction].present?
          @issues = apply_order(@issues)
        else
          @issues = @issues.order(updated_at: :desc)
        end

        render json: @issues.as_json(include: [:issue_type, :severity, :priority, :status, :user, :assignee])
      end

      # GET /api/v1/issues/:id
      def show
        render json: @issue.as_json(include: [:issue_type, :severity, :priority, :status, :user, :comments])
      end

      # POST /api/v1/issues
      def create
        @issue = Issue.new(issue_params)

        # Asignar usuario: primero intentar con current_user, luego con params[:user_id], y finalmente usar el primer usuario disponible
        if current_user
          @issue.user_id = current_user.id
        elsif params[:user_id].present?
          @issue.user_id = params[:user_id]
        else
          # Usar el primer usuario disponible como fallback
          @issue.user_id = User.first&.id || 1 # Usar ID 1 como último recurso
        end

        if @issue.save
          render json: @issue, status: :created
        else
          render json: { errors: @issue.errors }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/issues/:id
      def update
        begin
          return render json: { error: "Debe proporcionar al menos un campo para actualizar" }, status: :unprocessable_entity if params[:issue].blank?

          # Sanear los parámetros para evitar errores
          update_params = issue_params

          # Manejar el campo deadline
          if update_params.key?(:deadline)
            if update_params[:deadline].blank?
              # Si deadline está vacío, establecerlo a nil
              update_params[:deadline] = nil
            else
              # Validar que la fecha sea posterior a hoy
              deadline_date = Date.parse(update_params[:deadline])
              if deadline_date <= Date.today
                return render json: { error: "La fecha límite debe ser posterior a hoy" }, status: :unprocessable_entity
              end
            end
          end

          # Manejar watchers
          if update_params.key?(:watcher_ids)
            # Si es nil o vacío, eliminar todos los watchers
            if update_params[:watcher_ids].nil? || update_params[:watcher_ids].empty?
              @issue.watchers.clear
              update_params.delete(:watcher_ids)
            else
              # Convertir a array y asegurar que son números
              watcher_ids = Array(update_params[:watcher_ids]).map(&:to_i).compact
              # Verificar que los usuarios existen
              unless User.where(id: watcher_ids).count == watcher_ids.length
                return render json: { error: "Algunos IDs de watchers no son válidos" }, status: :unprocessable_entity
              end
              # Asignar directamente los watchers al issue en lugar de confiar en update
              @issue.watcher_ids = watcher_ids
              update_params.delete(:watcher_ids) # Quitar de los parámetros para evitar conflictos
            end
          end

          # Intentar actualizar el issue solo con los campos proporcionados
          if @issue.update(update_params)
            render json: @issue.as_json(include: [:issue_type, :severity, :priority, :status, :user, :watchers])
          else
            render json: { errors: @issue.errors }, status: :unprocessable_entity
          end
        rescue Date::Error
          render json: { error: "Formato de fecha inválido. Use el formato YYYY-MM-DD" }, status: :unprocessable_entity
        rescue => e
          # Capturar cualquier excepción y devolver un mensaje de error claro
          Rails.logger.error("Error al actualizar issue: #{e.message}\n#{e.backtrace.join("\n")}")
          render json: { error: "Error al actualizar el issue: #{e.message}" }, status: :internal_server_error
        end
      end

      # DELETE /api/v1/issues/:id
      def destroy
        @issue.destroy
        head :no_content
      end

      # POST /api/v1/issues/bulk
      def bulk
        begin
          # Obtener el array del body de la petición
          names = request.body.read
          names = JSON.parse(names)

          return render json: { error: "Debe proporcionar un array de nombres" }, status: :unprocessable_entity if !names.is_a?(Array)

          created_issues = []
          failed_issues = []

          names.each do |name|
            issue = Issue.new(
              subject: name,
              user_id: (current_user&.id || User.first&.id || 1),
              issue_type_id: IssueType.first&.id,
              severity_id: Severity.first&.id,
              priority_id: Priority.first&.id,
              status_id: Status.first&.id
            )

            if issue.save
              created_issues << issue.id
            else
              failed_issues << name
            end
          end

          render json: created_issues, status: :created
        rescue JSON::ParserError
          render json: { error: "El formato del JSON es inválido" }, status: :unprocessable_entity
        rescue => e
          render json: [], status: :internal_server_error
        end
      end

      private

      def set_issue
        @issue = Issue.find(params[:id])
      end

      def issue_params
        params.require(:issue).permit(:subject, :content, :issue_type_id, :severity_id, :priority_id, :status_id, :assignee_id, :user_id, :deadline, watcher_ids: [])
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
        when ''
          # Si no hay order_by, ordenar por fecha de modificación descendente
          issues.order(updated_at: :desc)
        else
          # Para cualquier otro valor no reconocido, ordenar por fecha de modificación descendente
          issues.order(updated_at: :desc)
        end
      end

      # GET /api/v1/issues/:id/attachments
      def attachments
        attachments_with_urls = @issue.attachments.map do |attachment|
          {
            id: attachment.id,
            filename: attachment.filename.to_s,
            content_type: attachment.content_type,
            created_at: attachment.created_at,
            url: Rails.application.routes.url_helpers.rails_blob_path(attachment, only_path: true)
          }
        end

        render json: attachments_with_urls
      end

      # POST /api/v1/issues/:id/attachments
      def add_attachment
        if params[:attachment].present?
          @issue.attachments.attach(params[:attachment])
          attachment = @issue.attachments.last

          render json: {
            id: attachment.id,
            filename: attachment.filename.to_s,
            content_type: attachment.content_type,
            created_at: attachment.created_at,
            url: Rails.application.routes.url_helpers.rails_blob_path(attachment, only_path: true)
          }, status: :created
        else
          render json: { error: "No attachment provided" }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/issues/:id/attachments/:attachment_id
      def delete_attachment
        attachment = ActiveStorage::Attachment.find_by(id: params[:attachment_id])

        if attachment.nil?
          render json: { error: "Attachment not found" }, status: :not_found
        elsif attachment.record_id != @issue.id
          render json: { error: "Attachment does not belong to this issue" }, status: :forbidden
        else
          attachment.purge
          head :no_content
        end
      end
    end
  end
end
