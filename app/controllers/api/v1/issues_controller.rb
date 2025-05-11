module Api
  module V1
    class IssuesController < ApplicationController
      # Omitir verificación CSRF para API
      skip_before_action :verify_authenticity_token
      # Incluir todas las acciones que necesitan el callback set_issue
      before_action :set_issue, only: [:show, :update, :destroy, :attachments, :add_attachment, :delete_attachment]

      # GET /api/v1/issues
      def index
        @issues = Issue.all.includes(:issue_type, :severity, :priority, :status, :user)

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

        render json: @issues.as_json(include: [:issue_type, :severity, :priority, :status, :user])
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
          # Sanear los parámetros para evitar errores
          update_params = issue_params

          # Asegurarse de que watcher_ids sea un array si está presente
          if update_params[:watcher_ids].present? && !update_params[:watcher_ids].is_a?(Array)
            update_params[:watcher_ids] = [update_params[:watcher_ids]].flatten.compact
          end

          # Intentar actualizar el issue
          if @issue.update(update_params)
            render json: @issue.as_json(include: [:issue_type, :severity, :priority, :status, :user])
          else
            render json: { errors: @issue.errors }, status: :unprocessable_entity
          end
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

      private

      def set_issue
        @issue = Issue.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Issue not found" }, status: :not_found
      end

      def issue_params
        params.require(:issue).permit(:subject, :content, :status_id, :issue_type_id, :severity_id, :priority_id, :assignee_id, { watcher_ids: [] })
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
