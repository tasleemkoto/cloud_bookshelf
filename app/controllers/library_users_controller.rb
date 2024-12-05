class LibraryUsersController < ApplicationController
  before_action :set_library, except: [:create]
  before_action :set_library_user, only: [:edit, :update, :destroy]
  before_action :authorize_library_user, only: [:edit, :update, :destroy]

  def index
    authorize @library, :show?
    @library_users = @library.library_users.includes(:user)
  end

  def new
    @library_user = @library.library_users.new
    authorize @library_user
  end

  def create
    @library = Library.find_by(unique_id: params[:unique_id])
    if @library
      @library_user = @library.library_users.new(user: current_user)
      authorize @library_user

      if @library_user.save
        redirect_to library_path(@library), notice: "Successfully joined the library."
      else
        redirect_to root_path, alert: "Failed to join the library."
      end
    else
      redirect_to root_path, alert: "No library found with the provided unique ID."
    end
  end

  def edit
  end

  def update
    if @library_user.update(library_user_params)
      redirect_to library_library_users_path(@library), notice: "Library user updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @library_user.destroy
    redirect_to library_library_users_path(@library), notice: "User removed successfully from the library."
  end

  private

  def set_library
    @library = Library.find(params[:library_id])
  end

  def set_library_user
    @library_user = @library.library_users.find(params[:id])
  end

  def library_user_params
    params.require(:library_user).permit(:user_id, :is_admin)
  end

  def authorize_library_user
    authorize @library_user
  end
end
