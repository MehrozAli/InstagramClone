module PostsHelper
  def post_already_liked_by_user?(post)
    post.likes.find_by_user_id(current_user.id).present?
  end
end
