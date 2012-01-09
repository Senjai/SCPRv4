class HomeController < ApplicationController
  layout "homepage"
  
  def index
    @homepage = Homepage.published.first
    
    citems = @homepage.content.collect { |c| c.content }

    # -- Broadcast Bar -- #    
    @onnow = Schedule.where("day = ? AND start_time <= ?", Date.today.wday, Time.now.to_s(:time)).limit(1)
    @upnext = Schedule.where("day = ? AND end_time < ?", Date.today.wday, Time.now.to_s(:time)).order("day DESC, start_time DESC").limit(1)
        
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
    
    # -- Section Rules -- #
    
    @sections = []
    
    # run a query for each section 
    Category.all.each do |cat|
      content = ThinkingSphinx.search '',
        :classes    => ContentBase.content_classes,
        :page       => 1,
        :per_page   => 12,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => cat.id },
        :without_any => { :obj_key => citems.collect {|c| c.obj_key.to_crc32 } }
      
      top = nil
      right = nil
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
