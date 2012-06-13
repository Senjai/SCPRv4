class Admin::ResourceController < Admin::BaseController
  before_filter :get_record, only: [:show, :edit, :update, :destroy]
  before_filter :get_records, only: :index
  before_filter :extend_breadcrumbs_with_resource_root
  
  # -- Basic CRUD -- #
  
  def index
    respond_with :admin, @records
  end

  def new
    breadcrumb "New", nil
    @record = resource_class.new
    respond
  end
  
  def show
    respond
  end
  
  def edit
    breadcrumb "Edit", nil
    respond
  end
  
  def create
    @record = resource_class.new(params[resource_param])
    flash[:notice] = "Saved #{resource_title}" if @record.save
    respond
  end
  
  def update
    flash[:notice] = "Saved #{resource_title}" if @record.update_attributes(params[resource_param])
    respond
  end
  
  def destroy
    flash[:notice] = "Deleted #{resource_title}" if @record.delete
    respond
  end
  
  
  
  # -- Fetch Records -- #
  
  def get_record
    begin
      @record = resource_class.find(params[:id])
    rescue
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def get_records
    @records = resource_class.order(resource_class.list_order).paginate(page: params[:page], per_page: resource_class.list_per_page)
  end
  
  
  
  # -- Response -- #
  
  def respond
    respond_with_resource(@record, params[:commit_action])
  end
  
  def respond_with_resource(resource, action)
    respond_with :admin, resource, location: requested_location(action, resource)
  end
  
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
  
  
  
  # -- Resource Class helpers -- #
  
  def resource_class
    @resource_class ||= params[:controller].camelize.demodulize.singularize.constantize
  end
  
  helper_method :resource_title
  def resource_title
    @resource_title ||= resource_class.to_s.titleize
  end
  
  def resource_param
    @resource_param ||= resource_class.to_s.underscore.to_sym
  end
  
  def resource_path_helper
    @resource_url_helper ||= Rails.application.routes.url_helpers.send("admin_#{resource_class.to_s.tableize}_path")
  end
  
  
  
  # -- Breadcrumbs -- #
  
  def extend_breadcrumbs_with_resource_root
    breadcrumb resource_title.pluralize, resource_path_helper
  end
end