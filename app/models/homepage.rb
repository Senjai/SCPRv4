class Homepage < ActiveRecord::Base
  self.table_name = "layout_homepage"
  outpost_model
  has_secretary

  include Concern::Scopes::PublishedScope
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::ContentAssociation
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Callbacks::RedisPublishCallback
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  
  TEMPLATES = {
    "default"    => "Visual Left",
    "lead_right" => "Visual Right"
  }
  
  TEMPLATE_OPTIONS = TEMPLATES.map { |k, v| [v, k] }
  
  #-------------------
  # Scopes
  
  #-------------------
  # Associations
  has_many :content, class_name: "HomepageContent", order: "position", dependent: :destroy
  belongs_to :missed_it_bucket
  
  #-------------------
  # Validations
  validates :base, presence: true
  
  #-------------------
  # Callbacks
  after_save :expire_cache

  #-------------------
  # Sphinx
  define_index do
    indexes base
    has published_at
    has updated_at
  end
  
  #----------
  
  def expire_cache
    Rails.cache.expire_obj("layout/homepage")
  end
  
  #----------
  
  def scored_content
    # -- Homepage Items -- #
    
    citems = self.content.collect { |c| c.content || nil }.compact

    # -- More Headlines -- #
    
    # Anything with a news category is eligible
    headlines = ContentBase.search({
      :limit       => 12,
      :without     => { category: '' },
      :without_any => { obj_key: citems.collect {|c| c.obj_key.to_crc32 } },
    })
    
    # -- Section Blocks -- #
    
    sections = []
    
    # run a query for each section 
    Category.all.each do |cat|
      # exclude content that is used in our object
      content = ContentBase.search({
        :limit    => 5,
        :with        => { category: cat.id },
        :without_any => { obj_key: citems.collect {|c| c.obj_key.to_crc32 } }
      })
      
      more     = []
      top      = nil
      sorttime = nil
      
      content.each do |c|
        # get the content time as Time
        ctime = c.published_at.is_a?(Date) ? c.published_at.to_time : c.published_at
        
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
        :content  => [top,more].flatten.compact,
        :sorttime => sorttime
      }
      
      
      #----------
      # -- Right Feature Candidates -- #
      #----------
      
      sec[:candidates] = cat.feature_candidates :exclude => [ citems,top ].flatten.compact
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
  
  #---------------------
  
  private
  
  def build_content_association(content_hash, content)
    HomepageContent.new(
      :position => content_hash["position"].to_i,
      :content  => content,
      :homepage => self
    )
  end
end
