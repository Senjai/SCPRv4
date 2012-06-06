class Admin::NewsStoriesController < Admin::BaseController  
  before_filter :get_record, only: [:show, :edit, :update, :destroy]
  before_filter :get_records, only: :index
  before_filter { |c| c.send(:breadcrumb, [resource_title.pluralize, Rails.application.routes.url_helpers.send("admin_#{klass.to_s.tableize}_path")]) }
  
  respond_to :html
    
  def index
    respond_with :admin, @record
  end

  def new
    breadcrumb ["New", nil]
    @record = klass.new
    respond
  end
  
  def show
    respond
  end
  
  def edit
    breadcrumb ["Edit", nil]
    respond
  end
  
  def create
    @record = klass.new(resource_param)
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
  
  helper_method :resource_title
  def resource_title
    klass.to_s.titleize
  end

  def klass
    NewsStory
  end
  
  def resource_param
    params[klass.to_s.underscore.to_sym]
  end
  
  private  
  ## Move these to base_controller
  def get_record
    super(klass)
  end
  
  def get_records
    super(klass)
  end
end