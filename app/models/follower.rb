class Follower < ApplicationRecord
  validates :follower_id, uniqueness: { scope: :following_id }
end
