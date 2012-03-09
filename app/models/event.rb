class Event < ActiveRecord::Base
  self.table_name =  'rails_events_event'
  self.primary_key = :id

  has_many :assets, :class_name => "ContentAsset", :as => :content
  
  #----------
  
  scope :published, where(:is_published => true)
  scope :upcoming, lambda { where("starts_at > ?", Time.now) }
  scope :forum, where("etype != ? AND etype != ?", "spon", "pick").order("starts_at ASC")
  scope :sponsored, where("etype = ?", "spon")
  
  #----------

  def obj_key
    "events/event:#{self.id}"
  end

  def link_path(options={})
    Rails.application.routes.url_helpers.event_path({
      :year => self.starts_at.year, 
      :month => self.starts_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.starts_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
      :slug => self.slug,
      :trailing_slash => true
    }.merge! options)
    
  end
end