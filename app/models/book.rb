class Book < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :library
  has_many :checkouts, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one_attached :photo

  # Attachments
  has_one_attached :photo
  has_one_attached :pdf # For ebooks

  # Validations
  validates :title, :author, :genre, :year, :format, presence: true
  validates :year, numericality: { only_integer: true, less_than_or_equal_to: Date.today.year }
  validates :format, inclusion: { in: %w[ebook hardcover researchpaper] }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, inclusion: { in: %w[available reserve_pending reserved not_available] }, allow_nil: true

  validates :qr_code, uniqueness: true, presence: true, if: -> { format == 'hardcover' }
  validates :photo, attached: false, content_type: ['image/png', 'image/jpg', 'image/jpeg'], unless: -> { pdf.attached? || format == 'researchpaper' }
  validates :pdf, attached: false, if: -> { format == 'ebook' }, content_type: ['application/pdf']


  # Callbacks
  after_create :generate_qr_code
  before_validation :set_defaults
  after_create :generate_qr_code_and_save

  # Default values
  def set_defaults
    self.quantity ||= 1 # Default quantity
    self.status ||= "available" # Default status
  end

  def available_for_checkout?
    format == 'hardcover' && quantity.positive?
  end

  def decrement_quantity!
    update!(quantity: quantity - 1) if quantity.positive?
  end

  def increment_quantity!
    update!(quantity: quantity + 1)
  end

  # Generate a unique QR code after the book is created
  def generate_qr_code
    return unless format == "hardcover" && library.present? && id.present?

    self.qr_code = Rails.application.routes.url_helpers.library_book_url(
      library_id: library.id,
      id: id,
      host: 'www.cloudbookshelf.me'
    )
  end

  def generate_qr_code_and_save
    generate_qr_code
    save! # Save the record with the generated QR code
  end

  # Generate QR Code as an SVG
  def qr_code_svg
    return unless qr_code.present?

    qr = RQRCode::QRCode.new(qr_code)
    qr.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    ).html_safe
  end


  # Check if the book is reservable
  def reservable?
    return false unless format == "hardcover"  # Only hardcover books can be reserved
    return false unless quantity.positive?    # Ensure quantity is greater than 0
    return false unless status == "available" # Status must be "available"
    return false if checkouts.pending.exists? # No pending checkouts should exist

    true
  end


  # Scopes
  scope :available, -> { where(status: "available") }
end
