class Checkout < ApplicationRecord
  belongs_to :user
  has_many :checkout_books, inverse_of: :checkout, dependent: :destroy
  has_many :books, through: :checkout_books

  accepts_nested_attributes_for :checkout_books, allow_destroy: true

  
end
