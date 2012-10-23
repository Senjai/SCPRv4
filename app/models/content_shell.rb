class ContentShell < ContentBase
  include Model::Methods::StatusMethods
  include Model::Methods::PublishingMethods
  include Model::Validations::ContentValidation
  include Model::Validations::PublishedAtValidation
  include Model::Associations::ContentAlarmAssociation
  include Model::Associations::AssetAssociation  
  include Model::Scopes::SinceScope
  
  
  self.table_name =  "contentbase_contentshell"
  has_secretary
    
  acts_as_content comments: false
  
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
