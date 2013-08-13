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
      self.pending.each(&:fire)
    end
  end


  # Fire an alarm. This is *always* destroy the alarm, whether or not
  # the content was published or not. The idea is that you should be
  # able to call `fire` on any alarm at any time and have it perform its
  # action. If you want to batch-fire only pending alarms, use ::fire_pending.
  def fire
    log "(##{self.id}) Firing Alarm (#{self.content.simple_title})"

    # No matter what, if the content is pending, then we want to
    # destroy this alarm, otherwise it could get stuck forever
    # or maybe publish unexpectedly in the future, which could be
    # dangerous for something like BreakingNewsAlert.
    if self.content.pending?
      log "(##{self.id}) Content is pending... publishing it now. " \
          "(#{self.content.simple_title})"
      self.content.publish
    else
      log "(##{self.id} Content isn't pending. " \
          "(#{self.content.simple_title})\n" \
          "Not publishing, but will still destroy this alarm."
    end

    # This method shouldn't be called unless you're reading to actually
    # fire the alarm, so we should always destroy it at this point.
    self.destroy
  end

  add_transaction_tracer :fire, category: :task


  def pending?
    self.fire_at <= Time.now
  end
end
