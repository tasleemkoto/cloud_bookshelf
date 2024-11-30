class Libraries::AdminDashboardsController < ApplicationController
  before_action :set_library
  
  layout "dashboard"

  # Displays the admin dashboard for a specific library.
  # - Authorizes the `admin_dashboard?` policy to ensure the user is an admin of the library.
  # - Loads all books associated with the library.
  # - Loads all users who are members of the library.
  # - Loads all notifications for the library, ordered by the most recent first.
  # - Loads all pending reservations (checkouts) for the library, including associated books and users.
  def show
    authorize @library, :admin_dashboard?
    
    @books = @library.books
    @users = @library.users
    @pending_checkouts = @library.checkouts.where(status: 'pending').includes(:book, :user)

  end

  def approve_reservation
    @checkout = @library.checkouts.pending.find(params[:checkout_id])
    authorize @checkout

    if @checkout.update(status: :approved, approved_at: Time.current)
      @checkout.book.decrement!(:quantity)
      if @checkout.book.quantity.zero?
        @checkout.book.update!(availability: false, status: 'not_available')
      end
      flash[:notice] = "Reservation approved successfully."
    else
      flash[:alert] = "Could not approve the reservation."
    end

    redirect_to library_admin_dashboard_path(@library)
  end

  def deny_reservation
    @checkout = @library.checkouts.pending.find(params[:checkout_id])
    authorize @checkout

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