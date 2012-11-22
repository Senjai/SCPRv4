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
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Methods::CommentMethods
  include Concern::Methods::HeadlineMethods
  include Concern::Methods::ContentJsonMethods

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
  validates :slug, uniqueness: true

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
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has status
    has "1", as: :findable, type: :boolean
    has "CRC32(CONCAT('content/video:',contentbase_videoshell.id))", :type => :integer, :as => :obj_key
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "0", :as => :is_slideshow, :type => :boolean
    has "0", :as => :has_audio, :type => :boolean
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
