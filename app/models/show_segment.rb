class ShowSegment < ActiveRecord::Base
  include Concern::Scopes::SinceScope
  include Concern::Scopes::PublishedScope
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::AudioAssociation
  include Concern::Associations::AssetAssociation
  include Concern::Associations::RelatedContentAssociation
  include Concern::Associations::RelatedLinksAssociation
  include Concern::Associations::BylinesAssociation
  include Concern::Associations::CategoryAssociation
  include Concern::Validations::ContentValidation
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Callbacks::GenerateSlugCallback
  include Concern::Callbacks::CacheExpirationCallback
  include Concern::Callbacks::RedisPublishCallback
  include Concern::Callbacks::TouchCallback
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Methods::CommentMethods
  include Concern::Methods::HeadlineMethods
  include Concern::Methods::TeaserMethods
  
  self.table_name = 'shows_segment'
  has_secretary
  ROUTE_KEY = "segment"
  
  ASSET_SCHEMES = [
    ["Full Width (default)", ""],
    ["Float Right", "float"],
    ["Slideshow", "slideshow"],
    ["No Display", "hidden"]
  ]
  
  #-------------------
  # Scopes
  scope :filtered_by_bylines, ->(bio_id) { 
    self.includes(:bylines).where(ContentByline.table_name => { user_id: bio_id }) 
  }
  
  #-------------------
  # Associations
  belongs_to :show,   class_name: "KpccProgram"
  has_many :rundowns, class_name: "ShowRundown", foreign_key: "segment_id", dependent: :destroy
  has_many :episodes, through: :rundowns, source: :episode, order: "air_date asc", autosave: true
  
  #-------------------
  # Validations
  validates :show, presence: true
  
  def should_validate?
    self.pending? || self.published?
  end
  
  def should_generate_slug?
    self.slug.blank? && (self.pending? || self.published?)
  end
  
  #-------------------
  # Callbacks
  
  #-------------------
  # Administration
  administrate do
    define_list do
      list_order "updated_at desc"
      
      column :headline
      column :show
      column :bylines
      column :published_at
      column :status
      
      filter :show_id, collection: -> { KpccProgram.all.map { |program| [program.to_title, program.id] } }
      filter :bylines, collection: -> { Bio.select_collection }
      filter :status, collection: -> { ContentBase.status_text_collect }
    end
  end
  include Concern::Methods::ContentJsonMethods
  
  #-------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes headline
    indexes teaser
    indexes body
    indexes bylines.user.name, as: :bylines
    has show.id, as: :program
    has category.id, as: :category
    has category.is_news, as: :category_is_news
    has published_at
    has updated_at
    has status
    has "1", as: :findable, type: :boolean
    has "1", as: :is_source_kpcc, type: :boolean
    has "CRC32(CONCAT('shows/segment:',#{ShowSegment.table_name}.id))", type: :integer, as: :obj_key
    has "(#{ShowSegment.table_name}.segment_asset_scheme <=> 'slideshow')", type: :boolean, as: :is_slideshow
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0", as: :has_audio, type: :boolean
    join audio
  end
  
  #----------
  
  def episode
    episodes.first
  end

  #----------
  
  def sister_segments
    if episodes.present?
      episode.segments.published.where("shows_segment.id != ?", self.id)
    else
      show.segments.published.where("shows_segment.id != ?", self.id).limit(5)
    end
  end

  #----------
  
  def byline_extras
    [self.show.title]
  end
  
  #----------
  
  def route_hash
    return {} if !self.published? || !self.persisted?
    {
      :show           => self.persisted_record.show.slug,
      :year           => self.persisted_record.published_at.year, 
      :month          => "%02d" % self.persisted_record.published_at.month,
      :day            => "%02d" % self.persisted_record.published_at.day,
      :id             => self.persisted_record.id,
      :slug           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end
end
