class HomeController < ApplicationController  
  layout "homepage"
  
  def index
    @homepage = Homepage.published.first
    @schedule_current = Schedule.on_now
  end
  
  #----------

  def beta
    render :layout => false
  end
  
  #----------
  
  def listen
    render layout: 'application'
  end
  
  def about_us
    render :layout => "app_nosidebar"
  end
  
  def error
    render :template => "/error/500.html", :status => 500, :layout => "app_nosidebar"
  end
  
  def not_found
    render :template => "/error/404.html", :status => 404, :layout => "app_nosidebar"
  end
  
  def fb_channel_file
    cache_expire = 1.year
    response.headers["Pragma"] = "public"
    response.headers["Cache-Control"] = "max-age=#{cache_expire.to_i}"
    response.headers["Expires"] = (Time.now + cache_expire).strftime("%d %m %Y %H:%I:%S %Z")
    render :layout => false, :inline => "<script src='//connect.facebook.net/en_US/all.js'></script>"
  end
  
  #----------
  
  # Process the form values for Archive and redirect to canonical URL
  def process_archive_select
    year = params[:archive]["date(1i)"].to_i
    month = "%02d" % params[:archive]["date(2i)"].to_i
    day = "%02d" % params[:archive]["date(3i)"].to_i
    
    redirect_to archive_path(year, month, day) and return
  end

  #----------
  
  def archive
    if params[:year] and params[:month] and params[:day]
      @date = Time.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    end

    if @date
      condition = ["published_at between :today and :tomorrow", today: @date, tomorrow: @date.tomorrow]
      @news_stories   = NewsStory.published.where(condition)
      @show_segments  = ShowSegment.published.where(condition)
      @show_episodes  = ShowEpisode.published.where("air_date=?", @date)
      @blog_entries   = BlogEntry.published.where(condition)
                                  .includes(:blog)
                                  .where("blogs_blog.is_remote = ?", false) # Keep out Multi-American, temporarily
      @video_shells   = VideoShell.published.where(condition)
      @content_shells = ContentShell.published.where(condition)
    end
    
    render layout: 'application'
  end
  
  #----------
  
  def missed_it_content
    @homepage = Homepage.find(params[:id])
    @carousel_contents = @homepage.missed_it_bucket.contents.paginate(page: params[:page], per_page: 6)
    render 'missed_it_content.js.erb'
  end
  
  def self._cache_homepage(obj_key=nil)
    view = ActionView::Base.new(ActionController::Base.view_paths, {})  
    
    class << view  
      include ApplicationHelper  
      include WidgetsHelper
      include Rails.application.routes.url_helpers
    end
    
    Rails.logger.info("in _cache_homepage for #{obj_key}")
    
    # -- Update Sphinx Index -- #
    
    # for now, just run the complete index for the object's model
    if model = ContentBase.get_model_for_obj_key(obj_key)
      idx = model.sphinx_index_names
      
      # For now, we'll update the byline index every time.
      # TODO: Put a check to see if the byline has updated, and only index then
      byline_idx = ContentByline.sphinx_index_names
      idx += byline_idx
      
      if idx && idx.present?
        tsc = ThinkingSphinx::Configuration.instance
        # run index
        out = tsc.controller.index idx
        Rails.logger.info("Sphinx index updated for #{model.name}: #{out}")
      end
    end
    
    # get scored content from homepage
    @homepage = Homepage.published.first
    scored_content = @homepage.scored_content    
        
    # write cache...
    Rails.cache.write(
      "home/headlines", 
      view.render(:partial => "home/cached/headlines", :object => scored_content[:headlines])
    )
    
    # render and cache
    Rails.cache.write(
      "home/sections",
      view.render(:partial => "home/cached/sections", :object => scored_content[:sections])
    )
  end
  
  class << self
    include NewRelic::Agent::Instrumentation::ControllerInstrumentation
    add_transaction_tracer :_cache_homepage, :category => :task
  end
end
