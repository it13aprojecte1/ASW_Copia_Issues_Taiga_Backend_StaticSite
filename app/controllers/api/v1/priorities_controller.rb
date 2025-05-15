module Api
  module V1
    class PrioritiesController < BaseController
      # Ya no es necesario omitir verificación CSRF, se maneja en BaseController
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
        # Comprobar si la prioridad tiene issues asociadas
        issues_count = Issue.where(priority_id: @priority.id).count

        if issues_count > 0
          # Si tiene issues asociadas, verificar que hay otras prioridades disponibles
          other_priorities_count = Priority.where.not(id: @priority.id).count

          if other_priorities_count == 0
            return render json: {
              error: "No se puede eliminar la última prioridad disponible mientras tenga issues asociadas"
            }, status: :unprocessable_entity
          end

#Verificar si se proporcionó un ID de destino
          unless params[:issues_go_to_id].present?
            return render json: {
              error: "Esta prioridad tiene #{issues_count} issues asociadas. Debe proporcionar issues_go_to_id para migrarlas."
            }, status: :unprocessable_entity
          end

#Verificar que la prioridad de destino existe
          destination_priority = Priority.find_by(id: params[:issues_go_to_id])

          unless destination_priority
            return render json: {
              error: "La prioridad de destino con ID #{params[:issues_go_to_id]} no existe"
            }, status: :unprocessable_entity
          end

#Verificar que no estamos intentando migrar a la misma prioridad
          if destination_priority.id == @priority.id
            return render json: {
              error: "No puede migrar issues a la misma prioridad que está intentando eliminar"
            }, status: :unprocessable_entity
          end

#Migrar las issues a la nueva prioridad
          Issue.where(priority_id: @priority.id).update_all(priority_id: destination_priority.id)
        end

#Eliminar la prioridad
        if @priority.destroy
          render json: {
            message: issues_count > 0 ?
              "Prioridad eliminada correctamente. #{issues_count} issues migradas a la prioridad '#{Priority.find(params[:issues_go_to_id]).name}'" :
              "Prioridad eliminada correctamente"
          }, status: :ok
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