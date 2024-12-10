class Book < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :library
  has_many :checkouts, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one_attached :photo

  # Validations
  validates :title, :author, :genre, :year, :format, presence: true
  validates :year, numericality: { only_integer: true, less_than_or_equal_to: Date.today.year }
  validates :format, inclusion: { in: %w[ebook hardcover researchpaper] }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, inclusion: { in: %w[available reserve_pending reserved not_available] }, allow_nil: true
  validates :qr_code, uniqueness: true, allow_nil: true

  # Callbacks
  before_validation :generate_qr_code, on: :create
  before_validation :set_defaults

  # Default values
  def set_defaults
    self.status ||= "available"
    self.quantity ||= 0
  end

  # Instance Methods

  # Generate a unique QR code
  def generate_qr_code
    self.qr_code ||= SecureRandom.uuid
  end

  # Check if the book is reservable
  def reservable?
    format == "hardcover" && quantity.positive? && status == "available"
  end

  # Scopes
  scope :available, -> { where(status: "available") }
end
