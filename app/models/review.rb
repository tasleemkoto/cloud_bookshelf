class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :comment, presence: true
  validates :rating, presence: true
  validates :rating, inclusion: { in: 1..5, message: "must be between 1 and 5" }
end
