class UsersController < ApplicationController

  before_filter :find_user

  def show
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end

end
