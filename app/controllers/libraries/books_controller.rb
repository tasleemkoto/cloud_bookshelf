class Libraries::BooksController < ApplicationController
  before_action :set_library
  before_action :set_book, only: %i[show edit update destroy read]

  def index
    authorize @library, :show?
    @books = policy_scope(@library.books)
  end

  def show
    set_library
    authorize @book
    @reviews = @book.reviews
  end

  def new
    @book = @library.books.new
    authorize @book
  end

  def create
    @book = @library.books.new(book_params)
    authorize @book

    if @book.save
      redirect_to library_book_path(@library, @book), notice: "Book successfully added."
    else
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
    if @book.format == "ebook"
      @content = @book.content # Replace with your actual logic to fetch eBook content
      render "read"
    else
      redirect_to library_book_path(@library, @book), alert: "This book is not available for online reading."
    end
  end

  private

  def set_library
    @library = Library.find(params[:id])
  end

  def set_book
    @book = @library.books.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :summary, :author, :genre, :year, :format, :quantity, :qr_code, :status)
  end
end
