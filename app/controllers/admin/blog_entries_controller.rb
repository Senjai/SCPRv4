class Admin::NewsStoriesController < Admin::BaseController
  before_filter :get_record, only: [:show, :edit, :update, :destroy]
  before_filter { |c| c.send(:breadcrumb, ["News Stories", admin_news_stories_path]) }
  
  respond_to :html
    
  def index
    @news_stories = NewsStory.order("published_at desc").paginate(page: params[:page], per_page: 25)
    respond_with :admin, @news_stories
  end

  def new
    breadcrumb ["New", nil]
    @news_story = NewsStory.new
    respond
  end
  
  def show
    respond
  end
  
  def edit
    breadcrumb ["Edit", nil]
    respond
  end
  
  def create
    @news_story = NewsStory.new(params[:news_story])
    flash[:notice] = "Saved News Story" if @news_story.save
    respond
  end
  
  def update
    flash[:notice] = "Saved News Story" if @news_story.update_attributes(params[:news_story])
    respond
  end
  
  def destroy
    flash[:notice] = "Deleted News Story" if @news_story.delete
    respond
  end
  
  protected
  def get_record
    super(BlogEntry)
  end
  
  private
  def respond
    respond_with_resource(@blog_entry, params[:commit_action])
  end
end