class Libraries::AdminDashboardsController < ApplicationController
  before_action :set_library
  layout "dashboard"

  def show
    authorize @library, :admin_dashboard?

    @books = @library.books
    @users = @library.users
    @pending_checkouts = @library.checkouts.pending.includes(:book, :user)
    @notification = Notification.new # Initialize the notification object here
  end

  def approve_reservation
    @checkout = @library.checkouts.pending.find(params[:checkout_id])
    authorize @checkout, :approve_reservation?

    if @checkout.update(status: :approved)
      @checkout.book.decrement!(:quantity)
      flash[:notice] = "Reservation approved successfully."
    else
      flash[:alert] = "Could not approve the reservation."
    end

    redirect_to library_admin_dashboard_path(@library)
  end

  def deny_reservation
    @checkout = @library.checkouts.pending.find(params[:checkout_id])
    authorize @checkout, :deny_reservation?

    if @checkout.update(status: :denied)
      flash[:notice] = "Reservation denied successfully."
    else
      flash[:alert] = "Could not deny the reservation."
    end

    redirect_to library_admin_dashboard_path(@library)
  end

  private

  def set_library
    @library = Library.find(params[:id])
    authorize @library, :admin_dashboard?
  end
end
