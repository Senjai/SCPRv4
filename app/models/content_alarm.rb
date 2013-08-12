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



  class << self
    # Fire any pending alarms
    def fire_pending
      self.pending.each do |alarm|
        alarm.fire
      end
    end
  end


  # Fire an alarm.
  def fire
    if can_fire?
      log "Firing ContentAlarm ##{self.id} for " \
          "#{self.content.simple_title}"

      if self.content.publish
        log "Published #{self.content.simple_title}. " \
            "Removing this alarm."
        self.destroy
      else
        log "Couldn't save #{self.content.simple_title}. " \
            "Will be tried again next time."
        false
      end
    else
      log "Can't fire ContentAlarm ##{self.id} " \
          "for #{self.content.simple_title}."
      false
    end
  end

  add_transaction_tracer :fire, category: :task


  def pending?
    self.fire_at <= Time.now
  end


  private

  # Can fire if this alarm is pending, and if the content is
  # Pending -OR- Published... in the case that it's published,
  # it will just serve to "touch" the content.
  def can_fire?
    self.pending? && self.content.pending?
  end
end
