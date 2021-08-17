class Post < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :user

  validates :user, :image, presence: true

  scope :active, -> { where active: true }

  def image_url
    image.url
  end
end
