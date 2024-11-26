class Book < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :library
<<<<<<< HEAD
  has_many :checkouts
  has_many :wishlists
  has_many :reviews
  has_many :checkout_books
  has_many :checkouts, through: :checkout_books
=======
  has_many :checkouts, dependent: :destroy
  # has_many :wishlists
  has_many :reviews, dependent: :destroy 
>>>>>>> master

  validates :title, presence: true
  validates :author, presence: true
  validates :genre, presence: true
  validates :year, presence: true, numericality: { only_integer: true, less_than_or_equal_to: Date.today.year } 
  validates :status, inclusion: { in: %w[available reserve_pending reserved not_available] }
  validates :format, inclusion: { in: %w[ebook hardcover researchpaper] }, allow_blank: false
  # validates :qr_code, uniqueness: true, allow_nil: true
  validates :quantity, numericality: { only_integer: true }

  #Callbacks
  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.status ||= "available"
    # If no `status` is set, default it to "available".
  end

  # Check if the book is reservable
  def reservable?
    format == 'hardcover' && quantity.to_i.positive? && status == "available"
  end

  # Track availability
  def available_quantity
    quantity - checkouts.approved.count
  end

  # Methods for status updates
  def mark_reserve_pending!
    update!(status: "reserve_pending")
  end

  def mark_reserved!
    update!(status: "reserved")
  end

  def mark_available!
    update!(status: "available", quantity: checkouts.approved.count)
  end

  def mark_not_available!
    update!(status: "not_available")
  end

  def all_reserved?
    format == "hardcover" && checkouts.pending.count >= quantity
   
  end

  # Scopes
  scope :available, -> { where(status: "available") }
  
end
