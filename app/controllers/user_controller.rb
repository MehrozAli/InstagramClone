class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:profile]

  def index
    @posts = current_user.posts.active.includes(:likes)
    @recommended = User.where.not(id: current_user.id)
  end

  def profile
    @user_posts = @user.posts.active
  end

  private

  def set_user
    @user = User.find_by_username(params[:username])
  end
end
