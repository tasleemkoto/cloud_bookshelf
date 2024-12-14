class Checkout < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :library

  # Enumerations
  enum status: { pending: 0, approved: 1, returned: 2, denied: 3 }

  # Validations
  validate :sufficient_quantity, unless: -> { status == "denied" }

  # Callbacks
  after_create :decrement_book_quantity
  after_update :restore_book_quantity, if: -> { saved_change_to_status? && returned? }

  private

  def sufficient_quantity
    if book.quantity <= 0
      errors.add(:book, "is not available")
    elsif book.checkouts.pending.exists?(user: user)
      errors.add(:book, "already has a pending reservation for this user")
    end
  end

  def ensure_book_availability
    errors.add(:book, "is not available for checkout") unless book.available_for_checkout?
  end

  def decrement_book_quantity
    book.decrement_quantity!
  end

  def restore_book_quantity
    book.increment_quantity!
  end



  def decrement_book_quantity
    book.update!(quantity: book.quantity - 1) if book.quantity.positive?
  end

  def restore_book_quantity
    book.update!(quantity: book.quantity + 1)
  end
end
