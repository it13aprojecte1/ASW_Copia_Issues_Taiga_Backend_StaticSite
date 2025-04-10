class IssuesController < ApplicationController
  before_action :set_issue, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  #Action que oculta la barra de navegacion donde tenemos el cerrar sesion en el momento que estoy haciendo esto
  before_action :hide_navbar, only: [:new]
  before_action :set_filter_options, only: [:index]

  # GET /issues or /issues.json
  def index
    @issues = Issue.all.includes(:issue_type, :severity, :priority, :status, :user)

    # Aplicar filtro si existe
    if params[:filter].present?
      @issues = filter_issues(@issues, params[:filter])
    elsif session[:issues_filter].present?
      @issues = filter_issues(@issues, session[:issues_filter])
    end

    # Aplicar búsqueda si existe
    if params[:search].present?
      @issues = @issues.where("subject LIKE ?", "%#{params[:search]}%")
    end

    apply_filters

    # Aplicar ordenación
    sort_column = params[:sort] || session[:issues_sort] || "updated_at"
    sort_direction = params[:direction] || session[:issues_direction] || "desc"

    # Ordenar según el campo
    case sort_column
    when "issue_type_id"
      @issues = @issues.joins(:issue_type).order("issue_types.name #{sort_direction}")
    when "severity_id"
      @issues = @issues.joins(:severity).order("severities.name #{sort_direction}")
    when "priority_id"
      @issues = @issues.joins(:priority).order("priorities.name #{sort_direction}")
    when "status_id"
      @issues = @issues.joins(:status).order("statuses.name #{sort_direction}")
    when "user_id"
      @issues = @issues.joins("LEFT JOIN users ON issues.user_id = users.id").order("users.email #{sort_direction}")
    else
      @issues = @issues.order("#{sort_column} #{sort_direction}")
    end

    # Acción para mostrar/ocultar el panel de filtros
  def toggle_filters
    session[:show_filters] = !session[:show_filters]

    # Redireccionar de vuelta a la página de issues manteniendo los parámetros actuales
    redirect_to issues_path(request.parameters.except(:action, :controller))
  end

  # Acción para añadir un nuevo filtro
  def add_filter
    filter_type = params[:filter_type]
    filter_value = params[:filter_value]
    filter_mode = params[:filter_mode] || "include"

    # Inicializar sesión de filtros si no existe
    session[:filters] ||= {
      include: {}
    }

    # Añadir el filtro al modo correspondiente
    session[:filters][filter_mode.to_sym][filter_type] ||= []

    # Añadir el valor si no está ya presente
    unless session[:filters][filter_mode.to_sym][filter_type].include?(filter_value)
      session[:filters][filter_mode.to_sym][filter_type] << filter_value
    end

    # Redireccionar de vuelta a la página de issues
    redirect_to issues_path(request.parameters.except(:action, :controller, :filter_type, :filter_value, :filter_mode))
  end

  # Acción para eliminar un filtro
  def remove_filter
    filter_type = params[:filter_type]
    filter_value = params[:filter_value]
    filter_mode = params[:filter_mode] || "include"

    # Eliminar el filtro si existe
    if session[:filters] &&
       session[:filters][filter_mode.to_sym] &&
       session[:filters][filter_mode.to_sym][filter_type]

      session[:filters][filter_mode.to_sym][filter_type].delete(filter_value)

      # Eliminar el tipo de filtro si está vacío
      if session[:filters][filter_mode.to_sym][filter_type].empty?
        session[:filters][filter_mode.to_sym].delete(filter_type)
      end

      # Eliminar el modo si está vacío
      if session[:filters][filter_mode.to_sym].empty?
        session[:filters].delete(filter_mode.to_sym)
      end
    end

    # Redireccionar de vuelta a la página de issues
    redirect_to issues_path(request.parameters.except(:action, :controller, :filter_type, :filter_value, :filter_mode))
  end

  # Acción para limpiar todos los filtros
  def clear_filters
    session[:filters] = nil
    redirect_to issues_path(request.parameters.except(:action, :controller))
  end

  end

  # GET /issues/1 or /issues/1.json
  def show
  end

  # GET /issues/new con ejemplo de valores posibles (esto en la BD se guarda con los numeros concretos que tenemos
  #en el model de issue.rb)
 def new
  @issue = Issue.new(
    priority_id: Priority.find_by(name: 'Normal')&.id,
    severity_id: Severity.find_by(name: 'Normal')&.id,
    issue_type_id: IssueType.find_by(name: 'Bug')&.id,
    status_id: Status.find_by(name: 'New')&.id
  )
end


  # GET /issues/1/edit
  def edit

  end

  # POST /issues or /issues.json crea el issue i li assigna el user sino no en té cap d'assignat
def create
  @issue = current_user.issues.build(issue_params)
  logger.debug "PARAMS: #{params.inspect}"

  if @issue.save
    redirect_to issues_path, notice: "Issue creada correctamente."
  else
    render :new, status: :unprocessable_entity
  end
end

  # PATCH/PUT /issues/1 or /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to root_path, notice: "Issue was successfully updated." }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1 or /issues/1.json
  def destroy
    @issue.destroy!

    respond_to do |format|
      format.html { redirect_to issues_path, status: :see_other, notice: "Issue was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def bulk_new
    # Solo necesitamos renderizar la vista
  end

def bulk_create
  if params[:bulk_issues].present?
    lines = params[:bulk_issues].split("\n").map(&:strip).reject(&:empty?)

    lines.each do |line|
      Issue.create(
        subject: line,
        user_id: current_user.id,
        issue_type_id: IssueType.find_by(name: 'Bug')&.id,
        severity_id: Severity.find_by(name: 'Normal')&.id,
        priority_id: Priority.find_by(name: 'Normal')&.id,
        status_id: Status.find_by(name: 'New')&.id,
        created_at: Date.today
      )
    end

    redirect_to issues_path, notice: "#{lines.count} issues were created successfully!"
  else
    redirect_to bulk_new_issues_path, alert: "No issues were provided"
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_issue
  @issue = Issue.find(params[:id])
  end
    # Only allow a list of trusted parameters through.
  def issue_params
  params.require(:issue).permit(:subject, :content, :status_id, :issue_type_id, :severity_id, :priority_id)
  end

  def hide_navbar
    @hide_navbar = true
  end

  def filter_issues(issues, filter)
    case filter
    when "bug"
      issues.where(issue_type_id: IssueType.find_by(name: "Bug").id)
    when "feature"
      issues.where(issue_type_id: IssueType.find_by(name: "Feature").id)
    when "high_priority"
      issues.where(priority_id: Priority.find_by(name: "High").id)
    when "low_severity"
      issues.where(severity_id: Severity.find_by(name: "Low").id)
    # Añade más casos según tus necesidades
    else
      issues
    end
  end

  def sort_direction(column)
    if params[:sort] == column && params[:direction] == "desc"
      "asc"
    else
      "desc"  # La primera vez será descendente
    end
  end
  helper_method :sort_direction

  def get_display_name(filter_type, value_id)
    case filter_type
    when "type"
      IssueType.find_by(id: value_id)&.name || "Unknown Type"
    when "severity"
      Severity.find_by(id: value_id)&.name || "Unknown Severity"
    when "priority"
      Priority.find_by(id: value_id)&.name || "Unknown Priority"
    when "status"
      Status.find_by(id: value_id)&.name || "Unknown Status"
    when "assigned_to"
      User.find_by(id: value_id)&.email || "Unknown User"
    when "created_by"
      User.find_by(id: value_id)&.email || "Unknown User"
    else
      "Unknown"
    end
  end
  helper_method :get_display_name

  def set_filter_options
    # Opciones disponibles para cada tipo de filtro
    @severity_options = Severity.all
    @priority_options = Priority.all
    @type_options = IssueType.all
    @status_options = Status.all
    @user_options = User.all

    # Si no hay filtros en la sesión, inicializarlos
    session[:filters] ||= {
      include: {}
    }

    # Conteo de filtros activos para mostrar en el botón
    @active_filters_count = 0

    if session[:filters]
      session[:filters].each do |mode, filters|
        filters.each do |type, values|
          @active_filters_count += values.size
        end
      end
    end
  end

  def apply_filters
    return unless session[:filters]

    # Aplicar filtros de inclusión
    if session[:filters][:include].present?
      session[:filters][:include].each do |filter_type, values|
        next if values.empty?

        case filter_type
        when "type"
          @issues = @issues.where(issue_type_id: values)
        when "severity"
          @issues = @issues.where(severity_id: values)
        when "priority"
          @issues = @issues.where(priority_id: values)
        when "status"
          @issues = @issues.where(status_id: values)
        when "assigned_to"
          @issues = @issues.where(user_id: values)
        when "created_by"
          @issues = @issues.where(creator_id: values)
        end
      end
    end
  end
end