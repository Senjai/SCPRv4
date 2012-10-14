class Admin::BaseController < ActionController::Base  
  protect_from_forgery
  abstract!
  
  before_filter :require_admin, :root_breadcrumb  
  layout 'admin'
  
  # -- Login checks -- #
  
  helper_method :admin_user
  def admin_user
    begin
      if session['_auth_user_id']
        @admin_user ||= AdminUser.find(session['_auth_user_id'])
      end
    rescue
      session['_auth_user_id'] = nil
      @admin_user              = nil
    end
  end
  
  def require_admin
    # Only allow in if admin_user is set, and 
    # admin is_staff is true
    if !admin_user.try(:is_staff?)
      session[:return_to] = request.fullpath
      redirect_to admin_login_path and return false
    end
  end
  
  def breadcrumb(*args)
    @breadcrumbs ||= []
    pairs = args.each_slice(2).map { |pair| { title: pair[0], link: pair[1] } }
    pairs.each { |pair| @breadcrumbs.push(pair) }
  end
  
  attr_reader :breadcrumbs  
  helper_method :breadcrumbs
  
  protected
    def root_breadcrumb
      breadcrumb "KPCC Admin", admin_root_path
    end
  #
end
