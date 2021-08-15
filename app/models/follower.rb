# A follow edge: follower_id follows following_id.
class Follower < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :following_id }
  validate :not_following_self

  private

  def not_following_self
    errors.add(:following, "can't be yourself") if follower_id.present? && follower_id == following_id
  end
end
