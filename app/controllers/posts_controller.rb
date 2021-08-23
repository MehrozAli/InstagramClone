class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_post, except: %i[show create new]

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    if current_user.posts.create!(post_params)
      redirect_to home_path, notice: 'Post Uploaded!'
    else
      redirect_to new_post_path, alert: 'Post could not be uploaded.'
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post updated!'
    else
      render 'edit', alert: 'Could not update post'
    end
  end

  def destroy
    if @post.destroy!
      redirect_to home_path, notice: 'Post deleted!'
    else
      redirect_to home_path, alert: 'Could not delete post!'
    end
  end

  private

  def post_params
    params.require(:post).permit(:image, :image_cache)
  end

  def set_post
    @post = Post.includes(:comments).find(params[:id])
  end

  def authorize_post
    authorize @post
  end
end
