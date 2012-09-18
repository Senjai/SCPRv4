class ShowEpisode < ContentBase
  include Model::Validations::ContentValidation
  include Model::Callbacks::SetPublishedAtCallback
  include Model::Associations::ContentAlarmAssociation
  include Model::Scopes::SinceScope
  
  
  self.table_name =  "shows_episode"
  has_secretary
  
  CONTENT_TYPE = 'shows/episode'
  
  acts_as_content comments: false
                  
  # -------------------
  # Administration
  administrate do |admin|
    admin.define_list do |list|
      list.order = "published_at desc"
      list.column "headline"
      list.column "show"
      list.column "air_date", helper: :display_date
      list.column "status"
      list.column "published_at"
    end
  end
  
  # -------------------
  # Validations
  validates :show_id,  presence: true
  validates :air_date, presence: true, if: :published?
  
  # -------------------
  # Associations
  belongs_to  :show,      class_name:   "KpccProgram"
  
  has_many    :rundowns,  class_name:   "ShowRundown", 
                          foreign_key:  "episode_id"
  
  has_many    :segments,  class_name:   "ShowSegment", 
                          foreign_key:  "segment_id", 
                          through:      :rundowns, 
                          order:        "segment_order asc"
    
  # -------------------
  # Scopes
  scope :published, where(status: ContentBase::STATUS_LIVE).order("air_date desc, published_at desc")
  scope :upcoming, -> { where(["status = ? and air_date >= ?",ContentBase::STATUS_PENDING,Date.today()]).order("air_date asc") }
  
  # -------------------
  
  define_index do
    indexes headline
    indexes body
    has "''", :as => :category, :type => :integer
    has "0", :as => :category_is_news, :type => :boolean
    has published_at
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "CRC32(CONCAT('shows/episode:',shows_episode.id))", :type => :integer, :as => :obj_key
    has "0", :type => :boolean, :as => :is_slideshow
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0", :as => :has_audio, :type => :boolean
    where "status = #{ContentBase::STATUS_LIVE}"
    join audio
  end

  #----------
  
  def link_path(options={})
    # We can't figure out the link path until
    # all of the pieces are in-place.
    return nil if !published?
    
    Rails.application.routes.url_helpers.episode_path(options.merge!({
      :show           => self.show.slug,
      :year           => self.air_date.year, 
      :month          => "%02d" % self.air_date.month,
      :day            => "%02d" % self.air_date.day,
      :trailing_slash => true
    }))
  end
end
