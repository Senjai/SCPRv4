module Api::Public::V2
  class ContentController < BaseController
    before_filter :set_classes, 
      :sanitize_limit, 
      :sanitize_page, 
      :sanitize_query, 
      only: [:index]

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
      @content = ContentBase.obj_by_url!(params[:url])
      
      respond_with @content do |format|
        format.json { render :show }
      end
    end
    
    #---------------------------
    
    def show
      @content = ContentBase.obj_by_key!(params[:obj_key])
      respond_with @content
    end


    #---------------------------

    private

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
      if params[:limit].present?
        limit = params[:limit].to_i
        @limit = limit > 40 ? 40 : limit
      else
        @limit = 10
      end
    end

    #---------------------------
    
    def sanitize_page
      @page = params[:page] ? params[:page].to_i : 1
    end
    
    #---------------------------
    
    def sanitize_query
      @query = params[:query].to_s
    end
  end
end
