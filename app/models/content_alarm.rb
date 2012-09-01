class ContentAlarm < ActiveRecord::Base
  self.table_name = "contentbase_contentalarm"
  logs_as_task
  
  #----------
  # Scopes
  default_scope where("content_type is not null")
  scope :pending, -> { where("fire_at <= ? and has_fired = ?", Time.now, false).order("fire_at") }
  
  
  #----------
  # Association
  map_content_type_for_django
  belongs_to :content, polymorphic: true
  
  
  #----------
  # Validation
  validates_presence_of :fire_at, :content_id, :content_type
  validate :fire_at_is_in_future, if: -> { self.fire_at.present? }
  validate :content_status_is_pending, if: -> { self.content.present? }
  
  def fire_at_is_in_future
    if !(self.fire_at >= Time.now)
      errors.add(:fire_at, "must be in the future.")
    end
  end
  
  def content_status_is_pending
    if !(self.content.status == ContentBase::STATUS_PENDING)
      errors.add(:content_status, "must be pending in order for a Content Alarm to fire.")
    end
  end
  
  
  #----------
  # Callbacks
  before_save :set_action_for_django
  
  def set_action_for_django
    self.action = 1
  end
  
  #---------------------
  
  
  def self.fire_pending
    self.pending.each do |alarm|
      alarm.fire
    end
  end

  #---------------------
  
  def fire
    if can_fire?
      ContentAlarm.log "Firing ContentAlarm ##{self.id} for #{self.content.class.name} ##{self.content.id}"
      self.content.update_attributes(status: ContentBase::STATUS_LIVE)
      self.destroy
    else
      ContentAlarm.log "Can't fire ContentAlarm ##{self.id} for #{self.content.class.name} ##{self.content.id}"
      false
    end
  end
  
  #---------------------
  
  def pending?
    self.fire_at <= Time.now
  end

  #---------------------

  def can_fire?
    pending? and self.content.status == ContentBase::STATUS_PENDING
  end
end
