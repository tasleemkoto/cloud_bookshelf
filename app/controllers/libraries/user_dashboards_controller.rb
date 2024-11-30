class Libraries::UserDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_library

  def show
    authorize @library, :user_dashboard?

    @books = @library.books
    @approved_reservations = current_user.checkouts.approved.includes(:book)
  end

  private

  def set_library
    @library = Library.find(params[:library_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to libraries_path, alert: 'Library not found'
  end
end
