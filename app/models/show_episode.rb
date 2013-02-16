class ShowEpisode < ActiveRecord::Base
  self.table_name = "shows_episode"
  outpost_model
  has_secretary

  include Concern::Scopes::SinceScope
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::AudioAssociation
  include Concern::Associations::AssetAssociation
  include Concern::Validations::ContentValidation
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Callbacks::CacheExpirationCallback
  include Concern::Callbacks::RedisPublishCallback
  include Concern::Callbacks::TouchCallback
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Methods::HeadlineMethods
  include Concern::Methods::ContentJsonMethods

  ROUTE_KEY = "episode"
  
  #-------------------
  # Scopes
  scope :published, -> { where(status: ContentBase::STATUS_LIVE).order("air_date desc, published_at desc") }
  scope :upcoming, -> { where(["status = ? and air_date >= ?",ContentBase::STATUS_PENDING,Date.today()]).order("air_date asc") }
  
  #-------------------
  # Association
  belongs_to  :show,      :class_name  => "KpccProgram"
  
  has_many    :rundowns,  :class_name  => "ShowRundown", 
                          :foreign_key => "episode_id",
                          :dependent   => :destroy
  
  has_many    :segments,  :class_name  => "ShowSegment", 
                          :foreign_key => "segment_id", 
                          :through     => :rundowns, 
                          :order       => "segment_order"

  #-------------------
  # Validations
  validates :show, presence: true
  validates :air_date, presence: true, if: :should_validate?
  
  def needs_validation?
    self.pending? || self.published?
  end
  
  #-------------------
  # Callbacks
  attr_accessor :segment_json
  before_save :parse_segment_json
  
  before_validation :generate_headline, if: -> { self.headline.blank? }
  def generate_headline
    if self.air_date.present?
      self.headline = "#{self.show.title} for #{self.air_date.strftime("%B %-d, %Y")}"
    end
  end
  
  #-------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes headline
    indexes body
    indexes bylines.user.name, as: :bylines
    has show.id, as: :program
    has "''", as: :category, type: :integer
    has "0", as: :category_is_news, type: :boolean
    has air_date
    has published_at
    has updated_at
    has status
    has "1", as: :findable, type: :boolean
    has "1", as: :is_source_kpcc, type: :boolean
    has "CRC32(CONCAT('shows/episode:',#{ShowEpisode.table_name}.id))", type: :integer, as: :obj_key
    has "0", type: :boolean, as: :is_slideshow
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0", as: :has_audio, type: :boolean
    join audio
  end

  #--------------------
  # Teaser just returns the body.
  def teaser
    self.body
  end

  #----------
  # Fake the byline
  def byline
    self.show.title
  end
  
  #----------
  
  def json
    super.merge({
      :teaser         => self.teaser,
      :short_headline => self.headline
    })
  end
  
  #----------
  
  def route_hash
    return {} if !self.published? || !self.persisted?
    {
      :show           => self.persisted_record.show.slug,
      :year           => self.persisted_record.air_date.year, 
      :month          => "%02d" % self.persisted_record.air_date.month,
      :day            => "%02d" % self.persisted_record.air_date.day,
      :trailing_slash => true
    }
  end
  
  #----------
    
  def parse_segment_json
    return if self.segment_json.blank?
    @_loaded_rundowns = []

    Array(JSON.parse(self.segment_json)).each do |segment_hash|
      if segment = ContentBase.obj_by_key(segment_hash["id"])
        # Protect against AssociationMismatch Error
        if segment.is_a? ShowSegment
          association = ShowRundown.new(
            :segment_order => segment_hash["position"], 
            :segment       => segment, 
            :episode       => self
          )
        
          @_loaded_rundowns.push association
        end
      end
    end
    
    self.rundowns = @_loaded_rundowns
    true
  end
end
