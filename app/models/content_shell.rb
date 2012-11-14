class ContentShell < ContentBase
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Methods::HeadlineMethods
  include Concern::Validations::ContentValidation
  include Concern::Validations::PublishedAtValidation
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::AssetAssociation  
  include Concern::Scopes::SinceScope
  
  
  self.table_name =  "contentbase_contentshell"
  has_secretary
      
  def self.content_key
    "content/shell"
  end
  
  # ------------------
  # Validation
  validates :url, presence: true

  def should_validate?
    pending? or published?
  end
  
  
  # -------------------
  # Administration
  administrate do
    define_list do
      list_order "published_at desc"
      
      column "headline"
      column "site"
      column "bylines"
      column "status"
      column "published_at"
    end
  end


  # -------------------
  # Scopes


  # -------------------
  
  define_index do
    indexes headline
    indexes body
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has "CRC32(CONCAT('content/shell:',contentbase_contentshell.id))", :type => :integer, :as => :obj_key
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "0", :as => :is_slideshow, :type => :boolean
    has "0", :as => :has_audio, :type => :boolean
    where "status = #{STATUS_LIVE}"
  end
  
  def teaser
    self.body
  end
  
  #----------
  # Override AdminResource's `link_path` for these
  def link_path(options={})
    self.url
  end
  
  def remote_link_path(options={})
    self.url
  end
  
  #----------
  
  def byline_elements
    [self.site]
  end
  
  #----------
end
