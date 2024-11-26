class Wishlist < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :library

  validates :user_id, uniqueness: { scope: :book_id, message: "already added this book to wishlist" }
end
