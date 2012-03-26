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
  
  def upcoming?
    ends_at > Time.now # Use "ends_at" so it still shows the details while the event is happening
  end
  
  def consoli_dated # This could be a little more robust, but it'll do for now, should probably also be a helper.
    if starts_at.day == ends_at.day
      starts_at.strftime("%A, %B %e, %l-") + ends_at.strftime("%l%P")
    else
      starts_at.strftime("%A, %B %e, %l%P-") + ends_at.strftime("%A, %B %e, %l%P")
    end
  end
  
  #----------
  
  def url_safe_address
    inline_address.gsub(/\s/, "+") # TODO Figure out what else we need to gsub - https://developers.google.com/maps/documentation/webservices/#BuildingURLs
  end
  
  def is_forum_event
    if self.etype == "comm" || self.etype == "cult" || self.etype == "hall"
      true
    end
  end
  
  #----------
  
  def obj_key
    "events/event:#{self.id}"
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
  
  def remote_link_path
    "http://www.scpr.org#{self.link_path}"
  end
  
  
  def obj_key
    "events/event:#{self.id}"
  end
end