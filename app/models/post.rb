class Post < ApplicationRecord
  default_scope { order created_at: :desc }
  mount_uploader :image, ImageUploader

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user

  delegate :post_user, to: :user

  validates :user, :image, presence: true

  scope :active, -> { where active: true }
  scope :arePosts, -> { where post_type: 'post' }
  scope :areStories, -> { where post_type: 'story' }

  def image_url
    image.url
  end

  # Likes the post for +user+, or removes their like if it exists.
  # Returns true when the post ends up liked.
  def toggle_like_by(user)
    like = likes.find_by(user: user)
    if like
      like.destroy!
      reload
      false
    else
      likes.create!(user: user)
      reload
      true
    end
  end
end
