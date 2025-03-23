class CommentsController < ApplicationController
  before_action :authenticate_user! # Asegura que el usuario esté logueado

  def create
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @issue, notice: 'Comentario creado con éxito.'
    else
      redirect_to @issue, alert: 'No se pudo crear el comentario.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end