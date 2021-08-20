class LikesController < ApplicationController
  before_action :check_like_exists?, only: [:like_post]

  def like_post
    @post_id = params[:id]

    respond_to do |format|
      format.js do
        @success = LikeCreator.new(@already_liked, @post_id, current_user.id).execute
        @total_likes_count = get_post_likes(@post_id)
        render 'like'
      end
    end
  end

  private

  def check_like_exists?
    @already_liked = Like.find_by(post_id: params[:id], user_id: current_user.id)
  end

  def get_post_likes(post_id)
    Post.find(post_id).likes_count
  end
end
