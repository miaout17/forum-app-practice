class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_permission!

  # Reference: https://github.com/ryanb/cancan/wiki/Admin-Namespace
  private
  def verify_permission!
    redirect_to root_url unless current_user.manager?
  end

  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end

end
