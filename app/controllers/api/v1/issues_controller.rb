module Api
  module V1
    class IssuesController < ApplicationController
      # Omitir verificación CSRF para API
      skip_before_action :verify_authenticity_token
      before_action :set_issue, only: [:show, :update, :destroy]

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
        @issue.user_id = current_user.id if current_user

        if @issue.save
          render json: @issue, status: :created
        else
          render json: { errors: @issue.errors }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/issues/:id
      def update
        if @issue.update(issue_params)
          render json: @issue
        else
          render json: { errors: @issue.errors }, status: :unprocessable_entity
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
    end
  end
end
