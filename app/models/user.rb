class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :profileImg, ImageUploader

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email, :username, :first_name, presence: true
  validates :email, :username, uniqueness: true
  validates_associated :posts

  def full_name
    "#{first_name} #{last_name}".strip
  end

  alias post_user full_name

  def total_followers
    Follower.where(following_id: id).count
  end

  def total_following
    Follower.where(follower_id: id).count
  end

  def following?(user_id)
    Follower.find_by(follower_id: id, following_id: user_id).present?
  end
end
