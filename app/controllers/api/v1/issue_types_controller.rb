module Api
  module V1
    class IssueTypesController < BaseController
      # Ya no es necesario omitir verificación CSRF, se maneja en BaseController
      before_action :set_issue_type, only: [:update, :destroy]

      # GET /api/v1/issue_types
      def index
        @issue_types = IssueType.all
        render json: @issue_types
      end

      # POST /api/v1/issue_types
      def create
        @issue_type = IssueType.new(issue_type_params)
        if @issue_type.save
          render json: @issue_type, status: :created
        else
          render json: { errors: @issue_type.errors }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/issue_types/:id
      def update
        if @issue_type.update(issue_type_params)
          render json: @issue_type
        else
          render json: { errors: @issue_type.errors }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/issue_types/:id
      def destroy
        # Comprobar si el tipo de issue tiene issues asociadas
        issues_count = Issue.where(issue_type_id: @issue_type.id).count

        if issues_count > 0
          # Si tiene issues asociadas, verificar que hay otros tipos disponibles
          other_types_count = IssueType.where.not(id: @issue_type.id).count

          if other_types_count == 0
            return render json: {
              error: "No se puede eliminar el último tipo de issue disponible mientras tenga issues asociadas"
            }, status: :unprocessable_entity
          end

#Verificar si se proporcionó un ID de destino
          unless params[:issues_go_to_id].present?
            return render json: {
              error: "Este tipo de issue tiene #{issues_count} issues asociadas. Debe proporcionar issues_go_to_id para migrarlas."
            }, status: :unprocessable_entity
          end

#Verificar que el tipo de destino existe
          destination_type = IssueType.find_by(id: params[:issues_go_to_id])

          unless destination_type
            return render json: {
              error: "El tipo de issue de destino con ID #{params[:issues_go_to_id]} no existe"
            }, status: :unprocessable_entity
          end

#Verificar que no estamos intentando migrar al mismo tipo
          if destination_type.id == @issue_type.id
            return render json: {
              error: "No puede migrar issues al mismo tipo que está intentando eliminar"
            }, status: :unprocessable_entity
          end

#Migrar las issues al nuevo tipo
          Issue.where(issue_type_id: @issue_type.id).update_all(issue_type_id: destination_type.id)
        end

#Eliminar el tipo
        if @issue_type.destroy
          render json: {
            message: issues_count > 0 ?
              "Tipo de issue eliminado correctamente. #{issues_count} issues migradas al tipo '#{IssueType.find(params[:issues_go_to_id]).name}'" :
              "Tipo de issue eliminado correctamente"
          }, status: :ok
        else
          render json: { errors: @issue_type.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_issue_type
        @issue_type = IssueType.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Issue type not found" }, status: :not_found
        return
      end

      def issue_type_params
        params.require(:issue_type).permit(:name, :color, :position)
      end
    end
  end
end