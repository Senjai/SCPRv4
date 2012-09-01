class ContentAlarm < ActiveRecord::Base
  self.table_name = "contentbase_contentalarm"
  logs_as_task
  
  #----------
  # Scopes
  default_scope where("content_type is not null")
  scope :pending, -> { where("fire_at <= ? and has_fired = ?", [Time.now, false]) }
  
  #----------
  # Association
  map_content_type_for_django
  belongs_to :content, polymorphic: true
  
  #----------
  # Validation
  validates_presence_of :fire_at, :content_id, :content_type
  validate :is_in_future
  
  def is_in_future
    if !(self.fire_at >= Time.now)
      errors.add(:fire_at, "must be in the future.")
    end
  end
  
  #----------
  # Callbacks
  before_save :set_action
  
  def set_action
    self.action = "publish"
  end
  
  #---------------------
  
  def self.fire_pending
    self.pending.each do |alarm|
      alarm.fire
    end
  end

  #---------------------
  
  def fire
    if self.can_fire?
      ContentAlarm.log(
        "*** [#{Time.now}] Firing ContentAlarm ##{self.id} " \
        "for #{self.content.class.name} ##{self.content.id}")
      
      if self.content.update_attributes(status: ContentBase::STATUS_PUBLISHED)
        self.destroy
      else
        self.update_attribute(:status, "FAILED")
      end
    else
      false
    end
  end
  
  #---------------------
  
  def pending?
    self.fire_at <= Time.now
  end
  
  #---------------------
  
  def can_fire?
    self.pending? and self.content.status == ContentBase::STATUS_PENDING
  end
end
