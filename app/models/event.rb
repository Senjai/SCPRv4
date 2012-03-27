class Event < ActiveRecord::Base
  self.table_name =  'rails_events_event'
  self.primary_key = :id
  
  has_many :assets, :class_name => "ContentAsset", :as => :content
  
  ForumTypes = [
    "comm",
    "cult",
    "hall"
  ]
  
  #----------

  scope :published, where(:is_published => true)
  scope :upcoming, lambda { published.where("starts_at > ?", Time.now).order("starts_at") }
  scope :forum, published.where("etype != ? AND etype != ?", "spon", "pick")
  scope :sponsored, published.where("etype = ?", "spon")
  scope :past, lambda { published.where("starts_at < ?", Time.now).order("starts_at desc") }
  
  def self.closest
    upcoming.first
  end
  
  def upcoming? # Still display maps, details, etc. if the event is currently happening
    if ends_at.blank?
      starts_at > Time.now
    else
      ends_at > Time.now
    end
  end
  
  def consoli_dated # should probably be a helper.
    if self.is_all_day
      starts_at.strftime("%A, %B %e")
    elsif ends_at.blank?
      starts_at.strftime("%A, %B %e, %l%P")
    elsif starts_at.day == ends_at.day
      if starts_at.strftime("%P") != ends_at.strftime("%P")
        starts_at.strftime("%A, %B %e, %l%P-") + ends_at.strftime("%l%P")
      else
        starts_at.strftime("%A, %B %e, %l-") + ends_at.strftime("%l%P")
      end
    else
      starts_at.strftime("%A, %B %e, %l%P-") + ends_at.strftime("%A, %B %e, %l%P")
    end
  end
  
  #----------
  
  def is_forum_event?
    ForumTypes.include? self.etype
  end
  
  #----------
  
  def obj_key
    "events/event:#{self.id}"
  end
  
  def inline_address(separator=", ")
    [address_1, address_2, city, state, zip_code].reject { |element| element.blank? }.join(separator)
  end
  
  def description
    if self.upcoming? or (!self.upcoming? and archive_description.blank?)
      self[:description]
    else
      archive_description
    end
  end
  
  def show_comments
    false # TODO Add this column in mercer
  end
  
  def audio_url
    "http://media.scpr.org/#{self.audio}"
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
    self.show_comments
  end
  
  def remote_link_path
    "http://www.scpr.org#{self.link_path}"
  end
  
  
  def obj_key
    "events/event:#{self.id}"
  end
end