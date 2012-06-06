class Admin::BaseController < ActionController::Base
  protect_from_forgery
  before_filter :require_admin
  before_filter { |c| c.send(:breadcrumb, ["KPCC Admin", admin_root_path]) }
  
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
  
  def respond
    respond_with_resource(@record, params[:commit_action])
  end
  
  def respond_with_resource(resource, action)
    respond_with :admin, resource, location: requested_location(action, resource)
  end
  
  def get_record(obj_class)
    begin
      @record = obj_class.find(params[:id])
    rescue
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def get_records(obj_class)
    @records = obj_class.order("published_at desc").paginate(page: params[:page], per_page: 25)
  end
    
  # FIXME: The requirements for this method to work are too specific (it assumes a lot)
  def requested_location(action, record)
    if record.blank?
      raise ArgumentError, "Can't build url helpers without record"
    end
    
    if action.blank?
      return nil
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
  
  def breadcrumb(pair=[])
    @breadcrumbs ||= []
    @breadcrumbs.push(pair) if pair.present?
  end
end
