class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:profile]
  before_action :set_recommended_users, only: [:index]

  def index
    @posts = Post.includes(:likes, :comments).where(user_id: @following_ids).arePosts.active
    @stories = Post.where(user_id: @following_ids).areStories.active
    @comment = Comment.new
  end

  def profile; end

  def follow_user
    follower = Follower.new(follower_id: current_user.id, following_id: params[:follow_id])
    if follower.save
      redirect_to home_path, notice: 'Followed!'
    else
      redirect_to home_path, alert: 'Something went wrong!'
    end
  end

  def unfollow_user
    @follower = Follower.find_by(follower_id: current_user.id, following_id: params[:follow_id])
    if @follower.destroy
      redirect_to search_path, notice: 'Unfollowed!'
    else
      redirect_to search_path, alert: 'Something went wrong'
    end
  end

  def search
    if params[:search].blank?
      redirect_to home_path
    else
      @results = User.where('username LIKE :name', name: "%#{params[:search]}%")
    end
  end

  private

  def set_user
    @user = User.find_by_username(params[:username])
    @user_posts = @user.posts.arePosts.active
  end

  def set_recommended_users
    @following_ids = Follower.where(follower_id: current_user.id).pluck(:following_id)
    @following_ids << current_user.id
    @recommended = User.where.not(id: @following_ids)
  end
end
