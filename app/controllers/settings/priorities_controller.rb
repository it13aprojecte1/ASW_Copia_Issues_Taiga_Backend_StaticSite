class Settings::PrioritiesController < ApplicationController
  before_action :set_priority, only: [:edit, :update, :destroy]

  def index
    @priorities = Priority.order(:position)
  end

  def new
    @priority = Priority.new
  end

  def create
    @priority = Priority.new(priority_params)

    # Check if position already exists and shift if needed
    shift_positions_down(@priority.position) if Priority.exists?(position: @priority.position)

    if @priority.save
      redirect_to settings_priorities_path, notice: 'Prioridad creada correctamente.'
    else
      render :new
    end
  end

  def edit
    # Se carga la prioridad a editar
  end

  def update
    old_position = @priority.position
    new_position = priority_params[:position].to_i

    if old_position != new_position
      if new_position > old_position
        # Moving down: shift intermediate elements up
        Priority.where('position > ? AND position <= ?', old_position, new_position)
                .update_all('position = position - 1')
      else
        # Moving up: shift intermediate elements down
        Priority.where('position >= ? AND position < ?', new_position, old_position)
                .update_all('position = position + 1')
      end

      # Update the position of the current priority directly
      @priority.update_column(:position, new_position)
    end

    if @priority.update(priority_params)
      redirect_to settings_priorities_path, notice: 'Prioridad actualizada correctamente.'
    else
      render :edit
    end
  end

  def destroy
    position = @priority.position
    @priority.destroy

    # Reorder positions after deletion: move all higher positions down by 1
    Priority.where('position > ?', position)
            .update_all('position = position - 1')

    redirect_to settings_priorities_path, notice: 'Prioridad eliminada correctamente.'
  end

  private

  def set_priority
    @priority = Priority.find(params[:id])
  end

  def priority_params
    params.require(:priority).permit(:name, :color, :position)  # AquÃ­ no necesitamos `:is_closed`
  end

  # Shifts all items at or below the given position down by one
  def shift_positions_down(position)
    Priority.where('position >= ?', position)
            .update_all('position = position + 1')
  end
end