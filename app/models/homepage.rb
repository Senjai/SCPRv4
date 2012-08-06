class Homepage < ActiveRecord::Base
  self.table_name =  "layout_homepage"

  # -------------------
  # Administration
  administrate
  self.list_order = "published_at desc"
  self.list_fields = [
    ['published_at'],
    ['status'],
    ['base', title: "Base Template"]
  ]
  
  # -------------------
  # Associations
  has_many :content, :class_name => "HomepageContent", :order => "position asc"
  belongs_to :missed_it_bucket
  
  # -------------------
  # Scopes
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
    ).compact
        
    # -- Section Blocks -- #
    
    sections = []
        
    # run a query for each section 
    Category.all.each do |cat|
      # exclude content that is used in our object
      content = ThinkingSphinx.search('',
        :classes    => ContentBase.content_classes,
        :page       => 1,
        :per_page   => 5,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => cat.id },
        :without_any => { :obj_key => citems.collect {|c| c.obj_key.to_crc32 } }
      ).compact
      
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
      
      sec[:candidates] = cat.feature_candidates :exclude => [ citems,top ].flatten
      sec[:right] = sec[:candidates] ? sec[:candidates][0][:content] : nil
      
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