module PostsHelper
  def post_already_liked_by_user?(post)
    post.likes.find_by_user_id(current_user.id).present?
  end

  def can_alter_post?(post_id)
    current_post = Post.find(post_id)
    user_signed_in? && current_user.id == current_post.user_id
  end
end
