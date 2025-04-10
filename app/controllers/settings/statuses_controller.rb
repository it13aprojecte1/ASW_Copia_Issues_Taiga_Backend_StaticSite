class Settings::StatusesController < ApplicationController
  before_action :set_status, only: [:edit, :update, :destroy, :confirm_destroy]

  def index
    @statuses = Status.order(:position)
  end

  def new
    @status = Status.new
  end

  def create
    @status = Status.new(status_params)

    # Check if position already exists and shift if needed
    shift_positions_down(@status.position) if Status.exists?(position: @status.position)

    if @status.save
      redirect_to settings_statuses_path, notice: 'Status creado correctamente.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    old_position = @status.position
    new_position = status_params[:position].to_i

    if old_position != new_position
      if new_position > old_position
        # Moving down: shift intermediate elements up
        Status.where('position > ? AND position <= ?', old_position, new_position)
              .update_all('position = position - 1')
      else
        # Moving up: shift intermediate elements down
        Status.where('position >= ? AND position < ?', new_position, old_position)
              .update_all('position = position + 1')
      end

      # Update the position of the current status directly
      @status.update_column(:position, new_position)
    end

    if @status.update(status_params)
      redirect_to settings_statuses_path, notice: 'Status actualizado correctamente.'
    else
      render :edit, notice: 'Error'
    end
  end

  # Muestra la página de confirmación de eliminación con el desplegable para seleccionar status destino
  def confirm_destroy
    # Obtener todos los status excepto el actual para mostrarlos en el desplegable
    @other_statuses = Status.where.not(id: @status.id).order(:position)

    # Verificar si hay issues asociadas a este status
    @has_issues = Issue.where(status_id: @status.id).exists?
  end

  def destroy
    position = @status.position

    # Si se proporciona un status de reemplazo, actualizar todas las issues asociadas
    if params[:replacement_status_id].present?
      Issue.where(status_id: @status.id).update_all(status_id: params[:replacement_status_id])
    end

    @status.destroy

    # Reorder positions after deletion: move all higher positions down by 1
    Status.where('position > ?', position)
          .update_all('position = position - 1')

    redirect_to settings_statuses_path, notice: 'Status eliminado correctamente.'
  end

  private

  def set_status
    @status = Status.find(params[:id])
  end

  def status_params
    params.require(:status).permit(:name, :color, :is_closed, :position)
  end

  # Shifts all items at or below the given position down by one
  def shift_positions_down(position)
    Status.where('position >= ?', position)
          .update_all('position = position + 1')
  end
end