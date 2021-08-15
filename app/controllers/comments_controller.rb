class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: %i[edit update destroy]

  def edit; end

  def create
    @comment = @post.comments.new(comment_params.merge(user: current_user))
    authorize @comment
    if @comment.save
      flash.now[:notice] = 'Comment created successfully'
    else
      flash.now[:alert] = 'Comment could not be created'
    end
  end

  def update
    if @comment.update(comment_params)
      flash.now[:notice] = 'Comment updated'
    else
      flash.now[:alert] = 'Comment could not be updated'
    end
  end

  def destroy
    @comment.destroy!
    flash.now[:notice] = 'Comment deleted!'
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_body)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
    authorize @comment
  end
end
