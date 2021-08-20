class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:profile]
  before_action :set_recommended_users, only: [:index]

  def index
    @posts = Post.where(user_id: @following_ids).active.includes(:likes, :comments)
    @comment = Comment.new
  end

  def profile; end

  def follow_user
    user_id = params[:follow_id]
    redirect_to home_path if Follower.create!(follower_id: current_user.id, following_id: user_id)
  end

  private

  def set_user
    @user = User.find_by_username(params[:username])
    @user_posts = @user.posts.active
  end

  def set_recommended_users
    @following_ids = Follower.where(follower_id: current_user.id).pluck(:following_id)
    @following_ids << current_user.id
    @recommended = User.where.not(id: @following_ids)
  end
end
