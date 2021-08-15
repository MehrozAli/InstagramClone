class CommentPolicy < ApplicationPolicy
  def create?
    PostPolicy.new(user, record.post).show?
  end

  # Only the author may change the wording of a comment.
  def update?
    owner?
  end

  # The post owner may also remove comments left on their post.
  def destroy?
    owner? || user.id == record.post_owner
  end
end
