class ReviewsController < ApplicationController
  before_action :set_book
  before_action :authenticate_user!

  def create
    @review = @book.reviews.new(review_params)
    @review.user = current_user
      if @review.save
        redirect_to @book, notice: 'Review was successfully created.'
      else
        render 'books/show'
      end
  end

  def edit
  end

  def update
  end

  def destroy
    @review = @book.reviews.find(params[:id])
    @review.destroy
    redirect_to @book, notice: 'Review was successfully deleted'
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def review_params
     params.require(:review).permit(:content, :rating)
  end
end
