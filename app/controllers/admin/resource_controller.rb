class Admin::ResourceController < Admin::BaseController
  include AdminResource::Helpers::Controller
  
  before_filter :get_record, only: [:show, :edit, :update, :destroy]
  before_filter :get_records, only: :index
  before_filter :extend_breadcrumbs_with_resource_root
  before_filter :add_user_id_to_params, only: [:create, :update, :destroy]
  
  respond_to :html
  
  helper_method :resource_class, :resource_title, :resource_param, :resource_url
  
  # -- Basic CRUD -- #
  
  def index
    @list = resource_class.admin.list
    
    # Temporary - This should be moved into AdminResource
    if @list.columns.empty?
      default_fields = resource_class.column_names - AdminResource::Admin::DEFAULTS[:excluded_fields] - AdminResource::List::DEFAULTS[:excluded_columns]
      default_fields.each do |field|
        resource_class.admin.list.column field
      end
    end
    
    # Temporary - This should be moved into AdminResource
    if @list.linked_columns.empty?
      @list.columns.first.linked = true
    end
        
    respond_with :admin, @records
  end

  def new
    # Temporary - This should be moved into AdminResource
    @fields = resource_class.admin.fields.present? ? resource_class.admin.fields : resource_class.column_names - AdminResource::Admin::DEFAULTS[:excluded_fields]

    breadcrumb "New", nil
    @record = resource_class.new
    respond
  end
  
  def show
    respond
  end
  
  def edit
    # Temporary - This should be moved into AdminResource
    @fields = resource_class.admin.fields.present? ? resource_class.admin.fields : resource_class.column_names - AdminResource::Admin::DEFAULTS[:excluded_fields]

    breadcrumb "Edit", nil
    respond
  end
  
  def create
    @record = resource_class.new(params[resource_param])
    flash[:notice] = "Saved #{resource_title}" if @record.save
    respond
  end
  
  def update
    params[resource_param].merge!(logged_user_id: admin_user.id)
    flash[:notice] = "Saved #{resource_title}" if @record.update_attributes(params[resource_param])
    respond
  end
  
  def destroy
    flash[:notice] = "Deleted #{resource_title}" if @record.delete
    respond
  end
  
  
  #-----------------
  # Fetch Records
  
  def get_record
    @record = resource_class.find(params[:id])
  end
  
  def get_records
    @records = resource_class.order(resource_class.admin.list.order).paginate(page: params[:page], per_page: resource_class.admin.list.per_page)
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


  #-----------------
  # Breadcrumbs
  
  def extend_breadcrumbs_with_resource_root
    breadcrumb resource_title.pluralize, resource_url
  end
  
  def add_user_id_to_params
    params[resource_param].merge!(logged_user_id: admin_user.id)
  end
end
