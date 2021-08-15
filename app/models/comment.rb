class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
  belongs_to :user

  validates :comment_body, :post_id, :user_id, presence: true

  def post_owner
    post.user_id
  end
end
