module Api::Public::V2
  class ArticlesController < BaseController
    TYPES = {
      "news"        => [NewsStory],
      "external"    => [ContentShell],
      "blogs"       => [BlogEntry],
      "segments"    => [ShowSegment]
    }

    DEFAULTS = {
      :types        => "news,blogs,segments",
      :limit        => 10,
      :order        => "published_at",
      :sort_mode    => :desc, # Symbol plz
      :page         => 1 # o, rly?
    }

    MAX_RESULTS = 40

    before_filter \
      :set_conditions,
      :set_classes,
      :sanitize_limit,
      :sanitize_page,
      :sanitize_query,
      :sanitize_categories,
      only: [:index]

    before_filter :sanitize_obj_key, only: [:show]
    before_filter :sanitize_url, only: [:by_url]

    #---------------------------

    def index
      @articles = ContentBase.search(@query, {
        :classes => @classes,
        :limit   => @limit,
        :page    => @page,
        :with    => @conditions
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

    def most_viewed
      @articles = Rails.cache.read("popular/viewed")

      if !@articles
        render_service_unavailable(
          message: "Cache not warm. Try again in a few minutes."
        ) and return false
      end

      respond_with @articles do |format|
        format.json { render :index }
      end
    end

    #---------------------------

    def most_commented
      @articles = Rails.cache.read("popular/commented")

      if !@articles
        render_service_unavailable(
          message: "Cache not warm. Try again in a few minutes."
        ) and return false
      end

      respond_with @articles do |format|
        format.json { render :index }
      end
    end

    #---------------------------

    private

    def set_conditions
      @conditions = {}
    end

    def set_classes
      @classes = []
      params[:types] ||= defaults[:types]

      params[:types].split(",").uniq.each do |type|
        if klasses = allowed_types[type]
          @classes += klasses
        end
      end

      @classes.uniq!
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

    #---------------------------

    def sanitize_categories
      if params[:categories].present?
        slugs   = params[:categories].to_s.split(',')
        ids     = Category.where(slug: slugs).map(&:id)

        if ids.present?
          @conditions[:category] = ids
        end
      end
    end
  end
end
