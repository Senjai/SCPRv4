class Admin::NprStoriesController < Admin::BaseController
  include AdminResource::Controller::Helpers
  include AdminResource::Controller::Callbacks

  before_filter :authorize_resource
  before_filter :get_record, only: [:import, :destroy]
  before_filter :get_records, only: [:index]
  before_filter :extend_breadcrumbs_with_resource_root

  respond_to :html, :json, :js
  
  def index
    @list = resource_class.admin.list
    respond_with :admin, @records
  end

  #--------------
  
  def import
    story = NprStory.find(params[:id])
    story.async_import(admin_user.username)
    render "import"
  end
  
  #--------------
  
  def destroy
    @record.destroy
    notice "Deleted #{@record.simple_title}"
    respond_with :admin, @record
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
