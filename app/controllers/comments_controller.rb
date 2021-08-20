class CommentsController < ApplicationController
  before_action :set_post, only: [:create]

  def create
    redirect_to home_path if @post.comments.create!(comment_params)
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_body, :user_id)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
