class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_one :library
  has_many :library_users
  has_many :books
  has_many :checkouts
  has_many :notifications
  has_many :wishlists
  has_many :reviews
  has_many :libraries, through: :library_users

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  # validates :email_confirmation, presence: true, if: :email_changed?

  #instance method
  def library_admin?(library)
    library_users.exists?(library: library, is_admin: true)
  end
end
