module CommentsHelper
  def can_alter_comment?(comment)
    current_user.id == comment.user_id || current_user.id == comment.post_owner
  end
end
