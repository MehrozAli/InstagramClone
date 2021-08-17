class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    if current_user.posts.create(post_params)
      redirect_to home_path
    else
      redirect_to new_post_path
    end
  end

  def show; end

  private

  def post_params
    params.require(:post).permit(:image, :image_cache)
  end
end
