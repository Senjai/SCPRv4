module Api::Private::V2
  class ArticlesController < BaseController
    DEFAULTS = {
      :types        => "news,blogs,segments",
      :limit        => 10,
      :order        => "public_datetime",
      :sort_mode    => :desc, # Symbol plz
      :page         => 1 # o, rly?
    }

    before_filter \
      :set_classes, 
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
      @articles = ContentBase.search(@query, {
        :classes   => @classes,
        :limit     => @limit,
        :page      => @page,
        :order     => @order,
        :sort_mode => @sort_mode,
        :with      => @conditions
      })
      
      @articles = @articles.map(&:to_article)
      respond_with @articles
    end
    
    #---------------------------
    
    def by_url
      @article = ContentBase.obj_by_url(@url)

      if !@article
        render_not_found and return false
      end

      @article = @article.to_article

      respond_with @article do |format|
        format.json { render :show }
      end
    end  
    
    #---------------------------
    
    def show
      @article = Outpost.obj_by_key(@obj_key)

      if !@article
        render_not_found and return false
      end
      
      @article = @article.to_article
      respond_with @article
    end


    #---------------------------

    private

    def set_classes
      @classes = []
      allowed_types = {
        "news"        => [NewsStory],
        "shells"      => [ContentShell],
        "blogs"       => [BlogEntry],
        "segments"    => [ShowSegment],
        "abstracts"   => [Abstract],
        "events"      => [Event],
        "queries"     => [PijQuery]
      }
      
      params[:types] ||= DEFAULTS[:types]

      params[:types].split(",").uniq.each do |type|
        if klasses = allowed_types[type]
          @classes += klasses
        end
      end

      @classes.uniq!
    end
    
    #---------------------------
    # No Limit for Private API
    def sanitize_limit
      @limit = params[:limit] ? params[:limit].to_i : DEFAULTS[:limit]
    end

    #---------------------------
    
    def sanitize_page
      page = params[:page].to_i
      @page = page > 0 ? page : DEFAULTS[:page]
    end
    
    #---------------------------
    
    def sanitize_query
      @query = params[:query].to_s
    end
    
    #---------------------------
    
    def sanitize_order
      @order = params[:order] ? params[:order].to_s : DEFAULTS[:order]
    end
    
    #---------------------------
    # For now just "desc" and "asc", although this could
    # support any of the Sphinx sort modes in the future.
    def sanitize_sort_mode
      @sort_mode = 
        if %w{desc asc}.include?(params[:sort_mode])
          params[:sort_mode].to_sym
        else
          DEFAULTS[:sort_mode]
        end
    end

    #---------------------------
    
    # Hello. You've stumbled across this because you're 
    # trying to figure out why unpublished content is 
    # showing up in the aggregator. I'll tell you why.
    #
    # Remember that "true" and "false" parameters don't
    # get converted to actual Ruby boolean values. 
    # Use "1" and "0". Thinking Sphinx or ActiveRecord
    # will convert them accordingly.
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
