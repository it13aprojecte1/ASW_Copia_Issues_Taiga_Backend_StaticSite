module Api
  module V1
    class StatusesController < BaseController
      # Ya no es necesario omitir verificación CSRF, se maneja en BaseController
      before_action :set_status, only: [:update, :destroy]

      # GET /api/v1/statuses
      def index
        @statuses = Status.all
        render json: @statuses
      end

      # POST /api/v1/statuses
      def create
        @status = Status.new(status_params)
        shift_positions_up(@status.position) if Status.exists?(position: @status.position)
        if @status.save
          render json: @status, status: :created
        else
          render json: { errors: @status.errors }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/statuses/:id
      def update
        old_position = @status.position
        new_position = status_params[:position].to_i
        if old_position != new_position
          if new_position < old_position
            Status.where(position: new_position...old_position).update_all("position = position + 1")
          else
            Status.where(position: (old_position + 1)..new_position).update_all("position = position - 1")
          end
          @status.update_column(:position, new_position)
        end

        if @status.update(status_params)
          render json: @status
        else
          render json: { errors: @status.errors }, status: :unprocessable_entity
        end
      end
          # DELETE /api/v1/statuses/:id
      def destroy
        # Comprobar si el status tiene issues asociadas
        issues_count = Issue.where(status_id: @status.id).count

        if issues_count > 0
          # Si tiene issues asociadas, verificar que hay otros status disponibles
          other_statuses_count = Status.where.not(id: @status.id).count

          if other_statuses_count == 0
            return render json: {
              error: "No se puede eliminar el último estado disponible mientras tenga issues asociadas"
            }, status: :unprocessable_entity
          end

#Verificar si se proporcionó un ID de destino
          unless params[:issues_go_to_id].present?
            return render json: {
              error: "Este estado tiene #{issues_count} issues asociadas. Debe proporcionar issues_go_to_id para migrarlas."
            }, status: :unprocessable_entity
          end

#Verificar que el estado de destino existe
          destination_status = Status.find_by(id: params[:issues_go_to_id])

          unless destination_status
            return render json: {
              error: "El estado de destino con ID #{params[:issues_go_to_id]} no existe"
            }, status: :unprocessable_entity
          end

#Verificar que no estamos intentando migrar al mismo estado
          if destination_status.id == @status.id
            return render json: {
              error: "No puede migrar issues al mismo estado que está intentando eliminar"
            }, status: :unprocessable_entity
          end

#Migrar las issues al nuevo estado
          Issue.where(status_id: @status.id).update_all(status_id: destination_status.id)
        end

#Eliminar el estado
        shift_positions_down(@status.position) if Status.exists?(position: @status.position)
        if @status.destroy
          render json: {
            message: issues_count > 0 ?
              "Estado eliminado correctamente. #{issues_count} issues migradas al estado '#{Status.find(params[:issues_go_to_id]).name}'" :
              "Estado eliminado correctamente"
          }, status: :ok
        else
          render json: { errors: @status.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_status
        @status = Status.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Status not found" }, status: :not_found
      end

      def status_params
        params.require(:status).permit(:name, :color, :is_closed, :position)
      end

      def shift_positions_up(position)
        # Mover todas las posiciones mayores a la posición eliminada hacia arriba
        Status.where("position >= ?", position).update_all("position = position + 1")
      end

      def shift_positions_down(position)
        # Mover todas las posiciones menores a la posición eliminada hacia abajo
        Status.where("position > ?", position).update_all("position = position - 1")
      end
    end
  end
end