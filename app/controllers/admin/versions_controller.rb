class Admin::VersionsController < Admin::BaseController
  include AdminResource::Helpers::Controller

  before_filter :get_admin_list, only: [:activity, :index]
  before_filter :get_object, only: [:index, :show, :compare]
  before_filter :extend_breadcrumbs_for_object, only: [:index, :show]
  
  #--------------
  # See all activity
  def activity
    breadcrumb "Activity"
    @versions = Secretary::Version.order(@list.order).page(params[:page]).per(@list.per_page)
    render :index
  end
  
  #--------------
  # See activity for a single object
  def index
    breadcrumb "History"
    @versions = @object.versions.order(@list.order).page(params[:page]).per(@list.per_page)
  end
    
  #--------------
  # Compare a version to its previous version
  def show
    @version_b = @object.versions.find_by_version_number!(params[:version_number])
    @version_a = @version_b.previous_version
    
    breadcrumb "History", admin_history_path(@object.class.route_key, @object.id), @version_b.to_title
        
    if !Rails.cache.read(@version_b.cache_key)
      @attribute_diffs = Secretary::Diff.new(@version_a, @version_b)
    end
  end
    
  #--------------
  
  protected    
    def extend_breadcrumbs_for_object
      breadcrumb @object.class.name.titleize.pluralize, url_for([:admin, @object.class])
      breadcrumb @object.simple_title, url_for([:admin, @object])
    end

    #--------------
    
    def get_admin_list
      @list = Secretary::Version.admin.list
    end

    #--------------
    
    def get_object
      Rails.logger.warn "Warning: unsafe object fectching in #{__FILE__}"
      @object = to_class(params[:resources]).find(params[:resource_id])
    end
  #
end
