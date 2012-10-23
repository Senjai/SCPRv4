class HomeController < ApplicationController  
  layout "homepage"
  
  # Just for development purposes
  # Pass ?regenerate to the URL to regenerate the homepage category blocks
  # Only works in development
  before_filter :generate_homepage, only: :index, if: -> { Rails.env == "development" && params.has_key?(:regenerate) }
  before_filter :fetch_data_points, only: [:index, :election_results]
  
  def index
    @homepage = Homepage.published.first
    @schedule_current = Schedule.on_now
  end

  def election_results
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
  
  protected
  def generate_homepage
    self.class._cache_homepage
  end
  
  def fetch_data_points
    # For the election
    @data = DataPoint.where(group: 'election')
    @data_points = DataPoint.to_hash(@data)
  end
end
