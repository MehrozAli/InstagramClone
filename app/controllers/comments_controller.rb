class CommentsController < ApplicationController
  before_action :set_post, only: %i[edit create update destroy]
  before_action :set_comment, only: %i[edit update destroy]
  before_action :authorize_comment, except: %i[create]

  def edit; end

  def create
    comment = @post.comments.new(comment_params)
    if comment.save
      flash[:notice] = 'Comment created successfully'
    else
      flash[:alert] = 'Comment could not be created'
      redirect_back(fallback_location: home_path)
    end
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = 'Comment updated'
    else
      render action: :edit, alert: 'Comment could not be updated!'
    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = 'Comment deleted!'
    else
      redirect_to home_path, alert: 'Could not delete comment.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_body, :user_id)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def authorize_comment
    authorize @comment
  end
end
