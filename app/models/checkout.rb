class Checkout < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :library

  # Enumerations
  enum status: { pending: 0, approved: 1, returned: 2, denied: 3 }

  # Validations
  validate :sufficient_quantity

  # Callbacks
  after_create :decrement_book_quantity
  after_update :restore_book_quantity, if: :returned?

  private

  def sufficient_quantity
    errors.add(:book, "is not available") if book.quantity <= 0
  end

  def decrement_book_quantity
    book.update!(quantity: book.quantity - 1) if book.quantity.positive?
  end

  def restore_book_quantity
    book.update!(quantity: book.quantity + 1)
  end
end
