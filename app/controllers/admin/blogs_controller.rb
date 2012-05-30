class Admin::BlogsController < Admin::BaseController
  before_filter :get_record, only: [:show, :edit, :update, :destroy]
  respond_to :html
  
  def index
    @blogs = Blog.order("name")
  end

  def new
    @blog = Blog.new
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
      @blog = Blog.find(params[:id])
    rescue
      raise ActionController::RoutingError.new("Not Found")
    end
  end
end