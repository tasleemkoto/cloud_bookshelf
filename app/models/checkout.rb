class Checkout < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :library

  validates :start_date, :due_date, presence: true

  #enumerations:
  enum status: { pending: 0, approved: 1, returned: 2, denied: 3 }

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
end
