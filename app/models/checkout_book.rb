class CheckoutBook < ApplicationRecord
  belongs_to :checkout
  belongs_to :book
end
