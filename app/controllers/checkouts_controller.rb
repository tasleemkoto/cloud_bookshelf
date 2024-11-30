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
    @checkout.user = current_user
    @checkout.library = current_user.libraries.first
    @checkout.status = :not_yet_returned # Set the initial status

    if @checkout.save
      redirect_to checkouts_path, notice: "Checkouts successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @checkout.update(checkout_params)
      redirect_to @checkout, notice: 'Checkout successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @checkout.book.update(status: "Available")
    @checkout.destroy
    redirect_to checkouts_url, notice: 'Checkout was successfully destroyed.'
  end

  def return
    @checkout = Checkout.find(params[:id])
    if @checkout.update(status: "returned")
      redirect_to checkouts_path, notice: "Book successfully returned."
    else
      redirect_to checkouts_path, alert: "Unable to return the book."
    end
  end

  private

  def set_checkout
    @checkout = Checkout.find(params[:id])
  end

  def checkout_params
    params.require(:checkout).permit(:user_id, :book_id, :start_date, :due_date, :is_returned, :library_id)
  end
end
