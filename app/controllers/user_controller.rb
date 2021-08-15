class UserController < ApplicationController
  SEARCH_LIMIT = 50
  SUGGESTION_LIMIT = 5

  before_action :authenticate_user!

  def index
    visible_ids = current_user.outgoing_follows.pluck(:following_id) << current_user.id
    @posts = Post.includes(:user, :likes, comments: :user).where(user_id: visible_ids).arePosts.active
    @stories = Post.includes(:user).where(user_id: visible_ids).areStories.active
    @recommended = User.where.not(id: visible_ids).order(:created_at).limit(SUGGESTION_LIMIT)
  end

  def profile
    @user = User.find_by!(username: params[:username])
    @user_posts = @user.posts.arePosts.active
  end

  def follow_user
    follow = current_user.outgoing_follows.new(following_id: params[:follow_id])
    if follow.save
      redirect_back_or_to home_path, notice: 'Followed!'
    else
      redirect_back_or_to home_path, alert: "Could not follow: #{follow.errors.full_messages.to_sentence}"
    end
  end

  def unfollow_user
    follow = current_user.outgoing_follows.find_by(following_id: params[:follow_id])
    if follow&.destroy
      redirect_back_or_to search_path, notice: 'Unfollowed!'
    else
      redirect_back_or_to home_path, alert: 'You are not following that user.'
    end
  end

  def search
    if params[:search].blank?
      redirect_to home_path
    else
      term = "%#{User.sanitize_sql_like(params[:search].strip)}%"
      @results = User.where('username ILIKE :term OR first_name ILIKE :term OR last_name ILIKE :term', term: term)
                     .order(:username).limit(SEARCH_LIMIT)
    end
  end
end
