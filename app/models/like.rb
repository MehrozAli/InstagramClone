class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :post_id, uniqueness: { scope: :user_id }

  after_create :increment_like_count
  after_destroy :decrement_like_count

  private

  def increment_like_count
    post.increment(:likes_count).save
  end

  def decrement_like_count
    post.decrement(:likes_count).save
  end
end
