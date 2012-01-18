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
        
    # -- Homepage Object -- #
    @homepage = Homepage.published.first    
    citems = @homepage.content.collect { |c| c.content }

    # -- More Headlines -- #
    
    # Anything with a news category is eligible
    
    @headlines = ThinkingSphinx.search(
      '',
      :classes    => ContentBase.content_classes,
      :page       => 1,
      :per_page   => 12,
      :order      => :published_at,
      :sort_mode  => :desc,
      :without    => { :category => '' },
      :without_any => { :obj_key => citems.collect {|c| c.obj_key.to_crc32 } }
    )
    
    # write cache...
    Rails.cache.write(
      "home/headlines",
      view.render(:partial => "home/cached/headlines", :object => @headlines)
    )
    
    # -- Section Blocks -- #
    
    @sections = []
    
    # run a query for each section 
    Category.all.each do |cat|
      content = ThinkingSphinx.search '',
        :classes    => ContentBase.content_classes,
        :page       => 1,
        :per_page   => 5,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => cat.id },
        :without_any => { :obj_key => citems.collect {|c| c.obj_key.to_crc32 } }
      
      top = nil
      more = []
      sorttime = nil
      
      content.each do |c|
        
        ctime = c.public_datetime.is_a?(Date) ? c.public_datetime.to_time : c.public_datetime
        
        # if we're still here, weigh this content for sorting
        if !sorttime || ctime > sorttime
          sorttime = ctime
        end
        
        # does this content have an asset?
        if !top && c.assets.any?
          top = c
          next
        end
        
        # finally, just drop it in the more bucket
        more << c
      end  
      
      # assemble section object
      @sections << {
        :section  => cat,
        :top      => top,
        :right    => nil,
        :more     => more,
        :sorttime => sorttime
      }      
    end
    
    # now sort sections by the sorttime
    @sections.sort_by! {|s| s[:sorttime] }.reverse!
    
    now = DateTime.now()
    
    # so we need to figure out what goes in the right feature for each section
    @sections[0..4].each do |sec|
      candidates = []
      
      # -- first look for featured comments -- #
      
      featured = sec[:section].comment_bucket.comments.published.where( "published_at > ?", now - 1 )
      
      if featured.any?
        # Initial score:  20
        # Decay rate:     0.05
        candidates << {
          :content  => featured.first,
          :score    => 20 * Math.exp( -0.05 * ((Time.now - featured.first.published_at) / 3600) )
        }        
      end
      
      # -- now try slideshows -- #
      
      content = ThinkingSphinx.search '',
        :classes    => ContentBase.content_classes,
        :page       => 1,
        :per_page   => 1,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => sec[:section].id, :is_slideshow => true }
        
      if content
        # Initial score:  5 + number of slides
        # Decay rate:     0.01
        slideshow = content.first
        
        candidates << {
          :content  => slideshow,
          :score    => (5 + slideshow.assets.length) * Math.exp( -0.01 * ((Time.now - (slideshow.public_datetime.is_a?(Date) ? slideshow.public_datetime.to_time : slideshow.public_datetime)) / 3600) )
        }
      end
      
      # -- segment in the last two days? -- #
      
      segments = ThinkingSphinx.search '',
        :classes    => [ShowSegment],
        :page       => 1,
        :per_page   => 1,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => sec[:section].id }
        
      if segments
        # Initial score:  10
        # Decay rate:     0.02  
        seg = segments.first
        
        candidates << {
          :content  => seg,
          :score    => 10 * Math.exp(-0.02 * ((Time.now - seg.public_datetime.to_time) / 3600) )
        }
      end
      
      if candidates.any?
        candidates.sort_by! {|c| -c[:score] }
        sec[:right] = candidates[0][:content]
      end
    end
    
    # render and cache
    Rails.cache.write(
      "home/sections",
      view.render(:partial => "home/cached/sections", :object => @sections)
    )
  end
  
  class << self
    include NewRelic::Agent::Instrumentation::ControllerInstrumentation
    add_transaction_tracer :_cache_homepage, :category => :task
  end
end
