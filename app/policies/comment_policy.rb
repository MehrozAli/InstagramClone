class CommentPolicy < ApplicationPolicy
  def edit?
    comment_owner?
  end

  def update?
    comment_owner?
  end

  def destroy?
    comment_owner?
  end

  private

  def comment_owner?
    owner? || user.id == record.post_owner
  end
end
