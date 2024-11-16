class Book < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :summary, presence: true
  validates :author, presence: true
  validates :genre, presence: true
  validates :year, presence: true, numericality: { only_integer: true }, inclusion: { in: 1000..Date.today.year }
  validates :format, presence: true
  validates :availability
  validates :location, presence: true
  validates :qr_code, uniqueness:true, allow_nil: true
  validates :quantity, numericality: { only_integer: true}
  validates :view_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
