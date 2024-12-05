class CheckoutsController < ApplicationController
  before_action :set_checkout, only: %i[edit update destroy return]
  before_action :authorize_checkout, only: %i[edit update destroy return]

  def index
    @checkouts = policy_scope(Checkout)
  end

  def new
    @checkout = Checkout.new
    authorize @checkout
  end

  def create
    @checkout = current_user.checkouts.new(checkout_params)
    @checkout.status = :pending
    authorize @checkout

    if @checkout.save
      redirect_to checkouts_path, notice: "Reservation request submitted."
    else
      render :new
    end
  end

  def return
    if @checkout.update(status: :returned)
      @checkout.book.increment!(:quantity)
      redirect_to checkouts_path, notice: "Book successfully returned."
    else
      redirect_to checkouts_path, alert: "Unable to return the book."
    end
  end

  private

  def set_checkout
    @checkout = Checkout.find(params[:id])
  end

  def authorize_checkout
    authorize @checkout
  end

  def checkout_params
    params.require(:checkout).permit(:book_id, :library_id, :start_date, :due_date)
  end
end
