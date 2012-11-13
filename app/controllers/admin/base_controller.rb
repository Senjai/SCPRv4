class Admin::BaseController < ActionController::Base
  include AdminResource::Breadcrumbs
  
  abstract!
  protect_from_forgery
  
  layout 'admin'
  before_filter :require_admin, :root_breadcrumb, :set_sections
  
  #------------------------
  
  helper_method :admin_user
  def admin_user
    begin
      @admin_user ||= AdminUser.find(session['_auth_user_id'])
    rescue ActiveRecord::RecordNotFound
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
  
  def authorize!(resource=nil)
    resource ||= AdminResource::Helpers::Controller.to_class(params[:controller])
    
    if !admin_user.can_manage?(resource)
      handle_unauthorized(resource)
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

  #------------------------
  
  private
  
  def handle_unauthorized(resource)
    redirect_to admin_root_path, alert: "You don't have permission to manage #{resource.to_title.pluralize}"
    return false
  end
end
