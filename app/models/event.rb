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
  scope :forum, published.where("etype IN (?)", ForumTypes)
  scope :sponsored, published.where("etype = ?", "spon")
  scope :past, lambda { published.where("starts_at < ?", Time.now).order("starts_at desc") }
  
  def self.closest
    upcoming.first
  end
  
  def upcoming? # Still display maps, details, etc. if the event is currently happening
    starts_at > Time.now
  end
  
  def current?
    if ends_at.present?
      Time.now.between? starts_at, ends_at
    else
      Time.now.between? starts_at, starts_at.end_of_day
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
    if self.upcoming? or archive_description.blank?
      self[:description]
    else
      archive_description
    end
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
  
  def teaser
    if self._teaser?
      return self._teaser
    end
    
    # -- cut down body to get teaser -- #
    
    l = 180    
    
    # first test if the first paragraph is an acceptable length
    fp = /^(.+)/.match(ActionController::Base.helpers.strip_tags(self.description).gsub("&nbsp;"," ").gsub(/\r/,''))
    
    if fp && fp[1].length < l
      # cool, return this
      return fp[1]
    elsif fp
      # try shortening this paragraph
      short = /^(.{#{l}}\w*)\W/.match(fp[1])
      
      if short
        return "#{short[1]}..."
      else
        return fp[1]
      end
    else
      return ''
    end    
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