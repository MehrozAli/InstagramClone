class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :profileImg, ImageUploader

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :outgoing_follows, class_name: 'Follower', foreign_key: :follower_id,
                              inverse_of: :follower, dependent: :destroy
  has_many :incoming_follows, class_name: 'Follower', foreign_key: :following_id,
                              inverse_of: :following, dependent: :destroy

  # Usernames appear in /profile/:username, so keep them URL-safe.
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       length: { maximum: 20 }, format: { with: /\A[a-zA-Z0-9_]+\z/ }
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, length: { maximum: 20 }

  def full_name
    "#{first_name} #{last_name}".strip
  end

  alias post_user full_name

  def total_followers
    incoming_follows.count
  end

  def total_following
    outgoing_follows.count
  end

  def following?(user_id)
    outgoing_follows.exists?(following_id: user_id)
  end
end
