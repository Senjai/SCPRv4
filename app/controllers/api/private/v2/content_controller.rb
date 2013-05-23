module Api::Private::V2
  class ContentController < BaseController
    before_filter :set_classes, 
      :sanitize_limit, 
      :sanitize_page, 
      :sanitize_query, 
      :sanitize_order, 
      :sanitize_sort_mode, 
      :sanitize_conditions,
      only: [:index]

    before_filter :sanitize_obj_key, only: [:show]
    before_filter :sanitize_url, only: [:by_url]
    
    #---------------------------
    
    def index
      @content = ContentBase.search(@query, {
        :classes   => @classes,
        :limit     => @limit,
        :page      => @page,
        :order     => @order,
        :sort_mode => @sort_mode,
        :with      => @conditions
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
      @content = ContentBase.obj_by_key(@obj_key)

      if !@content
        render_not_found and return false
      end
      
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
    # No Limit for Private API
    def sanitize_limit
      @limit = params[:limit] ? params[:limit].to_i : 10
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
    
    def sanitize_order
      @order = params[:order] ? params[:order].to_s : "published_at"
    end
    
    #---------------------------
    # For now just "desc" and "asc", although this could
    # support any of the Sphinx sort modes in the future.
    def sanitize_sort_mode
      @sort_mode = %w{desc asc}.include?(params[:sort_mode]) ? params[:sort_mode].to_sym : :desc
    end

    #---------------------------
    
    def sanitize_conditions
      @conditions = params[:with]
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
