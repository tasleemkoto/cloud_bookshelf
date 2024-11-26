class Libraries::BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  def index
    @books = Book.all
  end

  def show
  end

  def new
<<<<<<< HEAD
    @book = Book.new
=======
    @book =Book.new
>>>>>>> master
  end

  def create
    @book = Book.new(book_params)

    if book.save
      redirect_to @book
    else
      render :new
    end
  end

  def edit
  end

  def update
    if book.update(book_params)
      redirect_to @book
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
  end

  private

  def books
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :description, :published_year)
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
