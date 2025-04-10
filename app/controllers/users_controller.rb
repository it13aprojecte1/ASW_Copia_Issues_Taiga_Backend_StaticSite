class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy profile update_avatar update_bio ]
  before_action :authenticate_user!, only: %i[ profile update_avatar update_bio ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

    # GET /users/1/profile
    def profile
      @assigned_issues = @user.assigned_issues
      @watched_issues = @user.watched_issues
      @comments = @user.comments.includes(:issue).order(created_at: :desc)
      @active_tab = params[:tab] || 'assigned_issues'
    end

    # PATCH /users/1/update_avatar
    def update_avatar
      # Verificar que el usuario actual solo pueda actualizar su propio avatar
      unless current_user == @user
        return redirect_to profile_user_path(@user), alert: "No tienes permiso para modificar este perfil."
      end

      respond_to do |format|
        if @user.update(params.require(:user).permit(:avatar))
          format.html { redirect_to profile_user_path(@user), notice: "Avatar was successfully updated." }
        else
          format.html { redirect_to profile_user_path(@user), alert: "Failed to update avatar." }
        end
      end
    end

    # PATCH /users/1/update_bio
    def update_bio
      # Verificar que el usuario actual solo pueda actualizar su propia bio
      unless current_user == @user
        return redirect_to profile_user_path(@user), alert: "No tienes permiso para modificar este perfil."
      end

      respond_to do |format|
        if @user.update(params.require(:user).permit(:bio))
          format.html { redirect_to profile_user_path(@user), notice: "Bio was successfully updated." }
        else
          format.html { redirect_to profile_user_path(@user), alert: "Failed to update bio." }
        end
      end
    end


  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to new_user_session_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end





 private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      # Redirigir si el ID es "sign_out"
    if params[:id] == "sign_out"
    # Redirigir a la ruta correcta de cierre de sesiÃ³n
    return redirect_to new_user_session_path
  end

  @user = User.find(params[:id])
end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :bio, :avatar)
    end
end
