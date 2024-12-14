class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_checkout, only: %i[approve deny]

  # Create a new reservation
  def create
    @checkout = Checkout.new(checkout_params)
    @checkout.status = :pending

    if @checkout.save
      redirect_to library_book_path(@checkout.library, @checkout.book),
                  notice: 'Reservation request sent to the librarian.'
    else
      redirect_to library_book_path(@checkout.library, @checkout.book),
                  alert: @checkout.errors.full_messages.to_sentence
    end
  end

  # Admin approves the reservation
  def approve
    if @checkout.book.quantity.positive?
      ActiveRecord::Base.transaction do
        @checkout.book.decrement_quantity!
        @checkout.update!(status: :approved, start_date: Date.today, due_date: Date.today + 7.days)
      end
      redirect_to admin_dashboard_library_path(@checkout.library),
                  notice: 'Reservation approved successfully.'
    else
      redirect_to admin_dashboard_library_path(@checkout.library),
                  alert: 'Insufficient book quantity.'
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to admin_dashboard_library_path(@checkout.library),
                alert: "Failed to approve the reservation: #{e.message}"
  end

  # Admin denies the reservation
  def deny
    ActiveRecord::Base.transaction do
      # Restore the book's quantity if it was decremented during the reservation
      @checkout.book.increment_quantity! if @checkout.book.quantity.present?

      # Update the status to denied without triggering validations
      @checkout.update_columns(status: :denied)
    end

    redirect_to admin_dashboard_library_path(@checkout.library),
                notice: 'Reservation denied.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to admin_dashboard_library_path(@checkout.library),
                alert: "Failed to deny the reservation: #{e.message}"
  end


  private

  def set_checkout
    @checkout = Checkout.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_dashboard_library_path(params[:library_id]),
                alert: 'Reservation not found.'
  end

  def checkout_params
    params.require(:checkout).permit(:book_id, :user_id, :library_id)
  end
end
