class Libraries::AdminDashboardsController < ApplicationController
  before_action :set_library

  def show
    authorize @library, :admin_dashboard?

     # Paginate each section with its respective parameter
     @books = @library.books.page(params[:books_page]).per(4)
     @users = @library.users.page(params[:users_page]).per(4)
     @pending_checkouts = @library.checkouts.pending.includes(:book, :user).page(params[:pending_checkouts_page]).per(4)
     @notification = Notification.new
  end



  private

  def set_library
    @library = Library.find(params[:id])
    authorize @library, :admin_dashboard?
  end
end
