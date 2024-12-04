class Libraries::ReviewsController < ApplicationController
  before_action :set_library
  before_action :set_book
  before_action :set_review, only: [:destroy]

  def create
    @review = @book.reviews.new(review_params)
    @review.user = current_user

    # Authorize the action for the review object
    authorize @review

    if @review.save
      redirect_to library_book_path(@library, @book), notice: 'Review created successfully!'
    else
      @reviews = @book.reviews
      flash[:alert] = @review.errors.full_messages.to_sentence
      render 'libraries/books/show'
    end
  end

  def destroy
    authorize @review

    if @review.destroy
      respond_to do |format|
        format.html { redirect_to library_book_path(@library, @book), notice: 'Review successfully deleted!' }
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("#{@review.class.name.underscore}_#{@review.id}")
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to library_book_path(@library, @book), alert: 'Unable to delete review.' }
        format.turbo_stream do
          render turbo_stream: turbo_stream.append('flash', partial: 'shared/flash', locals: { alert: 'Unable to delete review.' })
        end
      end
    end
  end


  private

  def set_library
    @library = Library.find(params[:library_id])
  end

  def set_book
    @book = @library.books.find(params[:book_id])
  end

  def set_review
    @review = @book.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
