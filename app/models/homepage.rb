class Homepage < ActiveRecord::Base
  self.table_name =  "layout_homepage"
  
  has_many :content, :class_name => "HomepageContent", :order => "position asc"
  
  scope :published, where(:status => ContentBase::STATUS_LIVE).order("published_at desc")
  
  #----------
  
  def scored_content
    # -- Homepage Items -- #
    
    citems = self.content.collect { |c| c.content || nil }.compact

    # -- More Headlines -- #
    
    # Anything with a news category is eligible
    headlines = ThinkingSphinx.search(
      '',
      :classes    => ContentBase.content_classes,
      :page       => 1,
      :per_page   => 12,
      :order      => :published_at,
      :sort_mode  => :desc,
      :without    => { :category => '' },
      :without_any => { :obj_key => citems.collect {|c| c.obj_key.to_crc32 } }
    )
        
    # -- Section Blocks -- #
    
    sections = []
        
    # run a query for each section 
    Category.all.each do |cat|
      # exclude content that is used in our object
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
        # get the content time as Time
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
      
      # stick top at the front of content
      
      
      # assemble section object
      sec = {
        :section  => cat,
        :content  => [top,more].flatten,
        :sorttime => sorttime
      }
      
      #----------
      # -- Right Feature Candidates -- #
      #----------
      
      candidates = []

      # -- first look for featured comments -- #

      featured = sec[:section].comment_bucket.comments.published

      if featured.any?
        # Initial score:  20
        # Decay rate:     0.05
        candidates << {
          :content  => featured.first,
          :score    => 20 * Math.exp( -0.04 * ((Time.now - featured.first.published_at) / 3600) ),
          :metric   => :comment
        }        
      end

      # -- now try slideshows -- #

      slideshow = ThinkingSphinx.search '',
        :classes    => ContentBase.content_classes,
        :page       => 1,
        :per_page   => 1,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => sec[:section].id, :is_slideshow => true },
        :without_any => { :obj_key => [citems,sec[:content][0]].flatten.collect {|c| c.obj_key.to_crc32 } }

      if slideshow.any?
        # Initial score:  5 + number of slides
        # Decay rate:     0.01
        slideshow = slideshow.first

        candidates << {
          :content  => slideshow,
          :score    => (5 + slideshow.assets.length) * Math.exp( -0.01 * ((Time.now - (slideshow.public_datetime.is_a?(Date) ? slideshow.public_datetime.to_time : slideshow.public_datetime)) / 3600) ),
          :metric   => :slideshow
        }
      end

      # -- segment in the last two days? -- #

      segments = ThinkingSphinx.search '',
        :classes    => [ShowSegment],
        :page       => 1,
        :per_page   => 1,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => sec[:section].id },
        :without_any => { :obj_key => [citems,sec[:content][0]].flatten.collect {|c| c.obj_key.to_crc32 } }

      if segments.any?
        # Initial score:  10
        # Decay rate:     0.02  
        seg = segments.first

        candidates << {
          :content  => seg,
          :score    => 10 * Math.exp(-0.02 * ((Time.now - seg.public_datetime.to_time) / 3600) ),
          :metric   => :segment
        }
      end

      if candidates.any?
        candidates.sort_by! {|c| -c[:score] }
        sec[:right] = candidates[0][:content]
        sec[:candidates] = candidates
      end
      
      # Add this to our section list
      sections << sec
    end
    
    # now sort sections by the sorttime
    sections.sort_by! {|s| s[:sorttime] }.reverse!
    
    now = DateTime.now()
    
    return {
      :headlines  => headlines,
      :sections   => sections
    }
  end
  
end