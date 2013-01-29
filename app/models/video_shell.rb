class VideoShell < ActiveRecord::Base
  include Concern::Scopes::SinceScope
  include Concern::Scopes::PublishedScope
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::AssetAssociation
  include Concern::Associations::BylinesAssociation
  include Concern::Associations::CategoryAssociation
  include Concern::Validations::ContentValidation
  include Concern::Validations::SlugValidation
  include Concern::Validations::PublishedAtValidation
  include Concern::Callbacks::GenerateSlugCallback
  include Concern::Callbacks::CacheExpirationCallback
  include Concern::Callbacks::RedisPublishCallback
  include Concern::Callbacks::TouchCallback
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Methods::CommentMethods
  include Concern::Methods::HeadlineMethods

  self.table_name = "contentbase_videoshell"
  ROUTE_KEY       = "video"
  has_secretary
  
  def self.content_key
    "content/video"
  end
  
  #-------------------
  # Scopes

  #-------------------
  # Association
    
  # -------------------
  # Validation

  #-------------------
  # Callbacks
  
  #-------------------
  # Administration
  administrate do
    define_list do
      column :headline
      column :slug
      column :bylines
      column :status
      column :published_at
    end
  end
  include Concern::Methods::ContentJsonMethods
  
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
    has "CRC32(CONCAT('content/video:',#{VideoShell.table_name}.id))", type: :integer, as: :obj_key
    has "1", as: :is_source_kpcc, type: :boolean
    has "0", as: :is_slideshow, type: :boolean
    has "0", as: :has_audio, type: :boolean
  end
  
  #--------------------
  # Teaser just returns the body.
  def teaser
    self.body
  end

  #--------------------
  
  def route_hash
    return {} if !self.persisted? || !self.published?
    {
      :id             => self.persisted_record.id,
      :slug           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end
end
