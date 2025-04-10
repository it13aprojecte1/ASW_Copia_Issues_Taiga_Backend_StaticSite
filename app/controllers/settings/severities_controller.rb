class Settings::SeveritiesController < ApplicationController
  before_action :set_severity, only: [:edit, :update, :destroy]

  def index
    @severities = Severity.order(:position)
  end

  def new
    @severity = Severity.new
  end

  def create
    @severity = Severity.new(severity_params)

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
    if @severity.update(severity_params)
      redirect_to settings_severities_path, notice: 'Severidad actualizada correctamente.'
    else
      render :edit
    end
  end

  def destroy
    @severity.destroy
    redirect_to settings_severities_path, notice: 'Severidad eliminada correctamente.'
  end

  private

  def set_severity
    @severity = Severity.find(params[:id])
  end

  def severity_params
    params.require(:severity).permit(:name, :color, :position)  # Aquí no necesitamos `:is_closed`
  end
end

