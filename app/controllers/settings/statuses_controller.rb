class Settings::StatusesController < ApplicationController
  before_action :set_status, only: [:edit, :update, :destroy]

  def index
    @statuses = Status.order(:position)
  end

  def new
    @status = Status.new
  end

  def create
    @status = Status.new(status_params)

    if @status.save
      redirect_to settings_statuses_path, notice: 'Status creado correctamente.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @status.update(status_params)
      redirect_to settings_statuses_path, notice: 'Status actualizado correctamente.'
    else
      render :edit
    end
  end

  def destroy
    @status.destroy
    redirect_to settings_statuses_path, notice: 'Status eliminado correctamente.'
  end

  private

  def set_status
    @status = Status.find(params[:id])
  end

  def status_params
    params.require(:status).permit(:name, :color, :is_closed, :position)
  end
end
