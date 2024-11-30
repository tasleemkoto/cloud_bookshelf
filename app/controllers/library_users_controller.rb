class LibraryUsersController < ApplicationController
  before_action :set_library
  before_action :set_library_user, only: [:edit, :update, :destroy]
  before_action :authorize_library_user, only: [:create, :edit, :update, :destroy]

  def index
    @library_users = @library.library_users.all
    # authorize @library_users
  end

  def new
    @library_user = LibraryUser.new(library: @library)
    authorize @library_user
  end

  def create
    # @library_user = @library.library_users.new(library_user_params)
    # if @library_user.save
    #   redirect_to library_library_users_path(@library), notice: 'Library User added successfully.'
    # else
    #   render :new, status: :unprocessable_entity
    # end
  end

  def edit
  end

  def update
    if @library_user.update(library_user_params)
      redirect_to library_library_users_path(@library), notice: 'User updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @library_user.destroy
    redirect_to library_library_users_path(@library), notice: 'User removed successfully from library.'
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
