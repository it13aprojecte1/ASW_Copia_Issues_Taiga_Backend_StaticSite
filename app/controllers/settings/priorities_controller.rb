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
    if @priority.update(priority_params)
      redirect_to settings_priorities_path, notice: 'Prioridad actualizada correctamente.'
    else
      render :edit
    end
  end

  def destroy
    @priority.destroy
    redirect_to settings_priorities_path, notice: 'Prioridad eliminada correctamente.'
  end

  private

  def set_priority
    @priority = Priority.find(params[:id])
  end

  def priority_params
    params.require(:priority).permit(:name, :color, :position)  # Aquí no necesitamos `:is_closed`
  end
end

