class Settings::IssueTypesController < ApplicationController
  before_action :set_issue_type, only: [:edit, :update, :destroy, :confirm_destroy]

  def index
    @issue_types = IssueType.order(:position)
  end

  def new
    @issue_type = IssueType.new
  end

  def create
    @issue_type = IssueType.new(issue_type_params)

    # Check if position already exists and shift if needed
    shift_positions_down(@issue_type.position) if IssueType.exists?(position: @issue_type.position)

    if @issue_type.save
      redirect_to settings_issue_types_path, notice: 'Tipo de Incidencia creado correctamente.'
    else
      render :new
    end
  end

  def edit
    # Se carga el tipo de incidencia a editar
  end

  def update
    old_position = @issue_type.position
    new_position = issue_type_params[:position].to_i

    if old_position != new_position
      if new_position > old_position
        # Moving down: shift intermediate elements up
        IssueType.where('position > ? AND position <= ?', old_position, new_position)
                 .update_all('position = position - 1')
      else
        # Moving up: shift intermediate elements down
        IssueType.where('position >= ? AND position < ?', new_position, old_position)
                 .update_all('position = position + 1')
      end

      # Update the position of the current issue_type directly
      @issue_type.update_column(:position, new_position)
    end

    if @issue_type.update(issue_type_params)
      redirect_to settings_issue_types_path, notice: 'Tipo de Incidencia actualizado correctamente.'
    else
      render :edit
    end
  end

  # Muestra la página de confirmación de eliminación con el desplegable para seleccionar tipo de incidencia destino
  def confirm_destroy
    # Obtener todos los tipos de incidencia excepto el actual para mostrarlos en el desplegable
    @other_issue_types = IssueType.where.not(id: @issue_type.id).order(:position)

    # Verificar si hay issues asociadas a este tipo de incidencia
    @has_issues = Issue.where(issue_type_id: @issue_type.id).exists?
  end

  def destroy
    position = @issue_type.position

    # Si se proporciona un tipo de incidencia de reemplazo, actualizar todas las issues asociadas
    if params[:replacement_issue_type_id].present?
      Issue.where(issue_type_id: @issue_type.id).update_all(issue_type_id: params[:replacement_issue_type_id])
    end

    @issue_type.destroy

    # Reorder positions after deletion: move all higher positions down by 1
    IssueType.where('position > ?', position)
             .update_all('position = position - 1')

    redirect_to settings_issue_types_path, notice: 'Tipo de Incidencia eliminado correctamente.'
  end

  private

  def set_issue_type
    @issue_type = IssueType.find(params[:id])
  end

  def issue_type_params
    params.require(:issue_type).permit(:name, :color, :position)
  end

  # Shifts all items at or below the given position down by one
  def shift_positions_down(position)
    IssueType.where('position >= ?', position)
             .update_all('position = position + 1')
  end
end