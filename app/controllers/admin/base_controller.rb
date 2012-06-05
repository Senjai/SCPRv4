class Admin::BaseController < ActionController::Base
  protect_from_forgery
  before_filter :require_admin
  layout 'admin'
  
  SAVE_OPTIONS = [
    ["Save & Return to List", "index"],
    ["Save & Continue Editing", "edit"],
    ["Save & Add Another", "new"]
  ]
  
  helper_method :admin_user
  def admin_user
    @admin_user ||= AdminUser.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  
  def require_admin
    return true if admin_user
    session[:return_to] = request.fullpath
    redirect_to admin_login_path and return false
  end
  
  # FIXME: The requirements for this method to work are too specific (it assumes a lot)
  def requested_location(action, record)
    if record.blank?
      raise ArgumentError, "Can't build url helpers without record"
    end
    
    class_str = record.class.to_s.underscore
    url_helpers = Rails.application.routes.url_helpers
    case action
    when "edit"
      url_helpers.send("edit_admin_#{class_str}_path", record)
    when "new"
      url_helpers.send("new_admin_#{class_str}_path")
    else
      url_helpers.send("admin_#{class_str.pluralize}_path")
    end
  end
end
