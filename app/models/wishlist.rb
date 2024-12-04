class Wishlist < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :library

  # Validations
  validates :user_id, uniqueness: { scope: [:book_id, :library_id], message: "already added this book to wishlist for this library" }
end
