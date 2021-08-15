module PostsHelper
  # Uses the preloaded likes when the feed has included them.
  def post_already_liked_by_user?(post)
    post.likes.any? { |like| like.user_id == current_user.id }
  end

  def can_alter_post?(post)
    user_signed_in? && policy(post).update?
  end
end
