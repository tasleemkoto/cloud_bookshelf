class Libraries::BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  def index
    authorize @library, :show?
    @books = @library.books
  end

  def show
    authorize @book
    @reviews = @book.reviews.new
    # @pending_reservation = @book.reservations.find_by(user: current_user, status: "pending")
    # @book = Book.find(params[:id])
  end

  def new
    authorize @book
    @book =@library.books.new
  end

  def create
    @book = @library.books.new(book_params)
    authorize @book
    if book.save
      redirect_to library_book_path(@library), notice: "added"
    else
      render :new
    end
  end

  def edit

  end

  def update
    authorize @book
    if book.update(book_params)
      redirect_to library_book_path(@library, @book), notice: "updated"
    else
      render :edit
    end
  end

  def destroy
    authorize @book
    @book.destroy
    redirect_to library_book_path(@library), notice: "deleted"
  end

  # def reserve
  #   authorize @book
  #   if @book.available?
  #     reservation= @book.reservation.new(user: current_user, status: "pending")
  #     if @book.reservation.pending.count >= @book.quantity
  #       @book.update(status: "not available")
  #     end
  #     flash[:notice] ="Reservation done"
  #     redirect_to book_path(@book)
  #   else
  #     flash[:alert] ="Not available for reservation"
  #     redirect_to book_path(@book)
  #   end
  # end

  # def cancel_reservation
  #   authorize @book
  #   reservation = @book.reservations.find_by(user: current_user, status: 'pending')

  #   if reservation
  #     reservation.update
  #     if @book.reservations.pending.empty?
  #       @book.update
  #     end
  #     redirect_to library_book_path(@library, @book), notice: "Reservation canceled."
  #   else
  #     redirect_to library_book_path(@library, @book), alert: "No pending reservation found to cancel."
  #   end
  # end

  # def approve_reservation
  #   authorize @book
  #   reservation = @book.reservations.find_by(id: params[:reservation_id], status: 'pending')

  #   if reservation
  #     reservation.update(status: 'approved')
  #     @book.update(status: 'reserved')
  #     redirect_to library_book_path(@library, @book), notice: "Reservation approved."
  #   else
  #     redirect_to library_book_path(@library, @book), alert: "Reservation not found or already approved."
  #   end
  # end

  private

  def set_library
    authorize @library
    @library = Library.find(params[:library_id])
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author,:genre, :published_year, :format, :quantity)
  end

  class BooksController < ApplicationController
    def details
      book = Book.find(params[:id])
      render json: {
        author: book.author,
        format: book.format,
        availability: book.availability,
        location: book.location,
        quantity: book.quantity
      }
    end
  end

  private
  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
   params.require(:book).permit(:title, :summary, :author, :genre, :year, :format, :availability, :location, :qr_code, :photo, :quantity, :status, :view_count)
  end
end
