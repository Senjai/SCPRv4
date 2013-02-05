class ContentShell < ActiveRecord::Base
  include Concern::Scopes::SinceScope
  include Concern::Scopes::PublishedScope
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::AssetAssociation
  include Concern::Associations::BylinesAssociation
  include Concern::Associations::CategoryAssociation
  include Concern::Validations::ContentValidation
  include Concern::Validations::PublishedAtValidation
  include Concern::Callbacks::CacheExpirationCallback
  include Concern::Callbacks::RedisPublishCallback
  include Concern::Callbacks::TouchCallback
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Methods::HeadlineMethods

  self.table_name =  "contentbase_contentshell"
  has_secretary
      
  def self.content_key
    "content/shell"
  end
  
  #-------------------
  # Scopes
  
  #------------------
  # Association
  
  #------------------
  # Validation
  validates :url, presence: true

  def needs_validation?
    self.pending? || self.published?
  end

  #------------------
  # Callbacks
  
  #-------------------
  # Administration
  administrate do
    define_list do
      list_order "updated_at desc"
      
      column :headline
      column :site
      column :bylines
      column :status
      column :published_at
      
      filter :site, collection: -> { ContentShell.select("distinct site").map { |c| c.site } }
      filter :status, collection: -> { ContentBase.status_text_collect }
    end
  end
  
  # TODO Fix this hack
  include Concern::Methods::ContentJsonMethods
  def json
    super.merge({
      :short_headline => self.short_headline,
      :teaser         => self.teaser
    })
  end
  

  #-------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes headline
    indexes body
    indexes bylines.user.name, as: :bylines
    has category.id, as: :category
    has category.is_news, as: :category_is_news
    has published_at
    has updated_at
    has status
    has "1", as: :findable, type: :boolean
    has "CRC32(CONCAT('content/shell:',#{ContentShell.table_name}.id))", type: :integer, as: :obj_key
    has "1", as: :is_source_kpcc, type: :boolean
    has "0", as: :is_slideshow, type: :boolean
    has "0", as: :has_audio, type: :boolean
  end
  
  #-------------------
  
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
  
  def byline_extras
    [self.site]
  end
  
  #----------
end
