class Api::ApiController < ApplicationController
  respond_to :json
  
  before_filter :set_content_types, only: [:index]
  
  def index
    @content = ContentBase.search(params[:query].to_s, {
      :classes => @classes,
      :limit   => limit
    })
    
    respond_with @content
  end
  
  #---------------------------
  
  def show
    @content = ContentBaby.obj_by_key(params[:obj_key])
    respond_with @content
  end
    
  #---------------------------
  
  protected
  
  def set_content_types
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
      @classes = allowed_types.values.inject(:+)
    end
    
    @classes.uniq!
  end

  #---------------------------
  
  private
  
  def limit
    params[:limit] ? params[:limit].to_i : 20
  end
end
