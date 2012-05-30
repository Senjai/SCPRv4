class Admin::NewsStoriesController < Admin::BaseController
  before_filter :get_record, only: [:show, :edit, :update, :destroy]
  respond_to :html
  
  def index
    @news_stories = NewsStory.paginate(page: params[:page], per_page: 25)
  end

  def new
    @news_story = NewsStory.new
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
      @news_story = NewsStory.find(params[:id])
    rescue
      raise ActionController::RoutingError.new("Not Found")
    end
  end
end