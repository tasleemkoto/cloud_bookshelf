class LibrariesController < ApplicationController

  def index
    @libraries = policy_scope(Library)
  end

  def show
    @library = Library.find(params[:id])
    # authorize @library
  end

  def new
    @library = Library.new
    authorize @library
  end

  def create
    @library = Library.new(library_params)
    authorize @library
    if @library.save
      redirect_to @library, notice: 'Library was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @library = Library.find(params[:id])
    authorize @library
  end

  def update
    @library = Library.find(params[:id])
    authorize @library
    if @library.update(library_params)
      redirect_to @library, notice: 'Library was successfully updated in database.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @library = Library.find(params[:id])
    authorize @library
    @library.destroy
    redirect_to libraries_path, notice: 'Library has been deleted from database.'
  end

  private

  def library_params
    params.require(:library).permit(:name, :unique_id)
  end
end
