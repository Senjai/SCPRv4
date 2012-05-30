class Admin::BlogEntriesController < Admin::BaseController
  before_filter :get_record, only: [:show, :edit, :update, :destroy]
  respond_to :html
  
  def index
    @blog_entries = BlogEntry.order("published_at desc")
  end

  def new
    @blog_entry = BlogEntry.new
  end
  
  def show
  end
  
  def edit
  end
  
  def create
  end
  
  def update
  end
  
  def destroy
  end
  
  protected
  def get_record
    begin
      @blog_entry = BlogEntry.find(params[:id])
    rescue
      raise ActionController::RoutingError.new("Not Found")
    end
  end
end