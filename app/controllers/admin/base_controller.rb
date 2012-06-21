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
    begin
      if session['_auth_user_id']
        @admin_user ||= AdminUser.find(session['_auth_user_id'])
      else
        return false
      end
    rescue
      session['_auth_user_id'] = nil
      return false
    end
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

  attr_reader :breadcrumbs  
  helper_method :breadcrumbs
end
