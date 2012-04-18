class HomeController < ApplicationController  
  layout "homepage"
  
  def index
    @homepage = Homepage.published.first
    @schedule_current = Schedule.on_now
  end
  
  #----------

  def beta
    render :layout => "beta"
  end
  
  #----------
  
  def error
    render :template => "/error/500.html", :status => 500, :layout => "error"
  end
  
  def not_found
    render :template => "/error/404.html", :status => 404, :layout => "error"
  end
  
  #----------
  
  def self._cache_homepage(obj_key=nil,pickle=nil)
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
      
      if idx && idx.any?
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
    
    # if we're passed a pickle object, also perform mercer headlines caching
    if pickle
      #headlines = Homepage.mercer_headlines
      
      (Rails.cache.instance_variable_get :@data).set(
        ':1:hsection:headlines',
        pickle.dumps( view.render(:partial => "home/cached/mercer/headlines", :object => scored_content[:headlines]) ),
        :raw => true
      )
    end
  end
  
  class << self
    include NewRelic::Agent::Instrumentation::ControllerInstrumentation
    add_transaction_tracer :_cache_homepage, :category => :task
  end
end
