class Outpost::NprStoriesController < Outpost::BaseController
  # We don't want to include the Outpost actions here,
  # so we include stuff manually.
  include Outpost::Controller::Helpers
  include Outpost::Controller::Callbacks
  include Concern::Controller::Searchable
  
  #------------------
  # Outpost
  self.model = NprStory

  define_list do
    list_default_order "published_at"
    list_default_sort_mode "desc"

    list_per_page 50
    
    column :headline
    column :published_at, sortable: true, default_sort_mode: "desc"
    column :teaser
    column :link, display: :display_npr_link
    column :npr_id, header: "NPR ID"
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
    respond_with :admin, @records
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
    @record.async_import
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

  #--------------
  
  private

  #--------------
  
  def authorize_resource
    authorize!(model)
  end
end
