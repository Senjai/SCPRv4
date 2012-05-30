class Admin::BaseController < ActionController::Base
  protect_from_forgery
  layout 'admin'
  
  helper_method :admin_user
  def admin_user
    @admin_user
    return true # temporary for development
  end
  
end
