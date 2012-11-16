class OtherProgram < ActiveRecord::Base
  include Concern::Validations::SlugValidation
  
  self.table_name =  'programs_otherprogram'  
  has_secretary
  ROUTE_KEY = "program"

  #-------------------
  # Scopes
  scope :active, -> { where(:air_status => ['onair','online']) }
  
  #-------------------
  # Associations
  has_many :recurring_schedule_slots, as: :program
  has_many :schedules
  
  #-------------------
  # Validations
  validates :title, :air_status, presence: true
  validates :slug, uniqueness: true
  
  # Temporary
  validates :podcast_url, presence: true, if: -> { self.rss_url.blank? }
  validates :rss_url, presence: true, if: -> { self.podcast_url.blank? }
  
  validate :rss_or_podcast_present
  def rss_or_podcast_present
    if self.podcast_url.blank? && self.rss_url.blank?
      errors.add(:base, "Must specify either a Podcast url or an RSS url")
      errors.add(:podcast_url, "")
      errors.add(:rss_url, "")
    end
  end
  
  #-------------------
  # Callbacks
  
  #-------------------
  # Administration
  administrate do
    define_list do
      list_order "title"
      list_per_page :all
      
      column :title
      column :produced_by
      column :air_status
    end
  end
  
  #-------------------
  # Sphinx
  define_index do
    indexes title
    indexes description
    indexes host
    indexes produced_by
  end

  #-------------------
  
  def display_segments
    false
  end

  #-------------------
  
  def display_episodes
    false
  end

  #----------
  
  def published?
    self.air_status != "hidden"
  end
  
  #----------
  
  def route_hash
    return {} if !self.persisted? || !self.published?
    {
      :show           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end
  
  #----------
  
  def cache
    if self.podcast_url.present?
      fetch_feed(self.podcast_url, "podcast")
    end
    
    if self.rss_url.present?
      fetch_feed(self.rss_url, "rss")
    end
  end

  #----------
  
  private
  
  def fetch_feed(url, cache_suffix)
    cacher = CacheController.new
    feed   = Feedzirra::Feed.fetch_and_parse url
    
    if !feed.is_a?(Fixnum)
      cacher.cache(feed.entries.first(5), "/programs/cached/podcast_entry", "ext_program:#{self.slug}:#{cache_suffix}", local: :entry)
    end
  end
end
