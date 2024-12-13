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
    @library = Library.find(params[:library_id])
    @book = Book.find(params[:id])
    @checkout = current_user.checkouts.new(library: @library, book: @book)
    @checkout.status = :pending
    authorize @checkout

    if @checkout.save
      redirect_to user_dashboard_library_path(@library), notice: "Reservation request submitted."
    else
      render :new
    end
  end

  def approve_reservation
    @checkout = Checkout.find(params[:id])
    authorize @checkout, :approve_reservation?
    if @checkout.update(status: "approved")
      @checkout.book.decrement!(:quantity)
      flash[:notice] = "Reservation approved successfully."
    else
      flash[:alert] = "Could not approve the reservation."
    end
    @library = @checkout.book.library
    redirect_to admin_dashboard_library_path(@library)
  end

  def deny_reservation
    @checkout = Checkout.find(params[:id])
    authorize @checkout, :deny_reservation?

    if @checkout.update(status: :denied)
      flash[:notice] = "Reservation denied successfully."
    else
      flash[:alert] = "Could not deny the reservation."
    end
    @library = @checkout.book.library
    redirect_to admin_dashboard_library_path(@library)
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
