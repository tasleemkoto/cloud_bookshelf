class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:edit, :update, :destroy]

  def index
    @checkouts = Checkout.includes(:user).all
  end

  def new
    @checkout = Checkout.new
  end

  def create
    @checkout = Checkout.new(checkout_params)
    if @checkout.save
      create_checkout_books
      redirect_to @checkout, notice: 'Checkout was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @checkout.update(checkout_params)
      redirect_to @checkout, notice: 'Checkout successfully updated!'
    else
      render :edit
    end
  end

  def destroy
    @checkout.destroy
    redirect_to checkouts_url, notice: 'Checkout was successfully destroyed.'
  end

  private

  def set_checkout
    @checkout = Checkout.find(params[:id])
  end

  def checkout_params
    params.require(:checkout).permit(:user_id)
  end

  def books_params
    params[:books]&.map do |book|
      book.permit(:book_id, :start_date, :due_date)
    end || []
  end

  def create_checkout_books
    books_params.each do |book|
      CheckoutBook.create(
        checkout_id: @checkout.id,
        book_id: book[:book_id],
        start_date: book[:start_date],
        due_date: book[:due_date]
      )
    end
  end
end
