class HomeController < ApplicationController  
  layout "homepage"
  
  def index
    @homepage = Homepage.published.first
    
    citems = @homepage.content.collect { |c| c.content }

    # -- Broadcast Bar -- #    
    @onnow = Schedule.where("day = ? AND start_time <= ?", Date.today.wday, Time.now.to_s(:time)).limit(1)
    @upnext = Schedule.where("day = ? AND end_time < ?", Date.today.wday, Time.now.to_s(:time)).order("day DESC, start_time DESC").limit(1)
            
  end
  
  #----------

  def beta
    render :layout => "beta"
  end
  
  #----------
  
  def self._cache_homepage(obj_key=nil)
    view = ActionView::Base.new(ActionController::Base.view_paths, {})  
    
    class << view  
      include ApplicationHelper  
    end
    
    Rails.logger.debug("in _cache_homepage for #{obj_key}")
    
    # -- Update Sphinx Index -- #
    
    # for now, just run the complete index for the object's model
    if model = ContentBase.get_model_for_obj_key(obj_key)
      idx = model.sphinx_index_names
      
      if idx && idx.any?
        tsc = ThinkingSphinx::Configuration.instance
        # run index
        tsc.controller.index idx
        
        Rails.logger.debug("Sphinx index updated for #{model.name}")
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
