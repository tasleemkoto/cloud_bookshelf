class Libraries::BooksController < ApplicationController
  before_action :set_library
  before_action :set_book, only: %i[show edit update destroy read qr_code_download redirect_to_library]

  def index
    authorize @library, :show?
    @books = policy_scope(@library.books)
    @image_urls = fetch_cloudinary_images('Bookshelf')
  end

  def show
    set_library
    authorize @book
    @reviews = @book.reviews.page(params[:reviews_page]).per(4) # Paginate
  end

  def new
    @book = @library.books.new
    authorize @book
  end

  def create
    @book = @library.books.new(book_params)
    @book.user_id = current_user.id # Assign the current user's ID to the book

    authorize @book

    # Generate QR code for hardcover books
    if @book.format == "hardcover"
      @book.qr_code = Rails.application.routes.url_helpers.library_book_url(
        library_id: @library.id,
        id: SecureRandom.uuid, # Generate a temporary unique identifier for QR
        host: 'www.cloudbookshelf.me'
      )
    end

    # Set initial status
    @book.status ||= "available"

    if @book.save
      # Generate the final QR code after saving the book with a real ID
      if @book.format == "hardcover"
        @book.update!(
          qr_code: Rails.application.routes.url_helpers.library_book_url(
            library_id: @library.id,
            id: @book.id,
            host: 'www.cloudbookshelf.me'
          )
        )
      end
      redirect_to library_book_path(@library, @book), notice: "Book successfully added."
    else
      flash.now[:alert] = @book.errors.full_messages.to_sentence
      render :new
    end
  end



  def edit
    authorize @book
  end

  def update
    authorize @book
    if @book.update(book_params)
      redirect_to library_book_path(@library, @book), notice: "Book successfully updated."
    else
      render :edit
    end
  end

  def destroy
    authorize @book
    @book.destroy
    redirect_to library_books_path(@library), notice: "Book successfully deleted."
  end

  def read
    authorize @book
    if @book.format == "ebook" && @book.pdf.attached?
      render 'read', locals: { pdf_url: url_for(@book.pdf) }
    else
      redirect_to library_book_path(@library, @book), alert: "This book is not available for online reading."
    end
  end

  def qr_code_download
    authorize @book

    send_data(
      RQRCode::QRCode.new(@book.qr_code).as_png(size: 300),
      type: 'image/png',
      filename: "qr_code_#{@book.title.parameterize}.png",
      disposition: 'attachment'
    )
  end

  def redirect_to_library
    # Authorize the library using Pundit
    if current_user.libraries.include?(@library)
      # User is already assigned to the library
      redirect_to library_path(@library), notice: "Welcome back to the library!"
    else
      # Assign user to library
      LibraryUser.create!(user: current_user, library: @library)
      redirect_to library_path(@library), notice: "You have been added to this library."
    end
  rescue Pundit::NotAuthorizedError
    # If authorization fails, redirect to a fallback page
    redirect_to root_path, alert: "You are not authorized to access this library."
  end


  private

  def set_library
    @library = Library.find(params[:library_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to libraries_path, alert: "Library not found."
  end


  def set_book
    @book = @library.books.find(params[:id])
  end

  def book_params
    allowed_params = [:title, :summary, :author, :genre, :year, :format, :status]

    # Add conditional attributes
    allowed_params << :quantity << :qr_code if params[:book][:format] == "hardcover"
    allowed_params << :pdf if params[:book][:format] == "ebook"
    allowed_params << :photo # Photo is common for all formats

    params.require(:book).permit(allowed_params)
  end

  def fetch_cloudinary_images(folder)
    resources = Cloudinary::Api.resources(
      type: :upload,
      prefix: folder,
      max_results: 100 # Fetch up to 100 images from the folder
    )
    resources['resources'].map { |resource| resource['secure_url'] }
  rescue Cloudinary::Api::Error => e
    Rails.logger.error "Cloudinary API Error: #{e.message}"
    []
  end
end
