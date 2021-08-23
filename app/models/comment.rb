class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :comment_body, :post_id, :user_id, presence: true

  after_create :increment_comment_count
  after_destroy :decrement_comment_count

  def post_owner
    Post.find(post_id).user_id
  end

  private

  def increment_comment_count
    Post.find(post_id).increment(:comments_count).save
  end

  def decrement_comment_count
    Post.find(post_id).decrement(:comments_count).save
  end
end
