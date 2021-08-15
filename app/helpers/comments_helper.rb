module CommentsHelper
  def can_edit_comment?(comment)
    policy(comment).update?
  end

  def can_delete_comment?(comment)
    policy(comment).destroy?
  end
end
