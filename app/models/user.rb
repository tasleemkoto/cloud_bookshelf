class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :library_users
  has_many :books
  has_many :checkouts
  has_many :notifications
  has_many :wishlists
  has_many :reviews
  has_many :libraries, through: :library_users

  validates :email, presence: false, uniqueness: true
  # validates :email_confirmation, presence: true, if: :email_changed?
end
