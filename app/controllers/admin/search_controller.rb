class Admin::SearchController < Admin::BaseController
  include AdminResource::Helpers::Controller
  before_filter :set_class
  
  def index
    @records = @klass.search(params[:query],
      :page     => params[:page] || 1,
      :per_page => 50
    )
    
    @list = @klass.admin.list
    
    render '/admin/resource/index'
  end
  
  def resource_class
    @klass
  end
  
  private
  def set_class
    @klass = to_class(params[:resource])
  end
end
