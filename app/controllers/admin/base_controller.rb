class Admin::BaseController < ActionController::Base  
  protect_from_forgery
  before_filter :require_admin
  before_filter { |c| c.send(:breadcrumb, "KPCC Admin", admin_root_path) }  
  
  layout 'admin'
  
  SAVE_OPTIONS = [
    ["Save & Return to List", "index"],
    ["Save & Continue Editing", "edit"],
    ["Save & Add Another", "new"]
  ]
  
  
  # -- Login checks -- #
  
  helper_method :admin_user
  def admin_user
    @admin_user ||= AdminUser.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  
  def require_admin
    return true if admin_user
    session[:return_to] = request.fullpath
    redirect_to admin_login_path and return false
  end
  
  
  def breadcrumb(*args)
    @breadcrumbs ||= []
    pairs = args.each_slice(2).to_a
    pairs.each { |pair| @breadcrumbs.push(pair) }
  end
end
