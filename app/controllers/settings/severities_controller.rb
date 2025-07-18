class Settings::SeveritiesController < ApplicationController
  before_action :set_severity, only: [:edit, :update, :destroy, :confirm_destroy]

  def index
    @severities = Severity.order(:position)
  end

  def new
    @severity = Severity.new
  end

  def create
    @severity = Severity.new(severity_params)

    # Check if position already exists and shift if needed
    shift_positions_down(@severity.position) if Severity.exists?(position: @severity.position)

    if @severity.save
      redirect_to settings_severities_path, notice: 'Severidad creada correctamente.'
    else
      render :new
    end
  end

  def edit
    # Se carga la severidad a editar
  end

  def update
    old_position = @severity.position
    new_position = severity_params[:position].to_i

    if old_position != new_position
      if new_position > old_position
        # Moving down: shift intermediate elements up
        Severity.where('position > ? AND position <= ?', old_position, new_position)
                .update_all('position = position - 1')
      else
        # Moving up: shift intermediate elements down
        Severity.where('position >= ? AND position < ?', new_position, old_position)
                .update_all('position = position + 1')
      end

      # Update the position of the current severity directly
      @severity.update_column(:position, new_position)
    end

    if @severity.update(severity_params)
      redirect_to settings_severities_path, notice: 'Severidad actualizada correctamente.'
    else
      render :edit
    end
  end

  # Muestra la página de confirmación de eliminación con el desplegable para seleccionar severidad destino
  def confirm_destroy
    # Obtener todas las severidades excepto la actual para mostrarlas en el desplegable
    @other_severities = Severity.where.not(id: @severity.id).order(:position)

    # Verificar si hay issues asociadas a esta severidad
    @has_issues = Issue.where(severity_id: @severity.id).exists?
  end

  def destroy
    position = @severity.position

    # Si se proporciona una severidad de reemplazo, actualizar todas las issues asociadas
    if params[:replacement_severity_id].present?
      Issue.where(severity_id: @severity.id).update_all(severity_id: params[:replacement_severity_id])
    end

    @severity.destroy

    # Reorder positions after deletion: move all higher positions down by 1
    Severity.where('position > ?', position)
            .update_all('position = position - 1')

    redirect_to settings_severities_path, notice: 'Severidad eliminada correctamente.'
  end

  private

  def set_severity
    @severity = Severity.find(params[:id])
  end

  def severity_params
    params.require(:severity).permit(:name, :color, :position)  # Aquí no necesitamos `:is_closed`
  end

  # Shifts all items at or below the given position down by one
  def shift_positions_down(position)
    Severity.where('position >= ?', position)
            .update_all('position = position + 1')
  end
end