class ContentAlarm < ActiveRecord::Base
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  self.table_name = "contentbase_contentalarm"
  logs_as_task
  
  #----------
  # Scopes
  scope :pending, -> { where("fire_at <= ?", Time.now).order("fire_at") }
  
  #----------
  # Association
  belongs_to :content, polymorphic: true
  
  #----------
  # Validation
  
  #----------
  # Callbacks

  #---------------------
  
  class << self
    #---------------------
    # Fire any pending alarms
    def fire_pending
      self.pending.each do |alarm|
        alarm.fire
      end
    end
  end

  #---------------------
  # Fire an alarm.
  def fire
    if self.can_fire?
      ContentAlarm.log "Firing ContentAlarm ##{self.id} for #{self.content.simple_title}"
      if self.content.update_attributes(status: ContentBase::STATUS_LIVE)
        ContentAlarm.log "Published #{self.content.simple_title}. Removing this alarm."
        self.destroy
      else
        ContentAlarm.log "Couldn't save #{self.content.simple_title}. Will be tried again."
        false
      end
    else
      ContentAlarm.log "Can't fire ContentAlarm ##{self.id} for #{self.content.simple_title}"
      false
    end
  end
  
  add_transaction_tracer :fire, category: :task
  
  #---------------------
  
  def pending?
    self.fire_at <= Time.now
  end

  #---------------------
  # Can fire if this alarm is pending, and if the content is 
  # Pending -OR- Published... in the case that it's published, 
  # it will just serve to "touch" the content.
  #
  # Note that SCPRv4 destroys content alarms when content moves 
  # from Pending -> Not Pending, so once mercer is gone, there 
  # shouldn't be any alarms with content that ISN'T Pending,
  # so the extra `content.published?` condition can probably
  # go away at that point.
  def can_fire?
    self.pending? && (self.content.pending? || self.content.published?)
  end
end
