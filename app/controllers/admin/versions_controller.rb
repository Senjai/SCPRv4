class Admin::VersionsController < Admin::BaseController
  include AdminResource::Helpers::Controller

  before_filter :get_admin_list, only: [:activity, :index]
  before_filter :get_object, only: [:index, :show, :compare]
  before_filter :extend_breadcrumbs_for_history
  before_filter :extend_breadcrumbs_for_object, only: [:index, :show, :compare]
  
  #--------------
  # See all activity
  def activity
    breadcrumb "Activity"
    @versions = Secretary::Version.order(@list.order).paginate(page: params[:page], per_page: @list.per_page)
    render :index
  end
  
  #--------------
  # See activity for a single object
  def index
    @versions = @object.versions.order(@list.order).paginate(page: params[:page], per_page: @list.per_page)
  end
  
  def show
    @version = @object.versions.where(version_number: params[:version_number]).first
    breadcrumb @version.to_title
  end
    
  #--------------
  # Diff a version with any other version from the same object
  def compare
    breadcrumb "Compare"
    
    @version_a       = @object.versions.where(version_number: params[:a_num]).first
    @version_b       = @object.versions.where(version_number: params[:b_num]).first
    @cache_key       = "compare:#{@object.class.name.tableize.singularize}/#{@object.id}:#{@version_a.version_number}/#{@version_b.version_number}"
    @attribute_diffs = Secretary::Diff.new(@version_a.object, @version_b.object)
  end
  
  #--------------
  
  protected
    def extend_breadcrumbs_for_history
      breadcrumb "History", admin_activity_path
    end
    
    def extend_breadcrumbs_for_object
      breadcrumb @object.to_title, url_for([:admin, @object])
    end

    #--------------
    
    def get_admin_list
      @list = Secretary::Version.admin.list
    end

    #--------------
    
    def get_object
      logger.info "Warning: unsafe object fectching in #{__FILE__}"
      @object = to_class(params[:resources]).find(params[:resource_id])
    end
  #
end
