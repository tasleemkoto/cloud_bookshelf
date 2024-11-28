class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:edit, :update, :destroy]

  def index
    @checkouts = Checkout.includes(:user, :book).all
  end

  def new
    @checkout = Checkout.new
  end

  def create
    @checkout = Checkout.new(checkout_params)

    # Debugging: print parameters to console
    logger.debug "Checkout Params: #{checkout_params.inspect}"

    if @checkout.save
      @checkout.book.update(status: "CheckedOut")
      redirect_to @checkout, notice: 'Checkout was successfully created.'
    else
    # Log validation errors
      logger.debug "Checkout Save Failed: #{@checkout.errors.full_messages}"
      render :new
    end
  end

  def edit
  end

  def update
    if @checkout.update(checkout_params)
      @checkout.book.update(status: "CheckedOut")
      redirect_to @checkout, notice: 'Checkout successfully updated!'
    else
      render :edit
    end
  end

  def destroy
    @checkout.book.update(status: "Available")
    @checkout.destroy
    redirect_to checkouts_url, notice: 'Checkout was successfully destroyed.'
  end

  private

  def set_checkout
    @checkout = Checkout.find(params[:id])
  end

  def checkout_params
    params.require(:checkout).permit(:user_id, :book_id, :start_date, :due_date, :is_returned)
  end
end
