class Checkout < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :library

  validates :start_date, :due_date, presence: true
  validate :sufficient_quantity

  #enumerations:
  enum status: { pending: 0, approved: 1, returned: 2, denied: 3, not_yet_returned: 4 }

  #scopes
  scope :current_reservations, -> { where(is_returned: false).order(created_at: :asc) }

  scope :approved, -> { where(status: "approved") }

  scope :pending, -> { where(status: "pending") }

  #logic for checkouts:
  def expire!
    return unless pending? && created_at < 4.days.ago

    update!(status: "returned")

    book.mark_available!
  end

  def sufficient_quantity
    errors.add(:quantity, "not available") if book.quantity < 5
  end
end
