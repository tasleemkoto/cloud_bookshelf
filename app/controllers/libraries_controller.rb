class LibrariesController < ApplicationController

  def index
    @libraries = Library.all
    skip_policy_scope
  end

  def show
    @library = Library.find(params[:id])
    skip_authorization
  end

  def new
    @library = Library.new
  end

  def create
    new
    
  end

  def edit

  end

  def update

  end

  def destroy

  end
end
