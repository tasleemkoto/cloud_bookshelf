class Book < ApplicationRecord
  belongs_to :user
  belongs_to :library
  has_many :checkouts
  has_many :wishlists
  has_many :reviews

  validates :title, presence: true
  validates :author, presence: true
  validates :genre, presence: true
  validates :year, presence: true, numericality: { only_integer: true }, inclusion: { in: 1000..Date.today.year }
  validates :format, presence: true
  validates :format, inclusion: { in: %w[ebook hardcover researchpaper] }, allow_blank: false
  validates :qr_code, uniqueness: true, allow_nil: true
  validates :quantity, numericality: { only_integer: true }
end
