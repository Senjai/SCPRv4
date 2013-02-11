class Admin::NprStoriesController < Admin::BaseController
  include Outpost::Controller::Helpers
  include Outpost::Controller::Callbacks
  include Concern::Controller::Searchable
  
  before_filter :authorize_resource
  before_filter :get_record, only: [:import, :skip]
  before_filter :get_records, only: [:index]
  before_filter :extend_breadcrumbs_with_resource_root

  respond_to :html, :json, :js
  
  def index
    @list = resource_class.admin.list
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
    
    redirect_to admin_npr_stories_path
  end

  #--------------
  
  def extend_breadcrumbs_with_resource_root
    breadcrumb resource_class.to_title.pluralize, resource_class.admin_index_path
  end

  #--------------
  
  private

  #--------------
  
  def authorize_resource
    authorize!(resource_class)
  end
end
