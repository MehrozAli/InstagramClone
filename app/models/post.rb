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
end
