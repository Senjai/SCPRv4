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
  
  # Address and Google Maps stuff.
  # TODO Move this out of Events, into its own class.
  
  def gmaps_json
    if inline_address.present?
      puts "... fetching JSON from Google Maps"
      raw_json = Net::HTTP.get(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{url_safe_address}&sensor=false")) # TODO Pass in some informatiomn from the user's device to enable sensor or not
      JSON.parse(raw_json)
    end
  end
  
  def lat_long
    json = gmaps_json
    if json.present? and json["status"] == "OK"
      "#{json["results"][0]["geometry"]["location"]["lat"]},#{json["results"][0]["geometry"]["location"]["lng"]}" # TODO This is fragile, dependent upon the format & order of the JSON response from google maps
    end
  end
  
  def url_safe_address
    inline_address.gsub(/\s/, "+") # TODO Figure out what else we need to gsub - https://developers.google.com/maps/documentation/webservices/#BuildingURLs
  end
  
  def inline_address(separator=", ")
    [address_1, address_2, city, state, zip_code].reject { |element| element.blank? }.join(separator)
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
  
  def has_comments?
    true
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