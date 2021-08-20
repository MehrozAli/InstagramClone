class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :comment_body, :post_id, :user_id, presence: true
end
