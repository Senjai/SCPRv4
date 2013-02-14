class Admin::VersionsController < Admin::BaseController
  include Outpost::Controller::Helpers

  #--------------
  # Outpost
  self.model = Secretary::Version

  define_list do
    list_default_order "created_at"
    list_default_sort_mode "desc"
    list_per_page 10
    
    column :user, display: proc { self.user.try(:to_title) || "System" }
    column :description
    column :versioned, header: "Object", display: proc { self.versioned.simple_title }
    column :version_number, header: "Version"
    column :created_at, header: "Timestamp"

    filter :user_id, collection: -> { Bio.select_collection } 
  end

  #--------------

  before_filter :set_order_and_sort_mode, only: [:index, :show, :activity]
  before_filter :get_object, only: [:index, :show]
  before_filter :authorize_resource, only: [:index, :show]
  before_filter :extend_breadcrumbs_for_object, only: [:index, :show]
  
  #--------------
  # See all activity
  def activity
    breadcrumb "Activity"
    @versions = Secretary::Version.order("#{order} #{sort_mode}").page(params[:page]).per(list.per_page)
    render :index
  end
  
  #--------------
  # See activity for a single object
  def index
    breadcrumb "History"
    @versions = @object.versions.order("#{order} #{sort_mode}").page(params[:page]).per(list.per_page)
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

  def set_order_and_sort_mode
    @order     = "created_at"
    @sort_mode = "desc"
  end

  #--------------

  def get_object
    klass = Outpost::Helpers::Naming.to_class(params[:resources])
    authorize!(klass)
    redirect_to admin_root_path if !klass.has_secretary?
    @object = klass.find(params[:resource_id])
  end

  #--------------
  
  def authorize_resource
    authorize!(@object.class)
  end
  
  #--------------
  
  def extend_breadcrumbs_for_object
    breadcrumb @object.class.name.titleize.pluralize, url_for([:admin, @object.class])
    breadcrumb @object.simple_title, url_for([:edit, :admin, @object])
  end
end
