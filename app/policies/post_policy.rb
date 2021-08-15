class PostPolicy < ApplicationPolicy
  def show?
    owner? || !record.user.isPrivate || user.following?(record.user_id)
  end

  def like?
    show?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end
end
