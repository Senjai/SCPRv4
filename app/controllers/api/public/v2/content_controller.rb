module Api::Public::V2
  class ContentController < BaseController
    before_filter :set_classes, 
      :sanitize_limit, 
      :sanitize_page, 
      :sanitize_query, 
      only: [:index]

    before_filter :sanitize_obj_key, only: [:show]
    before_filter :sanitize_url, only: [:by_url]

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
      @content = ContentBase.obj_by_url(@url)

      if !@content
        render_not_found and return false
      end

      respond_with @content do |format|
        format.json { render :show }
      end
    end  
    
    #---------------------------
    
    def show
      @content = Outpost.obj_by_key(@obj_key)

      if !@content
        render_not_found and return false
      end
      
      respond_with @content
    end

    #---------------------------

    def most_viewed
      @content = Rails.cache.read("popular/viewed")
      
      if !@content
        render_service_unavailable(
          message: "Cache not warm. Try again in a few minutes."
        ) and return false
      end

      respond_with @content do |format|
        format.json { render :index }
      end
    end

    #---------------------------

    def most_commented
      @content = Rails.cache.read("popular/commented")

      if !@content
        render_service_unavailable(
          message: "Cache not warm. Try again in a few minutes."
        ) and return false
      end

      respond_with @content do |format|
        format.json { render :index }
      end
    end

    #---------------------------

    private

    def set_classes
      @classes = []
      allowed_types = {
        "news"     => [NewsStory, ContentShell],
        "blogs"    => [BlogEntry],
        "segments" => [ShowSegment],
        "episodes" => [ShowEpisode]
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
    # Limit to 40 for public API
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
      page = params[:page].to_i
      @page = page > 0 ? page : 1
    end
    
    #---------------------------
    
    def sanitize_query
      @query = params[:query].to_s
    end

    #---------------------------

    def sanitize_obj_key
      @obj_key = params[:obj_key].to_s
    end

    #---------------------------

    def sanitize_url
      begin
        # Parse the URI and then turn it back into a string,
        # just to make sure it's even a valid URI before we pass
        # it on.
        @url = URI.parse(params[:url]).to_s
      rescue URI::Error
        render_bad_request(message: "Invalid URL") and return false
      end
    end
  end
end
