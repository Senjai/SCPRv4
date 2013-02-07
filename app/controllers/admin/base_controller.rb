class Admin::BaseController < ActionController::Base
  include Concern::Controller::CustomErrors
  include AdminResource::Breadcrumbs
  
  abstract!
  protect_from_forgery

  layout 'admin'
  before_filter :require_admin
  before_filter :set_sections
  before_filter :root_breadcrumb
  before_filter :setup_tickets
  before_filter :set_current_homepage
  
  #------------------------
  
  helper_method :admin_user
  def admin_user
    begin
      @admin_user ||= AdminUser.where(is_staff: true).find(session['_auth_user_id'])
    rescue ActiveRecord::RecordNotFound
      session['_auth_user_id'] = nil
      @admin_user              = nil
    end
  end

  #------------------------
  
  def require_admin
    # Only allow in if admin_user is set
    if !admin_user
      session[:return_to] = request.fullpath
      redirect_to admin_login_path and return false
    end
  end

  #------------------------
  
  def authorize!(resource=nil)
    resource ||= AdminResource::Helpers::Naming.to_class(params[:controller])
    
    if !admin_user.can_manage?(resource)
      handle_unauthorized(resource)
    end
  end

  #------------------------
  
  protected
  
  #------------------------
  # We need a new Ticket on every page, since we're offering
  # the ability to submit a ticket from any page in the CMS
  def setup_tickets
    @ticket  = Ticket.new
    @tickets = Ticket.opened
  end

  #------------------------
  # Grab the most recent homepage for the Quicknav
  def set_current_homepage
    @current_homepage = Homepage.published.first
  end
  
  #------------------------
  # Just setup the @sections variable so the views can add to it.
  def set_sections
    @sections = {}
  end
  
  #------------------------
  # Always want to add this link to the Breadcrumbs
  def root_breadcrumb
    breadcrumb "Outpost", admin_root_path
  end

  #------------------------
  
  private
  
  def handle_unauthorized(resource)
    redirect_to admin_root_path, alert: "You don't have permission to manage #{resource.to_title.pluralize}"
    return false
  end
  
  #-------------------------
  # Override this method from CustomErrors so we can specify the template path
  def render_error(status, e=StandardError)
    render template: "/admin/errors/error_#{status}", status: status, locals: { error: e }
    report_error(e)
  end
  
  #-------------------------
  def with_rollback(object)
    object.transaction do
      yield if block_given?
      raise ActiveRecord::Rollback
    end
  end
end
