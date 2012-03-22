class Event < ActiveRecord::Base
  self.table_name =  'rails_events_event'
  self.primary_key = :id
  
  has_many :assets, :class_name => "ContentAsset", :as => :content
  
#  belongs_to :enco_audio, :foreign_key => "enco_number", :primary_key => "enco_number", :conditions => proc { ["publish_date = ?",self.audio_date] }
  has_many :uploaded_audio, :as => "content"
  
  #----------

  scope :published, where(:is_published => true)
  scope :upcoming, lambda { published.where("starts_at > ?", Time.now).order("starts_at") }
  scope :forum, published.where("etype != ? AND etype != ?", "spon", "pick")
  scope :sponsored, published.where("etype = ?", "spon")
  scope :past, lambda { published.where("ends_at < ?", Time.now).order("starts_at desc") }
  
  def self.closest
    upcoming.first
  end
  
  #----------
  
  def link_path(options={})
    Rails.application.routes.url_helpers.event_path(options.merge!({
      :year => self.starts_at.year, 
      :month => self.starts_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.starts_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
      :slug => self.slug,
      :trailing_slash => true
    }))
  end
  
  ### ContentBase methods
  
  def teaser # TODO Need a teaser column in mercer for events
    description.blank? ? "#{title} at #{location_name}" : description.scan(/(?:\w+\s)/)[0..20].join(" ") + "..."
  end
  
  def headline
    title
  end
  
  
  def audio
    @audio ||= self._get_audio()
  end
  
  def _get_audio # Do we need to check for ENCO audio for Events?
    # check for ENCO Audio
    audio = []
    
    if self.respond_to?(:enco_audio)
      audio << self.enco_audio
    end
    
    if self.respond_to?(:uploaded_audio)
      audio << self.uploaded_audio
    end
    
    return audio.flatten.compact
  end
  
  
  def remote_link_path
    "http://www.scpr.org#{self.link_path}"
  end
  
  
  def obj_key
    "events/event:#{self.id}"
  end
end