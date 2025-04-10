class Settings::IssueTypesController < ApplicationController
  before_action :set_issue_type, only: [:edit, :update, :destroy]

  def index
    @issue_types = IssueType.order(:position)
  end

  def new
    @issue_type = IssueType.new
  end

  def create
    @issue_type = IssueType.new(issue_type_params)

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
    if @issue_type.update(issue_type_params)
      redirect_to settings_issue_types_path, notice: 'Tipo de Incidencia actualizado correctamente.'
    else
      render :edit
    end
  end

  def destroy
    @issue_type.destroy
    redirect_to settings_issue_types_path, notice: 'Tipo de Incidencia eliminado correctamente.'
  end

  private

  def set_issue_type
    @issue_type = IssueType.find(params[:id])
  end

  def issue_type_params
    params.require(:issue_type).permit(:name, :color, :position)
  end
end
