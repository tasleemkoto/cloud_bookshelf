class Library < ApplicationRecord
  # association
  belongs_to :user
  has_many :books, dependent: :destroy
  has_many :library_users, dependent: :destroy
  has_many :users, through: :library_users
  has_many :checkouts, dependent: :destroy
  has_many :notifications, dependent: :destroy
  # belongs_to :user
  # before_destroy :delete_associated_books
  has_one_attached :photo
  validates :name, presence: true, uniqueness: true
  validates :unique_id, presence: true, uniqueness: true

  # callbacks
  before_validation :generate_unique_id, on: :create

  private

  def generate_unique_id
    self.unique_id ||= SecureRandom.uuid
  end
end
