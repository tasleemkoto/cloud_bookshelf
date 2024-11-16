class Checkout < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :start_date, presence: true
  validates :due_date, presence: true
  validates :return_date, date: { after_or_equal_to: :start_date, allow_blank: true }
end
