class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @libraries = current_user&.libraries || [] # Fetch libraries the user belongs to
    @recent_notifications = current_user.notifications.order(created_at: :desc).limit(10) if current_user
    @library_user = LibraryUser.new # Used for accessing a library via GUID
  end
end
