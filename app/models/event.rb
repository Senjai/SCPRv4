class Event < ActiveRecord::Base
  include Model::Validations::SlugValidation
  include Model::Validations::ContentValidation
  
  self.table_name =  'events_event'
  self.primary_key = "id"
  
  acts_as_content auto_published_at: false, has_status: false, published_at: false
  has_secretary
  
  ForumTypes = [
    "comm",
    "cult",
    "hall"
  ]
  
  CONTENT_TYPE = "events/event"
  
  # -------------------
  # Administration
  administrate do |admin|
    admin.define_list do |list|
      list.order = "created_at desc"
      list.column "headline"
      list.column "starts_at"
      list.column "location_name", header: "Location"
      list.column "etype",         header: "Type"
      list.column "kpcc_event",    header: "KPCC Event?"
      list.column "is_published",  header: "Published?"
    end
  end

  # -------------------
  # Validations
  validates_presence_of :etype, :starts_at, if: -> { self.published? }
  validates :slug, unique_by_date: { scope: :starts_at, filter: :day, message: "has already been used for that start date." },
    if: :published?
  
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
    multiple_days? and current?
  end
  
  def multiple_days?
    minutes > 24*60
  end
  
  def minutes
    ((ends_at - starts_at) / 60).floor
  end
  
  # -------------------
  
  # Fake these until we can make Events actually publishable
  def published?
    is_published
  end
  
  def pending?
    !published?
  end
  
  def status
    published? ? ContentBase::STATUS_LIVE : ContentBase::STATUS_DRAFT
  end
  
  #-------------
  
  def self.closest
    upcoming.first
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
  
  #----------
  
  def inline_address(separator=", ")
    [address_1, address_2, city, state, zip_code].reject { |element| element.blank? }.join(separator)
  end

  #----------
  
  def description
    if self.upcoming? or archive_description.blank?
      self.body
    else
      archive_description
    end
  end

  #----------
  
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
end
