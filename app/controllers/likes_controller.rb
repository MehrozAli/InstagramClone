class LikesController < ApplicationController
  before_action :authenticate_user!

  def like_post
    @post = Post.find(params[:id])
    authorize @post, :like?
    @liked = @post.toggle_like_by(current_user)
    respond_to { |format| format.js { render 'like' } }
  end
end
