class Api::ApiController < ApplicationController
  respond_to :json
  
  before_filter :set_access_control_headers
  before_filter :set_classes, :sanitize_limit, :sanitize_page, :sanitize_query, only: [:index]

  #---------------------------
  
  def options
    head :ok
  end

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
  
  def set_access_control_headers
    response.headers['Access-Control-Allow-Origin']      = request.env['HTTP_ORIGIN'] || "*"
    response.headers['Access-Control-Allow-Methods']     = 'POST, GET, OPTIONS'
    response.headers['Access-Control-Max-Age']           = '1000'
    response.headers['Access-Control-Allow-Headers']     = 'x-requested-with,content-type,X-CSRF-Token'
    response.headers['Access-Control-Allow-Credentials'] = "true"
  end

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

  #---------------------------
    
  def sanitize_limit
    @limit = params[:limit] ? params[:limit].to_i : 10
  end
  
  def sanitize_page
    @page = params[:page] ? params[:page].to_i : 1
  end
  
  #---------------------------
  
  def sanitize_query
    @query = params[:query].to_s
  end
end
