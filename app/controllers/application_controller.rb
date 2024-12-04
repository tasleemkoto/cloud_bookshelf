class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit::Authorization

  # Pundit: allow-list approach
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def after_sign_in_path_for(resource)
    # Get the first library the user is associated with (if any)
    library = resource.libraries.first

    if library.present?
      # Redirect based on whether the user is an admin for that library
      if resource.library_admin?(library)
        admin_dashboard_library_path(library)
      else
        user_dashboard_library_path(library)
      end
    else
      # Redirect to the root path if no libraries are associated
      root_path
    end
  end

  # Uncomment when you *really understand* Pundit!
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

   private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

end
