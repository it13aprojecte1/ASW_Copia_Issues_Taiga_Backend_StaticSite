class IssuesController < ApplicationController
  before_action :set_issue, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  #Action que oculta la barra de navegacion donde tenemos el cerrar sesion en el momento que estoy haciendo esto
  before_action :hide_navbar, only: [:new]


  # GET /issues or /issues.json
  def index
    @issues = current_user.issues.order(created_at: :desc)


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

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_issue
  @issue = Issue.find(params[:id])
  end
    # Only allow a list of trusted parameters through.
  def issue_params
  params.require(:issue).permit(:subject, :content, :status_id, :issue_type_id, :severity_id, :priority_id, :deadline, :assignee_id, {watcher_ids: []})
  end

    def hide_navbar
    @hide_navbar = true
  end
end
