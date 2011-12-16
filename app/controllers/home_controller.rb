class HomeController < ApplicationController
  layout "homepage"
  
  def index
    @homepage = Homepage.published.first
    
    citems = @homepage.content.collect { |c| c.content }

    # -- Broadcast Bar -- #
    Time.zone = "Pacific Time (US & Canada)"
    
    @onnow = Schedule.where("day = ? AND start_time <= ?", Date.today.wday, Time.now.to_s(:time)).limit(1)
    @upnext = Schedule.where("day = ? AND end_time < ?", Date.today.wday, Time.now.to_s(:time)).order("day DESC, start_time DESC").limit(1)
        
    # -- More Headlines -- #
    
    @headlines = []
    ThinkingSphinx.search(
      '',
      :classes    => [NewsStory],
      :page       => 1,
      :per_page   => 12,
      :order      => :published_at,
      :sort_mode  => :desc
    ).each do |c|
      # only include content that is not in the homepage
      if !citems.include? c
        @headlines << c
      end
    end
    
    # -- Latest Events  -- #
    @events = Event.where("is_published = ? AND starts_at > ? AND etype != ? AND etype != ?", 1, Time.now, "spon", "pick").order("starts_at ASC").limit(4)
    
    
    # -- Section Rules -- #
    
    @sections = []
    
    # run a query for each section 
    Category.all.each do |cat|
      content = ThinkingSphinx.search '',
        :classes    => [NewsStory,BlogEntry,ContentShell,ShowSegment],
        :page       => 1,
        :per_page   => 12,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => cat.id }
      
      top = nil
      right = nil
      more = []
      sorttime = nil
      
      content.each do |c|
        # first, rule out content that is in the homepage
        if citems.include? c
          # pass...
          next
        end
        
        # if we're still here, weigh this content for sorting
        if !sorttime || c.public_datetime > sorttime
          sorttime = c.public_datetime
        end
        
        # does this content have an asset?
        if !top && c.assets.any?
          top = c
          next
        end
        
        # if a slideshow or segment, potential right feature
        if !right && c.canFeature?
          right = c
          next
        end
        
        # finally, just drop it in the more bucket
        more << c
      end  
      
      # assemble section object
      @sections << {
        :section  => cat,
        :top      => top,
        :right    => right,
        :more     => more,
        :sorttime => sorttime
      }      
    end
    
    # now sort sections by the sorttime
    @sections.sort_by! {|s| s[:sorttime] }.reverse!
  end
  
  def old_index
    @homepage = Homepage.published.first
    
    # -- Section Rules -- #
    
    sechash = {}
    @sections = []
    
    # Grab 40 pieces of categorized content and pop them into buckets
    @content = ThinkingSphinx.search '',
      :classes    => [NewsStory],
      :page       => 1,
      :per_page   => 40,
      :order      => :published_at,
      :sort_mode  => :desc

    @content.each do |c|
      if c.category
        if sechash[ c.category.id ]
          sechash[ c.category.id ] << c
        else
          s = [c]
          sechash[ c.category.id ] = s
          @sections << s
        end
      end
    end
  end

  def beta
    render :layout => "beta"
  end
end
