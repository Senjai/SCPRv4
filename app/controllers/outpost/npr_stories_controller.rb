class Outpost::NprStoriesController < Outpost::BaseController
  include Concern::Controller::Searchable
  
  # We don't want to include the Outpost actions here,
  # so we include stuff manually.
  include Outpost::Controller::Helpers
  include Outpost::Controller::Callbacks
  include Outpost::Controller::Ordering
  include Outpost::Controller::Filtering
  include Outpost::Controller::Preferences

  self.model = NprStory

  define_list do |l|
    l.default_order = "published_at"
    l.default_sort_mode = "desc"

    l.per_page = 50
    
    l.column :headline
    l.column :published_at, sortable: true, default_sort_mode: "desc"
    l.column :teaser
    l.column :link
    l.column :npr_id, header: "NPR ID"
  end

  #------------------

  before_filter :authorize_resource
  before_filter :get_record, only: [:import, :skip]
  before_filter :get_records, only: [:index]
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
    NprStory.async_sync_with_api
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
