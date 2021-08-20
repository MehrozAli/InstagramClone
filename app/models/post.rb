class Post < ApplicationRecord
  default_scope { order created_at: :desc }
  mount_uploader :image, ImageUploader

  has_many :likes, dependent: :destroy
  belongs_to :user

  validates :user, :image, presence: true

  scope :active, -> { where active: true }

  def image_url
    image.url
  end

  def post_user
    user.full_name
  end
end
