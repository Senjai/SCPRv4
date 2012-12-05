class Homepage < ActiveRecord::Base
  include Concern::Scopes::PublishedScope
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  
  self.table_name =  "layout_homepage"
  has_secretary

  TEMPLATES = {
    "default"    => "Visual Left",
    "lead_right" => "Visual Right"
  }
  
  TEMPLATE_OPTIONS = TEMPLATES.map { |k, v| [v, k] }
  
  #-------------------
  # Scopes
  
  #-------------------
  # Associations
  has_many :content, class_name: "HomepageContent", order: "position asc", dependent: :destroy
  belongs_to :missed_it_bucket
  
  #-------------------
  # Validations
  validates :base, presence: true, inclusion: { in: TEMPLATES.keys }
  
  #-------------------
  # Callbacks
  # #content_json is a way to pass in a string representation
  # of a javascript object to the model, which will then be
  # parsed and turned into HomepageContent objects in the 
  # #parse_content_json method.
  attr_accessor :content_json
  before_save :parse_content_json
  
  #-------------------
  # Administration
  administrate do
    define_list do
      column :published_at
      column :status
      column :base, header: "Base Template"
    end
  end

  #-------------------
  # Sphinx
  
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
