class Event < ActiveRecord::Base
  set_table_name 'rails_events_event'
  set_primary_key :id

  has_many :assets, :class_name => "ContentAsset", :as => :content
  
  #----------
  
  scope :published, where(:is_published => true)
  
  scope :upcoming_forum, where("starts_at > ? AND etype != ? AND etype != ?", Time.now, "spon", "pick").order("starts_at ASC")
  
  #----------

  def obj_key
    "events/event:#{self.id}"
  end

  def link_path
    Rails.application.routes.url_helpers.event_path(
      :year => self.starts_at.year, 
      :month => self.starts_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.starts_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
      :slug => self.slug,
      :trailing_slash => true
    )
    
  end
end