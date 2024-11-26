class Libraries::BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book =Book.new
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
end
