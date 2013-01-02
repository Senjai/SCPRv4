class Api::Private::ContentController < Api::PrivateController
  before_filter :set_classes, :sanitize_limit, :sanitize_page, :sanitize_query, only: [:index]

  #---------------------------
  
  def index
    @content = ContentBase.search(@query, {
      :classes => @classes,
      :limit   => @limit,
      :page    => @page
    })
    
    respond_with @content
  end
  
  #---------------------------
  
  def by_url
    @content = ContentBase.obj_by_url(params[:url])
    respond_with @content
  end  
  
  #---------------------------
  
  def show
    @content = ContentBaby.obj_by_key(params[:obj_key])
    respond_with @content
  end
    
  #---------------------------
  
  private

  #---------------------------
  
  def set_classes
    @classes = []
    allowed_types = {
      "news"     => [NewsStory, ContentShell],
      "blogs"    => [BlogEntry],
      "segments" => [ShowSegment],
      "episodes" => [ShowEpisode],
      "video"    => [VideoShell]
    }
    
    if params[:types]
      params[:types].split(",").each do |type|
        if klasses = allowed_types[type]
          @classes += klasses
        end
      end
    else
      # All classes
      @classes = allowed_types.values.inject(:+)
    end
    
    @classes.uniq!
  end
end
