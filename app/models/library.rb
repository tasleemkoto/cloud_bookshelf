class Library < ApplicationRecord
  # association
  has_many :books
  has_many :library_users
  has_many :users, through: :library_users

  validates :name, presence: true, uniqueness: true
  validates :unique_id, presence: true, uniqueness: true
end
