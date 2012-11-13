class Admin::SearchController < Admin::BaseController
  before_filter :set_class
  
  def index
    flash[:info] = "Search functionality isn't implemented yet. Sorry!"
    return
    
    @records = @klass.search(params[:query],
      :page     => params[:page] || 1,
      :per_page => 50
    )
    
    @list = @klass.admin.list
  end
  
  def resource_class
    @klass
  end
  
  private
  def set_class
    @klass = AdminResource::Helpers::Naming.to_class(params[:resource])
  end
end
