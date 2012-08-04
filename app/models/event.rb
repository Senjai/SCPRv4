class Event < ActiveRecord::Base
  self.table_name =  'events_event'
  self.primary_key = "id"
  
  ForumTypes = [
    "comm",
    "cult",
    "hall"
  ]
  
  # -------------------
  # Administration
  administrate
  
  # -------------------
  # Associations
  has_many :assets, class_name: "ContentAsset", as: :content

  # -------------------
  # Validations
  validates_presence_of :id, :title, :slug, :etype, :starts_at
  
  # -------------------
  # Scopes
  scope :published,             where(is_published: true)
  scope :forum,                 published.where("etype IN (?)", ForumTypes)
  scope :sponsored,             published.where("etype = ?", "spon")
  
  scope :upcoming,              -> { published.where("starts_at > ?", Time.now).order("starts_at") }
  scope :upcoming_and_current,  -> { published.where("ends_at > ?", Time.now).order("starts_at") }
  scope :past,                  -> { published.where("ends_at < ?", Time.now).order("starts_at desc") }

  # -------------------
  
  def self.sorted(events)
    events.sort { |a,b| a.sorter <=> b.sorter }
  end
  
  def sorter
    ongoing? ? ends_at : starts_at
  end
  
  # -------------------

  def ongoing?
    is_multiple_days? and current?
  end
  
  def is_multiple_days?
    minutes > 24*60
  end
  
  def minutes
    ((ends_at - starts_at) / 60).floor
  end
  
  # -------------------
  
  def self.closest
    upcoming.first
  end
  
  def headline
    title
  end
  
  def short_headline
    headline
  end
  
  # -------------------
  
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
  
  # -------------------
  
  def consoli_dated # should probably be a helper.
    # If one needs minutes, use that format for the other as well, for consistency
    timef = (starts_at.min == 0 and [0, nil].include?(ends_at.try(:min))) ? "%l" : "%l:%M"
    
    if self.is_all_day
      starts_at.strftime("%A, %B %e") # Wednesday, October 11
    elsif ends_at.blank?
      starts_at.strftime("%A, %B %e, #{timef}%P") # Wednesday, October 11, 11am
    elsif starts_at.day == ends_at.day # If the event starts and ends on the same day
      if starts_at.strftime("%P") != ends_at.strftime("%P") # If it starts in the AM and ends in the PM
        starts_at.strftime("%A, %B %e, #{timef}%P -") + ends_at.strftime("#{timef}%P")
      else
        starts_at.strftime("%A, %B %e, #{timef} -") + ends_at.strftime("#{timef}%P")
      end
    else # If the event starts and ends on different days
      starts_at.strftime("%A, %B %e, #{timef}%P -") + ends_at.strftime("%A, %B %e, #{timef}%P")
    end
  end
  
  #----------
  
  def is_forum_event?
    ForumTypes.include? self.etype
  end
  
  def has_format?
    false
  end
  
  def has_comments?
    self.show_comments
  end
  
  #----------
  
  def obj_key
    "events/event:#{self.id}"
  end
  
  def disqus_identifier
    obj_key
  end
  
  def disqus_shortname
    'kpcc'
  end

  #----------
  
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
  
  def remote_link_path
    "http://www.scpr.org#{self.link_path}"
  end
    
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
end
