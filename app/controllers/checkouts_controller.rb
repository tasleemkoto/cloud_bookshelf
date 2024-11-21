class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:edit, :update, :return]

  def index
    @checkout = Checkout.all
  end

  def new
    @checkout = Checkout.new
  end

  def create

    @checkout = Checkout.new(checkout_params)
    if @checkout.save
      redirect_to @checkout, notice: 'Checkout was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @checkout = Checkout.find(params[:id])

  end

  def update
    @checkout = Checkout.find(params[:id])
    if @checkout.update(checkout_params)
      redirect_to @checkout, notice: "checkout successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_checkout
    @checkout = Checkout.find(params[:id])
  end

  def checkout_params
    params.require(:checkout).permit(:start_date, :due_date, :return_date, :is_returned, :user_id, :book_id)
  end
end
