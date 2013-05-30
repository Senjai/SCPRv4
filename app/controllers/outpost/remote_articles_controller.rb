class Outpost::RemoteArticlesController < Outpost::BaseController
  # We don't want to include the Outpost actions here,
  # so we include stuff manually.
  include Outpost::Controller::Helpers
  include Outpost::Controller::Callbacks
  include Concern::Controller::Searchable
  
  #------------------
  # Outpost
  self.model = RemoteArticle

  define_list do
    list_default_order "published_at"
    list_default_sort_mode "desc"

    list_per_page 50

    column :organization
    column :headline
    column :published_at, sortable: true, default_sort_mode: "desc"
    column :teaser
    column :url
    column :article_id, header: "Remote ID"

    filter :organization, collection: -> { RemoteArticle.organization_select_collection }
  end

  #------------------

  before_filter :get_record, only: [:import, :skip]
  before_filter :get_records, only: [:index]
  before_filter :authorize_resource
  before_filter :order_records, only: [:index]
  before_filter :filter_records, only: [:index]
  before_filter :extend_breadcrumbs_with_resource_root

  #------------------

  respond_to :html, :json, :js

  #------------------
  
  def index
    @records = @records.where(new: true)
    respond_with :outpost, @records
  end

  #--------------
  
  def sync
    breadcrumb "Sync"
    Resque.enqueue(Job::NprFetch)
    render "sync"
  end

  #--------------
  
  def import
    breadcrumb "Importing", nil, @record.to_title
    @record.async_import(import_to_class: params[:import_to_class])
    render "import"
  end
  
  #--------------
  
  def skip
    if @record.update_attributes(new: false)
      flash[:notice] = "Skipped NPR Story: \"#{@record.to_title}\""
    else
      flash[:alert] = "Could not skip NPR Story"
    end
    
    redirect_to outpost_npr_stories_path
  end

  #--------------
  
  def extend_breadcrumbs_with_resource_root
    breadcrumb model.to_title.pluralize, model.admin_index_path
  end
end
