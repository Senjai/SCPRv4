class Admin::ResourceController < Admin::BaseController
  include AdminResource::Helpers::Controller

  before_filter :authorize!
  before_filter :get_record, only: [:show, :edit, :update, :destroy]
  before_filter :get_records, only: :index
  before_filter :extend_breadcrumbs_with_resource_root
  before_filter :add_user_id_to_params, only: [:create, :update]
    
  respond_to :html
    
  # -- Basic CRUD -- #
  
  def index
    @list = resource_class.admin.list
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
    @record = resource_class.new(params[resource_class.singular_route_key])
    if @record.save
      flash[:notice] = "Saved #{@record.simple_title}"
      respond
    else
      render :new
    end
  end
  
  def update
    if @record.update_attributes(params[resource_class.singular_route_key])
      flash[:notice] = "Saved #{@record.simple_title}"
      respond
    else
      render :edit
    end
  end
  
  def destroy
    flash[:notice] = "Deleted #{@record.simple_title}" if @record.delete
    respond
  end
  
  
  #-----------------
  # Fetch Records
  
  def get_record
    @record = resource_class.find(params[:id])
  end
  
  def get_records
    @records = resource_class.order(resource_class.admin.list.order).page(params[:page]).per(resource_class.admin.list.per_page)
  end
  
  
  #-----------------
  # Response
  
  def respond
    respond_with_resource(@record, params[:commit_action])
  end
  
  def respond_with_resource(resource, action)
    respond_with :admin, resource, location: requested_location(action, resource)
  end
  
  def requested_location(action, record)    
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


  #-----------------
  # Authorization
  # TODO Abstract this
  def authorize!
    unless admin_user.allowed_to?(action_name, resource_class)
      redirect_to admin_root_path, alert: "You don't have permission to #{Permission.normalize_rest(action_name).titleize} #{resource_class.to_title.pluralize}" and return false
    end
  end


  #-----------------
  # Breadcrumbs
  def extend_breadcrumbs_with_resource_root
    breadcrumb resource_class.to_title.pluralize, resource_class.admin_index_path
  end
  
  def add_user_id_to_params
    params[resource_class.singular_route_key].merge!(logged_user_id: admin_user.id)
  end
end
