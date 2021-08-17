class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  validates :email, :username, :first_name, presence: true
  validates :email, uniqueness: true
  validates_associated :posts

  def full_name
    "#{first_name} #{last_name}"
  end
end