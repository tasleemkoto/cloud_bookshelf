class UsersController < ApplicationController
  def dashboard
    skip_authorization
  end
end
