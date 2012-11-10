class Admin::BaseController < ActionController::Base  
  abstract!
  protect_from_forgery
  
  layout 'admin'
  before_filter :require_admin, :root_breadcrumb, :set_sections
  
  #------------------------
  
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

  #------------------------
  
  def require_admin
    # Only allow in if admin_user is set, and 
    # admin is_staff is true
    if !admin_user.try(:is_staff?)
      session[:return_to] = request.fullpath
      redirect_to admin_login_path and return false
    end
  end

  #------------------------
  
  def breadcrumb(*args)
    @breadcrumbs ||= []
    pairs = args.each_slice(2).map { |pair| { title: pair[0], link: pair[1] } }
    pairs.each { |pair| @breadcrumbs.push(pair) }
  end
  
  attr_reader :breadcrumbs
  helper_method :breadcrumbs

  #------------------------
  
  def authorize!(action=nil, resource=nil)
    action   ||= action_name
    resource ||= AdminResource::Helpers::Controller.to_class(params[:controller])
    if !admin_user.allowed_to?(action, resource)
      redirect_to admin_root_path, alert: "You don't have permission to #{Permission.normalize_rest(action).titleize} #{resource.to_title.pluralize}"
      return false
    end
  end

  #------------------------
  
  protected
  # Just setup the @sections variable so the views can add to it.
  def set_sections
    @sections = {}
  end
  
  #------------------------
  # Always want to add this link to the Breadcrumbs
  def root_breadcrumb
    breadcrumb "KPCC Admin", admin_root_path
  end
end
