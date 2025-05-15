module Api
  module V1
    class SeveritiesController < BaseController
      # Ya no es necesario omitir verificación CSRF, se maneja en BaseController
      before_action :set_severity, only: [:update, :destroy]

      # GET /api/v1/severities
      def index
        @severities = Severity.all
        render json: @severities
      end

      # POST /api/v1/severities
      def create
        @severity = Severity.new(severity_params)
        if @severity.save
          render json: @severity, status: :created
        else
          render json: { errors: @severity.errors }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/severities/:id
      def update
        if @severity.update(severity_params)
          render json: @severity
        else
          render json: { errors: @severity.errors }, status: :unprocessable_entity
        end
      end
          # DELETE /api/v1/severities/:id
      def destroy
        # Comprobar si la severidad tiene issues asociadas
        issues_count = Issue.where(severity_id: @severity.id).count

        if issues_count > 0
          # Si tiene issues asociadas, verificar que hay otras severidades disponibles
          other_severities_count = Severity.where.not(id: @severity.id).count

          if other_severities_count == 0
            return render json: {
              error: "No se puede eliminar la última severidad disponible mientras tenga issues asociadas"
            }, status: :unprocessable_entity
          end

          # Verificar si se proporcionó un ID de destino
          unless params[:issues_go_to_id].present?
            return render json: {
              error: "Esta severidad tiene #{issues_count} issues asociadas. Debe proporcionar issues_go_to_id para migrarlas."
            }, status: :unprocessable_entity
          end

          # Verificar que la severidad de destino existe
          destination_severity = Severity.find_by(id: params[:issues_go_to_id])

          unless destination_severity
            return render json: {
              error: "La severidad de destino con ID #{params[:issues_go_to_id]} no existe"
            }, status: :unprocessable_entity
          end

          # Verificar que no estamos intentando migrar a la misma severidad
          if destination_severity.id == @severity.id
            return render json: {
              error: "No puede migrar issues a la misma severidad que está intentando eliminar"
            }, status: :unprocessable_entity
          end

          # Migrar las issues a la nueva severidad
          Issue.where(severity_id: @severity.id).update_all(severity_id: destination_severity.id)
        end

        # Eliminar la severidad
        if @severity.destroy
          render json: {
            message: issues_count > 0 ?
              "Severidad eliminada correctamente. #{issues_count} issues migradas a la severidad '#{Severity.find(params[:issues_go_to_id]).name}'" :
              "Severidad eliminada correctamente"
          }, status: :ok
        else
          render json: { errors: @severity.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_severity
        @severity = Severity.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Severity not found" }, status: :not_found
      end

      def severity_params
        params.require(:severity).permit(:name, :color, :position)
      end
    end
  end
end