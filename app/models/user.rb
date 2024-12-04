class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :library_users, dependent: :destroy
  has_many :libraries, through: :library_users
  has_many :books
  has_many :checkouts
  has_many :notifications
  has_many :wishlists
  has_many :reviews

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # Check if the user is an admin for a specific library
  def library_admin?(library)
    library_users.exists?(library: library, is_admin: true)
  end
end
