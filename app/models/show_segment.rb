class ShowSegment < ContentBase
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Methods::CommentMethods
  include Concern::Methods::HeadlineMethods
  include Concern::Methods::TeaserMethods
  include Concern::Validations::ContentValidation
  include Concern::Validations::SlugUniqueForPublishedAtValidation
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::AudioAssociation
  include Concern::Associations::AssetAssociation
  include Concern::Scopes::SinceScope
  
  
  self.table_name      = 'shows_segment'
  has_secretary
  PRIMARY_ASSET_SCHEME = :segment_asset_scheme
  ROUTE_KEY            = "segment"
  
  ASSET_SCHEMES = [
    ["Full Width (default)", ""],
    ["Float Right", "float"],
    ["Slideshow", "slideshow"]
  ]
  
  #-------------------
  # Scopes
  
  #-------------------
  # Associations
  belongs_to :show,   :class_name => "KpccProgram"
  has_many :rundowns, :class_name => "ShowRundown", :foreign_key => "segment_id"
  has_many :episodes, :through    => :rundowns, :source => :episode, :order => "air_date asc"
  
  #-------------------
  # Validations
  validates :show, presence: true
  
  def should_validate?
    pending? or published?
  end
  
  #-------------------
  # Callbacks
  
  #-------------------
  # Administration
  administrate do
    define_list do
      column :headline
      column :show
      column :bylines
      column :published_at
      column :status
    end
  end
  
  #-------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes headline
    indexes teaser
    indexes body
    has show.id, as: :program
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has status
    has "1", as: :findable, type: :boolean
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "CRC32(CONCAT('shows/segment:',shows_segment.id))", :type => :integer, :as => :obj_key
    has "(shows_segment.segment_asset_scheme <=> 'slideshow')", :type => :boolean, :as => :is_slideshow
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0", :as => :has_audio, :type => :boolean
    join audio
  end
  
  #----------
  
  def episode
    episodes.first
  end
  
  def sister_segments
    if episodes.present?
      episode.segments.published.where("shows_segment.id != ?", self.id)
    else
      show.segments.published.where("shows_segment.id != ?", self.id).limit(5)
    end
  end
  
  def byline_elements
    [self.show.title]
  end
  
  #----------
  
  def canFeature?
    self.assets.present?
  end
  
  #----------
  
  def public_datetime
    self.published_at
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
