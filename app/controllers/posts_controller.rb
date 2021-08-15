class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_post, except: %i[show create new add_story create_story]

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      ClearStoryJob.delay(run_at: 2.minutes.from_now).perform_later(@post.id) if @post.post_type == 'story'
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
    if @post.destroy
      redirect_to home_path, notice: 'Post deleted!'
    else
      redirect_to home_path, alert: 'Could not delete post!'
    end
  end

  def add_story
    @post = Post.new(post_type: 'story')
    render 'new'
  end

  private

  def post_params
    params.require(:post).permit(:image, :image_cache, :post_type)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_post
    authorize @post
  end
end
